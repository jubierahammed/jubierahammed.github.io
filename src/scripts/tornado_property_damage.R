################################################################################
##         Modeling Tornado Property Damage Using Storm Events                ##
##                    and County Demographics                                 ##
################################################################################

library(tidyverse)
library(jtools)
library(janitor)
library(GGally)
library(easystats)
library(arm)
library(sf)
library(tidycensus)
library(scales)
library(units)

# NOAA Storm Events data (tornado records)
Storm0 <- StormEvents_details  # loaded from NOAA Storm Events dataset

# Keep only tornado observations and selected variables
Storm1 <- Storm0 %>%
  filter(EVENT_TYPE == "Tornado") %>%
  dplyr::select(STATE, STATE_FIPS, CZ_FIPS, CZ_NAME, DEATHS_DIRECT, DEATHS_INDIRECT,
                DAMAGE_PROPERTY, TOR_F_SCALE, TOR_LENGTH, TOR_WIDTH)

# Drop missing values
Storm1 <- na.omit(Storm1)

# Turn DAMAGE_PROPERTY into a number (handles "K" and "M" suffixes)
DP <- parse_number(Storm1$DAMAGE_PROPERTY)
K <- str_ends(Storm1$DAMAGE_PROPERTY, "K")
Storm1$PropDam <- ifelse(K == TRUE, DP * 1000, DP * 1000000)

# Convert to factors
Storm1$STATE       = factor(Storm1$STATE)
Storm1$CZ_NAME     = factor(Storm1$CZ_NAME)
Storm1$TOR_F_SCALE = factor(Storm1$TOR_F_SCALE)

# Drop unknown-intensity tornadoes (EFU)
Storm2 <- Storm1 %>% dplyr::filter(TOR_F_SCALE != "EFU")
Storm2$TOR_F_SCALE <- factor(Storm2$TOR_F_SCALE)

# Explore distributions
ggplot(Storm2, aes(x = TOR_LENGTH)) + geom_histogram() + theme_bw()
ggplot(Storm2, aes(x = TOR_WIDTH)) + geom_histogram() + theme_bw()
ggplot(Storm2, aes(x = PropDam)) + geom_histogram() + theme_bw()

ggplot(Storm2, aes(x = TOR_F_SCALE, y = PropDam)) +
  geom_boxplot() +
  geom_jitter() +
  labs(y = "Property Damage", x = "Enhanced Fujita Scale") +
  scale_y_continuous(labels = scales::dollar) +
  theme_bw()
ggsave("tornado_damage_by_scale.png", width = 8, height = 6, dpi = 300)

# Set Census API key (stored as an environment variable, not hard-coded)
census_api_key(Sys.getenv("CENSUS_API_KEY"), install = TRUE, overwrite = TRUE)

# Download county-level ACS variables + geometry
US_Counties <- get_acs(
  geography = "county",
  variables = c("B01003_001", "B25107_001", "B01002_001", "B19019_001"),
  year      = 2019,
  geometry  = TRUE,
  survey    = "acs5"
)

US_Counties$variable <- factor(US_Counties$variable)
US_Counties$variable <- fct_recode(US_Counties$variable,
                                    MedHHInc   = "B19019_001",
                                    MedHomeVal = "B25107_001",
                                    MedAge     = "B01002_001",
                                    TotPop     = "B01003_001"
)

# Reshape to wide format and summarize
USData <- st_drop_geometry(US_Counties)
USDataWide <- USData %>%
  pivot_wider(names_from = variable, values_from = estimate) %>%
  dplyr::select(GEOID, NAME, MedAge, MedHHInc, MedHomeVal, TotPop) %>%
  group_by(GEOID, NAME) %>%
  summarise(
    MeanAge     = mean(MedAge,     na.rm = TRUE),
    MeanHHInc   = mean(MedHHInc,   na.rm = TRUE),
    MeanHomeVal = mean(MedHomeVal, na.rm = TRUE),
    MeanTotPop  = mean(TotPop,     na.rm = TRUE)
  )

# Merge with county boundaries
US_C <- US_Counties[US_Counties$variable == "MedAge", ]
USCnty <- merge(US_C[, c(1, 6)], USDataWide, by = "GEOID")

# Calculate population density
USCnty$KMsqr  <- set_units(st_area(USCnty$geometry), km^2)
USCnty$PopDen <- round(USCnty$MeanTotPop / USCnty$KMsqr, 1)

# Build GEOID for Storm2 to enable the join
state <- str_pad(Storm2$STATE_FIPS, 2, side = "left", pad = "0")
cty   <- str_pad(Storm2$CZ_FIPS, 3, side = "left", pad = "0")
Storm2$GEOID <- paste0(state, cty)

# Join tornado records to county demographic data
Storm3 <- Storm2 %>% dplyr::filter(PropDam > 0)
Winds0 <- left_join(Storm3, USCnty, by = "GEOID")

# Select and log-transform (heavily skewed) variables
Winds1 <- Winds0 %>%
  dplyr::select(PropDam, TOR_LENGTH, TOR_WIDTH, MeanHomeVal, PopDen)

Winds2 <- Winds1 %>% mutate(across(PropDam:PopDen, log))
ggpairs(Winds2)

# Regression model
Out <- lm(PropDam ~ ., data = Winds2)
summ(Out, confint = TRUE, digits = 4)
plot(parameters(Out))
ggsave("tornado_regression_coefficients.png", width = 7, height = 6, dpi = 300)
check_model(Out)
