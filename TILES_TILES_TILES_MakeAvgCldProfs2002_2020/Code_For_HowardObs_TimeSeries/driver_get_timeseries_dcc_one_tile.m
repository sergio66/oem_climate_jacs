function out = driver_get_timeseries_dcc_one_tile(latbin,lonbin,iNumYears,iDorA,iLorOorA,findtile)

%% iTileNum == Sergio = 1 -- 4608
%%   so Latbin 01/Lonbin 01 == 0001
%%   so Latbin 64/Lonbin 72 == 4608
%%   iTileNum = (Latbin-1)*72 + LonBin
%%
%%
%% see also driver_load_individual_tile_maxmin_timeseries.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
/home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR has Readme_Anomaly_TWP_lat35_lon66

hence 

addpath /home/sergio/MATLABCODE/PLOTTER

dcc_t23_35_66 = driver_get_timeseries_dcc_one_tile(35,66,23,-1,0);  %% iDorA = -1 ==> asc
% save dcc_t23years_lat35_lon66 dcc_t23_35_66
process_get_timeseries_one_tile
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/COLORMAP
addpath /home/sergio/KCARTA/MATLAB
addpath /home/sergio/git/rtp_prod2/util/

%    iDorA = -1; %% asc
%    iDorA =  0; %% all
%    iDorA = +1; %% desc DEFAULT    
%    iDorA = -1;

%iNumYears = 20;
%iNumYears = 23;

bah = load('h2645structure.mat');
f2645 = bah.h.vchan;

% function out = get_timeseries_dcc_one_tile(latbin,lonbin,iNumYears,iDorA,iLorOorA,findtile)
if nargin == 0
  latbin = 32;
  lonbin = 36;
  iNumYears = 23;
  iDorA = +1; %% desc DEFAULT
  iLorOorA = 0; %% do all (land and ocean)
  findtile = -1;
elseif nargin == 1
  lonbin = 36;
  iNumYears = 23;    
  iDorA = +1; %% desc DEFAULT
  iLorOorA = 0; %% do all (land and ocean)  
  findtile = -1;
elseif nargin == 2
  iNumYears = 23;  
  iDorA = +1; %% desc DEFAULT
  iLorOorA = 0; %% do all (land and ocean)  
  findtile = -1;
elseif nargin == 3
  iDorA = +1; %% desc DEFAULT
  iLorOorA = 0; %% do all (land and ocean)  
  findtile = -1;
elseif nargin == 4
  iLorOorA = 0; %% do all (land and ocean)  
  findtile = -1;
elseif nargin == 5
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

%% good try BUT DOES NOT WORK
indY = 8 + (0:25)*23;  %% first year 2002/09 to 2002/12 takes 9 timesteps
                       %% each additional year takes 23 more timesteps
YY = (0:iNumYears) + 2002;     %% the years
%[indY YY]

accum = [];
thetime = [];
thetimecenter = [];
thestatcenter = [];

ttmax = 460;
ttmax = iNumYears * 23;    %% there are 23 files per years (16 day intervals)
iaFound = zeros(1,ttmax);

out.latbin = latbin;
out.lonbin = lonbin;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% BETTER TRY

isilonX = '/asl/isilon/airs/tile_test7/';          %% on taki, before Apr 2025
isilonX = '/umbc/rs/strow/asl/airs/tile_test7/';   %% on chip, after  Apr 2025
dir_isilon_find_howard_tiles
isilonX = isilon_tiledir;

hugedir = dir(isilonX);  %% 480 timesteps till Sep 2023
theyear = [];
thecount = [];
for tt = 3 : length(hugedir)
  junkname = hugedir(tt).name;
  junkyear = str2num(junkname(1:4));
  junkstep = str2num(junkname(7:9));
  saveyear(tt-2) = junkyear;
  savestep(tt-2) = junkstep;

  if length(intersect(junkyear,theyear)) == 1
    boo = find(theyear == junkyear);
    thecount(boo) = thecount(boo) + 1;
  else
    theyear = [theyear junkyear];
    thecount(length(theyear)) = 1;
  end
end
thecount = cumsum(thecount);
whos theyear thecount YY indY
[theyear(1:iNumYears); thecount(1:iNumYears); YY(1:iNumYears); indY(1:iNumYears)]'

[saveyear; savestep]'
fprintf(1,'length(saveyear) = %3i \n',length(saveyear));
%fprintf(1,'length(strname)  = %3i \n',length(strname));
%strname

%% Spet 01-Dec 31 = 8 timesteps, so Jan 01-Aug 31 = 23-8
%% so 8 steps for 2002, 23 step for other years, 13 steps for 2022
tt0 = 8 + (iNumYears-1)*23 + (23-8);
fprintf(1,'8 + (iNumYears-1)*23 + (23-8) = %3i but have %3i files \n',tt0,length(saveyear))

ttmax = 460;
ttmax = iNumYears * 23;    %% there are 23 files per years (16 day intervals)
ttmax = min(tt0,length(saveyear));
iaFound = zeros(1,ttmax);

for tt = 1 : ttmax
  YYX   = saveyear(tt);
  tstep = savestep(tt); 
  latstr = strname(1:6);  %% eg S02p75

  fname  = [isilonX num2str(YYX,'%02d') '_s' num2str(tt,'%03d')    '/' latstr '/tile_' num2str(YYX,'%02d') '_s' num2str(tt,'%03d') '_' strname '.nc'];
  fname  = [isilonX num2str(YYX,'%02d') '_s' num2str(tstep,'%03d') '/' latstr '/tile_' num2str(YYX,'%02d') '_s' num2str(tstep,'%03d') '_' strname '.nc'];

  if ~exist(fname)
    fprintf(1,'%s DNE fname \n',fname)
  end
end

mooT = 0;
for yy = 2002:2002+iNumYears
  moo = find(saveyear == yy);
  mooT = mooT + length(moo);
  fprintf(1,'%4i %2i %3i \n',yy,length(moo),mooT)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('iPlot')
  iPlot = -1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set_iQAX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ii = 0;
for tt = 1 : ttmax
  ii    = ii + 1;
  YYX   = saveyear(tt);
  tstep = savestep(tt); 
  latstr = strname(1:6);  %% eg S02p75

  fname  = [isilonX num2str(YYX,'%02d') '_s' num2str(tt,'%03d')    '/' latstr '/tile_' num2str(YYX,'%02d') '_s' num2str(tt,'%03d') '_' strname '.nc'];
  fname  = [isilonX num2str(YYX,'%02d') '_s' num2str(tstep,'%03d') '/' latstr '/tile_' num2str(YYX,'%02d') '_s' num2str(tstep,'%03d') '_' strname '.nc'];

  latstr = strname(1:6);  %% eg S02p75

  if ~exist(fname)
    fprintf(1,'%3i %s DNE \n',tt,fname);
    %error('fine DNE')

    out.avg.mean_lat(tt)      = nan;
    out.avg.mean_lon(tt)      = nan;
    out.avg.mean_sol(tt)      = nan;
    out.avg.mean_sat(tt)      = nan;        

    out.avg.mean_rtime(tt)    = nan;
    out.avg.yy(tt) = nan;     out.avg.mm(tt) = nan;     out.avg.dd(tt) = nan;     out.avg.doy(tt) = nan;

    out.avg.mean_rad(:,tt)    = nan;
    out.avg.std_rad(:,tt)     = nan;
    out.avg.max_rad(:,tt)     = nan;
    out.avg.min_rad(:,tt)     = nan;

    out.avg.mean_rad_1231(tt) = nan;
    out.avg.max_rad_1231(tt)  = nan;
    out.avg.min_rad_1231(tt)  = nan;

    out.avg.name{tt} = 'DNE';
    
  else
    fprintf(1,'tt = %3i timestep = %3i diff(tt-tstep) = %2i loading in %s \n',tt,tstep,tt-tstep,fname);
    iaFound(tt) = +1;
    a = read_netcdf_lls(fname);
    
    lump_all_together_dcc_onetile_timestep
    
  end
end

fprintf(1,'found %3i out of %3i files \n',sum(iaFound),ttmax);

%% save('fruit.mat', '-struct', 'fruit'):
out.latbin = latbin;
out.lonbin = lonbin;
savename = ['tile_timeseries_latbin_' num2str(out.latbin,'%2i') '_lonbin_' num2str(out.lonbin,'%2i') '_meandata.mat'];
out.comment = 'see /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries/get_timeseries_one_tile.m';
saver = ['save ' savename ' out comment'];
saver = ['save(savename,''-struct'',''out'');'];
out.saver   = saver;
out.quantsx = quantsx;
out.dbt     = dbt;
