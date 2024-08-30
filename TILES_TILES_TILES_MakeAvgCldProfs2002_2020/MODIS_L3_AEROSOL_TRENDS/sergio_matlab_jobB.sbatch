#!/bin/bash

# after launchung job watch squeue -u sergio
#
# or check_progress.sc
#
# run this with   sbatch -p high_mem --array=1-262 sergio_matlab_jobB.sbatch 1     clouds
# run this with   sbatch -p high_mem --array=1-262 sergio_matlab_jobB.sbatch 2     aerosols
# run this with   sbatch -p high_mem --array=1-262 sergio_matlab_jobB.sbatch 3     clouds combined T/A

#  Name of the job:
#SBATCH --job-name=MODISL3_DRIVER

# requeue; if held type scontrol release JOBID
#SBATCH --requeue

#  N specifies that 1 job step is to be allocated per instance of matlab
#SBATCH -N1

#  This specifies the number of cores per matlab session will be
#available for parallel jobs
#SBATCH --cpus-per-task 1

#SBATCH --account=pi_strow

#  Specify the desired partition develop/batch/prod
##SBATCH --partition=batch
## can shorthand this as -p high_mem on the command line
#SBATCH --partition=high_mem

########################################################################
#  Specify the qos and run time (format:  dd-hh:mm:ss)

#SBATCH --qos=short+
#SBATCH --time=0:59:00

########################################################################

##  This is in MB, less aggressive
#SBATCH --mem-per-cpu=16000

########################################################################

if [ $# -gt 0 ]; then
  echo "Your command line contains $# arguments"
elif [ $# -eq 0 ]; then
  echo "Your command line contains no arguments"
fi

##  Specify the job array (format:  start-stop:step)
## DO NOT USE srun matlab -nodisplay -r "clust_do_kcarta_driver; exit"   but instead matlab -nodisplay -r "clust_do_kcarta_driver; exit" 

if [[ "$1" -eq "" ]]; then
  # this is clouds
  matlab -nodisplay -r "clust_modis_cloud_L3; exit"
elif [[ "$1" -eq "1" ]]; then
  # this is clouds
  matlab -nodisplay -r "clust_modis_cloud_L3; exit"
elif [[ "$1" -eq "2" ]]; then
  # this is aerosols
  matlab -nodisplay -r "clust_modis_aerosol_L3; exit"
elif [[ "$1" -eq "3" ]]; then
  # this is combined Terra/Aqua clouds
  matlab -nodisplay -r "clust_modis_combinedTA_cloud_L3; exit"
fi
