addpath /home/sergio/MATLABCODE
system_slurm_stats;

disp('before delete files'); sizer = ['!df -h /scratch']; eval(sizer)

lser = ['!ls -ltR /scratch/Anomaly365_16'];
eval(lser)

rmer = ['!/bin/rm -r /scratch/Anomaly365_16'];
eval(rmer)

lser = ['!ls -ltR /scratch/Anomaly365_16_12p*'];
eval(lser)

rmer = ['!/bin/rm -r /scratch/Anomaly365_16_12p*'];
eval(rmer)

disp('after delete files'); sizer = ['!df -h /scratch']; eval(sizer)
