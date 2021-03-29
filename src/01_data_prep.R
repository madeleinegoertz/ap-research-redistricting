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

# unzip zip file that has the shapefiles in into temp directory
unzip("shp/va_ushouse_2018_precincts_race.zip", exdir="shp/va_ushouse_2018_precincts_race")
# read in the shapefile
df <- st_read("shp/va_ushouse_2018_precincts_race/va_ushouse_2018_precincts_race.shp")
# delete the extracted files. 
unlink("shp/va_ushouse_2018_precincts_race", recursive=TRUE)

# convert CON_DIST to integer for initcds
df$CON_DIST <- as.numeric(df$CON_DIST)

# add row_n as unique precinct identifier to join on for plots
df$row_n <- seq.int(nrow(df))

# set up the redistricting problem
va_map <- redist_map(df, existing_plan=CON_DIST, pop_tol=0.01)

colors <- c("#DA618D", "#85D7D4", "#044b62", "#D5D160", "#e7854b", "#6cc32f", "#A87ADA", "#DAB8D3", "#C843DB", "#329349", "#78A5D5")

save(va_map, colors, file = "data/data_race.RData")
