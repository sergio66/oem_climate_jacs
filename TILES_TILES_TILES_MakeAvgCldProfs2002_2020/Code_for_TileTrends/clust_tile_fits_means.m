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
%JOB = 2222

system_slurm_stats

more off

%{
for ii = 1 : 72
  for jj = 1 : 64
    mker = ['!mkdir -p ../DATAObsStats_StartSept2002_CORRECT_LatLon_v3/Mean/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d')];
    eval(mker)
  end
end

%}

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
fdirpre      = 'Data/Quantv1_Extreme';
fdirpre_out  = 'Data/Quantv1_Extremefits';
i16daysSteps = 412;
%% Sergio stuff (run from my dir)
fdirpre      = '../DATAObsStats_StartSept2002_CORRECT_LatLon_v3/Extreme/';
fdirpre_out  = '../DATAObsStats_StartSept2002_CORRECT_LatLon_v3/Extreme/';
i16daysSteps = 429;
%% Sergio stuff (run from my dir)
fdirpre      = '../DATAObsStats_StartSept2002_CORRECT_LatLon/';   %% symbolic link to ./DATAObsStats_StartSept2002_CORRECT_LatLon -> /asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_CORRECT_LatLon
fdirpre_out  = '../DATAObsStats_StartSept2002_CORRECT_LatLon_v3/Mean/';
i16daysSteps = 429;

% Create outputfile name and save
fnout = sprintf('LatBin%1$02d/LonBin%2$02d/mean_fits_LonBin%2$02d_LatBin%1$02d_V1_TimeSteps%3$03d.mat',lati,loni,i16daysSteps);
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

% run the target script
tile_fits_means(loni,lati,fdirpre,fnout,i16daysSteps); %% can technically put [yy mm dd]_stop date   and [yy mm dd]_start date as two extra arguments

% only for tests
% fprintf(1, 'pause for the cause\n')
% pause(5)
