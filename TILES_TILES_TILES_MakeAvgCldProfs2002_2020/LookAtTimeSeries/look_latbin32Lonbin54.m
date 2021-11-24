addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/COLORMAP
addpath /asl/matlib/aslutil

homedir = pwd; %% cd /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/MakeAvgCldProfs2002_2020/LookAtTimeSeries/

set(0,'DefaultLegendAutoUpdate','off')

cd /umbc/xfs2/strow/asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_CORRECT_LatLon/

%% need to make this correction since meanBT1231 was run wrongly
%    all_72lonbins.meanBT1231(ii,tt) = rad2bt(1520,a.mean_rad_asc(1520));  %% ORIG WRONG CODE run on Dec 8, 2020
% instead of
%    all_72lonbins.meanBT1231(ii,tt) = rad2bt(1231,a.mean_rad_asc(1520));  %% THIS IS CORRECT corrected Dec 16, 2020

iDoInitStuff = input('look for regions (-1/+1) : ');

if iDoInitStuff > 0
  for jj = 1 : 64
    themall = load(['LatBin' num2str(jj,'%02d') '/summarystats_LatBin' num2str(jj,'%02d') '_LonBin_1_72_timesetps_001_412_V1.mat']);
    rlat(jj,:) = themall.rlat(:,1);
    rlon(jj,:) = themall.rlon(:,1);
    meanBT1231(jj,:) = themall.meanBT1231(:,1);                           %% ORIG
    meanBT1231(jj,:) = rad2bt(1231,ttorad(1520,themall.meanBT1231(:,1))); %% FIXED
    maxBT1231(jj,:) = themall.maxBT1231(:,1);
    minBT1231(jj,:) = themall.minBT1231(:,1);
  end
  figure(1); scatter_coast(rlon(:),rlat(:),50,maxBT1231(:)); title('maxBT1231'); colormap jet; caxis([200 340])
  figure(2); scatter_coast(rlon(:),rlat(:),50,meanBT1231(:)); title('meanBT1231'); colormap jet; caxis([200 340])
  figure(3); scatter_coast(rlon(:),rlat(:),50,minBT1231(:)); title('minBT1231'); colormap jet
  figure(4); scatter_coast(rlon(:),rlat(:),50,maxBT1231(:)-meanBT1231(:)); title('Max-Mean BT1231'); colormap jet
  
  rrlon = rlon(:);
  rrlat = rlat(:);
  mmeanBT1231 = meanBT1231(:);
  mmaxBT1231  = maxBT1231(:);
  mminBT1231  = minBT1231(:);
    wgf = '/asl/models/usgs/world_grid_deg10_v2.mat';
    addpath /asl/s1/sergio/home/MATLABCODE/rtp_prod2/util/
    [salti, landfrac] = usgs_deg10_dem(rrlat, rrlon,wgf);
  
  ooClear = find(abs(rrlat) <= 30 & landfrac == 0 & mminBT1231 > 270 & (mmaxBT1231-mmeanBT1231) < 5);
  ooCloud = find(abs(rrlat) <= 30 & landfrac == 0 & mminBT1231 < 210 & (mmaxBT1231-mmeanBT1231) > 25);
  ooSeasonal = find(rrlat >= 35 & landfrac == 0);
  
  ooClearX = find(abs(rrlat) <= 30 & landfrac == 0 & mminBT1231 > 270 & (mmaxBT1231-mmeanBT1231) < 5 & rrlon >= 100 & rrlon <= 110,1);
  ooCloudX = find(abs(rrlat) <= 30 & landfrac == 0 & mminBT1231 < 210 & (mmaxBT1231-mmeanBT1231) > 25 & rrlon >= 150,1);
  
  ooClearX = find(abs(rrlat) <= 30 & landfrac == 0 & mminBT1231 > 270 & (mmaxBT1231-mmeanBT1231) < 5 & rrlon >= 100 & rrlon <= 110,1);
  ooClearX = find(abs(rrlat) <= 30 & landfrac == 0 & mminBT1231 > 270 & (mmaxBT1231-mmeanBT1231) < 5 & rrlon >= 080 & rrlon <= 090,1);
  ooCloudX = find(abs(rrlat) <= 30 & landfrac == 0 & mminBT1231 < 210 & (mmaxBT1231-mmeanBT1231) > 25 & rrlon >= 150 & rrlat > 5,1);
  ooSeasonalX = find(rrlat >= 37 & rrlon >= -52 & landfrac == 0 & (mmaxBT1231-mmeanBT1231) > 20,1);
  
  figure(5); plot(rrlon,rrlat,'k.',rrlon(ooClear),rrlat(ooClear),'ro',rrlon(ooCloud),rrlat(ooCloud),'bx',rrlon(ooSeasonal),rrlat(ooSeasonal),'gx')
  coast = load('coast.mat');
  figure(5); plot(rrlon(ooClear),rrlat(ooClear),'ro',rrlon(ooCloud),rrlat(ooCloud),'bo',rrlon(ooSeasonal),rrlat(ooSeasonal),'go',...
                 coast.long,coast.lat,'k.',rrlon(ooClearX),rrlat(ooClearX),'rx',rrlon(ooCloudX),rrlat(ooCloudX),'bx',rrlon(ooSeasonalX),rrlat(ooSeasonalX),'gx')
    hl = legend('clear','cloud');
  for ii = 1 : 5; figure(ii); plotaxis2; end
  
  load /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/MakeAvgCldProfs2002_2020/latB64.mat
  lonbins = -180:5:+180;
  
  %% to show we need the -1
  %% [find(lonbins >= min(rrlon),1) find(lonbins >= max(rrlon),1) find(latB2 >= min(rrlat),1) find(latB2 >= max(rrlat),1)]
  %% so see, we need -1
  indClearX = find(lonbins >= rrlon(ooClearX),1)-1; indClearY = find(latB2 >= rrlat(ooClearX),1)-1;
  indCloudX = find(lonbins >= rrlon(ooCloudX),1)-1; indCloudY = find(latB2 >= rrlat(ooCloudX),1)-1;
  indSeasonalX = find(lonbins >= rrlon(ooSeasonalX),1)-1; indSeasonalY = find(latB2 >= rrlat(ooSeasonalX),1)-1;
  fprintf(1,'ClearBin    : indX lon = %2i %8.4f     indY lat = %2i %8.4f \n',[indClearX rrlon(ooClearX) indClearY rrlat(ooClearX)])               % 55  87.5009   24 -23.3750
  fprintf(1,'CloudBin    : indX lon = %2i %8.4f     indY lat = %2i %8.4f \n',[indCloudX rrlon(ooCloudX) indCloudY rrlat(ooCloudX)])               % 68  152.5007  36  6.8743
  fprintf(1,'SeasonalBin : indX lon = %2i %8.4f     indY lat = %2i %8.4f \n',[indSeasonalX rrlon(ooSeasonalX) indSeasonalY rrlat(ooSeasonalX)])   % 27 -47.4736   47  39.8756
  
  figure(5); axis([80 160 -30 +30])
  disp('ret to continue'); pause
  figure(5); axis([-100 0 30 50])
  disp('ret to continue'); pause
end

disp('ClearBin    : indX lon = 54  87.5009     indY lat = 24 -23.3750')
disp('CloudBin    : indX lon = 67 152.5007     indY lat = 35   6.8743')
disp('SeasonalBin : indX lon = 27 -47.4736     indY lat = 47  39.8756')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iChooseLatLonBin = input('Enter Lonbin/Latbin to look at (Lonbin 54 Latbin 32 -- is a good one, over Indonesia)  0 to stop: ');

while iChooseLatLonBin(1) > 0
  cder = ['cd  /umbc/xfs2/strow/asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_CORRECT_LatLon/LatBin' num2str(iChooseLatLonBin(2),'%02d') '/'];
  eval(cder)
  themall = load(['summarystats_LatBin' num2str(iChooseLatLonBin(2),'%02d') '_LonBin_1_72_timesetps_001_412_V1.mat']);
  
  yy2002 = themall.yy(iChooseLatLonBin(1),:) + (themall.mm(iChooseLatLonBin(1),:)-1)/12 + (themall.dd(iChooseLatLonBin(1),:)-1)/12/30;
  figure(1)
  plot(yy2002,themall.maxBT1231(iChooseLatLonBin(1),:),'r',yy2002,themall.meanBT1231(iChooseLatLonBin(1),:),'k',yy2002,themall.minBT1231(iChooseLatLonBin(1),:),'b')                             %% ORIG
  plot(yy2002,themall.maxBT1231(iChooseLatLonBin(1),:),'r',yy2002,rad2bt(1231,ttorad(1520,themall.meanBT1231(iChooseLatLonBin(1),:))),'k',yy2002,themall.minBT1231(iChooseLatLonBin(1),:),'b')   %% FIXED
  hl = legend('max','mean','min');
  xlim([min(yy2002) max(yy2002)]); title(['From all lonbins, choose bin ' num2str(iChooseLatLonBin(1),'%03d')])
  
  %%%%%%%%%%%%%%%%%%%%%%%%%
  cder = ['cd  LonBin' num2str(iChooseLatLonBin(1),'%02d')]; eval(cder);
  ind54 = load(['summarystats_LatBin' num2str(iChooseLatLonBin(2),'%02d') '_LonBin' num2str(iChooseLatLonBin(1),'%02d') '_timesetps_001_412_V1.mat']);
  [mean(ind54.lon_asc) mean(ind54.lat_asc)]
  
  figure(2);
  plot(yy2002,ind54.maxBT1231_desc,'r',yy2002,ind54.meanBT1231_desc,'k',yy2002,ind54.minBT1231_desc,'b')
  hl = legend('max','mean','min');
  xlim([min(yy2002) max(yy2002)]); title(['From LonBin' num2str(iChooseLatLonBin(1),'%02d')])
  
  figure(3);
  %% ORIG
  plot(yy2002,themall.maxBT1231(iChooseLatLonBin(1),:),'r',yy2002,themall.meanBT1231(iChooseLatLonBin(1),:),'k',yy2002,themall.minBT1231(iChooseLatLonBin(1),:),'b',...
       yy2002,ind54.maxBT1231_desc,'m',yy2002,ind54.meanBT1231_desc,'g',yy2002,ind54.minBT1231_desc,'c')
  xlim([min(yy2002) max(yy2002)]); 
  disp('<<< SO themall.meanBT1231 is completely messed up. mebbe channel is not 1291 or 1520! >>> ')
  
  %% FIXED
  plot(yy2002,themall.maxBT1231(iChooseLatLonBin(1),:),'r',yy2002,rad2bt(1231,ttorad(1520,themall.meanBT1231(iChooseLatLonBin(1),:))),'k',yy2002,themall.minBT1231(iChooseLatLonBin(1),:),'b',...
       yy2002,ind54.maxBT1231_desc,'m',yy2002,ind54.meanBT1231_desc,'g',yy2002,ind54.minBT1231_desc,'c')
  xlim([min(yy2002) max(yy2002)]); 
  disp('<<< SO themall.meanBT1231 now fixed. mebbe channel is not 1291 or 1520! >>> ')
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  figure(6); plot(ind54.wnum,rad2bt(ind54.wnum,squeeze(ind54.rad_quantile_desc(1,:,:))),...
                  ind54.wnum,ones(size(ind54.wnum))*ind54.meanBT1231_desc(1),'k',1231,ind54.meanBT1231_desc(1),'kx',...
                  ind54.wnum,ones(size(ind54.wnum))*ind54.maxBT1231_desc(1),'k',1231,ind54.maxBT1231_desc(1),'kx',...
                  ind54.wnum,ones(size(ind54.wnum))*ind54.minBT1231_desc(1),'k',1231,ind54.minBT1231_desc(1),'kx',1231*ones(1,3),[ind54.maxBT1231_desc(1) ind54.meanBT1231_desc(1) ind54.minBT1231_desc(1)])
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  cder = ['cd ' homedir]; eval(cder);
  %indY = 35; indX = 67; %% this is the CLOUDY bin I selected
  %indY = 24; indX = 54; %% this is the CLEAR  bin I selected
  
  %indY = indCloudY; indX = indCloudX;
  indY = iChooseLatLonBin(2); indX = iChooseLatLonBin(1);
  
  JOB = (indY-1)*72 + indX;
  %lser = ['!ls  ../DATA_OneYear/' num2str(JOB,'%04d')];
  %eval(lser)
  thedir = dir(['../DATA_OneYear/' num2str(JOB,'%04d') '/pall_gridbox_' num2str(JOB,'%04d') '_16daytimestep_*.mat']);
  
  for tt = 1 : length(thedir)
    prof = load(['../DATA_OneYear/' num2str(JOB,'%04d') '/pall_gridbox_' num2str(JOB,'%04d') '_16daytimestep_001_2013_01_01_to_2013_01_16.mat']);
    prof = load(['../DATA_OneYear/' num2str(JOB,'%04d') '/' thedir(tt).name]);
    [yyy,mmm,ddd,hhh] = tai2utcSergio(mean(prof.p2x.rtime));
  
    figure(6); hold on; plot(prof.h2x.vchan,rad2bt(prof.h2x.vchan,prof.pavg.mean_cloud_calc),'ko','linewidth',3,'markersize',5); hold off
    %figure(7); clf; plot(prof.h2x.vchan,rad2bt(prof.h2x.vchan,prof.p2x.rcalc))
  
    %%I loaded in 2013, so from Sept 2002 to Jan 2013 is about (2012-2002)*23 + (4*30/23) = timestep 235
    figure(7); clf;  plot(ind54.quants(2:end),ind54.quantile1231_desc(235+tt-1,:),'o-',ind54.quants,quantile(rad2bt(prof.h2x.vchan(5),prof.p2x.rcalc(5,:)),ind54.quants),'rx-');
    figure(7); clf;  plot(ind54.quants(2:end),ind54.quantile1231_desc(235+tt-1,:),'o-',ind54.quants,quantile(rad2bt(prof.h2x.vchan(5),prof.p2x.sarta_rclearcalc(5,:)),ind54.quants),'rx-');
    hl = legend('Obs BT1231 quantiles','ERA quantiles','location','best','fontsize',8); title(['timestep ' num2str(tt) ' : ' num2str(mmm,'%02d') '/' num2str(ddd,'%02d') ])
    pause(0.1)
    wahCld = quantile(rad2bt(prof.h2x.vchan(5),prof.p2x.rcalc(5,:)),ind54.quants);
    wahClr = quantile(rad2bt(prof.h2x.vchan(5),prof.p2x.sarta_rclearcalc(5,:)),ind54.quants);
    saveOBS(tt) = ind54.quantile1231_desc(235+tt-1,16);
    saveOBS_HOT(tt) = ind54.maxBT1231_desc(235+tt-1);
    saveCALClr(tt) = wahClr(end);
    saveCALCld(tt) = wahCld(end);
    saveTT(tt) = mmm + ddd/30;
  end
  figure(7); plot(saveTT,saveOBS,'b',saveTT,saveOBS_HOT,'c',saveTT,saveCALClr,'r',saveTT,saveCALCld,'m'); hl = legend('obs','max obs','cal clr','cal cld','location','best','fontsize',10); xlim([min(saveTT) max(saveTT)])

  iChooseLatLonBin = input('Enter Lonbin/Latbin to look at (Lonbin 54 Latbin 32 -- is a good one, over Indonesia)  0 to stop: ');
end
