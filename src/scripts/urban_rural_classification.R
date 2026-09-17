################################################################################
##       Classifying Urban and Rural Census Tracts in Texas                   ##
##              via Logistic Regression                                       ##
################################################################################

library(tidyverse)
library(easystats)
library(caret)
library(rcompanion)
library(janitor)
library(GGally)
library(psych)
library(tigris)
library(sf)
library(mapview)
library(ROCit)
library(jtools)

# Load and clean five separate Census extracts (Decennial + ACS 5-year)
RuralUrban = janitor::clean_names(DecennialDHC2020_H2)
EduAtt     = janitor::clean_names(EduAttACS5Y2023_B15003)
MedAge     = janitor::clean_names(MedAgeACS5Y2020_B01002)
MedHHInc   = janitor::clean_names(MedHHincACS5Y2023_B19013)
TTtoWork   = janitor::clean_names(TTwACS5Y2023_B08303)

# Merge all five datasets by GEOID
Combo = RuralUrban |>
  left_join(EduAtt, by = 'geo_id') |>
  left_join(MedAge, by = 'geo_id') |>
  left_join(MedHHInc, by = 'geo_id') |>
  left_join(TTtoWork, by = 'geo_id')

##### Data Processing ######
# Drop margin-of-error columns
RurUrbTex0 = Combo |> select(!contains("margin"))

# Convert key variables to numeric
RurUrbTex0 = RurUrbTex0 |>
  mutate(across(median_age:lt_25minute_commute_to_work, as.numeric))

# Create percent-with-college-degree variable
RurUrbTex0 = RurUrbTex0 |>
  mutate(PctColDeg = rowSums(across(estimate_total_associates_degree:estimate_total_doctorate_degree)) /
           estimate_total * 100)
RurUrbTex0$PctColDeg = round(RurUrbTex0$PctColDeg, 2)

# Define Urban (urban pop >= rural pop) as a binary outcome
RurUrbTex0 = RurUrbTex0 |> mutate(U = (urban >= rural))
RurUrbTex0$Urban = factor(as.numeric(RurUrbTex0$U),
                           levels = c(1, 0),
                           labels = c("Urban", "Rural"))

RurUrbTex1 = RurUrbTex0[, c(1:3, 32:37)]
RurUrbTex1 = RurUrbTex1 |> rename(Pct0_25MsToWork = lt_25minute_commute_to_work)

# Descriptive statistics by group
summary(RurUrbTex1)
describeBy(RurUrbTex1[, 4:7], group = RurUrbTex1$Urban)

ggpairs(RurUrbTex1,
        columns = 4:7,
        aes(color = Urban, alpha = 0.5))

# Merge with Texas census tract boundaries
TxTract <- tracts("TX", cb = TRUE)
RurUrbTex1$geo_id = as.character(RurUrbTex1$geo_id)
RurUrbTex2 = merge(TxTract, RurUrbTex1, by.x = "GEOID", by.y = "geo_id")

# Map variables across Texas
UrbanMap <- mapview(RurUrbTex2, zcol = "Urban")
UrbanMap
mapshot(UrbanMap, file = "urban_rural_texas_map.png")  # requires webshot2: install.packages("webshot2")

mapview(RurUrbTex2, zcol = "median_age")
mapview(RurUrbTex2, zcol = "median_household_income")
mapview(RurUrbTex2, zcol = "Pct0_25MsToWork")
mapview(RurUrbTex2, zcol = "PctColDeg")

####### Modeling ########

# Logistic regression: predicting Urban vs Rural
UorR = glm(U ~ median_age + median_household_income +
             Pct0_25MsToWork + PctColDeg,
           data = RurUrbTex2, family = binomial("logit"))

summ(UorR, confint = TRUE, digits = 5)
summ(UorR, confint = TRUE, exp = TRUE, digits = 5)  # exponentiated coefficients

countRSquare(UorR)  # accuracy measure
plot(parameters(UorR))
check_model(UorR)

# Predicted probabilities at the default 0.50 cutoff
probabilites = predict(UorR, type = "response")
Esti_CityCountry = ifelse(probabilites >= 0.50, "Urban", "Rural")

RurUrbTex3 = na.omit(RurUrbTex2)
confusionMatrix(factor(as.character(RurUrbTex3$Urban)),
                factor(Esti_CityCountry), positive = "Urban")

# Find a better classification cutoff using ROC / KS statistic
rocit <- rocit(score = UorR$fitted.values, class = UorR$y)
kplot <- ksplot(rocit)
message("KS Stat (empirical) : ", kplot$`KS stat`)
message("KS Stat (empirical) cutoff : ", kplot$`KS Cutoff`)

# Re-classify using the optimized cutoff
Esti_CityCountry = ifelse(probabilites >= 0.79, "Urban", "Rural")
confusionMatrix(factor(as.character(RurUrbTex3$Urban)),
                factor(Esti_CityCountry), positive = "Urban")

# Identify and map correctly vs. incorrectly classified tracts
RightWrong = data.frame(Actural = as.character(RurUrbTex3$Urban),
                         Predicted = Esti_CityCountry)

RurUrbTex3$choice =
  with(RightWrong, 1 * (Actural == "Urban" & Predicted == "Rural") +
         2 * (Actural == "Rural" & Predicted == "Urban"))

RurUrbTex3$choice = factor(RurUrbTex3$choice,
                            levels = c(0, 1, 2),
                            labels = c("correct", "Rural_when_Urban", "Urban_when_Rural"))

ChoiceMap <- mapview(RurUrbTex3, zcol = "choice")
ChoiceMap
mapshot(ChoiceMap, file = "urban_rural_classification_accuracy.png")
