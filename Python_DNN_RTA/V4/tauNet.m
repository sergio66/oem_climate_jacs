%% ---- per-layer optical depth network ----
function tauFixed100 = tauNet(params, layerFeatures)
    % layerFeatures: dlarray 'CB', (nLayerFeatures x batch) -- the 10
    % SARTA predictors for this layer + a layer-position encoding

    %% ASSUMES 100 layers
  
    h1 = relu(fullyconnect(layerFeatures, params.tau_fc1_W, params.tau_fc1_b));
    h2 = relu(fullyconnect(h1, params.tau_fc2_W, params.tau_fc2_b));
    raw = fullyconnect(h2, params.tau_fc3_W, params.tau_fc3_b);   % (nChannelsBand x batch)
    tau = stableSoftplus(raw);                                     % enforce >= 0
end

