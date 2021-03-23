# This script takes the long table raw compactness and fairness measures output as csvs, 
# and write a latex file of the mean measures for mcmc, smc, and the control. 

import pandas as pd

dfc = pd.read_csv("results/compact.100.csv", usecols=["nloop","alg","measure","value"])
dff = pd.read_csv("results/fair.100.csv", usecols=["nloop","alg","measure","value"])
df = pd.concat([dfc, dff])

df = df.set_index(['alg', 'nloop', 'measure'])
df = df.unstack(level='measure')
mean = df.mean(level=0)
mean.columns = mean.columns.droplevel(0)
mean_long = mean.transpose()
# df2['nloop'] = "mean"
# df2 = df2.set_index('nloop', append=True)
mean_long = mean_long.reindex(["ecc", "fh", "pp", "dseats", "bias",
   "dec", "effgap", "effgapeqpop",  "lopwin", "meanmed", "resp", "taugap"])
mean_long["type"] = ["compact", "compact", "compact", "fair", "fair", 
    "fair", "fair", "fair", "fair", "fair", "fair", "fair"]
mean_long = mean_long.reset_index()
mean_long = mean_long.set_index(['type', 'measure'])
mean_long.to_latex(buf="paper/results/tbl.tex", float_format="{:#.6g}".format, multirow=True)