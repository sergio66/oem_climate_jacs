wgf = '/asl/models/usgs/world_grid_deg10_v2.mat';
addpath /asl/s1/sergio/home/MATLABCODE/rtp_prod2/util/
[boox,booy] = find(isnan(results.rlat));
if length(boox) > 0
  [booy boox]
  for ii =  1 : length(boox)        
    results.rlat(boox(ii),booy(ii)) = results.rlat(boox(ii)+1,booy(ii));
    results.rlon(boox(ii),booy(ii)) = 0.5*(results.rlon(boox(ii)-1,booy(ii)) + results.rlon(boox(ii)+1,booy(ii)));
  end
end

[salti, landfrac] = usgs_deg10_dem(results.rlat, results.rlon,wgf);
results.salti = reshape(salti,72,64);
results.landfrac = reshape(landfrac,72,64);
figure(1); scatter_coast(results.rlon(:),results.rlat(:),50,results.landfrac(:)); title('landfrac')

results.AIRS_stemp_trend_nan = results.AIRS_stemp_trend;
results.AIRS_stemp_trend_nan(results.landfrac > 0) = NaN;

results.SUSS_stemp_trend_nan = results.SUSS_stemp_trend;
results.SUSS_stemp_trend_nan(results.landfrac > 0) = NaN;

results.ZHOU_stemp_trend_nan = results.ZHOU_stemp_trend;
results.ZHOU_stemp_trend_nan(results.landfrac > 0) = NaN;

%%%%%%%%%%%%%%%%%%%%%%%%%

results.AIRS_stemp_ERA_trend_nan = results.AIRS_stemp_ERA_trend;
results.AIRS_stemp_ERA_trend_nan(results.landfrac > 0) = NaN;

results.SUSS_stemp_ERA_trend_nan = results.SUSS_stemp_ERA_trend;
results.SUSS_stemp_ERA_trend_nan(results.landfrac > 0) = NaN;

results.ZHOU_stemp_ERA_trend_nan = results.ZHOU_stemp_ERA_trend;
results.ZHOU_stemp_ERA_trend_nan(results.landfrac > 0) = NaN;

%%%%%%%%%%%%%%%%%%%%%%%%%

results.AIRS_co2_trend_nan = results.AIRS_co2_trend;
results.AIRS_co2_trend_nan(results.landfrac > 0) = NaN;

results.SUSS_co2_trend_nan = results.SUSS_co2_trend;
results.SUSS_co2_trend_nan(results.landfrac > 0) = NaN;

results.ZHOU_co2_trend_nan = results.ZHOU_co2_trend;
results.ZHOU_co2_trend_nan(results.landfrac > 0) = NaN;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{

I worked a good bit this morning on a good mapping Mfile, please start
using it (if it works!).  I am attaching that file, and another file I
use all the time that does 2D smoothing (smoothn).  Here are sample
uses of both.  dbtsmooth = smoothn(dbt1231,1); (You don’t always need
the “1”, but it is kinda the default.  >1 more smoothing, < 1 less
smoothing)

aslmap(1,latB,lonB,sy,[-90 90],[-180 180],opts)
the opts var is not needed, but I generally use it, here is an example
opts =
  struct with fields:
     cmap: [64x3 double]
    caxis: [-0.2500 0.2501]
    color: ‘k’
>> For +- diff maps I often do opts.map = llsmap5;
11:33
Oh, in aslmap “sy” is your grid, like “dbt1231" or “dbtsmooth”.

Note that smoothn has a literature reference.  And, it handle NaNs,
but tried to fill them in.  Often I get the indices of the NaNs from
the original unsmoothed file, do the smoothing, then replace the
smoothed version pixels that had NaN’s back with NaNs.

%}
addpath /home/sergio/MATLABCODE/PLOTTER/ASLMAPeq_area/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
figure(1); scatter_coast(results.rlon(:),results.rlat(:),50,results.ZHOU_stemp(:)); title('stemp K')
colormap jet; caxis([210 310]); colormap jet
figure(2); scatter_coast(results.rlon(:),results.rlat(:),50,results.ZHOU_stemp_trend(:)); title('stemp trend K/yr')
colormap jet; caxis([-0.2 +0.2]); colormap(usa2); 

figure(3); scatter_coast(results.rlon(:),results.rlat(:),50,results.ZHOU_stemp_ERA(:)); title('stemp ERA K')
colormap jet; caxis([210 310]); colormap jet
figure(4); scatter_coast(results.rlon(:),results.rlat(:),50,results.ZHOU_stemp_ERA_trend(:)); title('stemp ERA trend K/yr')
colormap jet; caxis([-0.2 +0.2]); colormap(usa2); 

figure(5); plot(nanmean(results.ZHOU_stemp,1),results.rlat(1,:)); xlabel('ST K/yr'); ylabel('Latitude')
figure(5); plot(nanmean(results.ZHOU_stemp_trend,1),results.rlat(1,:),'r',nanmean(results.ZHOU_stemp_trend_nan,1),results.rlat(1,:),'b','linewidth',2); 
  plotaxis2;  hl = legend('Land+Ocean','Ocean','location','best');  xlabel('ST K/yr'); ylabel('Latitude'); xlim([-0.1 +0.1])

figure(5); plot(nanmean(results.AIRS_stemp_trend,1),results.rlat(1,:),'r--',nanmean(results.AIRS_stemp_trend_nan,1),results.rlat(1,:),'r',...
                nanmean(results.ZHOU_stemp_trend,1),results.rlat(1,:),'g--',nanmean(results.ZHOU_stemp_trend_nan,1),results.rlat(1,:),'g',...
                nanmean(results.SUSS_stemp_trend,1),results.rlat(1,:),'b--',nanmean(results.SUSS_stemp_trend_nan,1),results.rlat(1,:),'b',...
                'linewidth',2); 
  plotaxis2;  hl = legend('Land+Ocean AIRS','Ocean AIRS','Land+Ocean ZHOU','Ocean ZHOU','Land+Ocean SUSS','Ocean SUSS','location','best','fontsize',8);  xlabel('ST K/yr'); ylabel('Latitude');

figure(5); plot(nanmean(results.ZHOU_stemp_ERA_trend,1),results.rlat(1,:),'r--',nanmean(results.ZHOU_stemp_ERA_trend_nan,1),results.rlat(1,:),'r',...
                nanmean(results.ZHOU_stemp_trend,1),results.rlat(1,:),'g--',nanmean(results.ZHOU_stemp_trend_nan,1),results.rlat(1,:),'g',...
                'linewidth',2); 
  plotaxis2;  hl = legend('Land+Ocean ERA','Ocean ERA','Land+Ocean ZHOU','Ocean ZHOU','location','best','fontsize',8);  xlabel('ST K/yr'); ylabel('Latitude');

figure(6); plot(nanmean(results.ZHOU_co2_trend,1),results.rlat(1,:),'g--',nanmean(results.ZHOU_co2_trend_nan,1),results.rlat(1,:),'g')
  plotaxis2;  hl = legend('Land+Ocean ZHOU','Ocean ZHOU','location','best','fontsize',8);  xlabel('CO2 ppm/yr'); ylabel('Latitude');

figure(7); scatter_coast(results.rlon(:),results.rlat(:),50,results.ZHOU_icetop(:));       title('icetop mb'); colormap jet; caxis([100 500]); colormap jet
figure(8); scatter_coast(results.rlon(:),results.rlat(:),50,results.ZHOU_icetop_trend(:)); title('icetop trend mb/yr'); colormap jet; caxis([-10 +10]); colormap(usa2);
figure(7); scatter_coast(results.rlon(:),results.rlat(:),50,results.ZHOU_iceOD(:));        title('iceOD '); colormap jet; caxis([0 2]); colormap jet
figure(9); scatter_coast(results.rlon(:),results.rlat(:),50,results.ZHOU_iceOD_trend(:));  title('iceOD trend /yr'); colormap jet; caxis([-0.05 +0.05]); colormap(usa2);
figure(7); scatter_coast(results.rlon(:),results.rlat(:),50,results.ZHOU_icefrac(:));        title('icefrac '); colormap jet; caxis([0 1]); colormap jet
figure(10); scatter_coast(results.rlon(:),results.rlat(:),50,results.ZHOU_icefrac_trend(:));  title('icefrac trend /yr'); colormap jet; caxis([-0.05 +0.05]); colormap(usa2);
figure(7); scatter_coast(results.rlon(:),results.rlat(:),50,results.ZHOU_icesze(:));        title('icesze um'); colormap jet; caxis([0 100]); colormap jet
figure(11); scatter_coast(results.rlon(:),results.rlat(:),50,results.ZHOU_icesze_trend(:));  title('icesze trend um/yr'); colormap jet; caxis([-1 +1]); colormap(usa2);

figure(7); scatter_coast(results.rlon(:),results.rlat(:),50,results.ZHOU_watertop(:));       title('watertop mb'); colormap jet; caxis([100 500]); colormap jet
figure(8); scatter_coast(results.rlon(:),results.rlat(:),50,results.ZHOU_watertop_trend(:)); title('watertop trend mb/yr'); colormap jet; caxis([-10 +10]); colormap(usa2);
figure(7); scatter_coast(results.rlon(:),results.rlat(:),50,results.ZHOU_waterOD(:));        title('waterOD '); colormap jet; caxis([0 2]); colormap jet
figure(9); scatter_coast(results.rlon(:),results.rlat(:),50,results.ZHOU_waterOD_trend(:));  title('waterOD trend /yr'); colormap jet; caxis([-0.05 +0.05]); colormap(usa2);
figure(7); scatter_coast(results.rlon(:),results.rlat(:),50,results.ZHOU_waterfrac(:));        title('waterfrac '); colormap jet; caxis([0 1]); colormap jet
figure(10); scatter_coast(results.rlon(:),results.rlat(:),50,results.ZHOU_waterfrac_trend(:));  title('waterfrac trend /yr'); colormap jet; caxis([-0.05 +0.05]); colormap(usa2);
figure(7); scatter_coast(results.rlon(:),results.rlat(:),50,results.ZHOU_watersze(:));        title('watersze um'); colormap jet; caxis([0 100]); colormap jet
figure(11); scatter_coast(results.rlon(:),results.rlat(:),50,results.ZHOU_watersze_trend(:));  title('watersze trend um/yr'); colormap jet; caxis([-1 +1]); colormap(usa2);

opts.cmap = jet;
opts.caxis = [-0.6 +0.6];
opts.caxis = [-0.2 +0.2];
opts.color = 'k';
opts.map = 'mercator';
load ../latB64.mat;  lats = 0.5*(latB2(1:end-1) + latB2(2:end)); lats = latB2;
lonsx = -180:5:+180; lons = 0.5*(lonsx(1:end-1) + lonsx(2:end)); lons = lonsx;
%figno = 1; aslmap(figno,double(results.rlat),double(results.rlon),double(results.ZHOU_stemp_trend),[-90 90],[-180 180],opts);
figno = 12; aslmap(figno,double(lats),double(lons),smoothn(double(results.ZHOU_stemp_trend')),[-90 90],[-180 180],opts);

%{
figure(3); plot(results.rlat(1,:),nanmean(results.AIRS_stemp_trend,1),'r',results.rlat(1,:),nanmean(results.AIRS_stemp_trend_nan,1),'b','linewidth',2); 
  plotaxis2;  hl = legend('Land+Ocean','Ocean','location','best');  ylabel('ST K/yr'); xlabel('Latitude');
  xlim([-60 +60])  
  xlim([-85 +85])
%}
disp('ret'); pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1); scatter_coast(results.rlon(:),results.rlat(:),50,results.BT1231_obs(:)); title('BT1231\_obs K')
colormap jet; caxis([210 300]); colormap jet
figure(2); scatter_coast(results.rlon(:),results.rlat(:),50,results.BT1231_obs_trend(:)); title('BT1231\_obs trend K/yr')
colormap jet; caxis([-0.2 +0.2]); colormap(usa2); 
disp('ret'); pause

figure(1); scatter_coast(results.rlon(:),results.rlat(:),50,results.BT1231_cal(:)); title('BT1231\_cal K')
colormap jet; caxis([210 300]); colormap jet
figure(2); scatter_coast(results.rlon(:),results.rlat(:),50,results.BT1231_cal_trend(:)); title('BT1231\_cal trend K/yr')
colormap jet; caxis([-0.2 +0.2]); colormap(usa2); 
disp('ret'); pause

figure(1); scatter_coast(results.rlon(:),results.rlat(:),50,results.mmw(:)); title('col W mmw')
colormap jet; caxis([0 60]); colormap jet
figure(2); scatter_coast(results.rlon(:),results.rlat(:),50,results.mmw_trend(:)); title('col W trend mmw/yr')
colormap jet; caxis([-0.2 +0.2]); colormap(usa2); 
disp('ret'); pause

figure(1); scatter_coast(results.rlon(:),results.rlat(:),50,results.BT1231_obs(:)-results.BT1231_cal(:)); 
title('BT1231\_obs - BT1231\_cal K')
colormap jet; caxis([-1 +1]); colormap jet
figure(2); scatter_coast(results.rlon(:),results.rlat(:),50,results.BT1231_obs_trend(:)-results.BT1231_cal_trend(:)); 
title('BT1231\_obs - BT1231\_cal trend K/yr')
colormap jet; caxis([-0.1 +0.1]); colormap(usa2); 
disp('ret'); pause
