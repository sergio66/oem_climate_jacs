%% layer_od_supervised_fit.m
% Direct supervised regression: local SARTA-style predictors -> effective
% layer optical depth, using targets built from convolved layer-to-space
% transmittances (NOT convolved OD -- avoids Jensen's-inequality bias
% from convolving a spiky, line-core-dominated quantity).
%
% Target construction (done upstream, from your KCARTA dump):
%   Tconv(k, channel)   = SRF-convolved layer-to-space transmittance
%                         from level k to TOA, for this profile
%   effOD(k, channel)   = -log( Tconv(k,channel) / Tconv(k+1,channel) )
%                       = log(Tconv(k+1,channel)) - log(Tconv(k,channel))
%
% This script assumes effOD and the 10 local predictors are ALREADY
% computed and reshaped into flat (profile,layer) rows -- see assembly
% section below for the expected shapes.
%
% UNVERIFIED (no MATLAB available here) -- structural sketch to debug
% against.

%% ---- expected inputs (from your own KCARTA-dump + convolution step) ----
% predictorsAll : (nProfiles x nLayers x 10)  -- your existing SARTA predictors
% effOD_All     : (nProfiles x nLayers x nChannelsBand) -- targets, from above
% layerTempAll  : (nProfiles x nLayers)        -- for reference/diagnostics only
%                 (NOT needed as a training input beyond whatever role
%                  it already plays among the 10 predictors)

[nProfiles, nLayers, nPred] = size(predictorsAll);
nChannelsBand = size(effOD_All, 3);

%% ---- numerical floor: avoid log(~0) for very opaque layers/levels ----
% Tconv can be extremely close to zero for low levels in strongly
% absorbing channels -- clip before any log() upstream, and sanity-check
% effOD_All for Inf/NaN here before proceeding.
badVals = ~isfinite(effOD_All);
fprintf('Non-finite effOD entries: %d / %d (%.3f%%)\n', ...
        sum(badVals(:)), numel(effOD_All), 100*mean(badVals(:)));
effOD_All(badVals) = NaN;   % mark explicitly; exclude these rows below rather
                             % than silently zeroing them (zero is a real,
                             % different physical value -- don't conflate)

%% ---- reshape (profile, layer) -> flat rows, IMPORTANT: split by PROFILE ----
% Splitting by row here would leak adjacent layers of the same profile
% across train/val (they're highly correlated -- same near-neighbor
% problem as the original profile-level split, just one level down).
nTrainProfiles = round(0.8 * nProfiles);
profOrder = randperm(nProfiles);
trainProf = profOrder(1:nTrainProfiles);
valProf   = profOrder(nTrainProfiles+1:end);

% add a layer-position feature (normalized index), same as before
layerPosFeature = repmat((1:nLayers)/nLayers, nProfiles, 1);   % (nProfiles x nLayers)

X_train = [];  Y_train = [];
for k = 1:nLayers
    rowPred = squeeze(predictorsAll(trainProf, k, :));           % (nTrainProfiles x 10)
    rowPos  = layerPosFeature(trainProf, k);                      % (nTrainProfiles x 1)
    rowY    = squeeze(effOD_All(trainProf, k, :));                 % (nTrainProfiles x nChannelsBand)

    validRows = all(isfinite(rowY), 2);   % drop rows with any non-finite target
    X_train = [X_train; rowPred(validRows,:), rowPos(validRows)]; %#ok<AGROW>
    Y_train = [Y_train; rowY(validRows,:)];                        %#ok<AGROW>
end

X_val = [];  Y_val = [];
for k = 1:nLayers
    rowPred = squeeze(predictorsAll(valProf, k, :));
    rowPos  = layerPosFeature(valProf, k);
    rowY    = squeeze(effOD_All(valProf, k, :));

    validRows = all(isfinite(rowY), 2);
    X_val = [X_val; rowPred(validRows,:), rowPos(validRows)]; %#ok<AGROW>
    Y_val = [Y_val; rowY(validRows,:)];                        %#ok<AGROW>
end

fprintf('Training rows (profile x layer): %d\n', size(X_train,1));
fprintf('Validation rows: %d\n', size(X_val,1));
fprintf('Input dim: %d, output dim (nChannelsBand): %d\n', size(X_train,2), size(Y_train,2));

%% ---- normalize inputs (z-score, fit on train only) ----
xMean = mean(X_train,1);  xStd = std(X_train,0,1) + 1e-12;
X_train = (X_train - xMean) ./ xStd;
X_val   = (X_val   - xMean) ./ xStd;

%% ---- small network: local problem, keep it small ----
nInput  = size(X_train,2);
hidden  = 64;

params = struct();
params.fc1_W = dlarray(initWeights(hidden, nInput));
params.fc1_b = dlarray(zeros(hidden,1,'single'));
params.fc2_W = dlarray(initWeights(hidden, hidden));
params.fc2_b = dlarray(zeros(hidden,1,'single'));
params.fc3_W = dlarray(initWeights(nChannelsBand, hidden));
params.fc3_b = dlarray(zeros(nChannelsBand,1,'single'));

function y = stableSoftplus(x)
    y = max(x,0) + log(1 + exp(-abs(x)));
end

function tau = forwardLayerOD(params, X)
    % X: dlarray 'CB', (nInput x batch)
    h1 = relu(fullyconnect(X,  params.fc1_W, params.fc1_b));
    h2 = relu(fullyconnect(h1, params.fc2_W, params.fc2_b));
    raw = fullyconnect(h2, params.fc3_W, params.fc3_b);
    tau = stableSoftplus(raw);   % OD >= 0, physically required
end

function [loss, grads] = modelGradientsLayerOD(params, X, Y)
    pred = forwardLayerOD(params, X);
    loss = mean((pred - Y).^2, 'all');
    grads = dlgradient(loss, params);
end

%% ---- straightforward training loop -- millions of rows, ~11 input dims,
%       this should behave nothing like the earlier 400-effective-dim problem ----
miniBatchSize = 1024;
numEpochs     = 30;
learnRate     = 1e-3;

avgGrad = []; avgGradSq = []; iteration = 0;
nTrainRows = size(X_train,1);
numBatchesPerEpoch = floor(nTrainRows / miniBatchSize);

for epoch = 1:numEpochs
    order = randperm(nTrainRows);
    epochLoss = 0;

    for b = 1:numBatchesPerEpoch
        batchIdx = order((b-1)*miniBatchSize+1 : b*miniBatchSize);
        Xb = dlarray(single(X_train(batchIdx,:))', 'CB');
        Yb = dlarray(single(Y_train(batchIdx,:))', 'CB');

        [loss, grads] = dlfeval(@modelGradientsLayerOD, params, Xb, Yb);
        iteration = iteration + 1;
        [params, avgGrad, avgGradSq] = adamupdate(params, grads, avgGrad, avgGradSq, iteration, learnRate);

        epochLoss = epochLoss + double(loss) * numel(batchIdx);
    end
    epochLoss = epochLoss / (numBatchesPerEpoch*miniBatchSize);

    Xv = dlarray(single(X_val)', 'CB');
    Yv = dlarray(single(Y_val)', 'CB');
    predVal = forwardLayerOD(params, Xv);
    valLoss = double(mean((predVal - Yv).^2, 'all'));

    if mod(epoch,5)==0 || epoch==1
        fprintf('epoch %3d  train MSE %.6f  val MSE %.6f\n', epoch, epochLoss, valLoss);
    end
end

%% ---- compare fitted per-layer OD against SARTA's own, once trained ----
% (this is the actual deliverable -- where SARTA's implied layer OD
% deviates from the KCARTA-truth-derived effective OD the network learned)
predODVal = extractdata(forwardLayerOD(params, dlarray(single(X_val)','CB')))';
% odDiffVsSARTA = predODVal - sartaODVal;   % wire in SARTA's own per-layer OD here
