# This creates the seats votes curves. 

library(tidyverse)
library(pscl)
load("results/raw.fair.100.all.RData")

# First need to extract DVS.

dvs <- function(data) {
  data %>%
  select(districts, DVS, nloop) %>%
  pivot_wider(
    names_from = nloop,
    values_from = DVS
  )
}

summarize_dvs <- function(data) {
  data %>%
  rowwise(districts) %>%
  summarise(
    mean = mean(c_across()),
    median = median(c_across())
  )
}

plot_dvs <- function(dvs, alg) {
  dvs %>%
  seatsVotes(desc=alg) %>%
  plot(type="seatsVotes")
}

mcmc.raw <- dvs(raw.fair$mcmc)
mcmc.sum <- summarize_dvs(mcmc.raw)
plot_dvs(mcmc.sum$mean, 'MCMC')

smc.raw <- dvs(raw.fair$smc)
smc.sum <- summarize_dvs(smc.raw)
plot_dvs(smc.raw[,100], 'SMC')


