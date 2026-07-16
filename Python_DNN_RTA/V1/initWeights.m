function W = initWeights(nOut, nIn)
    % He/Kaiming-style init, self-contained (no toolbox init function dependency)
    W = single(randn(nOut, nIn) * sqrt(2/nIn));
end

