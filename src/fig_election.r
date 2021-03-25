# This script makes the pretty maps for my results section. 

library(tidyverse)
library(sf)

load("src/data.RData")
load("src/mcmc.RData")
load("src/smc.RData")
load("src/fair.calc.RData") # for picking a map
load("src/fair.raw.RData") # for getting DVS

plot_election <- function(fair, raw, maps, alg, savename=NULL) {
  map <- which.min(abs(fair$bias))
  # extract the dvs vector for that map
  dvs <-
    raw %>%
    filter(nloop == map) %>%
    select(districts, DVS) %>%
    rename(CON_DIST = districts) %>%
    mutate(CON_DIST = CON_DIST + 1) #1 - indexed districts
  
  # extract congressional districts from alg output
  plan <-
    maps[,map] %>%
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
    rename(dvs_dist = DVS) %>% # specify that it's for the dist, not precinct
    # add geo stuff
    mutate(centroid = st_centroid(geometry), lon = map_dbl(centroid, 1), lat = map_dbl(centroid, 2)) %>% 
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
  df_plot <-
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
        title = paste("2018 Virginia Congressional Election under Fairest", alg, "District"),
        subtitle = paste("Compared to", scales::percent(mean(df_elect$DVS), accuracy = .1), "DVS at-large"),
        fill = "DVS",
        caption=paste0(sum(df_elect$DVS > 0.5), "/11 Democratic Seats")
      )
  if(!is.null(savename))
    ggsave(paste0("paper/img/",savename,".png"))
}

mcmc <- plot_election(
  fair = calc.fair$mcmc,
  raw = raw.fair$mcmc,
  maps = mcmc.out$partitions,
  alg = "MCMC",
  savename = "elec.mcmc"
)

smc <- plot_election(
  fair = calc.fair$smc,
  raw = raw.fair$smc,
  maps = smc.out$cdvec,
  alg = "SMC",
  savename = "elec.smc"
)

control <- plot_election(
  fair = calc.fair$control,
  raw = raw.fair$control,
  maps = as_tibble(df$CON_DIST),
  alg = "Control",
  savename = "elec.control"
)