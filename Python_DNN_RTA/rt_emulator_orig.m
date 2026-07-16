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

clear; clc; close all;
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

nSamples  = 38000;
nLevels   = 100;
nChannels = 1000;
nPCA_BT   = 32;   % BT/radiance output PCA components
nPCA_T    = 12;   % temperature profile EOFs
nPCA_Q    = 15;   % humidity profile EOFs
nPCA_O3   = 15;   % ozone profile EOFs (more variable than T/Q -> keep more)
nPCA_emis = 8;    % emissivity spectrum PCA components

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

%% ------------------------------------------------------------------
%  1. Normalize the well-mixed gases + scalars
%  ------------------------------------------------------------------
% Well-mixed gases: shape barely varies -> represent with column mean only
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
% log-transform humidity and ozone before PCA (both span orders of
% magnitude and are closer to log-normal); temperature stays linear
Q_log  = log(max(Q, 1e-12));
O3_log = log(max(O3, 1e-12));

tPCA   = fitSpectralPCA(T,      nPCA_T);
qPCA   = fitSpectralPCA(Q_log,  nPCA_Q);
o3PCA  = fitSpectralPCA(O3_log, nPCA_O3);
emisPCA = fitSpectralPCA(emissivityRaw, nPCA_emis);
btPCA   = fitSpectralPCA(btRaw,         nPCA_BT);

tEOF    = encodeSpectral(tPCA,  T,      true);
qEOF    = encodeSpectral(qPCA,  Q_log,  true);
o3EOF   = encodeSpectral(o3PCA, O3_log, true);
emisEOF = encodeSpectral(emisPCA, emissivityRaw, true);
targetCoeffs = encodeSpectral(btPCA, btRaw, false);   % keep raw PCA scale for target

% Sanity check: how much variance is each basis actually capturing?
% (worth inspecting before you trust nPCA_T/Q/O3 above -- see note at
% bottom of script)
fprintf('T   EOF cum. variance kept: %.5f\n', sum(tPCA.explainedVarRatio(1:nPCA_T)));
fprintf('Q   EOF cum. variance kept: %.5f\n', sum(qPCA.explainedVarRatio(1:nPCA_Q)));
fprintf('O3  EOF cum. variance kept: %.5f\n', sum(o3PCA.explainedVarRatio(1:nPCA_O3)));

%% ------------------------------------------------------------------
%  3. Assemble full input feature matrix
%  ------------------------------------------------------------------
X = [tEOF, qEOF, o3EOF, scalarTensor, emisEOF];   % (nSamples x nFeatures)
Y = targetCoeffs;                                  % (nSamples x nPCA_BT)

nFeatures = size(X,2);
fprintf('Total input feature dimension: %d\n', nFeatures);

%% ------------------------------------------------------------------
%  4. Train / validation split
%  ------------------------------------------------------------------
nTrain = round(0.8*nSamples);
idxPerm = randperm(nSamples);
trainIdx = idxPerm(1:nTrain);
valIdx   = idxPerm(nTrain+1:end);

Xtrain = X(trainIdx,:);  Ytrain = Y(trainIdx,:);
Xval   = X(valIdx,:);    Yval   = Y(valIdx,:);

%% ------------------------------------------------------------------
%  5. Build MLP parameters (manual dlarray custom-training-loop style)
%  ------------------------------------------------------------------
hidden1 = 128;
hidden2 = 128;

params = struct();
params.fc1_W = dlarray(initWeights(hidden1, nFeatures));
params.fc1_b = dlarray(zeros(hidden1,1,'single'));
params.fc2_W = dlarray(initWeights(hidden2, hidden1));
params.fc2_b = dlarray(zeros(hidden2,1,'single'));
params.fc3_W = dlarray(initWeights(nPCA_BT, hidden2));
params.fc3_b = dlarray(zeros(nPCA_BT,1,'single'));

% fixed (non-trained) linear PCA decoder, for evaluation/reconstruction only
decoderW = dlarray(single(btPCA.coeff'));   % (nChannels x nPCA_BT) -> stored transposed for fullyconnect
decoderB = dlarray(single(btPCA.mu(:)));    % (nChannels x 1)

%% ------------------------------------------------------------------
%  6. Train
%  ------------------------------------------------------------------
miniBatchSize   = 256;
numEpochs       = 30;
learnRate       = 1e-3;

avgGrad   = [];
avgGradSq = [];
iteration = 0;

nTrainSamples = size(Xtrain,1);
numBatchesPerEpoch = floor(nTrainSamples / miniBatchSize);

for epoch = 1:numEpochs
    order = randperm(nTrainSamples);
    epochLoss = 0;

    for b = 1:numBatchesPerEpoch
        batchIdx = order((b-1)*miniBatchSize+1 : b*miniBatchSize);
        Xb = dlarray(single(Xtrain(batchIdx,:))', 'CB');  % (features x batch)
        Yb = dlarray(single(Ytrain(batchIdx,:))', 'CB');  % (nPCA_BT x batch)

        [loss, grads] = dlfeval(@modelGradients, params, Xb, Yb);

        iteration = iteration + 1;
        [params, avgGrad, avgGradSq] = adamupdate(params, grads, ...
            avgGrad, avgGradSq, iteration, learnRate);

        epochLoss = epochLoss + double(loss) * numel(batchIdx);
    end
    epochLoss = epochLoss / (numBatchesPerEpoch*miniBatchSize);

    % validation loss
    Xv = dlarray(single(Xval)', 'CB');
    Yv = dlarray(single(Yval)', 'CB');
    predVal = forwardMLP(params, Xv);
    valLoss = double(mean((predVal - Yv).^2, 'all'));

    if mod(epoch,5) == 0 || epoch == 1
        fprintf('epoch %3d  train MSE %.5f  val MSE %.5f\n', epoch, epochLoss, valLoss);
    end
end

%% ------------------------------------------------------------------
%  7. Evaluate: reconstruct full BT spectrum and check channel-wise error
%  ------------------------------------------------------------------
predCoeffsVal = extractdata(forwardMLP(params, dlarray(single(Xval)','CB')))';  % (nVal x nPCA_BT)
btReconVal    = decodeSpectral(btPCA, predCoeffsVal, false);                     % (nVal x nChannels)
btTrueVal     = btRaw(valIdx,:);

channelRMSE = sqrt(mean((btReconVal - btTrueVal).^2, 1));  % (1 x nChannels), Kelvin
fprintf('Validation BT RMSE: mean %.3f K, max %.3f K\n', mean(channelRMSE), max(channelRMSE));

%% ==================================================================
%  Local functions
%  ==================================================================

function bt = planckBT(radiance, wavenumberCm1)
    c1 = 1.191042e-5;
    c2 = 1.4387752;
    nu = wavenumberCm1;
    bt = c2*nu ./ log(1 + (c1*nu.^3)./radiance);
end

function radiance = btToRadiance(bt, wavenumberCm1)
    c1 = 1.191042e-5;
    c2 = 1.4387752;
    nu = wavenumberCm1;
    radiance = (c1*nu.^3) ./ (exp(c2*nu./bt) - 1);
end

function refSigma = makeReferenceSigmaGrid(nLevels, concentrateNearSurface)
    lin = linspace(0,1,nLevels);
    if concentrateNearSurface
        refSigma = lin.^1.5;
    else
        refSigma = lin;
    end
end

function vOut = interpProfileToSigmaGrid(pressure, values, refSigma)
    % pressure, values: raw profile, ordered TOA -> surface, arbitrary
    % length. refSigma: fixed target grid, e.g. makeReferenceSigmaGrid(100).
    pSurf = pressure(end);
    sigmaSrc = pressure / pSurf;
    vOut = interp1(sigmaSrc, values, refSigma, 'linear', 'extrap');
end

function S = fitSpectralPCA(data, nComponents)
    % data: (nSamples x nDim) -- works for vertical profiles or spectra
    [coeff, score, ~, ~, explained, mu] = pca(data, 'NumComponents', nComponents);
    S.coeff = coeff;                          % (nDim x nComponents)
    S.mu    = mu;                             % (1 x nDim)
    S.coeffMean = mean(score,1);
    S.coeffStd  = std(score,0,1) + 1e-12;
    S.explainedVarRatio = explained/100;      % fraction, length = min(nSamples,nDim)-1
end

function coeffs = encodeSpectral(S, data, standardize)
    coeffs = (data - S.mu) * S.coeff;         % (nSamples x nComponents)
    if standardize
        coeffs = (coeffs - S.coeffMean) ./ S.coeffStd;
    end
end

function data = decodeSpectral(S, coeffs, standardize)
    if standardize
        coeffs = coeffs .* S.coeffStd + S.coeffMean;
    end
    data = coeffs * S.coeff' + S.mu;
end

function W = initWeights(nOut, nIn)
    % He/Kaiming-style init, self-contained (no toolbox init function dependency)
    W = single(randn(nOut, nIn) * sqrt(2/nIn));
end

function Y = forwardMLP(params, X)
    % X: dlarray, format 'CB' (features x batch)
    h1 = relu(fullyconnect(X,  params.fc1_W, params.fc1_b));
    h2 = relu(fullyconnect(h1, params.fc2_W, params.fc2_b));
    Y  = fullyconnect(h2, params.fc3_W, params.fc3_b);   % linear output, PCA coeff scale
end

function [loss, grads] = modelGradients(params, X, Y)
    Ypred = forwardMLP(params, X);
    loss = mean((Ypred - Y).^2, 'all');
    grads = dlgradient(loss, params);
end
