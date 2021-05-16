# This script runs smc
# The final redistricting results are in smc.out$cdvec

library(redist)

load("data/data.RData")

start.time <- Sys.time()
smc.out <- redist.smc(
  adjobj = adjlist,
  popvec = df$pop,
  ndists = 11,
  nsims = 100,
  popcons = 0.01
)
end.time <- Sys.time()
print(end.time - start.time)

save(smc.out, file = "data/smc.RData")
