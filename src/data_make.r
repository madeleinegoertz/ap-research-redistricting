# This script processes the 2018 VA congressional election precincts file, and
# generates:
# adjlist: list of length precincts of all adjacency precincts
# centroids: list of the geometric means of each precincts
# distancemat: square distances matrix between centroids of precinct
# area: numeric vector of area of each precinct
# centers: 2d list of coordinates (x,y) of precinct centroids
# colors: 11-hexcode vector used to color maps

library(tidyverse)
library(sf)
library(redist)
library(sp)
library(spData)
library(spdep)

df <- st_read("C:/Users/madie/OneDrive/data/pre-redist/VA_precinct_2018_nonan/VA_precinct_2018_nonan.shp")

# convert CON_DIST to integer for initcds
df$CON_DIST <- as.numeric(df$CON_DIST)

adjlist <- redist.adjacency(df)
centroids <- sf::st_centroid(df)
distancemat <- sf::st_distance(centroids, centroids)
area <- sf::st_area(df)
centers <- sf::st_coordinates(centroids)
# add row_n as unique precinct identifier to join on for plots
df$row_n <- seq.int(nrow(df))
# CRSG requires integer population
df$pop_int <- round(df$pop)
colors <- c("#DA618D", "#85D7D4", "#044b62", "#D5D160", "#e7854b", "#6cc32f", "#A87ADA", "#DAB8D3", "#C843DB", "#329349", "#78A5D5")

save.image(file = "src/data.RData")
