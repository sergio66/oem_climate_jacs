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
channelRMSE = sqrt(mean((btLinearVal - btTrueVal).^2, 1));  % (1 x nChannels), Kelvin
fprintf('Validation BT Linear RMSE: mean %.3f K, max %.3f K\n', mean(channelRMSE), max(channelRMSE));
  
figure(7); colormap jet;
  yyaxis left;  plot(freq,nanmean(btLinearVal - btTrueVal),'b',freq,nanstd(btLinearVal - btTrueVal,[],1),'r')    
  yyaxis right; plot(freq,nanmean(btLinearVal),'k')
    legend('mean(KC-calc)','std(KC-calc)','mean(KC)','location','best')
title('Linear Regr')    

