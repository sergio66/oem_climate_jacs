%
% airs_tile_task - batch wrapper for airsL1c2buf
%

function run_tile_fit

more off

i = str2num(getenv('SLURM_ARRAY_TASK_ID'));

g = load('quantv2_fit_list');%  ilon ilat

loni  = g.ilong;
lati  = g.ilatg;

% run the target script
tile_fits2(loni(i),lati(i));

% only for tests
% fprintf(1, 'pause for the cause\n')
% pause(5)
