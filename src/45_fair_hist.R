library(dplyr)
library(ggplot2)
library(patchwork)

load("data/fair.calc.100.RData")

fair_hist <- function(x, control, measure, alg, lab) {
  ggplot(mapping = aes(x = x)) +
    theme_bw(base_size = 7) +
    geom_histogram(bins = 25) +
    geom_vline(
      aes(xintercept = control),
      color = "red", size = 1
    ) +
    annotate(
      geom = 'text', 
      label = paste("control =", format(control, digits=3)), 
      x = -Inf, 
      y = Inf, 
      hjust = 0, 
      vjust = 1,
      color = "red",
      size = 3
    ) + 
    labs(
      x = measure,
      y = "Number of plans",
      title = paste(lab, measure, "distr. of", alg, "plans")
    )
}

smc.bias <- fair_hist(
  x = calc.fair$smc$bias,
  control = calc.fair$control$bias,
  measure = "Partisan Bias",
  alg = "SMC", 
  lab = "a)"
)

smc.effgap <- fair_hist(
  x = calc.fair$smc$effgap,
  control = calc.fair$control$effgap,
  measure = "Efficiency Gap",
  alg = "SMC", 
  lab = "b)"
)

smc.dec <- fair_hist(
  x = calc.fair$smc$dec,
  control = calc.fair$control$dec,
  measure = "Declination",
  alg = "SMC", 
  lab = "c)"
)
smc.meanmed <- fair_hist(
  x = calc.fair$smc$meanmed,
  control = calc.fair$control$meanmed,
  measure = "Mean-Median",
  alg = "SMC", 
  lab = "d)"
)

crsg.bias <- fair_hist(
  x = calc.fair$crsg$bias,
  control = calc.fair$control$bias,
  measure = "Partisan Bias",
  alg = "CRSG", 
  lab = "e)"
)

crsg.effgap <- fair_hist(
  x = calc.fair$crsg$effgap,
  control = calc.fair$control$effgap,
  measure = "Efficiency Gap",
  alg = "CRSG", 
  lab = "f)"
)

crsg.dec <- fair_hist(
  x = calc.fair$crsg$dec,
  control = calc.fair$control$dec,
  measure = "Declination",
  alg = "CRSG", 
  lab = "g)"
)
crsg.meanmed <- fair_hist(
  x = calc.fair$crsg$meanmed,
  control = calc.fair$control$meanmed,
  measure = "Mean-Median",
  alg = "CRSG", 
  lab = "h)"
)

p <- (smc.bias | smc.dec | smc.effgap | smc.meanmed) / 
     (crsg.bias | crsg.dec | crsg.effgap | crsg.meanmed) 
ggsave("paper/img/fair_hist.png", p, units = "in", width = 9, height=4.5)
