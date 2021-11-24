/bin/rm slurm*; sbatch --exclude=cnode[204,225,267] --array=352-353,358,363%30 sergio_matlab_jobB.sbatch 5 
