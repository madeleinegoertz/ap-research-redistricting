import geopandas
import pandas as pd

# read in block groups shapefile
bg = geopandas.read_file("zip://shp/va_2018_blck_grp_shp.zip")
# keep only the useful cols
bg = bg[["GEOID", "GISJOIN", "geometry"]].copy()
# read in population data csv
data = pd.read_csv("shp/va_2018_blck_grp_pop.zip")
# keep only the relevant columns for total population by race.
# AJWNE001:    Total
# AJWNE002:    White alone
# AJWNE003:    Black or African American alone
# AJWNE004:    American Indian and Alaska Native alone
# AJWNE005:    Asian alone
# AJWNE006:    Native Hawaiian and Other Pacific Islander alone
# AJWNE007:    Some other race alone
# AJWNE008:    Two or more races
# AJWNE009:    Two or more races: Two races including Some other race
# AJWNE010:    Two or more races: Two races excluding Some other race, and three or more races
data = data[["GISJOIN", "AJWNE001", "AJWNE002", "AJWNE003", "AJWNE004", "AJWNE005", 
            "AJWNE006", "AJWNE007", "AJWNE008", "AJWNE009", "AJWNE010"]].copy()
# rename these cols to something more intelligible
data.columns = ["GISJOIN", "pop", "white_pop", "black_pop", "aian_pop", "asian_pop", 
                "nhopi_pop", "sor_pop", "2more_pop", "2morenosor_pop", "2morenot3more_pop"]
# merge the population data into the bg shapefile
bg = bg.merge(data, on='GISJOIN')

# write bg to file
out_file = "shp/va_2018_blck_grp_shp_pop.shp"
bg.to_file(out_file)
# best to zip manually now (too lazy to use shutil)