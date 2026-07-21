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

nChannelsBand = numel(wavenumbersBand);
nLayerFeatures = 10 + 1;   % 10 SARTA predictors + 1 layer-position encoding

%% ---- tau network parameters (shared across layers; layer index is an input) ----
hidden = 64;   % keep small -- this network only has to learn ONE layer's local
               % physics at a time, not the whole atmosphere at once
params = struct();
params.tau_fc1_W = dlarray(initWeights(hidden, nLayerFeatures));
params.tau_fc1_b = dlarray(zeros(hidden,1,'single'));
params.tau_fc2_W = dlarray(initWeights(hidden, hidden));
params.tau_fc2_b = dlarray(zeros(hidden,1,'single'));
params.tau_fc3_W = dlarray(initWeights(nChannelsBand, hidden));
params.tau_fc3_b = dlarray(zeros(nChannelsBand,1,'single'));

%% ---- stable softplus, to enforce tau >= 0 (physically required) ----
function y = stableSoftplus(x)
    % softplus(x) = log(1+exp(x)), numerically stable form
    y = max(x,0) + log(1 + exp(-abs(x)));
end

%% ---- per-layer optical depth network ----
function tau = tauNet(params, layerFeatures)
    % layerFeatures: dlarray 'CB', (nLayerFeatures x batch) -- the 10
    % SARTA predictors for this layer + a layer-position encoding
    h1 = relu(fullyconnect(layerFeatures, params.tau_fc1_W, params.tau_fc1_b));
    h2 = relu(fullyconnect(h1, params.tau_fc2_W, params.tau_fc2_b));
    raw = fullyconnect(h2, params.tau_fc3_W, params.tau_fc3_b);   % (nChannelsBand x batch)
    tau = stableSoftplus(raw);                                     % enforce >= 0
end

%% ---- Planck function, vectorized over channels AND batch ----
function B = planckRadianceVec(T, wavenumbersBand)
    % T: dlarray 'CB', (1 x batch); wavenumbersBand: plain (nChannelsBand x 1)
    c1 = 1.191042e-5; c2 = 1.4387752;
    nu = dlarray(single(wavenumbersBand));   % (nChannelsBand x 1)
    % broadcast: (nChannelsBand x 1) against (1 x batch) -> (nChannelsBand x batch)
    B = (c1*nu.^3) ./ (exp(c2*nu./T) - 1);
end

%% ---- finite-layer Schwarzschild composition (FIXED physics, not learned) ----
function R_TOA = composeRTUpward(params, layerFeaturesAll, layerTempAll, ...
                                   surfTemp, emis, mu, wavenumbersBand)
    % layerFeaturesAll: cell{nLayers}, each (10 x batch) -- your SARTA
    %                    predictors for that layer (pre-computed, not learned)
    % layerTempAll:     (nLayers x batch), plain dlarray -- layer temperatures,
    %                    used only for the Planck term (known physics input)
    % surfTemp: (1 x batch); emis: (nChannelsBand x batch), spectral;
    % mu: (1 x batch) = cos(viewAngle)

    nLayers = numel(layerFeaturesAll);
    batchSize = size(surfTemp, 2);

    % --- surface term: upwelling emission only (see downwelling note above) ---
    Bsurf = planckRadianceVec(surfTemp, wavenumbersBand);   % (nChannelsBand x batch)
    % crude downwelling placeholder: representative "mean atmosphere" temp
    Tdown = dlarray(single(250*ones(1,batchSize)), 'CB');    % PLACEHOLDER -- refine later
    Bdown = planckRadianceVec(Tdown, wavenumbersBand);
    I = emis .* Bsurf + (1 - emis) .* Bdown;                 % (nChannelsBand x batch)

    % --- propagate upward through each layer via the FIXED finite-layer solution ---
    for k = 1:nLayers
        layerIdxEncoded = dlarray(single((k/nLayers) * ones(1,batchSize)), 'CB');  % simple layer-position feature
        feats = cat(1, layerFeaturesAll{k}, layerIdxEncoded);   % (11 x batch)

        tau_k = tauNet(params, feats);                          % (nChannelsBand x batch), LEARNED
        t_k   = exp(-tau_k ./ mu);                               % (nChannelsBand x batch)
        B_k   = planckRadianceVec(layerTempAll(k,:), wavenumbersBand);  % KNOWN, from profile T

        I = I .* t_k + B_k .* (1 - t_k);   % <-- the finite-layer analytic solution, applied per channel
    end

    R_TOA = I;   % (nChannelsBand x batch)
end

%% ---- loss + gradients ----
function [loss, grads] = modelGradientsLayerRT(params, layerFeaturesAll, layerTempAll, ...
                                                  surfTemp, emis, mu, wavenumbersBand, Rtrue)
    Rpred = composeRTUpward(params, layerFeaturesAll, layerTempAll, ...
                              surfTemp, emis, mu, wavenumbersBand);
    loss = mean((Rpred - Rtrue).^2, 'all');   % straight MSE against your existing TOA radiance labels
    grads = dlgradient(loss, params);
end

%% ---- training loop call site (per batch) ----
% layerFeaturesAll_batch: cell{nLayers}, each (10 x miniBatchSize), sliced
%   from your precomputed per-layer predictor arrays for this batch's profiles
% layerTempAll_batch:     (nLayers x miniBatchSize)
% Rtrue_batch: dlarray 'CB', (nChannelsBand x miniBatchSize), your ACTUAL
%              stored KCARTA (or KCARTA-SARTA residual) radiance for this band
%
% [loss, grads] = dlfeval(@modelGradientsLayerRT, params, layerFeaturesAll_batch, ...
%                          layerTempAll_batch, surfTempBatch, emisBatch, muBatch, ...
%                          wavenumbersBand, Rtrue_batch);
% [params, avgGrad, avgGradSq] = adamupdate(params, grads, avgGrad, avgGradSq, iteration, learnRate);
