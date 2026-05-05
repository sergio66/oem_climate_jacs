%% (A)
%% first   mkdir /home/sergio/nogit/TILES/
%%         mkdir /home/sergio/nogit/TILES/MixedUpNames
%% then    cd /home/sergio/git/oem_climate_jacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/
%%         ln -s /home/sergio/nogit/TILES/MixedUpNames    DATAObsStats_StartSept2002
%% then    cd Code_For_HowardObs_TimeSeries
%%         ls -lt ../DATAObsStats_StartSept2002

%% then run this code by cut and paste,  or run   "mker_dirs_64lats_72lons.m" from Code_For_HowardObs_TimeSeries
for junkLat = 1 : 64
  mker = ['!mkdir ../DATAObsStats_StartSept2002/LatBin' num2str(junkLat,'%02d') '/'];
  eval(mker);
  for junkLon = 1 : 72
    mker = ['!mkdir ../DATAObsStats_StartSept2002/LatBin' num2str(junkLat,'%02d') '/LonBin' num2str(junkLon,'%02d') ];
    eval(mker)
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% (B)
%% first   mkdir /home/sergio/nogit/TILES/
%%         mkdir /home/sergio/nogit/TILES/CorrectNames
%% then    cd /home/sergio/git/oem_climate_jacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/
%%         ln -s /home/sergio/nogit/TILES/CorrectNames    DATAObsStats_StartSept2002_CORRECT_LatLon
%% then    cd Code_For_HowardObs_TimeSeries
%%         ls -lt ../DATAObsStats_StartSept2002_CORRECT_LatLon

