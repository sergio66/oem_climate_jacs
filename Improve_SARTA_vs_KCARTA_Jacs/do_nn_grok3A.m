function y = do_nn_grok3(P,X,Y,rSplit)

y = [];

if nargin == 3
  rSplit = 0.8;
end

%% see ReadmeGrok3

% Assume your data:
% P : [numParams x N]     ← 10 to 50 rows
% X : [1 x N]             ← initial scalar values
% Y : [1 x N]             ← target scalar values

numParams = size(P,1);

% Normalize inputs and targets
[Pnorm, muP, sigP] = normalize(P, 2);
[Xnorm, muX, sigX] = normalize(X, 2);
[Ynorm, muY, sigY] = normalize(Y, 2);

% Combine inputs: P + X
Input = [Pnorm; Xnorm];        % size: [numParams+1, N]

% === Residual Learning (Strongly Recommended) ===
Delta = Y - X;                       % Learn correction instead of absolute value
DeltaNorm = Ynorm - Xnorm;
[Deltanorm, muDelta, sigDelta] = normalize(Y-X, 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 3. TRANSPOSE to correct format: [660 x 8]
Ynorm      = Ynorm';
DeltaNorm  = DeltaNorm';
Input      = Input';                    % ← THIS IS THE KEY FIX

YTrainFull = Ynorm;               % [660 x 1]
YTrainFull = DeltaNorm;           % [660 x 1]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optional train/validation split
N = size(Input,1);

if rSplit < 0.95
  idx = randperm(N);
  trainIdx = idx(1:round(rSplit*N));
  valIdx   = idx(round(rSplit*N)+1:end);
  
  XTrain = Input(trainIdx, :);
  YTrain = DeltaNorm(trainIdx, :);     % Target = correction
  
  XVal   = Input(valIdx, :);
  YVal   = DeltaNorm(valIdx, :);

else
  idx = randperm(N);

  rrSplit = 0.95;
  
  trainIdx = idx(1:round(rrSplit*N));
  trainIdx = 1:length(Y);
  
  valIdx   = idx(round(rrSplit*N)+1:end);

  XTrain = Input;
  YTrain = DeltaNorm;

  XVal   = Input(valIdx, :);
  YVal   = DeltaNorm(valIdx, :);
end

disp(['Number of input values : ', num2str(length(Y))]);
disp(['Training samples: ', num2str(size(XTrain,2))]);
disp(['Validation samples: ', num2str(size(XVal,2))]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2. Define the Network

layers = [
    featureInputLayer(numParams + 1)   % P + scalar X
    
    fullyConnectedLayer(128);    reluLayer;    batchNormalizationLayer    
    fullyConnectedLayer(256);    reluLayer;    batchNormalizationLayer    
    fullyConnectedLayer(128);    reluLayer;    batchNormalizationLayer    
    fullyConnectedLayer(64);     reluLayer
    
    fullyConnectedLayer(1)             % Output scalar correction
    ];

net = dlnetwork(layers);

%% 3. Training options

options = trainingOptions('adam', ...
    'MaxEpochs', 1000, ...
    'MiniBatchSize', 32, ...
    'InitialLearnRate', 1e-3, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod', 200, ...
    'LearnRateDropFactor', 0.5, ...
    'ValidationData',{XVal, YVal}, ...
    'ValidationFrequency',30, ...
    'Plots','none',...
    'Verbose',true, ...    
    'ExecutionEnvironment','auto');
%%%    'Plots','training-progress', ...
%%%    'Verbose',false, ...

%numParams
%whos XTrain YTrain XVal YVal
net = trainnet(XTrain, YTrain, net, "mse", options);

figure(1); clf
semilogy(info.TrainingLoss); hold on;
semilogy(info.ValidationLoss);
title('Loss Curve');
legend('Training','Validation');
grid on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iSave = +1;
if iSave > 0
  Model.net       = net;
  Model.muP       = muP;      Model.sigP = sigP;
  Model.muX       = muX;      Model.sigX = sigX;
  Model.muDelta   = muDelta;  Model.sigDelta = sigDelta;
  
  save('ScalarNN_Residual.mat', 'Model');
  disp('Model saved successfully.');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Y_pred = predictScalarNN3(P', X');
figure(1); plot(1:length(Y),Y,1:length(Y),Y_pred)


'here 0'
keyboard_nowindow


% 1. Predict on training data
DeltaNorm_pred = predict(net, XTrain);                    % normalized delta
Delta_pred     = DeltaNorm_pred * sigDelta + muDelta;     % original scale

% 2. Reconstruct predictions in original scale
X_original_train = X(:, trainIdx)';                       % original X  [trainSamples x 1]
Y_pred_train     = X_original_train + Delta_pred;         % Final prediction
Y_true_train     = Y(:, trainIdx)';                       % True Y

% 3. Plot - Two good ways:

figure(1); clf;

% Plot A: Final Y vs True Y (Best visual check)
subplot(2,1,1);
plot(Y_true_train, 'b-', 'LineWidth', 1.2); hold on;
plot(Y_pred_train, 'r--', 'LineWidth', 1.0);
title('Final Prediction vs True Y (Training Data)');
legend('True Y', 'Predicted Y');
ylabel('Y value');
grid on;

% Plot B: Needed Correction vs Predicted Correction
subplot(2,1,2);
Delta_raw = Delta;
plot(Delta_raw(trainIdx)', 'b-', 'LineWidth', 1.2); hold on;
plot(Delta_pred, 'r--', 'LineWidth', 1.0);
title('True Delta vs Predicted Delta');
legend('True Delta (Y-X)', 'Predicted Delta');
ylabel('Delta');

grid on;

fprintf('Final MAE on Y: %.6f\n', mean(abs(Y_pred_train - Y_true_train)));

DeltaNorm_pred = predict(net, XTrain);
Delta_pred = DeltaNorm_pred * sigDelta + muDelta;
mae = mean(abs(Delta_pred' - Delta(trainIdx)));   % should be small if well trained
fprintf('Mean Absolute Error on Delta: %.4f\n', mae);

DeltaTrainNorm = predict(net, XTrain);
DeltaTrainPred = DeltaTrainNorm * sigY + muY;
DeltaTrainPred = DeltaTrainNorm * sigDelta + muDelta;

figure(1)
plot(1:length(trainIdx),XTrain(:,8),1:length(trainIdx),DeltaTrainPred);
plot(1:length(trainIdx),YTrain,1:length(trainIdx),X_init + Delta_pred);

'here 1'
keyboard_nowindow

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4. Prediction (Inference)

% For a new sample
%P_new = XVal;      % [numParams x 1]
%X_init = YVal;     % scalar

'here 2'
keyboard_nowindow

%InputNew = [ (P_new - muP)./sigP ; 
%             (X_init - muX)./sigX ];
InputNew  = P_new;

DeltaValNorm = predict(net, InputNew);
DeltaVal     = DeltaValNorm * sigY + muY;     % denormalize

Y_pred = X_init + DeltaVal;                    % Final predicted scalar

plot(X,Y,'b.',X,Y_pred,'rx')

%%%%%%%%%%%%%%%%%%%%%%%%%

y.Y_pred = Y_pred;
keyboard_nowindow

error('gksjglksgjslkgjlksj')
return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%{
%% Complete Compact Script (Copy-Paste Ready)

%% Full Compact Script
[Pnorm, muP, sigP] = normalize(P,2);
[Xnorm, muX, sigX] = normalize(X,2);
[Ynorm, muY, sigY] = normalize(Y,2);

Input = [Pnorm; Xnorm];
DeltaNorm = Ynorm - Xnorm;

layers = [
    featureInputLayer(size(Input,1))
    fullyConnectedLayer(128); reluLayer; batchNormalizationLayer
    fullyConnectedLayer(256); reluLayer; batchNormalizationLayer
    fullyConnectedLayer(128); reluLayer; batchNormalizationLayer
    fullyConnectedLayer(64);  reluLayer
    fullyConnectedLayer(1)
];

net = dlnetwork(layers);

options = trainingOptions('adam','MaxEpochs',800,'MiniBatchSize',32,...
    'InitialLearnRate',1e-3,'LearnRateDropPeriod',150,'LearnRateDropFactor',0.5,...
    'ValidationData',{Input(:,valIdx), DeltaNorm(:,valIdx)},...
    'Plots','training-progress');

net = trainnet(Input(:,trainIdx), DeltaNorm(:,trainIdx), net, "mse", options);

% Predict
Y_pred = X_init + predict(net, [ (P_new-muP)./sigP ; (X_init-muX)./sigX ]) * sigY + muY;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% saving the trained NN and norm stats

%% Save the model (after training)
save('MyScalarNN_Model.mat', ...
     'net', ...           % the trained dlnetwork
     'muP', 'sigP', ...   % normalization for P
     'muX', 'sigX', ...   % normalization for X
     'muY', 'sigY', ...   % normalization for Delta/Y
     'numParams', ...     % optional but useful
     '-v7.3');            % good for larger networks

disp('Model saved as MyScalarNN_Model.mat');

% 2. Create a Clean Prediction Function (Recommended)
% call it predictScalarNN.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Y_pred = predictScalarNN(P_new, X_init)
% PREDICTSCALARNN  Load model and predict Y from P and X
%   Y_pred = predictScalarNN(P_new, X_init)
%   P_new  : [numParams x 1] or [numParams x M]
%   X_init : scalar or [1 x M]

persistent net muP sigP muX sigX muY sigY

if isempty(net)
    % Load model once
    load('MyScalarNN_Model.mat', 'net', 'muP', 'sigP', ...
                               'muX', 'sigX', 'muY', 'sigY');
    disp('ScalarNN model loaded.');
end

% Normalize inputs
Pnorm = (P_new - muP) ./ sigP;
Xnorm = (X_init - muX) ./ sigX;

% Combine
Input = [Pnorm; Xnorm];

% Predict correction (Delta)
DeltaNorm = predict(net, Input);

% Denormalize and apply residual
Delta = DeltaNorm .* sigY + muY;
Y_pred = X_init + Delta;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% which you can use later, vers 1

% Example usage for new data
P_new = rand(25, 1);      % your 25 parameters
X_init = 12.34;           % your initial scalar

Y_pred = predictScalarNN(P_new, X_init);

disp(['Predicted Y = ', num2str(Y_pred)]);
You can also call it on multiple samples at once:
matlabP_new = rand(25, 10);     % 10 different cases
X_init = [10; 20; 30];  % column vector
Y_pred = predictScalarNN(P_new, X_init);

%% ONE SCRIPT
% After training - Quick save
Model.net = net;
Model.muP = muP; Model.sigP = sigP;
Model.muX = muX; Model.sigX = sigX;
Model.muY = muY; Model.sigY = sigY;
Model.numParams = numParams;
save('MyScalarNN_Model.mat', 'Model');

load('MyScalarNN_Model.mat', 'Model');
net = Model.net;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Why This Works Well
% Very fast and stable because output is scalar.
% Residual learning (Y = X + correction) is especially good when X is already a reasonable approximation of Y.
% Easy to tune (you can make the network deeper/wider if needed).
%}
