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
iCorT = 0;   %% both

iCorT

iYears = 20; 
iYears = 22; 

if iYears < 22
  error('use compute_or_load_ceres_olr_trends')
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
    mmS = startM;
  elseif yyx == stopY   
    mmE = 08;
    mmE = stopM;
  end
  for ii = mmS : mmE
    iCnt = iCnt + 1;
    thetime.yy(iCnt) = yyx;
    thetime.mm(iCnt) = ii;
    thetime.dd(iCnt) = 15;
  end
end
dayOFtime = change2days(thetime.yy,thetime.mm,thetime.dd,2002);
yymm = thetime.yy + (thetime.mm-1)/12;

thetime.dayOFtime = dayOFtime;
thetime.yymm = yymm;

%%%%%%%%%%%%%%%%%%%%%%%%%

error(';lkas')
make_trends_anomalies_ceres_2022

%%%%%%%%%%%%%%%%%%%%%%%%%

ceresX.lat = ceres.lat;
ceresX.lon = ceres.lon;
% save ceres_lat_lon  ceresX

iSave = input('save ceres trends (-1/+1) : ');
if iSave > 0
  if iCorT > 0
    saver = ['save ceres_trends_' num2str(stopY-startY,'%02d') 'year_C.mat ceres_trend thetime ceresX'];
  elseif iCorT < 0
    saver = ['save ceres_trends_' num2str(stopY-startY,'%02d') 'year_T.mat ceres_trend thetime ceresX'];
  elseif iCorT == 0
    saver = ['save ceres_trends_' num2str(stopY-startY,'%02d') 'year_C_T.mat ceres_trend thetime ceresX'];
  end
  eval(saver);
end

[h,ha,p,pa] = rtpread('/home/sergio/MATLABCODE/oem_pkg_run/FIND_NWP_MODEL_TRENDS/summary_atm_N_cld_20years_all_lat_all_lon_2002_2022_monthlyERA5.ip.rtp');
figure(3); clf; pcolor(reshape(ceres_trend.trend_toa_lw_all_4608,72,64)');      colorbar; colormap(usa2); shading flat; caxis([-1 +1]); title('ALL')
figure(4); clf; pcolor(reshape(ceres_trend.trend_toa_lw_clr_t_4608,72,64)');    colorbar; colormap(usa2); shading flat; caxis([-1 +1]); title('CLR')
figure(3); clf; simplemap(p.rlat,p.rlon,ceres_trend.trend_toa_lw_all_4608,5);   colorbar; colormap(usa2); shading flat; caxis([-1 +1]/2); title('ALL')
figure(4); clf; simplemap(p.rlat,p.rlon,ceres_trend.trend_toa_lw_clr_t_4608,5); colorbar; colormap(usa2); shading flat; caxis([-1 +1]/2); title('CLR')
