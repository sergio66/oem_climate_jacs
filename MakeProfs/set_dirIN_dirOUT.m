%% you need to set the location of the input statlat files, and output dir
%% also set iName_has_mean = +1 if names in the statlat files are eg a.gas1_mean,a.spres_mean
%% also set iName_has_mean = -1 if names in the statlat files are eg a.gas1     ,a.spres

%% Oct 2018
statsType = ['Desc_ocean'];   %% early Aug 2018
statsType = ['Desc'];         %% late  Aug 2018
dirIN  = ['/home/strow/Work/Airs/Random/Data/' statsType '/'];
%% dirOUT = ['LATS40_avg/' statsType '/'];
dirOUT = ['LATS40_avg_made_Jan23_2019/' statsType '/'];
iName_has_mean = +1; %% oct 2018 AIRS STM

%% Apr 2019 allsky
statsType = ['Desc'];       
dirIN  = ['/home/strow/Work/Airs/Random/Data/' statsType '/'];
dirOUT = ['LATS40_avg_made_Mar29_2019/' statsType '/'];
iName_has_mean = +1; %% oct 2018 AIRS STM

%% Apr 2019 clrsky
statsType = ['Desc'];       
dirIN  = ['/home/strow/Work/Airs/Stability/Data/' statsType '/'];
dirOUT = ['LATS40_avg_made_Mar29_2019_Clr/' statsType '/'];
iName_has_mean = +1; %% oct 2018 AIRS STM

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Apr 2019 clrsky with mmw rates, also used for anomalies
statsType = ['Desc'];       
dirIN  = ['/home/strow/Work/Airs/Stability/Data/' statsType '/'];
dirOUT = ['LATS40_avg_made_Mar29_2019_Clr/' statsType '/'];
iName_has_mean = +1; %% oct 2018 AIRS STM

%% June 2019 IASI 11 years clrsky with mmw rates
statsType = ['Desc'];       
dirIN  = ['/home/strow/Work/Iasi/Stability/Data/' statsType '/'];
dirOUT = ['LATS40_avg_IASI_11year/' statsType '/'];
iName_has_mean = +1; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Apr 2019 clrsky with mmw rates, also used for anomalies, only has CFC11
statsType = ['Desc'];       
dirIN  = ['/home/strow/Work/Airs/Stability/Data/' statsType '/'];
dirOUT = ['LATS40_avg_made_Mar29_2019_Clr/' statsType '/'];
iName_has_mean = +1; %% oct 2018 AIRS STM

%% Aug 2019 clrsky with mmw rates, also used for anomalies, has CFC11 and CFC12
statsType = ['Desc'];       
dirIN  = ['/home/strow/Work/Airs/Stability/Data/' statsType '/'];
dirOUT = ['LATS40_avg_made_Aug20_2019_Clr/' statsType '/'];
iName_has_mean = +1; %% oct 2018 AIRS STM

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Apr 2019 allsky with mmw rates, also used for anomalies
statsType = ['Desc'];       
dirIN  = ['/home/strow/Work/Airs/Random/Data/' statsType '/'];
dirOUT = ['LATS40_avg_made_June14_2019_Cld/' statsType '/'];

%% Apr + Aug 2019 allsky desc ocean; this one has problems with cfrac from Jan 2018 onwards
statsType = ['Desc_ocean'];       
dirIN  = ['/home/strow/Work/Airs/Random/Data/' statsType '/'];
dirOUT = ['LATS40_avg_made_Aug15_2019_Cld/' statsType '/'];
iName_has_mean = +1; %% oct 2018 AIRS STM

%% Apr + Aug 2019 allsky desc ocean; this one has fixed problems with cfrac from Jan 2018 onwards, also has CFC12
statsType = ['Desc_ocean_new'];       
statsType = ['Desc_ocean'];       
dirIN  = ['/home/strow/Work/Airs/Random/Data/' statsType '/'];
dirOUT = ['LATS40_avg_made_Aug22_2019_Cld/' statsType '/'];
iName_has_mean = +1; %% oct 2018 AIRS STM

%% Apr + Aug 2019 allsky desc ocean; this one has fixed problems with cfrac from Jan 2018 onwards, also has CFC12
statsType = ['Desc'];       
dirIN  = ['/home/strow/Work/Airs/Random/Data/' statsType '/'];
dirOUT = ['LATS40_avg_made_Sept21_2019_Cld/' statsType '/'];
iName_has_mean = +1; %% oct 2018 AIRS STM

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% this is for CRIS LO RES !!!!
statsType = ['Desc'];       
dirIN  = ['/home/strow/Work/Cris/Stability/Data/' statsType '/'];
dirOUT = ['CLO_LAT40_avg_made_Dec2019_Clr/' statsType '/'];
iName_has_mean = +1; %% oct 2018 AIRS STM
