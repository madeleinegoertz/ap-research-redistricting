library(dplyr)
load("data/compact.raw.100.RData")

num_edges <-6991

########################## MCMC
calc_compact <- function(data, alg) {
  df <-
    data %>%
    select(districts, PolsbyPopper, EdgesRemoved, nloop) %>%
    pivot_wider(
      names_from = districts,
      values_from = c(PolsbyPopper, EdgesRemoved)
    ) %>%
    rowwise(nloop) %>%
    summarise(
      pp = mean(c_across(starts_with("PolsbyPopper"))),
      # normalize to total num edges. 
      ecc = 1 - mean(c_across(starts_with("EdgesRemoved")))/num_edges
    )
  df$alg <- alg
  return(df)
}

table.smc <- calc_compact(raw.compact$smc, "smc")
table.crsg <- calc_compact(raw.compact$crsg, "crsg")
table.control <- calc_compact(raw.compact$control, "control")
calc.compact <- list ( 
  smc = table.smc,
  crsg = table.crsg,
  control = table.control
)
save(calc.compact, file = "data/compact.calc.100.RData")

longtbl <-
  bind_rows(
    table.smc, table.crsg, table.control
  ) %>%
  pivot_longer(
    !c(alg, nloop),
    names_to = "measure",
    values_to = "value"
  )
# R doesn't set me use multiindex so I have to send this to python.
write.csv(longtbl, file = "data/compact.100.csv")

