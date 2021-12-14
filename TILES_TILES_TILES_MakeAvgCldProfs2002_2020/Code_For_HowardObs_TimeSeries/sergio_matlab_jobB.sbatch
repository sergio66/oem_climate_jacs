#!/bin/bash

# run this with sbatch --exclude=cnode203,cnode260,cnode267 --array=1-48%128 --output='testslurm' sergio_matlab_jobB.sbatch
# run this with sbatch --exclude=cnode203,cnode260,cnode267 --array=1-48%128 sergio_matlab_jobB.sbatch 
# run this with sbatch --exclude=cnode203,cnode260,cnode267 --array=1-3000%256 --output='/dev/null' sergio_matlab_jobB.sbatch
#
# run this with sbatch --array=1-360%128 sergio_matlab_jobB.sbatch 1   for clust_make_profs_data
# run this with sbatch --array=1-360%128 sergio_matlab_jobB.sbatch 2   for clust_make_profs_data_howard_bins
# run this with sbatch --array=1-360%128 sergio_matlab_jobB.sbatch 3   for cluster_anomaly_and_trends_16day_calcs_howard
#
# run this with sbatch -p high_mem --array=1-400%16 sergio_matlab_jobB.sbatch 10  for clust_check_howard_16daytimesetps_2013_raw_griddedV2 -- used this for quantiles for AIRS STM May 2021
# run this with sbatch             --array=1-400%8  sergio_matlab_jobB.sbatch 10  for clust_check_howard_16daytimesetps_2013_raw_griddedV2
# run this with sbatch -p high_mem --array=1-64     sergio_matlab_jobB.sbatch 11  for cluster_loop_make_correct_timeseriesV2
# run this with sbatch             --array=1-64     sergio_matlab_jobB.sbatch 11  for cluster_loop_make_correct_timeseriesV2
#
# run this with sbatch -p high_mem --array=1-440%16 sergio_matlab_jobB.sbatch 12  for clust_check_howard_16daytimesetps_2013_raw_griddedV3 -- used this for extremens, but can also do quantiles
# run this with sbatch             --array=1-440%8  sergio_matlab_jobB.sbatch 12  for clust_check_howard_16daytimesetps_2013_raw_griddedV3
# run this with sbatch -p high_mem --array=1-64     sergio_matlab_jobB.sbatch 13  for cluster_loop_make_correct_timeseriesV3
# run this with sbatch             --array=1-64     sergio_matlab_jobB.sbatch 13  for cluster_loop_make_correct_timeseriesV3

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

## this is for choices 3,6
##SBATCH --qos=short+
##SBATCH --time=00:59:00 
##SBATCH --mem-per-cpu=16000

## this is for choices 10 = quantiles
##SBATCH --qos=medium+
##SBATCH --time=23:59:00 
##SBATCH --mem-per-cpu=24000

## this is for choices 12 = extremes
##SBATCH --qos=medium+
##SBATCH --time=07:59:00 
##SBATCH --mem-per-cpu=24000

## this is for choices 11,13
#SBATCH --qos=medium+
#SBATCH --time=05:59:00 
#SBATCH --mem-per-cpu=12000

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
  matlab -nodisplay -r "clust_make_profs_data; exit"
elif [[ "$1" -eq "1" ]]; then
  matlab -nodisplay -r "clust_make_profs_data; exit"
######
elif [[ "$1" -eq "2" ]]; then
  matlab -nodisplay -r "clust_make_profs_data_howard_bins; exit"
elif [[ "$1" -eq "3" ]]; then
  matlab -nodisplay -r "cluster_anomaly_and_trends_16day_calcs_howard; exit"
elif [[ "$1" -eq "4" ]]; then
  matlab -nodisplay -r "cluster_make_calcs_profile_trends; exit"
######
elif [[ "$1" -eq "5" ]]; then
  matlab -nodisplay -r "clust_make_profs_data_howard_bins_startSept2002; exit"
elif [[ "$1" -eq "6" ]]; then
  matlab -nodisplay -r "clust_gather_pall_howardV3_startSept2002; exit"
######
elif [[ "$1" -eq "7" ]]; then
  matlab -nodisplay -r "clust_make_profs_data_howard_bins_OneYearStartJan1; exit"
elif [[ "$1" -eq "8" ]]; then
  matlab -nodisplay -r "clust_make_profs_data_howard_bins_OneYearStartJan1_Desc; exit"
elif [[ "$1" -eq "9" ]]; then
  matlab -nodisplay -r "clust_make_profs_data_howard_bins_OneYearStartJan1_Asc; exit"
##
######## NOV 2020 : gather howards stats and put them into files, need mucho memory and 4 hours, 400 timesteps -- then read all files and concat the timesteps together
######## NOV 2020 : gather howards stats and put them into files, need mucho memory and 4 hours, 400 timesteps -- then read all files and concat the timesteps together
######## NOV 2020 : gather howards stats and put them into files, need mucho memory and 4 hours, 400 timesteps -- then read all files and concat the timesteps together
## sbatch -p high_mem --array=1-400%16 sergio_matlab_jobB.sbatch 10
elif [[ "$1" -eq "10" ]]; then
  echo "clust_check_howard_16daytimesetps_2013_raw_griddedV2 : Quantile only"
  matlab -nodisplay -r "clust_check_howard_16daytimesetps_2013_raw_griddedV2; exit"
## sbatch --array=1-64 sergio_matlab_jobB.sbatch 11
elif [[ "$1" -eq "11" ]]; then
  echo "cluster_loop_make_correct_timeseriesV2 : FIX Quantile, All or eXtremes"
  matlab -nodisplay -r "cluster_loop_make_correct_timeseriesV2; exit"
##
## sbatch -p high_mem --array=1-400%16 sergio_matlab_jobB.sbatch 12
elif [[ "$1" -eq "12" ]]; then
  echo "clust_check_howard_16daytimesetps_2013_raw_griddedV3 : set iQAX to do Quantile, All or eXtremes"
  matlab -nodisplay -r "clust_check_howard_16daytimesetps_2013_raw_griddedV3; exit"
## sbatch --array=1-64 sergio_matlab_jobB.sbatch 13
elif [[ "$1" -eq "13" ]]; then
  echo "cluster_loop_make_correct_timeseriesV3 : set iQAX to FIX Quantile, All or eXtremes"
  matlab -nodisplay -r "cluster_loop_make_correct_timeseriesV3; exit"
fi
