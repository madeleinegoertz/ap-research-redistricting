import pandas as pd

df = pd.read_csv("results/longtbl.csv", usecols=["nloop","alg","measures","value"])
df = df.set_index(['alg', 'nloop', 'measures'])
df = df.unstack(level='measures')
df2 = df.mean(level=0)
df2['nloop'] = "mean"
df2 = df2.set_index('nloop', append=True)
df = pd.concat([df, df2])
print(df.to_latex())
