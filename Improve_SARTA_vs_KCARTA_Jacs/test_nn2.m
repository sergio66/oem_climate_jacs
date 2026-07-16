% 1. Generate/Load 1D Sample Data
x = linspace(0, 10, 1000)'; % Predictor
y = sin(x) + 0.1*randn(size(x)); % Response with noise

% 1. Define Network Architecture
layers = [
    featureInputLayer(1) % Input 1 feature
    fullyConnectedLayer(100)
    reluLayer
    fullyConnectedLayer(50)
    reluLayer
    fullyConnectedLayer(1)
    regressionLayer];

% 2. Specify Training Options
options = trainingOptions('adam', ...
    'MaxEpochs', 100, ...
    'MiniBatchSize', 32, ...
    'Plots', 'training-progress');

% 3. Train the Network
net = trainNetwork(x, y, layers, options);

