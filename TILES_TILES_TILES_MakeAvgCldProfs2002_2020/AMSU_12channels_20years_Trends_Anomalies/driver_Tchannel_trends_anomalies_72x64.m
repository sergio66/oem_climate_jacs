addpath /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/StrowCodeforTrendsAndAnomalies/
addpath /home/sergio/MATLABCODE/COLORMAP
addpath /home/sergio/MATLABCODE/COLORMAP/LLS

%so data since Oct 1998
%[change2days(1998,10,15,1978) a.time(1)]
%[change2days(2024,07,15,1978) a.time(end)]

%see channel and noise info eg 
%  https://en.wikipedia.org/wiki/Advanced_microwave_sounding_unit
%  https://space.oscar.wmo.int/instruments/view/amsu_a
% CH 4-14 are tropospheric and stratospheric temperatures, with Ch 4 being "surface" and Ch 14 being "upper strat"

dir0 = '/home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/AMSU_12channels_20years_Trends_Anomalies/';
dir0 = 'AMSU_12channels_20years/';

do_XX_YY_from_X_Y
iChan = 4;
a = read_netcdf_lls([dir0 '/NOAA-STAR_TCDR_AMSUA_Ch' num2str(iChan) '_Monthly_S199811-E202406_V2.0.nc']);
plot(a.latitude,ones(size(a.latitude)),'b.-',rlat,ones(size(rlat)),'r.-');
plot(a.latitude,a.latitude,'b.-',rlat,rlat,'r.-')
for jj = 1 : 72
  line([a.latitude(jj) a.latitude(jj)],[a.latitude_bounds(1,jj) a.latitude_bounds(2,jj)],'color','b');
end
for jj = 1 : 64
  line([rlat(jj) rlat(jj)],[rlat65(jj) rlat65(jj+1)],'color','r');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for jj = 1 : 64
  boo = find(a.latitude >= rlat65(jj) & a.latitude < rlat65(jj+1));
  boo = find(a.latitude_bounds(1,:) >= rlat65(jj) & a.latitude_bounds(2,:) < rlat65(jj+1));
  boo1 = find(a.latitude_bounds(1,:) <= rlat65(jj)   & a.latitude_bounds(2,:) >= rlat65(jj));
  boo2 = find(a.latitude_bounds(1,:) <= rlat65(jj+1) & a.latitude_bounds(2,:) >= rlat65(jj+1));
  if length(boo1) > 0 & length(boo2) > 0
    countY(jj) = 1;
  end
end
plot(rlat,countY,'.-')
for ii = 1 : 72
  boo = find(a.longitude >= rlon73(ii) & a.longitude < rlon73(ii+1));
  boo = find(a.longitude_bounds(1,:) >= rlon73(ii) & a.longitude_bounds(2,:) < rlon73(ii+1));
  countX(ii) = length(boo);
  boo1 = find(a.longitude_bounds(1,:) <= rlon73(jj)   & a.longitude_bounds(2,:) >= rlon73(jj));
  boo2 = find(a.longitude_bounds(1,:) <= rlon73(jj+1) & a.longitude_bounds(2,:) >= rlon73(jj+1));
  if length(boo1) > 0 & length(boo2) > 0
    countX(ii) = 1;
  end
end
plot(rlon,countX,'.-')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iChan < 14
  ix = (1:309)-1; ix = 1998 + ix/12; %% boo = find(ix > 2002.75 & ix <= 2022.75); === 59 to 298 
else
  ix = (1:282)-1; ix = 1998 + ix/12; %% boo = find(ix > 2002.75 & ix <= 2022.75); === 59 to 282 
end
for jj = 1 : 64
  for ii = 1 : 72
    boo1 = find(a.latitude_bounds(1,:) <= rlat65(jj)   & a.latitude_bounds(2,:) >= rlat65(jj));
    boo2 = find(a.latitude_bounds(1,:) <= rlat65(jj+1) & a.latitude_bounds(2,:) >= rlat65(jj+1));
    boo3 = find(a.longitude_bounds(1,:) <= rlon73(ii)   & a.longitude_bounds(2,:) >= rlon73(ii));
    boo4 = find(a.longitude_bounds(1,:) <= rlon73(ii+1) & a.longitude_bounds(2,:) >= rlon73(ii+1));
    if length(boo1) > 0 & length(boo2) > 0 & length(boo3) > 0 & length(boo4) > 0
      countXY(ii,jj) = 1;
    end
    xjunk = boo3:boo4;
    yjunk = boo1:boo2;
    boo = find(ix > 2002.75 & ix <= 2022.75); fprintf(1,'iChan = %2i 2002/09 to 20022/08 = %3i to %3i \n',iChan,min(boo),max(boo))
    wah = a.T_SNO(xjunk,yjunk,boo); 
    junk = squeeze(nanmean(wah,3));
    wahsave(ii,jj) = nanmean(junk(:));
  end
end
figure(1); pcolor(squeeze(a.T_SNO(:,:,300))'); colorbar; colormap jet; title('144 x 72 res')
figure(2); pcolor(wahsave'); colorbar; colormap jet; title('72 x 64 res')
pause(1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for iChan = 4:14
  if iChan ~= 14
    a = read_netcdf_lls([dir0 '/NOAA-STAR_TCDR_AMSUA_Ch' num2str(iChan) '_Monthly_S199811-E202406_V2.0.nc']);
  else
    a = read_netcdf_lls([dir0 '/NOAA-STAR_TCDR_AMSUA_Ch' num2str(iChan) '_Monthly_S200101-E202406_V2.0.nc']);
  end
  %% May 2021 : gave AIRS_STM presentation on anomaly time series retrievals for (TWP) tile lat = 35, lon = 66
  %% (35-1)*72 + 66 == 2514;      plot_72x64tles(2514,4608)
  lat = find(a.latitude_bounds(1,:) >= 5.5 &  a.latitude_bounds(2,:) <= 8.25);
  lat = find(a.latitude_bounds(1,:) >= 5.0 &  a.latitude_bounds(2,:) <= 8.25);
  lon = find(a.longitude_bounds(1,:) >= 145 &  a.longitude_bounds(2,:) <= 150);

  doh = squeeze(a.T_SNO(lon(1),lat(1),:));
  if iChan < 14
    ix = (1:309)-1; ix = 1998 + ix/12; %% boo = find(ix > 2002.75 & ix <= 2022.75); === 59 to 298 
  else
    ix = (1:282)-1; ix = 1998 + ix/12; %% boo = find(ix > 2002.75 & ix <= 2022.75); === 59 to 282 
  end
  boo = find(ix > 2002.75 & ix <= 2022.75); fprintf(1,'iChan = %2i 2002/09 to 20022/08 = %3i to %3i \n',iChan,min(boo),max(boo))

  figure(1); clf; plot(ix,doh); grid; xlim([2002.75 2024.75-2]); title(num2str(iChan));

  wah = a.T_SNO(:,:,boo); wah = nanmean(squeeze(nanmean(wah,1)),2);
  figure(2); clf; plot(a.latitude,wah); grid; title(num2str(iChan));

  wah = a.T_SNO(:,:,boo); wah = squeeze(nanmean(wah,1)); wahM = nanmean(wah,2) * ones(1,length(boo));;
  figure(3); clf; pcolor(a.latitude,ix(boo),wah');      shading interp; colormap jet;                     title(num2str(iChan)); colorbar
  figure(4); clf; pcolor(a.latitude,ix(boo),wah'-wahM'); shading interp; colormap(usa2); caxis([-1 +1]*5); title(num2str(iChan)); colorbar

  disp('ret to continue'); pause(0.1)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[a.time_bounds(:,1:10); a.time(1:10)']'
for iChan = 4:14
  if iChan ~= 14
    a = read_netcdf_lls([dir0 '/NOAA-STAR_TCDR_AMSUA_Ch' num2str(iChan) '_Monthly_S199811-E202406_V2.0.nc']);
  else
    a = read_netcdf_lls([dir0 '/NOAA-STAR_TCDR_AMSUA_Ch' num2str(iChan) '_Monthly_S200101-E202406_V2.0.nc']);
  end

  if iChan < 14
    ix = (1:309)-1; ix = 1998 + ix/12; %% boo = find(ix > 2002.75 & ix <= 2022.75); === 59 to 298 
  else
    ix = (1:282)-1; ix = 1998 + ix/12; %% boo = find(ix > 2002.75 & ix <= 2022.75); === 59 to 282 
  end

  boo = find(ix > 2002.75 & ix <= 2022.75); fprintf(1,'iChan = %2i 2002/09 to 20022/08 = %3i to %3i \n',iChan,min(boo),max(boo))
  thetime = a.time(boo);
  for jj = 1 : 64
    fprintf(1,'latbin %3i of 64 \n',jj);
    for ii = 1 : 72
      boo1 = find(a.latitude_bounds(1,:) <= rlat65(jj)   & a.latitude_bounds(2,:) >= rlat65(jj));
      boo2 = find(a.latitude_bounds(1,:) <= rlat65(jj+1) & a.latitude_bounds(2,:) >= rlat65(jj+1));
      boo3 = find(a.longitude_bounds(1,:) <= rlon73(ii)   & a.longitude_bounds(2,:) >= rlon73(ii));
      boo4 = find(a.longitude_bounds(1,:) <= rlon73(ii+1) & a.longitude_bounds(2,:) >= rlon73(ii+1));
      if length(boo1) > 0 & length(boo2) > 0 & length(boo3) > 0 & length(boo4) > 0
        countXY(ii,jj) = 1;
      end
      xjunk = boo3:boo4;
      yjunk = boo1:boo2;
      wah = a.T_SNO(xjunk,yjunk,boo); 
      if length(xjunk) > 1 & length(yjunk) > 1
        wah = squeeze(nanmean(wah,1));
        wah = squeeze(nanmean(wah,1));
      else
        wah = squeeze(wah);
        wah = squeeze(nanmean(wah,1));       
      end
      good = find(isfinite(wah));
      if length(good) > 10
        [B, stats, err] = Math_tsfit_lin_robust(thetime(good),wah(good)',4);
        trend_T(iChan,ii,jj) = B(2);
        trend_T_err(iChan,ii,jj) = stats.se(2);

        [x_anom B2 stats2] = generic_compute_anomaly(thetime(good),wah(good));
        anom_T(iChan,ii,jj,good) = x_anom;
      else
        trend_T(iChan,ii,jj) = nan;;
        trend_T_err(iChan,ii,jj) = nan;
        anom_T(iChan,ii,jj,1:240) = nan;
      end    %% if then
    end      %% lon loop
  end        %% lat loop
end          %% chan loop

load llsmap5
pseudo_p = fliplr(linspace(100,1000,11));
%% https://www.researchgate.net/figure/Vertical-distribution-of-the-AMSU-A-channels-3-14-weighting-function-at-nadir-over-land_fig2_238941978
pseudo_p = [ 900 600 350 275 180  90 50 25 10  5 2]; 

%% https://www.star.nesdis.noaa.gov/jpss/documents/AMM_All/ATMS_SDR/Provisional/ATMS-GPS-RO-calibration.pdf
pseudo_p = [1085 892 606 351 253 165 86 49 24 10 5] ;

wah = squeeze(nanmean(trend_T(4:14,:,:),2));
figure(3); pcolor(rlat,pseudo_p,wah); shading interp; caxis([-1 +1]*0.15); colormap(llsmap5); colorbar; set(gca,'ydir','reverse'); set(gca,'yscale','log');
ylim([10 1000])

%{
save trends_anomalies_AMSU_20year_72x64.mat trend_T trend_T_err anom_T
%}

