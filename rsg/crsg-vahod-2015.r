# To add a new cell, type '# %%'
# To add a new markdown cell, type '# %% [markdown]'
# %%
library(sf)
library(ggplot2)
library(tidyverse)
library(tibble)
library(magrittr)
library(redist)
library(sp)
library(spData)
library(spdep)
library(igraph)

va_2015_file <- "C:/Users/madie/OneDrive/data/pre-redist/VA_precinct_2015/VA_precinct_2015.shp"
df <- st_read(va_2015_file)


# %%
# list of lists of precincts adjacent to each precincts
adj <- redist.adjacency(df)


# %%
# area of each precincts
area <- sf::st_area(df)


# %%
# coordinate of centroid of each precinct
centers <- sf::st_coordinates(sf::st_centroid(df))


# %%
# returns list with district_membership vector (which district each precinct is in), 
# district_list vector (contains vector of each precinct in each district), and
# district_pop vector (population totals for each district)
crsg_out <- redist.crsg(adj.list = adj, 
                        population = df$pop, 
                        area = area,
                        x_center = centers[,1], 
                        y_center = centers[,2], 
                        ndists = 100, 
                        thresh = .1, #population threshold
                        maxiter = 1e6)


# %%
# generate 100 random colors that are distinct so that the different districts are distinguishable. 
library(randomcoloR)
colors <- distinctColorPalette(k=100)


# %%
cds <- crsg_out$district_membership
plot <- redist.map(shp=df, 
        district_membership=cds, 
        centroids=FALSE, 
        edges=FALSE,
        title="100 Districts in VA HOD: 2015 CRSG") +
        theme(legend.position="right") +
        scale_fill_manual(values = colors)
        # geom_sf_label(aes(label = cds))
#ggsave("fairfax_10.png")
plot


# %%
library(pscl)
# compute the percent of votes won by democrats in each district under DVS
plot_sv <- redist.metrics(cds, measure = c("DSeats", "DVS"), df$repvote, dvote = df$demvote) %>% 
           # extract DVS into vector
           pull(DVS) %>%
           # calculate seats-votes curve using uniform partisan swing
           seatsVotes(desc="Democratic Vote Shares, VA HOD 2015 CRSG") %>%
           # plot the seats-votes curve
           plot(type="seatsVotes")


# %%



