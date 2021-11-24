%{
look at RTP_PROFS/Cld
eg 
 -rw-rw-r-- 1 sergio pi_strow 16227865 Dec 29 20:35 timestep_lonbin_58_latbin_63_JOB_4522_cld.rtp
(63-1)*72 + 58 = 4522
%}

fid = fopen('/home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/MakeAvgCldProfs2002_2020/LookAtTimeSeries/RTP_PROFS/Cld/lon_lat_job.txt','w');
for jj = 1 : 64
  for ii = 1 : 72
    JOB = (jj-1)*72 + ii;
    fprintf(fid,'%2i %2i %4i \n',jj,ii,JOB);
  end
end
fclose(fid);
