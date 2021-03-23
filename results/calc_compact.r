library(dplyr)
load("results/data.RData")
load("results/raw.compact.100.three.RData")

########################## MCMC
# take mean pp score
table.mcmc <-
  raw.compact$mcmc %>%
  select(districts, PolsbyPopper, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = PolsbyPopper
  ) %>%
  rowwise(nloop) %>%
  summarise(pp_mean = mean(c_across()))
# add fh score
table.mcmc$fh <-
  raw.compact$mcmc %>%
  select(districts, FryerHolden, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = FryerHolden
  ) %>%
  rowwise(nloop) %>%
  summarise(fh = mean(c_across())) %>%
  pull(var = fh)
# add Edges Removed score
table.mcmc$ecc <-
  raw.compact$mcmc %>%
  select(districts, EdgesRemoved, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = EdgesRemoved
  ) %>%
  rowwise(nloop) %>%
  summarise(ecc = 1 - mean(c_across())/num_edges) %>%
  pull(var = ecc)
table.mcmc$alg <- "mcmc"

########################## SMC
# take mean pp score
table.smc <-
  raw.compact$smc %>%
  select(districts, PolsbyPopper, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = PolsbyPopper
  ) %>%
  rowwise(nloop) %>%
  summarise(pp_mean = mean(c_across()))
# add fh score
table.smc$fh <-
  raw.compact$smc %>%
  select(districts, FryerHolden, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = FryerHolden
  ) %>%
  rowwise(nloop) %>%
  summarise(fh = mean(c_across())) %>%
  pull(var = fh)
# add Edges Removed score
table.smc$ecc <-
  raw.compact$smc %>%
  select(districts, EdgesRemoved, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = EdgesRemoved
  ) %>%
  rowwise(nloop) %>%
  summarise(ecc = 1 - mean(c_across())/num_edges) %>%
  pull(var = ecc)
table.smc$alg <- "smc"

########################## Control
# take mean pp score
table.control <-
  raw.compact$control %>%
  select(districts, PolsbyPopper, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = PolsbyPopper
  ) %>%
  rowwise(nloop) %>%
  summarise(pp_mean = mean(c_across()))
# add fh score
table.control$fh <-
  raw.compact$control %>%
  select(districts, FryerHolden, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = FryerHolden
  ) %>%
  rowwise(nloop) %>%
  summarise(fh = mean(c_across())) %>%
  pull(var = fh)
# add Edges Removed score
table.control$ecc <-
  raw.compact$control %>%
  select(districts, EdgesRemoved, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = EdgesRemoved
  ) %>%
  rowwise(nloop) %>%
  summarise(ecc = 1 - mean(c_across())/num_edges) %>%
  pull(var = ecc)
table.control$alg <- "control"

table <-
  bind_rows(
    table.mcmc, table.smc, table.control
  )

save(table, file = "results/calc.compact.100.RData")

longtbl <-
  table %>%
  pivot_longer(
    !c(alg, nloop),
    names_to = "measure",
    values_to = "value"
  )
# R doesn't set me use multiindex so I have to send this to python.
write.csv(longtbl, file = "results/compact.100.csv")

