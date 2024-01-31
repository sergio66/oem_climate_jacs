function [] = tile_fits_quantiles(loni,lati,fdirpre,fnout,i16daysSteps,iQAX,stopdate,startdate,i16daysStepsX,iAllorSeason)
%%                                  1    2     3      4       6        [ 6     7       8          9             10      ])

xnargin = nargin;

%% copied from /home/strow/Work/Airs/Tiles/tile_fits.m

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
%% %% see eg ~/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries/clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m
%% hugedir = dir('/asl/isilon/airs/tile_test7/');  %% 417 timesteps till Nov 2020
%% hugedir = dir('/asl/isilon/airs/tile_test7/');  %% 433 timesteps till Nov 2021
%% hugedir = dir('/asl/isilon/airs/tile_test7/');  %% 457 timesteps till Nov 2020
%% disp('>>>>>>>> looking at /asl/isilon/airs/tile_test7/ ')
%% 
%% fprintf(1,'found %3i timesteps there \n',length(hugedir)-2); %% remember first two are . and ..
%% 
%% iaFound = zeros(1,600);
%% for ii = 3 : length(hugedir)
%%   junk = hugedir(ii).name;
%%   junk = str2num(junk(end-2:end));
%%   iaFound(junk) = 1;
%% end
%% junk = find(iaFound == 1); junk = max(junk); maxN = junk;
%%   fprintf(1,'max(iaFound) = %3i so should do "kleenslurm; sbatch             --array=430-%3i  sergio_matlab_jobB.sbatch 10" \n',junk,junk+2);

iQuiet = +1;
remove_timesteps_not_found_from_finalfilename
iaNoData = junk;
clear iQuiet

%disp('these timesteps are not found : '); junk = find(iaFound(1:junk) == 0); iaNoData = junk
%  iTimeStepNotFound = 0;             iaNoData = [];
%  iTimeStepNotFound = length(junk);  iaNoData = junk;
  
fprintf(1,'there should be %3i Sergio processed files \n',maxN - iTimeStepNotFound);
disp('>>>>>>>> looking at /asl/isilon/airs/tile_test7/ ')
disp(' ' )
%keyboard_nowindow

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iQAX == 1
  fn_summary = sprintf('LatBin%1$02d/LonBin%2$02d/summarystats_LatBin%1$02d_LonBin%2$02d_timesetps_001_%3$03d_V1.mat',lati,loni,i16daysSteps);
  %fn_summary = sprintf('LatBin%1$02d/LonBin%2$02d/summarystats_LatBin%1$02d_LonBin%2$02d_timesetps_001_%3$03d_V1.mat',lati,loni,i16daysStepsX);
elseif iQAX == 3
  fn_summary = sprintf('LatBin%1$02d/LonBin%2$02d/iQAX_3_summarystats_LatBin%1$02d_LonBin%2$02d_timesetps_001_%3$03d_V1.mat',lati,loni,i16daysSteps);
  %fn_summary = sprintf('LatBin%1$02d/LonBin%2$02d/iQAX_3_summarystats_LatBin%1$02d_LonBin%2$02d_timesetps_001_%3$03d_V1.mat',lati,loni,i16daysStepsX);
elseif iQAX == 4
  fn_summary = sprintf('LatBin%1$02d/LonBin%2$02d/iQAX_4_summarystats_LatBin%1$02d_LonBin%2$02d_timesetps_001_%3$03d_V1.mat',lati,loni,i16daysSteps);  
  %fn_summary = sprintf('LatBin%1$02d/LonBin%2$02d/iQAX_4_summarystats_LatBin%1$02d_LonBin%2$02d_timesetps_001_%3$03d_V1.mat',lati,loni,i16daysStepsX);
else
  error('unknown iQAX')
end
fn_summary = fullfile(fdirpre,fn_summary);

%% printVariableLengthArray([i16daysSteps i16daysStepsX])

if exist(fn_summary)
  fprintf(1,'tile_fits_quantiles.m :lati,loni = %2i %2i  loading  << %s >> with %3i i16daysSteps\n',lati,loni,fn_summary,i16daysSteps)
  d = load(fn_summary);
  if length(d.lat_asc) < i16daysSteps-iTimeStepNotFound
    fprintf(1,'[length(d.lat_asc) i16daysSteps] = %4i %4i \n',length(d.lat_asc),i16daysSteps)
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
printVariableLengthArray(d.timestep_notfound)
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

  iaSE = find((dtime >= datenum(datetime(startdate(1),startdate(2),startdate(3))) & dtime <= datenum(datetime(stopdate(1),stopdate(2),stopdate(3)))));

  if length(iaNoData) > 0
    iaSE = setdiff(iaSE,iaNoData);
    fprintf(1,'taking into account %3i missing timesteps (FEW ), anticipate %4i timesteps to be used \n',iTimeStepNotFound,length(iaSE));
  else
    fprintf(1,'taking into account %3i missing timesteps (NONE), anticipate %4i timesteps to be used \n',iTimeStepNotFound,length(iaSE));
  end
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
      fprintf(1,'          k_desc == uses startdate/stopdate of %4i/%02i/%02i to  %4i/%02i/%02i and \n',startdate,stopdate);
      fprintf(1,'          iaSE   == uses startdate/stopdate of %4i/%02i/%02i to  %4i/%02i/%02i and timeSE = load(''../Code_For_HowardObs_TimeSeries/timestepsStartEnd_2002_09_to_2024_09.mat''); \n',startdate,stopdate);
k_desc
iaSE
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
elseif iQAX == 4
  numQuant = 3;
else
  error('unknown iQAX')
end

if iAllorSeason > 0
  b_asc          = NaN(2645,numQuant,10);
  b_desc         = NaN(2645,numQuant,10);
  berr_asc       = NaN(2645,numQuant,10);
  berr_desc      = NaN(2645,numQuant,10);
else
  b_asc          = NaN(2645,numQuant,2);
  b_desc         = NaN(2645,numQuant,2);
  berr_asc       = NaN(2645,numQuant,2);
  berr_desc      = NaN(2645,numQuant,2);
end

dbt_asc        = NaN(2645,numQuant);
dbt_desc       = NaN(2645,numQuant);
dbt_err_asc    = NaN(2645,numQuant);
dbt_err_desc   = NaN(2645,numQuant);

resid_desc_std = NaN(2645,numQuant);
resid_asc_std  = NaN(2645,numQuant);

% 6 values are:  ols_s, robust_s, mad_s, s, t(2), p(2) 
stats_desc = NaN(2645,numQuant,6);
stats_asc  = NaN(2645,numQuant,6);

% keyboard_nowindow

if iQAX == 1
  qi1 = 12; qi2 = 16;
elseif iQAX == 3
  qi1 = 3; qi2 = 5;
elseif iQAX == 4
  qi1 = 1; qi2 = 1;
else
  error('unknown iQAX')
end

clear damonth

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run off tsurf using bt1231/bt1228 regression for qi = 16;  

iNumSineCosCycles = 4;
if iAllorSeason < 0
  %% only DJF, MAM, JJA, SON
  iNumSineCosCycles = 0;
end

for qi = qi1 : qi2
   % r1231 = squeeze(d.rad_quantile_desc(:,1520,qi));
   % r1228 = squeeze(d.rad_quantile_desc(:,1513,qi));
   r1231 = squeeze(d.rad_quantile_desc(k_desc,1520,qi));
   r1228 = squeeze(d.rad_quantile_desc(k_desc,1513,qi));
   bt1231 = rad2bt(fairs(1520),r1231);
   bt1228 = rad2bt(fairs(1513),r1228);
   desc_tsurf = bt1231 + polyval(p,bt1228 - bt1231);
   [dbt_desc_tsurf(qi- (qi1-1) ,:) stats] = Math_tsfit_lin_robust(dtime(k_desc)-dtime(k_desc(1)),desc_tsurf,iNumSineCosCycles);
   % dbt_desc_tsurf(qi- (qi1-1) ,2)
   dbt_desc_tsurf_err(qi- (qi1-1) ,2) = stats.se(2);
   % dbt_desc_tsurf_err(qi- (qi1-1) ,2)

   % r1231 = squeeze(d.rad_quantile_asc(:,1520,qi));
   % r1228 = squeeze(d.rad_quantile_asc(:,1513,qi));
   r1231 = squeeze(d.rad_quantile_asc(k_asc,1520,qi));
   r1228 = squeeze(d.rad_quantile_asc(k_asc,1513,qi));
   bt1231 = rad2bt(fairs(1520),r1231);
   bt1228 = rad2bt(fairs(1513),r1228);
   asc_tsurf = bt1231 + polyval(p,bt1228 - bt1231);
   [dbt_asc_tsurf(qi- (qi1-1) ,:) stats] = Math_tsfit_lin_robust(dtime(k_asc)-dtime(k_asc(1)),asc_tsurf,iNumSineCosCycles);
   % dbt_asc_tsurf(qi- (qi1-1) ,2)
   dbt_asc_tsurf_err(qi- (qi1-1) ,2) = stats.se(2);
   % dbt_asc_tsurf_err(qi- (qi1-1) ,2)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

warning off   
for qi = 1:numQuant
  fprintf(1,'qi = %2i of %2i \n',qi,numQuant);
  [ b_satzen_desc(qi,:) stats] = Math_tsfit_lin_robust(dtime(k_desc)-dtime(k_desc(1)),d.satzen_quantile1231_desc(k_desc,qi),1);
  berr_satzen_desc(qi,:) = stats.se;

  [ b_satzen_asc(qi,:) stats] = Math_tsfit_lin_robust(dtime(k_asc)-dtime(k_asc(1)),d.satzen_quantile1231_asc(k_asc,qi),1);
  berr_satzen_asc(qi,:) = stats.se;

  for ch = 1:2645
    % Desc
    r = squeeze(d.rad_quantile_desc(:,ch,qi));
    % bt = rad2bt(fairs(ch),squeeze(d.rad_quantile_desc(:,ch,qi)));
    [b_desc(ch,qi,:) stats] = Math_tsfit_lin_robust(dtime(k_desc)-dtime(k_desc(1)),r(k_desc),iNumSineCosCycles);
    berr_desc(ch,qi,:) = stats.se;
    stats_desc(ch,qi,:) = [stats.ols_s stats.robust_s stats.mad_s stats.s stats.t(2) stats.p(2)];
    l = xcorr(stats.resid,1,'coeff');
    lag_desc(ch,qi) = l(1);
    deriv = drdbt(fairs(ch),rad2bt(fairs(ch),r(k_desc)));
    bt_resid = stats.resid./deriv;
    resid_desc_std(ch,qi) = nanstd(real(bt_resid));
      
    % Asc
    r = squeeze(d.rad_quantile_asc(:,ch,qi));
    %   bt = rad2bt(fairs(ch),squeeze(d.rad_quantile_asc(:,ch,qi)));
    [b_asc(ch,qi,:) stats] = Math_tsfit_lin_robust(dtime(k_asc)-dtime(k_asc(1)),r(k_asc),iNumSineCosCycles);
    berr_asc(ch,qi,:) = stats.se;
    stats_asc(ch,qi,:) = [stats.ols_s stats.robust_s stats.mad_s stats.s stats.t(2) stats.p(2)];
    l = xcorr(stats.resid,1,'coeff');
    lag_asc(ch,qi) = l(1);
    deriv = drdbt(fairs(ch),rad2bt(fairs(ch),r(k_asc)));
    bt_resid = stats.resid./deriv;
    resid_asc_std(ch,qi) = nanstd(real(bt_resid));
  end

  % Convert b_trends and uncertainties to BT units
  deriv = drdbt(fairs,rad2bt(fairs,squeeze(b_desc(:,qi,1))));
  dbt_desc(:,qi)     = b_desc(:,qi,2)./deriv;
  dbt_err_desc(:,qi) = berr_desc(:,qi,2)./deriv;
     
  deriv = drdbt(fairs,rad2bt(fairs,squeeze(b_asc(:,qi,1))));
  dbt_asc(:,qi)     = b_asc(:,qi,2)./deriv;
  dbt_err_asc(:,qi) = berr_asc(:,qi,2)./deriv;
     
  % Correct dbt_ for lag-1 correlations (note b*(:,2) values NOT corrected for lag-1)
  lagc = sqrt( ( 1 + lag_desc(:,qi) ) ./ ( 1 - lag_desc(:,qi) ) ) ;
  dbt_err_desc(:,qi) = lagc .* dbt_err_desc(:,qi);
    
  lagc = sqrt( ( 1 + lag_asc(:,qi) ) ./ ( 1 - lag_asc(:,qi) ) ) ;
  dbt_err_asc(:,qi) = lagc .* dbt_err_asc(:,qi);
     
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

if ~exist(fnout)
  fprintf(1,'saving to %s \n',fnout);
  save(fnout);
else
  fprintf(1,'oops %s already exists \n',fnout)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   count_asc                        1x412                     3296  double                
%   count_desc                       1x412                     3296  double                
% 
%   lat_asc                          1x412                     3296  double                
%   lat_desc                         1x412                     3296  double                
%   
%   lon_asc                          1x412                     3296  double                
%   lon_desc                         1x412                     3296  double                
%   
%   meanBT_asc                     412x2645                 4358960  single                
%   meanBT_desc                    412x2645                 4358960  single                
%   
%   quantile1231_asc               412x16                     52736  double                
%   quantile1231_desc              412x16                     52736  double                
%   quants                           1x17                       136  double                
%   
%   rad_quantile_asc               412x2645x16            139486720  double                
%   rad_quantile_desc              412x2645x16            139486720  double                
%   
%   satzen_asc                       1x412                     3296  double                
%   satzen_desc                      1x412                     3296  double                
%   
%   satzen_quantile1231_asc        412x16                     52736  double                
%   satzen_quantile1231_desc       412x16                     52736  double                
%   
%   solzen_asc                       1x412                     3296  double                
%   solzen_desc                      1x412                     3296  double                
%   
%   solzen_quantile1231_asc        412x16                     52736  double                
%   solzen_quantile1231_desc       412x16                     52736  double                
% 
%   tai93_asc                        1x412                     3296  double                
%   tai93_desc                       1x412                     3296  double                

