addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/MODIS_CLOUD
addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/COLORMAP
%% addpath /home/sergio/MATLABCODE/CRODGERS_FAST_CLOUD
addpath /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/StrowCodeforTrendsAndAnomalies
 addpath /home/sergio/MATLABCODE/PLOTMISC

%{
https://doi.org/10.5194/acp-23-6559-2023
Opposing trends of cloud coverage over land and ocean under global warming
Huan Liu, Ilan Koren, Orit Altaratz, and Mickaël D. Chekroun
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fname =  '/asl/s1/sergio/MODIS_MONTHLY_L3/AEROSOL/DATA/2024/MYD08_M3.A2024153.061.2024187025207.hdf';

addpath /home/sergio/MATLABCODE/COLORMAP/COLORBREWER/cbrewer/cbrewer
blues = flipud(cbrewer('seq', 'Blues', 256));

timeS = [2019 01]; timeE = [2021 12];  %% COVID
timeS = [2002 09]; timeE = [2022 08];  %% 20 years
timeS = [2020 07]; timeE = [2024 06];  %% last 4 years
timeS = [2002 09]; timeE = [2024 06];  %% 22.5 years

if ~exist('od_liq')
  iCnt = 0;
  for yy = timeS(1) : timeE(1)
    days = [001 032 060 091 121 152 182 213 244 274 305 335];
    if mod(yy,4) == 0
      days(3:end) =  days(3:end) + 1;
    end
    mmS = 01; mmE = 12;
    if yy == timeS(1)
      mmS = timeS(2);
    elseif yy == timeE(1)
      mmE = timeE(2);
    end
    for mm = mmS : mmE
      fprintf(1,'%4i/%2i \n',yy,mm)
      savematname = ['/asl/s1/sergio/MODIS_MONTHLY_L3/AEROSOL/SUMMARY_MAT/modisL3cloud_' num2str(yy) '_' num2str(mm,'%02d') '.mat'];
      a = load(savematname);
      iCnt = iCnt + 1;
      
      od_liq(iCnt,:,:)   = a.summary.CloudOD_Liq_72x64;
      od_ice(iCnt,:,:)   = a.summary.CloudOD_Ice_72x64;
      iwp_liq(iCnt,:,:)  = a.summary.CloudIWP_Liq_72x64;
      iwp_ice(iCnt,:,:)  = a.summary.CloudIWP_Ice_72x64;
      dme_liq(iCnt,:,:)  = a.summary.CloudDME_Liq_72x64;
      dme_ice(iCnt,:,:)  = a.summary.CloudDME_Ice_72x64;
      cldtop(iCnt,:,:)   = a.summary.CloudTopP_72x64;
      cldfrac(iCnt,:,:)  = a.summary.CloudFrac_72x64;
      cldtopD(iCnt,:,:)   = a.summary.CloudTopP_Day_72x64;
      cldfracD(iCnt,:,:)  = a.summary.CloudFrac_Day_72x64;
      cldtopN(iCnt,:,:)   = a.summary.CloudTopP_Night_72x64;
      cldfracN(iCnt,:,:)  = a.summary.CloudFrac_Night_72x64;

      od_liqALL(iCnt,:,:)   = a.summary.CloudOD_Liq;
      od_iceALL(iCnt,:,:)   = a.summary.CloudOD_Ice;
      iwp_liqALL(iCnt,:,:)  = a.summary.CloudIWP_Liq;
      iwp_iceALL(iCnt,:,:)  = a.summary.CloudIWP_Ice;
      dme_liqALL(iCnt,:,:)  = a.summary.CloudDME_Liq;
      dme_iceALL(iCnt,:,:)  = a.summary.CloudDME_Ice;
      cldtopALL(iCnt,:,:)   = a.summary.CloudTopP;
      cldfracALL(iCnt,:,:)  = a.summary.CloudFrac;
      cldtopALLD(iCnt,:,:)   = a.summary.CloudTopP_Day;
      cldfracALLD(iCnt,:,:)  = a.summary.CloudFrac_Day;
      cldtopALLN(iCnt,:,:)   = a.summary.CloudTopP_Night;
      cldfracALLN(iCnt,:,:)  = a.summary.CloudFrac_Night;

      yyseries(iCnt) = yy;
      mmseries(iCnt) = mm;
      ddseries(iCnt) = a.dd;
      doy(iCnt) = change2days(yy,01,01,2002) + (a.dd-1);
    end
  end
end

figure(1); clf; pcolor(squeeze(nanmean(cldfracALL,1))');  shading interp; colormap(blues); colorbar; title('Avg CldFracA 360 x 180');
figure(2); clf; pcolor(squeeze(nanmean(cldfracALLD,1))'); shading interp; colormap(blues); colorbar; title('Avg CldFracD 360 x 180');
figure(3); clf; pcolor(squeeze(nanmean(cldfracALLN,1))'); shading interp; colormap(blues); colorbar; title('Avg CldFracN 360 x 180');
figure(4); clf; pcolor(squeeze(nanmean(cldfrac,1))');     shading interp; colormap(blues); colorbar; title('Avg CldFracA 72 x 64');
figure(5); clf; pcolor(squeeze(nanmean(cldfracD,1))');    shading interp; colormap(blues); colorbar; title('Avg CldFracD 72 x 64');
figure(6); clf; pcolor(squeeze(nanmean(cldfracN,1))');    shading interp; colormap(blues); colorbar; title('Avg CldFracN 72 x 64');

pause(1)
disp('ret to continue'); pause

yymm = yyseries + (mmseries-1)/12;

coslat    = cos(meanvaluebin(a.summary.LatitudeBins)*pi/180);
coslatAll = cos(meanvaluebin(a.summary.LatitudeBins'         )*pi/180) * ones(1,iCnt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% see ../Code_for_TileTrends/tile_fits_quantiles_anomalies.m

%    [b_desc(ch,qi,:)     stats] = Math_tsfit_lin_robust(dtime(k_desc)-dtime(k_desc(1)),r(k_desc),iNumSineCosCycles);
%    [bt_anom_desc(qi,ch,:) rad_anom_desc(qi,ch,:)] = compute_anomaly(k_desc,dtime,squeeze(b_desc(ch,qi,:)),fairs(ch),r);
%    [b_desc(ch,qi,:)  stats bt_anom_desc(qi,ch,:) rad_anom_desc(qi,ch,:)] = compute_anomaly_wrapper(k_desc,dtime,r,4,fairs(ch),+1,-1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ii = 1 : 180
  junk = squeeze(cldfracALL(:,:,ii)); junk = nanmean(junk,2); boo = find(isfinite(junk)); 
  [B,err,xavg_zonal_anom_cldfrac(ii,:)] = compute_anomaly_wrapper(boo,doy,junk,4,-1,-1);
end
clf; pcolor(yymm,-89.5:1:+89.5,xavg_zonal_anom_cldfrac); shading interp; colormap(usa2); colorbar; caxis([-1 +1]*0.15)
clf; pcolor(yymm,-89.5:1:+89.5,coslatAll .* xavg_zonal_anom_cldfrac); shading interp; colormap(usa2); colorbar; caxis([-1 +1]*0.15)
title('Cld Frac Anomaly')

for ii = 1 : 180
  junk = squeeze(cldfracALLD(:,:,ii)); junk = nanmean(junk,2); boo = find(isfinite(junk)); 
  [B,err,xavg_zonal_anom_cldfracD(ii,:)] = compute_anomaly_wrapper(boo,doy,junk,4,-1,-1);
end
clf; pcolor(yymm,-89.5:1:+89.5,xavg_zonal_anom_cldfracD); shading interp; colormap(usa2); colorbar; caxis([-1 +1]*0.15)
clf; pcolor(yymm,-89.5:1:+89.5,coslatAll .* xavg_zonal_anom_cldfracD); shading interp; colormap(usa2); colorbar; caxis([-1 +1]*0.15)
title('Cld Frac D Anomaly')

for ii = 1 : 180
  junk = squeeze(cldfracALLN(:,:,ii)); junk = nanmean(junk,2); boo = find(isfinite(junk)); 
  [B,err,xavg_zonal_anom_cldfracN(ii,:)] = compute_anomaly_wrapper(boo,doy,junk,4,-1,-1);
end
clf; pcolor(yymm,-89.5:1:+89.5,xavg_zonal_anom_cldfracN); shading interp; colormap(usa2); colorbar; caxis([-1 +1]*0.15)
clf; pcolor(yymm,-89.5:1:+89.5,coslatAll .* xavg_zonal_anom_cldfracN); shading interp; colormap(usa2); colorbar; caxis([-1 +1]*0.15)
title('Cld Frac N Anomaly')

for ii = 1 : 360
  junk = squeeze(cldfracALL(:,ii,:)); junk = nanmean(junk,2); boo = find(isfinite(junk)); 
  [B,err,xavg_meridional_anom_cldfrac(ii,:)] = compute_anomaly_wrapper(boo,doy,junk,4,-1,-1);
end
clf; pcolor(yymm,-179.5:1:+179.5,xavg_meridional_anom_cldfrac); shading interp; colormap(usa2); colorbar; caxis([-1 +1]*0.15)
title('Cld Frac Anomaly Meridional')

for ii = 1 : 360
  junk = squeeze(cldfracALLD(:,ii,:)); junk = nanmean(junk,2); boo = find(isfinite(junk)); 
  [B,err,xavg_meridional_anom_cldfracD(ii,:)] = compute_anomaly_wrapper(boo,doy,junk,4,-1,-1);
end
clf; pcolor(yymm,-179.5:1:+179.5,xavg_meridional_anom_cldfracD); shading interp; colormap(usa2); colorbar; caxis([-1 +1]*0.15)
title('Cld Frac D Anomaly Meridional')

for ii = 1 : 360
  junk = squeeze(cldfracALLN(:,ii,:)); junk = nanmean(junk,2); boo = find(isfinite(junk)); 
  [B,err,xavg_meridional_anom_cldfracN(ii,:)] = compute_anomaly_wrapper(boo,doy,junk,4,-1,-1);
end
clf; pcolor(yymm,-179.5:1:+179.5,xavg_meridional_anom_cldfracN); shading interp; colormap(usa2); colorbar; caxis([-1 +1]*0.15)
title('Cld Frac N Anomaly Meridional')

%%%%%

for ii = 1 : 180
  junk = squeeze(cldtopALL(:,:,ii)); junk = nanmean(junk,2); boo = find(isfinite(junk)); 
  [B,err,xavg_zonal_anom_cldtop(ii,:)] = compute_anomaly_wrapper(boo,doy,junk,4,-1,-1);
end
clf; pcolor(yymm,-89.5:1:+89.5,xavg_zonal_anom_cldtop); shading interp; colormap(usa2); colorbar; caxis([-1 +1]*50.0)
clf; pcolor(yymm,-89.5:1:+89.5,coslatAll .* xavg_zonal_anom_cldtop); shading interp; colormap(usa2); colorbar; caxis([-1 +1]*50.0)
title('Cld Top Anomaly')

for ii = 1 : 180
  junk = squeeze(cldtopALLD(:,:,ii)); junk = nanmean(junk,2); boo = find(isfinite(junk)); 
  [B,err,xavg_zonal_anom_cldtopD(ii,:)] = compute_anomaly_wrapper(boo,doy,junk,4,-1,-1);
end
clf; pcolor(yymm,-89.5:1:+89.5,xavg_zonal_anom_cldtopD); shading interp; colormap(usa2); colorbar; caxis([-1 +1]*50.0)
clf; pcolor(yymm,-89.5:1:+89.5,coslatAll .* xavg_zonal_anom_cldtopD); shading interp; colormap(usa2); colorbar; caxis([-1 +1]*50.0)
title('Cld Top D Anomaly')

for ii = 1 : 180
  junk = squeeze(cldtopALLN(:,:,ii)); junk = nanmean(junk,2); boo = find(isfinite(junk)); 
  [B,err,xavg_zonal_anom_cldtopN(ii,:)] = compute_anomaly_wrapper(boo,doy,junk,4,-1,-1);
end
clf; pcolor(yymm,-89.5:1:+89.5,xavg_zonal_anom_cldtopN); shading interp; colormap(usa2); colorbar; caxis([-1 +1]*50.0)
clf; pcolor(yymm,-89.5:1:+89.5,coslatAll .* xavg_zonal_anom_cldtopN); shading interp; colormap(usa2); colorbar; caxis([-1 +1]*50.0)
title('Cld Top N Anomaly')

%%%%%

for ii = 1 : 180
  junk = squeeze(od_iceALL(:,:,ii)); junk = nanmean(junk,2); boo = find(isfinite(junk)); 
  [B,err,xavg_zonal_anom_od_ice(ii,:)] = compute_anomaly_wrapper(boo,doy,junk,4,-1,-1);
end
clf; pcolor(yymm,-89.5:1:+89.5,xavg_zonal_anom_od_ice); shading interp; colormap(usa2); colorbar; caxis([-1 +1]*5.00)
clf; pcolor(yymm,-89.5:1:+89.5,coslatAll .* xavg_zonal_anom_od_ice); shading interp; colormap(usa2); colorbar; caxis([-1 +1]*5.00)
title('Cld Ice OD Anomaly')

for ii = 1 : 180
  junk = squeeze(od_iceALL(:,:,ii)) + squeeze(od_liqALL(:,:,ii)); junk = nanmean(junk,2); boo = find(isfinite(junk)); 
  [B,err,xavg_zonal_anom_od_ice(ii,:)] = compute_anomaly_wrapper(boo,doy,junk,4,-1,-1);
end
clf; pcolor(yymm,-89.5:1:+89.5,xavg_zonal_anom_od_ice); shading interp; colormap(usa2); colorbar; caxis([-1 +1]*5.00)
clf; pcolor(yymm,-89.5:1:+89.5,coslatAll .* xavg_zonal_anom_od_ice); shading interp; colormap(usa2); colorbar; caxis([-1 +1]*5.00)
title('Cld Ice+Water OD Anomaly')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ii = 1 : iCnt; junk = nanmean(squeeze(dme_iceALL(ii,:,:)),1); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
  [B,err,xavg_anom_dme_ice] = compute_anomaly_wrapper(1:iCnt,doy,data,4,-1,-1);
for ii = 1 : iCnt; junk = nanmean(squeeze(dme_liqALL(ii,:,:)),1); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
  [B,err,xavg_anom_dme_liq] = compute_anomaly_wrapper(1:iCnt,doy,data,4,-1,-1);
for ii = 1 : iCnt; junk = nanmean(squeeze(iwp_iceALL(ii,:,:)),1); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
  [B,err,xavg_anom_iwp_ice] = compute_anomaly_wrapper(1:iCnt,doy,data,4,-1,-1);
for ii = 1 : iCnt; junk = nanmean(squeeze(iwp_liqALL(ii,:,:)),1); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
  [B,err,xavg_anom_iwp_liq] = compute_anomaly_wrapper(1:iCnt,doy,data,4,-1,-1);
for ii = 1 : iCnt; junk = nanmean(squeeze(od_iceALL(ii,:,:)),1); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
  [B,err,xavg_anom_od_ice] = compute_anomaly_wrapper(1:iCnt,doy,data,4,-1,-1);
for ii = 1 : iCnt; junk = nanmean(squeeze(od_liqALL(ii,:,:)),1); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
  [B,err,xavg_anom_od_liq] = compute_anomaly_wrapper(1:iCnt,doy,data,4,-1,-1);

for ii = 1 : iCnt; junk = nanmean(squeeze(cldtopALL(ii,:,:)),1); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
  [B,err,xavg_anom_cldtop] = compute_anomaly_wrapper(1:iCnt,doy,data,4,-1,-1);
for ii = 1 : iCnt; junk = nanmean(squeeze(cldtopALLD(ii,:,:)),1); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
  [B,err,xavg_anom_cldtopD] = compute_anomaly_wrapper(1:iCnt,doy,data,4,-1,-1);
for ii = 1 : iCnt; junk = nanmean(squeeze(cldtopALLN(ii,:,:)),1); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
  [B,err,xavg_anom_cldtopN] = compute_anomaly_wrapper(1:iCnt,doy,data,4,-1,-1);

for ii = 1 : iCnt; junk = nanmean(squeeze(cldfracALL(ii,:,:)),1); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
  [B,err,xavg_anom_cldfrac] = compute_anomaly_wrapper(1:iCnt,doy,data,4,-1,-1);
for ii = 1 : iCnt; junk = nanmean(squeeze(cldfracALLD(ii,:,:)),1); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
  [B,err,xavg_anom_cldfracD] = compute_anomaly_wrapper(1:iCnt,doy,data,4,-1,-1);
for ii = 1 : iCnt; junk = nanmean(squeeze(cldfracALLN(ii,:,:)),1); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
  [B,err,xavg_anom_cldfracN] = compute_anomaly_wrapper(1:iCnt,doy,data,4,-1,-1);

figure(22); clf;
plot(yymm,(xavg_anom_od_ice+xavg_anom_od_liq)*1,'r',yymm,xavg_anom_cldfrac*50,'b',yymm,xavg_anom_cldtop/10,'k','linewidth',2);
plotaxis2; legend('\tau *1','frac*50','Press/10','location','best','fontsize',10); title('MODIS cld anomalies \newline directly from 180x360xTime')
xlim([floor(min(yymm)) ceil(max(yymm))])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for jj = 1 : 64
  fprintf(1,'Math_tsfit_lin_robust latbin %2i of 64 \n',jj)
  for ii = 1 : 72
    %% fprintf(1,'Math_tsfit_lin_robust latbin %2i of 64 lonbin %2i of 72 \n',jj,ii)
    data = squeeze(od_liq(:,ii,jj));
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats, junkanom] = compute_anomaly_wrapper(boo,doy,data,4,[],-1,-1);
      anom_od_liq(ii,jj,:)    = junkanom;
      trend_od_liq(ii,jj)     = B(2);
      trend_od_liq_unc(ii,jj) = stats.se(2);
      avg_od_liq(ii,jj)       = B(1);
      avg_od_liq_unc(ii,jj)   = stats.se(1);
    else
      anom_od_liq(ii,jj,:)    = nan(1,length(data));
      trend_od_liq(ii,jj)     = nan;
      trend_od_liq_unc(ii,jj) = nan;
      avg_od_liq(ii,jj)       = nan;
      avg_od_liq_unc(ii,jj)   = nan;
    end

    data = squeeze(od_ice(:,ii,jj));
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats, junkanom] = compute_anomaly_wrapper(boo,doy,data,4,[],-1,-1);
      anom_od_ice(ii,jj,:)    = junkanom;
      trend_od_ice(ii,jj)     = B(2);
      trend_od_ice_unc(ii,jj) = stats.se(2);
      avg_od_ice(ii,jj)       = B(1);
      avg_od_ice_unc(ii,jj)   = stats.se(1);
    else
      anom_od_ice(ii,jj,:)    = nan(1,length(data));
      trend_od_ice(ii,jj)     = nan;
      trend_od_ice_unc(ii,jj) = nan;
      avg_od_ice(ii,jj)       = nan;
      avg_od_ice_unc(ii,jj)   = nan;
    end

    data = squeeze(iwp_liq(:,ii,jj));
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats, junkanom] = compute_anomaly_wrapper(boo,doy,data,4,[],-1,-1);
      anom_iwp_liq(ii,jj,:)    = junkanom;
      trend_iwp_liq(ii,jj)     = B(2);
      trend_iwp_liq_unc(ii,jj) = stats.se(2);
      avg_iwp_liq(ii,jj)       = B(1);
      avg_iwp_liq_unc(ii,jj)   = stats.se(1);
    else
      anom_iwp_liq(ii,jj,:)    = nan(1,length(data));
      trend_iwp_liq(ii,jj)     = nan;
      trend_iwp_liq_unc(ii,jj) = nan;
      avg_iwp_liq(ii,jj)       = nan;
      avg_iwp_liq_unc(ii,jj)   = nan;
    end

    data = squeeze(iwp_ice(:,ii,jj));
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats, junkanom] = compute_anomaly_wrapper(boo,doy,data,4,[],-1,-1);
      anom_iwp_ice(ii,jj,:)    = junkanom;
      trend_iwp_ice(ii,jj)     = B(2);
      trend_iwp_ice_unc(ii,jj) = stats.se(2);
      avg_iwp_ice(ii,jj)       = B(1);
      avg_iwp_ice_unc(ii,jj)   = stats.se(1);
    else
      anom_iwp_ice(ii,jj,:)    = nan(1,length(data));
      trend_iwp_ice(ii,jj)     = nan;
      trend_iwp_ice_unc(ii,jj) = nan;
      avg_iwp_ice(ii,jj)       = nan;
      avg_iwp_ice_unc(ii,jj)   = nan;
    end

    data = squeeze(dme_liq(:,ii,jj));
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats, junkanom] = compute_anomaly_wrapper(boo,doy,data,4,[],-1,-1);
      anom_dme_liq(ii,jj,:)    = junkanom;
      trend_dme_liq(ii,jj)     = B(2);
      trend_dme_liq_unc(ii,jj) = stats.se(2);
      avg_dme_liq(ii,jj)       = B(1);
      avg_dme_liq_unc(ii,jj)   = stats.se(1);
    else
      anom_dme_liq(ii,jj,:)    = nan(1,length(data));
      trend_dme_liq(ii,jj)     = nan;
      trend_dme_liq_unc(ii,jj) = nan;
      avg_dme_liq(ii,jj)       = nan;
      avg_dme_liq_unc(ii,jj)   = nan;
    end

    data = squeeze(dme_ice(:,ii,jj));
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats, junkanom] = compute_anomaly_wrapper(boo,doy,data,4,[],-1,-1);
      anom_dme_ice(ii,jj,:)    = junkanom;
      trend_dme_ice(ii,jj)     = B(2);
      trend_dme_ice_unc(ii,jj) = stats.se(2);
      avg_dme_ice(ii,jj)       = B(1);
      avg_dme_ice_unc(ii,jj)   = stats.se(1);
    else
      anom_dme_ice(ii,jj,:)    = nan(1,length(data));
      trend_dme_ice(ii,jj)     = nan;
      trend_dme_ice_unc(ii,jj) = nan;
      avg_dme_ice(ii,jj)       = nan;
      avg_dme_ice_unc(ii,jj)   = nan;
    end

    %%%%%

    data = squeeze(cldtop(:,ii,jj));
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats, junkanom] = compute_anomaly_wrapper(boo,doy,data,4,[],-1,-1);
      anom_cldtop(ii,jj,:)    = junkanom;
      trend_cldtop(ii,jj)     = B(2);
      trend_cldtop_unc(ii,jj) = stats.se(2);
      avg_cldtop(ii,jj)       = B(1);
      avg_cldtop_unc(ii,jj)   = stats.se(1);
    else
      anom_cldtop(ii,jj,:)    = nan(1,length(data));
      trend_cldtop(ii,jj)     = nan;
      trend_cldtop_unc(ii,jj) = nan;
      avg_cldtop(ii,jj)       = nan;
      avg_cldtop_unc(ii,jj)   = nan;
    end

    data = squeeze(cldtopD(:,ii,jj));
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats, junkanom] = compute_anomaly_wrapper(boo,doy,data,4,[],-1,-1);
      anom_cldtopD(ii,jj,:)    = junkanom;
      trend_cldtopD(ii,jj)     = B(2);
      trend_cldtopD_unc(ii,jj) = stats.se(2);
      avg_cldtopD(ii,jj)       = B(1);
      avg_cldtopD_unc(ii,jj)   = stats.se(1);
    else
      anom_cldtopD(ii,jj,:)    = nan(1,length(data));
      trend_cldtopD(ii,jj)     = nan;
      trend_cldtopD_unc(ii,jj) = nan;
      avg_cldtopD(ii,jj)       = nan;
      avg_cldtopD_unc(ii,jj)   = nan;
    end

    data = squeeze(cldtopN(:,ii,jj));
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats, junkanom] = compute_anomaly_wrapper(boo,doy,data,4,[],-1,-1);
      anom_cldtopN(ii,jj,:)    = junkanom;
      trend_cldtopN(ii,jj)     = B(2);
      trend_cldtopN_unc(ii,jj) = stats.se(2);
      avg_cldtopN(ii,jj)       = B(1);
      avg_cldtopN_unc(ii,jj)   = stats.se(1);
    else
      anom_cldtopN(ii,jj,:)    = nan(1,length(data));
      trend_cldtopN(ii,jj)     = nan;
      trend_cldtopN_unc(ii,jj) = nan;
      avg_cldtopN(ii,jj)       = nan;
      avg_cldtopN_unc(ii,jj)   = nan;
    end

    %%%%%

    data = squeeze(cldfrac(:,ii,jj));
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats, junkanom] = compute_anomaly_wrapper(boo,doy,data,4,[],-1,-1);
      anom_cldfrac(ii,jj,:)    = junkanom;
      trend_cldfrac(ii,jj)     = B(2);
      trend_cldfrac_unc(ii,jj) = stats.se(2);
      avg_cldfrac(ii,jj)       = B(1);
      avg_cldfrac_unc(ii,jj)   = stats.se(1);
    else
      anom_cldfrac(ii,jj,:)    = nan(1,length(data));
      trend_cldfrac(ii,jj)     = nan;
      trend_cldfrac_unc(ii,jj) = nan;
      avg_cldfrac(ii,jj)       = nan;
      avg_cldfrac_unc(ii,jj)   = nan;
    end

    data = squeeze(cldfracD(:,ii,jj));
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats, junkanom] = compute_anomaly_wrapper(boo,doy,data,4,[],-1,-1);
      anom_cldfracD(ii,jj,:)    = junkanom;
      trend_cldfracD(ii,jj)     = B(2);
      trend_cldfracD_unc(ii,jj) = stats.se(2);
      avg_cldfracD(ii,jj)       = B(1);
      avg_cldfracD_unc(ii,jj)   = stats.se(1);
    else
      anom_cldfracD(ii,jj,:)    = nan(1,length(data));
      trend_cldfracD(ii,jj)     = nan;
      trend_cldfracD_unc(ii,jj) = nan;
      avg_cldfracD(ii,jj)       = nan;
      avg_cldfracD_unc(ii,jj)   = nan;
    end

    data = squeeze(cldfracN(:,ii,jj));
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats, junkanom] = compute_anomaly_wrapper(boo,doy,data,4,[],-1,-1);
      anom_cldfracN(ii,jj,:)    = junkanom;
      trend_cldfracN(ii,jj)     = B(2);
      trend_cldfracN_unc(ii,jj) = stats.se(2);
      avg_cldfracN(ii,jj)       = B(1);
      avg_cldfracN_unc(ii,jj)   = stats.se(1);
    else
      anom_cldfracN(ii,jj,:)    = nan(1,length(data));
      trend_cldfracN(ii,jj)     = nan;
      trend_cldfracN_unc(ii,jj) = nan;
      avg_cldfracN(ii,jj)       = nan;
      avg_cldfracN_unc(ii,jj)   = nan;
    end

  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sctrend = [];
scavg   = [];
scanom  = [];
iDo_sincosfit = +1; %% TO COMPARE AGAINST ROBUST FIT
iDo_sincosfit = -1; %% DEFAULT

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

doy2002 = doy;
comment = 'see driver_make_cloud_trends_from_modis_L3.m';
fout = ['modis_L3_cloud_trends_' num2str(timeS(1),'%04d') '_' num2str(timeS(2),'%04d') '_' num2str(timeE(1),'%04d') '_' num2str(timeE(2),'%04d') '.mat'];
saver = ['save ' fout ' trend* xavg_anom* avg* anom* sctrend* scavg* scanom* comment doy2002 yyseries mmseries ddseries yymm'];
eval(saver)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

do_XX_YY_from_X_Y

[lenT,lenX,lenY] = size(od_liq);
junkcos = ones(lenT,1) * cos(YY*pi/180); junkcos = reshape(junkcos,lenT,72,64);  junkcos = permute(junkcos,[2 3 1]); clf; pcolor(X,Y,squeeze(junkcos(:,:,1))); colormap jet; colorbar
yymm = timeS(1)+(timeS(2)-1)/12 + ((1:lenT)-1)/12;

jett = jet(128); jett(1,:) = 1;
jett = jet(2048); jett(1,:) = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%

for ii = 1 : lenT
  junk1 = squeeze(anom_od_liq(:,:,ii)); junk1 = junk1(:); %junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_anom_od_liq(ii) = nansum(junk1)/nansum(junk2);

  junk1 = squeeze(od_liq(ii,:,:)); junk1 = junk1(:); junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_od_liq_time(ii) = nansum(junk1)/nansum(junk2);
end

figure(20); clf; plot(yymm,avg_od_liq_time)

%[B, stats, err] = Math_tsfit_lin_robust(doy(boo)-doy(boo(1)),avg_od_liq_time(boo),4);
%  Anom = compute_anomaly(boo,doy-doy(1),B,[],avg_od_liq_time',-1);
[B, stats, Anom] = compute_anomaly_wrapper(boo,doy,avg_od_liq_time,4,[],-1,-1);
[scB,se,scAnom] = Math_sincosfit_wrapper(doy(boo),avg_od_liq_time(boo),4);

printarray([B scB' stats.se se'])
figure(21); clf; plot(yymm,avg_anom_od_liq,'b',yymm,Anom,'c'); plotaxis2; xlim([2020 2025])

%%%%%%%%%%%%%%%%%%%%%%%%%

for ii = 1 : lenT
  junk1 = squeeze(anom_od_ice(:,:,ii)); junk1 = junk1(:); %junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_anom_od_ice(ii) = nansum(junk1)/nansum(junk2);

  junk1 = squeeze(od_ice(ii,:,:)); junk1 = junk1(:); junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_od_ice_time(ii) = nansum(junk1)/nansum(junk2);
end

figure(20); clf; plot(yymm,avg_od_ice_time)

%[B, stats, err] = Math_tsfit_lin_robust(doy(boo)-doy(boo(1)),avg_od_ice_time(boo),4);
%  Anom = compute_anomaly(boo,doy-doy(1),B,[],avg_od_ice_time',-1);
[B, stats, Anom] = compute_anomaly_wrapper(boo,doy,avg_od_ice_time,4,[],-1,-1);
[scB,se,scAnom] = Math_sincosfit_wrapper(doy(boo),avg_od_ice_time(boo),4);

printarray([B scB' stats.se se'])
figure(21); clf; plot(yymm,avg_anom_od_ice,'b',yymm,Anom,'c'); plotaxis2; xlim([2020 2025])

%%%%%%%%%%%%%%%%%%%%%%%%%

for ii = 1 : lenT
  junk1 = squeeze(anom_dme_liq(:,:,ii)); junk1 = junk1(:); %junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_anom_dme_liq(ii) = nansum(junk1)/nansum(junk2);

  junk1 = squeeze(dme_liq(ii,:,:)); junk1 = junk1(:); junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_dme_liq_time(ii) = nansum(junk1)/nansum(junk2);
end

figure(20); clf; plot(yymm,avg_dme_liq_time)

%[B, stats, err] = Math_tsfit_lin_robust(doy(boo)-doy(boo(1)),avg_dme_liq_time(boo),4);
%  Anom = compute_anomaly(boo,doy-doy(1),B,[],avg_dme_liq_time',-1);
[B, stats, Anom] = compute_anomaly_wrapper(boo,doy,avg_dme_liq_time,4,[],-1,-1);
[scB,se,scAnom] = Math_sincosfit_wrapper(doy(boo),avg_dme_liq_time(boo),4);

printarray([B scB' stats.se se'])
figure(21); clf; plot(yymm,avg_anom_dme_liq,'b',yymm,Anom,'c'); plotaxis2; xlim([2020 2025])

%%%%%%%%%%%%%%%%%%%%%%%%%

for ii = 1 : lenT
  junk1 = squeeze(anom_dme_ice(:,:,ii)); junk1 = junk1(:); %junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_anom_dme_ice(ii) = nansum(junk1)/nansum(junk2);

  junk1 = squeeze(dme_ice(ii,:,:)); junk1 = junk1(:); junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_dme_ice_time(ii) = nansum(junk1)/nansum(junk2);
end

figure(20); clf; plot(yymm,avg_dme_ice_time)

%[B, stats, err] = Math_tsfit_lin_robust(doy(boo)-doy(boo(1)),avg_dme_ice_time(boo),4);
%  Anom = compute_anomaly(boo,doy-doy(1),B,[],avg_dme_ice_time',-1);
[B, stats, Anom] = compute_anomaly_wrapper(boo,doy,avg_dme_ice_time,4,[],-1,-1);
[scB,se,scAnom] = Math_sincosfit_wrapper(doy(boo),avg_dme_ice_time(boo),4);

printarray([B scB' stats.se se'])
figure(21); clf; plot(yymm,avg_anom_dme_ice,'b',yymm,Anom,'c'); plotaxis2; xlim([2020 2025])

%%%%%%%%%%%%%%%%%%%%%%%%%

for ii = 1 : lenT
  junk1 = squeeze(anom_cldtop(:,:,ii)); junk1 = junk1(:); %junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_anom_cldtop(ii) = nansum(junk1)/nansum(junk2);

  junk1 = squeeze(cldtop(ii,:,:)); junk1 = junk1(:); junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_cldtop_time(ii) = nansum(junk1)/nansum(junk2);
end

figure(20); clf; plot(yymm,avg_cldtop_time)

%[B, stats, err] = Math_tsfit_lin_robust(doy(boo)-doy(boo(1)),avg_cldtop_time(boo),4);
%  Anom = compute_anomaly(boo,doy-doy(1),B,[],avg_cldtop_time',-1);
[B, stats, Anom] = compute_anomaly_wrapper(boo,doy,avg_cldtop_time,4,[],-1,-1);
[scB,se,scAnom] = Math_sincosfit_wrapper(doy(boo),avg_cldtop_time(boo),4);

printarray([B scB' stats.se se'])
figure(21); clf; plot(yymm,avg_anom_cldtop,'b',yymm,Anom,'c'); plotaxis2; xlim([2020 2025])

%%%%%

for ii = 1 : lenT
  junk1 = squeeze(anom_cldtopD(:,:,ii)); junk1 = junk1(:); %junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_anom_cldtopD(ii) = nansum(junk1)/nansum(junk2);

  junk1 = squeeze(cldtopD(ii,:,:)); junk1 = junk1(:); junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_cldtopD_time(ii) = nansum(junk1)/nansum(junk2);
end

figure(20); clf; plot(yymm,avg_cldtopD_time)

%[B, stats, err] = Math_tsfit_lin_robust(doy(boo)-doy(boo(1)),avg_cldtopD_time(boo),4);
%  Anom = compute_anomaly(boo,doy-doy(1),B,[],avg_cldtopD_time',-1);
[B, stats, Anom] = compute_anomaly_wrapper(boo,doy,avg_cldtopD_time,4,[],-1,-1);
[scB,se,scAnom] = Math_sincosfit_wrapper(doy(boo),avg_cldtopD_time(boo),4);

printarray([B scB' stats.se se'])
figure(21); clf; plot(yymm,avg_anom_cldtopD,'b',yymm,Anom,'c'); plotaxis2; xlim([2020 2025])

%%%%%

for ii = 1 : lenT
  junk1 = squeeze(anom_cldtopN(:,:,ii)); junk1 = junk1(:); %junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_anom_cldtopN(ii) = nansum(junk1)/nansum(junk2);

  junk1 = squeeze(cldtopN(ii,:,:)); junk1 = junk1(:); junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_cldtopN_time(ii) = nansum(junk1)/nansum(junk2);
end

figure(20); clf; plot(yymm,avg_cldtopN_time)

%[B, stats, err] = Math_tsfit_lin_robust(doy(boo)-doy(boo(1)),avg_cldtopN_time(boo),4);
%  Anom = compute_anomaly(boo,doy-doy(1),B,[],avg_cldtopN_time',-1);
[B, stats, Anom] = compute_anomaly_wrapper(boo,doy,avg_cldtopN_time,4,[],-1,-1);
[scB,se,scAnom] = Math_sincosfit_wrapper(doy(boo),avg_cldtopN_time(boo),4);

printarray([B scB' stats.se se'])
figure(21); clf; plot(yymm,avg_anom_cldtopN,'b',yymm,Anom,'c'); plotaxis2; xlim([2020 2025])

%%%%%%%%%%%%%%%%%%%%%%%%%

for ii = 1 : lenT
  junk1 = squeeze(anom_cldfrac(:,:,ii)); junk1 = junk1(:); %junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_anom_cldfrac(ii) = nansum(junk1)/nansum(junk2);

  junk1 = squeeze(cldfrac(ii,:,:)); junk1 = junk1(:); junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_cldfrac_time(ii) = nansum(junk1)/nansum(junk2);
end

figure(20); clf; plot(yymm,avg_cldfrac_time)

%[B, stats, err] = Math_tsfit_lin_robust(doy(boo)-doy(boo(1)),avg_cldfrac_time(boo),4);
%  Anom = compute_anomaly(boo,doy-doy(1),B,[],avg_cldfrac_time',-1);
[B, stats, Anom] = compute_anomaly_wrapper(boo,doy,avg_cldfrac_time,4,[],-1,-1);
[scB,se,scAnom] = Math_sincosfit_wrapper(doy(boo),avg_cldfrac_time(boo),4);

printarray([B scB' stats.se se'])
figure(21); clf; plot(yymm,avg_anom_cldfrac,'b',yymm,Anom,'c'); plotaxis2; xlim([2020 2025])

%%%%%

for ii = 1 : lenT
  junk1 = squeeze(anom_cldfracD(:,:,ii)); junk1 = junk1(:); %junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_anom_cldfracD(ii) = nansum(junk1)/nansum(junk2);

  junk1 = squeeze(cldfracD(ii,:,:)); junk1 = junk1(:); junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_cldfracD_time(ii) = nansum(junk1)/nansum(junk2);
end

figure(20); clf; plot(yymm,avg_cldfracD_time)

%[B, stats, err] = Math_tsfit_lin_robust(doy(boo)-doy(boo(1)),avg_cldfracD_time(boo),4);
%  Anom = compute_anomaly(boo,doy-doy(1),B,[],avg_cldfracD_time',-1);
[B, stats, Anom] = compute_anomaly_wrapper(boo,doy,avg_cldfracD_time,4,[],-1,-1);
[scB,se,scAnom] = Math_sincosfit_wrapper(doy(boo),avg_cldfracD_time(boo),4);

printarray([B scB' stats.se se'])
figure(21); clf; plot(yymm,avg_anom_cldfracD,'b',yymm,Anom,'c'); plotaxis2; xlim([2020 2025])

%%%%%

for ii = 1 : lenT
  junk1 = squeeze(anom_cldfracN(:,:,ii)); junk1 = junk1(:); %junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_anom_cldfracN(ii) = nansum(junk1)/nansum(junk2);

  junk1 = squeeze(cldfracN(ii,:,:)); junk1 = junk1(:); junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_cldfracN_time(ii) = nansum(junk1)/nansum(junk2);
end

figure(20); clf; plot(yymm,avg_cldfracN_time)

%[B, stats, err] = Math_tsfit_lin_robust(doy(boo)-doy(boo(1)),avg_cldfracN_time(boo),4);
%  Anom = compute_anomaly(boo,doy-doy(1),B,[],avg_cldfracN_time',-1);
[B, stats, Anom] = compute_anomaly_wrapper(boo,doy,avg_cldfracN_time,4,[],-1,-1);
[scB,se,scAnom] = Math_sincosfit_wrapper(doy(boo),avg_cldfracN_time(boo),4);

printarray([B scB' stats.se se'])
figure(21); clf; plot(yymm,avg_anom_cldfracN,'b',yymm,Anom,'c'); plotaxis2; xlim([2020 2025])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
do_cloud_anom_plots
