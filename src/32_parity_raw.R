library(redist)

load("data/smc.100.RData")
load("data/crsg.100.RData")
load("data/data_va.RData")

parity.smc <-
  redist.parity(
    district_membership = smc.out$cdvec,
    population = df$pop,
    ncores=4
  )

parity.crsg <-
  redist.parity(
    district_membership = crsg.out$partitions,
    population = df$pop,
    ncores=4
  )

parity.control <-
  redist.parity(
    district_membership = as.matrix(as.numeric(df$CON_DIST)),
    population = df$pop,
    ncores=4
  )

parity.raw <-
  list(
    smc = parity.smc,
    crsg = parity.crsg,
    control = parity.control
  )

save(parity.raw, file = "data/parity.raw.100.RData")