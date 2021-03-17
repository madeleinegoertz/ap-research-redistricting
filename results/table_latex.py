# This script creates the data table for my project
import pandas as pd

dfc = pd.read_csv("results/compact.csv", usecols=["nloop","alg","measure","value"])
dff = pd.read_csv("results/fair.csv", usecols=["nloop","alg","measure","value"])

df = pd.concat([dfc, dff])
print(df)
# dfc = dfc.rename(columns={"nloop": "map"})
# dff = dff.rename(columns={"nloop": "map"})

# df = df.set_index(['alg', 'nloop', 'measures'])
# df = df.unstack(level='measures')
# df2 = df.mean(level=0)
# df2['nloop'] = "mean"
# df2 = df2.set_index('nloop', append=True)
# df = pd.concat([df, df2])
# print(df.to_latex())
