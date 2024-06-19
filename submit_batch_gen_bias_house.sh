#!/bin/bash

# This script is meant to act as a sentinel to submit
# jobs to the slurm scheduler. The main idea is that the
# running script will be the one that calls the process
# that takes up the most time 



# ==============
# JOB PARAMETERS
# ==============

# This is the identifier that slurm will use to help
# keep track of the jobs. Please make sure that this
# does not exceed 80 characters.
job_name="gen_bias_house_$(date '+%d-%m-%Y@%H:%M:%SET')"

# This controls how many jobs the scheduler will
# see submitted at the same time.
max_concurrent_jobs=500

# This is the name of the script that will be run
# to actually process all of the files and do the 
# you may need to modify the call to this script
# on line 167 or so
running_script_name="single_run_gen_bias_house.sh"


# ==================
# RUNNING PARAMETERS
# ==================
log_dir="logs"
states=("OH" "WI")
bias_parties=("Dem" "Rep")
opt_methods=("tilt" "burst")
#elections = #conditioned on state later
#opt_parameters = #conditioned on method later




# ===============================================================
# Ideally, you should not need to modify anything below this line
# However, you may need to modify the call on line 167
# ===============================================================

mkdir -p "${log_dir}"

job_ids=()
job_index=0

echo "========================================================"
echo "The job name is: $job_name"
echo "========================================================"

# This function will generate a label for the log and output file
generate_file_label() {
    local state="$1"
    local party="$2"
    local election="$3"
    local method="$4"
    local param="$5"


    # Use string substistution to replace spaces with dashes
    # This will make the files nicer to work with in the command line
    echo "${state// /-}"\
        "${party// /-}"\
        "${election// /-}"\
        "${method// /-}"\
        "_${param// /-}"\
        | tr ' ' '_'
    # The tr command replaces spaces with underscores so that
    # the file names are a bit nicer to read
}

# Indentation modified for readability

for state in "${states[@]}"; do
if [ "$state" == "OH" ]; then
    elections=("SEN18" "TRES18")
else
    elections=("SEN18" "AG18")
fi
for election in "${elections[@]}"; do
for party in "${bias_parties[@]}"; do
for method in "${opt_methods[@]}"; do
if [ "$method" == "tilt" ]; then
    params=(.1 .05 .01 .005 .001 .0005 .0001)
else
    params=(7 8 9 10 11 12 13)
fi
for param in "${params[@]}"; do

    file_label=$(generate_file_label \
        "$state" \
        "$election" \
        "$party" \
        "$method" \
        "$param" 
    )
    
    log_file="${log_dir}/${file_label}.log"

    # Waits for the current number of running jobs to be
    # less than the maximum number of concurrent jobs
    while [[ ${#job_ids[@]} -ge $max_concurrent_jobs ]] ; do
        # Check once per minute if there are any open slots
        sleep 60
        # We check for the job name, and make sure that squeue prints
        # the full job name up to 100 characters
        job_count=$(squeue --name=$job_name --Format=name:100 | grep $job_name | wc -l)
        if [[ $job_count -lt $max_concurrent_jobs ]]; then
            break
        fi
    done

    # Some logging for the 
    for job_id in "${job_ids[@]}"; do
        if squeue -j $job_id 2>/dev/null | grep -q $job_id; then
            continue
        else
            job_ids=(${job_ids[@]/$job_id})
            echo "Job $job_id has finished or exited."
        fi
    done

    # This output will be of the form "Submitted batch job 123456"
    job_output=$(sbatch --job-name=${job_name} \
        --output="${log_file}" \
        --error="${log_file}" \
        $running_script_name \
            "$state" \
            "$election" \
            "$party" \
            "$method" \
            "$param" \
            "$log_file"
    )
    # Extract the job id from the output. The awk command
    # will print the last column of the output which is
    # the job id in our case
    # 
    # Submitted batch job 123456
    #                     ^^^^^^
    job_id=$(echo "$job_output" | awk '{print $NF}')
    echo "Job output: $job_output"
    # Now we add the job id to the list of running jobs
    job_ids+=($job_id)
    # Increment the job index. Bash allows for sparse
    # arrays, so we don't need to worry about any modular arithmetic
    # nonsense
    job_index=$((job_index + 1))
done
done
done
done
done


# This is just a helpful logging line to let us know that all jobs have been submitted
# and to tell us what is still left to be done
printf "No more jobs need to be submitted. The queue is\n%s\n" "$(squeue --name=$job_name)"
# Check once per minute until the job queue is empty
while [[ ${#job_ids[@]} -gt 0 ]]; do
    sleep 60
    for job_id in "${job_ids[@]}"; do
        if squeue -j $job_id 2>/dev/null | grep -q $job_id; then
            continue
        else
            job_ids=(${job_ids[@]/$job_id})
            echo "Job $job_id has finished or exited."
        fi
    done

    job_ids=("${job_ids[@]}")
done

echo "All jobs have finished."