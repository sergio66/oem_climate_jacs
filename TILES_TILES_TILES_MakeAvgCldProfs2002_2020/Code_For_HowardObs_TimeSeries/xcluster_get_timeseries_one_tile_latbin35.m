clearvars -except JOB lonn loni lon
addpath /home/sergio/MATLABCODE

thelon = -180 : 5 : +180;
thelon = meanvaluebin(thelon);

load latB64.mat
thelat = meanvaluebin(latB2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% did this originally for Larrabee
lonn = [09 66];

%%% do all lonbins, but randomly
lonn = 1 : 72;
lonn = lonn(randperm(length(lonn)));

%%% do all lonbins, but randomly
lonn = 16;
lonn = lonn(randperm(length(lonn)));

printarray(lonn)
printarray(thelon(lonn))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for loni = 1 : length(lonn)
  lat = 35;   %% I did this originally
  lat = 32;   %% Larrabee asked for this
  lat = 54;   %% Larrabee asked for this

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
  
  fprintf(1,'lonbin = %2i == %8.6f   latbin = %2i = %8.6f \n',lonbin,thelon(lonbin),latbin,thelat(latbin))

  savenamex = ['../TrendsPaper_Reviewer_UNC/tile_timeseries_latbin_' num2str(latbin) '_lonbin_' num2str(lonbin) '_quantiledata.mat'];
  if exist(savenamex)
    fprintf(1,'%4i %3i %2i %s already exists \n',JOB,latbin,lonbin,savenamex)
    %% out = get_timeseries_one_tile_quantiles(latbin,lonbin,-1);    
  else
    fprintf(1,'%4i %3i %2i \n',JOB,latbin,lonbin)
    out = get_timeseries_one_tile_quantiles(latbin,lonbin,-1);
    savename = out.savename;
    eval(out.saver)
  
    fprintf(1,'saved to %s \n',savename)
  end
  clearvars -except JOB lonn loni lon
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{  
disp('printing mean satzen asc/solzen asc/satzen  desc/satzen desc/solzen')
[mean(asc_quantile.satzen_quantile1231_asc,1); mean(asc_quantile.solzen_quantile1231_asc,1); mean(desc_quantile.satzen_quantile1231_desc,1); mean(desc_quantile.solzen_quantile1231_desc,1)]
disp('printing std satzen asc/solzen asc/satzen desc/satzen desc/solzen')
[std(asc_quantile.satzen_quantile1231_asc,1); std(asc_quantile.solzen_quantile1231_asc,1); std(desc_quantile.satzen_quantile1231_desc,1); std(desc_quantile.solzen_quantile1231_desc,1)]
%}
