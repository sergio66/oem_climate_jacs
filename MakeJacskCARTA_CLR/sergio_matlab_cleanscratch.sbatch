#!/bin/bash

# also try Steves script            rm_scratch_fat_files.sc
# run this with   sbatch --array=1-50 sergio_matlab_cleanscratch.sbatch

#  Name of the job:
#SBATCH --job-name=KCARTA_CLEANSCRATCH

# requeue; if held type scontrol release JOBID
#SBATCH --requeue

#  N specifies that 1 job step is to be allocated per instance of matlab
#SBATCH -N1

#  This specifies the number of cores per matlab session will be
#available for parallel jobs
#SBATCH --cpus-per-task 1

#  Specify the desired partition develop/batch/prod
##SBATCH --partition=batch
#SBATCH --partition=high_mem

#  Specify the qos and run time (format:  dd-hh:mm:ss)

########################################################################
#SBATCH --qos=short+
#SBATCH --time=0:29:00

########################################################################

##  This is in MB, very aggressive but I have been running outta memory
##SBATCH --mem-per-cpu=24000
##  This is in MB, less aggressive
##SBATCH --mem-per-cpu=12000
##  This is in MB, very lean, don;t go below this as java starts crying, good for almost everything
##SBATCH --mem-per-cpu=4000
##  This is in MB, less aggressive
##SBATCH --mem-per-cpu=8000
##  This is in MB, less aggressive
#SBATCH --mem-per-cpu=32000


matlab -singleCompThread -nodisplay -r "rm_scratch_fat_files; exit"


