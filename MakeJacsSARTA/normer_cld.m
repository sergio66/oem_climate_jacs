function normer = normer_cld(params)

normer.dQ = 0.01;
normer.dT = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

normer.normWV  = 0.01;  %% frac/yr
normer.normT   = 0.1;  %% K/yr

normer.normWV  = 0.1;  %% frac/yr
normer.normT   = 0.5;  %% K/yr

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if params.iJacType == 4 | params.iJacType == 5 | params.iJacType == 41
  %% used these for AIRS cloud jacs
  %% https://www.esrl.noaa.gov/gmd/ccgg/trends/full.html  co2 ppm : 370 (in 2002) to 410 (in 2018)  
  %% https://www.esrl.noaa.gov/gmd/ccgg/trends_ch4/       ch4 ppb : 1780 (in 2002) to 1850 (in 2018)
  %% https://www.esrl.noaa.gov/gmd/hats/combined/N2O.html n2o ppb : 315 (in 2002) to 330 (in 2018)  
  normer.normCO2 = 1/370;   %% ppm/yr out of 370  since we do RRTM fluxes starting from 370 ppm
  normer.normO3  = 1;       %% frac/yr
  normer.normN2O = 1/320;   %% ppb/yr out of 320  may as well start from a better value
  normer.normCH4 = 1/1800;  %% ppb/yr out of 1800 may as well stick to this
  normer.normCFC = 1/1300;  %% ppt/yr out of 1300
  normer.normST  = 1;       %% K/yr

  normer.normCNG = 1/50;  %% frac/yr = 0.1 g/m2 per year, avg = 50  g/m2
  normer.normCSZ = 1/100; %% frac/yr = 0.1 um   per year, avg = 100 um
  normer.normCPR = 1/100; %% mb/yr   = 1.0 mb   per year, avg = 500 mb

  normer.normWV  = 1;  %% frac/yr
  normer.normT   = 1;  %% K/yr

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else

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

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
