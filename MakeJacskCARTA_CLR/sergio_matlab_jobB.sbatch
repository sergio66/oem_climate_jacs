#!/bin/bash

# watch squeue -u sergio
# run this with   sbatch --array=1-40 --output='testslurm' sergio_matlab_jobB.sbatch
# run this with   sbatch --array=1-40 sergio_matlab_jobB.sbatch
# run this with   /bin/rm batchout*.* slurm* JUNK/individual_prof_convolved_kcarta* JUNK/rad.dat* JUNK/jac.dat*; sbatch --array=1-40 sergio_matlab_jobB.sbatch
# run this with   /bin/rm batchout*.* slurm* JUNK/individual_prof_convolved_kcarta* JUNK/rad.dat*; sbatch --array=1-Nmax%128 sergio_matlab_jobB.sbatch
# run this with   rmer_slurm_JUNKrad.sc; sbatch --array=1-Nmax%128 sergio_matlab_jobB.sbatch  
# run this with   kleenslurm; sbatch -p cpu2021 --array=1-Nmax%128 sergio_matlab_jobB.sbatch 2    to do filelist stuff (need to create anomaly_list.txt)
#
# >>>>>>>>>>>>>>>>>>>>>>>>>
# if putting ONE job per node (ie no loop)
# run this with   /bin/rm batchout*.out batchout*.err JUNK/rad.dat*; sbatch --array=1-588%128 sergio_matlab_jobB.sbatch
#    where the %128 limits to 128 jobs at a go, to limit simultaneous resource need
# if putting MANY jobs per node (ie loop)
# run this with   /bin/rm batchout*.out batchout*.err JUNK/rad.dat*; sbatch --array=1-Nprofs/iaChunksize sergio_matlab_jobB.sbatch << make sure you do Nprofs/iaChunkSize!!!!
# >>>>>>>>>>>>>>>>>>>>>>>>>

#  Name of the job:
#SBATCH --job-name=KCARTA_CLRJAC_DRIVER

# requeue; if held type scontrol release JOBID
#SBATCH --requeue

#  N specifies that 1 job step is to be allocated per instance of matlab
#SBATCH -N1

#  This specifies the number of cores per matlab session will be
#available for parallel jobs
#SBATCH --cpus-per-task 1

#  Specify the desired partition develop/batch/prod
##SBATCH --partition=batch
#SBATCH --partition=high_mem

#  Specify the qos and run time (format:  dd-hh:mm:ss)

########################################################################
## 100 layer clouds
##SBATCH --qos=medium+
##SBATCH --time=3:59:00

# clear, or TwoSlab clouds, or fluxes
#SBATCH --qos=short+
######SBATCH --time=0:29:00 
#SBATCH --time=0:59:00

########################################################################

##  This is in MB, very aggressive but I have been running outta memory
##SBATCH --mem-per-cpu=24000
##  This is in MB, less aggressive
##SBATCH --mem-per-cpu=12000
##  This is in MB, very lean, don;t go below this as java starts crying, good for almost everything
##SBATCH --mem-per-cpu=4000
##  This is in MB, less aggressive
##SBATCH --mem-per-cpu=8000
##  This is in MB, less aggressive
#SBATCH --mem-per-cpu=32000

## defualt error output is to (by default slurm-{job id}_{array #}.out)
##  here we help spread the pain, into a directory
##SBATCH -o /home/sbuczko1/logs/sbatch/run_airibrad_rand_rtp-%A_%a.out
##SBATCH -e /home/sbuczko1/logs/sbatch/run_airibrad_rand_rtp-%A_%a.err
#######  here we help spread the pain, or into the dir where the call was initiated ... do this for fluu error reporting
##SBATCH -o batchout-%A_%a.out
##SBATCH -e batchout-%A_%a.err

########################################################################

##  Specify the job array (format:  start-stop:step)
if [ $# -gt 0 ]; then
  echo "Your command line contains $# arguments"
elif [ $# -eq 0 ]; then
  echo "Your command line contains no arguments"
fi

if [[ "$1" -eq "" ]]; then
  # this is individual clear/cld runs
  matlab -nodisplay -r "clust_do_kcarta_driver; exit"
elif [[ "$1" -eq "1" ]]; then
  # this is individual clear/cld runs
  matlab -nodisplay -r "clust_do_kcarta_driver; exit"
elif [[ "$1" -eq "2" ]]; then
  # this is filelist clear/cld runs
  matlab -nodisplay -r "clust_do_kcarta_driver_anomaly_filelist; exit"
fi


