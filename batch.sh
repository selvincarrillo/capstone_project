#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=ecoli_test
#SBATCH --ntasks=1
#SBATCH --time=4:00:00
#SBATCH --mem=2gb


#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=sc33764@uga.edu


cd /scratch/sc33764/capstone_project  # <-- UPDATED: your new main dir


# Run each step of the pipeline
bash setup.sh
bash read_qc.sh
bash variant_calling.sh

