function Y_pred = predictScalarNN3(P_new, X_init)
    persistent Model
    
    if isempty(Model)
        load('ScalarNN_Residual.mat', 'Model');
        disp('Residual Scalar NN loaded.');
    end
    
    % Normalize inputs
    Pnorm = (P_new - Model.muP) ./ Model.sigP;
    Xnorm = (X_init - Model.muX) ./ Model.sigX;
    
    Input = [Pnorm; Xnorm]';                    % [1 x 8]
    
    % Predict normalized delta
    DeltaNorm_pred = predict(Model.net, Input);
    
    % Denormalize delta and apply
    Delta_pred = DeltaNorm_pred * Model.sigDelta + Model.muDelta;
    Y_pred = X_init + Delta_pred;
end

