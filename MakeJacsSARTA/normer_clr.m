function normer = normer_clr(params)

%% till Aug 7, 2019
normer.dQ = 0.01;
normer.dT = 1;

%% after Aug 8, 2019, this may be too small
normer.dQ = 0.0001;
normer.dT = 0.01;

%% after Aug 13, 2019, this may be better
normer.dQ = 0.001;
normer.dQ = 0.005;
normer.dT = 0.01;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% *********** these are the normalizations we started with ************

normer.normCO2 = 2.2/370;   %% ppm/yr out of 370
normer.normO3  = 0.01;      %% frac/yr
normer.normN2O = 1.0/300;   %% ppb/yr outof 300
normer.normCH4 = 5/1860;    %% ppb/yr out of 1800
normer.normCFC = 1/1300;    %% ppt/yr out of 1300
normer.normST  = 0.1;       %% K/yr

normer.normCNG = 0.001; %% frac/yr = 0.1 g/m2 per year, avg = 100 g/m2
normer.normCSZ = 0.001; %% frac/yr = 0.1 um   per year, avg = 100 um
normer.normCPR = 0.001; %% mb/yr   = 1.0 mb   per year, avg = 500 mb

normer.normWV  = 0.01;  %% frac/yr
normer.normT   = 0.01;  %% K/yr

