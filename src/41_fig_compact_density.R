library(dplyr)
library(ggplot2)
library(patchwork)

load("data/compact.calc.RData")

compact_hist <- function(x, control, measure, alg, lab, min, max) {
  ggplot(mapping = aes(x = x)) +
    theme_bw(base_size = 7) +
    geom_density() + 
    xlim(min, max) + 
    ylim(0, 40) + 
    theme(
      text = element_text(size=10)
    ) +
    geom_vline(
      aes(xintercept = control),
      color = "red", size = 0.5, linetype = "longdash"
    ) +
    geom_vline(
      aes(xintercept = mean(x, na.rm=TRUE)),
      color = "blue", size = 0.5
    ) +
    geom_text(
      aes(label = paste("control:\n", format(control, digits=3)), 
        x = -Inf, 
        y = Inf), 
      hjust = 0, 
      vjust = 1,
      color = "red",
      size = 5
    ) + 
    geom_text(
      aes(label = paste("mean:\n", format(mean(x, na.rm=TRUE), digits=3)), 
          x = Inf, 
          y = Inf), 
      hjust = 1, 
      vjust = 1,
      color = "blue",
      size = 5
    ) + 
    labs(
      x = measure,
      y = "Number of maps",
      title = paste(alg, measure, "score distr.")
    )
}

smc.pp <- compact_hist(
  x = calc.compact$smc$pp,
  control = calc.compact$control$pp,
  measure = "Polsby-Popper",
  alg = "SMC", 
  lab = "a)",
  min = 0, 
  max = 0.3
)

smc.ecc <- compact_hist(
  x = calc.compact$smc$ecc,
  control = calc.compact$control$ecc,
  measure = "Edge-Cut",
  alg = "SMC", 
  lab = "b)",
  min = 0.6, 
  max = 1
)

crsg.pp <- compact_hist(
  x = calc.compact$crsg$pp,
  control = calc.compact$control$pp,
  measure = "Polsby-Popper",
  alg = "CRSG", 
  lab = "c)",
  min = 0, 
  max = 0.3
)

crsg.ecc <- compact_hist(
  x = calc.compact$crsg$ecc,
  control = calc.compact$control$ecc,
  measure = "Edge-Cut",
  alg = "CRSG", 
  lab = "d)",
  min = 0.6, 
  max = 1
)

p <- (smc.pp | smc.ecc) / (crsg.pp | crsg.ecc) 
ggsave("paper/img/compact.density.png", p, units = "in", width = 6.5, height=6.5)