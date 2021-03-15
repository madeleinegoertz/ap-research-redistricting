# This script runs the crsg algorithm and saves the output in this format.
# crsg.out is a named list, with 
# df, the precinct shapefile used in redistricting
# partitions, a n precincts x 10 matrix where each col is a map.

library(tidyverse)
library(sf)
library(redist)
library(sp)
library(spData)
library(spdep)

load("results/data.RData")

nsims <- 10
crsg <- vector(mode = "list", length = nsims)
for (i in 1:nsims) {
  crsg[[i]] <- 
    redist.crsg(adj.list = adjlist, 
      area = area, 
      population = df$pop, 
      x_center = centers[,1], 
      y_center = centers[,2], 
      ndists = 11, 
      thresh = .01)
}

partitions <- matrix(c(crsg[[1]]$district_membership),
               nrow=length(crsg[[1]]$district_membership))
for (i in 2:length(crsg)) { # already included col 1
  partitions <- cbind(partitions,crsg[[i]]$district_membership)
}

crsg.out <- list(df = df, partitions = partitions)

save(crsg.out, file = "results/crsg.RData")
