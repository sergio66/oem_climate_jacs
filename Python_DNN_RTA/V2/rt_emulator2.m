%% rt_emulator.m
% MATLAB port of rt_emulator.py -- DNN emulator for a radiative transfer
% forward model.
%
% DESIGN (differs from the Python version in one deliberate way):
%   Instead of a 1D-CNN profile encoder, this version PCA/EOF-compresses
%   each vertical profile variable (T, Q, O3) separately, and represents
%   the nearly-well-mixed gases (CO2, CH4, N2O) with just their column
%   mean, before feeding everything into a plain MLP. This follows from
%   the observation that T/Q vertical structure -- especially aloft -- is
%   low-rank: a handful of EOFs captures nearly all the real variability,
%   so a learned convolutional encoder is solving a problem PCA already
%   solves in closed form, with fewer parameters and no risk of
%   overfitting the extra flexibility on ~38k profiles.
%
% Pipeline:
%   1. (Not shown here -- do this once from your raw variable-N profiles)
%      Interpolate each profile onto a fixed sigma grid (sigma = p/p_surf)
%      using interpProfileToSigmaGrid, since your N differs by terrain
%      (Everest ~75 levels/~325 hPa surface, ocean ~97/~1013 hPa,
%      Dead Sea ~100/~1067 hPa). Record true surface pressure as a scalar.
%   2. Log-transform gas concentrations, z-score everything.
%   3. Convert target radiance -> brightness temperature.
%   4. PCA-compress: T, Q, O3 profiles; emissivity spectrum (input);
%      BT spectrum (target, output side).
%   5. Train an MLP: [T_eof, Q_eof, O3_eof, gas scalars, surf scalars,
%      emissivity EOF] -> predicted BT PCA coefficients.
%   6. Reconstruct full M-channel BT (then radiance) via the fixed linear
%      PCA decoder.
%
% Requires: Deep Learning Toolbox (dlarray, fullyconnect, adamupdate)
%           Statistics and Machine Learning Toolbox (pca)

%clear; clc; close all;

addpath /home/sergio/git/matlabcode/COLORMAP

rng(0);

%% ------------------------------------------------------------------
%  0. Placeholder synthetic data -- replace with your real .mat loading
%  ------------------------------------------------------------------
% Expect your real data loaded as flat variables (not a struct -- see
% earlier discussion), already interpolated onto a common sigma grid:
%   T, Q, O3, CO2, CH4, N2O   : (nSamples x nLevels)
%   surfTemp, surfPressure, viewAngleSecant : (nSamples x 1)
%   radiance (or bt directly) : (nSamples x nChannels)
%   emissivity                : (nSamples x nChannels), same channel grid

nSamples  = 38148;
nLevels   = 100;
nChannels = 2645;
nPCA_BT   = 128;  % BT/radiance output PCA components
nPCA_T    = 20;   % temperature profile EOFs
nPCA_Q    = 20;   % humidity profile EOFs
nPCA_O3   = 15;   % ozone profile EOFs (more variable than T/Q -> keep more)
nPCA_CH4  = 5;    % ch4 profile EOFs (more variable than T/Q -> keep more)
nPCA_emis = 128;  % emissivity spectrum PCA components

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% read in the KCARTA and rtp information

iUseActual_Profs_N_Rads = +1;
iJac = 2;    %% do CO2 jac
iJac = 6;    %% do CH4 jac
iJac = 100;  %% do ColT jac
iJac = -1;   %% do radiances
iJac = 101;  %% do SKT jac

nChannels0 = 2645;
freq_00 = instr_chans2645';

if iUseActual_Profs_N_Rads < 0
  disp('faking reading in 38000 profiles and radiances')
  fake_profiles_channels_radiances
else
  disp('reading in 38000 profiles and radiances')
  disp('WARNING : if you change from eg iJac = -1 to iJac = 101, cut and paste these next 7 lines')  
  get_profiles_channels_radiances
  wavenumbers = freq_00;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
iALOTMP = 0;  %% all fovs
iALOTMP = 1;  %% land fovs
iALOTMP = 2;  %% ocean fovs
iALOTMP = 3;  %% tropical fovs
iALOTMP = 4;  %% tropical+midlat fovs
iALOTMP = 5;  %% polar fovs
iALOTMP = 6;  %% tropical ocean fovs
iALOTMP = 7;  %% tropical+midlat ocean fovs
iALOTMP = 8;  %% polar ocean fovs
iALOTMP = 9;  %% warm land  fovs where there are many samples ... hist(p.stemp(land) will tell you these limits)
iALOTMP = 10; %% warm ocean fovs where there are many samples ... hist(p.stemp(ocean) will tell you these limits)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iALOTMP = 1;  %% land fovs
iALOTMP = 2;  %% ocean fovs
iALOTMP = 10; %% warm ocean fovs where there are many samples ... hist(p.stemp(ocean) will tell you these limits)
iALOTMP = 6;  %% tropical ocean fovs

if iALOTMP == 0
  iFlag = 1 : length(p.stemp);
  quick_subset_samples

elseif iALOTMP == 1
  iFlag = find(px.landfrac == 1);
  quick_subset_samples
  
elseif iALOTMP == 9
  %% sss = find(p.landfrac == 1);; ist(p.stemp(sss),100)
  iFlag = find(px.landfrac == 1 & p.stemp >= 240 & p.stemp <= 310);
  quick_subset_samples
  
elseif length(intersect(iALOTMP,[2 6 7 8 10])) == 1

  if iALOTMP == 2
    iFlag = find(px.landfrac == 0);
  elseif iALOTMP == 6
    iFlag = find(px.landfrac == 0 & abs(p.rlat) <= 30);
  elseif iALOTMP == 7
    iFlag = find(px.landfrac == 0 & abs(p.rlat) <= 60);
  elseif iALOTMP == 8
    iFlag = find(px.landfrac == 0 & abs(p.rlat) > 60);
  elseif iALOTMP == 10
    iFlag = find(px.landfrac == 0 & abs(p.rlat) <= 60 & p.stemp >= 273 & p.stemp < 305);
  end
  quick_subset_samples
  
end

whos freq0 emissivityRaw0  btRaw radianceRaw_00 T Q co2_500mb surfTemp localAngleSecant

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% get ready and run fitting
%% set up scalars, and PCA/EOOF of t(p),q(p),O3(p)

nPCA_T    = 10;   % temperature profile EOFs
nPCA_Q    = 10;   % humidity profile EOFs
nPCA_O3   = 15;   % ozone profile EOFs (more variable than T/Q -> keep more)
nPCA_emis = 64;   % emissivity spectrum PCA components
nPCA_BT   = 64;   % BT/radiance output PCA components

nPCA_BT   = 256;  % BT/radiance output PCA components
nPCA_T    = 20;   % temperature profile EOFs
nPCA_Q    = 20;   % humidity profile EOFs
nPCA_O3   = 20;   % ozone profile EOFs (more variable than T/Q -> keep more)
nPCA_CH4  = 5;    % ch4 profile EOFs (more variable than T/Q -> keep more)
nPCA_CO2  = 5;    % ch4 profile EOFs (more variable than T/Q -> keep more)
nPCA_emis = 256;  % emissivity spectrum PCA components

iScalar = 0;  %% orig : co2/n2o/ch4 at 500 mb
iScalar = 1;  %% new  : n2o at 500 mb, co2/ch4 profiles

iHidden = 3; iNN = 128;  %% depth of hidden layers, and number of neurons/layer     rmse ~ 0.3 K train, val ~ 0.5K
iHidden = 3; iNN = 256;  %% depth of hidden layers, and number of neurons/layer     rmse ~ 0.3 K train, val ~ 0.5K no improvement

iHidden = 2; iNN = 256;  %% depth of hidden layers, and number of neurons/layer   seems good               rmse ~ 0.5 K
iHidden = 2; iNN = 128;  %% depth of hidden layers, and number of neurons/layer   too few                  rmse ~ 2 K
iHidden = 2; iNN = 512;  %% depth of hidden layers, and number of neurons/layer   no improvement from 512  rmse ~ 0.3 K train, val ~ 0.5K

iHidden = 4; iNN = 128;  %% depth of hidden layers, and number of neurons/layer     rmse ~ 0.4 K train, val ~ 0.6K
iHidden = 4; iNN = 256;  %% depth of hidden layers, and number of neurons/layer     rmse ~ 0.2 K train, val ~ 0.4K
iHidden = 4; iNN = 512;  %% depth of hidden layers, and number of neurons/layer     rmse ~ 0.2 K train, val ~ 0.5K WOW

iStd = +1;   %% do     standardize, PCA will be similar for all
iStd = -1;   %% do not standardize, PCA get be large for first 203 compoentns which dominate

%% this is to weight the observations according to SKT histogram; see epoch_loop.m
useWeighting = true;   % flip this to false for the baseline comparison

set_up_PCA

do_main_setup_epochs_loop

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% check answers and stats

do_stats
do_linear_ridge_regression

do_per_profile_breakdown       %% also eric suggestion to see if SKT,SPRES,MMW,ANLE are culprints

do_check_neighbor_closeness


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
