% closed-form ridge regression, X: (nTrain x nFeatures), Y: (nTrain x nPCA_BT)
lambda = 1e-3;

%% X A = Y ==> X'X A = X' Y ==> A = inv (X'X) (X'Y) = (X'X) \ (X'Y)
Wridge = (Xtrain'*Xtrain + lambda*eye(size(Xtrain,2))) \ (Xtrain'*Ytrain);
predLinearVal = Xval * Wridge;
linRMSE = sqrt(mean((predLinearVal - Yval).^2, 'all'));
fprintf('Linear baseline val MSE (coeff space): %.5f\n', linRMSE);

predLinearVal_BT = decodeSpectral(btPCA, predLinearVal, false);
linChannelRMSE = sqrt(mean((predLinearVal_BT - btTrueVal).^2, 1));
fprintf('Linear baseline val BT RMSE: mean %.3f K, max %.3f K\n', mean(linChannelRMSE), max(linChannelRMSE));

btLinearVal    = decodeSpectral(btPCA, predLinearVal, false);                     % (nVal x nChannels)
channelRMSE_LINval = sqrt(mean((btLinearVal - btTrueVal).^2, 1));  % (1 x nChannels), Kelvin
fprintf('Validation BT Linear RMSE: mean %.3f K, max %.3f K\n', mean(channelRMSE_LINval), max(channelRMSE_LINval));

figure(3); colormap jet;
  yyaxis left;  plot(freq,nanmean(btLinearVal - btTrueVal),'b',freq,nanstd(btLinearVal - btTrueVal,[],1),'r'); plotaxis2;
    ylabel('bias/std [k]')  
  yyaxis right; plot(freq,nanmean(btLinearVal),'k'); hold on; plot(freq,nanmean(btTrueVal),'color',[1 1 1]*0.6); hold off; plotaxis2;
    legend('mean(KC-calc)','std(KC-calc)','mean(KC)','location','best')
    ylabel('actual mean [k]'); xlabel('Waveumber cm-1')    
title('Validation : Linear Regr')    

%%%%%%%%%%%%%%%%%%%%%%%%%

figure(7); clf
plot(wavenumbers, channelRMSE_NNtrain, 'b', wavenumbers, channelRMSE_NNval, 'r', wavenumbers, channelRMSE_LINval,'g');
hold on;  plot(freq,nanmean(btTrueVal),'color',[1 1 1]*0.6,'linewidth',2); hold off; plotaxis2;
legend('NN train','NN val','linearregr val','Signal To Fit'); xlabel('wavenumber (cm^{-1})'); ylabel('RMSE (K)');
  title('RMSE : Training and Validation and Linear')

