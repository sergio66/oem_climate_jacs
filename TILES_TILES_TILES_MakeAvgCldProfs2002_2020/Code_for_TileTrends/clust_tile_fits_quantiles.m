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
%% JOB = 2222

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
i16daysSteps = 412;   %% 2002/09 to 2020/08

%% Sergio stuff (run from my dir)
fdirpre      = '../DATAObsStats_StartSept2002_CORRECT_LatLon/';   %% symbolic link to ./DATAObsStats_StartSept2002_CORRECT_LatLon -> /asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_CORRECT_LatLon
fdirpre_out  = '../DATAObsStats_StartSept2002_CORRECT_LatLon/';
i16daysSteps = 412;   %% 2002/09 to 2020/08, testing that I get same results as Larrabee
i16daysSteps = 429;   %% 2002/09 to 2021/07
i16daysSteps = 431;   %% 2002/09 to 2021/08
i16daysSteps = 433;   %% 2002/09 to 2021/09

% Create outputfile name and save
fnout = sprintf('LatBin%1$02d/LonBin%2$02d/fits_LonBin%2$02d_LatBin%1$02d_V1_TimeSteps%3$03d.mat',lati,loni,i16daysSteps);
fnout = fullfile(fdirpre_out,fnout);
if ~exist(fnout)
  fprintf(1,'making fnout = %s \n',fnout)
else
  fprintf(1,'fnout = %s already exists\n',fnout)
  error('fnout already exists')
end

if ~exist(fdirpre_out)
  mkdir(fdirpre_out)
end

if exist(fnout)
  fprintf(1,'fnout = %s already exists, skipping \n',fnout)
end

% run the target script
%tile_fits_quantiles(loni,lati,fdirpre,fnout,i16daysSteps); %% can technically put [yy mm dd]_stop date   and [yy mm dd]_start date as two extra arguments
tile_fits_quantiles(loni,lati,fdirpre,fnout,i16daysSteps,[2021 08 31],[2002 09 01]); %% can technically put [yy mm dd]_stop date   and [yy mm dd]_start date as two extra arguments

% only for tests
% fprintf(1, 'pause for the cause\n')
% pause(5)
