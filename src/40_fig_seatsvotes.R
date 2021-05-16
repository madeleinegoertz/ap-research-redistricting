# This creates the seats votes curves. 

library(tidyverse)
# must use my version of pscl via install_github("madeleinegoertz/pscl")
library(pscl) 
load("data/fair.raw.RData")

dvs <- function(data) {
  data %>%
  select(districts, DVS, nloop) %>%
  pivot_wider(
    names_from = nloop,
    values_from = DVS
  )
}

plot_mean_sv <- function(data, desc) {
  data %>%
   dvs() %>%
   rowwise(districts) %>%
   summarise(
     mean = mean(c_across()),
     median = median(c_across())
   ) %>%
   pull(mean) %>%
   as.matrix() %>%
   seatsVotes(desc=desc) %>%
   plot(type="seatsVotes")
}
plot_all_sv <- function(data, desc) {
 data %>%
   dvs() %>%
   select(-districts) %>%
   as.matrix() %>%
   seatsVotes(desc=desc) %>%
   plot(type="seatsVotes")
}


smc <- plot_all_sv(raw.fair$smc, "100 SMC-Generated Maps")
crsg <- plot_all_sv(raw.fair$crsg, "100 CRSG-Generated Maps")
control <- plot_all_sv(raw.fair$control, "Existing Map (Control)")

# write to files manually. Export as png to
# paper/img/sv.<alg>.png w/ aspect ratio 550:550

