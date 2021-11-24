#!/bin/bash

# run this with sbatch --exclude=cnode[205,239,241-242] --array=1-40 sergio_matlab_jobB.sbatch 1  to make 40 latbin 16day avg, no seasonal
# run this with sbatch --exclude=cnode[205,239,241-242] --array=1-40 sergio_matlab_jobB.sbatch 3  to make 40 latbin geophysical rates

#  Name of the job:
#SBATCH --job-name=CLUST_MAKEJAC
#  N specifies that 1 job step is to be allocated per instance of
#matlab
#SBATCH -N1
#  This specifies the number of cores per matlab session will be
#available for parallel jobs
#SBATCH --cpus-per-task 1
#  Specify the desired partition develop/batch/prod
#SBATCH --partition=batch
#  Specify the qos and run time (format:  dd-hh:mm:ss)
#SBATCH --qos=short+
#SBATCH --time=0:59:00 
#  This is in MB, very aggressive but I have been running outta memory
#SBATCH --mem-per-cpu=12000
#  This forces use of hpcf2013 nodes add this to your sbatch script
#######SBATCH --constraint=hpcf2013

if [ $# -gt 0 ]; then
  echo "Your command line contains $# arguments"
elif [ $# -eq 0 ]; then
  echo "Your command line contains no arguments"
fi

if [[ "$1" -eq "" ]]; then
  echo "cmd line arg = DNE, doing lat40 16day avg, no seasonal"
  srun matlab -nodisplay -r "clust_make_lats40_16dayavg_noseasonal; exit"    #### this has seasonal stuff removed before 16 day average DEFAULT
elif [[ "$1" -eq "1" ]]; then
  echo "cmd line arg = 1, doing lat40 16day avg, no seasonal"
  srun matlab -nodisplay -r "clust_make_lats40_16dayavg_noseasonal; exit"    #### this has seasonal stuff removed before 16 day average DEFAULT
elif [[ "$1" -eq "2" ]]; then
  echo "cmd line arg = 2, doing lat40 16day avg, with seasonal still there"
  srun matlab -nodisplay -r "clust_make_lats40_16dayavg; exit"              #### this has seasonal stuff         before 16 day average
elif [[ "$1" -eq "3" ]]; then
  echo "cmd line arg = 3, doing rates"
  srun matlab -nodisplay -r "clust_make_geophysical_rates40; exit"          ### do the geophysical rates
fi
#srun matlab -nodisplay -r "clust_make_sarta_test_jacobians; exit"


