# This script runs the partisan fairness metrics on the alg outputs.
library(redist)
library(tidyverse)

load("results/data.RData")
load("results/mcmc.RData")
load("results/smc.RData")

# MCMC
mcmc.fair <-
  redist.metrics(
    district_membership = mcmc.out$partitions,
    measure = "all",
    rvote = df$G18HORREP,
    dvote = df$G18HORDEM,
    ncores = 4
  )
mcmc.fair$alg <- "mcmc"
# remove results from last run that always have NaNs
mcmc.fair <- mcmc.fair[-c(1101:1111),]

# SMC
smc.fair <-
  redist.metrics(
    district_membership = smc.out$cdvec,
    measure = "all",
    rvote = df$G18HORREP,
    dvote = df$G18HORDEM,
    ncores = 4
  )
smc.fair$alg <- "smc"

# Control
control.fair <-
  redist.metrics(
    # mean median function crashes if just pass vector of CON_DIST, so 
    # I bind a nonsense vector and then delete the data later. Annoying.
    district_membership = cbind(df$CON_DIST, replicate(length(df$CON_DIST), 1)),
    measure = "all",
    rvote = df$G18HORREP,
    dvote = df$G18HORDEM,
    ncores = 4
  )
# delete said nonsense data. 
control.fair <- control.fair[-c(12:22),]
control.fair$alg <- "control"

raw.fair <-
  list(
    mcmc = mcmc.fair,
    smc = smc.fair,
    control = control.fair
  )

save(raw.fair, file = "results/raw.fair.RData")
