function [] = tile_fits_quantiles_anomalies(loni,lati,fdirpre,fnout,i16daysSteps,iQAX,stopdate,startdate,i16daysStepsX,iAllorSeason)
%%                                  1    2     3      4       6        [ 6     7       8          9             10      ])

xnargin = nargin;

%% copied from /home/strow/Work/Airs/Tiles/tile_fits.m

addpath ../Code_For_HowardObs_TimeSeries/Strow_Tiles
%% [bt_anom r_anom] = compute_anomaly(k,dtime,b,f,r);

if nargin < 5
  error('need 5 arguments loni,lati,fdirpre,fout,i16daysSteps [stopdate,startdate,i16daysStepsX] are optional')
end

if nargin == 5
  iQAX = 1;
  startdate = [2002 09 01];
  stopdate = [];
  i16daysStepsX = i16daysSteps;
  iAllorSeason = +1;
elseif nargin == 6
  startdate = [2002 09 01];
  stopdate = [];
  i16daysStepsX = i16daysSteps;
  iAllorSeason = +1;
elseif nargin == 7
  startdate = [2002 09 01];
  i16daysStepsX = i16daysSteps;
  iAllorSeason = +1;
elseif nargin == 8
  i16daysStepsX = i16daysSteps;
  iAllorSeason = +1;
elseif nargin == 9
  iAllorSeason = +1;
end

addpath /asl/matlib/aslutil
addpath /asl/matlib/time
addpath /home/strow/Matlab/Math

load_fairs

% loni = 40;
% lati = 1;

% % AIRS channel ID
% ch = 1520;

p = [-0.17 -0.15 -1.66  1.06];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(' ')
%% see eg ~/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries/clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m
hugedir = dir('/asl/isilon/airs/tile_test7/');  %% 417 timesteps till Nov 2020
hugedir = dir('/asl/isilon/airs/tile_test7/');  %% 433 timesteps till Nov 2021
hugedir = dir('/asl/isilon/airs/tile_test7/');  %% 457 timesteps till Nov 2020
disp('>>>>>>>> looking at /asl/isilon/airs/tile_test7/ ')

fprintf(1,'found %3i timesteps there \n',length(hugedir)-2); %% remember first two are . and ..

iaFound = zeros(1,600);
for ii = 3 : length(hugedir)
  junk = hugedir(ii).name;
  junk = str2num(junk(end-2:end));
  iaFound(junk) = 1;
end
junk = find(iaFound == 1); junk = max(junk); maxN = junk;
  fprintf(1,'max(iaFound) = %3i so should do "kleenslurm; sbatch             --array=430-%3i  sergio_matlab_jobB.sbatch 10" \n',junk,junk+2);

disp('these timesteps are not found : '); junk = find(iaFound(1:junk) == 0); iaNoData = junk
  iTimeStepNotFound = 0;             iaNoData = [];
  iTimeStepNotFound = length(junk);  iaNoData = junk;
  
fprintf(1,'so should only find %3i Sergio processed files \n',maxN - iTimeStepNotFound);
disp('>>>>>>>> looking at /asl/isilon/airs/tile_test7/ ')
disp(' ' )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iQAX == 1
  fn_summary = sprintf('LatBin%1$02d/LonBin%2$02d/summarystats_LatBin%1$02d_LonBin%2$02d_timesetps_001_%3$03d_V1.mat',lati,loni,i16daysSteps);
elseif iQAX == 3
  fn_summary = sprintf('LatBin%1$02d/LonBin%2$02d/iQAX_3_summarystats_LatBin%1$02d_LonBin%2$02d_timesetps_001_%3$03d_V1.mat',lati,loni,i16daysSteps);
end
fn_summary = fullfile(fdirpre,fn_summary);

if exist(fn_summary)
  fprintf(1,'tile_fits_quantiles.m :lati,loni = %2i %2i  loading  << %s >> with %3i i16daysSteps\n',lati,loni,fn_summary,i16daysSteps)
  d = load(fn_summary);
  if length(d.lat_asc) < i16daysSteps-iTimeStepNotFound
    [length(d.lat_asc) i16daysSteps]
    error('length(d.lat_asc) < i16daysSteps')
  end
else
  fprintf(1,'tile_fits_quantiles.m : lati,loni = %2i %2i  %s with %3i i16daysSteps DNE \n',lati,loni,fn_summary,i16daysSteps)
  error('stopppppp and look at eg ../Code_For_HowardObs_TimeSeries/cluster_loop_make_correct_timeseriesV3.m')
end

%mtime = tai2dtime(airs2tai(d.tai93_desc + offset1958_to_1993));
mtime = tai2dtime(airs2tai(d.tai93_desc)); 
dtime = datenum(mtime); 

% [mtime(1)]
% [d.tai93_desc(1)/1000 dtime(1)]
% which tai2dtime 
% which datenum 
% which airs2tai
% disp('1 ret to continue'); pause

% restoredefaultpath
% addpath /home/sergio/MATLABCODE/TIME
% addpath /home/sergio/MATLABCODE
% [yyjunk,mmjunk,ddjunk] = tai2utcSergio(d.tai93_desc + offset1958_to_1993);
% daysSince2002 = change2days(yyjunk,mmjunk,ddjunk,2002);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% see ../Code_For_HowardObs_TimeSeries/driver_fix_thedata_asc_desc_solzen_time_001_504_64x72.m -- which makes timestepsStartEnd_2002_09_to_2024_09.mat
%% see ../Code_For_HowardObs_TimeSeries/driver_fix_thedata_asc_desc_solzen_time_001_504_64x72.m -- which makes timestepsStartEnd_2002_09_to_2024_09.mat
%% see ../Code_For_HowardObs_TimeSeries/driver_fix_thedata_asc_desc_solzen_time_001_504_64x72.m -- which makes timestepsStartEnd_2002_09_to_2024_09.mat

disp(' timestep_notfound = ')
d.timestep_notfound
if length(setdiff(d.timestep_notfound,iaNoData)) > 0
  disp('>>>>>>>>>>>> oops length(setdiff(d.timestep_notfound,iaNoData)) > 0')
  disp('>>>>>>>>>>>> oops length(setdiff(d.timestep_notfound,iaNoData)) > 0')
  disp('>>>>>>>>>>>> oops length(setdiff(d.timestep_notfound,iaNoData)) > 0')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if xnargin > 6
  timeSE = load('../Code_For_HowardObs_TimeSeries/timestepsStartEnd_2002_09_to_2024_09.mat');
  rtimeS = utc2taiSergio(startdate(1),startdate(2),startdate(3),0.0001);
  rtimeE = utc2taiSergio(stopdate(1),stopdate(2),stopdate(3),24-0.0001);
  iaSE = find(timeSE.rtimeS >= rtimeS & timeSE.rtimeE <= rtimeE);
  if length(iaNoData) > 0
    iaSE = setdiff(iaSE,iaNoData);
  end
  fprintf(1,'taking into account %3i missing timesteps, anticipate %4i timesteps to be used \n',iTimeStepNotFound,length(iaSE));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%k_desc = d.count_desc./median(d.count_desc) > 0.98 & (mtime <= datetime(2015,8,28));
%k_asc = d.count_asc./median(d.count_asc) > 0.98 & (mtime <= datetime(2015,8,28));
if xnargin == 6
  fprintf(1,'  fitting entire data set \n')
  k_desc = d.count_desc./median(d.count_desc) > 0.98; % all data
  k_asc = d.count_asc./median(d.count_asc) > 0.98;    % all data

elseif xnargin == 7
  fprintf(1,'  fitting till and including %4i/%2i/%2i \n',stopdate)
  k_desc = d.count_desc./median(d.count_desc) > 0.98 & (mtime <= datetime(stopdate(1),stopdate(2),stopdate(3)));
  k_asc = d.count_asc./median(d.count_asc) > 0.98 & (mtime <= datetime(stopdate(1),stopdate(2),stopdate(3)));

  if length(k_desc) ~= length(iaSE)
    fprintf(1,'whoops 6A length(k_desc) ~= length(iaSE)  %3i %3i \n',length(k_desc),length(iaSE));
    error('please check');
  elseif length(k_asc) ~= length(iaSE)
    fprintf(1,'whoops 6B length(k_asc) ~= length(iaSE)  %3i %3i \n',length(k_asc),length(iaSE));
    error('please check');
  end
  %% passed the length test, now check the indices are the same
  if sum(reshape(k_desc,length(iaSE),1)-reshape(iaSE,length(iaSE),1)) ~= 0
    error('whoops 6C k_desc) ~= iaSE')
  elseif sum(reshape(k_asc,length(iaSE),1)-reshape(iaSE,length(iaSE),1)) ~= 0
    error('whoops 6C k_asc) ~= iaSE')
  end

elseif xnargin >= 8
  fprintf(1,'  fitting between and including both time end points %4i/%2i/%2i and %4i/%2i/%2i \n',startdate,stopdate)
  k_desc = find(d.count_desc./median(d.count_desc) > 0.98 & (mtime >= datetime(startdate(1),startdate(2),startdate(3)) & mtime <= datetime(stopdate(1),stopdate(2),stopdate(3))));
  k_asc  = find(d.count_asc./median(d.count_asc)   > 0.98 & (mtime >= datetime(startdate(1),startdate(2),startdate(3)) & mtime <= datetime(stopdate(1),stopdate(2),stopdate(3))));

  k_desc = find(d.count_desc./median(d.count_desc) > 0.98 & (dtime >= datenum(datetime(startdate(1),startdate(2),startdate(3))) & dtime <= datenum(datetime(stopdate(1),stopdate(2),stopdate(3)))));
  k_asc  = find(d.count_asc./median(d.count_asc)   > 0.98 & (dtime >= datenum(datetime(startdate(1),startdate(2),startdate(3))) & dtime <= datenum(datetime(stopdate(1),stopdate(2),stopdate(3)))));

  k_desc = find((dtime >= datenum(datetime(startdate(1),startdate(2),startdate(3))) & dtime <= datenum(datetime(stopdate(1),stopdate(2),stopdate(3)))));
  k_asc  = find((dtime >= datenum(datetime(startdate(1),startdate(2),startdate(3))) & dtime <= datenum(datetime(stopdate(1),stopdate(2),stopdate(3)))));

  damonth = month(dtime);
  if iAllorSeason == -1   
    %%% DJF
    k_desc = find((dtime >= datenum(datetime(startdate(1),startdate(2),startdate(3))) & dtime <= datenum(datetime(stopdate(1),stopdate(2),stopdate(3)))) & (month(dtime) == 12 | month(dtime) == 01 | month(dtime) == 02)); 
    k_asc  = find((dtime >= datenum(datetime(startdate(1),startdate(2),startdate(3))) & dtime <= datenum(datetime(stopdate(1),stopdate(2),stopdate(3)))) & (month(dtime) == 12 | month(dtime) == 01 | month(dtime) == 02));     
  elseif iAllorSeason == -2
    %%% MAM
    k_desc = find((dtime >= datenum(datetime(startdate(1),startdate(2),startdate(3))) & dtime <= datenum(datetime(stopdate(1),stopdate(2),stopdate(3)))) & (month(dtime) == 03 | month(dtime) == 04 | month(dtime) == 05)); 
    k_asc  = find((dtime >= datenum(datetime(startdate(1),startdate(2),startdate(3))) & dtime <= datenum(datetime(stopdate(1),stopdate(2),stopdate(3)))) & (month(dtime) == 03 | month(dtime) == 04 | month(dtime) == 05));     
  elseif iAllorSeason == -3
    %%% JJA
    k_desc = find((dtime >= datenum(datetime(startdate(1),startdate(2),startdate(3))) & dtime <= datenum(datetime(stopdate(1),stopdate(2),stopdate(3)))) & (month(dtime) == 06 | month(dtime) == 07 | month(dtime) == 08)); 
    k_asc  = find((dtime >= datenum(datetime(startdate(1),startdate(2),startdate(3))) & dtime <= datenum(datetime(stopdate(1),stopdate(2),stopdate(3)))) & (month(dtime) == 06 | month(dtime) == 07 | month(dtime) == 08));     
  elseif iAllorSeason == -4
    %%% SON
    k_desc = find((dtime >= datenum(datetime(startdate(1),startdate(2),startdate(3))) & dtime <= datenum(datetime(stopdate(1),stopdate(2),stopdate(3)))) & (month(dtime) == 09 | month(dtime) == 10 | month(dtime) == 11)); 
    k_asc  = find((dtime >= datenum(datetime(startdate(1),startdate(2),startdate(3))) & dtime <= datenum(datetime(stopdate(1),stopdate(2),stopdate(3)))) & (month(dtime) == 09 | month(dtime) == 10 | month(dtime) == 11));     
  end

  % mtime = tai2dtime(airs2tai(d.tai93_desc)); 
  % dtime = datenum(mtime); 
  % mtime(1)
  % [d.tai93_desc(1)/1000 dtime(1)]
  % which tai2dtime 
  % which datenum 
  % which airs2tai
  % disp('2 ret to continue'); pause
  % keyboard_nowindow

  if iAllorSeason > 0
    if length(k_desc) ~= length(iaSE) 
      fprintf(1,'whoops 7A length(k_desc) ~= length(iaSE)  %3i %3i \n',length(k_desc),length(iaSE));
      %% if off by 1 or 2, reset
      if abs(length(k_desc) - length(iaSE)) <= iTimeStepNotFound & ((k_desc(1) == iaSE(1)) | (k_desc(end) == iaSE(end)))
        disp('since lengths are only off by 1 or 2 reset k_desc')
        k_desc = iaSE;
      else
        error('please check');
      end
    end
    if length(k_asc) ~= length(iaSE) & iAllorSeason > 0
      fprintf(1,'whoops 7B length(k_asc) ~= length(iaSE)  %3i %3i \n',length(k_asc),length(iaSE));
      %% if off by 1 or 2, reset
      if abs(length(k_asc) - length(iaSE)) <= iTimeStepNotFound & ( (k_asc(1) == iaSE(1)) | (k_asc(end) == iaSE(end)))
        disp('since lengths are only off by 1 or 2 reset k_asc')
        k_asc = iaSE;
      else
        error('please check');
      end
    end
    %% passed the length test, now check the indices are the same
  
    if sum(reshape(k_desc,length(iaSE),1)-reshape(iaSE,length(iaSE),1)) ~= 0
      disp('whoops 7C k_desc) ~= iaSE, reset k_desc')
      k_desc = iaSE;
    end
    if sum(reshape(k_asc,length(iaSE),1)-reshape(iaSE,length(iaSE),1)) ~= 0
      disp('whoops 7C k_asc) ~= iaSE, reset k_asc')
      k_asc = iaSE;
    end
  end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iQAX == 1
  numQuant = 16;
elseif iQAX == 3
  numQuant = 5;
end

bt_anom_desc  = nan(numQuant,2645,length(k_desc));
rad_anom_desc = nan(numQuant,2645,length(k_desc));
bt_anom_asc   = nan(numQuant,2645,length(k_asc));
rad_anom_asc  = nan(numQuant,2645,length(k_asc));

if iQAX == 1
  qi1 = 12; qi2 = 16;
elseif iQAX == 3
  qi1 = 3; qi2 = 5;
end

clear damonth

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run off tsurf using bt1231/bt1228 regression for qi = 16;  

iNumSineCosCycles = 4;
if iAllorSeason < 0
  %% only DJF, MAM, JJA, SON
  iNumSineCosCycles = 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

warning off   
for qi = 1:numQuant
  fprintf(1,'qi = %2i of %2i \n',qi,numQuant);
  disp('  doing 2645 chans : + = 1000, . = 100')
  for ch = 1:2645
    if mod(ch,1000) == 0
      fprintf(1,'+')
    elseif mod(ch,100) == 0
      fprintf(1,'.')
    end
    % Desc
    r = squeeze(d.rad_quantile_desc(:,ch,qi));
    bt_desc(ch,qi) = nanmean(rad2bt(fairs(ch),squeeze(d.rad_quantile_desc(:,ch,qi))));
    [b_desc(ch,qi,:)     stats] = Math_tsfit_lin_robust(dtime(k_desc)-dtime(k_desc(1)),r(k_desc),iNumSineCosCycles);
    [bt_anom_desc(qi,ch,:) rad_anom_desc(qi,ch,:)] = compute_anomaly(k_desc,dtime,squeeze(b_desc(ch,qi,:)),fairs(ch),r);      
    %[boo roo] = compute_anomaly(k_desc,dtime,squeeze(b_desc(ch,qi,:)),fairs(ch),r);
    %plot(dtime(k_desc),roo,dtime(k_desc),r(k_desc)-mean(r(k_desc)))

    % Asc
    r = squeeze(d.rad_quantile_asc(:,ch,qi));
    bt_asc(ch,qi) = nanmean(rad2bt(fairs(ch),squeeze(d.rad_quantile_asc(:,ch,qi))));
    [b_asc(ch,qi,:) stats] = Math_tsfit_lin_robust(dtime(k_asc)-dtime(k_asc(1)),r(k_asc),iNumSineCosCycles);
    [bt_anom_asc(qi,ch,:) rad_anom_asc(qi,ch,:)] = compute_anomaly(k_asc,dtime,squeeze(b_asc(ch,qi,:)),fairs(ch),r);      
    %[boo roo] = compute_anomaly(k_asc,dtime,squeeze(b_asc(ch,qi,:)),fairs(ch),r);
    %plot(dtime(k_asc),roo,dtime(k_asc),r(k_asc)-mean(r(k_asc)))
  end
  fprintf(1,'\n');

end
warning on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get rid of variables I don't want to save
quants = d.quants; % want to save these

clear d r deriv f lagc qi stats ans ch l 

% Create output dir if needed
%fout_dir = sprintf('LatBin%1$02d/LonBin%2$02d',lati,loni);
%fout_dir = fullfile(fdirpre_out,fout_dir)
%if exist(fout_dir) == 0
%   mkdir(fout_dir)
%end

rtime = mattime2rtime(dtime);
[yy mm dd hh] = tai2utcSergio(rtime);

rtime_asc  = rtime(k_asc);
rtime_desc = rtime(k_desc);
[yy_desc mm_desc dd_desc hh_desc] = tai2utcSergio(rtime(k_desc));
[yy_asc mm_asc dd_asc hh_asc] = tai2utcSergio(rtime(k_asc));

if ~exist(fnout)
  fprintf(1,'saving to %s \n',fnout);
  saver = ['save -v7.3 ' fnout ' bt_anom* rad_anom* rtime* yy_* mm_* dd_* hh_* bt_desc bt_asc b_desc b_asc'];
  eval(saver);
else
  fprintf(1,'oops %s already exists \n',fnout)
  fprintf(1,'saving to %s \n',fnout);
  saver = ['save -v7.3 ' fnout ' bt_anom* rad_anom* rtime* yy_* mm_* dd_* hh_* bt_desc bt_asc b_desc b_asc'];
  eval(saver);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
load ../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin31/LonBin62/iQAX_3_fits_LonBin62_LatBin31_V1_200200090001_202200080031_Anomaly_TimeStepsX457.mat
d2002 = change2days(yy_desc,mm_desc,dd_desc,2002);
plot(d2002,squeeze(bt_anom_desc(3,1520,:)))
plot(d2002/265+2002,squeeze(bt_anom_desc(3,1520,:)))
plot(d2002/365+2002,squeeze(bt_anom_desc(3,1520,:)))
plot(d2002/365+2002,squeeze(bt_anom_desc(3,1520,:))); xlim([2002 2023])
%}
