function data = decodeSpectral(S, coeffs, standardize)
    if standardize
	coeffs = coeffs .* S.coeffStd + S.coeffMean;
    end
    data = coeffs * S.coeff' + S.mu;
end
