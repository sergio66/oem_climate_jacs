function ceres = load_ceres_data_22years(ceres_fnameA,ceres_fnameB);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 2
  error('need 2 filenames')
end

%{
if nargin == 0
  error('need two argin')
  ceres_fnameA = '/asl/s1/sergio/CERES_OLR_15year/CERES_EBAF_Ed4.2_Subset_200209-201706.nc';
    Y0 = 2002; M0 = 09; YE = 2016; ME = 06; iNumY = 22; index = 1 : 228;
  ceres_fnameB = '/asl/s1/sergio/CERES_OLR_15year/CERES_EBAF_Ed4.2_Subset_201707-202403.nc';
    Y0 = 2017; M0 = 07; YE = 2024; ME = 03; iNumY = 22; index = 31 : 31-1+240;
  Y0 = 2002; M0 = 09; YE = 2024; ME = 03; iNumY = 22; index = 31 : 31-1+240;
  iCorT = 1;  %% just get down the clear filled region in a pixel .. rather than empirically filed "Total" clear sky  
elseif nargin == 1
  ceres_fnameB = '/asl/s1/sergio/CERES_OLR_15year/CERES_EBAF_Ed4.2_Subset_201707-202403.nc';
    Y0 = 2017; M0 = 07; YE = 2024; ME = 03; iNumY = 22; index = 31 : 31-1+240;
    Y0 = 2002; M0 = 09; YE = 2024; ME = 03; iNumY = 22; index = 31 : 31-1+240;
end
%}

iCorT = +1;  %% just get the clear filled region in a pixel .. rather than empirically filed "Total" clear sky
iCorT = -1;  %% just get the amazingly empirically filed "Total" clear sky
iCorT = 0;   %% get both
if iCorT == 1
  disp('getting _c_ == partially clear observed pixels : partial cloud filled version == from actual clear scenes') 
elseif iCorT == -1
  disp('getting _t_ == empirically/astonishingly totally clear observed pixels == from clear sky calculations') 
elseif iCorT == 0
  disp('getting _c_ == partially clear observed pixels : partial cloud filled version == from actual clear scenes') 
  disp('getting _t_ == empirically/astonishingly totally clear observed pixels == from clear sky calculations') 
end

a1 = read_netcdf_lls(ceres_fnameA);
a2 = read_netcdf_lls(ceres_fnameB);

a = struct;
a.lon = a1.lon;
a.lat = a1.lat;
a.time = [a1.time; a2.time];

a.solar_mon  = cat(3,a1.solar_mon,a2.solar_mon);
a.cldarea_total_daynight_mon  = cat(3,a1.cldarea_total_daynight_mon,a2.cldarea_total_daynight_mon);
a.cldpress_total_daynight_mon  = cat(3,a1.cldpress_total_daynight_mon,a2.cldpress_total_daynight_mon);
a.cldtemp_total_daynight_mon  = cat(3,a1.cldtemp_total_daynight_mon,a2.cldtemp_total_daynight_mon);
a.cldtau_total_day_mon  = cat(3,a1.cldtau_total_day_mon,a2.cldtau_total_day_mon);

a.toa_sw_all_mon  = cat(3,a1.toa_sw_all_mon,a2.toa_sw_all_mon);
a.toa_lw_all_mon  = cat(3,a1.toa_lw_all_mon,a2.toa_lw_all_mon);
a.toa_net_all_mon = cat(3,a1.toa_net_all_mon,a2.toa_net_all_mon);
a.toa_sw_clr_c_mon  = cat(3,a1.toa_sw_clr_c_mon,a2.toa_sw_clr_c_mon);
a.toa_lw_clr_c_mon  = cat(3,a1.toa_lw_clr_c_mon,a2.toa_lw_clr_c_mon);
a.toa_net_clr_c_mon = cat(3,a1.toa_net_clr_c_mon,a2.toa_net_clr_c_mon);
a.toa_sw_clr_t_mon  = cat(3,a1.toa_sw_clr_t_mon,a2.toa_sw_clr_t_mon);
a.toa_lw_clr_t_mon  = cat(3,a1.toa_lw_clr_t_mon,a2.toa_lw_clr_t_mon);
a.toa_net_clr_t_mon = cat(3,a1.toa_net_clr_t_mon,a2.toa_net_clr_t_mon);
a.toa_cre_sw_mon  = cat(3,a1.toa_cre_sw_mon,a2.toa_cre_sw_mon);
a.toa_cre_lw_mon  = cat(3,a1.toa_cre_lw_mon,a2.toa_cre_lw_mon);
a.toa_cre_net_mon  = cat(3,a1.toa_cre_net_mon,a2.toa_cre_net_mon);

[mmm] = length(a.time);

if ~isfield(a,'toa_lw_clr_t_mon')
  disp('toa_lw_clr_t_mon DNW so not getting the empirically filled total clear sky')
  iCorT = 1;
end

index = 1 : mmm;

ceres.lon = a.lon;
ceres.lat = a.lat;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% [h,ha,p,pa] = rtpread('../FIND_NWP_MODEL_TRENDS/summary_atm_N_cld_20years_all_lat_all_lon_2002_2022_monthlyERA5.ip.rtp');
[h,ha,p,pa] = rtpread('/home/sergio/MATLABCODE/oem_pkg_run/FIND_NWP_MODEL_TRENDS/summary_atm_N_cld_20years_all_lat_all_lon_2002_2022_monthlyERA5.ip.rtp');

hindex = 1 : 8;
hindex = 1;

F.s_longitude = a.lon;
F.s_latitude  = a.lat;
F.s_time      = a.time;
F.s_mtime     = datenum(1900,0,0,double(F.s_time),0,0);

% [X,Y] = ndgrid(F.s_latitude,F.s_longitude);
% iX = flipud(X); iY = flipud(Y);
% figure(1); clf; simplemap(X,simplemap(wrapTo180(Y),squeeze(a.toa_lw_all_mon(:,:,1))))

[Y,X] = ndgrid(F.s_latitude,F.s_longitude);
Y = Y'; X = X';
iX = X; iY = Y;
figure(1); clf; simplemap(Y,wrapTo180(X),squeeze(a.toa_lw_all_mon(:,:,1))); title('Sept 2002 LW flux');
figure(2); clf; simplemap(Y,wrapTo180(X),squeeze(a.toa_sw_all_mon(:,:,1))); title('Sept 2002 SW flux')
figure(3); clf; simplemap(Y,wrapTo180(X),squeeze(a.solar_mon(:,:,1)));      title('Sept 2002 Solar')

figure(1); clf; simplemap(Y,wrapTo180(X),squeeze(nanmean(a.toa_lw_all_mon,3))); title('avg LW flux');
figure(2); clf; simplemap(Y,wrapTo180(X),squeeze(nanmean(a.toa_sw_all_mon,3))); title('avg SW flux')
figure(3); clf; simplemap(Y,wrapTo180(X),squeeze(nanmean(a.solar_mon,3)));      title('avg Solar')

figure(1); clf; simplemap(Y,wrapTo180(X),squeeze(nanmean(a.toa_cre_lw_mon,3))); title('avg LW CRE');
figure(2); clf; simplemap(Y,wrapTo180(X),squeeze(nanmean(a.toa_cre_sw_mon,3))); title('avg SW CRE'); caxis([-1 +1]*75); colormap(usa2)
figure(3); clf; simplemap(Y,wrapTo180(X),squeeze(nanmean(a.solar_mon,3)));      title('avg Solar')

wah = single(ncread(ceres_fnameA,'toa_lw_all_mon',[1 1 hindex],[Inf Inf 1]));; %whos wah
wah = squeeze(a.toa_lw_all_mon(:,:,1));
F.junk.ig   = griddedInterpolant(iX,iY,wah,'linear');
miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
figure(2); clf; simplemap(p.rlat,p.rlon,miaow,5); colorbar; shading flat; caxis([200 300]); colormap jet;
figure(2); clf; scatter_coast(p.rlon,p.rlat,100,miaow); colorbar; shading flat; caxis([200 300]); colormap jet;

for hindex = 1 : length(a.time)
  wah = squeeze(a.solar_mon(:,:,hindex));
  F.junk.ig   = griddedInterpolant(iX,iY,wah,'linear');
  miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
  ceres.solar_4608_center(hindex,:) = miaow;

  wah = squeeze(a.cldarea_total_daynight_mon(:,:,hindex));
  F.junk.ig   = griddedInterpolant(iX,iY,wah,'linear');
  miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
  ceres.cldarea_total_daynight_4608_center(hindex,:) = miaow;

  wah = squeeze(a.cldpress_total_daynight_mon(:,:,hindex));
  F.junk.ig   = griddedInterpolant(iX,iY,wah,'linear');
  miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
  ceres.cldpress_total_daynight_4608_center(hindex,:) = miaow;

  wah = squeeze(a.cldtemp_total_daynight_mon(:,:,hindex));
  F.junk.ig   = griddedInterpolant(iX,iY,wah,'linear');
  miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
  ceres.cldtemp_total_daynight_4608_center(hindex,:) = miaow;

  wah = squeeze(a.cldtau_total_day_mon(:,:,hindex));
  F.junk.ig   = griddedInterpolant(iX,iY,wah,'linear');
  miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
  ceres.cldtau_total_day_4608_center(hindex,:) = miaow;

  wah = squeeze(a.toa_lw_all_mon(:,:,hindex));
  F.junk.ig   = griddedInterpolant(iX,iY,wah,'linear');
  miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
  ceres.toa_lw_all_4608_center(hindex,:) = miaow;

  wah = squeeze(a.toa_sw_all_mon(:,:,hindex));
  F.junk.ig   = griddedInterpolant(iX,iY,wah,'linear');
  miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
  ceres.toa_sw_all_4608_center(hindex,:) = miaow;

  wah = squeeze(a.toa_net_all_mon(:,:,hindex));
  F.junk.ig   = griddedInterpolant(iX,iY,wah,'linear');
  miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
  ceres.toa_net_all_4608_center(hindex,:) = miaow;

  wah = squeeze(a.toa_lw_clr_c_mon(:,:,hindex));
  F.junk.ig   = griddedInterpolant(iX,iY,wah,'linear');
  miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
  ceres.toa_lw_clr_c_4608_center(hindex,:) = miaow;

  wah = squeeze(a.toa_sw_clr_c_mon(:,:,hindex));
  F.junk.ig   = griddedInterpolant(iX,iY,wah,'linear');
  miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
  ceres.toa_sw_clr_c_4608_center(hindex,:) = miaow;

  wah = squeeze(a.toa_net_clr_c_mon(:,:,hindex));
  F.junk.ig   = griddedInterpolant(iX,iY,wah,'linear');
  miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
  ceres.toa_net_clr_c_4608_center(hindex,:) = miaow;

  wah = squeeze(a.toa_lw_clr_t_mon(:,:,hindex));
  F.junk.ig   = griddedInterpolant(iX,iY,wah,'linear');
  miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
  ceres.toa_lw_clr_t_4608_center(hindex,:) = miaow;

  wah = squeeze(a.toa_sw_clr_t_mon(:,:,hindex));
  F.junk.ig   = griddedInterpolant(iX,iY,wah,'linear');
  miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
  ceres.toa_sw_clr_t_4608_center(hindex,:) = miaow;

  wah = squeeze(a.toa_net_clr_t_mon(:,:,hindex));
  F.junk.ig   = griddedInterpolant(iX,iY,wah,'linear');
  miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
  ceres.toa_net_clr_t_4608_center(hindex,:) = miaow;

  wah = squeeze(a.toa_cre_net_mon(:,:,hindex));
  F.junk.ig   = griddedInterpolant(iX,iY,wah,'linear');
  miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
  ceres.toa_cre_net_4608_center(hindex,:) = miaow;

  wah = squeeze(a.toa_cre_sw_mon(:,:,hindex));
  F.junk.ig   = griddedInterpolant(iX,iY,wah,'linear');
  miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
  ceres.toa_cre_sw_4608_center(hindex,:) = miaow;

  wah = squeeze(a.toa_cre_lw_mon(:,:,hindex));
  F.junk.ig   = griddedInterpolant(iX,iY,wah,'linear');
  miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
  ceres.toa_cre_lw_4608_center(hindex,:) = miaow;
end

ceres
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% instead of doing TimeAvg  to get (X,Y)  (where you do mean(data,3)) 
%%               do ZonalAvg to get (Y,T)  (where you do mean(data,1)) 

data = a.toa_lw_all_mon(:,:,index);
data = squeeze(mean(data,1));
ceres.lwdata = data;

data = a.toa_sw_all_mon(:,:,index);
data = squeeze(mean(data,1));
ceres.swdata = data;

data = a.toa_net_all_mon(:,:,index);
data = squeeze(mean(data,1));
ceres.netdata = data;

data = a.toa_cre_lw_mon(:,:,index);
data = squeeze(mean(data,1));
ceres.crelwdata = data;

data = a.toa_cre_sw_mon(:,:,index);
data = squeeze(mean(data,1));
ceres.creswdata = data;

data = a.toa_cre_net_mon(:,:,index);
data = squeeze(mean(data,1));
ceres.crenetdata = data;

if iCorT == 1 | iCorT == 0
  disp('getting _c_ == partially clear observed pixels : partial cloud filled version == from actual clear scenes') 
  data = a.toa_lw_clr_c_mon(:,:,index);
  data = squeeze(mean(data,1));
  ceres.lwdata_clr = data;

  data = a.toa_sw_clr_c_mon(:,:,index);
  data = squeeze(mean(data,1));
  ceres.swdata_clr = data;

  data = a.toa_net_clr_c_mon(:,:,index);
  data = squeeze(mean(data,1));
  ceres.netdata_clr = data;
end
if iCorT == -1 | iCorT == 0
  disp('getting _t_ == empirically/astonishingly totally clear observed pixels == from clear sky calculations') 
  data = a.toa_lw_clr_t_mon(:,:,index);
  data = squeeze(mean(data,1));
  ceres.lwdata_clr = data;

  data = a.toa_sw_clr_t_mon(:,:,index);
  data = squeeze(mean(data,1));
  ceres.swdata_clr = data;

  data = a.toa_net_clr_t_mon(:,:,index);
  data = squeeze(mean(data,1));
  ceres.netdata_clr = data;
end
  
data = a.solar_mon(:,:,index);
data = squeeze(mean(data,1));
ceres.solardata = data;

data = a.cldarea_total_daynight_mon(:,:,index);
data = squeeze(mean(data,1));
ceres.cldareadata = data;

data = a.cldpress_total_daynight_mon(:,:,index);
data = squeeze(mean(data,1));
ceres.cldpressdata = data;

data = a.cldtemp_total_daynight_mon(:,:,index);
data = squeeze(mean(data,1));
ceres.cldtempdata = data;

data = a.cldtau_total_day_mon(:,:,index);
data = squeeze(mean(data,1));
ceres.cldtaudata = data;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{

EBAF 4.1

Parameters : 
I clicked on ALL params for
TOA fluxes
TOA CRE fluxes
Solar Flux
Cloud Params
Surface Fluxes
Surface CRE fluxes

Temmporal Res : monthly mean

Spatial : 1x1 grid

Time range : 09/2002 - 08/2018
%}

