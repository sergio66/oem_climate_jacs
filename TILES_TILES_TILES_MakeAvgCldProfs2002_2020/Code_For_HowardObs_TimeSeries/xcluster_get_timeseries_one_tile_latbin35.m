clearvars -except JOB lonn loni lon
addpath /home/sergio/MATLABCODE

thelon = -180 : 5 : +180;
thelon = meanvaluebin(thelon);

lonn = [09 66];
thelon(lonn)

for loni = 1 : length(lonn)
  lat = 35;
  lat = 32;
  lon = lonn(loni);

  JOB = (lat-1)*72 + lon;
  
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
  clearvars -except JOB lonn loni lon
end
  
