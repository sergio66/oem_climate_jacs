fid = fopen('/asl/s1/sergio/MakeAvgProfs2002_2020_startSept2002/summary_latbin_files.txt','w');

fprintf(fid,'%% see /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/MakeAvgCldProfs2002_2020/make_summary_latbin_files_txt_startSept2002.m \n');
fprintf(fid,'%% ls -1 /asl/s1/sergio/MakeAvgProfs2002_2020_startSept2002/LatBin*/summary_latbin* > /asl/s1/sergio/MakeAvgProfs2002_2020_startSept2002/summary_latbin_files.txt \n');
fprintf(1fid,'%% last one is 2002 2020 65  73 which is saying : do the AVERAGE one, bloke! at DATA_startSept2002/summary_16years_all_lat_all_lon.rtp = /asl/s1/sergio/MakeAvgProfs2002_2020_startSept2002/summary_16years_all_lat_all_lon.rtp \n');

for yy = 1 : 64
  for xx = 1 : 72
    fprintf(fid,'2002 2020 %2i %3i \n',yy,xx);
  end
end
yy = 65; xx = 73;     fprintf(fid,'2002 2020 %2i %3i \n',yy,xx); 
fclose(fid);

%{
/asl/s1/sergio/MakeAvgProfs2002_2020_startSept2002/LatBin38/summary_latbin_38_lonbin_38.rtp       yy xx
/asl/s1/sergio/MakeAvgProfs2002_2020_startSept2002/LatBin38/summary_latbin_38_lonbin_39.rtp
/asl/s1/sergio/MakeAvgProfs2002_2020_startSept2002/LatBin38/summary_latbin_38_lonbin_40.rtp
%}
