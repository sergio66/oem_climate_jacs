%clear all
load ceres_trends_22year_C_T.mat
load ceres_lat_lon
ceres = ceresX;
[~,iCnt] = size(ceres_trend.anom_toa_net_clr_t_4608);

ix = 0;
for yy = 2002 : 2024
  mmS = 1; mmE = 12;
  if yy == 2002
    mmS = 9;
  elseif yy == 2024
    mmE = 3;
  end
  for mm = mmS : mmE
    ix = ix + 1;
    yy_ceres_save(ix) = yy;
    mm_ceres_save(ix) = mm;
  end
end

if ix ~= iCnt
  error('oops ix ~= iCnt')
end

yymm_ceres = yy_ceres_save + (mm_ceres_save-1)/12;
make_trends_anomalies_ceres_2022
