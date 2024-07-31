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

iVers = 1;  %% use JOB together with "notdonetxt" generated by NNN<loop_make_correct_timeseriesV2.m>NNN   YYY<driver_loop_checkprogress_timeseries.m>YYY
iVers = 0;  %% use JOB together with hugedir = dir('/asl/isilon/airs/tile_test7/');

%% JOB = 1 * Nyears*23  :::  recall there are 23 timesteps per year, so in 2022/08/31 there should be 23 x 20 = 460 timesteps total
%% JOB = 1 * Nyears*23  :::  recall there are 23 timesteps per year, so in 2023/08/31 there should be 23 x 21 = 483 timesteps total
JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
if length(JOB) == 0
  JOB = 458;  %% last one done to 2022/08

  JOB = 479;  %% last one done to 2023/07
  JOB = 487;  %% last one done to 2023/12

  JOB = 498;  %% last one done to 2024/06
  JOB = 504;  %% last one done to 2024/08
end

%JOB = 6
%JOB = 457
%JOB = 396 %% this one had a few NaNs and was not being done, did a fix 2022/09/16, but this might cause trouble in trends

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% input  dir = /asl/isilon/airs/tile_test7/HowardsTIlingMap, this could be corrected eg using  x = translator_wrong2correct(JOB);
%% output dir = eg ../DATAObsStats_StartSept2002/LatBin01/LonBin32/iQAX_3_stats_data_2015_s288.mat

%% 2013_s237 to 2013_s259
%% 2015_s283
date_stamp = ['2015_s283'];   %% example

hugedir = dir('/asl/isilon/airs/tile_test7/');  %% 417 timesteps till Nov 2020
hugedir = dir('/asl/isilon/airs/tile_test7/');  %% 433 timesteps till Sep 2021
hugedir = dir('/asl/isilon/airs/tile_test7/');  %% 457 timesteps till Sep 2022
hugedir = dir('/asl/isilon/airs/tile_test7/');  %% 480 timesteps till Sep 2023

iaFound = zeros(1,600);
for ii = 3 : length(hugedir)
  junk = hugedir(ii).name;
  junk = str2num(junk(end-2:end));
  iaFound(junk) = 1;
end
junk = find(iaFound == 1); junk = max(junk); maxN = junk; 
  fprintf(1,'max(iaFound) = %3i so should do "kleenslurm; sbatch             --array=430-%3i  sergio_matlab_jobB.sbatch 10" \n',junk,junk+2);

disp('these timesteps are not found : '); junk = find(iaFound(1:junk) == 0)
  iTimeStepNotFound = 0;
  iTimeStepNotFound = length(junk);
fprintf(1,'so should only find %3i Sergio processed files \n',maxN - iTimeStepNotFound);
disp(' ' )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dbt = 180 : 1 : 340;
set_iQAX

if iVers == 0
  JOB = JOB + 2 - iTimeStepNotFound;  %% because first two are '.' and '..'
elseif iVers == 1
  disp('make sure you have run driver_loop_checkprogress_timeseries before this')
  disp('make sure you have run driver_loop_checkprogress_timeseries before this')
  disp('make sure you have run driver_loop_checkprogress_timeseries before this')
  notdone = load('notdone.txt');  %% this already has an offset of +2   .... 
  JOB = notdone(JOB);
end

date_stamp = hugedir(JOB).name;
fprintf(1,'JOB = %4i date_stamp = %s \n',JOB,date_stamp);
%error('kjskjs')
%%%%%%%%%%%%%%%%%%%%%%%%%
%% check to see if 64*72 files have been made for that date_stamp

disp('INITIAL CHECK : HAS ANYTHING BEEN MADE???? looping over 64 latbins .....')
numdone = zeros(72,64);
for jj = 1 : 64      %% latitude
  if mod(jj,10) == 0
    fprintf(1,'+')
  else
    fprintf(1,'.');
  end

  for ii = 1 : 72    %% longitude
    JOB = (jj-1)*72 + ii;

    %% x = translator_wrong2correct(JOB);  don't need this since we are not translating
    fdirIN  = ['../DATAObsStats_StartSept2002/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];

    iDebug = -1;
    if iDebug > 0
      thedirjunk = dir([fdirIN '/*.mat']);
      iaFound2 = zeros(1,600);
      for ii2 = 1 : length(thedirjunk)
        junk = thedirjunk(ii2).name;
        junk = junk(1:end-4);
        junk = str2num(junk(end-2:end));
        iaFound2(junk) = 1;
      end
      junk = find(iaFound2 == 1); junk = max(junk); maxN2 = junk; 
      disp('these timesteps are not found : '); junk = find(iaFound2(1:junk) == 0)
        iTimeStepNotFound2 = 0;
        iTimeStepNotFound2 = length(junk);

      X = maxN - iTimeStepNotFound;
      Y = length(thedirjunk);
      str = ['LatBin ' num2str(jj,'%02i') ' LonBin ' num2str(ii,'%02i') ' expects ' num2str(X,'%03i') ' files and found ' num2str(Y,'%03i') ' files'];
      fprintf(1,'%s \n',str);
    end

    if iQAX == 1
      QAXdir = ['/stats_data_' date_stamp '.mat'];
    elseif iQAX == 3
      QAXdir = ['/iQAX_3_stats_data_' date_stamp '.mat'];
    elseif iQAX == 4
      QAXdir = ['/iQAX_4_stats_data_' date_stamp '.mat'];
    end

    thedir = dir([fdirIN QAXdir]);
    if length(thedir) == 1
      if thedir.bytes > 0           
        numdone(ii,jj) = 1;    
      end
    end
  end        
end
fprintf(1,'\n');
fprintf(1,'sum(numdone(:)) = %8i ',sum(numdone(:)))

if sum(numdone(:)) == 72*64
  fprintf(1,'have already made all 4608 files for this timestep %3i = %s, see eg %s  \n',JOB,date_stamp,[fdirIN QAXdir])
  error('this timestep already done!!!')
  return
else
  disp('humph .. files not made, the show must go on!!!')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ls /asl/isilon/airs/tile_test7/ | wc -l                 = 482 TIMESTAMPS
%% ls /asl/isilon/airs/tile_test7/2008_s142 | wc -l        = 064 LATBINS
%% ls /asl/isilon/airs/tile_test7/2008_s142/N52p25 | wc -l = 072 LONBINS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(1,'some or all files not made for timestep %3i = %s .. so reading them in SLOWLY \n',JOB,date_stamp);

tic
%% most of thesave fields = 1 x N bins eg thesave.meansolzen_asc, thesave.meanyear_asc etc        = 1 x N  
%% some are size length(quants)-1      eg thesave.quantile1231_asc,thesave.count_quantile1231_asc = N x length(quants)-1
%% some are size N,length(dbt))        eg thesave.hist_asc                                        = N x length(dbt)
%%   quite big one                     eg thesave.meanrad_asc                                     = N x 2645
%%   big one                           eg thesave.rad_asc                                         = N x length(quants)-1 x 2645
thesave = make_blank_thesave_struct(quants,dbt,4608);
  
fn = ['/asl/isilon/airs/tile_test7/' date_stamp '/N00p00/tile_' date_stamp '_N00p00_E000p00.nc'];
[s, a] = read_netcdf_h5(fn);

ianpts = 1:s.total_obs;
scatter(s.lon(ianpts),s.lat(ianpts),1,s.asc_flag(ianpts)); colorbar
plot(double(s.sol_zen(ianpts)),s.asc_flag(ianpts))

[yy,mm,dd,hh] = tai2utcSergio(s.tai93(ianpts)+offset1958_to_1993);
plot(hh,double(s.sol_zen(ianpts)),'o'); xlabel('hh'); ylabel('Solzen')

%% OUTER  LOOP      450 TIMESTEPS --> 1 FIXED TIMESTEP = JOB
%%   MIDDLE LOOP    064 LATBINS
%%     INNER  LOOP  072 LONBINS

pause(1)

iCnt = 0;
thedir0 = dir(['/asl/isilon/airs/tile_test7/' date_stamp '/']);                    %%%% 450 timesteps
for iii = 3 : length(thedir0)                                    
  dirdirname = ['/asl/isilon/airs/tile_test7/' date_stamp '/' thedir0(iii).name];  %%%% 64 latbins
  dirx = dir([dirdirname '/*.nc']);
  for jjj = 1 : length(dirx)
    fname = [dirdirname '/' dirx(jjj).name];                                       %%%% 72 lonbins
    iCnt = iCnt + 1;                                                               %%%% so iCnt == 1 -- 4608
    thesave.fname{iCnt} = fname;

    fprintf(1,'%4i %4i %4i %s \n',iii-2,jjj,iCnt,fname);

    thesave.iii(iCnt) = iii-2;  %% so this is LAT subdir                           ... I really should have called this jjj
    thesave.jjj(iCnt) = jjj;    %% and now we are reading the individual LON files ... I really should have called this iii
    thesave.fname{iCnt} = fname;
 
    [s, a] = read_netcdf_h5(fname);
  
    ianpts = 1:s.total_obs;
    %scatter(s.lon(ianpts),s.lat(ianpts),1,s.asc_flag(ianpts)); colorbar
    %plot(double(s.sol_zen(ianpts)),s.asc_flag(ianpts))

    [yy,mm,dd,hh] = tai2utcSergio(s.tai93(ianpts)+offset1958_to_1993);
    separate_s_into_sc_desc_quants
  end
  
  if mod(iCnt,72) == 0
    figure(1); clf; scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meansolzen_desc); colormap jet; title('desc solzen')
    figure(2); clf; scatter_coast(thesave.lon_asc,thesave.lat_asc,50,thesave.meansolzen_asc);    colormap jet; title('asc solzen')
    figure(3); clf; scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meanhour_desc);   colormap jet; title('desc hh UTC')
    figure(4); clf; scatter_coast(thesave.lon_asc,thesave.lat_asc,50,thesave.meanhour_asc);      colormap jet; title('asc hh UTC')
    figure(5); clf; scatter_coast(thesave.lon_asc,thesave.lat_asc,50,thesave.stdhour_desc);      colormap jet; title('std desc hh UTC')
    figure(6); clf; scatter_coast(thesave.lon_desc,thesave.lat_asc,50,thesave.stdhour_asc);      colormap jet; title('std asc hh UTC')
    pause(0.1);
  end
end

toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

wnum = s.wnum;
h2645 = load('/home/sergio/MATLABCODE/CRODGERS_FAST_CLOUD/h2645structure.mat');
wnum = h2645.h.vchan;

iSave = +1;
if iSave > 0
  %saver = ['save stats_howard_16daytimesetps_' date_stamp '_raw_gridded.mat thesave dbt quants wnum'];
  %eval(saver);

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

  %% do_the_save_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m --> do_the_save_howard_16daytimesetps_2013_raw_griddedV2
  do_the_save_howard_16daytimesetps_2013_raw_griddedV2(date_stamp,thesave,dbt,quants,wnum,iQAX);

end

disp('these were incorrect LatBinJJ/LonBinII .. now run cluster_loop_make_correct_timeseriesV2.m .. reads 72 lonbins x N TIMSTEPS, cats everything together, for output into correct LATBIN file ')
disp('these were incorrect LatBinJJ/LonBinII .. now run cluster_loop_make_correct_timeseriesV2.m .. reads 72 lonbins x N TIMSTEPS, cats everything together, for output into correct LATBIN file ')
disp('these were incorrect LatBinJJ/LonBinII .. now run cluster_loop_make_correct_timeseriesV2.m .. reads 72 lonbins x N TIMSTEPS, cats everything together, for output into correct LATBIN file ')

%{
%% thesave in this code is 
%%   most of thesave fields = 1 x 4608 bins eg thesave.meansolzen_asc, thesave.meanyear_asc etc     = 1 x 4608  
%%   some are size length(quants)-1      eg thesave.quantile1231_asc,thesave.count_quantile1231_asc = 4608 x length(quants)-1
%%   some are size 4608,length(dbt))     eg thesave.hist_asc                                        = 4608 x length(dbt)
%%     quite big one                     eg thesave.meanrad_asc                                     = 4608 x 2645
%%     big one                           eg thesave.rad_asc                                         = 4608 x length(quants)-1 x 2645
%% but the saving routine breaks them into separate 4608 files so eg you get
%%  ../DATAObsStats_StartSept2002/LatBin32/LonBin36/iQAX_3_stats_data_2020_s402.mat : 1x1 for lat_asc,lon_asc,mean1231_asc and then mean_rad_sc = 1x2645, hist_asc = 1x 161 and rad_quantile_asc = 2645 x 5
%%
%% so after cluster_loop_make_correct_timeseriesV2.m you get eg ../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin32/iQAX_3_summarystats_LatBin32_LonBin_1_72_timesetps_001_455_V1.mat
>>   load ../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin32/iQAX_3_summarystats_LatBin32_LonBin_1_72_timesetps_001_455_V1.mat
>>   whos
  Name             Size              Bytes  Class     Attributes

  dccBT1231       72x457            263232  double
  dd              72x457            263232  double
  maxBT1231       72x457            263232  double
  meanBT1231      72x457            263232  double
  minBT1231       72x457            263232  double
  mm              72x457            263232  double
  rlat            72x457            263232  double
  rlon            72x457            263232  double
  yy              72x457            263232  double

%% and also load ../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin32/LonBin36/iQAX_3_summarystats_LatBin32_LonBin36_timesetps_001_457_V1.mat
%% this BIG ONE BIG LEWANDOWSKI
>> whos *asc
  Name                           Size                   Bytes  Class     Attributes

  cntDCCBT1231_asc               1x457                   3656  double
  count_asc                      1x457                   3656  double
  count_quantile1231_asc       457x5                    18280  double
  day_asc                        1x457                   3656  double
  hist1231_asc                 457x161                 588616  double
  hour_asc                       1x457                   3656  double
  lat_asc                        1x457                   3656  double
  lon_asc                        1x457                   3656  double
  maxBT1231_asc                  1x457                   3656  double
  meanBT1231_asc                 1x457                   1828  single
  meanBT_asc                   457x2645               4835060  single
  minBT1231_asc                  1x457                   3656  double
  month_asc                      1x457                   3656  double
  quantile1231_asc             457x5                    18280  double
  rad_quantile_asc             457x2645x5            48350600  double
  satzen_asc                     1x457                   3656  double
  satzen_quantile1231_asc      457x5                    18280  double
  solzen_asc                     1x457                   3656  double
  solzen_quantile1231_asc      457x5                    18280  double
  tai93_asc                      1x457                   3656  double
  year_asc                       1x457                   3656  double

%}

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1); clf; scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meansolzen_desc); colormap jet; title('desc solzen')
figure(2); clf; scatter_coast(thesave.lon_asc,thesave.lat_asc,50,thesave.meansolzen_asc);    colormap jet; title('asc solzen')
figure(3); clf; scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meanhour_desc);   colormap jet; title('desc hh UTC')
figure(4); clf; scatter_coast(thesave.lon_asc,thesave.lat_asc,50,thesave.meanhour_asc);      colormap jet; title('asc hh UTC')
%figure(5); clf; scatter_coast(thesave.lon,thesave.lat_desc,50,thesave.stdhour_desc); colormap jet; title('std desc hh UTC')
%figure(6); clf; scatter_coast(thesave.lon,thesave.lat_asc,50,thesave.stdhour_asc); colormap jet; title('std asc hh UTC')

figure(5); clf; scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.max1231_desc); colormap jet; title('max 1231')
figure(6); clf; scatter_coast(thesave.lon_desc,thesave.lat_desc,50,rad2bt(1231,thesave.mean_rad_desc(:,1520))); colormap jet; title('mean 1231')
figure(7); clf; scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.max1231_desc'-rad2bt(1231,thesave.mean_rad_desc(:,1520))); colormap jet; title('max-mean')
figure(8); clf; scatter_coast(thesave.lon_desc,thesave.lat_desc,50,rad2bt(1231,thesave.rad_desc(:,length(quants)-1,1520))); colormap jet; title('hottest percetile 1231')

figure(9); oo = find(thesave.lon_desc <= -175); plot(dbt,thesave.hist_desc(oo,:))
figure(9); oo = find(thesave.lon_desc <= -175); [Y,I] = sort(thesave.lat_desc(oo)); pcolor(thesave.lat_desc(oo(I)),dbt,log10(thesave.hist_desc(oo(I),:)'));
  colormap jet; colorbar; shading interp

figure(10); clf; pcolor(wnum,quants(2:end),rad2bt(wnum,squeeze(thesave.rad_desc(1,:,:))')'); shading flat; colorbar; xlabel('Wavnumber'); ylabel('Quantile'); colormap jet
figure(10); clf; pcolor(wnum,1-quants(2:end),rad2bt(wnum,squeeze(thesave.rad_desc(1,:,:))')'); shading flat; colorbar; xlabel('Wavnumber'); ylabel('1-Quantile'); colormap jet; set(gca,'yscale','log')
figure(11); clf; plot(wnum,rad2bt(wnum,squeeze(thesave.rad_desc(1,:,:))')'); shading flat; colorbar; xlabel('Wavnumber');
figure(11); clf; plot(wnum,diff(rad2bt(wnum,squeeze(thesave.rad_desc(1,:,:))')')); shading flat; colorbar; xlabel('Wavnumber');
figure(11); clf; plot(wnum,diff(rad2bt(wnum,squeeze(thesave.rad_desc(1,15:16,:))')')); shading flat; colorbar; xlabel('Wavnumber'); ylim([-1 +1])

%plot(thesave.lon_desc(oo))
%pcolor(thesave.lon_desc,thesave.lat_desc,10,thesave.count_desc)
