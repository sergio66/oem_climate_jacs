%% see clust_check_howard_16daytimesetps_2013_raw_griddedV2.m -> clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m
%% see clust_check_howard_16daytimesetps_2013_raw_griddedV2.m -> clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m
%% see clust_check_howard_16daytimesetps_2013_raw_griddedV2.m -> clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m

addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/COLORMAP
addpath /asl/matlib/aslutil

iTile = 2788;  % land
iTile = 2786;  % arabian sea
iTile = input('Enter tile   [India : 2788 land    2786 ocean]       [Sudan : 2564-2565] : ');
if length(iTile) == 0
  iTile = 2788;
end

junk = translator_wrong2correct(iTile)
EW = junk.correctname(end-09:end-03);
NS = junk.correctname(end-16:end-11);
%% comment6 = 'India : if you want sergioindex = 2788 = latbin=39,lonbin=52, then you need howard index from correct.wrongind(2788) = 0448 = correct.name{2788} = N16p50_E075p00.nc';

JOB = 243;  %% 480 timesteps till Sep 2023   Mar 2013
JOB = 240;  %% 480 timesteps till Sep 2023   Feb 2013 
JOB = 003;  %% 480 timesteps till Sep 2023   Sept 2002
JOB = 246;  %% 480 timesteps till Sep 2023   May 2013
JOB = input('Enter timestep (240 = default as after 20 years we have 450 timesteps, so 225 is about halfway there) : ');
if length(JOB) == 0
  JOB = 240;
end

hugedir = dir('/asl/isilon/airs/tile_test7/');  

date_stamp = ['2015_s283'];   %% example
date_stamp = hugedir(JOB).name;
fprintf(1,'JOB = %4i date_stamp = %s \n',JOB,date_stamp);

thedir0 = dir(['/asl/isilon/airs/tile_test7/' date_stamp '/']);
% for iii = 3 : length(thedir0)
%  dirdirname = ['/asl/isilon/airs/tile_test7/' date_stamp '/' thedir0(iii).name];
%   dirx = dir([dirdirname '/*.nc']);
%   for jjj = 1 : length(dirx)
%     fname = [dirdirname '/' dirx(jjj).name];
%     iTile = iTile + 1;
%     thesave.fname{iTile} = fname;
%     fprintf(1,'%4i %4i %4i %s \n',iii-2,jjj,iTile,fname);
%   end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fname = ['/asl/isilon/airs/tile_test7/' date_stamp '/N16p50_E075p00/*.nc'];
fname = ['/asl/isilon/airs/tile_test7/2013_s239/N16p50/tile_2013_s239_N16p50_E075p00.nc'];
fname = ['/asl/isilon/airs/tile_test7/' date_stamp '/N16p50/tile_' date_stamp '_N16p50_E075p00.nc'];
fname = ['/asl/isilon/airs/tile_test7/' date_stamp '/N16p50/tile_' date_stamp '_N16p50_' EW '.nc'];
fname = ['/asl/isilon/airs/tile_test7/' date_stamp '/' NS '/tile_' date_stamp '_' NS '_' EW '.nc'];
fprintf(1,' >>> reading Howard tile %s \n',fname);
[s, a] = read_netcdf_h5(fname);

dbt = 180 : 1 : 340;
set_iQAX
ianpts = 1:s.total_obs;

thesave.max1231_asc = nan(1,4608);
thesave.min1231_asc = nan(1,4608);
thesave.DCC1231_asc = nan(1,4608);
%thesave.hist_asc = nan(4608,length(quants)-1);
thesave.hist_asc = nan(4608,length(dbt));
asc = find(s.asc_flag(ianpts) == 65);  
    X = rad2bt(1231,s.rad(1520,asc)); 
    Y = quantile(X,quants);
    thesave.max1231_asc(iTile) = max(X);
    thesave.min1231_asc(iTile) = min(X);
    thesave.DCC1231_asc(iTile) = length(find(X < 220));
    thesave.hist_asc(iTile,:) = histc(X,dbt)/length(X);
    for qq = 1 : length(quants)-1

      select_Zdata_based_on_iQAX_and_qq %%%% <<<<<<<<<<<<<<<<<<<<< this is the selector >>>>>>>>>>>>>>>>>>>>>>>>
      thesave.asc_Z{qq} = asc(Z);

      thesave.quantile1231_asc(iTile,qq) = Y(qq);
      thesave.count_quantile1231_asc(iTile,qq) = length(Z);
      if length(Z) >= 2
        thesave.rad_asc(iTile,qq,:) = nanmean(s.rad(:,asc(Z)),2);   
        thesave.satzen_quantile1231_asc(iTile,qq) = nanmean(s.sat_zen(asc(Z)));
        thesave.solzen_quantile1231_asc(iTile,qq) = nanmean(s.sol_zen(asc(Z)));
      elseif length(Z) == 1
        thesave.rad_asc(iTile,qq,:) = s.rad(:,asc(Z));   
        thesave.satzen_quantile1231_asc(iTile,qq) = s.sat_zen(asc(Z));
        thesave.solzen_quantile1231_asc(iTile,qq) = s.sol_zen(asc(Z));
      elseif length(Z) == 0
        thesave.rad_asc(iTile,qq,:) = NaN;
        thesave.satzen_quantile1231_asc(iTile,qq) = NaN;
        thesave.solzen_quantile1231_asc(iTile,qq) = NaN;
      end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%

thesave.max1231_desc = nan(1,4608);
thesave.min1231_descc = nan(1,4608);
thesave.DCC1231_desc = nan(1,4608);
%thesave.hist_desc = nan(4608,length(quants)-1);
thesave.hist_desc = nan(4608,length(dbt));
desc = find(s.asc_flag(ianpts) == 68);  
    X = rad2bt(1231,s.rad(1520,desc)); 
    Y = quantile(X,quants);
    thesave.max1231_desc(iTile) = max(X);
    thesave.min1231_desc(iTile) = min(X);
    thesave.DCC1231_desc(iTile) = length(find(X < 220));
    thesave.hist_desc(iTile,:) = histc(X,dbt)/length(X);
    for qq = 1 : length(quants)-1

      select_Zdata_based_on_iQAX_and_qq %%%% <<<<<<<<<<<<<<<<<<<<< this is the selector >>>>>>>>>>>>>>>>>>>>>>>>
      thesave.desc_Z{qq} = desc(Z);

      thesave.quantile1231_desc(iTile,qq) = Y(qq);
      thesave.count_quantile1231_desc(iTile,qq) = length(Z);
      if length(Z) >= 2
        thesave.rad_desc(iTile,qq,:) = nanmean(s.rad(:,desc(Z)),2);   
        thesave.satzen_quantile1231_desc(iTile,qq) = nanmean(s.sat_zen(desc(Z)));
        thesave.solzen_quantile1231_desc(iTile,qq) = nanmean(s.sol_zen(desc(Z)));
      elseif length(Z) == 1
        thesave.rad_desc(iTile,qq,:) = s.rad(:,desc(Z));   
        thesave.satzen_quantile1231_desc(iTile,qq) = s.sat_zen(desc(Z));
        thesave.solzen_quantile1231_desc(iTile,qq) = s.sol_zen(desc(Z));
      elseif length(Z) == 0
        thesave.rad_desc(iTile,qq,:) = NaN;
        thesave.satzen_quantile1231_desc(iTile,qq) = NaN;
        thesave.solzen_quantile1231_desc(iTile,qq) = NaN;
      end
    end

figure(1); clf; plot(dbt-273.15,thesave.hist_desc(iTile,:),'b',dbt-273.15,thesave.hist_asc(iTile,:),'r','linewidth',2);
figure(2); clf; plot(s.lon(thesave.desc_Z{3}),s.lat(thesave.desc_Z{3}),'b.',s.lon(thesave.asc_Z{3}),s.lat(thesave.asc_Z{3}),'r.'); title('Q03 locations'); hl = legend('desc','asc','location','best','fontsize',10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% see /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/loop_reader_India_Met_Data.m
%  iTile = 2788;
      indY = floor(iTile/72);
      indX = iTile - indY*72;
      indY = indY + 1;
  dir0 = '/home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/DATAObsStats_StartSept2002_CORRECT_LatLon/';
  ftrend = ['/LatBin' num2str(indY,'%02i') '/LonBin' num2str(indX,'%02i') '/iQAX_3_summarystats_LatBin' num2str(indY,'%02i') '_LonBin' num2str(indX,'%02i') '_timesetps_001_457_V1.mat'];
  fprintf(1,'>>> ftrend sergio saved = %s \n',ftrend)
  trend_data = load([dir0 ftrend]);

  jett = jet(256); jett(1,:) = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1)
JOBB = JOB - 2; %% two missing time steps?????
for ii = -2 : 2
  JOBB = JOB + ii; %% N missing time steps
  plot(dbt-273.15,thesave.hist_desc(iTile,:),'b',dbt-273.15,thesave.hist_asc(iTile,:),'r',dbt-273.15,trend_data.hist1231_desc(JOBB,:),'c',dbt-273.15,trend_data.hist1231_asc(JOBB,:),'m', 'linewidth',2);
  hl = legend('Desc Fresh Read','Asc Fresh Read','Saved last year Desc','Saved last year Asc','location','best','fontsize',10);
  title(num2str(ii)); 
  pause(0.1)
  %pause
end

if JOB < 160
  ii = -2;
elseif JOB < 260
  ii = -1; 
else
  ii = 0;
end

figure(1);
JOBB = JOB + ii; %% one missing time steps
plot(dbt-273.15,thesave.hist_desc(iTile,:),'b',dbt-273.15,thesave.hist_asc(iTile,:),'r',dbt-273.15,trend_data.hist1231_desc(JOBB,:),'c',dbt-273.15,trend_data.hist1231_asc(JOBB,:),'m', 'linewidth',2);
  title(num2str(ii)); 
plot(dbt-273.15,thesave.hist_desc(iTile,:),'bx-',dbt-273.15,thesave.hist_asc(iTile,:),'rx-',dbt-273.15,trend_data.hist1231_desc(JOBB,:),'c',dbt-273.15,trend_data.hist1231_asc(JOBB,:),'m', 'linewidth',2);
  xlabel('BT1231 deg C'); ylabel('Normalized hist'); xlim([-10 +60])
  title([num2str(trend_data.year_asc(JOBB)) '/' num2str(floor(trend_data.month_asc(JOBB)),'%02i')] ); 
  ax = axis;
  %for ii = 1:5
  %  line([trend_data.quantile1231_desc(JOBB,ii) trend_data.quantile1231_desc(JOBB,ii)]-273.15,[0 ax(4)],'color','c')
  %  line([trend_data.quantile1231_asc(JOBB,ii) trend_data.quantile1231_asc(JOBB,ii)]-273.15,[0 ax(4)],'color','m')
  %end
  line([trend_data.quantile1231_desc(JOBB,:); trend_data.quantile1231_desc(JOBB,:)]-273.15,[0 0 0 0 0; ax(4) ax(4) ax(4) ax(4) ax(4)],'color','c')
  line([trend_data.quantile1231_asc(JOBB,:); trend_data.quantile1231_asc(JOBB,:)]-273.15,  [0 0 0 0 0; ax(4) ax(4) ax(4) ax(4) ax(4)],'color','m')
  hl = legend('Desc Fresh Read','Asc Fresh Read','Saved last year Desc','Saved last year Asc','location','best','fontsize',10);

%%%%%%%%%%%%%%%%%%%%%%%%%

  figure(2); clf; vertices = plot_72x64_tiles(iTile);

  figure(2); clf; scatter(s.lon(thesave.asc_Z{3}),s.lat(thesave.asc_Z{3}),25,rad2bt(1231,s.rad(1520,thesave.asc_Z{3}))-273.15,'filled'); title('BT1231 [deg C] ASC Q03 locations'); colormap jet; colorbar
  rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);
  moo = load('coast.mat');
  hold on; plot(moo.long,moo.lat,'k','linewidth',2); hold off
  axis([vertices(1)-10 vertices(2)+10 vertices(3)-10 vertices(4)+10])
  axis([vertices(1)-4 vertices(2)+4 vertices(3)-4 vertices(4)+4])

  figure(3); clf; scatter(s.lon(thesave.desc_Z{3}),s.lat(thesave.desc_Z{3}),25,rad2bt(1231,s.rad(1520,thesave.desc_Z{3}))-273.15,'filled'); title('BT1231 [deg C] DESC Q03 locations'); colormap jet; colorbar
  rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);
  moo = load('coast.mat');
  hold on; plot(moo.long,moo.lat,'k','linewidth',2); hold off
  axis([vertices(1)-10 vertices(2)+10 vertices(3)-10 vertices(4)+10])
  axis([vertices(1)-4 vertices(2)+4 vertices(3)-4 vertices(4)+4])

  figure(4); clf; plot(s.lon(thesave.desc_Z{3}),s.lat(thesave.desc_Z{3}),'b.',s.lon(thesave.asc_Z{3}),s.lat(thesave.asc_Z{3}),'r.'); title('Q03 locations'); 
                  hl = legend('desc','asc','location','best','fontsize',10);
  rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);
  moo = load('coast.mat');
  hold on; plot(moo.long,moo.lat,'k','linewidth',2); hold off
  axis([vertices(1)-10 vertices(2)+10 vertices(3)-10 vertices(4)+10])
  axis([vertices(1)-4 vertices(2)+4 vertices(3)-4 vertices(4)+4])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  figure(5);
  daysSince2002 = change2days(trend_data.year_asc,trend_data.month_asc,trend_data.day_asc,2002);
  figure(5); pcolor(2002+daysSince2002/365,trend_data.dbt-273.15,log10(trend_data.hist1231_desc')); shading flat; colorbar; title('BT1231 DESC'); colormap(jett); caxis([-3.5 -1.5]); xlabel('Time'); ylabel('BT1231 deg C')
    hold on; plot(2002+daysSince2002/365,trend_data.quantile1231_desc(:,3)-273.15,'kx-','linewidth',2); hold off
  figure(6); pcolor(2002+daysSince2002/365,trend_data.dbt-273.15,log10(trend_data.hist1231_asc'));  shading flat; colorbar; title('BT1231 ASC'); colormap(jett); caxis([-3.5 -1.5]); xlabel('Time'); ylabel('BT1231 deg C')
    hold on; plot(2002+daysSince2002/365,trend_data.quantile1231_asc(:,3)-273.15,'kx-','linewidth',2); hold off

load h2645structure.mat
figure(7);
plot(h.vchan,rad2bt(h.vchan,s.rad(:,thesave.desc_Z{3}))-273.15,'b',h.vchan,rad2bt(h.vchan,s.rad(:,thesave.asc_Z{3}))-273.15,'r'); 
title('(r) ASC (b) DESC Q03'); ylabel('BT(wavenumber) [deg C]')
xlim([640 1640])
