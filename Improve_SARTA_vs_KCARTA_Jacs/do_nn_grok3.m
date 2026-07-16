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
				%
iRorD = +1; %% residual
iRorD = -1; %% direct

iRorD

if iRorD > 0
  Delta = Y - X; %% Residual Learning (Strongly Recommended) :  Learn correction instead of absolute value
  [DeltaNorm, muDelta, sigDelta] = normalize(Y-X, 2);  
else
  Delta = Y;     %% Direct Prediction
  [DeltaNorm, muDelta, sigDelta] = normalize(Y, 2);
end  

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

N1 = 0128; N2 = 256; N3 = 128;
N1 = 0512; N2 = 256; N3 = 128;
N1 = 2048; N2 = 256; N3 = 128;

layers = [
    featureInputLayer(numParams + 1)   % P + scalar X
    
    fullyConnectedLayer(128);    reluLayer;    batchNormalizationLayer;  dropoutLayer(0.1)    
    fullyConnectedLayer(256);    reluLayer;    batchNormalizationLayer;  dropoutLayer(0.1)
    fullyConnectedLayer(128);    reluLayer;    batchNormalizationLayer;    
    fullyConnectedLayer(64);     reluLayer
    
    fullyConnectedLayer(1)             % Output scalar correction
    ];

net = dlnetwork(layers);

%% 3. Training options

x1 = 1000; x2 = 32; x3 = 1e-3; x4 = 200; x5 = 0.5;
x1 = 1500; x2 = 64; x3 = 5e-4; x4 = 300; x5 = 0.5;
x1 = 0500; x2 = 64; x3 = 5e-4; x4 = 300; x5 = 0.5;

options = trainingOptions('adam', ...
    'MaxEpochs', x1, ...
    'MiniBatchSize', x2, ...
    'InitialLearnRate', x3, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod', x4, ...
    'LearnRateDropFactor', x5, ...
    'ValidationData',{XVal, YVal}, ...
    'ValidationFrequency',250, ...
    'Plots','none',...
    'Verbose',true, ...    
    'ExecutionEnvironment','auto');
%%%    'Plots','training-progress', ...
%%%    'Verbose',false, ...

%numParams
%whos XTrain YTrain XVal YVal
%% note that net is overwritten
net0 = net;
net = trainnet(XTrain, YTrain, net, "mse", options);

%%%%%%%%%%%%%%%%%%%%%%%%%

%{
Y_pred = zeros(size(X));
for i = 1:length(X)
    Y_pred(i) = predictCorrected(P(:,i), X(i), net, ...
                                 muP, sigP, muX, sigX, muDelta, sigDelta);
end
%}

Y_pred = predictBatch(P, X, net, muP, sigP, muX, sigX, muDelta, sigDelta,iRorD);

[~,I] = sort(X);

plot(X(I),X(I)-Y(I),X(I),X(I)-Y_pred(I));
error('lgsjlghszgklhzk jlgh zslkjyawbh tekwyhi6bah t.iesub6lawiu ailwey')

figure(1); clf;
plot(1:length(X), X,     'b-',  'LineWidth',1.1, 'DisplayName','Initial X'); hold on;
plot(1:length(Y), Y,     'g-',  'LineWidth',1.1, 'DisplayName','True Y');
plot(1:length(X), Y_pred,'r--', 'LineWidth',1.2, 'DisplayName','Predicted Y');
title('Initial X vs True Y vs Predicted Y');
xlabel('Index');
ylabel('Value');
legend('Location','best');
grid on;

figure(2); clf
plot(1:length(X), Y-X, 'b', 1:length(Y),Y - Y_pred, 'r'); legend('Initial X','Predicted Y','location','best')
[mean(Y-X) std(Y-X) mean(Y - Y_pred) std(Y - Y_pred)]
'try N'

%whos X Y Y_pred
%[mean(Y) std(Y) mean(Y-X) std(Y-X) mean(Y - Y_pred) std(Y - Y_pred)];
%keyboard_nowindow

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

%Y_pred = predictScalarNN3(P', X');
figure(3); plot(1:length(Y),Y,1:length(Y),Y_pred)


% 1. Predict on training data
DeltaNorm_pred = predict(net, XTrain);                    % normalized delta
Delta_pred     = DeltaNorm_pred * sigDelta + muDelta;     % original scale

% 2. Reconstruct predictions in original scale
X_original_train = X(:, trainIdx)';                       % original X  [trainSamples x 1]
Y_pred_train     = X_original_train + Delta_pred;         % Final prediction
Y_true_train     = Y(:, trainIdx)';                       % True Y

% 3. Plot - Two good ways:

figure(4); clf;
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

figure(5)
plot(1:length(trainIdx),XTrain(:,8),1:length(trainIdx),DeltaTrainPred);
plot(1:length(trainIdx),YTrain,1:length(trainIdx),XTrain + Delta_pred);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4. Prediction (Inference)

% For a new sample
%P_new = XVal;      % [numParams x 1]
%X_init = YVal;     % scalar

%InputNew = [ (P_new - muP)./sigP ; 
%             (X_init - muX)./sigX ];
InputNew  = P_new;

DeltaValNorm = predict(net, InputNew);
DeltaVal     = DeltaValNorm * sigY + muY;     % denormalize

Y_pred = X_init + DeltaVal;                    % Final predicted scalar

figure(6)
plot(X,Y,'b.',X,Y_pred,'rx')

%%%%%%%%%%%%%%%%%%%%%%%%%

y.Y_pred = Y_pred;

return
end

