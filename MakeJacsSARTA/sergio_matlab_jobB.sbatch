#!/bin/bash

# for 40 latbin rates,    run this with /bin/rm slurm*.out; sbatch --exclude=cnode203,cnode260,cnode267 --array=1-40 sergio_matlab_jobB.sbatch 
# for 365 timestep ANOMs, run this with /bin/rm slurm*.out; sbatch --exclude=cnode[204,267] --array=1-365 sergio_matlab_jobB.sbatch 
#
# can choose between (-1) cluster_driver_sartajac (DNE,1) cluster_driver_sartajac_anom40, (2) clust_do_sarta_driver_anomaly_loop40_strowV3 (3) both (4) put together
# eg for 365 timestep ANOMs,     run this with        /bin/rm slurm*.out; sbatch --exclude=cnode[204,267] --array=1-365 sergio_matlab_jobB.sbatch 1
# eg for 365 timestep ANOMs CLR, to  put all together /bin/rm slurm*.out; sbatch --exclude=cnode[204,267] --array=1-365 sergio_matlab_jobB.sbatch 4
# eg for 365 timestep ANOMs CLD, to  put all together /bin/rm slurm*.out; sbatch --exclude=cnode[204,267] --array=1-365 sergio_matlab_jobB.sbatch 5

#  Name of the job:
#SBATCH --job-name=CLUST_MAKEJAC

#  N specifies that 1 job step is to be allocated per instance of matlab
#SBATCH -N1

#  This specifies the number of cores per matlab session will be
#available for parallel jobs
#SBATCH --cpus-per-task 1

#  Specify the desired partition develop/batch/prod
#SBATCH --partition=batch
##SBATCH --partition=strow

#  Specify the qos and run time (format:  dd-hh:mm:ss)
#SBATCH --qos=short+
#SBATCH --time=0:59:00 

#  This is in MB, very aggressive but I have been running outta memory
#SBATCH --mem-per-cpu=12000

#  This forces use of hpcf2013 nodes add this to your sbatch script
##SBATCH --constraint=hpcf2013

########################################################################

if [ $# -gt 0 ]; then
  echo "Your command line contains $# arguments"
elif [ $# -eq 0 ]; then
  echo "Your command line contains no arguments"
fi

if [[ "$1" -eq "-1" ]]; then
  ## do average jacs, 40 latbins
  echo "cmd line arg = -1, doing 40 latbins, average jac"
  srun matlab -nodisplay -r "cluster_driver_sartajac; exit"        ## this is for RATES, one per latbin
elif [[ "$1" -eq "" ]]; then
  echo "cmd line arg = DNE, doing 365 timesteps, T/WV/tracegas"
  srun matlab -nodisplay -r "cluster_driver_sartajac_anom40; exit"  ## this is for 365 anomaly timesteps, loop over 40 latbins
elif [[ "$1" -eq "1" ]]; then
  echo "cmd line arg = 1, doing 365 timesteps, T/WV/tracegas"
  srun matlab -nodisplay -r "cluster_driver_sartajac_anom40; exit"  ## this is for 365 anomaly timesteps, loop over 40 latbins
elif [[ "$1" -eq "2" ]]; then
  echo "cmd line arg = 2, doing 365 timesteps, tracegas finite diff"
  srun matlab -nodisplay -r "clust_do_sarta_driver_anomaly_loop40_strowV3; exit"  ## this is for 365 anomaly timesteps, loop over 40 latbins, strow finote diff trace jacs
elif [[ "$1" -eq "3" ]]; then
  echo "cmd line arg = 3, doing 365 timesteps, tracegas finite diff and T/WV/tracegas"
  srun matlab -nodisplay -r "cluster_driver_sartajac_anom40; clust_do_sarta_driver_anomaly_loop40_strowV3; exit"  ## this is for 365 anomaly timesteps + strow finote diff trace jacs, loop over 40 latbins
elif [[ "$1" -eq "4" ]]; then
  echo "cmd line arg = 4, putting together 365 timesteps and adding in CFC jacs from kCARTA for clr"
  srun matlab -nodisplay -r "clust_translate2834to2645_addCFCjacs; exit"  ## this is for 365 anomaly timesteps + strow finote diff trace jacs, loop over 40 latbins
elif [[ "$1" -eq "5" ]]; then
  echo "cmd line arg = 5, putting together 365 timesteps and adding in CFC jacs from kCARTA for cld"
  srun matlab -nodisplay -r "clust_translate2834to2645_addCFCjacs_cld; exit"  ## this is for 365 anomaly timesteps + strow finote diff trace jacs, loop over 40 latbins
fi
