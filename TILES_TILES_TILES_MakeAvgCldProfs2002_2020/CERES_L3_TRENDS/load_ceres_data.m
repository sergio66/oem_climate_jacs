function ceres = load_ceres_data(ceres_fname,iCorT)

%% see /asl/s1/sergio/CERES_OLR_15year/Readme
%https://ceres.larc.nasa.gov/order_data.php
%
%Get monthly data set from 2002/09 to XXXX/08 : regional, monthly
%  CERES_EBAF-TOA_Ed4.1 Order

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Ryan suggested this
 
%% Interesting. I agree it often looks closer to the all-sky CERES but I
%% can’t think of a reason why. CERES does have biases of ~ 5W/m2 but
%% that’s for the raw values, not anomalies, where the errors are
%% believed to be much much smaller (and in line with ocean heat content
%% measurements) owing to the good stability of the instrument.  I wonder
%% if this is just a coincidence that your calculations match up with the
%% all-sky. Another possibility is it has to do with the clear-sky CERES
%% fluxes you are using. As of CERES EBAF version 4.1 they have a
%% traditional clear-sky product that uses clear-sky scenes, but they
%% also have a new clear-filled product where the total region is
%% clear-sky. I’m not sure how they do it, but it’s more lkike how AIRS
%% OLR and climate models define clear-sky, where there are no clouds at
%% all.  They must be doing some sort of correction using a radiative
%% transfer model or something.
%% 
%% Anyways, it may be worth comparing with that clear-filled version if
%% you aren’t already.  I’m not sure if it will improve things, but worth
%% a shot I think. You can download it from the CERES EBAF product rather
%% than the CERES EBAF TOA product on the CERES website. Here is a direct
%% link. Just click the little down arrow next to “TOA Fluxes” to see the
%% two clear-sky options.
%% https://ceres-tool.larc.nasa.gov/ord-tool/jsp/EBAF41Selection.jsp
%%
%% I mentioned the CERES thing and someone had a good idea.  Do you know
%% which CERES clear-sky you are using?  Is it from their EBAF product?
%% If so, is it the clear-sky (partial cloud "c") version or the
%% clear-sky (total cloud "t") version?  They are known to have different
%% trends in the global-mean (I forgot which is larger) but maybe they
%% also have different trends latitudinally. This is noteworthy for
%% you. All of your other OLR calculations come from models (well,
%% reanalysis at least) or radiative transfer calculations that were
%% performed without clouds, right?  That is how the CERES folks derive
%% their total-cloud "t" clear-sky. It involves a radiative transfer
%% calculation without clouds, more like how a model does it. Their
%% partial cloud "c" clear-sky flux is the original product where its
%% comprised of actual clear-sky scenes as observed from the
%% instrument. You can imagine e.g. the water vapor profile in actual
%% clear-sky scenes where there was no cloud may be different than the
%% water vapor profile in a scene where a cloud was present.
%% Consequently, the two clear-sky OLR calculations that CERES provides
%% are different.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 0
  error('need one argin')
  ceres_fname = '/asl/s1/sergio/CERES_OLR_15year/CERES_EBAF-TOA_Ed4.1_Subset_200209-202108.nc'; 
    Y0 = 2002; M0 = 09; YE = 2021; ME = 09; iNumY = 19; index = 1 : 228;
  ceres_fname = '/asl/s1/sergio/CERES_OLR_15year/CERES_EBAF-TOA_Ed4.2_Subset_200003-202307.nc'; 
    Y0 = 2000; M0 = 03; YE = 2023; ME = 07; iNumY = 20; index = 31 : 31-1+240;
  iCorT = 1;  %% just get down the clear filled region in a pixel .. rather than empirically filed "Total" clear sky  
elseif nargin == 1
  iCorT = 1;  %% just get down the clear filled region in a pixel .. rather than empirically filed "Total" clear sky
end

a = read_netcdf_lls(ceres_fname);

[mmm] = length(a.time);

if ~isfield(a,'toa_lw_clr_t_mon')
  disp('toa_lw_clr_t_mon DNW so not getting the empirically filled total clear sky')
  iCorT = 1;
end

index = 1 : mmm;

ceres.lon = a.lon;
ceres.lat = a.lat;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[h,ha,p,pa] = rtpread('/home/sergio/MATLABCODE/oem_pkg_run/FIND_NWP_MODEL_TRENDS/summary_atm_N_cld_20years_all_lat_all_lon_2002_2022_monthlyERA5.ip.rtp');

hindex = 1 : 8;
hindex = 1;

F.s_longitude = ncread(ceres_fname,'lon');
F.s_latitude  = ncread(ceres_fname,'lat');
F.s_time      = ncread(ceres_fname,'time');
F.s_mtime     = datenum(1900,0,0,double(F.s_time),0,0);

% [X,Y] = ndgrid(F.s_latitude,F.s_longitude);
% iX = flipud(X); iY = flipud(Y);
% figure(1); clf; simplemap(X,simplemap(wrapTo180(Y),squeeze(a.toa_lw_all_mon(:,:,1))))

[Y,X] = ndgrid(F.s_latitude,F.s_longitude);
Y = Y'; X = X';
iX = X; iY = Y;
figure(1); clf; simplemap(Y,wrapTo180(X),squeeze(a.toa_lw_all_mon(:,:,1)))

F.junk.ig   = griddedInterpolant(iX,iY,(single(ncread(ceres_fname,'toa_lw_all_mon',[1 1 hindex],[Inf Inf 1]))),'linear');
miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
figure(2); clf; simplemap(p.rlat,p.rlon,miaow,5); colorbar; shading flat; caxis([200 300]); colormap jet;
figure(2); clf; scatter_coast(p.rlon,p.rlat,100,miaow); colorbar; shading flat; caxis([200 300]); colormap jet;
figure(1); cx = caxis; figure(2); caxis(cx)

for hindex = 1 : length(a.time)
  F.junk.ig   = griddedInterpolant(iX,iY,(single(ncread(ceres_fname,'toa_lw_all_mon',[1 1 hindex],[Inf Inf 1]))),'linear');
  miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
  ceres.toa_lw_all_4608(hindex,:) = miaow;

  if iCorT == 1
    F.junk.ig   = griddedInterpolant(iX,iY,(single(ncread(ceres_fname,'toa_lw_clr_c_mon',[1 1 hindex],[Inf Inf 1]))),'linear');
    miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
    ceres.toa_lw_clr_4608(hindex,:) = miaow;

  elseif iCorT == -1
    F.junk.ig   = griddedInterpolant(iX,iY,(single(ncread(ceres_fname,'toa_lw_clr_t_mon',[1 1 hindex],[Inf Inf 1]))),'linear');
    miaow = F.junk.ig(wrapTo360(p.rlon),p.rlat);;
    ceres.toa_lw_clr_4608(hindex,:) = miaow;

  end
end
ceres
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data = a.toa_lw_all_mon(:,:,index);
data = squeeze(mean(data,1));
ceres.lwdata = data;

data = a.toa_sw_all_mon(:,:,index);
data = squeeze(mean(data,1));
ceres.swdata = data;

data = a.toa_net_all_mon(:,:,index);
data = squeeze(mean(data,1));
ceres.netdata = data;

if iCorT == 1
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

else
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

