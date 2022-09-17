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

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
%JOB = 100
%JOB = 457
%JOB = 396 %% this one had a few NaNs and was not being done, did a fix 2022/09/16, but this might cause trouble in trends

%% 2013_s237 to 2013_s259
%% 2015_s283
date_stamp = ['2015_s283'];   %% example

hugedir = dir('/asl/isilon/airs/tile_test7/');  %% 417 timesteps till Nov 2020
hugedir = dir('/asl/isilon/airs/tile_test7/');  %% 433 timesteps till Nov 2021
hugedir = dir('/asl/isilon/airs/tile_test7/');  %% 457 timesteps till Nov 2020

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

disp('looping over 64 latbins .....')
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

    thedir = dir([fdirIN '/stats_data_' date_stamp '.mat']);
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
  disp('have already made all 4608 files for this timestep');
  return
else
  disp('humph .. files not made, the show must go on!!!')
end

%%%%%%%%%%%%%%%%%%%%%%%%%

tic 
thesave = struct;
thesave.iii = nan(1,4608);
thesave.jjj = nan(1,4608);

thesave.count_asc = nan(1,4608);
thesave.lat_asc = nan(1,4608);
thesave.lon_asc = nan(1,4608);
thesave.meansolzen_asc = nan(1,4608);
thesave.stdsolzen_asc  = nan(1,4608);
thesave.meansatzen_asc = nan(1,4608);
thesave.stdsatzen_asc  = nan(1,4608);
thesave.meanyear_asc = nan(1,4608);
thesave.stdyear_asc  = nan(1,4608);
thesave.meanmonth_asc = nan(1,4608);
thesave.stdmonth_asc  = nan(1,4608);
thesave.meanday_asc = nan(1,4608);
thesave.stdday_asc  = nan(1,4608);
thesave.meanhour_asc  = nan(1,4608);
thesave.stdhour_asc  = nan(1,4608);
thesave.meantai93_asc = nan(1,4608);
thesave.stdtai93_asc  = nan(1,4608);
thesave.meanrad_asc = nan(4608,2645);
thesave.stdrad_asc  = nan(4608,2645);
thesave.max1231_asc = nan(1,4608);
thesave.min1231_asc = nan(1,4608);
thesave.DCC1231_asc = nan(1,4608);
thesave.hist_asc = nan(4608,161);
thesave.quantile1231_asc = nan(4608,16);
thesave.rad_asc = nan(4608,16,2645);
thesave.count_quantile1231_asc = nan(4608,16);
thesave.satzen_quantile1231_asc = nan(4608,16);
thesave.solzen_quantile1231_asc = nan(4608,16);

thesave.count_desc = nan(1,4608);
thesave.lat_desc = nan(1,4608);
thesave.lon_desc = nan(1,4608);
thesave.meansolzen_desc = nan(1,4608);
thesave.stdsolzen_desc  = nan(1,4608);
thesave.meansatzen_desc = nan(1,4608);
thesave.stdsatzen_desc  = nan(1,4608);
thesave.meanyear_desc = nan(1,4608);
thesave.stdyear_desc  = nan(1,4608);
thesave.meanmonth_desc = nan(1,4608);
thesave.stdmonth_desc  = nan(1,4608);
thesave.meanday_desc = nan(1,4608);
thesave.stdday_desc  = nan(1,4608);
thesave.meanhour_desc  = nan(1,4608);
thesave.stdhour_desc  = nan(1,4608);
thesave.meantai93_desc = nan(1,4608);
thesave.stdtai93_desc  = nan(1,4608);
thesave.meanrad_desc = nan(4608,2645);
thesave.stdrad_desc  = nan(4608,2645);
thesave.max1231_desc = nan(1,4608);
thesave.min1231_descc = nan(1,4608);
thesave.DCC1231_desc = nan(1,4608);
thesave.hist_desc = nan(4608,161);
thesave.quantile1231_desc = nan(4608,16);
thesave.rad_desc = nan(4608,16,2645);
thesave.count_quantile1231_desc = nan(4608,16);
thesave.satzen_quantile1231_desc = nan(4608,16);
thesave.solzen_quantile1231_desc = nan(4608,16);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fn = ['/asl/isilon/airs/tile_test7/' date_stamp '/N00p00/tile_' date_stamp '_N00p00_E000p00.nc'];
[s, a] = read_netcdf_h5(fn);

ianpts = 1:s.total_obs;
scatter(s.lon(ianpts),s.lat(ianpts),1,s.asc_flag(ianpts)); colorbar
plot(double(s.sol_zen(ianpts)),s.asc_flag(ianpts))

[yy,mm,dd,hh] = tai2utcSergio(s.tai93(ianpts)+offset1958_to_1993);
plot(hh,double(s.sol_zen(ianpts)),'o'); xlabel('hh'); ylabel('Solzen')

quants = [0 0.01 0.02 0.03 0.04 0.05 0.10 0.25 0.50 0.75 0.9 0.95 0.96 0.97 0.98 0.99 1.00];

pause(1)
dbt = 180 : 1 : 340;
iCnt = 0;
thedir0 = dir(['/asl/isilon/airs/tile_test7/' date_stamp '/']);
for iii = 3 : length(thedir0)
  dirdirname = ['/asl/isilon/airs/tile_test7/' date_stamp '/' thedir0(iii).name];
  dirx = dir([dirdirname '/*.nc']);
  for jjj = 1 : length(dirx)
    fname = [dirdirname '/' dirx(jjj).name];
    iCnt = iCnt + 1;
    thesave.fname{iCnt} = fname;

    fprintf(1,'%4i %4i %4i %s \n',iii-2,jjj,iCnt,fname);
 
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
      if length(Z) >= 2
        thesave.rad_asc(iCnt,qq,:) = nanmean(s.rad(:,asc(Z)),2);   
        thesave.satzen_quantile1231_asc(iCnt,qq) = nanmean(s.sat_zen(asc(Z)));
        thesave.solzen_quantile1231_asc(iCnt,qq) = nanmean(s.sol_zen(asc(Z)));
      elseif length(Z) == 1
        thesave.rad_asc(iCnt,qq,:) = s.rad(:,asc(Z));   
        thesave.satzen_quantile1231_asc(iCnt,qq) = s.sat_zen(asc(Z));
        thesave.solzen_quantile1231_asc(iCnt,qq) = s.sol_zen(asc(Z));
      elseif length(Z) == 0
        thesave.rad_asc(iCnt,qq,:) = NaN;
        thesave.satzen_quantile1231_asc(iCnt,qq) = NaN;
        thesave.solzen_quantile1231_asc(iCnt,qq) = NaN;
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
      if qq <  length(quants)-1
        Z = find(X >= Y(qq) & X < Y(qq+1));
      else
        Z = find(X >= Y(qq) & X <= Y(qq+1));
        Z = find(X >= Y(qq));
      end
      thesave.quantile1231_desc(iCnt,qq) = Y(qq);
      thesave.count_quantile1231_desc(iCnt,qq) = length(Z);
      if length(Z) >= 2
        thesave.rad_desc(iCnt,qq,:) = nanmean(s.rad(:,desc(Z)),2);   
        thesave.satzen_quantile1231_desc(iCnt,qq) = nanmean(s.sat_zen(desc(Z)));
        thesave.solzen_quantile1231_desc(iCnt,qq) = nanmean(s.sol_zen(desc(Z)));
      elseif length(Z) == 1
        thesave.rad_desc(iCnt,qq,:) = s.rad(:,desc(Z));   
        thesave.satzen_quantile1231_desc(iCnt,qq) = s.sat_zen(desc(Z));
        thesave.solzen_quantile1231_desc(iCnt,qq) = s.sol_zen(desc(Z));
      elseif length(Z) == 0
        thesave.rad_desc(iCnt,qq,:) = NaN;
        thesave.satzen_quantile1231_desc(iCnt,qq) = NaN;
        thesave.solzen_quantile1231_desc(iCnt,qq) = NaN;
      end
    end
  end

  if mod(iCnt,72) == 0
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
  do_the_save_howard_16daytimesetps_2013_raw_griddedV2(date_stamp,thesave,dbt,quants,wnum);
end

disp('since these were incorrect LatBinJJ/LonBinII .. now run loop_make_correct_timeseriesV2.m')
disp('since these were incorrect LatBinJJ/LonBinII .. now run loop_make_correct_timeseriesV2.m')
disp('since these were incorrect LatBinJJ/LonBinII .. now run loop_make_correct_timeseriesV2.m')

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meansolzen_desc); colormap jet; title('desc solzen')
figure(2); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meansolzen_desc); colormap jet; title('desc solzen')
figure(3); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meanhour_desc); colormap jet; title('desc hh UTC')
figure(4); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meanhour_desc); colormap jet; title('desc hh UTC')
%figure(5); scatter_coast(thesave.lon,thesave.lat_desc,50,thesave.stdhour_desc); colormap jet; title('std desc hh UTC')
%figure(6); scatter_coast(thesave.lon,thesave.lat_desc,50,thesave.stdhour_desc); colormap jet; title('std desc hh UTC')

figure(5); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.max1231_desc); colormap jet; title('max 1231')
figure(6); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,rad2bt(1231,thesave.mean_rad_desc(:,1520))); colormap jet; title('mean 1231')
figure(7); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.max1231_desc'-rad2bt(1231,thesave.mean_rad_desc(:,1520))); colormap jet; title('max-mean')
figure(8); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,rad2bt(1231,thesave.rad_desc(:,16,1520))); colormap jet; title('99-100 percetile 1231')

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
