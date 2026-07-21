function [loss, grads] = modelGradients(params, X, Y, W, iHidden)

%% X = input
%% Y = output to compare bias with
%% W = weight = ones or something else
  
Ypred = forwardMLP(params, X, iHidden);

%% unity weights W
loss = mean((Ypred - Y).^2, 'all');

%% non unity weights
err2 = (Ypred - Y).^2;              % (nPCA_BT x batch)
err2 = err2 .* W;                   % W broadcasts (1 x batch) across all nPCA_BT rows
loss = mean(err2, 'all');
    
grads = dlgradient(loss, params);

end


