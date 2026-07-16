function refSigma = makeReferenceSigmaGrid(nLevels, concentrateNearSurface)
    lin = linspace(0,1,nLevels);
    if concentrateNearSurface
        refSigma = lin.^1.5;
    else
        refSigma = lin;
    end
end
