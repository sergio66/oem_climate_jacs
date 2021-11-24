%% clustcmd -q short -n 36 make_sarta_test_jacobians.m 1:40

%% run with
%%   all slurm output to one file, Paul does NOT recommend this
%%     sbatch --array=N1-N2 --output='testslurm' sergio_matlab_jobB.sbatch
%%   all slurm output to individual files, messy, but Paul recommends this
%%     sbatch --array=N1-N2 sergio_matlab_jobB.sbatch
%% N1 = 1, N2 = number of files to be processed

%% copied from /home/sergio/MATLABCODE/RATES_NEW/
addpath /asl/matlib/aslutil/
addpath /asl/matlib/h4tools
addpath /asl/matlib/rtptools
addpath /home/sergio/MATLABCODE

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
%JOB = 18;
iiBin = JOB;

klayers = '/asl/packages/klayers/Bin/klayers_airs'; 
sarta   = '/home/sergio/SARTA_CLOUDY/Bin/sarta_dec05_sphcirrus_waterdrop_obsidian';
sarta   = '/asl/packages/sartaV108/Bin/sarta_apr08_m140';

iChangeSatZen = +1;
if iChangeSatZen > 0
  load('satzen_per_lat_for_env_data.mat');
  addpath /home/sergio/MATLABCODE/PLOTTER
  lats40 = equal_area_spherical_bands(20);
  lats40 = 0.5 * (lats40(1:end-1) + lats40(2:end));
  newsatzen = interp1(env_lat,mean(satzen_per_lat'),lats40);
  plot(env_lat,mean(satzen_per_lat'),lats40,newsatzen,'ro')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('make sure you correctly set "set_dirIN_dirOUT" as it is called by rates_profiles40')
rates_profiles40  %%% see make_lats40_avg_and_monthly_profs.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('now use put_together_rates')
