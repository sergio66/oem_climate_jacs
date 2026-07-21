subset_the_chans
nChannelsBand = numel(wavenumbers);

i1231 = find(freq >= 1231,1);
i900  = find(freq >= 900,1);
i820  = find(freq >= 820,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

targetCoeffs = btRaw;

%% ------------------------------------------------------------------
%  3. Assemble full input feature matrix
%  ------------------------------------------------------------------
disp('Stage 3 : Assemble FOr DNN')
clear X Y

if iFitChan == -1
  X = [dttEOF, qEOF, o3EOF, scalarTensor, emisEOF];                   % (nSamples x nFeatures)

elseif iFitChan == 1  
  X = [dt1_00, dt2_00, dt3_00, dt4_00, dt5_00, dt6_00, Wr1_00, Wr2_00, Wr3_00, Wr4_00, Wr5_00, Wr6_00];
  
end  
Y = targetCoeffs;                                                 % (nSamples x nPCA_BT)

disp(' ')
printarray(size(X),' input to DNN    size(X)')
disp(' ')
printarray(size(Y),' output from DNN size(Y)')
disp(' ')

nFeatures = size(X,2);
fprintf('Total input feature dimension: %d\n', nFeatures);

%% ------------------------------------------------------------------
%  4. Train / validation split
%  ------------------------------------------------------------------
disp('Stage 4 : find training/validation indices')
nTrain = round(0.8*nSamples);
idxPerm = randperm(nSamples);
trainIdx = idxPerm(1:nTrain);
valIdx   = idxPerm(nTrain+1:end);

Xtrain = X(trainIdx,:);  Ytrain = Y(trainIdx,:);
Xval   = X(valIdx,:);    Yval   = Y(valIdx,:);
printarray(size(trainIdx),'size(trainIdx)');
printarray(size(valIdx),  'size(valIdx)');

%% ------------------------------------------------------------------
%  5. Build MLP parameters (manual dlarray custom-training-loop style)
%  ------------------------------------------------------------------
disp('Stage 5 : getting ready for DNN')
params = set_up_dnn(iHidden,iNN,nLayerFeatures,nChannelsBand);

%% ------------------------------------------------------------------
%  6. Train
%  ------------------------------------------------------------------
disp('Stage 6 : Training')
miniBatchSize   = 256;
numEpochs       = 30;  %% too few
numEpochs       = 200; %% bit better
learnRate       = 1e-3;

avgGrad   = [];
avgGradSq = [];
iteration = 0;

nTrainSamples = size(Xtrain,1);
numBatchesPerEpoch = floor(nTrainSamples / miniBatchSize);

epoch_loop

