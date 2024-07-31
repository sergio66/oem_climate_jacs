#!/bin/bash

########################################################################
# NOTE 460 = 23 * 20 = number of timesteps so far since 2002/09/01 that Howard has made, so this will increase by 23 each year
# first this with   sbatch -p high_mem --array=1-4608%16   sergio_matlab_jobB.sbatch 1      for clust_driver_compute_AMSU_BT_20years_ERA5.m
# first this with   sbatch -p high_mem --array=1-4608%8    sergio_matlab_jobB.sbatch 2      for clust_driver_AMSU_jacs.m

# first this with   sbatch -p high_mem --array=1-4608      sergio_matlab_jobB.sbatch 1      for clust_driver_compute_AMSU_BT_20years_ERA5.m
# first this with   sbatch -p high_mem --array=1-4608      sergio_matlab_jobB.sbatch 2      for clust_driver_AMSU_jacs.m

########################################################################

#  Name of the job:
#SBATCH --job-name=MAKE_16day_avg

#  N specifies that 1 job step is to be allocated per instance of
#matlab
#SBATCH -N1

#  This specifies the number of cores per matlab session will be
#available for parallel jobs
#SBATCH --cpus-per-task 1

#  Specify the desired partition develop/batch/prod
#SBATCH --partition=batch
#SBATCH --partition=cpu2021
##SBATCH --partition=strow

## this is for choices 0,1,2,5,7
##SBATCH --qos=medium+
##SBATCH --time=15:59:00 
##SBATCH --mem-per-cpu=8000

## this is for choices 3,6,14
##SBATCH --qos=short+
##SBATCH --time=00:59:00 
##SBATCH --mem-per-cpu=16000

## this is for choices 12 = extremes
##SBATCH --qos=medium+
##SBATCH --time=07:59:00 
##SBATCH --mem-per-cpu=24000

## this is for choices 11,13
##SBATCH --qos=medium+
##SBATCH --time=05:59:00 
##SBATCH --mem-per-cpu=12000

#########################
## this is for choices 10 = quantiles
##SBATCH --qos=medium+
##SBATCH --time=23:59:00 
##SBATCH --mem-per-cpu=24000
#########################

## this is for choices 3,6,11,14
#SBATCH --qos=medium+
#SBATCH --time=03:59:00 
##SBATCH --mem-per-cpu=16000
#SBATCH --mem-per-cpu=10000

########################################################################
### check the number of input arguments
if [ $# -gt 0 ]; then
  echo "Your command line contains $# arguments"
elif [ $# -eq 0 ]; then
  echo "Your command line contains no arguments"
fi
########################################################################

if [[ "$1" -eq "" ]]; then
  echo "cmd line arg = DNE, generic run"
  matlab -nodisplay -r "clust_driver_compute_AMSU_BT_20years_ERA5; exit"
elif [[ "$1" -eq "1" ]]; then
  matlab -nodisplay -r "clust_driver_compute_AMSU_BT_20years_ERA5; exit"
elif [[ "$1" -eq "2" ]]; then
  matlab -nodisplay -r "clust_driver_AMSU_jacs; exit"
fi
