function [loss, grads] = modelGradients(params, X, Y, iHidden)
    Ypred = forwardMLP(params, X, iHidden);
    loss = mean((Ypred - Y).^2, 'all');
    grads = dlgradient(loss, params);
end


