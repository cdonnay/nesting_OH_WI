#!/usr/bin/env bash

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=28G


ml miniconda3
source activate nesting

# makes code reproduceable
export PYTHONHASHSEED=0

# -u stands for unbuffered, prints to output line by line
/home/donnay.1/.conda/envs/nesting/bin/python -u $@ 
