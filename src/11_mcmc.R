# This script redistricts using mcmc. Output stored in src/mcmc.RData
# maps in mcmc.out$partitions.

library(redist)

load("data/data.RData")

#use results from CRSG to generate starting values
load("data/crsg.RData")

mcmc.out <- redist.mcmc(adjobj = adjlist,
                        popvec = df$pop,
                        initcds = crsg.out$partitions[,1],
                        nsims = 101,
                        constraint = c("population", "compact"),
                        constraintweights = c(1, 1),
                        popcons = .01,
                        ssdmat = distancemat)
save(mcmc.out, file = "data/mcmc.RData")