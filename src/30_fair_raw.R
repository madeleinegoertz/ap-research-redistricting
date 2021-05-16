# This script runs the partisan fairness metrics on the alg outputs.
library(redist)
library(tidyverse)

load("data/data.RData")
load("data/smc.RData")
load("data/crsg.RData")

# SMC
smc.fair <-
  redist.metrics(
    district_membership = smc.out$cdvec,
    measure = "all",
    rvote = df$G18HORREP,
    dvote = df$G18HORDEM,
    ncores = 4
  ) %>%
  mutate(alg = "smc")

# CRSG
crsg.fair <-
  redist.metrics(
    district_membership = crsg.out$partitions,
    measure = "all",
    rvote = df$G18HORREP,
    dvote = df$G18HORDEM,
    ncores = 4
  ) %>%
  mutate(alg = "crsg")

df$CON_DIST <- as.numeric(df$CON_DIST)
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
  ) %>%
  mutate(alg = "control")
# delete said nonsense data. 
control.fair <- control.fair[-c(12:22),]

raw.fair <-
  list(
    smc = smc.fair,
    crsg = crsg.fair,
    control = control.fair
  )

save(raw.fair, file = "data/fair.raw.RData")
