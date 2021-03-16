## Create latex table from long table. 
library(xtable)
options(xtable.floating = TRUE)
options(xtable.timestamp = "")

load("results/calc.compact.RDATA")
xtable