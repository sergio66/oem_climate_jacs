function out = get_timeseries_one_tile_quantiles(latbin,lonbin,findtile)

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

dbt = 180 : 1 : 340;
set_iQAX

out.latbin = latbin;
out.lonbin = lonbin;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% BETTER TRY
hugedir = dir('/asl/isilon/airs/tile_test7/');  %% 480 timesteps till Sep 2023
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
length(saveyear)


%% Spet 01-Dec 31 = 8 timesteps, so Jan 01-Aug 31 = 23-8
%% so 8 steps for 2002, 23 step for other years, 13 steps for 2022
for tt = 1 : 8 + (iNumYears-1)*23 + (23-8)
  YYX   = saveyear(tt);
  tstep = savestep(tt); 
  latstr = strname(1:6);  %% eg S02p75

  fname  = ['/asl/isilon/airs/tile_test7/' num2str(YYX,'%02d') '_s' num2str(tt,'%03d')    '/' latstr '/tile_' num2str(YYX,'%02d') '_s' num2str(tt,'%03d') '_' strname '.nc'];
  fname  = ['/asl/isilon/airs/tile_test7/' num2str(YYX,'%02d') '_s' num2str(tstep,'%03d') '/' latstr '/tile_' num2str(YYX,'%02d') '_s' num2str(tstep,'%03d') '_' strname '.nc'];

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

ii = 0;
%% so 8 steps for 2002, 23 step for other years, 13 steps for 2022
for tt = 1 : 8 + (iNumYears-1)*23 + (23-8)
  ii    = ii + 1;
  YYX   = saveyear(tt);
  tstep = savestep(tt); 
  latstr = strname(1:6);  %% eg S02p75

  fname  = ['/asl/isilon/airs/tile_test7/' num2str(YYX,'%02d') '_s' num2str(tt,'%03d')    '/' latstr '/tile_' num2str(YYX,'%02d') '_s' num2str(tt,'%03d') '_' strname '.nc'];
  fname  = ['/asl/isilon/airs/tile_test7/' num2str(YYX,'%02d') '_s' num2str(tstep,'%03d') '/' latstr '/tile_' num2str(YYX,'%02d') '_s' num2str(tstep,'%03d') '_' strname '.nc'];

  latstr = strname(1:6);  %% eg S02p75

  if ~exist(fname)
    fprintf(1,'%3i %s DNE \n',tt,fname);
    %error('fine DNE')

    out.mean_lat(tt)      = nan;
    out.mean_lon(tt)      = nan;

    out.mean_rtime(tt)    = nan;
    out.yy(tt) = nan;     out.mm(tt) = nan;     out.dd(tt) = nan;     out.doy(tt) = nan;

    out.mean_rad(:,tt)    = nan;
    out.std_rad(:,tt)     = nan;
    out.max_rad(:,tt)     = nan;
    out.min_rad(:,tt)     = nan;

    out.mean_rad_1231(tt) = nan;
    out.max_rad_1231(tt)  = nan;
    out.min_rad_1231(tt)  = nan;

    out.name{tt} = 'DNE';

    %%%%%%%%%%%%%%%%%%%%%%%%%
    out.asc_lump.mean_lat(tt) = NaN;
    out.asc_lump.mean_lon(tt) = NaN;
    out.asc_lump.mean_rtime(tt) = NaN;
    out.asc_lump.yy(tt) = NaN;
    out.asc_lump.mm(tt) = NaN;
    out.asc_lump.dd(tt) = NaN;
    out.asc_lump.doy(tt) = NaN;
    out.asc_lump.time(tt) = NaN;
    out.asc_lump.mean_rad(:,tt) = NaN;
    out.asc_lump.std_rad(:,tt) = NaN;
    out.asc_lump.max_rad(:,tt) = NaN;
    out.asc_lump.min_rad(:,tt) = NaN;
    out.asc_lump.mean_rad_1231(tt) = NaN;
    out.asc_lump.std_rad_1231(tt) = NaN;
    out.asc_lump.max_rad_1231(tt) = NaN;
    out.asc_lump.min_rad_1231(tt) = NaN;

    out.asc_quantile.quantile1231_asc(tt,:) = NaN;
    out.asc_quantile.count_quantile1231_asc(tt,:) = NaN;
    out.asc_quantile.rad_asc(tt,:,:) = NaN;
    out.asc_quantile.stdrad_asc(tt,:,:) = NaN;
    out.asc_quantile.satzen_quantile1231_asc(tt,:) = NaN;
    out.asc_quantile.solzen_quantile1231_asc(tt,:) = NaN;
    out.asc_quantile.satzen_quantile1231_asc(tt,:) = NaN;
    out.asc_quantile.solzen_quantile1231_asc(tt,:) = NaN;

    %%%%%%%%%%%%%%%%%%%%%%%%%
    out.desc_lump.mean_lat(tt) = NaN;
    out.desc_lump.mean_lon(tt) = NaN;
    out.desc_lump.mean_rtime(tt) = NaN;
    out.desc_lump.yy(tt) = NaN;
    out.desc_lump.mm(tt) = NaN;
    out.desc_lump.dd(tt) = NaN;
    out.desc_lump.doy(tt) = NaN;
    out.desc_lump.time(tt) = NaN;
    out.desc_lump.mean_rad(:,tt) = NaN;
    out.desc_lump.std_rad(:,tt) = NaN;
    out.desc_lump.max_rad(:,tt) = NaN;
    out.desc_lump.min_rad(:,tt) = NaN;
    out.desc_lump.mean_rad_1231(tt) = NaN;
    out.desc_lump.std_rad_1231(tt) = NaN;
    out.desc_lump.max_rad_1231(tt) = NaN;
    out.desc_lump.min_rad_1231(tt) = NaN;

    out.desc_quantile.quantile1231_desc(tt,:) = NaN;
    out.desc_quantile.count_quantile1231_desc(tt,:) = NaN;
    out.desc_quantile.rad_desc(tt,:,:) = NaN;
    out.desc_quantile.stdrad_desc(tt,:,:) = NaN;
    out.desc_quantile.satzen_quantile1231_desc(tt,:) = NaN;
    out.desc_quantile.solzen_quantile1231_desc(tt,:) = NaN;
    out.desc_quantile.satzen_quantile1231_desc(tt,:) = NaN;
    out.desc_quantile.solzen_quantile1231_desc(tt,:) = NaN;

  else
    fprintf(1,'tt = %3i timestep = %3i diff(tt-tstep) = %2i loading in %s \n',tt,tstep,tt-tstep,fname);
    iaFound(tt) = +1;

    %a0 = read_netcdf_lls(fname);
    [a] = read_netcdf_h5(fname);

    ianpts = 1:a.total_obs;
    %scatter(a.lon(ianpts),a.lat(ianpts),1,a.asc_flag(ianpts)); colorbar
    %plot(double(a.sol_zen(ianpts)),a.asc_flag(ianpts))

    [yy,mm,dd,hh] = tai2utcSergio(a.tai93(ianpts)+offset1958_to_1993);

    iPlot = -1;
    lump_all_together_onetile_timestep
    lump_all_together_onetile_day_quantile
    lump_all_together_onetile_night_quantile

keyboard_nowindow
  end
end

fprintf(1,'found %3i out of %3i files \n',sum(iaFound),ttmax);

%% keyboard_nowindow

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% see Code_for_TileTrends/tile_fits_quantiles.m
trends_stats = find_trends_lagcoeff(out,quants);
out.trends_stats = trends_stats;

load ../Code_for_TileTrends/airs_f.mat
out.fairs = fairs;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% save('fruit.mat', '-struct', 'fruit'):
savename = ['tile_timeseries_latbin_' num2str(out.latbin,'%2i') '_lonbin_' num2str(out.lonbin,'%2i') '_quantiledata.mat'];
savename = ['../TrendsPaper_Reviewer_UNC/tile_timeseries_latbin_' num2str(out.latbin,'%2i') '_lonbin_' num2str(out.lonbin,'%2i') '_quantiledata.mat'];
out.latbin = latbin;
out.lonbin = lonbin;
out.comment = 'see /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries/get_timeseries_one_tile.m';

saver = ['save ' savename ' out comment'];
saver = ['save(savename,''-struct'',''out'');'];
out.savename = savename;
out.saver = saver;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
%% when subroutine ends, 
  savename = out.savename;
  eval(out.saver)

plot(fairs,out.trends_stats.resid_desc_std(:,3))
plot(fairs,out.trends_stats.resid_desc_std(:,3),'+',fairs,out.trends_stats.resid_asc_std(:,3),'*')
  ylabel('Std Fit Residual (K)'); legend('desc','asc','location','best');

%% then load in the file and run these

iaFound = find(max_rad_1231 > 0); whos iaFound

figure(1); plot(1:460,squeeze(desc_quantile.rad_desc(:,3,1520)),1:460,squeeze(desc_quantile.stdrad_desc(:,3,1520))*50)
figure(2); plot(1:2645,nanmean(squeeze(desc_quantile.rad_desc(:,1,:)),1),...
                1:2645,nanmean(squeeze(desc_quantile.rad_desc(:,3,:)),1),...
                1:2645,nanmean(squeeze(desc_quantile.rad_desc(:,5,:)),1))
  title('mean rad Q 1,3,5')
figure(3); plot(1:2645,nanmean(squeeze(desc_quantile.stdrad_desc(:,1,:)),1),...
                1:2645,nanmean(squeeze(desc_quantile.stdrad_desc(:,3,:)),1),...
                1:2645,nanmean(squeeze(desc_quantile.stdrad_desc(:,5,:)),1))
  title('std rad Q 1,3,5')

%}
