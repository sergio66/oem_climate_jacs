%
% airs_tile_task - batch wrapper for airsL1c2buf
%

function run_fire_sub_list

i = str2num(getenv('SLURM_ARRAY_TASK_ID'));

load quantv3_list2

% run the target script
find_fires2(long(i),latg(i));

