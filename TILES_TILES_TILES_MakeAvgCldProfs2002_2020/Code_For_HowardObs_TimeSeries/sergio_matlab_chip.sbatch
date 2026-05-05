#!/bin/bash

# mostly unused
# run this with sbatch --exclude=cnode203,cnode260,cnode267 --array=1-48%128 --output='testslurm' sergio_matlab_chip.sbatch
# run this with sbatch --exclude=cnode203,cnode260,cnode267 --array=1-48%128 sergio_matlab_chip.sbatch 
# run this with sbatch --exclude=cnode203,cnode260,cnode267 --array=1-3000%256 --output='/dev/null' sergio_matlab_chip.sbatch
#
# run this with sbatch --array=1-360%128 sergio_matlab_chip.sbatch 1   for clust_make_profs_data
# run this with sbatch --array=1-360%128 sergio_matlab_chip.sbatch 2   for clust_make_profs_data_howard_bins
# run this with sbatch --array=1-360%128 sergio_matlab_chip.sbatch 3   for cluster_anomaly_and_trends_16day_calcs_howard
# mostly unused

########################################################################
########################################################################
# NOTE 460 = 23 * 20 = number of timesteps so far since 2002/09/01 that Howard has made, so this will increase by 23 each year
# first this with   sbatch -p 2024 --array=1-460%16   sergio_matlab_chip.sbatch 10      for clust_check_howard_16daytimesetps_2013_raw_griddedV2 -- used this for quantiles for AIRS STM May 2021 
# first this with   sbatch -p 2024 --array=1-460%8    sergio_matlab_chip.sbatch 10      for clust_check_howard_16daytimesetps_2013_raw_griddedV2
# first this with   sbatch -p 2024 --array=1-479%8    sergio_matlab_chip.sbatch 10      for clust_check_howard_16daytimesetps_2013_raw_griddedV2, 2002/09-2023/07
# first this with   sbatch -p 2024 --array=479-490%8  sergio_matlab_chip.sbatch 10      for clust_check_howard_16daytimesetps_2013_raw_griddedV2, 2023/07-2023/12
# first this with   sbatch -p 2024 --array=500-530%8  sergio_matlab_chip.sbatch 10      for clust_check_howard_16daytimesetps_2013_raw_griddedV2, 2023/12-2025/08
# NOTE 460 = 23 * 20 = number of timesteps so far since 2002/09/01 that Howard has made, so this will increase by 23 each year
# then this with    sbatch -p 2024 --array=1-64     sergio_matlab_chip.sbatch 11           for cluster_loop_make_correct_timeseriesV2
# then this with    sbatch         --array=1-64     sergio_matlab_chip.sbatch 11           for cluster_loop_make_correct_timeseriesV2
########################################################################
#########################################################################

########################################################################
# run this with sbatch -p 2024 --array=1-4608%16 sergio_matlab_chip.sbatch 12  for clust_check_howard_16daytimesetps_2013_raw_griddedV3 -- used this for extremens, but can also do quantiles
# run this with sbatch             --array=1-4608%8  sergio_matlab_chip.sbatch 12  for clust_check_howard_16daytimesetps_2013_raw_griddedV3
# run this with sbatch             --array=1-4608    sergio_matlab_chip.sbatch 12  for clust_check_howard_16daytimesetps_2013_raw_griddedV3
# run this with sbatch -p 2024 --array=1-64      sergio_matlab_chip.sbatch 13  for cluster_loop_make_correct_timeseriesV3
# run this with sbatch             --array=1-64      sergio_matlab_chip.sbatch 13  for cluster_loop_make_correct_timeseriesV3
########################################################################
#
########################################################################
# run this with sbatch             --array=1-64     sergio_matlab_chip.sbatch 14  for clust_make_ecmwf_or_era_16days_tile
# run this with sbatch             --array=1-32%8   sergio_matlab_chip.sbatch 15  for clust_tile_3x5_TO_1x1.m, INDIA = 4 lonbis x 8 latbins -- reading in tiles so only do 8 per time
########################################################################
# run this with sbatch             --array=1-4608%8   sergio_matlab_chip.sbatch 16  for clust_driver_get_timeseries_dcc_one_tile.m
########################################################################
########################################################################
########################################################################

#SBATCH --job-name=MAKE_16day_avg     ## name
#SBATCH -N1                           ## number of job step is to be allocated per instance of matlab
#SBATCH --cpus-per-task 1             ## tasks per node/number of cores per matlab session will be

#SBATCH --cluster=chip-cpu            ## desired cluster
#SBATCH --account=pi_strow            ## cpu owner
#SBATCH --partition=2024              ## desired partition
#SBATCH --qos=shared                  ## qos to get as many cpu2024 as possible, else put pi_strow

########################################################################

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
#SBATCH --time=23:59:00 
#SBATCH --mem-per-cpu=24000
#########################

#########################
## this is for choices 3,6,11,14
###SBATCH --mem-per-cpu=16000
##SBATCH --qos=medium+
##SBATCH --time=03:59:00 
##SBATCH --mem-per-cpu=10000
#########################

########################################################################
### check the number of input arguments
if [ $# -gt 0 ]; then
  echo "Your command line contains $# arguments"
elif [ $# -eq 0 ]; then
  echo "Your command line contains no arguments"
fi
########################################################################

#### -nojvm kills code which try to plot
####   /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab -nojvm -nodisplay -r
#### so re-write to
####   /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab -nodisplay -r

if [[ "$1" -eq "" ]]; then
  echo "cmd line arg = DNE, generic run"
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab  -nodisplay -r "clust_make_profs_data; exit"
elif [[ "$1" -eq "1" ]]; then
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab  -nodisplay -r "clust_make_profs_data; exit"
######
elif [[ "$1" -eq "2" ]]; then
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab  -nodisplay -r "clust_make_profs_data_howard_bins; exit"
elif [[ "$1" -eq "3" ]]; then
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab  -nodisplay -r "cluster_anomaly_and_trends_16day_calcs_howard; exit"
elif [[ "$1" -eq "4" ]]; then
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab  -nodisplay -r "cluster_make_calcs_profile_trends; exit"
######
elif [[ "$1" -eq "5" ]]; then
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab  -nodisplay -r "clust_make_profs_data_howard_bins_startSept2002; exit"
elif [[ "$1" -eq "6" ]]; then
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab  -nodisplay -r "clust_gather_pall_howardV3_startSept2002; exit"
######
elif [[ "$1" -eq "7" ]]; then
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab  -nodisplay -r "clust_make_profs_data_howard_bins_OneYearStartJan1; exit"
elif [[ "$1" -eq "8" ]]; then
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab  -nodisplay -r "clust_make_profs_data_howard_bins_OneYearStartJan1_Desc; exit"
elif [[ "$1" -eq "9" ]]; then
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab  -nodisplay -r "clust_make_profs_data_howard_bins_OneYearStartJan1_Asc; exit"
##
######## NOV 2020 : gather howards stats and put them into files, need mucho memory and 4 hours, 400 timesteps -- then read all files and concat the timesteps together
######## NOV 2020 : gather howards stats and put them into files, need mucho memory and 4 hours, 400 timesteps -- then read all files and concat the timesteps together
######## NOV 2020 : gather howards stats and put them into files, need mucho memory and 4 hours, 400 timesteps -- then read all files and concat the timesteps together
## sbatch -p 2024 --array=1-400%16 sergio_matlab_chip.sbatch 10
elif [[ "$1" -eq "10" ]]; then
  echo "clust_check_howard_16daytimesetps_2013_raw_griddedV2 : Quantile only"
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab  -nodisplay -r "clust_check_howard_16daytimesetps_2013_raw_griddedV2; exit"
######## NOV 2020 : gather howards stats and put them into files, need mucho memory and 4 hours, 400 timesteps -- then read all files and concat the timesteps together
######## NOV 2020 : gather howards stats and put them into files, need mucho memory and 4 hours, 400 timesteps -- then read all files and concat the timesteps together
######## NOV 2020 : gather howards stats and put them into files, need mucho memory and 4 hours, 400 timesteps -- then read all files and concat the timesteps together
## sbatch --array=1-64 sergio_matlab_chip.sbatch 11
elif [[ "$1" -eq "11" ]]; then
  echo "cluster_loop_make_correct_timeseriesV2 : FIX Quantile, All or eXtremes"
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab  -nodisplay -r "cluster_loop_make_correct_timeseriesV2; exit"
######## NOV 2020 : gather howards stats and put them into files, need mucho memory and 4 hours, 400 timesteps -- then read all files and concat the timesteps together
######## NOV 2020 : gather howards stats and put them into files, need mucho memory and 4 hours, 400 timesteps -- then read all files and concat the timesteps together
######## NOV 2020 : gather howards stats and put them into files, need mucho memory and 4 hours, 400 timesteps -- then read all files and concat the timesteps together
##
## sbatch -p 2024 --array=1-400%16 sergio_matlab_chip.sbatch 12
elif [[ "$1" -eq "12" ]]; then
  echo "clust_check_howard_16daytimesetps_2013_raw_griddedV3 : set iQAX to do Quantile, All or eXtremes"
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab  -nodisplay -r "clust_check_howard_16daytimesetps_2013_raw_griddedV3; exit"
## sbatch --array=1-64 sergio_matlab_chip.sbatch 13
elif [[ "$1" -eq "13" ]]; then
  echo "cluster_loop_make_correct_timeseriesV3 : set iQAX to FIX Quantile, All or eXtremes"
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab  -nodisplay -r "cluster_loop_make_correct_timeseriesV3; exit"
#
elif [[ "$1" -eq "14" ]]; then
  echo "clust_make_ecmwf_or_era_16days_tile.m : to make 16day match to ERA, to check how good the quantiles"
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab  -nodisplay -r "iForward = +1; clust_make_ecmwf_or_era_16days_tile; exit"
elif [[ "$1" -eq "15" ]]; then
  echo "clust_tile_3x5_TO_1x1 : to make 6 subgrids per tile"
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab  -nodisplay -r "clust_tile_3x5_TO_1x1; exit"
#
elif [[ "$1" -eq "16" ]]; then
  echo "clust_driver_get_timeseries_dcc_one_tile.m : to see iof there are more DCC after 2021"
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab  -nodisplay -r "clust_driver_get_timeseries_dcc_one_tile; exit"  
fi
