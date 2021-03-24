# This creates the seats votes curves. 

library(tidyverse)
library(pscl)
load("results/raw.fair.100.all.RData")

# First need to extract DVS.

dvs <-
  raw.fair$mcmc %>%
  select(districts, DVS, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = DVS
  )

