library(ggplot2)
library(dplyr)

load("data/fair.calc.100.RData")

# df <-
#   calc.fair$smc %>%
#   select()

ggplot(calc.fair$smc, aes(x=dseats)) + geom_histogram()
ggplot(calc.fair$crsg, aes(x=bias)) + geom_histogram()

load("data/compact.calc.100.RData")

ggplot(calc.compact$smc, aes(x=pp)) + geom_histogram()
ggplot(calc.compact$crsg, aes(x=pp)) + 
  geom_histogram() +
  geom_vline(aes(xintercept=calc.compact$control$pp),
           color="blue", linetype="dashed", size=1)
ggplot(calc.compact$smc, aes(x=pp)) + 
  geom_histogram() +
  geom_vline(aes(xintercept=calc.compact$control$pp),
             color="blue", linetype="dashed", size=1)