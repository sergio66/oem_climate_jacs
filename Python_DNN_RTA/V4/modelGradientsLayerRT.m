%% ---- loss + gradients ----
function [loss, grads] = modelGradientsLayerRT(params, layerFeaturesAll, layerTempAll, ...
                                                  surfTemp, emis, mu, wavenumbersBand, Rtrue)
    Rpred = composeRTUpward(params, layerFeaturesAll, layerTempAll, ...
                              surfTemp, emis, mu, wavenumbersBand);
    loss = mean((Rpred - Rtrue).^2, 'all');   % straight MSE against your existing TOA radiance labels
    grads = dlgradient(loss, params);
end

