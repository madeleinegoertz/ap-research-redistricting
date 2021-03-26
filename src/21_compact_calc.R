library(dplyr)
load("src/data.RData")
load("src/compact.raw.RData")

########################## MCMC
calc_compact <- function(data, alg) {
  df <-
    data %>%
    select(districts, PolsbyPopper, FryerHolden, EdgesRemoved, nloop) %>%
    pivot_wider(
      names_from = districts,
      values_from = c(PolsbyPopper, FryerHolden, EdgesRemoved)
    ) %>%
    rowwise(nloop) %>%
    summarise(
      pp = mean(c_across(starts_with("PolsbyPopper"))),
      fh = mean(c_across(starts_with("FryerHolden"))),
      # normalize to total num edges. 
      ecc = 1 - mean(c_across(starts_with("EdgesRemoved")))/num_edges
    )
  df$alg <- alg
  return(df)
}

table.mcmc <- calc_compact(raw.compact$mcmc, "mcmc")
table.mcmc <- table.mcmc[-nrow(table.mcmc),] # remove junk row
table.smc <- calc_compact(raw.compact$smc, "smc")
table.control <- calc_compact(raw.compact$control, "control")
calc.compact <- list (
  mcmc = table.mcmc, 
  smc = table.smc,
  control = table.control
)
save(calc.compact, file = "src/compact.calc.RData")

longtbl <-
  bind_rows(
    table.mcmc, table.smc, table.control
  ) %>%
  pivot_longer(
    !c(alg, nloop),
    names_to = "measure",
    values_to = "value"
  )
# R doesn't set me use multiindex so I have to send this to python.
write.csv(longtbl, file = "src/compact.csv")

