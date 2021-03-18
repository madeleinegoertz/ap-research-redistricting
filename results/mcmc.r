# This script redistricts using mcmc. Output stored in results/mcmc.RData
# maps in mcmc.out$partitions.

library(redist)

load("results/data.RData")

#use results from CRSG to generate starting values
load("results/crsg.RData")

mcmc.out <- redist.mcmc(adjobj = adjlist,
                        popvec = df$pop,
                        #ndists = 11,
                        initcds = crsg.out$partitions[,1],
                        #nsims = 10,
                        nsims = 10001,
                        constraint = c("population", "compact"),
                        constraintweights = c(1, 1),
                        popcons = .01,
                        ssdmat = distancemat)
#save(mcmc.out, file = "results/mcmc.RData")
save(mcmc.out, file = "results/mcmc.10000.RData")