%% ---- Planck function, vectorized over channels AND batch ----
function B = planckRadianceVec(T, wavenumbersBand)
    % T: dlarray 'CB', (1 x batch); wavenumbersBand: plain (nChannelsBand x 1)
    c1 = 1.191042e-5; c2 = 1.4387752;
    nu = dlarray(single(wavenumbersBand));   % (nChannelsBand x 1)
    % broadcast: (nChannelsBand x 1) against (1 x batch) -> (nChannelsBand x batch)
    B = (c1*nu.^3) ./ (exp(c2*nu./T) - 1);
end

