# This script takes the long table raw compactness and fairness measures output as csvs, 
# and write a latex file of the mean measures for mcmc, smc, and the control. 

import pandas as pd

dfc = pd.read_csv("results/compact.100.csv", usecols=["nloop","alg","measure","value"])
dff = pd.read_csv("results/fair.100.csv", usecols=["nloop","alg","measure","value"])
df = pd.concat([dfc, dff])

df = df.set_index(['alg', 'nloop', 'measure'])
df = df.unstack(level='measure')
mean = df.mean(level=0)
mean.to_latex(buf="paper/results/tbl.tex")