# take mean pp score
table <-
  mcmc.compact %>%
  select(districts, PolsbyPopper, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = PolsbyPopper
  ) %>%
  rowwise(nloop) %>%
  summarise(pp_mean = mean(c_across()))
# add fh score
table$fh <-
  mcmc.compact %>%
  select(districts, FryerHolden, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = FryerHolden
  ) %>%
  rowwise(nloop) %>%
  summarise(fh = mean(c_across())) %>%
  pull(var = fh)
# add Edges Removed score
table$ecc <-
  mcmc.compact %>%
  select(districts, EdgesRemoved, nloop) %>%
  pivot_wider(
    names_from = districts,
    values_from = EdgesRemoved
  ) %>%
  rowwise(nloop) %>%
  summarise(ecc = mean(c_across())) %>%
  pull(var = ecc)

library(igraph)

num_edges <- 
  adjlist %>%
  graph_from_adj_list(
    mode = c("total")
  ) %>%
  gsize()
