%
% airs_tile_task - batch wrapper for airsL1c2buf
%

function test_run_tile_fit

more off

jarid = str2num(getenv('SLURM_ARRAY_TASK_ID'));    % job array ID
procid = str2num(getenv('SLURM_PROCID'));          % relative process ID
nprocs = str2num(getenv('SLURM_NTASKS'));          % number of tasks
nodeid = sscanf(getenv('SLURMD_NODENAME'), '%s');  % node name

% get the 16-day set for this task.  jarid is from the job array
% spec, while procid is 0 to nprocs-1

fprintf(1, 'airs_tile_task: jarid %d procid %d nprocs %d\n', ...
  jarid, procid, nprocs)

% --array numbers
% jarid starts at 1
lati = jarid;

% procid start at zero?
% 1-n from --ntasks, so keep track of where to start
% lati = procid+26;  starts at lati = 26
%for lati = 54:64

for loni = 1:72
   tile_fits_just_tsurf(loni,lati);
end

