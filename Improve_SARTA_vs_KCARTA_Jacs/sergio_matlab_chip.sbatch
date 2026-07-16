#!/bin/bash

# run this with   sbatch --array=0001-1000%512 --output='/dev/null/' sergio_matlab_chip.sbatch 1     to make sarta col jacs
# run this with   sbatch --array=1001-2000%512 --output='/dev/null/' sergio_matlab_chip.sbatch 1     to make sarta col jacs
#
# run this with   sbatch --array=1-200      --output='/dev/null/' sergio_matlab_chip.sbatch 2     to put together sarta/kcatra col jacs

# >>>>>>>>>>>>>>>>>>>>>>>>> ########################################################################

#SBATCH --job-name=SARTA_DRIVER      # Name of the job:
#SBATCH --requeue                     # requeue; if held type scontrol release JOBID
#SBATCH -N1                           # N specifies that 1 job step is to be allocated per instance of matlab
#SBATCH --cpus-per-task 1             # This specifies the number of cores per matlab session will be #available for parallel jobs

#SBATCH --cluster=chip-cpu            # desired cluster
#SBATCH --account=pi_strow            # cpu owner

########################################################################

#  Specify the qos and run time (format:  dd-hh:mm:ss)

## 100 layer clouds and TwoSlab clouds jacs rads, loop 
##SBATCH --qos=medium
##SBATCH --time=3:59:00

# DISORT rads, using option 10 where we loop
##SBATCH --qos=medium
##SBATCH --time=1:59:00

# clear, or TwoSlab clouds, or fluxes
##SBATCH --qos=short
##SBATCH --time=0:59:00

#########################

#  Specify the desired partition develop/batch/prod
## can shorthand this as -p high_mem on the command line
##SBATCH --partition=batch
##SBATCH --partition=2018
##SBATCH --partition=2021
##SBATCH --partition=2024

#### to make sure we have exclusive privilege, did this at 10 pm 5/5/2026 to get things moving
##SBATCH --qos=pi_strow
##SBATCH --partition=pi_strow
##SBATCH --time=0:59:00

#### we run on 2024 but run risk of someone pre-empting, clear sky, did not run on 5/5/2026 though it ran earlier
#SBATCH --qos=shared
#SBATCH --partition=2024
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
#SBATCH --mem-per-cpu=16000

########################################################################

source /home/sergio/.bashrc

## module load MATLAB/2023b
## module load netCDF-Fortran/4.6.1-iimpi-2023a
## module load HDF/4.2.16-2-GCCcore-13.2.0
## module load intel-compilers/2023.1.0
## module load imkl/2023.1.0

########################################################################

if [ $# -gt 0 ]; then
  echo "Your command line contains $# arguments"
elif [ $# -eq 0 ]; then
  echo "Your command line contains no arguments"
fi

##  Specify the job array (format:  start-stop:step)
## DO NOT USE srun matlab -nodisplay -r "clust_do_kcarta_driver; exit"   but instead matlab -nodisplay -r "clust_do_kcarta_driver; exit" 

#echo " "
#echo "this is the path"
#echo "$PATH"
#echo " "
#echo " this is the library path"
#echo "$LD_LIBRARY_PATH"
#echo " "

if [[ "$1" -eq "" ]]; then
  # this is sarta coljac runs
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab -nodisplay -r "clustmake_sartajacs; exit"
elif [[ "$1" -eq "1" ]]; then
  # this is sarta coljac runs    
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab -nodisplay -r "clustmake_sartajacs; exit"
elif [[ "$1" -eq "2" ]]; then
  # this is put together sarta/kcarta col jacs
  /usr/ebuild/installs/software/MATLAB/2023b/bin/matlab -nodisplay -r "clust_put_together_sarta_kcartajacs; exit"
fi
