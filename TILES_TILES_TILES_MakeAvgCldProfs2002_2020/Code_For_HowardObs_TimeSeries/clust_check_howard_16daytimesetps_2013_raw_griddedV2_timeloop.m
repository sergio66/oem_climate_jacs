addpath /home/motteler/shome/chirp_test
addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /asl/matlib/aslutil

%{
ls -lt /asl/isilon/airs/tile_test7/2002_s008/                        | wc -l      64 subdirs
ls -lt /asl/isilon/airs/tile_test7/2002_s008/N00p00/tile_2002_s008_* | wc -l      72 files in each subdir
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('WARNING ..... these Lat/Lon grids are WRONGLY NUMBERED because of matlab dir() .. so need to translate using "translator_wrong2correct.m" when concating timeseries')
disp('WARNING ..... these Lat/Lon grids are WRONGLY NUMBERED because of matlab dir() .. so need to translate using "translator_wrong2correct.m" when concating timeseries')
disp('WARNING ..... these Lat/Lon grids are WRONGLY NUMBERED because of matlab dir() .. so need to translate using "translator_wrong2correct.m" when concating timeseries')

disp('same as clust_check_howard_16daytimesetps_2013_raw_griddedV2 except innermost loop by time!!!')
disp('same as clust_check_howard_16daytimesetps_2013_raw_griddedV2 except innermost loop by time!!!')
disp('same as clust_check_howard_16daytimesetps_2013_raw_griddedV2 except innermost loop by time!!!')

iVers = 0;  %% use JOB together with hugedir = dir('/asl/isilon/airs/tile_test7/');
iVers = 1;  %% use JOB together with "notdonetxt" generated by loop_make_correct_timeseriesV2.m

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));   %% 1 -- 4608
JOB = 100
JOB = 2291
%JOB = 1

hugedir = dir('/asl/isilon/airs/tile_test7/');  %% 417 timesteps till Nov 2020

% indonesia = 0.78S, 113E   so latbin32,lonbin 113/180*36 + 36 = 59
% jj = 32; ii = 59;  
%  greenland = 71 N, 42 W  so latbinB64 = 59, lonbin72 = (180-42)/5 = 27
% jj = 59; ii = 27; 
% JOB = (jj-1)*72 + ii;

ntime = length(hugedir)-2;

tic 
thesave = struct;
thesave.iii = nan(1,ntime);
thesave.jjj = nan(1,ntime);

thesave.count_asc = nan(1,ntime);
thesave.lat_asc = nan(1,ntime);
thesave.lon_asc = nan(1,ntime);
thesave.meansolzen_asc = nan(1,ntime);
thesave.stdsolzen_asc  = nan(1,ntime);
thesave.meansatzen_asc = nan(1,ntime);
thesave.stdsatzen_asc  = nan(1,ntime);
thesave.meanyear_asc = nan(1,ntime);
thesave.stdyear_asc  = nan(1,ntime);
thesave.meanmonth_asc = nan(1,ntime);
thesave.stdmonth_asc  = nan(1,ntime);
thesave.meanday_asc = nan(1,ntime);
thesave.stdday_asc  = nan(1,ntime);
thesave.meanhour_asc  = nan(1,ntime);
thesave.stdhour_asc  = nan(1,ntime);
thesave.meantai93_asc = nan(1,ntime);
thesave.stdtai93_asc  = nan(1,ntime);
thesave.meanrad_asc = nan(ntime,2645);
thesave.stdrad_asc  = nan(ntime,2645);
thesave.max1231_asc = nan(1,ntime);
thesave.min1231_asc = nan(1,ntime);
thesave.DCC1231_asc = nan(1,ntime);
thesave.hist_asc = nan(ntime,161);
thesave.quantile1231_asc = nan(ntime,16);
thesave.rad_asc = nan(ntime,16,2645);
thesave.count_quantile1231_asc = nan(ntime,16);
thesave.satzen_quantile1231_asc = nan(ntime,16);
thesave.solzen_quantile1231_asc = nan(ntime,16);

thesave.count_desc = nan(1,ntime);
thesave.lat_desc = nan(1,ntime);
thesave.lon_desc = nan(1,ntime);
thesave.meansolzen_desc = nan(1,ntime);
thesave.stdsolzen_desc  = nan(1,ntime);
thesave.meansatzen_desc = nan(1,ntime);
thesave.stdsatzen_desc  = nan(1,ntime);
thesave.meanyear_desc = nan(1,ntime);
thesave.stdyear_desc  = nan(1,ntime);
thesave.meanmonth_desc = nan(1,ntime);
thesave.stdmonth_desc  = nan(1,ntime);
thesave.meanday_desc = nan(1,ntime);
thesave.stdday_desc  = nan(1,ntime);
thesave.meanhour_desc  = nan(1,ntime);
thesave.stdhour_desc  = nan(1,ntime);
thesave.meantai93_desc = nan(1,ntime);
thesave.stdtai93_desc  = nan(1,ntime);
thesave.meanrad_desc = nan(ntime,2645);
thesave.stdrad_desc  = nan(ntime,2645);
thesave.max1231_desc = nan(1,ntime);
thesave.min1231_descc = nan(1,ntime);
thesave.DCC1231_desc = nan(1,ntime);
thesave.hist_desc = nan(ntime,161);
thesave.quantile1231_desc = nan(ntime,16);
thesave.rad_desc = nan(ntime,16,2645);
thesave.count_quantile1231_desc = nan(ntime,16);
thesave.satzen_quantile1231_desc = nan(ntime,16);
thesave.solzen_quantile1231_desc = nan(ntime,16);

set_iQAX  %% set the quants
dbt = 180 : 1 : 340;

%{
%% see loop_make_correct_timeseriesV2

%% indonesia = 0.78S, 113E   so latbin32,lonbin 113/180*36 + 36 = 59
jj = 32; ii = 59;  

%% greenland = 71 N, 42 W  so latbinB64 = 59, lonbin72 = (180-42)/5 = 27
jj = 59; ii = 27; 

JOB = (jj-1)*72 + ii;
x = translator_wrong2correct(JOB);
fdirIN  = ['../DATAObsStats_StartSept2002/LatBin' num2str(x.wrong2correct_I_J_lon_lat(2),'%02i') '/LonBin' num2str(x.wrong2correct_I_J_lon_lat(1),'%02i') '/'];
fdirOUT = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];

so test : 

iCnt = 0;
for jj = 1 : 64
  for ii = 1 : 72
    iCnt = iCnt + 1;
    jjsave(iCnt) = jj;
    iisave(iCnt) = ii;
    JOB(iCnt) = (jj-1)*72 + ii;    
  end
end

jjnyuk = floor((JOB-1)/72) + 1;
iinyuk = JOB - (jjnyuk-1)*72;

[sum(jjnyuk-jjsave) sum(iinyuk-iisave)]

%}

jj = floor((JOB-1)/72) + 1;
ii = JOB - (jj-1)*72;
[JOB ii jj]

iCnt = 0;
for ttt = 1 : length(hugedir)-2
  tt = ttt + 2; %% since the first two are . and ..
  date_stamp = hugedir(tt).name;

  thedir0 = dir(['/asl/isilon/airs/tile_test7/' date_stamp '/']);
  iii = ii + 2;
  dirdirname = ['/asl/isilon/airs/tile_test7/' date_stamp '/' thedir0(iii).name];
  dirx = dir([dirdirname '/*.nc']);
  jjj = jj;

  fname = [dirdirname '/' dirx(jjj).name];
  iCnt = iCnt + 1;
  thesave.fname{iCnt} = fname;

  fprintf(1,'tt=%4i timestep= %s ii,jj=%4i %4i iCnt=%5i fname= %s \n',tt,date_stamp,iii-2,jjj,iCnt,fname);

  [s, a] = read_netcdf_h5(fname);
  ianpts = 1:s.total_obs;
  %scatter(s.lon(ianpts),s.lat(ianpts),1,s.asc_flag(ianpts)); colorbar
  %plot(double(s.sol_zen(ianpts)),s.asc_flag(ianpts))

  thesave.iii(iCnt) = iii-2;  %% so this is LAT subdir                           ... I really should have called this jjj
  thesave.jjj(iCnt) = jjj;    %% and now we are reading the individual LON files ... I really should have called this iii
  thesave.fname{iCnt} = fname;

  [yy,mm,dd,hh] = tai2utcSergio(s.tai93(ianpts)+offset1958_to_1993);

  asc = find(s.asc_flag(ianpts) == 65);  
  thesave.count_asc(iCnt) = length(asc);
  thesave.lat_asc(iCnt)  = nanmean(s.lat(asc));
  thesave.lon_asc(iCnt)  = nanmean(s.lon(asc));
  thesave.meanyear_asc(iCnt) = nanmean(yy(asc));
  thesave.stdyear_asc(iCnt)  = nanstd(yy(asc));
  thesave.meanmonth_asc(iCnt) = nanmean(mm(asc));
  thesave.stdmonth_asc(iCnt)  = nanstd(mm(asc));
  thesave.meanday_asc(iCnt) = nanmean(dd(asc));
  thesave.stdday_asc(iCnt)  = nanstd(dd(asc));
  thesave.meanhour_asc(iCnt) = nanmean(hh(asc));
  thesave.stdhour_asc(iCnt)  = nanstd(hh(asc));
  thesave.meantai93_asc(iCnt) = nanmean(s.tai93(asc));
  thesave.stdtai93_asc(iCnt)  = nanstd(s.tai93(asc));
  thesave.meansolzen_asc(iCnt) = nanmean(s.sol_zen(asc));
  thesave.stdsolzen_asc(iCnt)  = nanstd(s.sol_zen(asc));
  thesave.meansatzen_asc(iCnt) = nanmean(s.sat_zen(asc));
  thesave.stdsatzen_asc(iCnt)  = nanstd(s.sat_zen(asc));
  thesave.mean_rad_asc(iCnt,:) = nanmean(s.rad(:,asc),2);
  thesave.std_rad_asc(iCnt,:)  = nanstd(s.rad(:,asc),0,2);    
  X = rad2bt(1231,s.rad(1520,asc)); Y = quantile(X,quants);
  thesave.max1231_asc(iCnt) = max(X);
  thesave.min1231_asc(iCnt) = min(X);
  thesave.DCC1231_asc(iCnt) = length(find(X < 220));
  thesave.hist_asc(iCnt,:) = histc(X,dbt)/length(X);
  for qq = 1 : length(quants)-1
    if qq <  length(quants)-1
      Z = find(X >= Y(qq) & X < Y(qq+1));
    else
      Z = find(X >= Y(qq) & X <= Y(qq+1));
      Z = find(X >= Y(qq));
    end
    thesave.quantile1231_asc(iCnt,qq) = Y(qq);
    thesave.count_quantile1231_asc(iCnt,qq) = length(Z);
    if length(Z) > 2
      thesave.rad_asc(iCnt,qq,:) = nanmean(s.rad(:,asc(Z)),2);   
      thesave.satzen_quantile1231_asc(iCnt,qq) = nanmean(s.sat_zen(asc(Z)));
      thesave.solzen_quantile1231_asc(iCnt,qq) = nanmean(s.sol_zen(asc(Z)));
    else
      thesave.rad_asc(iCnt,qq,:) = s.rad(:,asc(Z));   
      thesave.satzen_quantile1231_asc(iCnt,qq) = s.sat_zen(asc(Z));
      thesave.solzen_quantile1231_asc(iCnt,qq) = s.sol_zen(asc(Z));
    end
  end
     
  desc = find(s.asc_flag(ianpts) == 68);  
  thesave.count_desc(iCnt) = length(desc);
  thesave.lat_desc(iCnt)  = nanmean(s.lat(desc));
  thesave.lon_desc(iCnt)  = nanmean(s.lon(desc));
  thesave.meanyear_desc(iCnt) = nanmean(yy(desc));
  thesave.stdyear_desc(iCnt)  = nanstd(yy(desc));
  thesave.meanmonth_desc(iCnt) = nanmean(mm(desc));
  thesave.stdmonth_desc(iCnt)  = nanstd(mm(desc));
  thesave.meanday_desc(iCnt) = nanmean(dd(desc));
  thesave.stdday_desc(iCnt)  = nanstd(dd(desc));
  thesave.meanhour_desc(iCnt) = nanmean(hh(desc));
  thesave.stdhour_desc(iCnt)  = nanstd(hh(desc));
  thesave.meantai93_desc(iCnt) = nanmean(s.tai93(desc));
  thesave.stdtai93_desc(iCnt)  = nanstd(s.tai93(desc));
  thesave.meansolzen_desc(iCnt) = nanmean(s.sol_zen(desc));
  thesave.stdsolzen_desc(iCnt)  = nanstd(s.sol_zen(desc));
  thesave.meansatzen_desc(iCnt) = nanmean(s.sat_zen(desc));
  thesave.stdsatzen_desc(iCnt)  = nanstd(s.sat_zen(desc));
  thesave.mean_rad_desc(iCnt,:) = nanmean(s.rad(:,desc),2);
  thesave.std_rad_desc(iCnt,:)  = nanstd(s.rad(:,desc),0,2);
  X = rad2bt(1231,s.rad(1520,desc)); Y = quantile(X,quants);
  thesave.max1231_desc(iCnt) = max(X);
  thesave.min1231_desc(iCnt) = min(X);
  thesave.DCC1231_desc(iCnt) = length(find(X < 220));
  thesave.hist_desc(iCnt,:) = histc(X,dbt)/length(X);

  for qq = 1 : length(quants)-1

    select_Zdata_based_on_iQAX_and_qq %%%% <<<<<<<<<<<<<<<<<<<<< this is the selector >>>>>>>>>>>>>>>>>>>>>>>>

    thesave.quantile1231_desc(iCnt,qq) = Y(qq);
    thesave.count_quantile1231_desc(iCnt,qq) = length(Z);
    if length(Z) > 2
      thesave.rad_desc(iCnt,qq,:) = nanmean(s.rad(:,desc(Z)),2);   
      thesave.satzen_quantile1231_desc(iCnt,qq) = nanmean(s.sat_zen(desc(Z)));
      thesave.solzen_quantile1231_desc(iCnt,qq) = nanmean(s.sol_zen(desc(Z)));
    else
      thesave.rad_desc(iCnt,qq,:) = s.rad(:,desc(Z));   
      thesave.satzen_quantile1231_desc(iCnt,qq) = s.sat_zen(desc(Z));
      thesave.solzen_quantile1231_desc(iCnt,qq) = s.sol_zen(desc(Z));
    end
  end

  if mod(iCnt,25) == 0
    figure(1); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meansolzen_desc); colormap jet; title('desc solzen')
    figure(2); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meansolzen_desc); colormap jet; title('desc solzen')
    figure(3); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meanhour_desc); colormap jet; title('desc hh UTC')
    figure(4); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meanhour_desc); colormap jet; title('desc hh UTC')
%    figure(5); scatter_coast(thesave.lon,thesave.lat_asc,50,thesave.stdhour_asc); colormap jet; title('std asc hh UTC')
%    figure(6); scatter_coast(thesave.lon,thesave.lat_asc,50,thesave.stdhour_desc); colormap jet; title('std desc hh UTC')
    pause(0.1);
  end
end

toc

wnum = s.wnum;
h2645 = load('/home/sergio/MATLABCODE/CRODGERS_FAST_CLOUD/h2645structure.mat');
wnum = h2645.h.vchan;

iSave = +1;
if iSave > 0
  %%% DATAObsStats_StartSept2002 is where we keep our Howard Obs stats
  %% ls DATA_StartSept2002/LatBin01 -- summary_latbin_01_lonbin_01.rtp to summary_latbin_01_lonbin_72.rtp
  
  %{
  for junkLat = 1 : 64
    mker = ['!mkdir ../DATAObsStats_StartSept2002/LatBin' num2str(junkLat,'%02d') '/'];
    eval(mker);
    for junkLon = 1 : 72
      mker = ['!mkdir ../DATAObsStats_StartSept2002/LatBin' num2str(junkLat,'%02d') '/LonBin' num2str(junkLon,'%02d') ];
      eval(mker)
    end
  end
  %}

  %% obviously not needed do_the_save_howard_16daytimesetps_2013_raw_griddedV2(date_stamp,thesave,dbt,quants,wnum);
  
  do_the_save_howard_16daytimesetps_2013_raw_griddedV2_alltimestep(date_stamp,thesave,dbt,quants,wnum,iQAX);
end

