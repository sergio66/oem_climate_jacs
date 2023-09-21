#!/bin/bash

# run this with      kleenslurm; sbatch --exclude=cnode203,cnode260,cnode267 --array=1-48%128 --output='testslurm' sergio_matlab_jobB.sbatch
# run this with      kleenslurm; sbatch --exclude=cnode203,cnode260,cnode267 --array=1-48%128 sergio_matlab_jobB.sbatch 
# run this with      kleenslurm; sbatch --exclude=cnode203,cnode260,cnode267 --array=1-3000%256 --output='/dev/null' sergio_matlab_jobB.sbatch
#
##########################
# run this with      kleenslurm; sbatch -p high_mem --array=1-4608%128 sergio_matlab_jobB.sbatch 1   for clust_tile_fits_quantiles.m OR
# run this with      kleenslurm; sbatch -p high_mem --array=1-4608%128 sergio_matlab_jobB.sbatch 10  for clust_tile_anomalies_quantiles.m OR
#
# run this with      kleenslurm; sbatch -p high_mem --array=1-64       sergio_matlab_jobB.sbatch 2   for clust_tile_fits_quantiles_loop72lons.m  AND
# run this with      kleenslurm; sbatch -p high_mem --array=1-64       sergio_matlab_jobB.sbatch 3   for clust_tile_fits_quantiles_loop72lons_backwards.m 
##########################
#
# run this with      kleenslurm; sbatch -p high_mem --array=1-4608%128 sergio_matlab_jobB.sbatch 4   for clust_tile_fits_extremes.m
# run this with      kleenslurm; sbatch -p high_mem --array=1-4608%128 sergio_matlab_jobB.sbatch 5   for clust_tile_fits_means.m
# run this with      kleenslurm; sbatch -p high_mem --array=1-64 sergio_matlab_jobB.sbatch 6         for clust_zonalavg_fits_quantiles.m

#  Name of the job:
#SBATCH --job-name=FIT_TILE_TRENDS

#  N specifies that 1 job step is to be allocated per instance of
#matlab
#SBATCH -N1

#  This specifies the number of cores per matlab session will be
#available for parallel jobs
#SBATCH --cpus-per-task 1

#  Specify the desired partition develop/batch/prod
#SBATCH --partition=cpu2021
##SBATCH --partition=batch
##SBATCH --partition=strow

## this is for choices 3,4
##SBATCH --qos=medium+
##SBATCH --time=7:59:00 
##SBATCH --mem-per-cpu=8000

## this is for choices 1,2,10
#SBATCH --qos=short+
#SBATCH --time=00:59:00 

########################################################################
# for most things # 1,2,3,10
#SBATCH --mem-per-cpu=16000

# for #4 clust_zonalavg_fits_quantiles since we read in a lot of stuff
##SBATCH --mem-per-cpu=32000

########################################################################
### check the number of input arguments
if [ $# -gt 0 ]; then
  echo "Your command line contains $# arguments"
elif [ $# -eq 0 ]; then
  echo "Your command line contains no arguments"
fi
########################################################################

if [[ "$1" -eq "" ]]; then
  echo "cmd line arg = DNE, generic run to fit trends"
  /usr/ebuild/software/MATLAB/2021b/bin/matlab -nodisplay -nosplash -r "iAllorSeason = +1; clust_tile_fits_quantiles; exit"
elif [[ "$1" -eq "1" ]]; then
  echo "cmd line arg = 1, generic run to fit trends"
  /usr/ebuild/software/MATLAB/2021b/bin/matlab -nodisplay -nosplash -r "iAllorSeason = +1; clust_tile_fits_quantiles; exit"
elif [[ "$1" -eq "10" ]]; then
  echo "cmd line arg = 10, anomalies"
  /usr/ebuild/software/MATLAB/2021b/bin/matlab -nodisplay -nosplash -r "iAllorSeason = +1; clust_tile_anomalies_quantiles; exit"
elif [[ "$1" -eq "2" ]]; then
  /usr/ebuild/software/MATLAB/2021b/bin/matlab -nodisplay -nosplash -r "clust_tile_fits_quantiles_loop72lons; exit"
elif [[ "$1" -eq "3" ]]; then
  /usr/ebuild/software/MATLAB/2021b/bin/matlab -nodisplay -nosplash -r "clust_tile_fits_quantiles_loop72lons_backwards; exit"
elif [[ "$1" -eq "4" ]]; then
  /usr/ebuild/software/MATLAB/2021b/bin/matlab -nodisplay -nosplash -r "clust_tile_fits_extremes; exit"
elif [[ "$1" -eq "5" ]]; then
  /usr/ebuild/software/MATLAB/2021b/bin/matlab -nodisplay -nosplash -r "clust_tile_fits_means; exit"
elif [[ "$1" -eq "6" ]]; then
  /usr/ebuild/software/MATLAB/2021b/bin/matlab -nodisplay -nosplash -r "iAorOorL = -1; clust_zonalavg_fits_quantiles; exit"
fi
