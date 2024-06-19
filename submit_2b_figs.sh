#!/bin/bash
#SBATCH --time=00-4:00:00 # days-hh:mm:ss
#SBATCH --nodes=1 # how many computers do we need?
#SBATCH --ntasks-per-node=1 # how many cores per node do we need?
#SBATCH --mem=31G # how many MB of memory do we need (2GB here)

source ~/.bashrc  # need to set up the normal environment.

source /cluster/tufts/mggg/cdonna01/.venv_triple_nest/bin/activate
# cd into the correct directory
cd /cluster/tufts/mggg/cdonna01/triple_nesting/new_code

state=$1
python 2b_figs.py $state