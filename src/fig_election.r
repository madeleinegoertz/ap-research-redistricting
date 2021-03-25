# This script makes the pretty maps for my results section. 

library(tidyverse)
library(sf)

load("src/data.RData")
load("src/mcmc.RData")
load("src/smc.RData")
load("src/fair.calc.RData") # for picking a map
load("src/fair.raw.RData") # for getting DVS

# choose MCMC map with the min abs value bias score. 
map <- which.min(abs(calc.fair$mcmc$bias))

# extract the dvs vector for that map
dvs <-
  raw.fair$mcmc %>%
  filter(nloop == map) %>%
  select(districts, DVS) %>%
  rename(CON_DIST = districts)
dvs$CON_DIST <- dvs$CON_DIST + 1 # adjust to match what's in df

# extract congressional districts from MCMC
mcmc_map <-
  mcmc.out$partitions[,map] %>%
  as_tibble() %>%
  rename(CON_DIST = value) %>%
  mutate(row_n = row_number(), CON_DIST = CON_DIST + 1)

# calc topline results
at_large <- 
  (sum(df$G18HORDEM) - sum(df$G18HORREP)) / 
  (sum(df$G18HORDEM) + sum(df$G18HORREP))

# create merged plotting data frame
df_elect <-
  # Merge in congressional district from MCMC partitions
  data.frame(df) %>%
  select(LOCALITY, PRECINCT, geometry) %>%
  mutate(row_n = row_number()) %>%
  inner_join(mcmc_map, by = c("row_n")) %>%
  select(-row_n) %>%
  # Merge in DVS
  inner_join(dvs, by = c("CON_DIST")) %>%
  rename(dvs_dist = DVS) %>% # specify that it's for the dist, not precinct
  # add geo stuff
  mutate(centroid = st_centroid(geometry), lon = map_dbl(centroid, 1), lat = map_dbl(centroid, 2)) %>% 
  st_as_sf()

df_plot <-
  df_elect %>%
  ggplot(aes(fill = dvs_dist)) + 
    geom_sf(size = .1, color=NA) +
    #geom_label(aes(lon, lat, label = scales::percent(dvs_dist))) + 
    scale_fill_gradientn(
      colors = c("#FF0000", "#f2e5f2", "#000080"),
      limits = c(0, 1)
      #values = scales::rescale(c(0, 0.45, 0.5, 0.55, 1))
      # labels = scales::percent_format(accuracy = 1)
    ) +
    theme_void() + 
    labs(
      title = "2018 Virginia Congressional Election under Fairest MCMC District",
      subtitle = paste("Compared to", scales::percent(mean(df_elect$dvs_dist), accuracy = .1), "DVS at-large"),
      fill = "DVS",
      caption=""
    )
