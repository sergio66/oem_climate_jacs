%% layer_composition_rt.m
% Learned per-layer optical depth (small NN, SARTA-style local predictors)
% composed through the FINITE-LAYER analytic Schwarzschild solution
% (fixed, not learned) to produce TOA radiance -- trained end-to-end
% against your existing 38000-profile TOA radiance labels. No per-layer
% optical-depth truth needed.
%
% UNVERIFIED (no MATLAB available here) -- treat as a structural sketch
% to debug against, not working code. The composition loop and the
% dlarray broadcasting are the parts most likely to need iteration.
%
% Simplification in this first pass: reflected downwelling term uses a
% crude placeholder (a single representative atmospheric temperature),
% not a full downward composition pass. Flagged below -- upgrade once
% the upward-only version is validated, since it roughly doubles the
% loop complexity and you said this is a "let's see it work first" pass.

%% ---- band setup ----
% wavenumbersBand: (nChannelsBand x 1), fixed, this band's channels
% nLayers: number of finite layers, surface (k=1) to TOA (k=nLayers)
% nPredictors = 10 (your existing SARTA-style local predictors per layer)

addpath /home/sergio/git/matlabcode/COLORMAP

for ii = 1 : 12; figure(ii); clf; colormap jet; end

nSamples  = 38148;
nLevels   = 100;
nChannels = 2645;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% read in the KCARTA and rtp information

iUseActual_Profs_N_Rads = +1;

iJac = 101;  %% do SKT jac
iJac = 100;  %% do ColT jac
iJac = 2;    %% do CO2 jac
iJac = 6;    %% do CH4 jac
iJac = -1;   %% do radiances

nChannels0 = 2645;
freq_00 = instr_chans2645';

get_profiles_channels_radiances
wavenumbers = freq_00;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% used in do_main_setup_epochs_loop
iFitChan = -1; %% all channels 645-2745
iFitChan = -2; %% LW/MW channels 645-1645
iFitChan =  1; %% WV MW channels 1230 - 630 cm-1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ---- tau network parameters (shared across layers; layer index is an input) ----
hidden = 64;   % keep small -- this network only has to learn ONE layer's local
               % physics at a time, not the whole atmosphere at once


iHidden = 3; iNN = 256;     %% depth of hidden layers, and number of neurons/layer     rmse ~ 0.3 K train, val ~ 0.5K no improvement
iHidden = 4; iNN = 512;     %% depth of hidden layers, and number of neurons/layer     rmse ~ 0.2 K train, val ~ 0.5K WOW
iHidden = 2; iNN = 256;     %% depth of hidden layers, and number of neurons/layer   seems good               rmse ~ 0.5 K
iHidden = 2; iNN = 064;     %% depth of hidden layers, and number of neurons/layer   seems good               rmse ~ 0.5 K

iHidden = 2; iNN = hidden;  %% depth of hidden layers, and number of neurons/layer   seems good               rmse ~ 0.5 K

nLayersMax = 100;   % pad up to this; real N varies 75-100 per your terrain discussion
do_main_setup_epochs_loop

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

do_stats
do_linear_ridge_regression
