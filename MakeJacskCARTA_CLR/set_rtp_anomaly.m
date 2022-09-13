%% there are 365 timesteps, each has 40 latbins

%%%%%%%%%%%%%%%%%%%%%%%%%
%{
% testing

full_path = '/home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/MakeProfs/LATS40_avg_made_Mar29_2019_Clr/Desc//16DayAvg//timestep_365_16day_avg.rp.rtp';
for JOB = 1 : 365*40  
  iTimeStep = floor(JOB/40) + 1;
  iLatbin  = mod(JOB,40); 
  if iLatbin == 0
    iLatbin = 40;
  end
  fprintf(1,'JOB   timesetep    latbin = %6i %3i %2i \n',JOB,iTimeStep,iLatbin)
end
%}
%%%%%%%%%%%%%%%%%%%%%%%%%

iTimeStep = floor((JOB-1)/40) + 1;
iLatbin  = mod(JOB,40); 
if iLatbin == 0
  iLatbin = 40;
end

%% use_this_rtp = ['../MakeProfs/LATS40_avg_made_Mar29_2019_Clr/Desc//16DayAvg//timestep_' num2str(iTimeStep,'%03d') '_16day_avg.rp.rtp'];
%% ln -s ../MakeProfs/LATS40_avg_made_Mar29_2019_Clr/Desc//16DayAvg/ AnomSym
use_this_rtp = ['AnomSym/timestep_' num2str(iTimeStep,'%03d') '_16day_avg.rp.rtp'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% moved to clust_do_kcarta_driver.m
%% DO NOT TOUCH THESE LAST TWO LINES. EDIT set_convolver as needed
%% use_this_rtp0 = use_this_rtp;
%% set_convolver
%% DO NOT TOUCH THESE LAST TWO LINES. EDIT set_convolver as needed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
