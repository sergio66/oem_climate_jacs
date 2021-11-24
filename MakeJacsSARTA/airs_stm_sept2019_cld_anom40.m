topts.iJacType = 100;   %% cld sky jacs!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% use_this_rtp = ['../MakeProfs/LATS40_avg_made_Mar29_2019_Clr/Desc//16DayAvg//timestep_' num2str(iTimeStep,'%03d') '_16day_avg.rp.rtp'];
%% ln -s ../MakeProfs/LATS40_avg_made_Mar29_2019_Clr/Desc//16DayAvg/ AnomSym

global iTimeStep

statsType = ['Desc_ocean'];   %% early Aug 2018
topts.fINPUT_rtp = ['AnomSymCld_with_seasonal/timestep_' num2str(iTimeStep,'%03d') '_16day_avg.rp.rtp']; %% profiles still have seasonal, trace gas messed up
topts.fINPUT_rtp = ['AnomSymCld_no_seasonal/timestep_' num2str(iTimeStep,'%03d') '_16day_avg.rp.rtp'];   %% profiles no have seasonal, trace gas fine

iNewOrOldSarta = -1;
iNewOrOldSarta = +1;
if iNewOrOldSarta == +1
  topts.savedir = ['SARTA_AIRSL1c_Anomaly365_16_CLD/' num2str(iTimeStep,'%03d') '/'];
elseif iNewOrOldSarta == -1
  topts.savedir = ['SARTA_AIRSL1c_Anomaly365_16_no_seasonal_OldSarta_smallpert_CLD/' num2str(iTimeStep,'%03d') '/'];
end

%if ~exist(topts.savedir)
%  mker = ['!/bin/mkdir ' topts.savedir];
%  eval(mker);
%end
