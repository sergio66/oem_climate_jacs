function vOut = interpProfileToSigmaGrid(pressure, values, refSigma)
    % pressure, values: raw profile, ordered TOA -> surface, arbitrary
    % length. refSigma: fixed target grid, e.g. makeReferenceSigmaGrid(100).
    pSurf = pressure(end);
    sigmaSrc = pressure / pSurf;
    vOut = interp1(sigmaSrc, values, refSigma, 'linear', 'extrap');
end
