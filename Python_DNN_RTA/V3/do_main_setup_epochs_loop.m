if iFitChan == -1
  ind_freq = 1: 2645;                                                             %% all
  ind_freq = find(freq0 <= 3000); %% all chans
elseif iFitChan == -2
  ind_freq = find(freq0 <= 1640);                                                 %% all TZ,CO2, WV, O3
elseif iFitChan == +1
  ind_freq = find(freq0 >= 1250 & freq0 <= 1700);                                 %% WV MW
  ind_freq = find(freq0 >= 1350 & freq0 <= 1700);                                 %% WV MW  
elseif iFitChan == +3  
  ind_freq = find(freq0 >= 0980 & freq0 <= 1100);                                 %% O3
elseif iFitChan == 800  
  ind_freq = find(freq0 >= 0820 & freq0 <= 0980 | freq0 > 1100 & freq0 <= 1250);  %% window
elseif iFitChan == -3
  ind_freq = find(freq0 >= 0700 & freq0 <= 1640);                                 %% low alt TZ,CO2, WV, O3
elseif iFitChan == 2
  ind_freq = find(freq0 >= 0600 & freq0 <= 0820);                                 %% LW TZ,CO2  
elseif iFitChan == 21  
  ind_freq = find(freq0 >= 2150 & freq0 <= 2450);                                 %% SW TZ,CO2
elseif iFitChan == 6  
  ind_freq = find(freq0 >= 1150 & freq0 <= 1450);                                 %% CH4
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

freq          = freq0;
emissivityRaw = emissivityRaw0;
btRaw         = btRaw0;
nChannels     = 2645;
btTrueVal     = btRaw0;

freq          = freq0(ind_freq);
emissivityRaw = emissivityRaw0(:,ind_freq);
btRaw         = btRaw0(:,ind_freq);;
btTrueVal     = btTrueVal(:,ind_freq);;;

emisPCA = fitSpectralPCA(emissivityRaw, nPCA_emis);
btPCA   = fitSpectralPCA(btRaw,         nPCA_BT);
emisEOF = encodeSpectral(emisPCA, emissivityRaw, true);

wavenumbers = freq;
nChannels = length(ind_freq);

i1231 = find(freq >= 1231,1);
i900  = find(freq >= 900,1);
i820  = find(freq >= 820,1);

emis_BT = rad2bt(1231,usstd_rad(1520));                  %% this is 1231 cm-1 reference radiance --> BT
emis_BT = rad2bt(1231,radianceRaw_00(:,1520)) - emis_BT; %% this is what we fitting here
%% i1231 = find(freq >= 1231,1)
plot(btRaw(:,i1231) - emis_BT(iFlag))  %% hmm

emis_BT1231 = btRaw(:,i1231);
emis_BT900 = btRaw(:,i900);
emis_BT820 = btRaw(:,i820);
emis_BT = [emis_BT820 emis_BT900 emis_BT1231];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iStd < 0
  %% do not standardize, PCA get be large for first 203 compoentns which dominate
  targetCoeffs = encodeSpectral(btPCA, btRaw, false);   % keep raw PCA scale for target
else
  %% do standardize, PCA will be similar for all
  targetCoeffs = encodeSpectral(btPCA, btRaw, true);   % keep raw PCA scale for target
end

% Sanity check: how much variance is each basis actually capturing?
% (worth inspecting before you trust nPCA_T/Q/O3 above -- see note at
% bottom of script)
fprintf('T   EOF cum. variance kept: %.5f\n', sum(tPCA.explainedVarRatio(1:nPCA_T)));
fprintf('Q   EOF cum. variance kept: %.5f\n', sum(qPCA.explainedVarRatio(1:nPCA_Q)));
fprintf('O3  EOF cum. variance kept: %.5f\n', sum(o3PCA.explainedVarRatio(1:nPCA_O3)));

%% ------------------------------------------------------------------
%  3. Assemble full input feature matrix
%  ------------------------------------------------------------------
disp('Stage 3 : Assemble FOr DNN')
clear X Y

if iScalar == 0
  X = [tEOF, qEOF, o3EOF, scalarTensor, emisEOF];                   % (nSamples x nFeatures)

elseif iScalar == 1  
  % X = [tEOF, qEOF, o3EOF,        co2EOF, ch4EOF, scalarTensor, emisEOF];   % (nSamples x nFeatures)
  % X = [tEOF, qEOF, o3EOF, tqEOF, co2EOF, ch4EOF, scalarTensor, emisEOF];   % (nSamples x nFeatures)
  % X = [tEOF, qEOF, q2EOF, q3EOF, q4EOF, q5EOF, q6EOF, o3EOF, tqEOF, co2EOF, ch4EOF, scalarTensor, emisEOF];   % (nSamples x nFeatures)  
  % X = [tEOF, t2EOF, t3EOF, t4EOF, t5EOF, t6EOF, qEOF, q2EOF, q3EOF, q4EOF, q5EOF, q6EOF, o3EOF, tqEOF, co2EOF, ch4EOF, scalarTensor, emisEOF, emis_BT];   % (nSamples x nFeatures)

  if iFitChan == 1
    X = [tEOF, qEOF, scalarTensor];
  else
    error('iFitChan')
  end
  
end  
Y = targetCoeffs;                                                 % (nSamples x nPCA_BT)

printarray(size(tEOF),'size(tEOF)')
printarray(size(qEOF),'size(qEOF)')
printarray(size(o3EOF),'size(o3EOF)')
printarray(size(emisEOF),'size(emisEOF)')
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

flag_bad_eof_profiles

%% ------------------------------------------------------------------
%  5. Build MLP parameters (manual dlarray custom-training-loop style)
%  ------------------------------------------------------------------
disp('Stage 5 : getting ready for DNN')

params = struct();
if iHidden == 2
  hidden1 = iNN;
  hidden2 = iNN;

  params.fc1_W = dlarray(initWeights(hidden1, nFeatures));
  params.fc1_b = dlarray(zeros(hidden1,1,'single'));
  params.fc2_W = dlarray(initWeights(hidden2, hidden1));
  params.fc2_b = dlarray(zeros(hidden2,1,'single'));
  params.fc3_W = dlarray(initWeights(nPCA_BT, hidden2));
  params.fc3_b = dlarray(zeros(nPCA_BT,1,'single'));

elseif iHidden == 3
  hidden1 = iNN;
  hidden2 = iNN;
  hidden3 = iNN;

  params.fc1_W = dlarray(initWeights(hidden1, nFeatures));
  params.fc1_b = dlarray(zeros(hidden1,1,'single'));
  params.fc2_W = dlarray(initWeights(hidden2, hidden1));
  params.fc2_b = dlarray(zeros(hidden2,1,'single'));
  params.fc3_W = dlarray(initWeights(hidden3, hidden2));
  params.fc3_b = dlarray(zeros(hidden3,1,'single'));
  params.fc4_W = dlarray(initWeights(nPCA_BT, hidden3));
  params.fc4_b = dlarray(zeros(nPCA_BT,1,'single'));

elseif iHidden == 4
  hidden1 = iNN;
  hidden2 = iNN;
  hidden3 = iNN;
  hidden4 = iNN;  

  params.fc1_W = dlarray(initWeights(hidden1, nFeatures));
  params.fc1_b = dlarray(zeros(hidden1,1,'single'));
  params.fc2_W = dlarray(initWeights(hidden2, hidden1));
  params.fc2_b = dlarray(zeros(hidden2,1,'single'));
  params.fc3_W = dlarray(initWeights(hidden3, hidden2));
  params.fc3_b = dlarray(zeros(hidden3,1,'single'));
  params.fc4_W = dlarray(initWeights(hidden4, hidden3));
  params.fc4_b = dlarray(zeros(hidden3,1,'single'));
  params.fc5_W = dlarray(initWeights(nPCA_BT, hidden4));
  params.fc5_b = dlarray(zeros(nPCA_BT,1,'single'));

else
  error('iHidden = 2,3,4 only')
end

% fixed (non-trained) linear PCA decoder, for evaluation/reconstruction only
decoderW = dlarray(single(btPCA.coeff'));   % (nChannels x nPCA_BT) -> stored transposed for fullyconnect
decoderB = dlarray(single(btPCA.mu(:)));    % (nChannels x 1)

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

