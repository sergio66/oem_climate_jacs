addpath /home/sergio/MATLABCODE/MODIS_CLOUD
addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/COLORMAP
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
    savematname = ['/asl/s1/sergio/MODIS_MONTHLY_L3/AEROSOL/SUMMARY_MAT/modisL3aerosol_' num2str(yy) '_' num2str(mm,'%02d') '.mat'];
    a = load(savematname);
    iCnt = iCnt + 1;
    aod(iCnt,:,:)   = a.summary.AOD_72x64;
    dblue(iCnt,:,:) = a.summary.DeepBlue_72x64;
    colwv(iCnt,:,:) = a.summary.ColumnWV_72x64;
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

for jj = 1 : 64
  fprintf(1,'latbin %2i of 64 \n',jj)
  for ii = 1 : 72
    data = squeeze(aod(:,ii,jj));
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats, err] = Math_tsfit_lin_robust(doy(boo),data(boo),4);
      anom_od(ii,jj,:) = compute_anomaly(boo,doy,B,[],data,-1);
      trend_aod(ii,jj)     = B(2);
      trend_aod_unc(ii,jj) = stats.se(2);
      avg_aod(ii,jj)       = B(1);
      avg_aod_unc(ii,jj)   = stats.se(1);
    else
      anom_od(ii,jj,:)     = NaN;
      trend_aod(ii,jj)     = NaN;
      trend_aod_unc(ii,jj) = NaN;
      avg_aod(ii,jj)       = NaN;
      avg_aod_unc(ii,jj)   = NaN;
    end

    data = squeeze(dblue(:,ii,jj));
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats, err] = Math_tsfit_lin_robust(doy(boo),data(boo),4);
      anom_deepblue(ii,jj,:)    = compute_anomaly(boo,doy,B,[],data,-1);
      trend_deepblue(ii,jj)     = B(2);
      trend_deepblue_unc(ii,jj) = stats.se(2);
      avg_deepblue(ii,jj)       = B(1);
      avg_deepblue_unc(ii,jj)   = stats.se(1);
    else
      anom_deepblue(ii,jj,:)    = NaN;
      trend_deepblue(ii,jj)     = NaN;
      trend_deepblue_unc(ii,jj) = NaN;
      avg_deepblue(ii,jj)       = NaN;
      avg_deepblue_unc(ii,jj)   = NaN;
    end

    data = squeeze(colwv(:,ii,jj));
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats, err] = Math_tsfit_lin_robust(doy(boo),data(boo),4);
      anom_colwv(ii,jj,:) = compute_anomaly(boo,doy,B,[],data,-1);
      trend_colwv(ii,jj)     = B(2);
      trend_colwv_unc(ii,jj) = stats.se(2);
      avg_colwv(ii,jj)       = B(1);
      avg_colwv_unc(ii,jj)   = stats.se(1);
    else
      anom_colwv(ii,jj,:)    = NaN;
      trend_colwv(ii,jj)     = NaN;
      trend_colwv_unc(ii,jj) = NaN;
      avg_colwv(ii,jj)       = NaN;
      avg_colwv_unc(ii,jj)   = NaN;
    end
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

doy2002 = doy;
comment = 'see driver_make_trends_from_modis_L3.m';
fout = ['modis_L3_aerosol_trends_' num2str(timeS(1),'%04d') '_' num2str(timeS(2),'%04d') '_' num2str(timeE(1),'%04d') '_' num2str(timeE(2),'%04d') '.mat'];
saver = ['save ' fout ' trend* avg* anom* comment doy2002'];
eval(saver)

do_XX_YY_from_X_Y

jett = jet(128); jett(1,:) = 1;
jett = jet(2048); jett(1,:) = 1;

figure(1); clf; aslmapSergio(rlat65,rlon73,smoothn(avg_colwv',1),   [-90 +90],[-180 +180]); caxis([0 +1]*60); title('Annual Average : Column Water 72x64'); colormap(jett); colorbar
figure(2); clf; aslmapSergio(rlat65,rlon73,smoothn(avg_aod',1),     [-90 +90],[-180 +180]); caxis([0 +1]*10); title('Annual Average : AOD 72x64');          colormap(jett); colorbar
figure(3); clf; aslmapSergio(rlat65,rlon73,smoothn(avg_deepblue',1),[-90 +90],[-180 +180]); caxis([0 +1]*10); title('Annual Average : DeepBlue 72x64');     colormap(jett); colorbar

figure(4); clf; aslmapSergio(rlat65,rlon73,smoothn(trend_colwv',1),   [-90 +90],[-180 +180]); caxis([-1 +1]*0.5); title('Annual Trends : Column Water 72x64'); colormap(usa2); colorbar
figure(5); clf; aslmapSergio(rlat65,rlon73,smoothn(trend_aod',1),     [-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Annual Trends : AOD 72x64');          colormap(usa2); colorbar
figure(6); clf; aslmapSergio(rlat65,rlon73,smoothn(trend_deepblue',1),[-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Annual Trends : DeepBlue 72x64');     colormap(usa2); colorbar

frac_colwv = trend_colwv./(avg_colwv + eps);
frac_aod = trend_aod./(avg_aod + eps);
frac_deepblue = trend_deepblue./(avg_deepblue + eps);
figure(7); clf; aslmapSergio(rlat65,rlon73,smoothn(frac_colwv',1),   [-90 +90],[-180 +180]); caxis([-1 +1]*0.5); title('Fractional Trends : Column Water 72x64'); colormap(usa2); colorbar
figure(8); clf; aslmapSergio(rlat65,rlon73,smoothn(frac_aod',1),     [-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Fractional Trends : AOD 72x64');          colormap(usa2); colorbar
figure(9); clf; aslmapSergio(rlat65,rlon73,smoothn(frac_deepblue',1),[-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Fractional Trends : DeepBlue 72x64');     colormap(usa2); colorbar

%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1); clf; aslmapSergio(rlat65,rlon73,avg_colwv',   [-90 +90],[-180 +180]); caxis([0 +1]*60); title('Annual Average : Column Water 72x64'); colormap(jett); colorbar
figure(2); clf; aslmapSergio(rlat65,rlon73,avg_aod',     [-90 +90],[-180 +180]); caxis([0 +1]*10); title('Annual Average : AOD 72x64');          colormap(jett); colorbar
figure(3); clf; aslmapSergio(rlat65,rlon73,avg_deepblue',[-90 +90],[-180 +180]); caxis([0 +1]*10); title('Annual Average : DeepBlue 72x64');     colormap(jett); colorbar

figure(4); clf; aslmapSergio(rlat65,rlon73,trend_colwv',   [-90 +90],[-180 +180]); caxis([-1 +1]*0.5); title('Annual Trends : Column Water 72x64'); colormap(usa2); colorbar
figure(5); clf; aslmapSergio(rlat65,rlon73,trend_aod',     [-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Annual Trends : AOD 72x64');          colormap(usa2); colorbar
figure(6); clf; aslmapSergio(rlat65,rlon73,trend_deepblue',[-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Annual Trends : DeepBlue 72x64');     colormap(usa2); colorbar

frac_colwv = trend_colwv./(avg_colwv + eps);
frac_aod = trend_aod./(avg_aod + eps);
frac_deepblue = trend_deepblue./(avg_deepblue + eps);
figure(7); clf; aslmapSergio(rlat65,rlon73,frac_colwv',   [-90 +90],[-180 +180]); caxis([-1 +1]*0.5); title('Fractional Trends : Column Water 72x64'); colormap(usa2); colorbar
figure(8); clf; aslmapSergio(rlat65,rlon73,frac_aod',     [-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Fractional Trends : AOD 72x64');          colormap(usa2); colorbar
figure(9); clf; aslmapSergio(rlat65,rlon73,frac_deepblue',[-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Fractional Trends : DeepBlue 72x64');     colormap(usa2); colorbar

