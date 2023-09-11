
%%% ENCOMPASSING PERIOD OF DATA AVAILABLE AND SAVED
startdate = [2002 09 01]; stopdate = [2020 08 31]; i16daysSteps = 412;                       %% 2002/09 to 2020/08, testing that I get same results as Larrabee
startdate = [2002 09 01]; stopdate = [2021 06 31]; i16daysSteps = 429;                       %% 2002/09 to 2021/06
startdate = [2002 09 01]; stopdate = [2021 07 31]; i16daysSteps = 431;                       %% 2002/09 to 2021/07
startdate = [2002 09 01]; stopdate = [2021 08 31]; i16daysSteps = 433;                       %% 2002/09 to 2021/08 = 19 years, 433 steps **********
startdate = [2002 09 01]; stopdate = [2014 08 31]; i16daysSteps = 433;                       %% 2002/09 to 2014/09 = 273 steps, but use this extended encompassing period to do things fast

startdate = [2002 09 01]; stopdate = [2022 08 31]; i16daysSteps = 456;                       %% 2002/09 to 2022/08 = 20 years, 457 steps **********
startdate = [2002 09 01]; stopdate = [2022 09 07]; i16daysSteps = 457;                       %% 2002/09 to 2022/08 = 20 years, 457 steps **********

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% DEFINE PERIOD YOU ACTUALLY WANT, so can speed up things using SAVED data
startdate = [2002 09 01]; stopdate = [2021 08 31]; 
startdate = [2005 01 01]; stopdate = [2014 12 31];  % Joao wants 10 years
startdate = [2003 01 01]; stopdate = [2012 12 31];  % Joao wants 10 years
startdate = [2002 09 01]; stopdate = [2014 08 31];  % overlap with CMIP6/AMIP6
startdate = [2012 05 01]; stopdate = [2019 04 30];  % overlap with Suomi CrIS NSR

startdate = [2015 01 01]; stopdate = [2021 12 31]; % OCO2-CO2 overlap
startdate = [2002 09 01]; stopdate = [2022 09 07]; % 2002/09 to 2022/08 = 20 years, 457 steps **********

startdate = [2002 09 01]; stopdate = [2022 08 31]; % 20 years!
startdate = [2002 09 01]; stopdate = [2007 08 31]; % 05 years!
startdate = [2002 09 01]; stopdate = [2012 08 31]; % 10 years!
startdate = [2002 09 01]; stopdate = [2017 08 31]; % 15 years!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
