addpath /home/strow/Matlab/Math
load_fairs

if ~exist('ind_lons')
  ind_lons = load('/home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/iType_2_convert_sergio_clearskygrid_obsonly_Q16.mat');
end

for JOB = 1 : 64
  fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(JOB,'%02d') '/trends_zonalavg_fits_quantiles_LatBin' num2str(JOB,'%02d') '_timesetps_001_429_V1.mat'];
  loader = ['load ' fname];
  eval(loader);
  wnum = fairs;
  usethese =  1 : 72;
  do_dah_zonal_comparisons;
  raC(JOB,:) = rho;
end

load /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR_zonalavg/latB64.mat
rlat = latB2;
rlat = 0.5*(rlat(1:end-1)+rlat(2:end));

comment = 'see loop64_do_day_zonal_comparisons.m';
pcolor(wnum,rlat,raC); colorbar; colormap(jet); caxis([0 1]); title('Correlations'); shading interp
xlim([640 1640])
%% save all_correlations_64lats.mat wnum raC comment rlat
