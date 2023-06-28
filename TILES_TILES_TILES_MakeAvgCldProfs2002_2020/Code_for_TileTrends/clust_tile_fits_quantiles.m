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

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));   %% loop over ind tiles 1-4608
% JOB = 2222
% JOB = 77

system_slurm_stats

more off

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

disp(' ')
%for JOB=1:4608
  lati = floor((JOB-1)/72)+1;  loni = JOB-(lati-1)*72;  fprintf(1,'JOB,lati,loni : %4i %3i %3i \n',JOB,lati,loni)
%end
disp(' ')

%% Strows stuff (run from his dir)
fdirpre      = '/home/strow/Work/Airs/Tiles/Data/Quantv1';        %% symbolic link to /home/strow/Work/Airs/Tiles/Data/Quantv1 -> /asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_CORRECT_LatLon
fdirpre_out  = '/home/strow/Work/Airs/Tiles/Data/Quantv1_fits';

%% Sergio stuff (run from my dir)
fdirpre      = '../DATAObsStats_StartSept2002_CORRECT_LatLon/';   %% symbolic link to ./DATAObsStats_StartSept2002_CORRECT_LatLon -> /asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_CORRECT_LatLon
fdirpre_out  = '../DATAObsStats_StartSept2002_CORRECT_LatLon/';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% ENCOMPASSING PERIOD OF DATA AVAILABLE AND SAVED
startdate = [2002 09 01]; stopdate = [2020 08 31]; i16daysSteps = 412;                       %% 2002/09 to 2020/08, testing that I get same results as Larrabee
startdate = [2002 09 01]; stopdate = [2021 06 31]; i16daysSteps = 429;                       %% 2002/09 to 2021/06
startdate = [2002 09 01]; stopdate = [2021 07 31]; i16daysSteps = 431;                       %% 2002/09 to 2021/07
startdate = [2002 09 01]; stopdate = [2021 08 31]; i16daysSteps = 433;                       %% 2002/09 to 2021/08 = 19 years, 433 steps **********
startdate = [2002 09 01]; stopdate = [2014 08 31]; i16daysSteps = 433;                       %% 2002/09 to 2014/09 = 273 steps, but use this extended encompassing period to do things fast

startdate = [2002 09 01]; stopdate = [2022 08 31]; i16daysSteps = 456;                       %% 2002/09 to 2022/08 = 20 years, 457 steps **********
startdate = [2002 09 01]; stopdate = [2022 09 07]; i16daysSteps = 457;                       %% 2002/09 to 2022/08 = 20 years, 457 steps **********

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% DEFINE PERIOD YOU ACTUALLY WANT, so can speed up things using SAVED data
startdate = [2002 09 01]; stopdate = [2021 08 31]; 
startdate = [2005 01 01]; stopdate = [2014 12 31];  % Joao wants 10 years
startdate = [2003 01 01]; stopdate = [2012 12 31];  % Joao wants 10 years
startdate = [2002 09 01]; stopdate = [2014 08 31];  % overlap with CMIP6/AMIP6
startdate = [2012 05 01]; stopdate = [2019 04 30];  % overlap with Suomi CrIS NSR

startdate = [2002 09 01]; stopdate = [2022 08 31]; % 20 years!
startdate = [2015 01 01]; stopdate = [2021 12 31]; % OCO2-CO2 overlap
startdate = [2002 09 01]; stopdate = [2022 09 07]; % 2002/09 to 2022/08 = 20 years, 457 steps **********
startdate = [2002 09 01]; stopdate = [2007 08 31]; % 05 years!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

set_iQAX

% Create outputfile name and save

if iQAX == 1
  if sum(startdate - [2002 09 01]) == 0 & i16daysSteps == i16daysStepsX
    fnout = sprintf('LatBin%1$02d/LonBin%2$02d/fits_LonBin%2$02d_LatBin%1$02d_V1_TimeSteps%3$03d.mat',lati,loni,i16daysSteps);
  else
    fnout = ['LatBin' num2str(lati,'%02d') '/LonBin' num2str(loni,'%02d') '/fits_LonBin' num2str(loni,'%02d') '_LatBin' num2str(lati,'%02d') '_V1_'];
    fnout = [fnout    num2str(startdate,'%04d') '_' num2str(stopdate,'%04d')  '_TimeStepsX' num2str(i16daysStepsX,'%03d')];
  end
elseif iQAX == 3
  if sum(startdate - [2002 09 01]) == 0 & i16daysSteps == i16daysStepsX
    fnout = sprintf('LatBin%1$02d/LonBin%2$02d/iQAX_3_fits_LonBin%2$02d_LatBin%1$02d_V1_TimeSteps%3$03d.mat',lati,loni,i16daysSteps);
  else
    fnout = ['LatBin' num2str(lati,'%02d') '/LonBin' num2str(loni,'%02d') '/iQAX_3_fits_LonBin' num2str(loni,'%02d') '_LatBin' num2str(lati,'%02d') '_V1_'];
    fnout = [fnout    num2str(startdate,'%04d') '_' num2str(stopdate,'%04d')  '_TimeStepsX' num2str(i16daysStepsX,'%03d')];
  end
end

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
tile_fits_quantiles(loni,lati,fdirpre,fnout,i16daysSteps,iQAX,stopdate,startdate,i16daysStepsX); %% can technically put [yy mm dd]_stop date   and [yy mm dd]_start date as two extra arguments

% only for tests
% fprintf(1, 'pause for the cause\n')
% pause(5)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('now go to /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/driver_put_together_QuantileChoose_trends.m and edit/run as needed')
disp('now go to /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/driver_put_together_QuantileChoose_trends.m and edit/run as needed')
disp('now go to /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/driver_put_together_QuantileChoose_trends.m and edit/run as needed')
