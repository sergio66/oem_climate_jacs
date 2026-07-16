function Y_pred = predictBatch(P, X_init, net, muP, sigP, muX, sigX, muDelta, sigDelta, iRorD)
% P: 7 x N,   X_init: 1 x N

Y_pred = zeros(size(X_init));

Pnorm = (P - muP) ./ sigP;
Xnorm = (X_init - muX) ./ sigX;

Input = [Pnorm; Xnorm]';                    % [N x 8]

DeltaNorm_pred = predict(net, Input);

%whos DeltaNorm_pred sigDelta muDelta
Delta_pred = DeltaNorm_pred * sigDelta + muDelta;

if iRorD > 0
  Y_pred = X_init(:) + Delta_pred(:);
else
  Y_pred = Delta_pred;
end
Y_pred = Y_pred';

end
