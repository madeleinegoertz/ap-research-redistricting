# run the edgecut branch metrics

library(redist)
library(dplyr)

load("data/data_race.RData")
load("data/smc_race.RData")

va_plans <- va_plans %>%
  mutate(pop_dev = abs(total_pop / get_target(va_map) - 1),
         comp = distr_compactness(va_map, measure = "FracKept"),
         pct_min = group_frac(va_map, pop - white_pop, pop),
         pct_dem = group_frac(va_map, G18HORDEM, G18HORDEM + G18HORREP))

plan_sum = group_by(va_plans, draw) %>%
  summarize(max_dev = max(pop_dev),
            avg_comp = mean(comp),
            max_pct_min = max(pct_min),
            dem_distr = sum(pct_dem > 0.5))
library(patchwork)

h <-
  hist(plan_sum, max_dev) + hist(va_plans, comp) +
  plot_layout(guides="collect")

frac <-
  redist.plot.distr_qtys(va_plans, pct_dem, sort="asc", size=0.5)

pal <- scales::viridis_pal()(12)[-1]
scat <- 
  redist.plot.scatter(va_plans, pct_min, pct_dem, 
                      color=pal[subset_sampled(va_plans)$district]) +
  scale_color_manual(values="black")