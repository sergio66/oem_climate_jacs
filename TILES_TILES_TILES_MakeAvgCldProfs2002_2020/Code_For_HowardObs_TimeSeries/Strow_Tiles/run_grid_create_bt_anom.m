% run_grid_create_bt_anom.m
% ---------------------------------------------------------------------------------- 
% 64 x 72 lat/lon; parallelize by lon
% ---------------------------------------------------------------------------------- 
i = str2num(getenv('SLURM_ARRAY_TASK_ID'));

start_time = datetime(2002,9,1,0,0,0);
stop_time  = datetime(2019,8,30,0,0,0);

grid_create_bt_anom_sergio(i,start_time,stop_time);
