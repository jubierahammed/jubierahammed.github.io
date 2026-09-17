################################################################################
##     Modeling Dallas Airbnb Prices and Mapping Where the Model Fails        ##
################################################################################

library(readr)
listings <- read_csv("data/listings.csv")

library(tidyverse)
library(easystats)
library(jtools)
library(arm)
library(broom)
library(broom.helpers)
library(GGally)
library(summarytools)
library(tmap)
library(tmaptools)
library(dlookr)
library(sf)

col = c(19, 22, 31, 32, 34, 37, 38, 41, 57, 71, 72, 79)
DalAir0 = listings[, col]

DalAir0 = rename(DalAir0,
                  Superhost        = host_is_superhost,
                  Neighborhood     = host_neighbourhood,
                  Location_ratings = review_scores_location,
                  Guest_ratings    = review_scores_value)

DalAir0 = na.omit(DalAir0)

# Clean price and bathroom fields
DalAir0$price = parse_number(DalAir0$price)

TF = (str_detect(DalAir0$bathrooms_text, "Shared|shared|Half|half"))
DalAir0 = DalAir0 |>
  mutate(Baths = ifelse(TF == TRUE, 0.5, parse_number(bathrooms_text)))
DalAir0$bathrooms_text <- NULL

DalAir0 <- DalAir0 |> mutate(across(where(is.character), as.factor))

# Filter to entire-home listings under $500, reasonable bed/bath counts
DalAir1 = DalAir0 |>
  filter(room_type == "Entire home/apt",
         price     < 500,
         bedrooms  < 5,
         Baths     < 5)
DalAir1$room_type <- NULL

descr(DalAir1) |> round(2) |> View()
freq(DalAir1$Neighborhood) |> round(2) |> View()

# Keep the neighborhoods with sufficient listings
N = c("Old East Dallas", "Oak Cliff", "Oak Lawn", "Far North Dallas",
      "Dallas Downtown Historic District", "Lower Greenville",
      "West Dallas", "Cedar Crest", "Northwest Dallas", "South Dallas",
      "Kessler", "Lake Highlands", "Northeast Dallas", "Cedars",
      "Bishop Arts District")
DalAir2 = DalAir1 |> filter(Neighborhood %in% N)
DalAir2$Neighborhood = factor(DalAir2$Neighborhood)
DalAir2$Superhost    = factor(DalAir2$Superhost)

######################### EDA ##################################

descr(DalAir2) |> round(2) |> View()

DalAirMap = DalAir2[, c(3, 4, 6)]
DalAirMap <- st_as_sf(DalAirMap, coords = c("longitude", "latitude"), crs = 4326)

# Map raw price
tmap_mode("view")
tm_layout() +
  tm_shape(DalAirMap) +
  tm_dots("price", size = .75,
          fill.scale = tm_scale_intervals(style = "fisher", n = 5,
                                           values = "brewer.or_rd"))

ggpairs(DalAir2, columns = c("price", "Guest_ratings", "Location_ratings",
                              "bedrooms", "Baths", "reviews_per_month"))

# Log-transform price to correct skew
DalAir2 |> normality(price)
DalAir2$LOGprice = log(DalAir2$price)
DalAir2 |> plot_normality(LOGprice)

ggpairs(DalAir2, columns = c("LOGprice", "Guest_ratings", "Location_ratings",
                              "bedrooms", "Baths", "reviews_per_month"))

# Price by neighborhood
ggplot(DalAir2, aes(y = price, x = fct_reorder(Neighborhood, price))) +
  geom_boxplot(fill = "#1abc9c") +
  coord_flip() +
  scale_y_log10() +
  theme_apa() +
  labs(x = "Neighborhoods")
ggsave("airbnb_price_by_neighborhood.png", width = 8, height = 7, dpi = 300)

DalAir2 |>
  group_by(Neighborhood) |>
  summarise(MeanPrice = mean(price), MedianPrice = median(price))

DalAir2 |>
  group_by(Superhost) |>
  summarise(MeanPrice = mean(price), MedianPrice = median(price))

######################### Modeling ################################

A_Model = lm(LOGprice ~ Superhost + Guest_ratings + Location_ratings +
               bedrooms + reviews_per_month, data = DalAir2)

summ(A_Model, confint = TRUE)
A_Model |> ggcoef_model()
check_model(A_Model)

standardize(A_Model)                            # standardized coefficients
effectsize::eta_squared(A_Model, partial = FALSE) # effect size

# Get model predictions and residuals
Model_stuff = augment(A_Model)

# Map standardized residuals to see where the model over/under-predicts
DalAirMap$ResStdz = Model_stuff$.std.resid

tmap_mode("view")
ResidMap <- tm_layout() +
  tm_shape(DalAirMap) +
  tm_dots("ResStdz", size = .75,
          fill.scale = tm_scale_intervals(style = "fixed",
                                           breaks = c(-3, -2, -1, 0, 1, 2, 3),
                                           values = "RdGy"),
          fill.legend = tm_legend(title = "Std. Resid. prices"))
ResidMap
tmap_save(ResidMap, "airbnb_residuals_map.png")

# Aggregate residual performance by neighborhood
NeighStdResid = data.frame(Hood = DalAir2$Neighborhood,
                            Std_Residuals = Model_stuff$.std.resid)

NeighStdResid |>
  group_by(Hood) |>
  summarise(sum(Std_Residuals)) |>
  View()
