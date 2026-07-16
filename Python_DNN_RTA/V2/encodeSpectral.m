function coeffs = encodeSpectral(S, data, standardize)
    coeffs = (data - S.mu) * S.coeff;         % (nSamples x nComponents)
    if standardize
        coeffs = (coeffs - S.coeffMean) ./ S.coeffStd;
    end
end
