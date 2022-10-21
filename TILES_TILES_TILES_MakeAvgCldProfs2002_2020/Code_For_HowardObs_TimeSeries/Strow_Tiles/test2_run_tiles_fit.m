%
% airs_tile_task - batch wrapper for airsL1c2buf
%

function test2_run_tiles_fit

more off

jarid = str2num(getenv('SLURM_ARRAY_TASK_ID'));    % job array ID
procid = str2num(getenv('SLURM_PROCID'));          % relative process ID
nprocs = str2num(getenv('SLURM_NTASKS'));          % number of tasks
nodeid = sscanf(getenv('SLURMD_NODENAME'), '%s');  % node name

% get the 16-day set for this task.  jarid is from the job array
% spec, while procid is 0 to nprocs-1

iset = jarid + procid;

fprintf(1, 'airs_tile_task: set %d node %s\n', iset, nodeid);
fprintf(1, 'airs_tile_task: jarid %d procid %d nprocs %d\n', ...
  jarid, procid, nprocs)

% --array numbers
% jarid starts at 1
loni = jarid;

% procid start at zero?
% 1-n from --ntasks, so keep track of where to start
% lati = procid+26;  starts at lati = 26
%for lati = 54:64
for lati = 54:64

% run the target script
tile_fits(loni,lati);

end


% only for tests
% fprintf(1, 'pause for the cause\n')
% pause(5)
