%
% airs_tile_task - batch wrapper for airsL1c2buf
%
% cp   /home/strow/Work/Airs/Tiles/run_tile_fit.m  driver_run_tile_fits.m

%% run_tile_fit

addpath /asl/matlib/rtptools/
addpath /asl/matlib/aslutil
addpath /asl/matlib/h4tools
addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/matlib/clouds/sarta
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS
%% addpath ../Code_For_HowardObs_TimeSeries/Strow_Tiles
addpath /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/StrowCodeforTrendsAndAnomalies

addpath /asl/matlib/aslutil
addpath /asl/matlib/time
%addpath /home/strow/Matlab/Math

disp('make sure you check "set_iQAX" and "set_start_stop_dates" ')
disp('make sure you check "set_iQAX" and "set_start_stop_dates" ')
disp('make sure you check "set_iQAX" and "set_start_stop_dates" ')

%% kleenslurm; sbatch -p high_mem --array=1-4608%128 sergio_matlab_jobB.sbatch 10  for clust_tile_anomalies_quantiles.m
JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));   %% loop over ind tiles 1-4608
if length(JOB) == 0
  JOB = 2222;
  JOB = 77;
  JOB = 2787;   %% daytime over India
  JOB = 719;
  fprintf(1,'JOB did not exist, setting to %4i \n',JOB)
end

disp(' ')
%for JOB=1:4608
  lati = floor((JOB-1)/72)+1;  loni = JOB-(lati-1)*72;  fprintf(1,'JOB,lati,loni : %4i %3i %3i \n',JOB,lati,loni)
%end
disp(' ')

system_slurm_stats

jarid   = str2num(getenv('SLURM_ARRAY_TASK_ID'));    % job array ID
  jarid = JOB;
procid  = str2num(getenv('SLURM_PROCID'));          % relative process ID
nprocs  = str2num(getenv('SLURM_NTASKS'));          % number of tasks
nodeid  = sscanf(getenv('SLURMD_NODENAME'), '%s');  % node name

% get the 16-day set for this task.  jarid is from the job array
% spec, while procid is 0 to nprocs-1

iset = jarid + procid;

disp('at end go to /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/driver_put_together_QuantileChoose_trends.m and edit/run as needed')

fprintf(1, 'airs_tile_task: set %d node %s\n', iset, nodeid);
fprintf(1, 'airs_tile_task: jarid %d procid %d nprocs %d\n',jarid, procid, nprocs)

%% Strows stuff (run from his dir)
fdirpre      = '/home/strow/Work/Airs/Tiles/Data/Quantv1';        %% symbolic link to /home/strow/Work/Airs/Tiles/Data/Quantv1 -> /asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_CORRECT_LatLon
fdirpre_out  = '/home/strow/Work/Airs/Tiles/Data/Quantv1_fits';

%% Sergio stuff (run from my dir)
fdirpre      = '../DATAObsStats_StartSept2002_CORRECT_LatLon/';   %% symbolic link to ./DATAObsStats_StartSept2002_CORRECT_LatLon -> /asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_CORRECT_LatLon
fdirpre_out  = '../DATAObsStats_StartSept2002_CORRECT_LatLon/';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('make sure you check "set_iQAX" and "set_start_stop_dates" ')

set_iQAX              %%% <<<< CHECK THIS
set_start_stop_dates  %%% <<<< CHECK THIS

r16daysStepsX =      ((change2days(stopdate(1),stopdate(2),stopdate(3),2002) - change2days(startdate(1),startdate(2),startdate(3),2002))/16);
i16daysStepsX = floor((change2days(stopdate(1),stopdate(2),stopdate(3),2002) - change2days(startdate(1),startdate(2),startdate(3),2002))/16);
i16daysStepsX = round((change2days(stopdate(1),stopdate(2),stopdate(3),2002) - change2days(startdate(1),startdate(2),startdate(3),2002))/16);

if i16daysStepsX < i16daysSteps
  wah = [startdate stopdate];
  fprintf(1,'expecting i16daysSteps = %3i but using time period %4/%2i/%2i to %4/%2i/%2i which is %3i steps \n',i16daysSteps,wah,i16daysStepsX)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('iAllorSeason')
  iAllorSeason = -1;    %% use DJF
  iAllorSeason = -2;    %% use MAM
  iAllorSeason = -3;    %% use JJA
  iAllorSeason = -4;    %% use SON
  iAllorSeason = +1;    %% use all data   <<<< DEFAULT
end

fprintf(1,'clust_tile_fits_quantiles.m : iAllorSeason = %3i \n',iAllorSeason)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create outputfile name and save

if iQAX == 1
  if sum(startdate - [2002 09 01]) == 0 & i16daysSteps == i16daysStepsX
    fnout = sprintf('LatBin%1$02d/LonBin%2$02d/fits_LonBin%2$02d_LatBin%1$02d_V1_Anomaly_TimeSteps%3$03d.mat',lati,loni,i16daysSteps);
  else
    fnout = ['LatBin' num2str(lati,'%02d') '/LonBin' num2str(loni,'%02d') '/fits_LonBin' num2str(loni,'%02d') '_LatBin' num2str(lati,'%02d') '_V1_'];
    fnout = [fnout    num2str(startdate,'%04d') '_' num2str(stopdate,'%04d')  '_Anomaly_TimeStepsX' num2str(i16daysStepsX,'%03d')];
  end
elseif iQAX == 3
  if sum(startdate - [2002 09 01]) == 0 & i16daysSteps == i16daysStepsX
    fnout = sprintf('LatBin%1$02d/LonBin%2$02d/iQAX_3_fits_LonBin%2$02d_LatBin%1$02d_V1_Anomaly_TimeSteps%3$03d.mat',lati,loni,i16daysSteps);
  else
    fnout = ['LatBin' num2str(lati,'%02d') '/LonBin' num2str(loni,'%02d') '/iQAX_3_fits_LonBin' num2str(loni,'%02d') '_LatBin' num2str(lati,'%02d') '_V1_'];
    fnout = [fnout    num2str(startdate,'%04d') '_' num2str(stopdate,'%04d')  '_Anomaly_TimeStepsX' num2str(i16daysStepsX,'%03d')];
  end
elseif iQAX == 4
  if sum(startdate - [2002 09 01]) == 0 & i16daysSteps == i16daysStepsX
    fnout = sprintf('LatBin%1$02d/LonBin%2$02d/iQAX_4_fits_LonBin%2$02d_LatBin%1$02d_V1_Anomaly_TimeSteps%3$03d.mat',lati,loni,i16daysSteps);
  else
    fnout = ['LatBin' num2str(lati,'%02d') '/LonBin' num2str(loni,'%02d') '/iQAX_4_fits_LonBin' num2str(loni,'%02d') '_LatBin' num2str(lati,'%02d') '_V1_'];
    fnout = [fnout    num2str(startdate,'%04d') '_' num2str(stopdate,'%04d')  '_Anomaly_TimeStepsX' num2str(i16daysStepsX,'%03d')];
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%
boo = length(fnout);
if strcmp(fnout(boo-3:boo),'.mat')
 fnout = fnout(1:boo-4);
end

if iAllorSeason == -1
  fnout = [fnout '_DJF'];
elseif iAllorSeason == -2
  fnout = [fnout '_MAM'];
elseif iAllorSeason == -3
  fnout = [fnout '_JJA'];
elseif iAllorSeason == -4
  fnout = [fnout '_SON'];
end

fnout = [fnout '.mat'];
%%%%%%%%%%%%%%%%%%%%%%%%%

%% no need for this since both asc and desc anoms are done
%% iNorD = +1; %% nighttime
%% iNorD = -1; %% fayttime
%% if iNorD < 0
%%   boo = length(fnout);
%%   if strcmp(fnout(boo-3:boo),'.mat')
%%     fnout = fnout(1:boo-4);
%%   end
%%   fnout = [fnout '_day'];
%%   fnout = [fnout '.mat'];
%% end

%%%%%%%%%%%%%%%%%%%%%%%%%

fnout = fullfile(fdirpre_out,fnout);
if ~exist(fnout)
  fprintf(1,'making fnout = %s \n',fnout)
else
  fprintf(1,'fnout = %s already exists\n',fnout)
  disp('fnout already exists')
  return
end

if ~exist(fdirpre_out)
  mkdir(fdirpre_out)
end

% run the target script
%% can technically put [yy mm dd]_stop date   and [yy mm dd]_start date as two extra arguments
tile_fits_quantiles_anomalies(loni,lati,fdirpre,fnout,i16daysSteps,iQAX,stopdate,startdate,i16daysStepsX,iAllorSeason); 

% only for tests
% fprintf(1, 'pause for the cause\n')
% pause(5)

disp('check progress using check_progress_trends_extremes_OR_anomalies.m')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('now go to /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/driver_put_together_QuantileChoose_anomalies.m and edit/run as needed')
disp('now go to /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/driver_put_together_QuantileChoose_anomalies.m and edit/run as needed')
disp('now go to /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/driver_put_together_QuantileChoose_anomalies.m and edit/run as needed')
