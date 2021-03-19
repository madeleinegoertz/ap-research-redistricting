# This script runs smc
# The final redistricting results are in smc.out$cdvec

library(redist)

load("results/data.RData")

start.time <- Sys.time()
smc.out <- redist.smc(
  adjobj = adjlist,
  popvec = df$pop,
  ndists = 11,
 # nsims = 10,
  nsims = 1000,
  popcons = 0.01
)
end.time <- Sys.time()
print(end.time - start.time)

#save(smc.out, file = "results/smc.RData")
save(smc.out, file = "results/smc.1000.RData")