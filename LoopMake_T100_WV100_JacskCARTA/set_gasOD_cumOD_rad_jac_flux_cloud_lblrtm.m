%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%                      THESE ARE DEFAULT            %%%%%%%%%%
%%%%%%%%%%%                      THESE ARE DEFAULT            %%%%%%%%%%
%%%%%%%%%%%                      THESE ARE DEFAULT            %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f1 = 605; f2 = 2830; mm = -1;   %% dummies, needed for now

iDoRad = +0;             %% do special
iDoRad = +1;   gg = 3;   %% do individual gas OD, need to set the .nml template switches yourself (eg cumOD, cumTrans)
iDoRad = +2;             %% do cumulative gas OD
iDoRad = +3;   gg = 4;   %% do rads/jacs/fluxes and if needed, jacobian for this gas

iDoJac = +100; %% do column Jacobians
iDoJac = +1;   %% do Jacobians
iDoJac = -1;   %% do rads and mebbe ODs

%% see definitions of kFlux
iDoFlux = +5;  %% do ILR/OLR only
iDoFlux = +6;  %% do up/down fluxes
iDoFlux = +2;  %% do heating rates
iDoFlux = -1;  %% no fluxes

iDoCloud = +1;   %% yes TwoSlabclouds    %% bkcarta.x ALWAYS TURNS CLOUDS OFF
iDoCloud = +100; %% yes 100 layer clouds %% bkcarta.x ALWAYS TURNS CLOUDS OFF
iDoCloud = -1; %% no clouds

iDoLBLRTM = +9999; %% use kcarta_LBLRTM
iDoLBLRTM = +1; %% use LBLRTM optical depths for CO2
iDoLBLRTM = +2; %% use LBLRTM optical depths for CO2, O3
iDoLBLRTM = +3; %% use LBLRTM optical depths for CO2, O3, CH4
iDoLBLRTM = +4; %% use LBLRTM optical depths for CO2, O3, CH4, CO
iDoLBLRTM = +5; %% use LBLRTM optical depths for CO2, O3, CH4, CO, N2
iDoLBLRTM = +6; %% use LBLRTM optical depths for CO2, O3, CH4, CO, N2, O2

iDoLBLRTM = -1; %% use our optical depths
iDoLBLRTM = +3; %% use LBLRTM optical depths for CO2, O3, CH4
iDoLBLRTM = +2; %% use LBLRTM optical depths for CO2, CH4

iDo_rt_1vs43 = 43;  %% use LINEAR in tau RT (ala LBLRTM)
iDo_rt_1vs43 = -1;  %% use CONST  in tau RT (ala SARTA)

iHITRAN = 2008;
iHITRAN = 2012;
iHITRAN = 2016;   

iKCKD =  1;    %% MT CKD  1, about 2003
iKCKD =  6;    %% MT CKD  6, Sergio/Scott mod to MT CKD 1, about 2008
iKCKD = 25;    %% MT CKD 25, about 2015
iKCKD = 32;    %% MT CKD 32, about 2018

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%                      THESE ARE DEFAULT            %%%%%%%%%%
%%%%%%%%%%%                      THESE ARE DEFAULT            %%%%%%%%%%
%%%%%%%%%%%                      THESE ARE DEFAULT            %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%iDoLBLRTM = +3; %% use LBLRTM optical depths for CO2, O3, CH4
%iDoLBLRTM = +9999; %% use kcarta_LBLRTM
%iDo_rt_1vs43 = 43;  %% use LINEAR in tau RT (ala LBLRTM)

%iDoCloud = +100; %% yes 100 layer clouds %% bkcarta.x ALWAYS TURNS CLOUDS OFF
%iDoCloud = +1;   %% yes 2slab clouds     %% bkcarta.x ALWAYS TURNS CLOUDS OFF

%iDoJac = +1;   %% do Jacobians

%iDoRad = 0;     %% special
%iDoLBLRTM = +3; %% use LBLRTM optical depths for CO2, O3, CH4
%iDo_rt_1vs43 = 43;  %% use LINEAR in tau RT (ala LBLRTM)

%iDoLBLRTM = +8; %% use 8 ext ODs (1,103,3,4,5,6,9,12) when doing uncertainty originally
%iDoLBLRTM = +7; %% use 8 ext ODs (1,103,3,4,5,6,9     when doing uncertainty again
%iDoLBLRTM = -1; %% use our optical depths

%iDoJac = +1;   %% do Jacobians
%iDoRad = +3;   gg = 5;   %% do rads/jacs/fluxes and if needed, jacobian for this gas

iHITRAN = 2008; iDoLBLRTM = -1; %% use our optical depths
iHITRAN = 2008; iDoLBLRTM = 2;  %% use LBLRTM ODs
iHITRAN = 2012; iDoLBLRTM = -1; %% use our optical depths
iHITRAN = 2012; iDoLBLRTM = 2;  %% use LBLRTM ODs
iHITRAN = 2016; iDoLBLRTM = -1; %% use our optical depths
iHITRAN = 2016; iDoLBLRTM = 2;  %% use LBLRTM ODs
iHITRAN = 2016; iDoLBLRTM = 7;  %% the uncertainties, link to template_Qrad_HITRANunc.nml

iKCKD =  6; iHITRAN = 2008; iDoLBLRTM = -1; %% use our optical depths
iKCKD =  6; iHITRAN = 2012; iDoLBLRTM = -1; %% use our optical depths
iKCKD =  6; iHITRAN = 2016; iDoLBLRTM = -1; %% use our optical depths

iKCKD =  32; iHITRAN = 2016; iDoLBLRTM = 0; %% use UMBC ODs
iKCKD =  1;  iHITRAN = 2016; iDoLBLRTM = 2; %% use LBLRTM ODs
iKCKD =  6;  iHITRAN = 2016; iDoLBLRTM = 2; %% use LBLRTM ODs
iKCKD =  25; iHITRAN = 2016; iDoLBLRTM = 2; %% use LBLRTM ODs
iKCKD =  32; iHITRAN = 2016; iDoLBLRTM = 2; %% use LBLRTM ODs

%iDoJac = +100; %% do column Jacobians, please set things correctly in template_Qcoljacobian.nml

%iKCKD =  25; iHITRAN = 2016; iDoLBLRTM = 2; %% use LBLRTM ODs  %% for NOAA 2018 meeting
%iKCKD =  32; iHITRAN = 2016; iDoLBLRTM = 2; %% use LBLRTM ODs  %% for NOAA 2018 meeting
%iKCKD =  25; iHITRAN = 2012; iDoLBLRTM = 1; %% use LBLRTM ODs  %% for NOAA 2018 meeting
%iKCKD =  25; iHITRAN = 2016; iDoLBLRTM = 1; %% use LBLRTM ODs  %% for NOAA 2018 meeting and for testing quite a few of the CO2 versions
%iKCKD =  25; iHITRAN = 2015; iDoLBLRTM = 1; %% use LBLRTM ODs  %% for NOAA 2018 meeting + GEISA 2015
%% turn off XSEC for GEISA 2015 / HITRAN 2016 tests for NAOO 2018 meeting
%% iNxsec = -1 --> iNxsec = 0 and iKCKD =  25; iHITRAN = 2016/2015/2012; iDoLBLRTM = 1; %% use LBLRTM ODs for CO2 only

%% turn off/on CO2/WV continuum function : go into template_Qrad.nml and explicitly do this
%               iaaOverrideDefault(1,9) = +2 : do WV/CO2 continuum
%               iaaOverrideDefault(1,9) = +4 : do WV/N2  continuum	       
%               iaaOverrideDefault(1,9) = +6 : do WV/CO2 + WV/N2  continuum	       
%iaaOverride(1,9) = 0     %% default, all off

%iKCKD =  25; iHITRAN = 2016; iDoLBLRTM = 2; iDoCloud = +1; %% use LBLRTM ODs, do clouds for SNOs etc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iHITRAN == 2008
  kcartaexec = '/home/sergio/KCARTA/BIN/bkcarta.x.114';
  kcartaexec = '/home/sergio/KCARTA/BIN/bkcarta.x.115';
  kcartaexec = '/home/sergio/KCARTA/BIN/bkcarta.x.116';
  kcartaexec = '/home/sergio/KCARTA/BIN/bkcarta.x.116_hartmann';
  kcartaexec = '/home/sergio/KCARTA/BIN/bkcarta_H2008.x';
  kcartaexec = '/home/sergio/KCARTA/BIN/Oct10_2016/bkcarta_H2008.x';   %% OLD
  kcartaexec = '/home/sergio/KCARTA/BIN/bkcarta.x_385ppmv_H08';        %% NEWER
elseif iHITRAN == 2012  
  kcartaexec = '/home/sergio/KCARTA/BIN/kcarta.x_400ppmv';             %% can do cloudy calcs with this, H2012, v1.18
%  kcartaexec = '/home/sergio/KCARTA/BIN/bkcarta.x_10gasjac_10MP';     %% do CLR calcs, H2012; can do 10 jacs, 10 sets of MP DNE
%  kcartaexec = '/home/sergio/KCARTA/BIN/kcarta.x_f90_400ppmv';        %% the whole kit and caboodle. H12, v1.20
  kcartaexec = '/home/sergio/KCARTA/BIN/kcarta.x_400ppmv_test_Apr15_2016Absoft';
  kcartaexec = '/home/sergio/KCARTA/BIN/kcarta.x_400ppmv_test_Oct01_2016Ifort';
  kcartaexec = '/home/sergio/KCARTA/BIN/kcarta.x_400ppmv';             %% latest gen v1.18 code, allows raAltComprDirsScale
                                                                       %%   is UMBC CO2 messed up???
  kcartaexec = '/home/sergio/KCARTA/BIN/kcarta.x_f90_400ppmv';         %% latest gen v1.20 code, allows raAltComprDirsScale
elseif iHITRAN == 2016
  kcartaexec = '/home/sergio/KCARTA/BIN/kcarta.x_400ppmv_H16';         %% H16, v1.18, allows raAltComprDirsScale
  kcartaexec = '/home/sergio/KCARTA//BIN/kcarta.x_f90_400ppmv_H16';    %% H16, v1.20, allows raAltComprDirsScale
elseif iHITRAN == 2015
  kcartaexec = '/home/sergio/KCARTA//BIN/kcarta.x_f90_400ppmv_G15';    %% G15, v1.20, allows raAltComprDirsScale
end

if iDoFlux > 0 | iDoCloud > 0
  kcartaexec = '/home/sergio/KCARTA/BIN/kcarta.x';
  kcartaexec = '/home/sergio/KCARTA/BIN/kcarta.x_f90_400ppmv';    %% the whole kit and caboodle  
end

if iDoLBLRTM == 9999
  kcartaexec = '/home/sergio/KCARTA/BIN/kcarta.x_lblrtm12.4';
  disp('>>>>>>>>>>>> hope you chose CKD 25 !!!!! <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')
end

iDoDefault = +1;
iDoDefault = 2008;
iDoDefault = -1;

if iDoDefault == 2008
  iDoRad = +3;       %% do rads/jacs/fluxes
  iDoJac = -1;       %% do rads and mebbe ODs
  iDoFlux = -1;      %% no fluxes
  iDoCloud = -1;     %% no clouds
  iDoLBLRTM = -1;    %% use our optical depths
  iDo_rt_1vs43 = -1; %% const in tau radiative transfer
  kcartaexec = '/home/sergio/KCARTA/BIN/Oct10_2016/bkcarta_H2008.x';
  kcartaexec = '/home/sergio/KCARTA/BIN/bkcarta_H2008.x';
  disp('>>>>>>>>>>>> doing H2008 kcarta --- hope you chose CKD 1 or CKD 6 !!!!! <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')  
elseif iDoDefault == 1
  iDoRad = +3;       %% do rads/jacs/fluxes
  iDoJac = -1;       %% do rads and mebbe ODs
  iDoFlux = -1;      %% no fluxes
  iDoCloud = -1;     %% no clouds
  iDoLBLRTM = -1;    %% use our optical depths
  iDo_rt_1vs43 = -1; %% const in tau radiative transfer
  kcartaexec = '/home/sergio/KCARTA/BIN/kcarta.x';  
end

strWaterCloud = '/asl/s1/sergio/CLOUDS_MIEDATA/WATER250/water_405_2905_250';
strIceCloud   = '/asl/s1/sergio/CLOUDS_MIEDATA/CIRRUS_BRYANBAUM/v2013/ice_yangbaum_GHM_333_2980_forkcarta';

caComment = [date ' ' kcartaexec ' iDoRad=' num2str(iDoRad) ' iDoLBLRTM=' num2str(iDoLBLRTM) ' iDo_rt_1vs43=' num2str(iDo_rt_1vs43)];
caComment = [caComment ' iDoCloud=' num2str(iDoCloud)];
ooh = strfind(caComment,'/');
if length(ooh) > 0
  caComment = strrep(caComment, '/', '\/');
end
if length(caComment) > 120
  disp('warning : truncating caComment to 120 chars')
  caComment = caComment(1:120);
end
