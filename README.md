# 3:1 Nesting in Redistricting 

## Replicating our Results
In order to replicate our results, you can either start with the file `1_preprocessing.py` or with `2a_biased_house_maps.py` and `2b_ensemble_analysis.py`. 
The former constructs the necessary dual graphs, while the latter runs our analysis and generates our figures.
We ran these using the bash script `run_python_file.sh`.
The longest run was the `2b` run for Ohio, which took almost 10 days.

## `1_preprocessing.py`
In order to run our MCMC processess, we utilize the package `gerrychain`. This requires us to construct a `json` file that stores the necessary dual graph, along with population and election information.

### Ohio
To construct the house dual graph, we needed the following files: enacted house and senate maps from the Census, 2018 precincts from VEST hosted on RDH, proposed house and senate maps from Ohio Redistricting Commission, and P.L. 94-171 2020 Census block file.
We heavily relied on `maup` to determine how blocks, precincts, and districts nest, and used this to aggregate election and population data.

### Wisconsin
To construct the house dual graph, we needed the following files: enacted house and senate maps from the Census, 2020 wards from MGGG, and P.L. 94-171 2020 Census block file.
We heavily relied on `maup` to determine how blocks, precincts, and districts nest, and used this to aggregate election and population data.
There are a few `NA` errors caused by precincts that have no blocks assigned to them.
In this case, we use the 2010 population data as a stand in.

## Step 2
These two Python files can be run once you have the `json` files. `2a` does our analysis of using short burst to bias house maps, and `2b` does our ensemble analysis of nested maps.
Both files store the runs of our chains using the `pcompress` package.

## Resources
* [RDH](https://redistrictingdatahub.org/)
* [Census](https://www.census.gov/programs-surveys/decennial-census/about/rdo/summary-files.html)
* [MGGG](https://github.com/mggg-states)
* [Ohio Redistricting Commission](https://archive.redistricting.ohio.gov/maps#view-maps)
