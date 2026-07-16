function y = do_nn_claude1(P_raw,X_raw,Y_raw,rSplit)

figure(1); clf
plot(X_raw,Y_raw,'.',X_raw,X_raw,'r')
  disp('ret to continue'); pause
  
y = [];

if nargin == 3
  rSplit = 0.8;
end

% Needs data:
% P : [N x numParams]     ← 10 to 50 rows
% X : [N x 1]             ← initial scalar values
% Y : [N x 1]             ← target scalar values

%% =========================================================
%  DNN: Map [X, P] -> Y  (600 samples, scalar regression)
%  Inputs : X (600x1), P (600x10), Y (600x1)
%  Network input dim = numParams  (X concatenated with P)
%  =========================================================

% Ensure correct types and orientation
X_raw = double(X_raw(:));    % 660 x 1
P_raw = double(P_raw);       % 660 x 300 (or however many you have)
Y_raw = double(Y_raw(:));    % 660 x 1

whos X_raw Y_raw P_raw

%% ---------------------------------------------------------
%  2.  BUILD FEATURE MATRIX  [X | P]  ->  (600 x numParams)
% ----------------------------------------------------------
Features = [X_raw, P_raw];   % 600 x numParams
nSamples  = size(Features, 1);
nInputs   = size(Features, 2);   % numParams

%% ---------------------------------------------------------
%  3.  NORMALISE  (zero-mean, unit-variance per feature)
% ----------------------------------------------------------
[Features_norm, mu_F, sigma_F] = zscore(Features);
[Y_norm,        mu_Y, sigma_Y] = zscore(Y_raw);

%Y_norm = Y_raw;
%mu_Y = 0;
%sigma_Y = 1

fprintf('Corr(Features_norm col1, Y_norm) = %.4f\n', corr(Features_norm(:,1), Y_norm));

%% ---------------------------------------------------------
%  4.  TRAIN / VALIDATION / TEST SPLIT  (70 / 15 / 15)
% ----------------------------------------------------------
idx       = randperm(nSamples);
nTrain    = round(rSplit * nSamples);         % if rSplit = 0.7 and N=600, this is 420
nVal      = round((1-rSplit)/2 * nSamples);   % if rSplit = 0,7 and N=600, this is 090
% nTest   = remaining                         % if rSplit = 0,7 and N=600, this is 090

trainIdx  = idx(1          : nTrain);
valIdx    = idx(nTrain+1   : nTrain+nVal);
testIdx   = idx(nTrain+nVal+1 : end);

X_train   = Features_norm(trainIdx, :)';   % numParams x 420
Y_train   = Y_norm(trainIdx)';             %  1 x 420

X_val     = Features_norm(valIdx,   :)';
Y_val     = Y_norm(valIdx)';

X_test    = Features_norm(testIdx,  :)';
Y_test    = Y_norm(testIdx)';

whos X_train Y_train
fprintf('Corr(X_train col1, Y_train) = %.4f\n', corr(X_train(1,:)', Y_train'));

%% ---------------------------------------------------------
%  5.  DEFINE NETWORK ARCHITECTURE
%      Input(numParams) -> FC(64) -> BN -> ReLU
%               -> FC(64) -> BN -> ReLU
%               -> FC(32) -> BN -> ReLU
%               -> FC(1)  (regression output)
% ----------------------------------------------------------
layers = [
    featureInputLayer(nInputs, 'Name', 'input', ...
                      'Normalization', 'none')

    fullyConnectedLayer(64, 'Name', 'fc1')
    batchNormalizationLayer('Name', 'bn1')
    reluLayer('Name', 'relu1')

    fullyConnectedLayer(64, 'Name', 'fc2')
    batchNormalizationLayer('Name', 'bn2')
    reluLayer('Name', 'relu2')

    fullyConnectedLayer(32, 'Name', 'fc3')
    batchNormalizationLayer('Name', 'bn3')
    reluLayer('Name', 'relu3')

    fullyConnectedLayer(1,  'Name', 'output')
    regressionLayer('Name', 'regressionOutput')
];


layers = [
    featureInputLayer(nInputs, 'Name', 'input', 'Normalization', 'none')

    fullyConnectedLayer(64, 'Name', 'fc1')
    reluLayer('Name', 'relu1')
    dropoutLayer(0.2, 'Name', 'drop1')

    fullyConnectedLayer(64, 'Name', 'fc2')
    reluLayer('Name', 'relu2')
    dropoutLayer(0.2, 'Name', 'drop2')

    fullyConnectedLayer(32, 'Name', 'fc3')
    reluLayer('Name', 'relu3')

    fullyConnectedLayer(1,  'Name', 'output')
    regressionLayer('Name', 'regressionOutput')
];

%% ---------------------------------------------------------
%  6.  TRAINING OPTIONS
% ----------------------------------------------------------
%% gives another screen
options = trainingOptions('adam', ...
    'MaxEpochs',           300, ...
    'MiniBatchSize',       64, ...
    'InitialLearnRate',    1e-3, ...
    'LearnRateSchedule',   'piecewise', ...
    'LearnRateDropFactor', 0.5, ...
    'LearnRateDropPeriod', 100, ...
    'L2Regularization',    1e-4, ...
    'ValidationData',      {X_val', Y_val'}, ...
    'ValidationFrequency', 10, ...
    'ValidationPatience',  20, ...
    'Shuffle',             'every-epoch', ...
    'Plots',               'training-progress', ...
    'Verbose',             true);

options = trainingOptions('adam', ...
    'MaxEpochs',           1000, ...
    'MiniBatchSize',       32, ...
    'InitialLearnRate',    1e-4, ...
    'LearnRateSchedule',   'piecewise', ...
    'LearnRateDropFactor', 0.5, ...
    'LearnRateDropPeriod', 200, ...
    'L2Regularization',    1e-4, ...
    'ValidationData',      {X_val', Y_val'}, ...
    'ValidationFrequency', 20, ...
    'ValidationPatience',  50, ...
    'Shuffle',             'every-epoch', ...
    'Plots',               'none', ...
    'Verbose',             true,...
    'VerboseFrequency',    100);   % print every 50 iterations    

%% ---------------------------------------------------------
%  7.  TRAIN
% ----------------------------------------------------------
fprintf('\nTraining DNN...\n');
whos X_train Y_train
net = trainNetwork(X_train', Y_train', layers, options);

% Debug: test on TRAINING data - should fit well if network learned anything
Y_train_pred_norm = predict(net, X_train');
Y_train_true = Y_train_pred_norm * sigma_Y + mu_Y;

fprintf('Y_train_pred range: %.4f to %.4f\n', min(Y_train_pred_norm), max(Y_train_pred_norm));
fprintf('X_train size: %d x %d\n', size(X_train,1), size(X_train,2));
fprintf('X_test  size: %d x %d\n', size(X_test,1),  size(X_test,2));

[~,I] = sort(X_train(1,:));
plot(X_train(1,I),X_train(1,I)-Y_train(I),X_train(1,I),X_train(1,I)-Y_train_pred_nrom(I))
keyboard_nowindow

% Also check: does a trivial linear fit work?
%b = [ones(size(X_train,1),1), X_train(:,1)]' \ Y_train';
%Y_lin = [ones(size(X_test,1),1), X_test(:,1)] * b;
%SS_res = sum((Y_test - Y_lin).^2);
%SS_tot = sum((Y_test - mean(Y_test)).^2);
%fprintf('Linear fit R2 on test: %.4f\n', 1 - SS_res/SS_tot);

%% ---------------------------------------------------------
%  8.  EVALUATE ON TEST SET
% ----------------------------------------------------------
Y_pred_norm = predict(net, X_test');

% Denormalise back to original scale
Y_pred = Y_pred_norm * sigma_Y + mu_Y;
Y_true = Y_test      * sigma_Y + mu_Y;

% Metrics
residuals = Y_true - Y_pred';
MSE   = mean(residuals.^2);
RMSE  = sqrt(MSE);
MAE   = mean(abs(residuals));
SS_res = sum(residuals.^2);
SS_tot = sum((Y_true - mean(Y_true)).^2);
R2    = 1 - SS_res / SS_tot;

fprintf('\n========== TEST SET RESULTS ==========\n');
fprintf('  RMSE : %.4f\n', RMSE);
fprintf('  MAE  : %.4f\n', MAE);
fprintf('  R2   : %.4f\n', R2);
fprintf('======================================\n\n');

%% ---------------------------------------------------------
%  9.  DIAGNOSTIC PLOTS
% ----------------------------------------------------------
figure(1);
%figure('Name', 'Predicted vs Truth', 'Color', 'w');
scatter(Y_true, Y_pred', 30, 'filled', 'MarkerFaceAlpha', 0.6);
hold on;
lims = [min([Y_true; Y_pred']), max([Y_true; Y_pred'])];
plot(lims, lims, 'r--', 'LineWidth', 1.5);
xlabel('True Y');
ylabel('Predicted Y');
title(sprintf('Test Set: Pred vs Truth  (R^2 = %.3f)', R2));
grid on; axis equal;

figure(2);
%figure('Name', 'Residuals', 'Color', 'w');
histogram(residuals, 30, 'FaceColor', [0.2 0.5 0.8]);
xlabel('Residual (True - Pred)');
ylabel('Count');
title('Residual Distribution (Test Set)');
grid on;

%% ---------------------------------------------------------
% 10.  SAVE
% ----------------------------------------------------------
save('trained_dnn.mat', 'net', 'mu_F', 'sigma_F', 'mu_Y', 'sigma_Y',...
     'X_test', 'Y_test', 'X_train', 'Y_train');

fprintf('Model saved to trained_dnn.mat\n');

%% ---------------------------------------------------------
% 11.  INFERENCE HELPER  (use on new data)
% ----------------------------------------------------------
% To predict on new samples later:
%
%   load('trained_dnn.mat');
%   X_new     = [x_scalar_new, p_params_new];   % (N x numParams)
%   X_new_n   = (X_new - mu_F) ./ sigma_F;      % normalise
%   Y_pred_n  = predict(net, X_new_n');          % (N x 1)
%   Y_pred    = Y_pred_n * sigma_Y + mu_Y;       % denormalise

% Check Y range and spread
fprintf('Y_train range: %.4f to %.4f\n', min(Y_train), max(Y_train));
fprintf('Y_pred  range: %.4f to %.4f\n', min(Y_pred),  max(Y_pred));

% Check if X is actually correlated with Y at all
fprintf('Corr(X,Y) = %.4f\n', corr(X_raw, Y_raw));
fprintf('Corr(P1,Y) = %.4f\n', corr(P_raw(:,1), Y_raw));

Y_pred_raw = predict(net, X_test');
fprintf('Y_pred_raw range: %.4f to %.4f\n', min(Y_pred_raw), max(Y_pred_raw));
fprintf('mu_Y=%.4f  sigma_Y=%.4f\n', mu_Y, sigma_Y);
fprintf('Y_pred denorm: %.4f to %.4f\n', min(Y_pred_raw)*sigma_Y+mu_Y, max(Y_pred_raw)*sigma_Y+mu_Y);
