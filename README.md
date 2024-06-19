# 3:1 Nesting in Redistricting 

## Replicating our Results
Significant improvements to the gerrychain codebase, usage of a cluster, as well as helpful suggestions from a reviewer resulted in changes to both underlying code and figures between the arxiv preprint and journal version. Old code and figures can be found in the "Arxiv Draft" folder. the various *.sh files are bash scripts used to run code in a cluster.

## Preprocessing
### `1_preprocessing.py`
In order to run our MCMC processess, we utilize the package `gerrychain`. This requires us to construct a `json` file that stores the necessary dual graph, along with population and election information.

#### Ohio
To construct the house dual graph, we needed the following files: enacted house and senate maps from the Census, 2018 precincts from VEST hosted on RDH, proposed house and senate maps from Ohio Redistricting Commission, and P.L. 94-171 2020 Census block file.
We heavily relied on `maup` to determine how blocks, precincts, and districts nest, and used this to aggregate election and population data.

#### Wisconsin
To construct the house dual graph, we needed the following files: enacted house and senate maps from the Census, 2020 wards from MGGG States, and P.L. 94-171 2020 Census block file.
We heavily relied on `maup` to determine how blocks, precincts, and districts nest, and used this to aggregate election and population data.
There are a few `NA` errors caused by precincts that have no blocks assigned to them.
In this case, we use the 2010 population data as a stand in.

## Neutral Senate Ensembles
The file 
- `2b_figs.py` generates the figures that analyze convergence and distributions of neutral senate ensembles given that the chaisn were already saved by `pcompress` and the file `2b_ensemble_analysis.py` was run.

## Mitigating Gerrymandering
The following code files were used to generate biased house and senate maps, as well as run neutral chains on top of biased house maps:

- `gen_bias_house_map.py` creates biased house maps for a given party using tilt or short burst and ReCom on precincts. `analysis_bias_house.ipynb` gives the best settings for optimization once chains are complete.
- `gen_bias_sen_map.py` creates biased senate maps for a given party using tilt or short burst and ReCom on precincts. `analysis_bias_senate.ipynb` gives the best settings for optimization once chains are complete.
- `optimize_sen_bias.py` creates biased senate maps for a given party using tilt or short burst and Swap on a biased house map produced by `gen_bias_house_map.py`. `analysis_bias_senate.ipynb` gives the best settings for optimization once chains are complete.
- `neutral_senate_on_bias_house.py` generates a neutral senate ensemble on top of a biased house map produced by `gen_bias_house_map.py`. `neutral_senate_on_bias_house_figs.py` then generates the relevant histogram figures.

## Resources
* [RDH](https://redistrictingdatahub.org/)
* [Census](https://www.census.gov/programs-surveys/decennial-census/about/rdo/summary-files.html)
* [MGGG States](https://github.com/mggg-states)
* [Ohio Redistricting Commission](https://archive.redistricting.ohio.gov/maps#view-maps)
* [Gerrychain](https://gerrychain.readthedocs.io/en/latest/index.html)


### Old Repo Instructions
In order to replicate our results, you can either start with the file `1_preprocessing.py` or with `2a_biased_house_maps.py` and `2b_ensemble_analysis.py`. 
The former constructs the necessary dual graphs, while the latter runs our analysis and generates our figures.
We ran these using the bash script `run_python_file.sh`.
The longest run was the `2b` run for Ohio, which took almost 10 days.
All files needed to run our code are included here, except the Census block files, which are too big to store on github.
You can read more about reproducing `gerrychain` code in the [documentation](https://gerrychain.readthedocs.io/en/latest/topics/reproducibility.html).

### `1_preprocessing.py`
In order to run our MCMC processess, we utilize the package `gerrychain`. This requires us to construct a `json` file that stores the necessary dual graph, along with population and election information.

#### Ohio
To construct the house dual graph, we needed the following files: enacted house and senate maps from the Census, 2018 precincts from VEST hosted on RDH, proposed house and senate maps from Ohio Redistricting Commission, and P.L. 94-171 2020 Census block file.
We heavily relied on `maup` to determine how blocks, precincts, and districts nest, and used this to aggregate election and population data.

#### Wisconsin
To construct the house dual graph, we needed the following files: enacted house and senate maps from the Census, 2020 wards from MGGG States, and P.L. 94-171 2020 Census block file.
We heavily relied on `maup` to determine how blocks, precincts, and districts nest, and used this to aggregate election and population data.
There are a few `NA` errors caused by precincts that have no blocks assigned to them.
In this case, we use the 2010 population data as a stand in.

### Step 2
These two Python files can be run once you have the `json` files. `2a` does our analysis of using short burst to bias house maps, and `2b` does our ensemble analysis of nested maps.
Both files store the runs of our chains using the `pcompress` package.


  
