# Evaluating Automated Redistricting Algorithms Using Measures of Compactness & Partisan Fairness: A Case Study of 2021 Congressional Redistricting in Virginia

[Here's my paper.](https://github.com/madeleinegoertz/ap-research-redistricting/blob/master/paper/paper.pdf)

This repository contains all of my work for my AP Research project that compared the performance of two different automated redistricting algorithms, [Compact Random Seed Growth and Sequential Monte Carlo](https://github.com/alarm-redist/redist/releases/tag/v2.0-2), in a hypothetical redistricting scenario of the Virginia Congressional Districts for the 2020s.

I used Python 3 to aggregate the shapefile data, R to run the redistricting algorithms and generate the figures, Zotero to track my references, LaTeX to typeset my paper, and PowerPoint to create the visuals for my presentation.

![Fairness Measures Density Plot](paper/img/fair.density.png)
![Compactness Measures Density Plot](paper/img/compact.density.png)

## Research Materials

### Data

The [shp](https://github.com/madeleinegoertz/ap-research-redistricting/tree/master/shp) directory contains the geographic data for this project.

* `va_2018_blck_grp_pop.zip`contains a shapefile of block-group-level population data for Virginia. This data came from the American Community Survey 2014-2018 5-year-estimates, downloaded from [IPUMS](https://www.nhgis.org/).

* `va_2018_blck_grp_shp.zip` contains the block-group geometry for Virginia that matches the ACS 2018 tabular. It was downloaded directly from the IPUMS.
  
* `va_2018_blck_grp_shp_pop.zip` is the block group shapefile with the tabular data merged, and was created by running `00_pop_merge.R`.

* `va_2018_ushouse_precincts.zip` contains a shapefile of precinct-level election results for the 2019 state-wide elections in Virginia. These were sourced from the [Voting and Election Science Team on the Harvard Dataverse](https://dataverse.harvard.edu/file.xhtml?persistentId=doi:10.7910/DVN/UBKYRU/K8EV6K&version=34.0).

* `va_ushouse_2018_precincts_race.zip` is generated by running `01_shp_prep.py`, which aggregates the block-group level population data up to the precinct level. *This aggregation relies on the [maup](https://github.com/mggg/maup) package for Python.

I used 2018 data because 2020 redistricting data was not publicly available at the time of the project in early 2021.

### Setup

Running `02_data_prep.R` generates `data.RData`, which holds the shapefile data as well as other helpful prerequisites for redistricting.

All of the intermediate `.RData` files are stored in the `data/` dir.

### Running Redistricting Algorithms

I compare two different redistricting algorithms, CRSG and SMC, both of which are implemented by the [redist v2.0-2](https://github.com/alarm-redist/redist/releases/tag/v2.0-2) R package.

1. `10_crsg.R` runs the CRSG algorithm. Output stored in `crsg.RData`.
2. `11_smc.R` runs 100 simulations of the SMC algorithm. Output stored in `smc.RData`.

### Evaluating Redistricting Plans

These generated redistricting plans can now be evaluated against the existing plans by computing various compactness and partisan fairness measures.

#### Compactness Measures

1. `20_compact_raw.R` computes compactness measures for the CRSG, SMC, and existing districts. Output stored in `compact.raw.RData`.
2. `21_compact_calc.R` takes the raw compactness measures and aggregates them to each simulation. Output store in `compact.calc.RData`.

#### Partisan Fairness Measures

1. `30_fair_raw.R` computes partisan fairness measures for the CRSG, SMC, and existing districts. Output stored in `fair.raw.RData`.
2. `31_fair_calc.R` takes the raw fairness measures and aggregates them to each simulation. Output stored in `fair.csv`.

### Generate Figures

* `40_fig_seatsvotes.R` takes the raw fairness measures and computes seats-votes curves for each proposal. Plots must be manually exported in RStudio. Subfigures put together in `paper/results/seatsvotes.tex`.*Generating the seats-votes curves relies on my modified version of the [pscl](https://github.com/madeleinegoertz/pscl/) package for R, which can be installed via `install_github(madeleinegoertz/pscl)` from the `devtools` package.

* `41_fig_compact_density.R` takes the calculated compactness measures and generates density distributions for each compactness measure for each algorithm. Figure written to `paper/img/compact.density.png`.

* `42_fig_fair_density.R` takes the calculated fairness measures and generates density distributions for each partisan fairness measure for each algorithm. Figure written to `paper/img/fair.density.png`.

## Report Materials

### Paper

The paper is typeset using LaTeX, which can be accomplished by building `paper/paper.tex`. The final pdf of the paper is located at `paper/paper.pdf`.

### Presentation

The visuals for my oral presentation were put together using PowerPoint, and can be found in the `presentation/` directory.

### Sources

The sources and respective notes consulted in this project can be found in this [Zotero library](https://www.zotero.org/groups/2728121/ap-research-redistricting/tags/cited/library). Select PDFs for cited research papers can be found in the `sources/` directory.
