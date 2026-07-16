function y = feature_selection(P_raw, X_raw,Y_raw)

%% =========================================================
%  FEATURE SELECTION for DNN inputs
%  Step 1: LASSO to screen 300 -> top N parameters
%  Step 2: Permutation importance on trained DNN
%  Inputs : X (660x1), P (660x300), Y (660x1)
%% =========================================================

%% ---------------------------------------------------------
%  1.  LOAD YOUR DATA  (same as train_dnn.m)
% ----------------------------------------------------------

figure(1); clf
plot(X_raw,Y_raw,'.',X_raw,X_raw,'r')
  disp('ret to continue'); pause
  
% Ensure correct types and orientation
X_raw = double(X_raw(:));    % 660 x 1
P_raw = double(P_raw);       % 660 x 300 (or however many you have)
Y_raw = double(Y_raw(:));    % 660 x 1

whos X_raw Y_raw P_raw

% Full feature matrix [X | P]
Features = [X_raw, P_raw];   % 660 x 301
nParams  = size(P_raw, 2);

% Feature names for plots (edit as needed)
feat_names = ["X", arrayfun(@(i) sprintf("P%d",i), 1:nParams, 'UniformOutput', false)];

%% ---------------------------------------------------------
%  2.  LASSO SCREENING  (fast linear screen of all params)
% ----------------------------------------------------------
fprintf('Running LASSO screening...\n');

[Features_norm, mu_F, sigma_F] = zscore(Features);
[Y_norm,        mu_Y, sigma_Y] = zscore(Y_raw);

% 5-fold cross-validated LASSO
[B, FitInfo] = lasso(Features_norm, Y_norm, 'CV', 5, 'NumLambda', 50);

% Plot LASSO cross-validation curve
figure(2); clf
%figure('Name', 'LASSO CV', 'Color', 'w');
lassoPlot(B, FitInfo, 'PlotType', 'CV');
title('LASSO Cross-Validation');

% Get coefficients at lambda with minimum CV error
B_best   = B(:, FitInfo.IndexMinMSE);
nonzero  = find(B_best ~= 0);

fprintf('\n--- LASSO selected %d / %d features ---\n', numel(nonzero), size(Features,2));
fprintf('Selected features:\n');
for i = 1:numel(nonzero)
    fprintf('  [%3d]  %-6s  coeff = %+.4f\n', nonzero(i), feat_names(nonzero(i)), B_best(nonzero(i)));
end

% Bar chart of LASSO coefficients
figure(3); clf
%figure('Name', 'LASSO Coefficients', 'Color', 'w');
bar(B_best, 'FaceColor', [0.2 0.5 0.8]);
xticks(1:numel(feat_names));
xticklabels(feat_names);
xtickangle(45);
ylabel('LASSO Coefficient');
title('LASSO Feature Coefficients (at min CV error)');
grid on;

%% ---------------------------------------------------------
%  3.  PERMUTATION IMPORTANCE on trained DNN
%  (run this section after training net in train_dnn.m)
% ----------------------------------------------------------
fprintf('\nComputing permutation importance...\n');

% Load trained net if not already in workspace
load('trained_dnn.mat');

% Use test set (must match what was used in train_dnn.m)
% Assumes X_test, Y_test are in workspace from train_dnn.m run

nFeats   = size(X_test, 2);
nReps    = 10;      % repeat shuffle N times and average for stability
imp      = zeros(nFeats, 1);

% Baseline R2
Y_pred_base = predict(net, X_test);
SS_tot      = sum((Y_test - mean(Y_test)).^2);
R2_base     = 1 - sum((Y_test - Y_pred_base).^2) / SS_tot;

fprintf('Baseline R2 = %.4f\n', R2_base);

for i = 1:nFeats
    R2_perm_rep = zeros(nReps, 1);
    for r = 1:nReps
        X_perm      = X_test;
        X_perm(:,i) = X_perm(randperm(size(X_test,1)), i);   % shuffle feature i
        Y_perm      = predict(net, X_perm);
        R2_perm_rep(r) = 1 - sum((Y_test - Y_perm).^2) / SS_tot;
    end
    imp(i) = R2_base - mean(R2_perm_rep);   % drop in R2 = importance
    fprintf('  Feature %-6s : R2 drop = %+.4f\n', feat_names(i), imp(i));
end

% Sort and plot
[imp_sorted, sort_idx] = sort(imp, 'descend');

figure(4); clf
%figure('Name', 'Permutation Importance', 'Color', 'w');
barh(imp_sorted, 'FaceColor', [0.2 0.7 0.4]);
yticks(1:nFeats);
yticklabels(feat_names(sort_idx));
xlabel('Drop in R^2 when feature is shuffled');
title(sprintf('Permutation Feature Importance (Baseline R^2 = %.3f)', R2_base));
grid on;
set(gca, 'YDir', 'reverse');

fprintf('\n--- Top features by permutation importance ---\n');
for i = 1:min(10, nFeats)
    fprintf('  %2d. %-6s  importance = %.4f\n', i, feat_names(sort_idx(i)), imp_sorted(i));
end
