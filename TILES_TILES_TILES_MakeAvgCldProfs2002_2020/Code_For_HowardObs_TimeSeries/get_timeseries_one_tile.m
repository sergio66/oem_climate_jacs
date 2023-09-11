function out = get_timeseries_one_tile(latbin,lonbin,findtile)

%% iTileNum == Sergio = 1 -- 4608
%%   so Latbin 01/Lonbin 01 == 0001
%%   so Latbin 64/Lonbin 72 == 4608
%%   iTileNum = (Latbin-1)*72 + LonBin
%%
%%
%% see also driver_load_individual_tile_maxmin_timeseries.m

addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/COLORMAP
addpath /home/sergio/KCARTA/MATLAB

if nargin == 0
  latbin = 32;
  lonbin = 36;
  findtile = -1;
elseif nargin == 1
  lonbin = 36;
  findtile = -1;
end

if findtile > 0
  %% eg tying to find which tile corresponds to lat=47N,lon=-45W ..... use get_timeseries_one_tile(47,-45,1);
  latbin0 = latbin;
  lonbin0 = lonbin;
  
  load latB64.mat
  rlat65 = latB2; rlon73 = -180 : 5 : +180;

  rlon = -180 : 5 : +180;  rlat = latB2;
  rlon = 0.5*(rlon(1:end-1)+rlon(2:end));
  rlat = 0.5*(rlat(1:end-1)+rlat(2:end));
  [Y,X] = meshgrid(rlat,rlon);
  X = X; Y = Y;
  YY = Y(:)';
  YY = cos(YY*pi/180);

  latbin = find(rlat65 >= latbin0,1);
  lonbin = find(rlon73 >= lonbin0,1);

  junk = [latbin0 lonbin0 latbin lonbin];
  fprintf(1,'lat/lon = %5.2f %5.2f translates to latbin/lonbin %i %2i \n',junk);
end

%% see translator_wrong2correct.m
load translator_wrong2correct

iTileNum = (latbin-1)*72 + lonbin;

strname = correct.name{iTileNum};
boo = findstr(strname,'s237_');
strname = strname(boo+5:end-3);
fprintf(1,'latbin,lonbin = %2i %2i --> iTileNum = %4i means need to load in timeseries for %s \n',latbin,lonbin,iTileNum,strname);

%% a = read_netcdf_lls('/asl/isilon/airs/tile_test7/2013_s237/S02p75/tile_2013_s237_S02p75_E175p00.nc');
%%          tai93: [11280x1 double]
%%            lat: [11280x1 double]
%%            lon: [11280x1 double]
%%      land_frac: [11280x1 double]
%%        sol_zen: [11280x1 double]
%%        sat_zen: [11280x1 double]
%%       asc_flag: [11280x1 double]
%%            rad: [2645x11280 double]
%%         rad_qc: [11280x1 double]
%%     synth_frac: [2645x1 double]
%%        chan_qc: [2645x1 double]
%%           nedn: [2645x1 double]
%%           wnum: [2645x1 double]
%%      total_obs: 9284

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


ixy = [latbin lonbin];

iNumYears = 20;
indY = 8 + (0:25)*23;  %% first year 2002/09 to 2002/12 takes 9 timesteps
                       %% each additional year takes 23 more timesteps
YY = (0:iNumYears)+ 2002;     %% the years
%[indY YY]

accum = [];
thetime = [];
thetimecenter = [];
thestatcenter = [];

ttmax = 460;
ttmax = iNumYears * 23;    %% there are 23 files per years (16 day intervals)
iaFound = zeros(1,ttmax);

ii = 0;
for tt = 1 : ttmax
  ii = ii + 1;
  too = find(tt <= indY,1);
  YYX = YY(too);

  latstr = strname(1:6);  %% eg S02p75

  fname  = ['/asl/isilon/airs/tile_test7/' num2str(YYX,'%02d') '_s' num2str(tt,'%03d') '/' latstr '/tile_' num2str(YYX,'%02d') '_s' num2str(tt,'%03d') '_' strname '.nc'];
  if ~exist(fname)
    fprintf(1,'%3i %s DNE \n',tt,fname);
    %error('fine DNE')

    out.mean_lat(tt)      = nan;
    out.mean_lon(tt)      = nan;

    out.mean_rtime(tt)    = nan;
    out.yy(tt) = nan;     out.mm(tt) = nan;     out.dd(tt) = nan;     out.doy(tt) = nan;

    out.mean_rad(:,tt)    = nan;
    out.max_rad(:,tt)     = nan;
    out.min_rad(:,tt)     = nan;

    out.mean_rad_1231(tt) = nan;
    out.max_rad_1231(tt)  = nan;
    out.min_rad_1231(tt)  = nan;

    out.name{tt} = 'DNE';

  else
    fprintf(1,'timestep = %3i loading in %s \n',tt,fname);
    iaFound(tt) = +1;
    a = read_netcdf_lls(fname);

    N = a.total_obs;
    ianpts = 1 : N;

    asc  = find(a.asc_flag(ianpts) == 65);
    desc = find(a.asc_flag(ianpts) == 68);

    out.name{tt} = fname;

    out.mean_lat(tt)      = nanmean(a.lat(1:N));
    out.mean_lon(tt)      = nanmean(a.lon(1:N));

    out.mean_rtime(tt)    = nanmean(a.tai93(1:N));
    [yy,mm,dd] = tai2utcSergio(out.mean_rtime + offset1958_to_1993);
    doy = change2days(yy,mm,dd,2002);
    out.yy(tt) = yy(tt);     out.mm(tt) = mm(tt);     out.dd(tt) = dd(tt);     out.doy(tt) = doy(tt);  out.time(tt) = 2002+doy(tt)/365;

    out.mean_rad(:,tt)    = nanmean(a.rad(:,1:N),2);
    out.max_rad(:,tt)     = nanmax(a.rad(:,1:N),[],2);
    out.min_rad(:,tt)     = nanmin(a.rad(:,1:N),[],2);

    out.mean_rad_1231(tt) = nanmean(a.rad(1520,1:N));
    out.max_rad_1231(tt)  = nanmax(a.rad(1520,1:N));
    out.min_rad_1231(tt)  = nanmin(a.rad(1520,1:N));

    plot(2002+doy/365,rad2bt(1231,out.min_rad_1231),'b',2002+doy/365,rad2bt(1231,out.mean_rad_1231),'g',2002+doy/365,rad2bt(1231,out.max_rad_1231),'r'); 
    title('BT 1231')
    pause(0.1)
  end
end

fprintf(1,'found %3i out of %3i files \n',sum(iaFound),ttmax);

