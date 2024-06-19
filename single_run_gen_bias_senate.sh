#!/bin/bash
#SBATCH --time=02-00:00:00 # days-hh:mm:ss
#SBATCH --nodes=1 # how many computers do we need?
#SBATCH --ntasks-per-node=1 # how many cores per node do we need?
#SBATCH --mem=2G # how many MB of memory do we need (2GB here)

source ~/.bashrc  # need to set up the normal environment.

source /cluster/tufts/mggg/cdonna01/.venv_triple_nest/bin/activate
# cd into the correct directory
cd /cluster/tufts/mggg/cdonna01/triple_nesting/new_code

state=$1
election=$2
party=$3
method=$4
param=$5
log_file=$6

python gen_bias_sen_map.py $state $party $election  $method $param
sacct -j $SLURM_JOB_ID --format=JobID,JobName,Partition,State,ExitCode,Start,End,Elapsed,NCPUS,NNodes,NodeList,ReqMem,MaxRSS,AllocCPUS,Timelimit,TotalCPU >> "$log_file" 2>> "$log_file"