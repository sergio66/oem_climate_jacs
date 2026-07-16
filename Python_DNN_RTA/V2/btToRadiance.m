function radiance = btToRadiance(bt, wavenumberCm1)
    %% rad in mW/cm2/sr/cm-1
    c1 = 1.191042e-5;
    c2 = 1.4387752;
    nu = wavenumberCm1;
    radiance = (c1*nu.^3) ./ (exp(c2*nu./bt) - 1);
end
