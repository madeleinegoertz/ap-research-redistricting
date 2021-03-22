library(dplyr)

load("results/raw.fair.100.RData")

########################## MCMC
# take mean DSeats
table.mcmc <-
  raw.fair$mcmc %>%
  select(districts, DSeats, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = DSeats
  ) %>%
  rowwise(nloop) %>%
  summarise(DSeats = mean(c_across()))
# add partisan bias
table.mcmc$bias <-
  raw.fair$mcmc %>%
  select(districts, Bias, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = Bias
  ) %>%
  rowwise(nloop) %>%
  summarise(bias = mean(c_across())) %>%
  pull(var = bias)
# add dvs_mean
table.mcmc$dvs_mean <-
  raw.fair$mcmc %>%
  select(districts, DVS, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = DVS
  ) %>%
  rowwise(nloop) %>%
  summarise(dvs_mean = mean(c_across())) %>%
  pull(var = dvs_mean)
table.mcmc$alg <- "mcmc"

########################## SMC
# take mean DSeats
table.smc <-
  raw.fair$smc %>%
  select(districts, DSeats, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = DSeats
  ) %>%
  rowwise(nloop) %>%
  summarise(DSeats = mean(c_across()))
# add partisan bias
table.smc$bias <-
  raw.fair$smc %>%
  select(districts, Bias, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = Bias
  ) %>%
  rowwise(nloop) %>%
  summarise(bias = mean(c_across())) %>%
  pull(var = bias)
# add dvs_mean
table.smc$dvs_mean <-
  raw.fair$smc %>%
  select(districts, DVS, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = DVS
  ) %>%
  rowwise(nloop) %>%
  summarise(dvs_mean = mean(c_across())) %>%
  pull(var = dvs_mean)
table.smc$alg <- "smc"

########################## Control
# take mean DSeats
table.control <-
  raw.fair$control %>%
  select(districts, DSeats, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = DSeats
  ) %>%
  rowwise(nloop) %>%
  summarise(DSeats = mean(c_across()))
# add partisan bias
table.control$bias <-
  raw.fair$control %>%
  select(districts, Bias, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = Bias
  ) %>%
  rowwise(nloop) %>%
  summarise(bias = mean(c_across())) %>%
  pull(var = bias)
# add dvs_mean
table.control$dvs_mean <-
  raw.fair$control %>%
  select(districts, DVS, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = DVS
  ) %>%
  rowwise(nloop) %>%
  summarise(dvs_mean = mean(c_across())) %>%
  pull(var = dvs_mean)
table.control$alg <- "control"

table <-
  bind_rows(
    table.mcmc, table.smc, table.control
  )

save(table, file = "results/calc.fair.100.RData")

longtbl <-
  table %>%
  pivot_longer(
    !c(alg, nloop),
    names_to = "measure",
    values_to = "value"
  )
# R doesn't set me use multiindex so I have to send this to python.
write.csv(longtbl, file = "results/fair.100.csv")
