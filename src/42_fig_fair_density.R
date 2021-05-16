library(dplyr)
library(ggplot2)
library(patchwork)

load("data/fair.calc.RData")

fair_hist <- function(x, control, measure, alg, lab) {
  ggplot(mapping = aes(x = x)) +
    theme_bw(base_size = 6.5) +
    #geom_histogram(bins = 25) +
    geom_density() + 
    xlim(-0.5, 0.5) + 
    ylim(0, 20) + 
    theme(
      text = element_text(size=9)
    ) +
    geom_vline(
      aes(xintercept = control),
      color = "red", size = 0.5, linetype = "longdash"
    ) +
    geom_vline(
      aes(xintercept = mean(x, na.rm = TRUE)),
      color = "blue", size = 0.5
    ) + 
    geom_text(
      aes(label = paste("control:\n", format(control, digits=3)), 
        x = -Inf, 
        y = Inf), 
      hjust = 0, 
      vjust = 1,
      color = "red",
      size = 3,
    ) + 
    geom_text(
      aes(label = paste("mean:\n", format(mean(x, na.rm = TRUE), digits=3)),
        x = Inf,
        y = Inf),
      hjust = 1,
      vjust = 1,
      color = "blue",
      size = 3,
    ) +
    labs(
      x = measure,
      y = "Number of maps",
      title = paste(alg, measure, "distr.")
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

p <- (smc.bias | smc.effgap | smc.dec | smc.meanmed) / 
     (crsg.bias | crsg.effgap | crsg.dec | crsg.meanmed) 
ggsave("paper/img/fair.density.png", p, units = "in", width = 9, height=4.5)
