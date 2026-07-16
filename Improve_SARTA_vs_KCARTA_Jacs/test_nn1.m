% 1. Generate/Load 1D Sample Data
x = linspace(0, 10, 1000)'; % Predictor
y = sin(x) + 0.1*randn(size(x)); % Response with noise

% 2. Train a Deep Neural Network (Regression)
% fitrnet automatically sets up a deep neural network
mdl = fitrnet(x, y, 'LayerSizes', [50 50 50], 'Activations', 'relu');

% 3. Predict and Visualize
y_pred = predict(mdl, x);
plot(x, y, '.', x, y_pred, '-r', 'LineWidth', 2)
legend('Data', 'Neural Net Fit')

