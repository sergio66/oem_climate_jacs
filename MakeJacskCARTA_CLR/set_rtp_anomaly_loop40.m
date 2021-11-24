%% there are 365 timesteps, each has 40 latbins

iTimeStep = JOB;

%% use_this_rtp = ['../MakeProfs/LATS40_avg_made_Mar29_2019_Clr/Desc//16DayAvg//timestep_' num2str(iTimeStep,'%03d') '_16day_avg.rp.rtp'];
%% ln -s ../MakeProfs/LATS40_avg_made_Mar29_2019_Clr/Desc//16DayAvg/    AnomSym        %% this is for fixed CO2/N2O/CH4 profiles, 16day avg has    seasonal
%% ln -s ../MakeProfs/LATS40_avg_made_Mar29_2019_Clr/Desc//16DayAvgNoS/ AnomSym        %% this is for fixed CO2/N2O/CH4 profiles, 16day avg has NO seasonal

use_this_rtp = ['AnomSym_Mar29_2019/timestep_'    num2str(iTimeStep,'%03d') '_16day_avg.rp.rtp'];  %% using for the great anomaly stuff, but no CFC12

%% Aug 28, 2019 %% hopefully great and includes CFC12, link to ../MakeProfs/LATS40_avg_made_Aug20_2019_Clr/Desc//16DayAvgNoS/
use_this_rtp = ['AnomSym/timestep_' num2str(iTimeStep,'%03d') '_16day_avg.rp.rtp'];             

%% Dec 05, 2019 %% hopefully great and includes CFC12, link to ../MakeProfs/LATS40_avg_made_Aug20_2019_Clr/Desc//16DayAvgNoS/
use_this_rtp = ['AnomSym/timestep_' num2str(iTimeStep,'%03d') '_16day_avg_co2ageofair.rp.rtp'];             

%% Jan 20,2020 %% hopefully great and includes CFC12, link to ../MakeProfs/CLO_LAT40_avg_made_Dec2019_Clr/Desc/16DayAvgNoS/ == CRIS
use_this_rtp = ['AnomSym/timestep_' num2str(iTimeStep,'%03d') '_16day_avg.rp.rtp'];             

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% moved to clust_do_kcarta_driver.m
%% DO NOT TOUCH THESE LAST TWO LINES. EDIT set_convolver as needed
%% use_this_rtp0 = use_this_rtp;
%% set_convolver
%% DO NOT TOUCH THESE LAST TWO LINES. EDIT set_convolver as needed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
