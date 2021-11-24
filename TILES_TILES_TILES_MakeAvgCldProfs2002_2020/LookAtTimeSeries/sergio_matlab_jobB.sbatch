#!/bin/bash

# run this with sbatch --exclude=cnode203,cnode260,cnode267 --array=1-64%128 --output='testslurm' sergio_matlab_jobB.sbatch
# run this with sbatch --exclude=cnode203,cnode260,cnode267 --array=1-64%128 sergio_matlab_jobB.sbatch 
#
# run this with sbatch --array=1-64%128 sergio_matlab_jobB.sbatch 1   for clust_make_profs_data
# run this with sbatch --array=1-64%128 sergio_matlab_jobB.sbatch 2   for clust_make_profs_data_howard_bins
# run this with sbatch --array=1-64%128 sergio_matlab_jobB.sbatch 3   for cluster_anomaly_and_trends_16day_calcs_howard
# run this with sbatch -p high_mem --array=1-64%400 sergio_matlab_jobB.sbatch 10  for clust_check_howard_16daytimesetps_2013_raw_griddedV2

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
##SBATCH --partition=strow

## this is for choices 3,4
#SBATCH --qos=medium+
#SBATCH --time=7:59:00 
#SBATCH --mem-per-cpu=8000

## this is for choices 0,1,2
##SBATCH --qos=short+
##SBATCH --time=00:59:00 
##SBATCH --mem-per-cpu=16000


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
  matlab -nodisplay -r "cluster_make_rtp_file; exit"
elif [[ "$1" -eq "1" ]]; then
  matlab -nodisplay -r "cluster_make_rtp_file; exit"
elif [[ "$1" -eq "2" ]]; then
  matlab -nodisplay -r "cluster_make_rtp_fileV2; exit"
elif [[ "$1" -eq "3" ]]; then
  matlab -nodisplay -r "cluster_make_rtp_fileV2_true_ERA; exit"
elif [[ "$1" -eq "4" ]]; then
  matlab -nodisplay -r "cluster_make_rtp_fileV2_true_ERA_backwards; exit"
fi
