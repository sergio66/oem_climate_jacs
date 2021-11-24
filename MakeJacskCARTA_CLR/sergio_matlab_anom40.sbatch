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

# run this with   sbatch --account=pi_strow --exclude=cnode026 --array=1-40  sergio_matlab_anom40.sbatch 1   for 40 latbins
#
# run this with   sbatch --account=pi_strow --exclude=cnode026 --array=1-365 sergio_matlab_anom40.sbatch 2   for 365 timesteps
#
# run this with   sbatch --account=pi_strow --exclude=cnode026 --array=1-365 sergio_matlab_anom40.sbatch 3   for 365 timesteps, latbin backwards
#
# run this with   sbatch --account=pi_strow --exclude=cnode204,cnode260,cnode267 --array=1-365 sergio_matlab_anom40.sbatch 4   for 365 timesteps, put together jacs
#
# run this with   sbatch --array=1-365 sergio_matlab_anom40.sbatch
# run this with   sbatch --array=1-365 --output='testslurm' sergio_matlab_anom40.sbatch
# run this with BEWARE SYMBOLIC LINK /bin/rm slurm* Anomaly365_16/*/individual_prof_convolved_kcarta* Anomaly365_16/*/rad.dat* Anomaly365_16/*/jac.dat*; sbatch --array=1-365 sergio_matlab_anom40.sbatch
# run this with   rmer_slurm_JUNKrad.sc; sbatch --array=1-Nmax%128 sergio_matlab_anom40.sbatch  

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
##SBATCH --partition=batch     ###### to put them together
#SBATCH --partition=high_mem   ###### to make the jacs

########################################################################
#  Specify the qos and run time (format:  dd-hh:mm:ss)

## to run the kCARTA jacs, clear, or TwoSlab clouds, or fluxes
#SBATCH --qos=medium+
#SBATCH --time=15:59:00

# to put them together
##SBATCH --qos=short+
##SBATCH --time=0:59:00

########################################################################

##  This is in MB, very aggressive but I have been running outta memory
##SBATCH --mem-per-cpu=24000
##  This is in MB, less aggressive
##SBATCH --mem-per-cpu=12000
##  This is in MB, very lean, don;t go below this as java starts crying, good for almost everything
##SBATCH --mem-per-cpu=4000
##  This is in MB, less aggressive
##SBATCH --mem-per-cpu=8000
##  This is in MB, very aggressive FOR JACS
#SBATCH --mem-per-cpu=32000

########################################################################
if [ $# -gt 0 ]; then
  echo "Your command line contains $# arguments"
elif [ $# -eq 0 ]; then
  echo "Your command line contains no arguments"
fi

##  Specify the job array (format:  start-stop:step)
if [[ "$1" -eq "" ]]; then
  # this is fixed timestep, loop over 40 latbins
  matlab -singleCompThread -nodisplay -r "clust_do_kcarta_driver; exit"
elif [[ "$1" -eq "1" ]]; then
  # this is fixed timestep, loop over 40 latbins
  matlab -singleCompThread -nodisplay -r "clust_do_kcarta_driver; exit"
elif [[ "$1" -eq "2" ]]; then
  # this is fixed latbin, loop over 365 timesteps
  matlab -singleCompThread -nodisplay -r "iColJacOnly=-1;clust_do_kcarta_driver_anomaly_loop40; exit"
elif [[ "$1" -eq "3" ]]; then
  # this is fixed latbin, loop over 365 timesteps
  matlab -singleCompThread -nodisplay -r "iColJacOnly=-1;clust_do_kcarta_driver_anomaly_loop40_backwards; exit"
fi
