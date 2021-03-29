# this script tries to follow the instructions outlined here:
# https://htmlpreview.github.io/?https://raw.githubusercontent.com/kosukeimai/redist/edgecut/docs/articles/redist.html#fn2
# It relies on the dev version of redist, found at 
# kosukeimai/redist$edgecut

library(redist)
library(dplyr)
library(ggplot2)

# load geo data
load("data/data.RData")

# set up the redistricting problem
va_map <- redist_map(df, existing_plan=CON_DIST, pop_tol=0.01)

# run smc
va_plans <- redist_smc(va_map, nsims=1000, compactness=1)

dev_comp <- va_plans %>%
  mutate(comp = distr_compactness(va_map)) %>%
  group_by(draw) %>%
  summarize(`Population deviation` = max(abs(total_pop/get_target(va_map) - 1)),
            Compactness = comp[1])
va_plans <- va_plans %>%
  mutate(pop_dev = abs(total_pop / get_target(va_map) - 1),
         comp = distr_compactness(va_map, measure = "FracKept"),
         pct_dem = group_frac(va_map, G18HORDEM, G18HORDEM + G18HORREP))

plan_sum <- group_by(va_plans, draw) %>%
  summarize(max_dev = max(pop_dev),
            avg_comp = mean(comp),
            dem_distr = sum(pct_dem > 0.5))