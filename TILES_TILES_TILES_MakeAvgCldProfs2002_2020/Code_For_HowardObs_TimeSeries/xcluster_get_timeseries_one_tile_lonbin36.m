clearvars -except JOB
addpath /home/sergio/MATLABCODE













%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%for lat = 1 : 4 : 64
for lat = 1 : 1 : 64
  lon = 36;
  lon = 36;

  JOB = (lat-1)*72 + 36;

  %disp(' ')
  %for JOB=1:4608
  %  lati = floor((JOB-1)/72)+1;
  %  loni = JOB-(lati-1)*72;  fprintf(1,'JOB,lati,loni : %4i %3i %3i \n',JOB,lati,loni)
  %end
  %disp(' ')
  
  latbin = floor((JOB-1)/72) + 1;
  lonbin = JOB - (latbin-1)*72;
  
  savenamex = ['../TrendsPaper_Reviewer_UNC/tile_timeseries_latbin_' num2str(latbin) '_lonbin_' num2str(lonbin) '_quantiledata.mat'];
  if exist(savenamex)
    fprintf(1,'%4i %3i %2i %s already exists \n',JOB,latbin,lonbin,savenamex)
  else
    fprintf(1,'%4i %3i %2i \n',JOB,latbin,lonbin)
    out = get_timeseries_one_tile_quantiles(latbin,lonbin,-1);
    savename = out.savename;
    eval(out.saver)
  
    fprintf(1,'saved to %s \n',savename)
  end
  clearvars -except JOB  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{  
disp('printing mean satzen asc/solzen asc/satzen desc/satzen desc/solzen')
[mean(asc_quantile.satzen_quantile1231_asc,1); mean(asc_quantile.solzen_quantile1231_asc,1); mean(desc_quantile.satzen_quantile1231_desc,1); mean(desc_quantile.solzen_quantile1231_desc,1)]
disp('printing std satzen asc/solzen asc/satzen desc/satzen desc/solzen')
[std(asc_quantile.satzen_quantile1231_asc,1); std(asc_quantile.solzen_quantile1231_asc,1); std(desc_quantile.satzen_quantile1231_desc,1); std(desc_quantile.solzen_quantile1231_desc,1)]
%}
