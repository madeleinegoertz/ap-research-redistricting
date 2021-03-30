library(dplyr)
library(ggplot2)

load("data/compact.calc.100.RData")
load("data/fair.calc.100.RData")
load("data/parity.raw.100.RData")

# polsby popper
pp <- calc.compact$smc$pp
# edge cut compactness
ecc <- calc.compact$smc$ecc
# partisan bias
bias <- calc.fair$smc$bias
# max population deviation
parity <- as.numeric(parity.raw$smc)

# compact v fair
ggplot(mapping=aes(x=pp, y=bias)) + geom_point()
ggplot(mapping=aes(x=ecc, y=bias)) + geom_point()

# compact v parity
ggplot(mapping=aes(x=pp, y=parity)) + geom_point()
ggplot(mapping=aes(x=ecc, y=parity)) + geom_point()

# parity v fair
ggplot(mapping=aes(x=parity, y=bias)) + geom_point()

# compact v compact
ggplot(mapping=aes(x=pp, y=ecc)) + geom_point() + geom_smooth(method='lm')

# smc pp
ggplot(mapping=aes(x=pp)) + 
  geom_histogram() +
  geom_vline(aes(xintercept=calc.compact$control$pp),
             color="blue", linetype="dashed", size=1)
# smc ecc
ggplot(mapping=aes(x=ecc)) + 
  geom_histogram() +
  geom_vline(aes(xintercept=calc.compact$control$ecc),
             color="blue", linetype="dashed", size=1)

# crsg pp
ggplot(mapping=aes(x=calc.compact$crsg$pp)) + 
  geom_histogram() +
  geom_vline(aes(xintercept=calc.compact$control$pp),
             color="blue", linetype="dashed", size=1)
# smc ecc
ggplot(mapping=aes(x=calc.compact$crsg$ecc)) + 
  geom_histogram() +
  geom_vline(aes(xintercept=calc.compact$control$ecc),
             color="blue", linetype="dashed", size=1)

# smc fair
ggplot(mapping=aes(x=calc.fair$smc$bias)) + 
  geom_histogram() +
  geom_vline(aes(xintercept=calc.fair$control$bias),
             color="blue", linetype="dashed", size=1) +
  labs(title = "smc bias")
# crsg fair
ggplot(mapping=aes(x=calc.fair$crsg$bias)) + 
  geom_histogram() +
  geom_vline(aes(xintercept=calc.fair$control$bias),
             color="blue", linetype="dashed", size=1) +
  labs(title = "crsg bias")