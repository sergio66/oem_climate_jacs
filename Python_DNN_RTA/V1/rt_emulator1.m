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
nPCA_BT   = 32;   % BT/radiance output PCA components
nPCA_T    = 20;   % temperature profile EOFs
nPCA_Q    = 20;   % humidity profile EOFs
nPCA_O3   = 15;   % ozone profile EOFs (more variable than T/Q -> keep more)
nPCA_emis = 100;  % emissivity spectrum PCA components

iUseActual_Profs_N_Rads = +1;
if iUseActual_Profs_N_Rads < 0
  freq = instr_chans2645;
  T   = randn(nSamples, nLevels)*20 + 250;
  Q   = abs(randn(nSamples, nLevels)) + 1e-3;
  O3  = abs(randn(nSamples, nLevels))*1e-6 + 1e-8;
  CO2 = 400*ones(nSamples, nLevels)   + randn(nSamples,1);
  CH4 = 1.8*ones(nSamples, nLevels)   + 0.05*randn(nSamples,1);
  N2O = 0.3*ones(nSamples, nLevels)   + 0.01*randn(nSamples,1);
  
  surfTemp        = randn(nSamples,1)*15 + 288;
  surfPressure    = 325 + (1067-325)*rand(nSamples,1);   % hPa; varies with terrain
  viewAngleSecant = 1 ./ cos(rand(nSamples,1)*1.0);
  
  wavenumbers   = linspace(650, 1200, nChannels);
  radianceRaw   = 50 + 100*rand(nSamples, nChannels);
  btRaw         = planckBT(radianceRaw, wavenumbers);
  emissivityRaw = min(max(0.95 + 0.03*randn(nSamples, nChannels), 0.5), 1.0);
else
  disp('reading in 38000 profiles and radiances')
  get_profiles_channels_radiances
  wavenumbers = freq;
  btRaw       = planckBT(radianceRaw, wavenumbers);  
end

%% ------------------------------------------------------------------
%  1. Normalize the well-mixed gases + scalars
%  ------------------------------------------------------------------
% Well-mixed gases: shape barely varies -> represent with column mean only
disp('Stage 1 : normalize')
co2Scalar = mean(CO2, 2);
ch4Scalar = mean(CH4, 2);
n2oScalar = mean(N2O, 2);

scalarNames = {'surfTemp','surfPressure','viewAngleSecant', ...
               'co2Scalar','ch4Scalar','n2oScalar'};
rawScalars  = struct('surfTemp',surfTemp,'surfPressure',surfPressure, ...
                      'viewAngleSecant',viewAngleSecant, ...
                      'co2Scalar',co2Scalar,'ch4Scalar',ch4Scalar,'n2oScalar',n2oScalar);

scalarStats = struct();
scalarTensor = zeros(nSamples, numel(scalarNames));
for k = 1:numel(scalarNames)
    name = scalarNames{k};
    x = rawScalars.(name);
    scalarStats.(name).mean = mean(x);
    scalarStats.(name).std  = std(x) + 1e-12;
    scalarTensor(:,k) = (x - scalarStats.(name).mean) / scalarStats.(name).std;
end

%% ------------------------------------------------------------------
%  2. PCA-compress T, Q, O3 profiles; emissivity input; BT target
%  ------------------------------------------------------------------
disp('Stage 2 : PCA compress')
% log-transform humidity and ozone before PCA (both span orders of
% magnitude and are closer to log-normal); temperature stays linear
Q_log  = log(max(Q, 1e-12));
O3_log = log(max(O3, 1e-12));

tPCA   = fitSpectralPCA(T,      nPCA_T);
qPCA   = fitSpectralPCA(Q_log,  nPCA_Q);
o3PCA  = fitSpectralPCA(O3_log, nPCA_O3);

tEOF    = encodeSpectral(tPCA,  T,      true);
qEOF    = encodeSpectral(qPCA,  Q_log,  true);
o3EOF   = encodeSpectral(o3PCA, O3_log, true);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

emissivityRaw0 = emissivityRaw;
btRaw0         = btRaw;
freq0          = freq;
btTrueVal0     = btTrueVal;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
iHiden = 3;
iHiden = 2;
do_main_setup_epochs_loop
do_stats
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
