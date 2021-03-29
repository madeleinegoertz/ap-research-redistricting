library(redist)

load("data/data.RData")

#use results from CRSG to generate starting values
load("data/crsg.RData")

RNGkind(kind = "L'Ecuyer-CMRG")
set.seed(1)
nchains <- 4
nsims <- 10000
initcds <- sample(ncol(crsg.out$partitions), nchains)

mcmc_chains <- lapply(1:nchains, function(x){
  redist.mcmc(adjobj = adjlist,
              popvec = df$pop,
              initcds = crsg.out$partitions[,initcds[x]],
              nsims = nsims,
              constraint = c("population", "compact"),
              constraintweights = c(1, 1),
              popcons = .01,
              ssdmat = distancemat)
})

seg_chains <- lapply(1:nchains, function(i){
   redist.segcalc(algout = mcmc_chains[[i]], 
                  grouppop = df$G18HORREP,
                  fullpop = df$pop)})


redist.diagplot(seg_chains, plot = 'gelmanrubin')
redist.diagplot(seg_chains[1], plot = "trace")
redist.diagplot(seg_chains[1], plot = "autocorr")
redist.diagplot(seg_chains[1], plot = "densplot")
redist.diagplot(seg_chains[1], plot = "mean")
