################################################################################
##            Mapping Historical Wildfire Incidents Across the US            ##
################################################################################

library(readr)
fire_raw <- read_csv("data/wildfire_incidents.csv")

library(tidyverse)
library(mapview)
library(sf)
library(ggthemes)
library(janitor)

# Copy dataset
fire = fire_raw

# Keep selected columns and remove missing values
fire1 = na.omit(fire[, c(1, 4:8)])
fire1 = clean_names(fire1)

# Extract state code from incident_number
fire1$state  = substr(fire1$incident_number, 1, 2)
fire1$statef = state.name[match(fire1$state, state.abb)]

# Delete incident number
fire1$incident_number = NULL

# Convert date
DD = substr(fire1$initial_source_sit209_record_date, 1, 10)
fire1$date = as.Date(DD, format = "%m/%d/%Y")
View(fire1)

# Extract month
fire1$month = month(fire1$date, label = TRUE)
head(fire1$month)

# Turn state variables into nominal
fire1$state  = factor(fire1$state)
fire1$statef = factor(fire1$statef)

# Delete date column
fire1$initial_source_sit209_record_date = NULL

# Summarize
summary(fire1)

# Make mappable
fire2 = st_as_sf(fire1, coords = c("longitude", "latitude"), crs = 4121)

# Test it
plot(fire2[, "incident_size_acres"], pch = ".")

# Map fires
map1 <- mapview(fire2, zcol = "incident_size_acres", cex = "incident_size_acres", burst = FALSE)
map1
mapshot(map1, file = "wildfire_locations_map.png")  # requires webshot2: install.packages("webshot2")

# Drop hurricanes
fire3 = fire2[!str_detect(fire2$incident_name, pattern = "Hurri"), ]

# Drop non-US (missing state names)
fire3 = na.omit(fire3)

# Map fire3 (final, cleaned map)
map2 <- mapview(fire3, zcol = "incident_size_acres", cex = "incident_size_acres", burst = FALSE)
map2
mapshot(map2, file = "wildfire_locations_map_cleaned.png")

# Bar plot of fires by month
fire3 |> ggplot() +
  geom_bar(aes(month), fill = "#1d5dc4") +
  theme_minimal()
ggsave("wildfires_by_month.png", width = 7, height = 6, dpi = 300)

# Bar plot of fires by state (>= 10,000 acres)
fire3 |> filter(incident_size_acres >= 10000) |> ggplot() +
  geom_bar(aes(statef), fill = "#68ad1a") +
  labs(y = "Number of fires",
       x = "States with at least one fire that burned 10K acres or more") +
  coord_flip() +
  theme_minimal()
ggsave("wildfires_states_over_10k_acres.png", width = 7, height = 8, dpi = 300)

# Bar plot of each state's largest fire (> 30,000 acres)
fire3 |>
  filter(incident_size_acres > 30000) |>
  group_by(state) |>
  mutate(BigFire = max(incident_size_acres)) |>
  ggplot() +
  geom_bar(aes(x = state, y = (BigFire / 1000)), stat = "identity", fill = "#ad1a24") +
  labs(y = "Acres burned (in thousands)", x = "Each State's Largest Fires") +
  theme_economist()
ggsave("wildfires_largest_per_state.png", width = 9, height = 6, dpi = 300)

# Histogram of acres burned (log base 2)
fire3 |>
  ggplot() +
  geom_histogram(aes(incident_size_acres), fill = "#f89b57", color = "lightblue") +
  scale_x_continuous(trans = 'log2') +
  labs(x = "number of acres burned", y = "number of fires") +
  theme_calc()
ggsave("wildfires_acres_burned_distribution.png", width = 7, height = 6, dpi = 300)
