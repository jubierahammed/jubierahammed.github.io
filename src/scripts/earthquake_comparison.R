################################################################################
##    Comparing Earthquake Activity Across California, Nevada, and Alaska     ##
################################################################################

library(readr)
all_month <- read_csv("data/all_month.csv")  # USGS 30-day earthquake feed

library(tidyverse)
library(tmap)
library(tmaptools)
library(forcats)
library(wordcloud)
library(sf)
library(lsr)
library(tidycensus)

EQ = all_month |> select(1:6, 14)

# Convert time to Date
EQ$Date = substr(EQ$time, 1, 10)
EQ$Date = as.Date(EQ$Date, format = "%Y-%m-%d")
EQ$time <- NULL

EQ$magType = tolower(EQ$magType)
EQ$magType = as.factor(EQ$magType)

# Extract state/region from the place field
loc1 = str_split(EQ$place, ",", simplify = TRUE)
loc1 = as.data.frame(loc1)
loc1$V2 = trimws(loc1$V2)
loc1$V2[loc1$V2 == "Aleutian Islands"] <- "Alaska"
loc1$V2[loc1$V2 == "CA"]               <- "California"

EQ$location = loc1$V2
EQ$place    <- NULL
EQ$location = as.factor(EQ$location)

EQ = EQ |> filter(EQ$mag > 0)

# Magnitude histogram
ggplot(EQ, aes(x = mag)) +
  geom_histogram(col = "#af33ff", fill = "#af33ff") +
  scale_x_continuous(breaks = seq(from = 0, to = 7, by = 0.5)) +
  labs(title = "Earthquake Magnitudes for the past 30 days", x = "magnitude", y = "Number") +
  theme_light()

# Average magnitude over time
D30 = aggregate(mag ~ Date, data = EQ, mean)
ggplot(data = D30, aes(x = Date, y = mag)) +
  geom_line() + geom_point() +
  labs(title = "Average Earthquake Activity over the past 30 days", y = "magnitude") +
  theme_light()

# Locations with the highest average magnitude
PMag = aggregate(mag ~ location, data = EQ, mean)
GT47 = PMag[PMag$mag > 4.7, ]

ggplot(data = GT47, aes(x = fct_reorder(location, mag), y = mag)) +
  geom_bar(stat = "identity", color = "#c3831a", fill = "#c3831a") +
  labs(title = "Locations with the most Intense Earthquake Activity \n over the past 30 days",
       x = "locations", y = "magnitude") +
  coord_flip() + theme_light()

# Frequency by location (word cloud)
LocFreq = data.frame(table(EQ$location))
wordcloud(LocFreq$Var1, LocFreq$Freq, scale = c(3, 1), min.freq = 5)

# California vs Nevada vs Alaska comparison
CNA = EQ |> filter(location %in% c("California", "Nevada", "Alaska"))
ggplot(CNA, aes(x = location, y = mag, color = location)) +
  geom_boxplot(outlier.shape = NA) + geom_jitter(alpha = 0.10) +
  labs(x = "locations", y = "magnitude") + theme_light()
ggsave("earthquake_magnitude_comparison.png", width = 7, height = 6, dpi = 300)

# Spatial mapping: California and Nevada
CN = EQ[EQ$location %in% c("California", "Nevada"), ]
CNSf = st_as_sf(CN, coords = c("longitude", "latitude"))
st_crs(CNSf) <- 4326
CNSf = rename(CNSf, magnitude = mag)

data(state_laea)
state_laea <- st_as_sf(state_laea)
state_laea <- st_transform(state_laea, crs = 4326)

statesCN = state_laea |> filter(GEOID %in% c("06", "32"))

EQMap <- tm_shape(statesCN) +
  tm_polygons(fill = "#f2fbd2", col = "grey60") +
  tm_shape(CNSf) +
  tm_symbols(size = "magnitude", fill_alpha = 0.55, fill = "#f6812f",
             col = "#c4611b", lwd = 1,
             size.scale = tm_scale(values.scale = 1.15))
EQMap
tmap_save(EQMap, "earthquake_ca_nv_map.png")

# Statistical comparison: California vs Nevada
t.test(CN$mag ~ factor(CN$location))
cohensD(CN$mag ~ factor(CN$location))

# California vs Alaska
CA_AK = EQ[EQ$location %in% c("California", "Alaska"), ]
t.test(CA_AK$mag ~ factor(CA_AK$location))
cohensD(CA_AK$mag ~ factor(CA_AK$location))
