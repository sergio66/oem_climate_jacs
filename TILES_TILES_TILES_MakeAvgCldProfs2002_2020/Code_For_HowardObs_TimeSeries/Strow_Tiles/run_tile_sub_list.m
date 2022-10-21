%
% airs_tile_task - batch wrapper for airsL1c2buf
%

function run_tile_sub_list

i = str2num(getenv('SLURM_ARRAY_TASK_ID'));

load quantv2_todo

% run the target script
do_tile(loni(i),lati(i));

