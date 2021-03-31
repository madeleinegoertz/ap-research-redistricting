# This script makes the pretty maps for my results section.

library(dplyr)
library(ggplot2)
library(purrr)
library(sf)
library(patchwork)

load("data/data.RData")
load("data/smc.RData")
load("data/crsg.RData")
load("data/fair.calc.100.RData") # for picking a map
load("data/raw.fair.100.RData") # for getting DVS

df$CON_DIST <- as.numeric(df$CON_DIST)

pop_vote <- sum(df$G18HORDEM) / (sum(df$G18HORDEM) + sum(df$G18HORREP))

plot_election <- function(fair, raw, maps, alg, savename = NULL) {
  map <- which.min(abs(fair$bias))
  # extract the dvs vector for that map
  dvs <-
    raw %>%
    filter(nloop == map) %>%
    select(districts, DVS) %>%
    rename(CON_DIST = districts) %>%
    mutate(CON_DIST = CON_DIST + 1) # 1 - indexed districts

  # extract congressional districts from alg output
  plan <-
    maps[, map] %>%
    as_tibble() %>%
    rename(CON_DIST = value) %>%
    mutate(
      row_n = row_number(),
      CON_DIST = CON_DIST + 1
    )

  # create merged plotting data frame
  df_elect <-
    # Merge in congressional district from maps
    data.frame(df) %>%
    select(LOCALITY, PRECINCT, geometry) %>%
    mutate(row_n = row_number()) %>%
    inner_join(plan, by = c("row_n")) %>%
    select(-row_n) %>%
    # Merge in DVS
    inner_join(dvs, by = c("CON_DIST")) %>%
    rename(dvs_dist = DVS) %>%
    # specify that it's for the dist, not precinct
    # add geo stuff
    mutate(
      centroid = st_centroid(geometry), 
      lon = map_dbl(centroid, 1), 
      lat = map_dbl(centroid, 2)
    ) %>%
    st_as_sf() %>%
    # make district-level sf file
    group_by(CON_DIST) %>%
    summarize(geometry = st_union(geometry)) %>%
    ungroup() %>%
    inner_join(dvs, by = c("CON_DIST")) %>%
    mutate(
      centroid = st_centroid(geometry),
      lon = map_dbl(centroid, 1),
      lat = map_dbl(centroid, 2)
    )

  df_elect %>%
    ggplot() +
    geom_sf(size = .1, aes(fill = DVS), color = "black") +
    geom_label(
      size = 2.5,
      aes(lon, lat, label = scales::percent(DVS, accuracy = 1))
    ) +
    scale_fill_gradientn(
      colors = c("#FF0000", "#bfbfbf", "#0000FF"),
      limits = c(0, 1),
      values = scales::rescale(c(0, 0.45, 0.5, 0.55, 1)),
      labels = scales::percent_format(accuracy = 1)
    ) +
    theme_void() +
    labs(
      title = paste("Election under Fairest", alg, "District"),
      subtitle = paste("Compared to", scales::percent(pop_vote, accuracy = .1), "popular DVS"),
      fill = "DVS",
      caption = paste0(sum(df_elect$DVS > 0.5), "/11 Democratic Seats")
    )
}

smc <- plot_election(
  fair = calc.fair$smc,
  raw = raw.fair$smc,
  maps = smc.out$cdvec,
  alg = "SMC",
  #savename = "elec.smc"
)

crsg <- plot_election(
  fair = calc.fair$crsg,
  raw = raw.fair$crsg,
  maps = crsg.out$partitions,
  alg = "CRSG",
  #savename = "elec.mcmc"
)

control <- plot_election(
  fair = calc.fair$control,
  raw = raw.fair$control,
  maps = as_tibble(df$CON_DIST),
  alg = "Control",
  #savename = "elec.control"
)

p <-
  (smc) / 
  (crsg) / 
  (control)

ggsave("paper/img/election.map.png", p, units = "in", width = 6.5, height = 9.75)
