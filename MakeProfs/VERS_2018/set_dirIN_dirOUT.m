%% you need to set the location of the input statlat files, and output dir
%% also set iName_has_mean = +1 if names in the statlat files are eg a.gas1_mean,a.spres_mean
%% also set iName_has_mean = -1 if names in the statlat files are eg a.gas1     ,a.spres

dirIN = '/home/strow/Work/Airs/Stability/Data/Desc/';     dirOUT = 'LATS40_avg/';  iName_has_mean = +1; %% apr 2017 AIRS STM

statsType = ['Desc_ocean'];   %% early Aug 2018
statsType = ['Desc'];         %% late  Aug 2018
dirIN  = ['/home/strow/Work/Airs/Random/Data/' statsType '/'];
dirOUT = ['LATS40_avg/' statsType '/'];
iName_has_mean = +1; %% oct 2018 AIRS STM