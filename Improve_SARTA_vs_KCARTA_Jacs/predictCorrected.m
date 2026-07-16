function Y_pred = predictCorrected(P_new, X_init, net, ...
                                   muP, sigP, muX, sigX, muDelta, sigDelta)

    % Normalize inputs
    Pnorm = (P_new - muP) ./ sigP;
    Xnorm = (X_init - muX) ./ sigX;
    
    Input = [Pnorm; Xnorm]';                    % [1 x 8]
    
    % Predict normalized delta
    DeltaNorm_pred = predict(net, Input);
    
    % Convert back to real scale
    Delta_pred = DeltaNorm_pred * sigDelta + muDelta;
    
    % Final prediction
    Y_pred = X_init + Delta_pred;
end
