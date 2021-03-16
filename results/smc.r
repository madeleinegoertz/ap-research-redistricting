# This script runs smc
# The final redistricting results are in smc.out$cdvec

library(redist)

load("results/data.RData")


smc.out <- redist.smc(
  adjobj = adjlist,
  popvec = df$pop,
  ndists = 11,
  nsims = 10,
  popcons = 0.01
)

save(smc.out, file = "results/smc.RData")