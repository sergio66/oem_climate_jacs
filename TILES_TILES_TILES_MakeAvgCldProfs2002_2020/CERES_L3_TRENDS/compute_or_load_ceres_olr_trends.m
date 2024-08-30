addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/StrowCodeforTrendsAndAnomalies
addpath /home/sergio/MATLABCODE/COLORMAP
addpath /home/sergio/MATLABCODE/PLOTTER 
addpath /home/sergio/MATLABCODE
addpath /asl/matlib/h4tools

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% function ceres = load_ceres_data(ceres_fname,iCorT)   
%% iCorT = +1;  %% the clear filled region in a pixel
%% iCorT = -1;  %% the empirically filed "Total" clear sky  

iCorT = +1;  %% hmm way
iCorT = -1;  %% Ryan suggestion

iCorT

iYears = 20; 
iYears = 22; 

if iYears > 20
  error('use compute_or_load_ceres_olr_trends_new')
end

if iYears == 20
  ceres_fname = '/asl/s1/sergio/CERES_OLR_15year/CERES_EBAF-TOA_Ed4.1_Subset_200209-202108.nc';  %% what I brought
  ceres_fname = '/asl/s1/sergio/CERES_OLR_15year/CERES_EBAF-TOA_Ed4.2_Subset_200209-202208.nc'; 
  ceres_fname = '/asl/s1/sergio/CERES_OLR_15year/CERES_EBAF_Ed4.1_Subset_200209-202108.nc';      %% what Ryan suggests
  ceres_fname = '/asl/s1/sergio/CERES_OLR_15year/CERES_EBAF_Ed4.2_Subset_200209-202208.nc';      %% what Ryan suggests
elseif  iYears == 22
  ceres_fnameA = '/asl/s1/sergio/CERES_OLR_15year/CERES_EBAF_Ed4.2_Subset_200209-201706.nc';
  ceres_fnameB = '/asl/s1/sergio/CERES_OLR_15year/CERES_EBAF_Ed4.2_Subset_201707-202403.nc';
end

if iYears == 20
  if iCorT > 0
    %% now load in CERES
    iCorT = +1;
    ceresS = load_ceres_data(ceres_fname,iCorT);
  elseif iCorT < 0  
    % EBAF  –  Level 3b
    % Observed TOA and computed surface all-sky and clear-sky fluxes; CERES-MODIS cloud properties. Clear-sky for total area of 1°x1° region.
    % make sure you get TOA and and and and and and TOA CRE 
    iCorT = -1;
    ceresR = load_ceres_data(ceres_fname,iCorT);
  end
    
  if iCorT > 0
    ceres = ceresS;
  elseif iCorT < 0
    ceres = ceresR;
  end
else
  ceres = load_ceres_data_22years(ceres_fnameA,ceres_fnameB);
end

if iYears == 20
  bonk = findstr(ceres_fname,'.nc');
  startD = ceres_fname(bonk-13:bonk-08); startY = str2num(startD(1:4)); startM = str2num(startD(5:6));
  stopD  = ceres_fname(bonk-06:bonk-01); stopY  = str2num(stopD(1:4));  stopM  = str2num(stopD(5:6));
else
  bonk = findstr(ceres_fnameA,'.nc');
  startD = ceres_fnameA(bonk-13:bonk-08); startY = str2num(startD(1:4)); startM = str2num(startD(5:6)); 
  bonk = findstr(ceres_fnameB,'.nc');
  stopD  = ceres_fnameB(bonk-06:bonk-01); stopY  = str2num(stopD(1:4));  stopM  = str2num(stopD(5:6));
  [startY startM stopY stopM]
end

iCnt = 0;

for yyx = 2002 : stopY
  mmS = 1; mmE = 12;
  if yyx == 2002
    mmS = 09;
    mmS = srtaM;
  elseif yyx == stopY   
    mmE = 08;
    mmE = stopM;
  end
  for ii = mmS : mmE
    iCnt = iCnt + 1;
    all.yy(iCnt) = yyx;
    all.mm(iCnt) = ii;
    all.dd(iCnt) = 15;
  end
end
dayOFtime = change2days(all.yy,all.mm,all.dd,2002);

%%%%%%%%%%%%%%%%%%%%%%%%%
for ii = 1 : 180
  data = ceres.lwdata(ii,:);
  boo = find(isfinite(data));
  if length(boo) > 20
    [B, stats] = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
    trend_ceres_lw(ii) = B(2);  
    trend_ceres_lw_err(ii) = stats.se(2);
  else
    trend_ceres_lw(ii) = NaN;
    trend_ceres_lw_err(ii) = NaN;
  end

  data = ceres.lwdata_clr(ii,:);
  boo = find(isfinite(data));
  if length(boo) > 20
    [B, stats] = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
    trend_ceres_lw_clr(ii) = B(2);  
    trend_ceres_lw_clr_err(ii) = stats.se(2);
  else
    trend_ceres_lw_clr(ii) = NaN;
    trend_ceres_lw_clr_err(ii) = NaN;
  end
end

for ii = 1 : 180
  data = ceres.swdata(ii,:);
  boo = find(isfinite(data));
  if length(boo) > 20
    [B, stats] = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
    trend_ceres_sw(ii) = B(2);  
    trend_ceres_sw_err(ii) = stats.se(2);
  else
    trend_ceres_sw(ii) = NaN;
    trend_ceres_sw_err(ii) = NaN;
  end

  data = ceres.swdata_clr(ii,:);
  boo = find(isfinite(data));
  if length(boo) > 20
    [B, stats] = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
    trend_ceres_sw_clr(ii) = B(2);  
    trend_ceres_sw_clr_err(ii) = stats.se(2);
  else
    trend_ceres_sw_clr(ii) = NaN;
    trend_ceres_sw_clr_err(ii) = NaN;
  end
end

for ii = 1 : 4608
  data = ceres.toa_lw_all_4608(:,ii);
  boo = find(isfinite(data));
  if length(boo) > 20
    [B, stats] = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
    trend_ceres_toa_lw_all_4608(ii) = B(2);  
    trend_ceres_toa_lw_all_4608_err(ii) = stats.se(2);
  else
    trend_ceres_toa_lw_all_4608(ii) = NaN;
    trend_ceres_toa_lw_all_4608_err(ii) = NaN;
  end

  data = ceres.toa_lw_clr_4608(:,ii);
  boo = find(isfinite(data));
  if length(boo) > 20
    [B, stats] = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
    trend_ceres_toa_lw_clr_4608(ii) = B(2);  
    trend_ceres_toa_lw_clr_4608_err(ii) = stats.se(2);
  else
    trend_ceres_toa_lw_clr_4608(ii) = NaN;
    trend_ceres_toa_lw_clr_4608_err(ii) = NaN;
  end
end

trend_ceres_lat = ceres.lat;
plot(trend_ceres_lat,trend_ceres_lw,trend_ceres_lat,trend_ceres_lw_clr,'linewidth',2); plotaxis2; hl = legend('allsky','clrsky','location','best');
xlabel('Latitude'); ylabel('Trend'); title('W/m2/K/yr')

ceres_trend.fname            = ceres_fname;
ceres_trend.trend_lat        = trend_ceres_lat;
ceres_trend.trend_lw         = trend_ceres_lw;
ceres_trend.trend_lw_err     = trend_ceres_lw_err;
ceres_trend.trend_lw_clr     = trend_ceres_lw_clr;
ceres_trend.trend_lw_clr_err = trend_ceres_lw_clr_err;
ceres_trend.trend_sw         = trend_ceres_sw;
ceres_trend.trend_sw_err     = trend_ceres_sw_err;
ceres_trend.trend_sw_clr     = trend_ceres_sw_clr;
ceres_trend.trend_sw_clr_err = trend_ceres_sw_clr_err;

ceres_trend.trend_toa_lw_all_4608     = trend_ceres_toa_lw_all_4608;
ceres_trend.trend_toa_lw_all_4608_err = trend_ceres_toa_lw_all_4608_err;
ceres_trend.trend_toa_lw_clr_4608     = trend_ceres_toa_lw_clr_4608;
ceres_trend.trend_toa_lw_clr_4608_err = trend_ceres_toa_lw_clr_4608_err;

iSave = input('save ceres trends (-1/+1) : ');
if iSave > 0
  if iCorT > 0
    saver = ['save ceres_trends_' num2str(stopY-startY,'%02d') 'year_C.mat ceres_trend'];
  elseif iCorT < 0
    saver = ['save ceres_trends_' num2str(stopY-startY,'%02d') 'year_T.mat ceres_trend'];
  end
  eval(saver);
end

[h,ha,p,pa] = rtpread('../FIND_NWP_MODEL_TRENDS/summary_atm_N_cld_20years_all_lat_all_lon_2002_2022_monthlyERA5.ip.rtp');
figure(3); clf; pcolor(reshape(ceres_trend.trend_toa_lw_all_4608,72,64)'); colorbar; colormap(usa2); shading flat; caxis([-1 +1]); title('ALL')
figure(4); clf; pcolor(reshape(ceres_trend.trend_toa_lw_clr_4608,72,64)'); colorbar; colormap(usa2); shading flat; caxis([-1 +1]); title('CLR')
figure(3); clf; simplemap(p.rlat,p.rlon,ceres_trend.trend_toa_lw_all_4608,5); colorbar; colormap(usa2); shading flat; caxis([-1 +1]/2); title('ALL')
figure(4); clf; simplemap(p.rlat,p.rlon,ceres_trend.trend_toa_lw_clr_4608,5); colorbar; colormap(usa2); shading flat; caxis([-1 +1]/2); title('CLR')
