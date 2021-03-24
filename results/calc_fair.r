library(tidyverse)

load("results/raw.fair.100.all.RData")

calc_fair <- function(data, alg) {
  df <-
    data %>%
    select(districts, DSeats, Bias, EffGap, EffGapEqPop, TauGap, MeanMedian,
           Declination, Responsiveness, LopsidedWins, nloop) %>%
    pivot_wider(
      names_from = districts,
      values_from = c(DSeats, Bias, EffGap, EffGapEqPop, TauGap, MeanMedian,
                      Declination, Responsiveness, LopsidedWins)
    ) %>%
    rowwise(nloop) %>%
    summarise( # take mean of all measures across districts. 
      dseats = mean(c_across(starts_with("DSeats"))),
      bias = mean(c_across(starts_with("Bias"))),
      effgap = mean(c_across(starts_with("EffGap_"))), # _ to not include == pop
      effgapeqpop = mean(c_across(starts_with("EffGapEqPop"))),
      taugap = mean(c_across(starts_with("TauGap"))),
      meanmed = mean(c_across(starts_with("MeanMedian"))),
      dec = mean(c_across(starts_with("Declination"))),
      resp = mean(c_across(starts_with("Responsiveness"))),
      lopwin = mean(c_across(starts_with("LopsidedWins"))),
    ) 
  df$alg <- alg
  return(df)
}

table.mcmc <- calc_fair(raw.fair$mcmc, "mcmc")
table.smc <- calc_fair(raw.fair$smc, "smc")
table.control <- calc_fair(raw.fair$control, "control")

longtbl <-
  bind_rows(table.mcmc, table.smc, table.control) %>%
  pivot_longer(
    !c(alg, nloop),
    names_to = "measure",
    values_to = "value"
  )
# R doesn't set me use multiindex so I have to send this to python.
write.csv(longtbl, file = "results/fair.100.csv")
