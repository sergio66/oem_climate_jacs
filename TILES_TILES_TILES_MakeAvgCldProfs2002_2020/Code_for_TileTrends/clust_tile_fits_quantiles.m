%
% airs_tile_task - batch wrapper for airsL1c2buf
%
% cp   /home/strow/Work/Airs/Tiles/run_tile_fit.m  driver_run_tile_fits.m
%% run_tile_fit

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath /asl/matlib/rtptools/
addpath /asl/matlib/aslutil
addpath /asl/matlib/h4tools
addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/matlib/clouds/sarta
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));   %% loop over ind tiles 1-4608
if length(JOB) == 0
  JOB = 1;
end
% JOB = 2222

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

disp(' ')
disp('make sure you check "set_iQAX" and "set_start_stop_dates" ')
disp('make sure you check "set_iQAX" and "set_start_stop_dates" ')
disp('make sure you check "set_iQAX" and "set_start_stop_dates" ')
disp(' ')

set_iQAX              %%% <<<< CHECK THIS
set_start_stop_dates  %%% <<<< CHECK THIS

%r16daysStepsX =      ((change2days(stopdate(1),stopdate(2),stopdate(3),2002) - change2days(startdate(1),startdate(2),startdate(3),2002))/16);
%i16daysStepsX = floor((change2days(stopdate(1),stopdate(2),stopdate(3),2002) - change2days(startdate(1),startdate(2),startdate(3),2002))/16);
%i16daysStepsX = round((change2days(stopdate(1),stopdate(2),stopdate(3),2002) - change2days(startdate(1),startdate(2),startdate(3),2002))/16);

remove_timesteps_not_found_from_finalfilename

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

create_output_filename_clust_tile_fits_quantiles_loop72lons

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

if exist(fnout)
  fprintf(1,'fnout = %s already exists, skipping \n',fnout)
  return
end

% run the target script
%tile_fits_quantiles(loni,lati,fdirpre,fnout,i16daysSteps); %% can technically put [yy mm dd]_stop date   and [yy mm dd]_start date as two extra arguments
%tile_fits_quantiles(loni,lati,fdirpre,fnout,i16daysSteps,[2021 08 31],[2002 09 01]); %% can technically put [yy mm dd]_stop date   and [yy mm dd]_start date as two extra arguments
tile_fits_quantiles(loni,lati,fdirpre,fnout,i16daysSteps,iQAX,stopdate,startdate,i16daysStepsX,iAllorSeason); %% can technically put [yy mm dd]_stop date   and [yy mm dd]_start date as two extra arguments

% only for tests
% fprintf(1, 'pause for the cause\n')
% pause(5)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('check if everything is done (all 64 x 72 bins) using    check_progress_trends_extremes_quantiles.m');
disp('check if everything is done (all 64 x 72 bins) using    check_progress_trends_extremes_quantiles.m');
disp('check if everything is done (all 64 x 72 bins) using    check_progress_trends_extremes_quantiles.m');
disp('now go to /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/driver_put_together_QuantileChoose_trends.m and edit/run as needed')
disp('now go to /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/driver_put_together_QuantileChoose_trends.m and edit/run as needed')
disp('now go to /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/driver_put_together_QuantileChoose_trends.m and edit/run as needed')
