function Y = forwardMLP(params, X, iHidden)

% if nargin == 2
%   iHidden = 2;
% end

  if iHidden == 2
    % X: dlarray, format 'CB' (features x batch)
    h1 = relu(fullyconnect(X,  params.fc1_W, params.fc1_b));
    h2 = relu(fullyconnect(h1, params.fc2_W, params.fc2_b));
    Y  = fullyconnect(h2, params.fc3_W, params.fc3_b);   % linear output, PCA coeff scale
  elseif iHidden == 3
    % X: dlarray, format 'CB' (features x batch)
    h1 = relu(fullyconnect(X,  params.fc1_W, params.fc1_b));
    h2 = relu(fullyconnect(h1, params.fc2_W, params.fc2_b));
    h3 = relu(fullyconnect(h2, params.fc3_W, params.fc3_b));
    Y  = fullyconnect(h3, params.fc4_W, params.fc4_b);   % linear output, PCA coeff scale
  elseif iHidden == 4    
    % X: dlarray, format 'CB' (features x batch)
    h1 = relu(fullyconnect(X,  params.fc1_W, params.fc1_b));
    h2 = relu(fullyconnect(h1, params.fc2_W, params.fc2_b));
    h3 = relu(fullyconnect(h2, params.fc3_W, params.fc3_b));
    h4 = relu(fullyconnect(h3, params.fc4_W, params.fc4_b));    
    Y  = fullyconnect(h3, params.fc5_W, params.fc5_b);   % linear output, PCA coeff scale   
  else
    error('Unsupported iHidden = %d', iHidden);
  end
end

%{
    h = X;
    for L = 1:nHiddenLayers
        h = relu(fullyconnect(h, params.(sprintf('fc%d_W',L)), params.(sprintf('fc%d_b',L))));
    end
    Y = fullyconnect(h, params.(sprintf('fc%d_W',nHiddenLayers+1)), params.(sprintf('fc%d_b',nHiddenLayers+1)));
    % ^ make sure this line exists and Y is what gets returned, not h
%}
