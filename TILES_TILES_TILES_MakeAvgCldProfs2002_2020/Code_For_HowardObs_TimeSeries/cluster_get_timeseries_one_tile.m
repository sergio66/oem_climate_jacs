JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));

if length(JOB) == 0
  JOB = 2304 - 36;
end

%disp(' ')
%for JOB=1:4608
%  lati = floor((JOB-1)/72)+1;
%  loni = JOB-(lati-1)*72;  fprintf(1,'JOB,lati,loni : %4i %3i %3i \n',JOB,lati,loni)
%end
%disp(' ')

latbin = floor((JOB-1)/72) + 1;
lonbin = JOB - (latbin-1)*72;

fprintf(1,'%4i %3i %2i \n',JOB,latbin,lonbin)

out = get_timeseries_one_tile_quantiles(latbin,lonbin,-1);
savename = out.savename;
eval(out.saver)

fprintf(1,'saved to %s \n',savename)
