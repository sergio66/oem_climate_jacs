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
# run this with   sbatch --exclude=cnode204,cnode260,cnode267 --array=1-365 sergio_matlab_anom40_strowV3.sbatch
# run this with   sbatch --exclude=cnode204,cnode260,cnode267 --array=1-365 --output='testslurm' sergio_matlab_anom40_strowV3.sbatch
# run this with BEWARE SYMBOLIC LINK /bin/rm slurm* Anomaly365_16/*/individual_prof_convolved_kcarta* Anomaly365_16/*/rad.dat* Anomaly365_16/*/jac.dat*; sbatch --array=1-365 sergio_matlab_anom40_strowV3.sbatch
# run this with   rmer_slurm_JUNKrad.sc; sbatch --array=1-Nmax%128 sergio_matlab_anom40_strowV3.sbatch  

#  Name of the job:
#SBATCH --job-name=KCARTA_STROWJAC

# requeue; if held type scontrol release JOBID
#SBATCH --requeue

#  N specifies that 1 job step is to be allocated per instance of matlab
#SBATCH -N1

#  This specifies the number of cores per matlab session will be
#available for parallel jobs
#SBATCH --cpus-per-task 1

#  Specify the desired partition develop/batch/prod
#SBATCH --partition=batch
##SBATCH --partition=high_mem

#  Specify the qos and run time (format:  dd-hh:mm:ss)

########################################################################
##SBATCH --qos=short+
##SBATCH --time=00:59:00

# stuff takes about 1.5 hours if scratch dirs are working
#SBATCH --qos=medium+
#SBATCH --time=11:59:00

########################################################################

##  This is in MB, very aggressive but I have been running outta memory
##SBATCH --mem-per-cpu=24000
##  This is in MB, less aggressive
##SBATCH --mem-per-cpu=12000
##  This is in MB, very lean, don;t go below this as java starts crying, good for almost everything
##SBATCH --mem-per-cpu=4000
##  This is in MB, less aggressive
##SBATCH --mem-per-cpu=32000
##  This is in MB, less aggressive since these are coljacs
#SBATCH --mem-per-cpu=8000

## defualt error output is to (by default slurm-{job id}_{array #}.out)
##  here we help spread the pain, into a directory
##SBATCH -o /home/sbuczko1/logs/sbatch/run_airibrad_rand_rtp-%A_%a.out
##SBATCH -e /home/sbuczko1/logs/sbatch/run_airibrad_rand_rtp-%A_%a.err
#######  here we help spread the pain, or into the dir where the call was initiated ... do this for fluu error reporting
##SBATCH -o batchout-%A_%a.out
##SBATCH -e batchout-%A_%a.err

########################################################################

##  Specify the job array (format:  start-stop:step)

matlab -singleCompThread -nodisplay -r "iColJacOnly=-1; clust_do_kcarta_driver_anomaly_loop40_strowV3; exit"    ## this is to run coljacs and T(z),WV(z),O3(z)jacs

