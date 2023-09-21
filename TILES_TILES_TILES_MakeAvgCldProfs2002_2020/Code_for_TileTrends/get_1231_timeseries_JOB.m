function [y,ySKT,iaTimeStepsFound] = get_1231_timeseries_JOB(loni,lati,iQAX,stopdate,startdate,ia16daysSteps,fdirpre,AorD,iChanID);

addpath /asl/matlib/aslutil
addpath /asl/matlib/time
addpath /home/strow/Matlab/Math

i16daysSteps = length(ia16daysSteps);

load_fairs

p = [-0.17 -0.15 -1.66  1.06];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%disp(' ')
%% see eg ~/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries/clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m
hugedir = dir('/asl/isilon/airs/tile_test7/');  %% 417 timesteps till Nov 2020
hugedir = dir('/asl/isilon/airs/tile_test7/');  %% 433 timesteps till Nov 2021
hugedir = dir('/asl/isilon/airs/tile_test7/');  %% 457 timesteps till Nov 2020
%disp('>>>>>>>> looking at /asl/isilon/airs/tile_test7/ ')

%fprintf(1,'found %3i timesteps there \n',length(hugedir)-2); %% remember first two are . and ..

iaFound = zeros(1,length(hugedir)-2);
for ii = 3 : length(hugedir)
  junk = hugedir(ii).name;
  junk = str2num(junk(end-2:end));
  iaFound(junk) = 1;
end
junk = find(iaFound == 1); junk = max(junk); maxN = junk;
%  fprintf(1,'max(iaFound) = %3i so should do "kleenslurm; sbatch             --array=430-%3i  sergio_matlab_jobB.sbatch 10" \n',junk,junk+2);

%disp('these timesteps are not found : '); junk = find(iaFound(1:junk) == 0); iaNoData = junk
  iTimeStepNotFound = 0;             iaNoData = [];
  iTimeStepNotFound = length(junk);  iaNoData = junk;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iQAX == 1
  fn_summary = sprintf('LatBin%1$02d/LonBin%2$02d/summarystats_LatBin%1$02d_LonBin%2$02d_timesetps_001_%3$03d_V1.mat',lati,loni,i16daysSteps);
elseif iQAX == 3
  fn_summary = sprintf('LatBin%1$02d/LonBin%2$02d/iQAX_3_summarystats_LatBin%1$02d_LonBin%2$02d_timesetps_001_%3$03d_V1.mat',lati,loni,i16daysSteps);
end
fn_summary = fullfile(fdirpre,fn_summary);

if exist(fn_summary)
  %fprintf(1,'tile_fits_quantiles.m :lati,loni = %2i %2i  loading  << %s >> with %3i i16daysSteps\n',lati,loni,fn_summary,i16daysSteps)
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

%disp(' timestep_notfound = ')
%d.timestep_notfound
%if length(setdiff(d.timestep_notfound,iaNoData)) > 0
%  disp('>>>>>>>>>>>> oops length(setdiff(d.timestep_notfound,iaNoData)) > 0')
%  disp('>>>>>>>>>>>> oops length(setdiff(d.timestep_notfound,iaNoData)) > 0')
%  disp('>>>>>>>>>>>> oops length(setdiff(d.timestep_notfound,iaNoData)) > 0')
%end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

timeSE = load('../Code_For_HowardObs_TimeSeries/timestepsStartEnd_2002_09_to_2024_09.mat');
rtimeS = utc2taiSergio(startdate(1),startdate(2),startdate(3),0.0001);
rtimeE = utc2taiSergio(stopdate(1),stopdate(2),stopdate(3),24-0.0001);
iaSE = find(timeSE.rtimeS >= rtimeS & timeSE.rtimeE <= rtimeE);
if length(iaNoData) > 0
  iaSE = setdiff(iaSE,iaNoData);
end
iaTimeStepsFound = find(iaFound(1:length(ia16daysSteps)) == 1);
%% fprintf(1,'taking into account %3i missing timesteps, anticipate %4i timesteps to be used \n',iTimeStepNotFound,length(iaSE));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k_desc = find((dtime >= datenum(datetime(startdate(1),startdate(2),startdate(3))) & dtime <= datenum(datetime(stopdate(1),stopdate(2),stopdate(3)))));
k_asc  = find((dtime >= datenum(datetime(startdate(1),startdate(2),startdate(3))) & dtime <= datenum(datetime(stopdate(1),stopdate(2),stopdate(3)))));

if length(k_desc) ~= length(iaSE) 
  %fprintf(1,'whoops 7A length(k_desc) ~= length(iaSE)  %3i %3i \n',length(k_desc),length(iaSE));
  %% if off by 1 or 2, reset
  if abs(length(k_desc) - length(iaSE)) <= iTimeStepNotFound+2 & ((k_desc(1) == iaSE(1)) | (k_desc(end) == iaSE(end)))
    %disp('since lengths are only off by 1 or 2 reset k_desc')
    k_desc = iaSE;
  else
    error('please check');
  end
end
if length(k_asc) ~= length(iaSE)
  %fprintf(1,'whoops 7B length(k_asc) ~= length(iaSE)  %3i %3i \n',length(k_asc),length(iaSE));
  %% if off by 1 or 2, reset
  if abs(length(k_asc) - length(iaSE)) <= iTimeStepNotFound+2 & ( (k_asc(1) == iaSE(1)) | (k_asc(end) == iaSE(end)))
    %disp('since lengths are only off by 1 or 2 reset k_asc')
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iQAX == 1
  numQuant = 16;
elseif iQAX == 3
  numQuant = 5;
end

if iQAX == 1
  qi1 = 12; qi2 = 16;
elseif iQAX == 3
  qi1 = 3; qi2 = 5;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run off tsurf using bt1231/bt1228 regression for qi = 16;  

iNumSineCosCycles = 4;

for qi = qi1 : qi2
   % r1231 = squeeze(d.rad_quantile_desc(:,1520,qi));
   % r1228 = squeeze(d.rad_quantile_desc(:,1513,qi));
   r1231 = squeeze(d.rad_quantile_desc(k_desc,1520,qi));
   r1228 = squeeze(d.rad_quantile_desc(k_desc,1513,qi));
   bt1231 = rad2bt(fairs(1520),r1231);
   bt1228 = rad2bt(fairs(1513),r1228);
   desc_tsurf(qi- (qi1-1),:) = bt1231 + polyval(p,bt1228 - bt1231);
%    [dbt_desc_tsurf(qi- (qi1-1) ,:) stats] = Math_tsfit_lin_robust(dtime(k_desc)-dtime(k_desc(1)),desc_tsurf,iNumSineCosCycles);
%    % dbt_desc_tsurf(qi- (qi1-1) ,2)
%    dbt_desc_tsurf_err(qi- (qi1-1) ,2) = stats.se(2);
%    % dbt_desc_tsurf_err(qi- (qi1-1) ,2)

   % r1231 = squeeze(d.rad_quantile_asc(:,1520,qi));
   % r1228 = squeeze(d.rad_quantile_asc(:,1513,qi));
   r1231 = squeeze(d.rad_quantile_asc(k_asc,1520,qi));
   r1228 = squeeze(d.rad_quantile_asc(k_asc,1513,qi));
   bt1231 = rad2bt(fairs(1520),r1231);
   bt1228 = rad2bt(fairs(1513),r1228);
   asc_tsurf(qi- (qi1-1),:) = bt1231 + polyval(p,bt1228 - bt1231);
%    [dbt_asc_tsurf(qi- (qi1-1) ,:) stats] = Math_tsfit_lin_robust(dtime(k_asc)-dtime(k_asc(1)),asc_tsurf,iNumSineCosCycles);
%    % dbt_asc_tsurf(qi- (qi1-1) ,2)
%    dbt_asc_tsurf_err(qi- (qi1-1) ,2) = stats.se(2);
%    % dbt_asc_tsurf_err(qi- (qi1-1) ,2)
end

if AorD == 'D'
  tsurf = desc_tsurf;
else
  tsurf = asc_tsurf;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

warning off   
for qi = 1:numQuant
  for ch = iChanID : iChanID
    if AorD == 'D'
      % Desc
      r(qi,:) = squeeze(d.rad_quantile_desc(k_desc,ch,qi));
    elseif AorD == 'A'
      % Asc
      r(qi,:) = squeeze(d.rad_quantile_asc(:,ch,qi));     
    end
  end
end
warning on

%whos r iaTimeStepsFound desc_tsurf asc_tsurf

if length(iaTimeStepsFound) > length(r)
  iaTimeStepsFound = iaTimeStepsFound(1:length(r));
elseif length(r) > length(iaTimeStepsFound)
  r = r(:,1:length(iaTimeStepsFound));
  tsurf = tsurf(:,1:length(iaTimeStepsFound));
end

y    = r;
ySKT = tsurf;

