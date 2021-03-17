# This script runs the partisan fairness metrics on the alg outputs.
library(redist)
library(tidyverse)

load("results/data.RData")
load("results/mcmc.RData")
load("results/smc.RData")
load("results/crsg.RData")

# MCMC
mcmc.fair <-
  redist.metrics(
    district_membership = mcmc.out$partitions,
    measure = c("DSeats", "DVS", "Bias"),
    rvote = df$G18HORREP,
    dvote = df$G18HORDEM,
    ncores = 4
  )
mcmc.fair$alg <- "mcmc"

# SMC
smc.fair <-
  redist.metrics(
    district_membership = smc.out$cdvec,
    measure = c("DSeats", "DVS", "Bias"),
    rvote = df$G18HORREP,
    dvote = df$G18HORDEM,
    ncores = 4
  )
smc.fair$alg <- "smc"

# CRSG
crsg.fair <-
  redist.metrics(
    district_membership = crsg.out$partitions,
    measure = c("DSeats", "DVS", "Bias"),
    rvote = df$G18HORREP,
    dvote = df$G18HORDEM,
    ncores = 4
  )
crsg.fair$alg <- "crsg"

# Control
control.fair <-
  redist.metrics(
    district_membership = df$CON_DIST,
    measure = c("DSeats", "DVS", "Bias"),
    rvote = df$G18HORREP,
    dvote = df$G18HORDEM,
    ncores = 4
  )
control.fair$alg <- "control"

raw.fair <-
  list(
    mcmc = mcmc.fair,
    smc = smc.fair,
    crsg = crsg.fair,
    control = control.fair
  )

save(raw.fair, file = "results/raw.fair.RData")
