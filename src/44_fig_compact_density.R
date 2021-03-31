library(dplyr)
library(ggplot2)
library(patchwork)

load("data/compact.calc.100.RData")

compact_hist <- function(x, control, measure, alg, lab, min, max) {
  ggplot(mapping = aes(x = x)) +
    theme_bw(base_size = 7) +
    #geom_histogram(bins = 25) +
    geom_density() + 
    xlim(min, max) + 
    ylim(0, 40) + 
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
      title = paste(lab, measure, "distribution of", alg, "plans")
    )
}

smc.pp <- compact_hist(
  x = calc.compact$smc$pp,
  control = calc.compact$control$pp,
  measure = "Polsby-Popper score",
  alg = "SMC", 
  lab = "a)",
  min = 0, 
  max = 0.3
)

smc.ecc <- compact_hist(
  x = calc.compact$smc$ecc,
  control = calc.compact$control$ecc,
  measure = "Edge-Cut compactness",
  alg = "SMC", 
  lab = "b)",
  min = 0.6, 
  max = 1
)

crsg.pp <- compact_hist(
  x = calc.compact$crsg$pp,
  control = calc.compact$control$pp,
  measure = "Polsby-Popper score",
  alg = "CRSG", 
  lab = "c)",
  min = 0, 
  max = 0.3
)

crsg.ecc <- compact_hist(
  x = calc.compact$crsg$ecc,
  control = calc.compact$control$ecc,
  measure = "Edge-Cut compactness",
  alg = "CRSG", 
  lab = "d)",
  min = 0.6, 
  max = 1
)

p <- (smc.pp | smc.ecc) / (crsg.pp | crsg.ecc) 
ggsave("paper/img/compact.density.png", p, units = "in", width = 6.5, height=6.5)