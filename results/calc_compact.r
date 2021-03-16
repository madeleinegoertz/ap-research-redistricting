library(tidyverse)
load("results/data.RData")
load("results/raw.compact.RData")

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

########################## CRSG
# take mean pp score
table.crsg <-
  raw.compact$crsg %>%
  select(districts, PolsbyPopper, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = PolsbyPopper
  ) %>%
  rowwise(nloop) %>%
  summarise(pp_mean = mean(c_across()))
# add fh score
table.crsg$fh <-
  raw.compact$crsg %>%
  select(districts, FryerHolden, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = FryerHolden
  ) %>%
  rowwise(nloop) %>%
  summarise(fh = mean(c_across())) %>%
  pull(var = fh)
# add Edges Removed score
table.crsg$ecc <-
  raw.compact$crsg %>%
  select(districts, EdgesRemoved, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = EdgesRemoved
  ) %>%
  rowwise(nloop) %>%
  summarise(ecc = 1 - mean(c_across())/num_edges) %>%
  pull(var = ecc)
table.crsg$alg <- "crsg"

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
    table.mcmc, table.smc, table.crsg, table.control
  )

save(table, file = "results/calc.compact.RData")
