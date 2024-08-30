function ceres = load_ceres_data(ceres_fname,iCorT)

%% see /asl/s1/sergio/CERES_OLR_15year/Readme
%https://ceres.larc.nasa.gov/order_data.php
%
%Get monthly data set from 2002/09 to XXXX/08 : regional, monthly
%  CERES_EBAF-TOA_Ed4.1 Order

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 0
  error('need one argin')
  ceres_fname1 = '/asl/s1/sergio/CERES_OLR_15year/CERES_EBAF_Ed4.2_Subset_200209-201706.nc';
  ceres_fname2 = '/asl/s1/sergio/CERES_OLR_15year/CERES_EBAF_Ed4.2_Subset_201707-202208.nc';
  ceres_fname = '/asl/s1/sergio/CERES_OLR_15year/CERES_EBAF_Ed4.2_Subset_200209-202208_ILR.nc';
    Y0 = 2002; M0 = 09; YE = 2022; ME = 09; iNumY = 20; index = 1 : 240;
  iCorT = 1;  %% just get down the clear filled region in a pixel .. rather than empirically filed "Total" clear sky  
elseif nargin == 1
  iCorT = 1;  %% just get down the clear filled region in a pixel .. rather than empirically filed "Total" clear sky
end

a = read_netcdf_lls(ceres_fname);

[mmm] = length(a.time);

if ~isfield(a,'sfc_new_lw_clr_t_mon')
  disp('sfc_new_lw_clr_t_mon DNW so not getting the empirically filled total clear sky')
  iCorT = 1;
end

index = 1 : mmm;

ceres.lon = a.lon;
ceres.lat = a.lat;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[h,ha,p,pa] = rtpread('../FIND_NWP_MODEL_TRENDS/summary_atm_N_cld_20years_all_lat_all_lon_2002_2022_monthlyERA5.ip.rtp');

hindex = 1 : 8;
hindex = 1;

F.s_longitude = ncread(ceres_fname,'lon');
F.s_latitude  = ncread(ceres_fname,'lat');
F.s_time      = ncread(ceres_fname,'time');
F.s_mtime     = datenum(1900,0,0,double(F.s_time),0,0);

% [X,Y] = ndgrid(F.s_latitude,F.s_longitude);
% iX = flipud(X); iY = flipud(Y);
% figure(1); clf; simplemap(X,simplemap(wrapTo180(Y),squeeze(a.sfc_new_lw_all_mon(:,:,1))))

[Y,X] = ndgrid(F.s_latitude,F.s_longitude);
Y = Y'; X = X';
iX = X; iY = Y;
figure(1); clf; simplemap(simplemap(Y,wrapTo180(X),squeeze(a.sfc_lw_down_all_mon(:,:,1))))

F.junk.ig   = griddedInterpolant(iX,iY,(single(ncread(ceres_fname,'sfc_lw_down_all_mon',[1 1 hindex],[Inf Inf 1]))),'linear');
miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
figure(2); clf; simplemap(p.rlat,p.rlon,miaow,5); colorbar; shading flat; caxis([200 300]); colormap jet;
figure(2); clf; scatter_coast(p.rlon,p.rlat,100,miaow); colorbar; shading flat; caxis([200 300]); colormap jet;
figure(1); cx = caxis; figure(2); caxis(cx)

F.junk2.ig   = griddedInterpolant(iX,iY,(single(ncread(ceres_fname,'sfc_sw_down_all_mon',[1 1 hindex],[Inf Inf 1]))),'linear');
miaow = F.junk2.ig(wrapTo360(p.rlon),p.rlat);;
figure(2); clf; simplemap(p.rlat,p.rlon,miaow,5); colorbar; shading flat; caxis([200 300]); colormap jet;
figure(2); clf; scatter_coast(p.rlon,p.rlat,100,miaow); colorbar; shading flat; caxis([200 300]); colormap jet;
figure(1); cx = caxis; figure(2); caxis(cx)


for hindex = 1 : length(a.time)
  F.junk.ig   = griddedInterpolant(iX,iY,(single(ncread(ceres_fname,'sfc_lw_down_all_mon',[1 1 hindex],[Inf Inf 1]))),'linear');
  miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
  ceres.sfc_lw_down_all_4608(hindex,:) = miaow;

  if iCorT == 1
    F.junk.ig   = griddedInterpolant(iX,iY,(single(ncread(ceres_fname,'sfc_lw_down_clr_c_mon',[1 1 hindex],[Inf Inf 1]))),'linear');
    miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
    ceres.sfc_lw_clr_4608(hindex,:) = miaow;

  elseif iCorT == -1
    F.junk.ig   = griddedInterpolant(iX,iY,(single(ncread(ceres_fname,'sfc_lw_down_clr_t_mon',[1 1 hindex],[Inf Inf 1]))),'linear');
    miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
    ceres.sfc_lw_clr_4608(hindex,:) = miaow;

  end

  F.junk.ig   = griddedInterpolant(iX,iY,(single(ncread(ceres_fname,'sfc_sw_down_all_mon',[1 1 hindex],[Inf Inf 1]))),'linear');
  miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
  ceres.sfc_sw_down_all_4608(hindex,:) = miaow;

  if iCorT == 1
    F.junk.ig   = griddedInterpolant(iX,iY,(single(ncread(ceres_fname,'sfc_sw_down_clr_c_mon',[1 1 hindex],[Inf Inf 1]))),'linear');
    miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
    ceres.sfc_sw_clr_4608(hindex,:) = miaow;

  elseif iCorT == -1
    F.junk.ig   = griddedInterpolant(iX,iY,(single(ncread(ceres_fname,'sfc_sw_down_clr_t_mon',[1 1 hindex],[Inf Inf 1]))),'linear');
    miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
    ceres.sfc_sw_clr_4608(hindex,:) = miaow;

  end
end
ceres
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data = a.sfc_lw_down_all_mon(:,:,index);
data = squeeze(mean(data,1));
ceres.lwdata = data;

data = a.sfc_sw_down_all_mon(:,:,index);
data = squeeze(mean(data,1));
ceres.swdata = data;

data = a.sfc_net_tot_all_mon(:,:,index);
data = squeeze(mean(data,1));
ceres.netdata = data;

if iCorT == 1
  disp('getting _c_ == partially clear observed pixels : partial cloud filled version == from actual clear scenes') 
  data = a.sfc_lw_down_clr_c_mon(:,:,index);
  data = squeeze(mean(data,1));
  ceres.lwdata_clr = data;

  data = a.sfc_sw_down_clr_c_mon(:,:,index);
  data = squeeze(mean(data,1));
  ceres.swdata_clr = data;

  data = a.sfc_sw_down_all_mon(:,:,index);
  data = squeeze(mean(data,1));
  ceres.netdata_clr = data;

else
  disp('getting _t_ == empirically/astonishingly totally clear observed pixels == from clear sky calculations') 
  data = a.sfc_lw_down_clr_t_mon(:,:,index);
  data = squeeze(mean(data,1));
  ceres.lwdata_clr = data;

  data = a.sfc_sw_down_clr_t_mon(:,:,index);
  data = squeeze(mean(data,1));
  ceres.swdata_clr = data;

  data = a.sfc_sw_down_all_mon(:,:,index);
  data = squeeze(mean(data,1));
  ceres.netdata_clr = data;
end
  
%  data = a.solar_mon(:,:,index);
%  data = squeeze(mean(data,1));
%  ceres.solardata = data;

%  data = a.cldarea_total_daynight_mon(:,:,index);
%  data = squeeze(mean(data,1));
%  ceres.cldareadata = data;

%  data = a.cldpress_total_daynight_mon(:,:,index);
%  data = squeeze(mean(data,1));
%  ceres.cldpressdata = data;

%  data = a.cldtemp_total_daynight_mon(:,:,index);
%  data = squeeze(mean(data,1));
%  ceres.cldtempdata = data;

%  data = a.cldtau_total_day_mon(:,:,index);
%  data = squeeze(mean(data,1));
%  ceres.cldtaudata = data;
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

