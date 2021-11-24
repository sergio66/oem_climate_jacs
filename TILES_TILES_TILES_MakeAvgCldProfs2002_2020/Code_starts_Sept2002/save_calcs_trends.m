%% see /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_Oct2020_trendsonly/convert_strowrates2oemrates_allskygrid.m

clear x

%a = load('/home/strow/Work/Airs/Tiles/Data/grid_fit_var_trends_all.mat');
%x = load('/home/strow/Work/Airs/Tiles/Data/grid_fit_trends_all.mat');

%a = load('/home/strow/Work/Airs/Tiles/Data/grid_fit_var_trends_all.mat');
x = load('/home/strow/Work/Airs/Tiles/Data/grid_fit_trends_all.mat');
a.dbt     = permute(x.dbt,[3 2 1]);
  a.dbt     = reshape(a.dbt,2645,64*72);
a.dbt_err = permute(x.dbt_err,[3 2 1]);
  a.dbt_err = reshape(a.dbt_err,2645,64*72);
a.lag     = permute(x.lag,[3 2 1]);
  a.lag     = reshape(a.lag,2645,64*72);

b_obs(:,:,2)     = a.dbt';
b_err_obs(:,:,2) = a.dbt_err';
lagcor_obs_anom(:,:) = a.lag';
b_obs = real(b_obs);
b_err_obs = real(b_err_obs);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
b_obsv2(:,:,2)     = trend.btobs';
b_err_obsv2(:,:,2) = trend.btobs_err';
lagcor_obs_anom(:,:) = a.lag';
b_obsv2 = real(b_obsv2);
b_err_obsv2 = real(b_err_obsv2);

b_cal(:,:,2)     = trend.btcld';
b_err_cal(:,:,2) = trend.btcld_err';
lagcor_cld_anom(:,:) = a.lag';
b_cal = real(b_cal);
b_err_cal = real(b_err_cal);

b_clr(:,:,2)     = trend.btclr';
b_err_clr(:,:,2) = trend.btclr_err';
lagcor_cld_anom(:,:) = a.lag';
b_clr = real(b_clr);
b_err_clr = real(b_err_clr);

%{
b_cal(:,:,2)     = b.dbt';
b_err_cal(:,:,2) = b.dbt_err';
lagcor_cal_anom(:,:) = b.lag';
b_cal = real(b_cal);
b_err_cal = real(b_err_cal);

b_bias(:,:,2)     = c.dbt';
b_err_bias(:,:,2) = c.dbt_err';
lagcor_bias_anom(:,:) = c.lag';
b_bias = real(b_bias);
b_err_bias = real(b_err_bias);
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lls4 = load('llsmap4');
lls4.llsmap4 = lls4.llsmap4(2:end,:);

figure(5); pcolor(reshape(squeeze(b_obs(:,1520,2)),72,64)');   shading interp; title('strow BT1231 rate');
figure(6); pcolor(reshape(squeeze(b_obsv2(:,1520,2)),72,64)'); shading interp; title('sergio BT1231 rate');
figure(7); pcolor(reshape(squeeze(b_cal(:,1520,2)),72,64)');   shading interp; title('ERA cld BT1231 rate');
figure(8); pcolor(reshape(squeeze(b_clr(:,1520,2)),72,64)');   shading interp; title('ERA clr BT1231 rate');
for ii = 5 : 8; figure(ii); colormap(usa2); caxis([-0.2 +0.2]); end

figure(5); wah = reshape(squeeze(b_obs(:,1520,2)),72,64);   scatter_coast(X(:),Y(:),50,wah(:)); title('strow BT1231 rate');
figure(6); wah = reshape(squeeze(b_obsv2(:,1520,2)),72,64); scatter_coast(X(:),Y(:),50,wah(:)); title('sergio BT1231 rate');
figure(7); wah = reshape(squeeze(b_cal(:,1520,2)),72,64);   scatter_coast(X(:),Y(:),50,wah(:)); title('ERA cld BT1231 rate');
figure(8); wah = reshape(squeeze(b_clr(:,1520,2)),72,64);   scatter_coast(X(:),Y(:),50,wah(:)); title('ERA clr BT1231 rate');
for ii = 5 : 8; figure(ii); colormap(usa2); colormap(lls4.llsmap4); caxis([-0.2 +0.2]); end

comment = 'from ~/MATLABCODE/oem_pkg_run_sergio_AuxJacs/MakeAvgCldProfs2002_2020/save_calcs_trennds.m';
%save /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_Oct2020_trendsonly/convert_strowrates2oemrates_allskygrid_obsNcalcs  b_* comment lagcor*

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
addpath /home/sergio/MATLABCODE/matlib/rtp_prod2/util/
[salti, landfrac] = usgs_deg10_dem(Y(:),X(:));

figure(1);
woo = ones(1,64*72)*NaN; woo(1:1:length(trend.stemp)) = trend.stemp;
stemprate = reshape(woo,72,64);
scatter_coast(X(:),Y(:),50,stemprate(:)); shading flat; colormap jet; colorbar; caxis([-0.2 +0.2]); colormap(usa2); colormap(lls4.llsmap4); 

stemp_rate_landNocean = nanmean(stemprate,1);

landfracNaN = reshape(landfrac,72,64); oceanfracNaN = landfracNaN; pcolor(X,Y,landfracNaN); colorbar
  landfracNaN(landfracNaN < 1) = NaN;      pcolor(X,Y,landfracNaN);  
  oceanfracNaN(oceanfracNaN > 0.01) = NaN; oceanfracNaN(isfinite(oceanfracNaN)) = 1; pcolor(X,Y,oceanfracNaN);
  stemprateXNaN = stemprate.*landfracNaN; scatter_coast(X(:),Y(:),10,stemprateXNaN(:))
  stemprateNaN  = stemprate.*oceanfracNaN; scatter_coast(X(:),Y(:),10,stemprateNaN(:))
stemp_rate_ocean = nanmean(stemprateNaN,1);
plot(rlat,stemp_rate_landNocean,'r',rlat,stemp_rate_ocean,'b')
save /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_Oct2020_trendsonly/era_stemp_rates.mat rlat stemp_rate_landNocean stemp_rate_ocean

figure(5); wah = reshape(squeeze(b_obs(:,1520,2)),72,64);   scatter_coast(X(:),Y(:),50,wah(:)); 
figure(6); wah = reshape(squeeze(b_obsv2(:,1520,2)),72,64); scatter_coast(X(:),Y(:),50,wah(:)); 
figure(7); wah = reshape(squeeze(b_cal(:,1520,2)),72,64);   scatter_coast(X(:),Y(:),50,wah(:)); 
figure(8); wah = reshape(squeeze(b_clr(:,1520,2)),72,64);   scatter_coast(X(:),Y(:),50,wah(:)); 
figure(6);                                                  scatter_coast(X(:),Y(:),50,stemprate(:)); 
for ii = 5 : 8; figure(ii); colormap(usa2); colormap(lls4.llsmap4); ylabel('Longitude'); xlabel('Latitude'); caxis([-0.2 +0.2]); end

figure(5); aslprint('/home/sergio/PAPERS/AIRS/AIRS_STM_Oct2020/GriddedRetrievals/Figs/bt1231_obs_trends.pdf');
figure(6); aslprint('/home/sergio/PAPERS/AIRS/AIRS_STM_Oct2020/GriddedRetrievals/Figs/era_stemp_trends.pdf');
figure(7); aslprint('/home/sergio/PAPERS/AIRS/AIRS_STM_Oct2020/GriddedRetrievals/Figs/bt1231_cld_trends.pdf');
figure(8); aslprint('/home/sergio/PAPERS/AIRS/AIRS_STM_Oct2020/GriddedRetrievals/Figs/bt1231_clr_trends.pdf');

%}
