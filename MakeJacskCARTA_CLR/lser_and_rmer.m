%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lser = ['!du -h /scratch/Anomaly365_16_12p4/' num2str(JOB,'%03d') '/*'];
eval(lser);
rmer = ['!/bin/rm -r /scratch/Anomaly365_16_12p4/' num2str(JOB,'%03d') '/*'];
eval(lser);

lser = ['!du -h /scratch/Anomaly365_16_12p8/' num2str(JOB,'%03d') '/*'];
eval(lser);
rmer = ['!/bin/rm -r /scratch/Anomaly365_16_12p8/' num2str(JOB,'%03d') '/*'];
eval(lser);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lser = ['!du -h /scratch/*/Anomaly365_16_12p4/' num2str(JOB,'%03d') '/*'];
eval(lser);
rmer = ['!/bin/rm -r /scratch/*/Anomaly365_16_12p4/' num2str(JOB,'%03d') '/*'];
eval(lser);

lser = ['!du -h /scratch/*/Anomaly365_16_12p8/' num2str(JOB,'%03d') '/*'];
eval(lser);
rmer = ['!/bin/rm -r /scratch/*/Anomaly365_16_12p8/' num2str(JOB,'%03d') '/*'];
eval(lser);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lser = ['!du -h /umbc/lustre/strow/sergio/scratch/Anomaly365_16_12p4/' num2str(JOB,'%03d') '/*'];
eval(lser);
rmer = ['!/bin/rm -r /umbc/lustre/strow/sergio/scratch/Anomaly365_16_12p4/' num2str(JOB,'%03d') '/*'];
eval(lser);

lser = ['!du -h /umbc/lustre/strow/sergio/scratch/Anomaly365_16_12p8/' num2str(JOB,'%03d') '/*'];
eval(lser);
rmer = ['!/bin/rm -r /umbc/lustre/strow/sergio/scratch/Anomaly365_16_12p8/' num2str(JOB,'%03d') '/*'];
eval(lser);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
lser = ['!du -h /scratch/Anomaly365_16_12p4/*/' num2str(JOB,'%03d') '/*'];
eval(lser);
rmer = ['!/bin/rm -r /scratch/Anomaly365_16_12p4/*/' num2str(JOB,'%03d') '/*'];
eval(lser);

lser = ['!du -h /scratch/Anomaly365_16_12p8/*/' num2str(JOB,'%03d') '/*'];
eval(lser);
rmer = ['!/bin/rm -r /scratch/Anomaly365_16_12p8/*/' num2str(JOB,'%03d') '/*'];
eval(lser);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lser = ['!du -h /scratch/*/Anomaly365_16_12p4/*/' num2str(JOB,'%03d') '/*'];
eval(lser);
rmer = ['!/bin/rm -r /scratch/*/Anomaly365_16_12p4/*/' num2str(JOB,'%03d') '/*'];
eval(lser);

lser = ['!du -h /scratch/*/Anomaly365_16_12p8/*/' num2str(JOB,'%03d') '/*'];
eval(lser);
rmer = ['!/bin/rm -r /scratch/*/Anomaly365_16_12p8/*/' num2str(JOB,'%03d') '/*'];
eval(lser);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lser = ['!du -h /umbc/lustre/strow/sergio/scratch/Anomaly365_16_12p4/*/' num2str(JOB,'%03d') '/*'];
eval(lser);
rmer = ['!/bin/rm -r /umbc/lustre/strow/sergio/scratch/Anomaly365_16_12p4/*/' num2str(JOB,'%03d') '/*'];
eval(lser);

lser = ['!du -h /umbc/lustre/strow/sergio/scratch/Anomaly365_16_12p8/*/' num2str(JOB,'%03d') '/*'];
eval(lser);
rmer = ['!/bin/rm -r /umbc/lustre/strow/sergio/scratch/Anomaly365_16_12p8/*/' num2str(JOB,'%03d') '/*'];
eval(lser);
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
