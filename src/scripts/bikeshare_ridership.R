################################################################################
##                Seasonal Bike-Share Ridership Modeling                      ##
################################################################################

library(tidyverse)
library(GGally)
library(easystats)
library(jtools)
library(boot.pval)

# 'day' is the daily bike-share dataset (Capital Bikeshare "day.csv")
Day = day[, c(2, 3, 8, 10, 12, 13, 16)]

Day1 = Day |> mutate(Season = case_when(season == 1 ~ "Winter",
                                         season == 2 ~ "Spring",
                                         season == 3 ~ "Summer",
                                         TRUE ~ "Fall"))

Day1$WorkDay = ifelse(Day1$workingday == 1, "Yes", "No")

Day1$season     <- NULL
Day1$workingday <- NULL
Day1$dteday     <- NULL

Day1$Season  = as.factor(Day1$Season)
Day1$WorkDay = as.factor(Day1$WorkDay)
Day1 = rename(Day1, Riders = cnt)

summary(Day1)

# Initial model, without exploring the data first
Model1 = lm(Riders ~ ., data = Day1)
summ(Model1)
plot(parameters(Model1))
check_model(Model1)

# EDA
ggplot(Day1, aes(Riders)) + geom_histogram(fill = "darkblue") + theme_light()

ggplot(Day1, aes(Riders, Season)) +
  geom_boxplot(notch = TRUE, fill = "darkred") + theme_light()
ggsave("ridership_by_season.png", width = 7, height = 5, dpi = 300)

ggplot(Day1, aes(Riders, WorkDay)) +
  geom_boxplot(notch = TRUE, fill = "darkgreen") + theme_light()

# Notch = confidence interval around the median; non-overlapping notches
# are strong evidence the group medians differ.
# Finding #1: Winter ridership looks very different from the other seasons.
# Finding #2: No apparent relationship between ridership and WorkDay.

ggpairs(Day1[, -1], legend = 1, columns = 1:4, aes(color = Season)) +
  theme(legend.position = "bottom")

ggplot(Day1, aes(Riders, temp, color = Season)) +
  geom_point() +
  geom_smooth(method = lm, se = FALSE) + theme_light()
ggsave("ridership_vs_temp_by_season.png", width = 8, height = 6, dpi = 300)

# Ridership rises with temperature in every season except Summer,
# suggesting Summer needs its own model.

# Summer model
Summer = Day1 |>
  filter(Season == "Summer") |>
  dplyr::select(-WorkDay)
Summer$Season <- NULL

ModelS = lm(Riders ~ ., data = Summer)
summ(ModelS, digits = 4)
plot(parameters(ModelS))
check_model(ModelS)

# Residuals for the Summer model aren't normally distributed, so bootstrap
# for more trustworthy p-values instead of relying on standard errors.
boot_summary(ModelS, R = 10000, adjust.method = "holm")

# Winter/Spring/Fall model
WSF = Day1 |>
  filter(Season != "Summer") |>
  dplyr::select(-WorkDay)
WSF$Season = as.factor(WSF$Season)

ModelWSF = lm(Riders ~ ., data = WSF)
summ(ModelWSF, digits = 4)
plot(parameters(ModelWSF))
check_model(ModelWSF)
