# This creates the seats votes curves. 

library(tidyverse)
#library(pscl) # must use my version of pscl via install_github("madeleinegoertz/pscl")
load("results/fair.raw.RData")

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

# par(mfrow=c(2,2))
#plot_mean_sv(raw.fair$mcmc, "MCMC Mean simulated DVS")
#smc <- plot_mean_sv(raw.fair$smc, "SMC Mean simulated DVS")
mcmc<- plot_all_sv(raw.fair$mcmc, "MCMC all simulated DVS")
smc <- plot_all_sv(raw.fair$smc, "SMC all simulated DVS")  
control <- plot_all_sv(raw.fair$control, "Control Simulated DVS")

# write to files manually. Export as png to
# paper/img/sv.<alg>.png w/ aspect ratio 541:491

