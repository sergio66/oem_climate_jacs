% per-profile: layerFeaturesAll{k} and layerTempAll(k,:) for k > actualN(profile)
% get set to values that force tau=0 -- simplest is a dedicated mask, applied
% AFTER tauNet rather than relying on the input features alone to force tau=0:

function tau = forwardLayerODMasked(params, layerFeatures, validMask)
    % layerFeatures: (11 x batch); validMask: (1 x batch), 1=real layer, 0=padding
    raw = fullyconnect(relu(fullyconnect(layerFeatures, params.tau_fc1_W, params.tau_fc1_b)), ...
                        params.tau_fc2_W, params.tau_fc2_b);
    raw = fullyconnect(raw, params.tau_fc3_W, params.tau_fc3_b);
    tau = stableSoftplus(raw);
    tau = tau .* validMask;   % force tau=0 for padded/nonexistent layers -- physically "no atmosphere"
end

