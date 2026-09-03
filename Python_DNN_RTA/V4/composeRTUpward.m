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
    Tdown = dlarray(single(250*ones(1,batchSize)), 'CB');    % PLACEHOLDER -- refine later of 250K
    Tdown = surfTemp - 5;                           
    Bdown = planckRadianceVec(Tdown, wavenumbersBand);

    I = emis .* Bsurf + (1 - emis)/pi .* Bdown;                 % (nChannelsBand x batch)

    % --- propagate upward through each layer via the FIXED finite-layer solution ---
    for k = 1:nLayers
        	  
      layerIdxEncoded = dlarray(single((k/nLayers) * ones(1,batchSize)), 'CB');  % simple layer-position feature
      %k/nLayers
      %batchSize
      %wah = layerFeaturesAll{k};
      %whos layerIdxEncoded wah
      feats = cat(1, layerFeaturesAll{k}, layerIdxEncoded);   % (11 x batch)

      tau_k = tauNet(params, feats);                          % (nChannelsBand x batch), LEARNED
      t_k   = exp(-tau_k ./ mu);                               % (nChannelsBand x batch)
      B_k   = planckRadianceVec(layerTempAll(k,:), wavenumbersBand);  % KNOWN, from profile T

      I = I .* t_k + B_k .* (1 - t_k);   % <-- the finite-layer analytic solution, applied per channel
    end

    R_TOA = I;   % (nChannelsBand x batch)
end

