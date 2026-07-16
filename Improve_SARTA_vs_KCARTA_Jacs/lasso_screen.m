%% =========================================================
%  LASSO FEATURE SCREENING
%  Goal: identify which of the ~300 P parameters are useful
%  for predicting the correction (Y - X) needed
%
%  Run this BEFORE train_dnn.m to select your P parameters
%  =========================================================

clear; clc; close all;

%% ---------------------------------------------------------
%  1.  LOAD YOUR DATA
% ----------------------------------------------------------
% load('mydata.mat');

% --- SYNTHETIC PLACEHOLDER (delete once you load real data) ---
rng(42);
nProfiles  = 132;
nAngles    = 5;
nSamples   = nProfiles * nAngles;   % 660
nParams    = 300;                   % all available P parameters

X_raw      = single(randn(nSamples, 1));
P_raw      = single(randn(nSamples, nParams));
Y_raw      = double(2*X_raw + P_raw(:,7) - 0.5*P_raw(:,45) + ...
                    0.3*P_raw(:,120).^2 + 0.1*randn(nSamples,1));
profile_id = repelem((1:nProfiles)', nAngles);   % 132 profiles x 5 angles
wavenumber = 800.0;   % single channel wavenumber (cm-1)
% --------------------------------------------------------------

% Ensure types
X_raw      = double(X_raw(:));
P_raw      = double(P_raw);
Y_raw      = double(Y_raw(:));
profile_id = double(profile_id(:));

% Feature names for plots
feat_names = ["X", "wavenumber", ...
              arrayfun(@(i) sprintf("P%d",i), 1:nParams, 'UniformOutput', false)];

%% ---------------------------------------------------------
%  2.  WHAT ARE WE TRYING TO PREDICT?
%      The CORRECTION needed: Y - X
%      This is what the DNN ultimately needs to learn
%      If Y-X is tiny and noisy, LASSO will tell you nothing matters
% ----------------------------------------------------------
correction = Y_raw - X_raw;   % what Code 2 gets wrong

fprintf('=== Correction signal stats ===\n');
fprintf('  Mean(Y-X) = %.6f\n', mean(correction));
fprintf('  Std(Y-X)  = %.6f\n', std(correction));
fprintf('  Max(Y-X)  = %.6f\n', max(abs(correction)));
fprintf('  Corr(X,Y) = %.4f\n', corr(X_raw, Y_raw));

if std(correction) < 0.01
    fprintf('\n  WARNING: correction signal is very small!\n');
    fprintf('  LASSO may find nothing useful - consider a different channel.\n\n');
end

%% ---------------------------------------------------------
%  3.  SPLIT ON PROFILES (not samples!)
%      Critical: same profile must not appear in train and val
% ----------------------------------------------------------
unique_profiles = unique(profile_id);
nP     = numel(unique_profiles);
p_idx  = randperm(nP);
nTrain = round(0.70 * nP);   % ~92 profiles
nVal   = round(0.15 * nP);   % ~20 profiles

train_profiles = unique_profiles(p_idx(1          : nTrain));
val_profiles   = unique_profiles(p_idx(nTrain+1   : nTrain+nVal));
test_profiles  = unique_profiles(p_idx(nTrain+nVal+1 : end));

trainIdx = ismember(profile_id, train_profiles);
valIdx   = ismember(profile_id, val_profiles);
testIdx  = ismember(profile_id, test_profiles);

fprintf('Split: %d train / %d val / %d test samples\n', ...
    sum(trainIdx), sum(valIdx), sum(testIdx));
fprintf('       (%d / %d / %d independent profiles)\n\n', ...
    sum(ismember(unique_profiles, train_profiles)), ...
    sum(ismember(unique_profiles, val_profiles)), ...
    sum(ismember(unique_profiles, test_profiles)));

%% ---------------------------------------------------------
%  4.  BUILD FEATURE MATRIX
%      Include X, wavenumber, and all P parameters
% ----------------------------------------------------------
wn_col   = repmat(wavenumber, nSamples, 1);   % constant for single channel
Features = [X_raw, wn_col, P_raw];            % 660 x 302

% Normalise
[Features_n, mu_F, sigma_F] = zscore(Features);
[corr_n,     mu_C, sigma_C] = zscore(correction);

F_train = Features_n(trainIdx, :);
C_train = corr_n(trainIdx);
F_val   = Features_n(valIdx,   :);
C_val   = corr_n(valIdx);
F_test  = Features_n(testIdx,  :);
C_test  = corr_n(testIdx);

%% ---------------------------------------------------------
%  5.  LASSO  with cross-validation
%      Predicts the correction (Y-X) from features
% ----------------------------------------------------------
fprintf('Running LASSO (this may take a minute)...\n');
[B, FitInfo] = lasso(F_train, C_train, ...
                     'CV',       5, ...
                     'NumLambda', 80, ...
                     'Standardize', false);   % already normalised

% Two useful lambda choices:
%   IndexMinMSE : lambda giving lowest CV error (most features)
%   Index1SE    : lambda within 1 std of min (fewer features, more robust)
idx_min = FitInfo.IndexMinMSE;
idx_1se = FitInfo.Index1SE;

B_min = B(:, idx_min);   % coefficients at min CV error
B_1se = B(:, idx_1se);   % coefficients at 1SE (sparser)

fprintf('\n--- LASSO results ---\n');
fprintf('  Min-MSE lambda : %d / %d features selected\n', ...
    sum(B_min ~= 0), size(Features,2));
fprintf('  1SE lambda     : %d / %d features selected (more conservative)\n', ...
    sum(B_1se ~= 0), size(Features,2));

%% ---------------------------------------------------------
%  6.  PRINT SELECTED FEATURES
% ----------------------------------------------------------
fprintf('\n=== Features selected at Min-MSE lambda ===\n');
nonzero_min = find(B_min ~= 0);
[~, sort_i] = sort(abs(B_min(nonzero_min)), 'descend');
nonzero_min = nonzero_min(sort_i);
for i = 1:numel(nonzero_min)
    fprintf('  %-12s  coeff = %+.4f\n', ...
        feat_names{nonzero_min(i)}, B_min(nonzero_min(i)));
end

fprintf('\n=== Features selected at 1SE lambda (conservative) ===\n');
nonzero_1se = find(B_1se ~= 0);
[~, sort_i] = sort(abs(B_1se(nonzero_1se)), 'descend');
nonzero_1se = nonzero_1se(sort_i);
for i = 1:numel(nonzero_1se)
    fprintf('  %-12s  coeff = %+.4f\n', ...
        feat_names{nonzero_1se(i)}, B_1se(nonzero_1se(i)));
end

%% ---------------------------------------------------------
%  7.  EVALUATE LASSO ON TEST SET
%      Gives a sense of how much linear correction is possible
% ----------------------------------------------------------
C_pred_min = F_test * B_min + FitInfo.Intercept(idx_min);
C_pred_1se = F_test * B_1se + FitInfo.Intercept(idx_1se);

% Denormalise back to real correction space
C_test_real     = C_test     * sigma_C + mu_C;
C_pred_min_real = C_pred_min * sigma_C + mu_C;
C_pred_1se_real = C_pred_1se * sigma_C + mu_C;

r2 = @(yt,yp) 1 - sum((yt-yp).^2)/sum((yt-mean(yt)).^2);

fprintf('\n=== LASSO test set performance ===\n');
fprintf('  Baseline (X alone) std(Y-X)     = %.6f\n', std(correction));
fprintf('  LASSO Min-MSE  R2 on correction = %.4f\n', r2(C_test_real, C_pred_min_real));
fprintf('  LASSO 1SE      R2 on correction = %.4f\n', r2(C_test_real, C_pred_1se_real));
fprintf('\n  (R2 > 0.5 means LASSO finds strong LINEAR signal)\n');
fprintf('  (R2 < 0.2 means correction is nonlinear -> DNN needed)\n\n');

%% ---------------------------------------------------------
%  8.  PLOTS
% ----------------------------------------------------------

% CV curve
figure('Name', 'LASSO CV Curve', 'Color', 'w');
lassoPlot(B, FitInfo, 'PlotType', 'CV');
title('LASSO Cross-Validation Curve');

% Coefficient bar chart (min-MSE)
figure('Name', 'LASSO Coefficients', 'Color', 'w');
bar(B_min, 'FaceColor', [0.2 0.5 0.8]);
xticks(1:numel(feat_names));
xticklabels(feat_names);
xtickangle(45);
ylabel('LASSO Coefficient');
title(sprintf('LASSO Coefficients at Min-MSE  (%d features selected)', sum(B_min~=0)));
grid on;

% Predicted vs true correction
figure('Name', 'LASSO Correction Fit', 'Color', 'w');
scatter(C_test_real, C_pred_min_real, 30, 'filled', 'MarkerFaceAlpha', 0.6);
hold on;
lims = [min([C_test_real; C_pred_min_real]), max([C_test_real; C_pred_min_real])];
plot(lims, lims, 'r--', 'LineWidth', 1.5);
xlabel('True correction (Y-X)');
ylabel('LASSO predicted correction');
title(sprintf('LASSO: Predicted vs True Correction  (R^2=%.3f)', ...
    r2(C_test_real, C_pred_min_real)));
grid on; axis equal;

%% ---------------------------------------------------------
%  9.  SAVE SELECTED FEATURE INDICES FOR train_dnn.m
% ----------------------------------------------------------
selected_features_min = nonzero_min;   % indices into [X, wn, P1..P300]
selected_features_1se = nonzero_1se;

save('lasso_results.mat', 'selected_features_min', 'selected_features_1se', ...
     'B_min', 'B_1se', 'FitInfo', 'feat_names', 'mu_F', 'sigma_F', 'mu_C', 'sigma_C');
fprintf('LASSO results saved to lasso_results.mat\n');
fprintf('Use selected_features_min or selected_features_1se\n');
fprintf('as your P parameter indices in train_dnn.m\n');
