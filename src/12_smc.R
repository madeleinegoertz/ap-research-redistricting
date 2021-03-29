# This script runs smc
# The final redistricting results are in smc.out$cdvec

library(redist)

load("data/data_race.RData")

start.time <- Sys.time()
# run smc
va_plans <- redist_smc(va_map, nsims=1000, compactness=1)
end.time <- Sys.time()
print(end.time - start.time)

save(va_plans, file = "data/smc_race.RData")
