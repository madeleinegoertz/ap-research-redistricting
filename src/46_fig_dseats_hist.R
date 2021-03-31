library(dplyr)
library(ggplot2)
library(patchwork)

load("data/fair.calc.100.RData")

seats_hist <- function(x, control, measure, alg, lab) {
  ggplot(mapping = aes(x = x)) +
    theme_bw() +
    geom_histogram(binwidth = 1, color = "black", fill = "lightgray") +
    xlim(5, 10) +
    ylim(0, 60) +
    geom_vline(
      aes(xintercept = control),
      color = "red", size = 0.5
    ) +
    geom_vline(
      aes(xintercept = mean(x, na.rm = TRUE)),
      color = "darkgreen", size = 0.5
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
      color = "darkgreen",
      size = 3,
    ) +
    labs(
      x = measure,
      y = "Number of plans",
      title = paste(lab, measure, "distr. of", alg, "plans")
    )
}

smc.seats <- seats_hist(
  x = calc.fair$smc$dseats,
  control = calc.fair$control$dseats,
  measure = "Democratic Seats",
  alg = "SMC", 
  lab = "a)"
)

crsg.seats <- seats_hist(
  x = calc.fair$crsg$dseats,
  control = calc.fair$control$dseats,
  measure = "Democratic Seats",
  alg = "CRSG", 
  lab = "a)"
)

p <- (smc.seats | crsg.seats)
ggsave("paper/img/dseats.hist.png", p, units = "in", width = 9, height=4.5)
