addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/MODIS_CLOUD
addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/COLORMAP
%% addpath /home/sergio/MATLABCODE/CRODGERS_FAST_CLOUD
addpath /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/StrowCodeforTrendsAndAnomalies

fname =  '/asl/s1/sergio/MODIS_MONTHLY_L3/AEROSOL/DATA/2024/MYD08_M3.A2024153.061.2024187025207.hdf';

timeS = [2019 01]; timeE = [2021 12];  %% COVID
timeS = [2020 07]; timeE = [2024 06];  %% last 4 years
timeS = [2002 09]; timeE = [2022 08];  %% 20 years
timeS = [2002 09]; timeE = [2024 06];  %% 22.5 years

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
    yyseries(iCnt) = yy;
    mmseries(iCnt) = mm;
    ddseries(iCnt) = a.dd;
    doy(iCnt) = change2days(yy,01,01,2002) + (a.dd-1);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% see ../Code_for_TileTrends/tile_fits_quantiles_anomalies.m

%    [b_desc(ch,qi,:)     stats] = Math_tsfit_lin_robust(dtime(k_desc)-dtime(k_desc(1)),r(k_desc),iNumSineCosCycles);
%    [bt_anom_desc(qi,ch,:) rad_anom_desc(qi,ch,:)] = compute_anomaly(k_desc,dtime,squeeze(b_desc(ch,qi,:)),fairs(ch),r);
%    [b_desc(ch,qi,:)  stats bt_anom_desc(qi,ch,:) rad_anom_desc(qi,ch,:)] = compute_anomaly_wrapper(k_desc,dtime,r,4,fairs(ch),+1,-1;
for jj = 1 : 64
  fprintf(1,'Math_tsfit_lin_robust latbin %2i of 64 \n',jj)
  for ii = 1 : 72
    data = squeeze(od_liq(:,ii,jj));
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats, junkanom] = compute_anomaly_wrapper(boo,doy(boo),data(boo),4,[],-1,-1);
      anom_od_liq(ii,jj,:)    = junkanom;
      trend_od_liq(ii,jj)     = B(2);
      trend_od_liq_unc(ii,jj) = stats.se(2);
      avg_od_liq(ii,jj)       = B(1);
      avg_od_liq_unc(ii,jj)   = stats.se(1);
    else
      anom_od_liq(ii,jj,:)    = NaN;
      trend_od_liq(ii,jj)     = NaN;
      trend_od_liq_unc(ii,jj) = NaN;
      avg_od_liq(ii,jj)       = NaN;
      avg_od_liq_unc(ii,jj)   = NaN;
    end

    data = squeeze(od_ice(:,ii,jj));
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats, junkanom] = compute_anomaly_wrapper(boo,doy(boo),data(boo),4,[],-1,-1);
      anom_od_ice(ii,jj,:)    = junkanom;
      trend_od_ice(ii,jj)     = B(2);
      trend_od_ice_unc(ii,jj) = stats.se(2);
      avg_od_ice(ii,jj)       = B(1);
      avg_od_ice_unc(ii,jj)   = stats.se(1);
    else
      anom_od_ice(ii,jj,:)    = NaN;
      trend_od_ice(ii,jj)     = NaN;
      trend_od_ice_unc(ii,jj) = NaN;
      avg_od_ice(ii,jj)       = NaN;
      avg_od_ice_unc(ii,jj)   = NaN;
    end

    data = squeeze(iwp_liq(:,ii,jj));
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats, junkanom] = compute_anomaly_wrapper(boo,doy(boo),data(boo),4,[],-1,-1);
      anom_iwp_liq(ii,jj,:)    = junkanom;
      trend_iwp_liq(ii,jj)     = B(2);
      trend_iwp_liq_unc(ii,jj) = stats.se(2);
      avg_iwp_liq(ii,jj)       = B(1);
      avg_iwp_liq_unc(ii,jj)   = stats.se(1);
    else
      anom_iwp_liq(ii,jj,:)    = NaN;
      trend_iwp_liq(ii,jj)     = NaN;
      trend_iwp_liq_unc(ii,jj) = NaN;
      avg_iwp_liq(ii,jj)       = NaN;
      avg_iwp_liq_unc(ii,jj)   = NaN;
    end

    data = squeeze(iwp_ice(:,ii,jj));
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats, junkanom] = compute_anomaly_wrapper(boo,doy(boo),data(boo),4,[],-1,-1);
      anom_iwp_ice(ii,jj,:)    = junkanom;
      trend_iwp_ice(ii,jj)     = B(2);
      trend_iwp_ice_unc(ii,jj) = stats.se(2);
      avg_iwp_ice(ii,jj)       = B(1);
      avg_iwp_ice_unc(ii,jj)   = stats.se(1);
    else
      anom_iwp_ice(ii,jj,:)    = NaN;
      trend_iwp_ice(ii,jj)     = NaN;
      trend_iwp_ice_unc(ii,jj) = NaN;
      avg_iwp_ice(ii,jj)       = NaN;
      avg_iwp_ice_unc(ii,jj)   = NaN;
    end

    data = squeeze(dme_liq(:,ii,jj));
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats, junkanom] = compute_anomaly_wrapper(boo,doy(boo),data(boo),4,[],-1,-1);
      anom_dme_liq(ii,jj,:)    = junkanom;
      trend_dme_liq(ii,jj)     = B(2);
      trend_dme_liq_unc(ii,jj) = stats.se(2);
      avg_dme_liq(ii,jj)       = B(1);
      avg_dme_liq_unc(ii,jj)   = stats.se(1);
    else
      anom_dme_liq(ii,jj,:)    = NaN;
      trend_dme_liq(ii,jj)     = NaN;
      trend_dme_liq_unc(ii,jj) = NaN;
      avg_dme_liq(ii,jj)       = NaN;
      avg_dme_liq_unc(ii,jj)   = NaN;
    end

    data = squeeze(dme_ice(:,ii,jj));
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats, junkanom] = compute_anomaly_wrapper(boo,doy(boo),data(boo),4,[],-1,-1);
      anom_dme_ice(ii,jj,:)    = junkanom;
      trend_dme_ice(ii,jj)     = B(2);
      trend_dme_ice_unc(ii,jj) = stats.se(2);
      avg_dme_ice(ii,jj)       = B(1);
      avg_dme_ice_unc(ii,jj)   = stats.se(1);
    else
      anom_dme_ice(ii,jj,:)    = NaN;
      trend_dme_ice(ii,jj)     = NaN;
      trend_dme_ice_unc(ii,jj) = NaN;
      avg_dme_ice(ii,jj)       = NaN;
      avg_dme_ice_unc(ii,jj)   = NaN;
    end

    data = squeeze(cldtop(:,ii,jj));
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats, junkanom] = compute_anomaly_wrapper(boo,doy(boo),data(boo),4,[],-1,-1);
      anom_cldtop(ii,jj,:)    = junkanom;
      trend_cldtop(ii,jj)     = B(2);
      trend_cldtop_unc(ii,jj) = stats.se(2);
      avg_cldtop(ii,jj)       = B(1);
      avg_cldtop_unc(ii,jj)   = stats.se(1);
    else
      anom_cldtop(ii,jj,:)    = NaN;
      trend_cldtop(ii,jj)     = NaN;
      trend_cldtop_unc(ii,jj) = NaN;
      avg_cldtop(ii,jj)       = NaN;
      avg_cldtop_unc(ii,jj)   = NaN;
    end

    data = squeeze(cldfrac(:,ii,jj));
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats, junkanom] = compute_anomaly_wrapper(boo,doy(boo),data(boo),4,[],-1,-1);
      anom_cldfrac(ii,jj,:)    = junkanom;
      trend_cldfrac(ii,jj)     = B(2);
      trend_cldfrac_unc(ii,jj) = stats.se(2);
      avg_cldfrac(ii,jj)       = B(1);
      avg_cldfrac_unc(ii,jj)   = stats.se(1);
    else
      anom_cldfrac(ii,jj,:)    = NaN;
      trend_cldfrac(ii,jj)     = NaN;
      trend_cldfrac_unc(ii,jj) = NaN;
      avg_cldfrac(ii,jj)       = NaN;
      avg_cldfrac_unc(ii,jj)   = NaN;
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
saver = ['save ' fout ' trend* avg* anom* sctrend* scavg* scanom* comment doy2002'];
eval(saver)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

do_XX_YY_from_X_Y

[lenT,lenX,lenY] = size(od_liq);
junkcos = ones(lenT,1) * cos(YY*pi/180); junkcos = reshape(junkcos,lenT,72,64);  junkcos = permute(junkcos,[2 3 1]); pcolor(X,Y,squeeze(junkcos(:,:,1))); colormap jet; colorbar
junkyymm = 2002.75 + ((1:lenT)-1)/12;

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

figure(10); clf; plot(junkyymm,avg_od_liq_time)

[B, stats, err] = Math_tsfit_lin_robust(doy(boo)-doy(boo(1)),avg_od_liq_time(boo),4);
  Anom = compute_anomaly(boo,doy-doy(1),B,[],avg_od_liq_time',-1);
[scB,se,scAnom] = Math_sincosfit_wrapper(doy(boo),avg_od_liq_time(boo),4);

printarray([B scB' stats.se se'])
figure(11); clf; plot(junkyymm,avg_anom_od_liq,'b',junkyymm,Anom,'c'); plotaxis2; xlim([2020 2025])

%%%%%%%%%%%%%%%%%%%%%%%%%

for ii = 1 : lenT
  junk1 = squeeze(anom_od_ice(:,:,ii)); junk1 = junk1(:); %junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_anom_od_ice(ii) = nansum(junk1)/nansum(junk2);

  junk1 = squeeze(od_ice(ii,:,:)); junk1 = junk1(:); junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_od_ice_time(ii) = nansum(junk1)/nansum(junk2);
end

figure(10); clf; plot(junkyymm,avg_od_ice_time)

[B, stats, err] = Math_tsfit_lin_robust(doy(boo)-doy(boo(1)),avg_od_ice_time(boo),4);
  Anom = compute_anomaly(boo,doy-doy(1),B,[],avg_od_ice_time',-1);
[scB,se,scAnom] = Math_sincosfit_wrapper(doy(boo),avg_od_ice_time(boo),4);

printarray([B scB' stats.se se'])
figure(11); clf; plot(junkyymm,avg_anom_od_ice,'b',junkyymm,Anom,'c'); plotaxis2; xlim([2020 2025])

%%%%%%%%%%%%%%%%%%%%%%%%%

for ii = 1 : lenT
  junk1 = squeeze(anom_cldtop(:,:,ii)); junk1 = junk1(:); %junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_anom_cldtop(ii) = nansum(junk1)/nansum(junk2);

  junk1 = squeeze(cldtop(ii,:,:)); junk1 = junk1(:); junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_cldtop_time(ii) = nansum(junk1)/nansum(junk2);
end

figure(10); clf; plot(junkyymm,avg_cldtop_time)

[B, stats, err] = Math_tsfit_lin_robust(doy(boo)-doy(boo(1)),avg_cldtop_time(boo),4);
  Anom = compute_anomaly(boo,doy-doy(1),B,[],avg_cldtop_time',-1);
[scB,se,scAnom] = Math_sincosfit_wrapper(doy(boo),avg_cldtop_time(boo),4);

printarray([B scB' stats.se se'])
figure(11); clf; plot(junkyymm,avg_anom_cldtop,'b',junkyymm,Anom,'c'); plotaxis2; xlim([2020 2025])

%%%%%%%%%%%%%%%%%%%%%%%%%

for ii = 1 : lenT
  junk1 = squeeze(anom_cldfrac(:,:,ii)); junk1 = junk1(:); %junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_anom_cldfrac(ii) = nansum(junk1)/nansum(junk2);

  junk1 = squeeze(cldfrac(ii,:,:)); junk1 = junk1(:); junk1(junk1 < 0) = NaN;
  junk2 = squeeze(junkcos(:,:,ii)); junk2 = junk2(:);
  avg_cldfrac_time(ii) = nansum(junk1)/nansum(junk2);
end

figure(10); clf; plot(junkyymm,avg_cldfrac_time)

[B, stats, err] = Math_tsfit_lin_robust(doy(boo)-doy(boo(1)),avg_cldfrac_time(boo),4);
  Anom = compute_anomaly(boo,doy-doy(1),B,[],avg_cldfrac_time',-1);
[scB,se,scAnom] = Math_sincosfit_wrapper(doy(boo),avg_cldfrac_time(boo),4);

printarray([B scB' stats.se se'])
figure(11); clf; plot(junkyymm,avg_anom_cldfrac,'b',junkyymm,Anom,'c'); plotaxis2; xlim([2020 2025])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(junkyymm,avg_anom_cldfrac*100,'k',junkyymm,avg_anom_cldtop,'g',junkyymm,avg_anom_od_ice,'b',junkyymm,avg_anom_od_liq,'r','linewidth',2); plotaxis2;
legend('cldfrac*100','cldtop','iceOD','liqOD','location','best','fontsize',10); 
ylabel('Anomaly')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1); clf; aslmapSergio(rlat65,rlon73,smoothn(avg_od_ice',1),  [-90 +90],[-180 +180]); caxis([0 +1]*60); title('Annual Average : OD ICE 72x64'); colormap(jett); colorbar
figure(2); clf; aslmapSergio(rlat65,rlon73,smoothn(avg_od_liq',1),  [-90 +90],[-180 +180]); caxis([0 +1]*10); title('Annual Average : OD_LIQ 72x64');          colormap(jett); colorbar
figure(3); clf; aslmapSergio(rlat65,rlon73,smoothn(avg_cldtop',1),  [-90 +90],[-180 +180]); caxis([0 +1]*10); title('Annual Average : Cldtop 72x64');     colormap(jett); colorbar

figure(4); clf; aslmapSergio(rlat65,rlon73,smoothn(trend_od_ice',1), [-90 +90],[-180 +180]); caxis([-1 +1]*0.5); title('Annual Trends : OD ICE 72x64'); colormap(usa2); colorbar
figure(5); clf; aslmapSergio(rlat65,rlon73,smoothn(trend_od_liq',1), [-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Annual Trends : OD_LIQ 72x64');          colormap(usa2); colorbar
figure(6); clf; aslmapSergio(rlat65,rlon73,smoothn(trend_cldtop',1), [-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Annual Trends : Cldtop 72x64');     colormap(usa2); colorbar

if iDo_sincosfit > 0
  figure(7); clf; aslmapSergio(rlat65,rlon73,smoothn(sctrend_od_ice',1), [-90 +90],[-180 +180]); caxis([-1 +1]*0.5); title('Annual Trends New : OD ICE 72x64'); colormap(usa2); colorbar
  figure(8); clf; aslmapSergio(rlat65,rlon73,smoothn(sctrend_od_liq',1), [-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Annual Trends New : OD_LIQ 72x64');          colormap(usa2); colorbar
  figure(9); clf; aslmapSergio(rlat65,rlon73,smoothn(sctrend_cldtop',1), [-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Annual Trends New : Cldtop 72x64');     colormap(usa2); colorbar
end
  
frac_od_ice = trend_od_ice./(avg_od_ice + eps);
frac_od_liq = trend_od_liq./(avg_od_liq + eps);
frac_cldtop = trend_cldtop./(avg_cldtop + eps);
figure(10); clf; aslmapSergio(rlat65,rlon73,smoothn(frac_od_ice',1), [-90 +90],[-180 +180]); caxis([-1 +1]*0.5); title('Fractional Trends : OD ICE 72x64'); colormap(usa2); colorbar
figure(11); clf; aslmapSergio(rlat65,rlon73,smoothn(frac_od_liq',1), [-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Fractional Trends : OD_LIQ 72x64');          colormap(usa2); colorbar
figure(12); clf; aslmapSergio(rlat65,rlon73,smoothn(frac_cldtop',1), [-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Fractional Trends : Cldtop 72x64');     colormap(usa2); colorbar

%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1); clf; aslmapSergio(rlat65,rlon73,avg_od_ice', [-90 +90],[-180 +180]); caxis([0 +1]*20);   title('Annual Average : OD ICE 72x64');  colormap(jett); colorbar
figure(2); clf; aslmapSergio(rlat65,rlon73,avg_od_liq', [-90 +90],[-180 +180]); caxis([0 +1]*20);   title('Annual Average : OD LIQ 72x64');  colormap(jett); colorbar
figure(3); clf; aslmapSergio(rlat65,rlon73,avg_cldtop', [-90 +90],[-180 +180]); caxis([0 +1]*1000); title('Annual Average : Cldtop 72x64');  colormap(jett); colorbar
figure(4); clf; aslmapSergio(rlat65,rlon73,avg_cldfrac',[-90 +90],[-180 +180]); caxis([0 +1]*1.25); title('Annual Average : Cldfrac 72x64'); colormap(jett); colorbar

figure(5); clf; aslmapSergio(rlat65,rlon73,trend_od_ice', [-90 +90],[-180 +180]); caxis([-1 +1]*0.2);  title('Annual Trends : OD ICE  72x64');  colormap(usa2); colorbar
figure(6); clf; aslmapSergio(rlat65,rlon73,trend_od_liq', [-90 +90],[-180 +180]); caxis([-1 +1]*0.2);  title('Annual Trends : OD LIQ  72x64');  colormap(usa2); colorbar
figure(7); clf; aslmapSergio(rlat65,rlon73,trend_cldtop', [-90 +90],[-180 +180]); caxis([-1 +1]*5);    title('Annual Trends : Cldtop  72x64');  colormap(usa2); colorbar
figure(8); clf; aslmapSergio(rlat65,rlon73,trend_cldfrac',[-90 +90],[-180 +180]); caxis([-1 +1]*0.01); title('Annual Trends : CldFrac 72x64');  colormap(usa2); colorbar

if iDo_sincosfit > 0
  figure(9); clf; aslmapSergio(rlat65,rlon73,sctrend_od_ice', [-90 +90],[-180 +180]); caxis([-1 +1]*0.5); title('Annual Trends New : OD ICE 72x64'); colormap(usa2); colorbar
  figure(10); clf; aslmapSergio(rlat65,rlon73,sctrend_od_liq', [-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Annual Trends New : OD LIQ 72x64');          colormap(usa2); colorbar
  figure(11); clf; aslmapSergio(rlat65,rlon73,sctrend_cldtop', [-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Annual Trends New : Cldtop 72x64');     colormap(usa2); colorbar
end

frac_od_ice = trend_od_ice./(avg_od_ice + eps);
frac_od_liq = trend_od_liq./(avg_od_liq + eps);
frac_cldtop = trend_cldtop./(avg_cldtop + eps);
figure(13); clf; aslmapSergio(rlat65,rlon73,frac_od_ice', [-90 +90],[-180 +180]); caxis([-1 +1]*0.5); title('Fractional Trends : OD ICE 72x64'); colormap(usa2); colorbar
figure(14); clf; aslmapSergio(rlat65,rlon73,frac_od_liq', [-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Fractional Trends : OD LIQ 72x64');          colormap(usa2); colorbar
figure(15); clf; aslmapSergio(rlat65,rlon73,frac_cldtop', [-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Fractional Trends : Cldtop 72x64');     colormap(usa2); colorbar

%%%%%%%%%%%%%%%%%%%%%%%%%
