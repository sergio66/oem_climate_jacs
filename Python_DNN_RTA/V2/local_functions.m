
%% ==================================================================
%  Local functions
%  ==================================================================

function bt = planckBT(radiance, wavenumberCm1)
    %% rad in mW/cm2/sr/cm-1
    c1 = 1.191042e-5;
    c2 = 1.4387752;
    nu = wavenumberCm1;
    bt = c2*nu ./ log(1 + (c1*nu.^3)./radiance);
end

function radiance = btToRadiance(bt, wavenumberCm1)
    %% rad in mW/cm2/sr/cm-1
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

