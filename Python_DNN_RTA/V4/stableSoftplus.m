%% ---- stable softplus, to enforce tau >= 0 (physically required) ----
function y = stableSoftplus(x)
    % softplus(x) = log(1+exp(x)), numerically stable form
    y = max(x,0) + log(1 + exp(-abs(x)));
end

