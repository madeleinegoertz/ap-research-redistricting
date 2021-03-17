## Create latex table from long table. 
library(xtable)
options(xtable.floating = TRUE)
options(xtable.timestamp = "")

load("results/calc.compact.RDATA")

library(tidyverse)
longtbl <-
  table %>%
  pivot_longer(
    !c(alg, nloop),
    names_to = "measures",
    values_to = "value"
  )
# R doesn't set me use multiindex so I have to send this to python.
write.csv(longtbl, file = "results/longtbl.csv")
