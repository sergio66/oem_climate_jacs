addpath /home/sergio/git/matlabcode/SHOWSTATS
addpath /home/sergio/git/matlabcode/CONVERT_GAS_UNITS

% ------------------------------------------------------------------
%  7. Evaluate: reconstruct full BT spectrum and check channel-wise error
%  ------------------------------------------------------------------
disp('Stage 7 : Validate against VAL dataset')
if iStd < 0
  fprintf('iHidden value at validation call = %d\n', iHidden);
  Xv = dlarray(single(Xval)','CB');
  predCoeffsVal = extractdata(forwardMLP(params, Xv,iHidden))';  % (nVal x nPCA_BT)
  btReconVal    = decodeSpectral(btPCA, predCoeffsVal, false);                     % (nVal x nChannels)
else
  fprintf('iHidden value at validation call = %d\n', iHidden);
  Xv = dlarray(single(Xval)','CB');
  predCoeffsVal = extractdata(forwardMLP(params, Xv,iHidden))';  % (nVal x nPCA_BT)
  btReconVal    = decodeSpectral(btPCA, predCoeffsVal, true);                     % (nVal x nChannels)
end  
btTrueVal     = btRaw(valIdx,:);

channelRMSE_NNval = sqrt(mean((btReconVal - btTrueVal).^2, 1));  % (1 x nChannels), Kelvin
fprintf('Validation BT RMSE: mean %.3f K, max %.3f K\n', mean(channelRMSE_NNval), max(channelRMSE_NNval));
figure(1); colormap jet; clf
plot(freq,nanmean(btReconVal),'b',freq,nanmean(btTrueVal),'r')
  yyaxis left;  plot(freq,nanmean(btReconVal - btTrueVal),'b',freq,nanstd(btReconVal - btTrueVal,[],1),'r')
    ylabel('bias/std [k]')
  yyaxis right; plot(freq,nanmean(btReconVal),'k'); hold on; plot(freq,nanmean(btTrueVal),'color',[1 1 1]*0.6); hold off
    legend('mean(KC-calc)','std(KC-calc)','mean(KC)','location','best')
    ylabel('actual mean [k]'); xlabel('Waveumber cm-1')
title('NN : Validation')

%%%%%%%%%%%%%%%%%%%%%%%%%

% You already have the pieces from earlier in the script — you just
% haven't run the same reconstruction check on the training set that you
% ran on validation. Add this after your evaluation block (works for
% either the EOF or CNN version, since both save params and reuse
% forwardMLP/forwardCNN + btPCA): matlab% --- training-set
% reconstruction error, same as your validation check ---

Xt = dlarray(single(Xtrain)', 'CB');            % EOF version
% Pt = dlarray(single(permute(profTrain,[2 3 1])), 'SCB'); Sb = dlarray(single(scalTrain)','CB'); % CNN version instead

disp('Stage 7 : Validate against TRAIN dataset')
if iStd < 0
  predCoeffsTrain = extractdata(forwardMLP(params, Xt,iHidden))';      % swap for forwardCNN(params, Pt, Sb) in CNN version
  btReconTrain    = decodeSpectral(btPCA, predCoeffsTrain, false);
else
  predCoeffsTrain = extractdata(forwardMLP(params, Xt,iHidden))';      % swap for forwardCNN(params, Pt, Sb) in CNN version
  btReconTrain    = decodeSpectral(btPCA, predCoeffsTrain, true);
end
btTrueTrain     = btRaw(trainIdx,:);

channelRMSE_NNtrain = sqrt(mean((btReconTrain - btTrueTrain).^2, 1));
fprintf('Train BT RMSE: mean %.3f K, max %.3f K\n', mean(channelRMSE_NNtrain), max(channelRMSE_NNtrain));
fprintf('Val   BT RMSE: mean %.3f K, max %.3f K\n', mean(channelRMSE_NNtrain), max(channelRMSE_NNtrain));

figure(2); clf; colormap jet;
  yyaxis left;  plot(freq,nanmean(btReconTrain - btTrueTrain),'b',freq,nanstd(btReconTrain - btTrueTrain,[],1),'r')
    ylabel('bias/std [k]')  
  yyaxis right; plot(freq,nanmean(btReconTrain),'k'); hold on; plot(freq,nanmean(btTrueTrain),'color',[1 1 1]*0.6); hold off
    legend('mean(KC-calc)','std(KC-calc)','mean(KC)','location','best')
    ylabel('actual mean [k]'); xlabel('Waveumber cm-1')    
title('NN : Training')    

figure(3); clf
plot(wavenumbers, channelRMSE_NNtrain, 'b-', wavenumbers, channelRMSE_NNval, 'r-');
legend('train','val'); xlabel('wavenumber (cm^{-1})'); ylabel('RMSE (K)');
title('RMSE : Training and Validation')
%%%%%%%%%%%%%%%%%%%%%%%%%

%% more diagnostics

disp(' ')
fprintf(1,'size Validation = %5i Training = %5i \n',length(valIdx),length(trainIdx))
disp(' ')

btRoundTrip = decodeSpectral(btPCA, encodeSpectral(btPCA, btTrueVal, false), false);
truncRMSE = sqrt(mean((btRoundTrip - btTrueVal).^2, 1));
fprintf('PCA truncation-only RMSE: mean %.3f K, max %.3f K\n', mean(truncRMSE), max(truncRMSE));

%%%%%%%%%%%%%%%%%%%%%%%%%

dbt = -5:0.1:+5;
if length(freq) == 2645
  i1231 = 1520;
else
  i1231 = floor(length(freq)/2);
end
figure(4); clf; plot(trainIdx,btReconTrain(:,i1231) - btTrueTrain(:,i1231),'b.',valIdx,btReconVal(:,i1231) - btTrueVal(:,i1231),'r.')
  legend('bias Train','bias Val','location','best');
figure(5); clf; plot(dbt,hist(btReconTrain(:,i1231) - btTrueTrain(:,i1231),dbt))
figure(5); clf; plot(dbt,hist(btReconTrain(:,i1231) - btTrueTrain(:,i1231),dbt),dbt,hist(btReconVal(:,i1231) - btTrueVal(:,i1231),dbt))
figure(5); clf; plot(dbt,hist(btReconTrain(:,i1231) - btTrueTrain(:,i1231),dbt)/length(trainIdx),...
                dbt,hist(btReconVal(:,i1231) - btTrueVal(:,i1231),dbt)/length(valIdx))
           grid; set(gca,'yscale','log') 
  legend('hist Train','hist Val','location','best');
  title('histogram Actual-Reconstruct')
  xlabel('dbt [K]'); ylabel('Normalized hist = h(x)/nsamples')
  
figure(6); clf;
badTrain = abs(btReconTrain(:,i1231) - btTrueTrain(:,i1231)); badTrain = find(badTrain == max(badTrain),1);
badVal   = abs(btReconVal(:,i1231) - btTrueVal(:,i1231));     badVal = find(badVal == max(badVal),1);
plot(freq,btTrueTrain(badTrain,:),'b',freq,btReconTrain(badTrain,:),'c',freq,btTrueVal(badVal,:),'r',freq,btReconVal(badVal,:),'m')
plot(freq,btTrueTrain(badTrain,:) - btReconTrain(badTrain,:),'b',freq,btTrueVal(badVal,:) - btReconVal(badVal,:),'r')
  legend('btTrueTrain - btReconTrain','btTrueVal - btReconVal');
  ylabel('Worst difference [K]')

figure(6); clf
badTrain = abs(btReconTrain(:,i1231) - btTrueTrain(:,i1231)); badTrain = find(badTrain >= 0.75*max(badTrain));
badVal   = abs(btReconVal(:,i1231) - btTrueVal(:,i1231));     badVal = find(badVal >= 0.75*max(badVal));
badTrain = abs(btReconTrain(:,i1231) - btTrueTrain(:,i1231)); badTrain = find(badTrain >= 2);
badVal   = abs(btReconVal(:,i1231) - btTrueVal(:,i1231));     badVal = find(badVal >= 2);
if length(badTrain) > 0 & length(badVal) > 0
  plot(freq,btTrueTrain(badTrain,:),'b',freq,btReconTrain(badTrain,:),'c',freq,btTrueVal(badVal,:),'r',freq,btReconVal(badVal,:),'m')
  plot(freq,btTrueTrain(badTrain,:) - btReconTrain(badTrain,:),'b',freq,btTrueVal(badVal,:) - btReconVal(badVal,:),'r')
    legend('btTrueTrain - btReconTrain','btTrueVal - btReconVal');
    ylabel('Worst difference [K]')
end

%%%%%%%%%%%%%%%%%%%%%%%%%

figure(8); clf
[nn nx ny nmean nstd] = myhist2d(px.stemp(trainIdx),btReconTrain(:,i1231) - btTrueTrain(:,i1231),200:5:350,-5:0.25:+5);
  errorbar(200:5:350,nmean,nstd); plotaxis2; title('training 2dhist');  xlabel('SKT')

mmw = mmwater_rtp(h,p);
[nn nx ny nmean nstd] = myhist2d(mmw(trainIdx),btReconTrain(:,i1231) - btTrueTrain(:,i1231),0:5:120,-5:0.25:+5);
  errorbar(0:5:120,nmean,nstd); plotaxis2; title('training 2dhist');  xlabel('mmw')

[nn nx ny nmean nstd] = myhist2d(p.scanang(trainIdx),btReconTrain(:,i1231) - btTrueTrain(:,i1231),0:5:60,-5:0.25:+5);
  errorbar(0:5:60,nmean,nstd); plotaxis2; title('training 2dhist');  xlabel('scanang')

[nn nx ny nmean nstd] = myhist2d(emissivityRaw(trainIdx,i1231),btReconTrain(:,i1231) - btTrueTrain(:,i1231),0:0.01:1,-5:0.25:+5);
  errorbar(0:0.01:1,nmean,nstd); plotaxis2; title('training 2dhist');  xlabel('EMISSIVITY')

%%%%%%%%%%%%%%%%%%%%%%%%%

figure(9); clf
[nn nx ny nmean nstd] = myhist2d(px.stemp(valIdx),btReconVal(:,i1231) - btTrueVal(:,i1231),200:5:350,-5:0.25:+5);
  errorbar(200:5:350,nmean,nstd); plotaxis2; title('validation 2dhist');  xlabel('SKT')

mmw = mmwater_rtp(h,p);
[nn nx ny nmean nstd] = myhist2d(mmw(valIdx),btReconVal(:,i1231) - btTrueVal(:,i1231),0:5:120,-5:0.25:+5);
  errorbar(0:5:120,nmean,nstd); plotaxis2; title('validation 2dhist');  xlabel('mmw')

[nn nx ny nmean nstd] = myhist2d(p.scanang(valIdx),btReconVal(:,i1231) - btTrueVal(:,i1231),0:5:60,-5:0.25:+5);
  errorbar(0:5:60,nmean,nstd); plotaxis2; title('validation 2dhist');  xlabel('scanang')

[nn nx ny nmean nstd] = myhist2d(emissivityRaw(valIdx,i1231),btReconVal(:,i1231) - btTrueVal(:,i1231),0:0.01:1,-5:0.25:+5);
  errorbar(0:0.01:1,nmean,nstd); plotaxis2; title('validation 2dhist');  xlabel('EMISSIVITY')

