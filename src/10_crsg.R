# This script runs the crsg algorithm and saves the output in this format.
# crsg.out is a named list, with 
# partitions, a n precincts x 100 matrix where each col is a map.

library(redist)

load("data/data.RData")

nsims <- 100
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

crsg.out <- list(partitions = partitions)

save(crsg.out, file = "data/crsg.RData")