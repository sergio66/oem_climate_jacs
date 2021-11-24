#!/bin/bash

# watch all jobs     squeue -u sergio
# delete all jobs    scancel -u sergio
#
# if only doing things on taki
# /bin/rm Anomaly365_16/*/jac*.dat*
# /bin/rm Anomaly365_16/*/rad*.dat*
# or simply    rmer_anom.sc
#
# if running on the cluster, try Steve's suggestion
# rm_scratch_fat_files.sc
#
# run this with   sbatch --account=pi_strow --exclude=cnode204,cnode260,cnode267 --array=1-365 sergio_matlab_anom40_put_together.sbatch    for 365 timesteps, put together jacs
#
#  Name of the job:
#SBATCH --job-name=KCARTA_CLRJANOM_DRIVER

# requeue; if held type scontrol release JOBID
#SBATCH --requeue

#  N specifies that 1 job step is to be allocated per instance of matlab
#SBATCH -N1

#  This specifies the number of cores per matlab session will be
#available for parallel jobs
#SBATCH --cpus-per-task 1

#  Specify the desired partition develop/batch/prod
#SBATCH --partition=batch    ###### to put them together

########################################################################
#  Specify the qos and run time (format:  dd-hh:mm:ss)

## to run the kCARTA jacs, clear, or TwoSlab clouds, or fluxes
# to put them together
#SBATCH --qos=short+
#SBATCH --time=0:19:00

########################################################################

##  This is in MB, very aggressive but I have been running outta memory
#SBATCH --mem-per-cpu=12000

########################################################################
if [ $# -gt 0 ]; then
  echo "Your command line contains $# arguments"
elif [ $# -eq 0 ]; then
  echo "Your command line contains no arguments"
fi

##  Specify the job array (format:  start-stop:step)
if [[ "$1" -eq "" ]]; then
  # this is fixed timestep, loop over 40 latbins
  matlab -singleCompThread -nodisplay -r "clust_driver_put_together_kcarta_jacs; exit"
elif [[ "$1" -eq "" ]]; then
  # this is fixed timestep, loop over 40 latbins
  matlab -singleCompThread -nodisplay -r "clust_driver_put_together_kcarta_jacs; exit"
fi
