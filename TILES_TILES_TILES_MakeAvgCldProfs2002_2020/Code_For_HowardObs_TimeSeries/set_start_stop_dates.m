%% ENCOMPASSING PERIOD OF DATA AVAILABLE AND SAVED
%% so for example load in data from tile_fits_quantiles.m :lati,loni =  1  1  
%% loading  << ../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin01/LonBin01/iQAX_3_summarystats_LatBin01_LonBin01_timesetps_001_479_V1.mat >> with 479 i16daysSteps

%% eventually please look at eg /home/sergio/MATLABCODE/oem_pkg_run/FIND_NWP_MODEL_TRENDS/driver_check_WV_T_RH_ERA5_geo_and_spectral_rates2.m     which has
%%   YMStart = [2018 09];  YMEnd = [2022 08];  %% last 4 years whose trends you want
%%   iYS = 2002; iYE = 2022;                   %% NOTE THIS IS JUST HOW MUCH DATA YOU HAVE in ERA5 dirs

startdateMaster = [2002 09 01]; stopdateMaster = [2020 08 31]; i16daysSteps = 412;                       %% 2002/09 to 2020/08, testing that I get same results as Larrabee
startdateMaster = [2002 09 01]; stopdateMaster = [2021 06 31]; i16daysSteps = 429;                       %% 2002/09 to 2021/06
startdateMaster = [2002 09 01]; stopdateMaster = [2021 07 31]; i16daysSteps = 431;                       %% 2002/09 to 2021/07
startdateMaster = [2002 09 01]; stopdateMaster = [2021 08 31]; i16daysSteps = 433;                       %% 2002/09 to 2021/08 = 19 years, 433 steps **********
startdateMaster = [2002 09 01]; stopdateMaster = [2014 08 31]; i16daysSteps = 433;                       %% 2002/09 to 2014/09 = 273 steps, but use this extended encompassing period to do things fast

startdateMaster = [2002 09 01]; stopdateMaster = [2022 08 31]; i16daysSteps = 456;                       %% 2002/09 to 2022/08 = 20   years, 457 steps **********
startdateMaster = [2002 09 01]; stopdateMaster = [2022 09 07]; i16daysSteps = 457;                       %% 2002/09 to 2022/08 = 20   years, 457 steps **********
startdateMaster = [2002 09 01]; stopdateMaster = [2023 08 25]; i16daysSteps = 479;                       %% 2002/09 to 2023/08 = 21   years, 479 steps **********
startdateMaster = [2002 09 01]; stopdateMaster = [2023 12 29]; i16daysSteps = 487;                       %% 2002/09 to 2023/12 = 21.3 years, 487 steps **********

startdateMaster = [2002 09 01]; stopdateMaster = [2024 06 24]; i16daysSteps = 498;                       %% 2002/09 to 2024/06 = 22.5 years, 498 steps **********

disp(' ')
fprintf(1,'cluster_loop_make_correct_timeseriesV2.m : set_start_stop_dates.m : MASTER start/stop date = %4i/%02i/%02i to %4i/%02i/%02i \n',startdateMaster,stopdateMaster)
fprintf(1,'cluster_loop_make_correct_timeseriesV2.m : set_start_stop_dates.m : MASTER start/stop date = %4i/%02i/%02i to %4i/%02i/%02i \n',startdateMaster,stopdateMaster)
fprintf(1,'cluster_loop_make_correct_timeseriesV2.m : set_start_stop_dates.m : MASTER start/stop date = %4i/%02i/%02i to %4i/%02i/%02i \n',startdateMaster,stopdateMaster)
disp(' ')

%% clear i16daysSteps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% DEFINE PERIOD YOU ACTUALLY WANT, so can speed up things using SAVED data
%% to make trends saved in ./DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin01/LonBin02/iQAX_3_fits_LonBin02_LatBin01_V1_200800010001_202200120031_TimeSteps_122_464_X342.mat

startdate = [2002 09 01]; stopdate = [2021 08 31];  % 19 years! *** THIS IS THE MASTER BLASTER
startdate = [2005 01 01]; stopdate = [2014 12 31];  % Joao wants 10 years
startdate = [2003 01 01]; stopdate = [2012 12 31];  % Joao wants 10 years
startdate = [2002 09 01]; stopdate = [2014 08 31];  % overlap with CMIP6/AMIP6
startdate = [2012 05 01]; stopdate = [2019 04 30];  % overlap with Suomi CrIS NSR
startdate = [2002 09 01]; stopdate = [2010 08 31];  % 8 years!

startdate = [2002 09 01]; stopdate = [2022 08 31];  % 20 years! *** THIS IS THE MASTER BLASTER
startdate = [2015 01 01]; stopdate = [2021 12 31];  % OCO2-CO2 overlap
startdate = [2002 09 01]; stopdate = [2022 09 07];  % 2002/09 to 2022/08 = 20 years, 457 steps **********
startdate = [2002 09 01]; stopdate = [2018 08 31];  % this is the 16 year span we used for AIRS stabiliy
startdate = [2018 09 01]; stopdate = [2022 08 31];  % so now use the 4 years after that to check stability
startdate = [2002 09 01]; stopdate = [2007 08 31];  % 05 years!   %% trends paper appendix
startdate = [2002 09 01]; stopdate = [2012 08 31];  % 10 years!   %% trends paper appendix
startdate = [2002 09 01]; stopdate = [2017 08 31];  % 15 years!   %% trends paper appendix
startdate = [2002 09 01]; stopdate = [2022 08 31];  % 20 years!   %% trends paper, and Sounder STM 2023

startdate = [2002 09 01]; stopdate = [2023 08 25];  % 21 years! *** THIS IS THE MASTER BLASTER
% I would only need ascending/descending nodes monthly L3 grids over the study period 2008-2021 (or 2022)
startdate = [2008 01 01]; stopdate = [2022 12 31];  % sarah.safieddine@latmos.ipsl.fr, Dec 20, 2023
startdate = [2002 09 01]; stopdate = [2024 01 01];  % 22.3 years! %% Joao at JPL wants this

startdate = [2020 07 01]; stopdate = [2024 06 30];  % 4 hot years
startdate = [2002 09 01]; stopdate = [2024 06 30];  % 22.5 years! %% AIRS STM Fall 2024 *** THIS IS THE MASTER BLASTER

disp(' ')
fprintf(1,'Code_for_TileTrends/clust_tile_fits_quantiles.m : set_start_stop_dates.m : REFINED SUBSET start/stop date = %4i/%02i/%02i to %4i/%02i/%02i \n',startdate,stopdate)
fprintf(1,'Code_for_TileTrends/clust_tile_fits_quantiles.m : set_start_stop_dates.m : REFINED SUBSET start/stop date = %4i/%02i/%02i to %4i/%02i/%02i \n',startdate,stopdate)
fprintf(1,'Code_for_TileTrends/clust_tile_fits_quantiles.m : set_start_stop_dates.m : REFINED SUBSET start/stop date = %4i/%02i/%02i to %4i/%02i/%02i \n',startdate,stopdate)
disp(' ')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
