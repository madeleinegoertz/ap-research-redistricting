library(sf)
library(ggplot2)
library(dplyr)
library(tibble)
library(magrittr)

precinct.data <- st_read("../data/VA-shapefiles-master/VA_precincts/VA_precincts.shp")

# copy over useful cols and rename them
precinct.data <- precinct.data %>%
    select(pop = TOTPOP,
           vap = VAP,
           obama = G17DHOD,
           mccain = G17RHOD,
           TotPop = TOTPOP,
           BlackPop = NH_BLACK,
           HispPop = HISP,
           VAP_1 = VAP,
           BlackVAP = BVAP,
           HispVAP = HVAP,
           geometry = geometry)
# add col geoid10 based off of index
precinct.data <- cbind(geoid10 = rownames(precinct.data), precinct.data)
# change all cols to numeric type
precinct.data %<>% 
      mutate_each(funs(if(is.character(.)) as.numeric(.) else .))
head(precinct.data)

library(sp)
library(spData)
library(spdep)

adjlist <- poly2nb(precinct.data, queen = FALSE) # queen = FALSE means that being kitty corner doesn't qualify.
adjlist

# build list that will bundle the adjlist, the precinct.data, and the other components once I work those out. 
va.full <- list(adjlist, precinct.data)
va.full

library(redist)

head(precinct.data)

# visualize polgons to make sure they're all there. 
precinct.data %>% ggplot(aes(fill = pop)) + 
  geom_sf()

precinct.data$id <- 1:2439 # TODO: Figure out why it says there are 2439 precincts, when IIRC there are 6688 in VA??
# visualize and label a small smattering of precincts
precinct.data[c(10, 11, 12, 13, 14, 15, 18, 19, 20, 28, 30, 31, 83, 85, 86, 87),] %>% ggplot() + 
  geom_sf() +
  geom_sf_label(aes(label = id))

# list all precincts that this one is adjacent to. 
adjlist[[86]]

library(igraph)
# commented out b/c takes forever!
# plot(graph_from_adj_list(adjlist, mode = 'total'))

# The C++ backend is more efficient if it's zero-indexed. 
for(i in 1:2439){
  adjlist[[i]] <- adjlist[[i]]-1
}

adjlist[[86]] #note how all the labels are shifted down by 1. 
class(adjlist)

va.mcmc <- redist.mcmc(adjobj = adjlist,
                    popvec = precinct.data$pop,
                    ndists = 11,
                    nsims = 10000,
                    savename = "redist.mcmc.va", 
                    maxiterrsg = 1000000000)

class(va.mcmc)

names(va.mcmc)

va.mcmc$partitions[,1]

va.mcmc$distance_parity[1]

# can I plot this?
cds <- va.mcmc$partitions[,1]
plot <- redist.map(shp=precinct.data, 
        district_membership=cds, 
        centroids=FALSE, 
        edges=FALSE,
        title="VA House of Delegates Districts: MCMC") +
        theme(legend.position="right")
        # geom_sf_label(aes(label = cds))
ggsave("plot.png", scale=2)

plot

RNGkind(kind = "L'Ecuyer-CMRG")
set.seed(1)
nchains <- 4
nsims <- 10000

mcmc_chains <- lapply(1:nchains, function(x){
          redist.mcmc(adjobj = adjlist, 
                      popvec = precinct.data$pop, 
                      nsims = nsims,
                      ndists = 100,
                      maxiterrsg = 1000000000)
})

cds <- mcmc_chains$partitions[,1]
plot2 <- redist.map(shp=precinct.data, 
        district_membership=cds, 
        centroids=FALSE, 
        edges=FALSE,
        title="VA House of Delegates Districts: MCMC Chains") +
        theme(legend.position="none")
        # geom_sf_label(aes(label = cds))
ggsave("mcmc_chains.png", scale=2)

plot2

rsg <- redist.rsg(adj.list = adjlist,
                  population = precinct.data$pop,
                  ndists = 100,
                  thresh = 0.05, 
                  maxiter = 1000000000)


