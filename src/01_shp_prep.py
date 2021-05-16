# This script takes a precincts shapefile with election data and aggregates in population 
# data from the block level using maup. 

import geopandas
import pandas as pd
import maup
import warnings
import shutil

# enable progress bar for all maup operations
maup.progress.enabled = True
# turn off annoying geopandas warnings
warnings.filterwarnings('ignore', 'GeoSeries.isna', UserWarning)

# read in files
bg = geopandas.read_file("zip://shp/va_2018_blck_grp_shp_pop.zip")
precincts = geopandas.read_file("zip://shp/va_2018_ushouse_precincts.zip")
# reproject files to north va CRS
precincts = precincts.to_crs(epsg=2283)
bg = bg.to_crs(epsg=2283)
# remove any bowties (little imperfections in the polygons)
precincts.geometry = precincts.buffer(0)
bg.geometry = bg.buffer(0)
# reset index
precincts = precincts.reset_index(drop = True)
bg = bg.reset_index(drop = True)

# choose data column being reaggregated.
columns = ["pop", "white_pop", "black_pop", "aian_pop", "asian_pop", "nhopi_pop", "sor_pop", "2more_pop"]
# Include area_cutoff=0 to ignore any intersections with no area,
# like boundary intersections, which we do not want to include in
# our proration.
pieces = maup.intersections(bg, precincts, area_cutoff=0)
# Weight by prorated population from bg
weights = bg["pop"].groupby(maup.assign(bg, pieces)).sum()
# Normalize the weights so that pop is allocated according to their
# share of population in the bg
weights = maup.normalize(weights, level=0)
# Use blocks to estimate population of each piece
precincts[columns] = maup.prorate(
    pieces,
    bg[columns],
    weights=weights
)

out_file = "shp/va_ushouse_2018_precincts_race.shp"
precincts.to_file(out_file)
#shutil.make_archive(out_file, 'zip', root_dir="src/va_ushouse_2018_precincts_data")
