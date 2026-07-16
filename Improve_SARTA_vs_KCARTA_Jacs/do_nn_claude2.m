function y = do_nn_claude2(P_raw,X_raw,Y_raw,rSplit)

figure(1); clf
plot(Y_raw,X_raw,'.',X_raw,X_raw,'k')
  xlabel('Y true (KCARTA)'); ylabel('Xin (SARTA)')
  %disp('ret to continue'); pause
  pause(0.1)
  
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

[mm,nn] = size(P_raw);
if mm ~= length(X_raw)
  P_raw = P_raw';
end  

whos X_raw Y_raw P_raw

%% ---------------------------------------------------------
%  2.  BUILD FEATURE MATRIX  [X | P]  ->  (660 x 14)
% ----------------------------------------------------------
Features = [X_raw, P_raw];       % 660 x 14
nSamples  = size(Features, 1);   % 660
nInputs   = size(Features, 2);   % 14

%% ---------------------------------------------------------
%  3.  NORMALISE  (zero-mean, unit-variance)
%      _n suffix = normalised space throughout
% ----------------------------------------------------------
[Features_n, mu_F, sigma_F] = zscore(Features);   % 660 x 14
[Y_n,        mu_Y, sigma_Y] = zscore(Y_raw);       % 660 x 1

%% ---------------------------------------------------------
%  4.  TRAIN / VALIDATION / TEST SPLIT  (70 / 15 / 15)
%      _n suffix = normalised, no suffix = real space
% ----------------------------------------------------------
idx    = randperm(nSamples);
nTrain = round(rSplit * nSamples);   % ~462
nVal   = round((1-rSplit)/2 * nSamples);   % ~99

trainIdx = idx(1            : nTrain);
valIdx   = idx(nTrain+1     : nTrain+nVal);
testIdx  = idx(nTrain+nVal+1: end);

iNrepeat = 5; %% remember I took *83 ECM + 49 UMBC) profiles, and repeated by 5. This duplicates things
if iNrepeat > 1
  iN_IndptProfiles = length(X_raw)/iNrepeat; %% number of independent profiles  === 132

  % If your data is ordered: all 5 angles of profile 1, then all 5 of profile 2, etc.
  profile_id = repelem((1:iN_IndptProfiles)', 5);   % [1,1,1,1,1, 2,2,2,2,2, ..., iN_IndptProfiles,iN_IndptProfiles,iN_IndptProfiles,iN_IndptProfiles,iN_IndptProfiles]

  %  if it's ordered differently — all iN_IndptProfiles profiles at angle 1, then all iN_IndptProfiles at angle 2:
  % profile_id = repmat((1:iN_IndptProfiles)', 5, 1);  % [1,2,3,...,iN_IndptProfiles, 1,2,3,...,iN_IndptProfiles, ...]

  profile_idx = randperm(floor(iN_IndptProfiles));   %% eg profile_idx = [57, 3, 118, 24, 6, 91, ...]

  XTrain = 1:floor(rSplit*length(X_raw)/iNrepeat);                         %% 1 : 72   if rSplit = 0.7
  XTest  = floor(length(X_raw)/iNrepeat*(1-rSplit)/2);
    XTest  = length(X_raw)/iNrepeat-length(XTest):length(X_raw)/iNrepeat;  %% 113:132  if rSplit = 0.7
  XVal   = max(XTrain)+1 : min(XTest)-1;                                   %% 73 : 112 if rSplit = 0.7

  train_profiles = profile_idx(XTrain);    % 70%
  val_profiles   = profile_idx(XVal);      % 15%
  test_profiles  = profile_idx(XTest);     % 15%

  % Step 3: expand back to sample indices
  % "give me all 660 rows where the profile belongs to train set"
  trainIdx = find(ismember(profile_id, train_profiles));
  % e.g. if profile 57 is in train, rows 281-285 are all included
  % Result: ~460 rows (92 profiles x 5 angles)

  valIdx  = find(ismember(profile_id, val_profiles));    % ~100 rows
  testIdx = find(ismember(profile_id, test_profiles));   % ~100 rows  
end

% --- normalised (used for training) ---
X_train_n  = Features_n(trainIdx, :);   % 462 x 14
Y_train_n  = Y_n(trainIdx);             % 462 x 1

X_val_n    = Features_n(valIdx,   :);   %  99 x 14
Y_val_n    = Y_n(valIdx);               %  99 x 1

X_test_n   = Features_n(testIdx,  :);   %  99 x 14
Y_test_n   = Y_n(testIdx);              %  99 x 1

% --- real space (used for evaluation and plots) ---
X_train_real = X_raw(trainIdx);         % 462 x 1
X_val_real   = X_raw(valIdx);
X_test_real  = X_raw(testIdx);

Y_train_real = Y_raw(trainIdx);         % 462 x 1
Y_val_real   = Y_raw(valIdx);
Y_test_real  = Y_raw(testIdx);

%% ---------------------------------------------------------
%  5.  DEFINE NETWORK ARCHITECTURE
%      Input(14) -> FC(64)->ReLU->Dropout
%               -> FC(64)->ReLU->Dropout
%               -> FC(32)->ReLU
%               -> FC(1)  regression output
% ----------------------------------------------------------
layers = [
    featureInputLayer(nInputs, 'Name', 'input', ...
                      'Normalization', 'none')

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
options = trainingOptions('adam', ...
    'MaxEpochs',           500, ...
    'MiniBatchSize',       32, ...
    'InitialLearnRate',    1e-4, ...
    'LearnRateSchedule',   'piecewise', ...
    'LearnRateDropFactor', 0.5, ...
    'LearnRateDropPeriod', 150, ...
    'L2Regularization',    1e-4, ...
    'ValidationData',      {X_val_n, Y_val_n}, ...
    'ValidationFrequency', 20, ...
    'ValidationPatience',  50, ...
    'Shuffle',             'every-epoch', ...
    'Plots',               'none', ...
    'Verbose',             true, ...
    'VerboseFrequency',    50);

%% ---------------------------------------------------------
%  7.  TRAIN
% ----------------------------------------------------------
fprintf('\nTraining DNN...\n');
whos X_train_n Y_train_n X_val_n Y_val_n
net = trainNetwork(X_train_n, Y_train_n, layers, options);

%% ---------------------------------------------------------
%  8.  PREDICT & DENORMALISE TO REAL SPACE
%      All Y_pred_*_real are directly comparable to Y_*_real
% ----------------------------------------------------------
Y_pred_train_real = predict(net, X_train_n) * sigma_Y + mu_Y;  % 462 x 1
Y_pred_val_real   = predict(net, X_val_n)   * sigma_Y + mu_Y;  %  99 x 1
Y_pred_test_real  = predict(net, X_test_n)  * sigma_Y + mu_Y;  %  99 x 1

%% ---------------------------------------------------------
%  9.  METRICS  (all in real space)
% ----------------------------------------------------------
r2 = @(yt, yp) 1 - sum((yt-yp).^2) / sum((yt-mean(yt)).^2);

R2_train   = r2(Y_train_real, Y_pred_train_real);
R2_val     = r2(Y_val_real,   Y_pred_val_real);
R2_test    = r2(Y_test_real,  Y_pred_test_real);
RMSE_train = sqrt(mean((Y_train_real - Y_pred_train_real).^2));
RMSE_test  = sqrt(mean((Y_test_real  - Y_pred_test_real).^2));

fprintf('\n========== RESULTS (real space) ==========\n');
fprintf('  Train  RMSE: %.4f   R2: %.4f\n', RMSE_train, R2_train);
fprintf('  Val              R2: %.4f\n',     R2_val);
fprintf('  Test   RMSE: %.4f   R2: %.4f\n', RMSE_test,  R2_test);
fprintf('==========================================\n\n');

%% ---------------------------------------------------------
% 10.  DIAGNOSTIC PLOTS
% ----------------------------------------------------------

% --- Predicted vs True scatter (train and test) ---
%figure('Name', 'Predicted vs Truth', 'Color', 'w');
figure(2); clf
subplot(1,2,1);
scatter(Y_train_real, Y_pred_train_real, 20, 'b', 'filled', 'MarkerFaceAlpha', 0.4);
hold on;
lims = [min([Y_train_real; Y_pred_train_real]), max([Y_train_real; Y_pred_train_real])];
plot(lims, lims, 'r--', 'LineWidth', 1.5);
xlabel('True Y'); ylabel('Predicted Y');
title(sprintf('Train  (R^2 = %.3f)', R2_train));
grid on; axis equal;

subplot(1,2,2);
scatter(Y_test_real, Y_pred_test_real, 20, 'g', 'filled', 'MarkerFaceAlpha', 0.6);
hold on;
lims = [min([Y_test_real; Y_pred_test_real]), max([Y_test_real; Y_pred_test_real])];
plot(lims, lims, 'r--', 'LineWidth', 1.5);
xlabel('True Y'); ylabel('Predicted Y');
title(sprintf('Test  (R^2 = %.3f)', R2_test));
grid on; axis equal;

% --- X vs Y in real space (all data) ---
X_all      = [X_train_real; X_val_real;      X_test_real];
Y_true_all = [Y_train_real; Y_val_real;      Y_test_real];
Y_pred_all = [Y_pred_train_real; Y_pred_val_real; Y_pred_test_real];

fprintf('Corr(X_all, Y_true_all) = %.4f\n', corr(X_all, Y_true_all));
fprintf('Corr(X_all, Y_pred_all) = %.4f\n', corr(X_all, Y_pred_all));

[X_sorted, sort_idx] = sort(X_all);
Y_true_sorted = Y_true_all(sort_idx);
Y_pred_sorted = Y_pred_all(sort_idx);

%figure('Name', 'Real Space: X vs Y', 'Color', 'w');
%figure(3); clf
%plot(X_sorted, Y_true_sorted, 'b.', 'MarkerSize', 8); hold on;
%plot(X_sorted, Y_pred_sorted, 'r.', 'MarkerSize', 6);
%plot(X_sorted, X_sorted, 'k', 'MarkerSize', 6); hold off
%xlabel('Input X (real scale)');
%ylabel('Y (real scale)');
%legend('True Y', 'Predicted Y', 'Location', 'best');
%t%itle('All data: True vs Predicted in real space');
%grid on;

%figure('Name', 'Real Space: X vs Y', 'Color', 'w');
figure(3); clf
plot(Y_true_sorted, X_sorted, 'b.', 'MarkerSize', 8); hold on;
plot(Y_true_sorted, Y_pred_sorted, 'r.', 'MarkerSize', 6);
plot(X_sorted, X_sorted, 'k', 'MarkerSize', 6); hold off
xlabel('Input True Y (real scale)');
ylabel('X in and Ypred');
legend('True Xin', 'Predicted Y', 'Location', 'best');
title('All data: True vs Predicted in real space');
grid on;

% --- Residuals ---
%figure('Name', 'Residuals', 'Color', 'w');
figure(4); clf
residuals_test = Y_test_real - Y_pred_test_real;
histogram(residuals_test, 30, 'FaceColor', [0.2 0.5 0.8]);
xlabel('Residual (True - Pred)');
ylabel('Count');
title('Residual Distribution (Test Set, real space)');
grid on;

% --- Spot check table ---
fprintf('--- Test set spot check (real space) ---\n');
fprintf('  X_real      Y_true      Y_pred      Error\n');
for i = 1:min(10, numel(X_test_real))
    fprintf('  %8.4f    %8.4f    %8.4f    %+.4f\n', ...
        X_test_real(i), Y_test_real(i), Y_pred_test_real(i), ...
        Y_test_real(i) - Y_pred_test_real(i));
end

%% ---------------------------------------------------------
% 11.  SAVE
% ----------------------------------------------------------
save('trained_dnn.mat', 'net', 'mu_F', 'sigma_F', 'mu_Y', 'sigma_Y', ...
     'X_train_n', 'Y_train_real', ...
     'X_val_n',   'Y_val_real', ...
     'X_test_n',  'Y_test_real');
fprintf('\nModel saved to trained_dnn.mat\n');

%% ---------------------------------------------------------
% 12.  INFERENCE ON NEW DATA
% ----------------------------------------------------------
% load('trained_dnn.mat');
% X_new       = [x_new, p_new];                        % (N x 14) real space
% X_new_n     = (X_new - mu_F) ./ sigma_F;             % normalise features
% Y_pred_real = predict(net, X_new_n) * sigma_Y + mu_Y; % predict & denormalise

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(5); clf

Y_pred_orig = zeros(nSamples, 1);
Y_pred_orig(trainIdx) = Y_pred_train_real;
Y_pred_orig(valIdx)   = Y_pred_val_real;
Y_pred_orig(testIdx)  = Y_pred_test_real;

plot(Y_raw, Y_raw - X_raw, 'b.', 'MarkerSize', 8); hold on;
plot(Y_raw, Y_raw - Y_pred_orig, 'r.', 'MarkerSize', 8);
xlabel('X');
ylabel('Correction');
legend('Y\_true - X\_true', 'Y\_pred - Y(DNN corrected)');
title('Correction in original order');
grid on;

%fprintf('Std of (X-Y)       = %.6f\n', std(Y_raw - X_raw));
%fprintf('Std of (Y-Y_pred)  = %.6f\n', std(Y_raw - Y_pred_orig));
%fprintf('Mean of (X-Y)      = %.6f\n', mean(X_raw - Y_raw));
%fprintf('Mean of (Y-Y_pred) = %.6f\n', mean(Y_raw - Y_pred_orig));

fprintf('(X-Y)       = %.6f +/- %.6f \n', mean(X_raw - Y_raw),       std(Y_raw - X_raw));
fprintf('(X-Y_pred)  = %.6f +/- %.6f \n', mean(Y_raw - Y_pred_orig), std(Y_raw - Y_pred_orig));
