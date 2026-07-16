function S = fitSpectralPCA(data, nComponents)
    % data: (nSamples x nDim) -- works for vertical profiles or spectra
    [coeff, score, ~, ~, explained, mu] = pca(data, 'NumComponents', nComponents);
    S.coeff = coeff;                          % (nDim x nComponents)
    S.mu    = mu;                             % (1 x nDim)
    S.coeffMean = mean(score,1);
    S.coeffStd  = std(score,0,1) + 1e-12;
    S.explainedVarRatio = explained/100;      % fraction, length = min(nSamples,nDim)-1
end
