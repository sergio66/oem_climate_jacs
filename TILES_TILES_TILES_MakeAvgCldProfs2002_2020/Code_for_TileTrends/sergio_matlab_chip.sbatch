#!/bin/bash

# run this with      kleenslurm; sbatch --exclude=cnode203,cnode260,cnode267 --array=1-48%128 --output='testslurm' sergio_matlab_chip.sbatch
# run this with      kleenslurm; sbatch --exclude=cnode203,cnode260,cnode267 --array=1-48%128 sergio_matlab_chip.sbatch 
# run this with      kleenslurm; sbatch --exclude=cnode203,cnode260,cnode267 --array=1-3000%256 --output='/dev/null' sergio_matlab_chip.sbatch
#
##########################
# run this with      kleenslurm; sbatch -p 2024 --array=1-4608%128 sergio_matlab_chip.sbatch 1   for clust_tile_fits_quantiles.m OR
# run this with      kleenslurm; sbatch -p 2024 --array=1-4608%128 sergio_matlab_chip.sbatch 10  for clust_tile_anomalies_quantiles.m OR
#
#     OR    OR      OR    OR      OR    OR      OR    OR      OR    OR      OR    OR      OR    OR      OR    OR      OR    OR      OR    OR      OR    OR      OR    OR 
#
# run this with      kleenslurm; sbatch -p 2024 --array=1-64       sergio_matlab_chip.sbatch 2   for clust_tile_fits_quantiles_loop72lons.m  AND
# run this with      kleenslurm; sbatch -p 2024 --array=1-64       sergio_matlab_chip.sbatch 3   for clust_tile_fits_quantiles_loop72lons_backwards.m 
##########################
#
# run this with      kleenslurm; sbatch -p 2024 --array=1-4608%128 sergio_matlab_chip.sbatch 4   for clust_tile_fits_extremes.m
# run this with      kleenslurm; sbatch -p 2024 --array=1-4608%128 sergio_matlab_chip.sbatch 5   for clust_tile_fits_means.m
# run this with      kleenslurm; sbatch -p 2024 --array=1-64 sergio_matlab_chip.sbatch 6         for clust_zonalavg_fits_quantiles.m

########################################################################

# run this with sbatch --array=1-204 sergio_matlab_chip.sbatch      not 240 since we stopped era-I match in 2019

#SBATCH --job-name=FIT_TILE_TRENDS    ## name
#SBATCH -N1                           ## number of job step is to be allocated per instance of matlab
#SBATCH --cpus-per-task 1             ## tasks per node/number of cores per matlab session will be

##SBATCH --partition=2024              ## desired partition
#SBATCH --partition=match             ## desired partition
#SBATCH --cluster=chip-cpu            ## desired cluster
#SBATCH --account=pi_strow
#SBATCH --qos=shared                  ## qos to get as many cpu2024 as possible, else put pi_strow

########################################################################

## this is for choices 3,4
##SBATCH --qos=medium+
##SBATCH --time=7:59:00 
##SBATCH --mem-per-cpu=8000

## this is for choices 1,2,10
##SBATCH --qos=short+
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
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab -nodisplay -nosplash -r "iAllorSeason = +1; clust_tile_fits_quantiles; exit"
elif [[ "$1" -eq "1" ]]; then
  echo "cmd line arg = 1, generic run to fit trends"
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab -nodisplay -nosplash -r "iAllorSeason = +1; clust_tile_fits_quantiles; exit"
elif [[ "$1" -eq "2" ]]; then
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab -nodisplay -nosplash -r "clust_tile_fits_quantiles_loop72lons; exit"
elif [[ "$1" -eq "3" ]]; then
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab -nodisplay -nosplash -r "clust_tile_fits_quantiles_loop72lons_backwards; exit"
elif [[ "$1" -eq "10" ]]; then
  echo "cmd line arg = 10, anomalies"    
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab -nodisplay -nosplash -r "iAllorSeason = +1; clust_tile_anomalies_quantiles; exit"
#  
elif [[ "$1" -eq "4" ]]; then
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab -nodisplay -nosplash -r "clust_tile_fits_extremes; exit"
elif [[ "$1" -eq "5" ]]; then
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab -nodisplay -nosplash -r "clust_tile_fits_means; exit"
elif [[ "$1" -eq "6" ]]; then
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab -nodisplay -nosplash -r "iAorOorL = -1; clust_zonalavg_fits_quantiles; exit"
fi
