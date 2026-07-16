trainLossHistory = zeros(numEpochs,1);
valLossHistory   = zeros(numEpochs,1);

for epoch = 1:numEpochs
    order = randperm(nTrainSamples);
    epochLoss = 0;

    for b = 1:numBatchesPerEpoch
        batchIdx = order((b-1)*miniBatchSize+1 : b*miniBatchSize);
        Xb = dlarray(single(Xtrain(batchIdx,:))', 'CB');  % (features x batch)
        Yb = dlarray(single(Ytrain(batchIdx,:))', 'CB');  % (nPCA_BT x batch)

        [loss, grads] = dlfeval(@modelGradients, params, Xb, Yb, iHidden);

        iteration = iteration + 1;
        [params, avgGrad, avgGradSq] = adamupdate(params, grads, ...
            avgGrad, avgGradSq, iteration, learnRate);

        epochLoss = epochLoss + double(loss) * numel(batchIdx);
    end
    epochLoss = epochLoss / (numBatchesPerEpoch*miniBatchSize);

    % validation loss
    Xv = dlarray(single(Xval)', 'CB');
    Yv = dlarray(single(Yval)', 'CB');
    predVal = forwardMLP(params, Xv, iHidden);
    valLoss = double(mean((predVal - Yv).^2, 'all'));

    trainLossHistory(epoch) = epochLoss;
    valLossHistory(epoch)   = valLoss;

    if mod(epoch,5) == 0 || epoch == 1
        fprintf('epoch %3d  train MSE %.5f  val MSE %.5f\n', epoch, epochLoss, valLoss);
    end
end

figure(3);
plot(1:numEpochs, trainLossHistory, 'b-', 1:numEpochs, valLossHistory, 'r-');
semilogy(1:numEpochs, trainLossHistory, 'b-', 1:numEpochs, valLossHistory, 'r-');
legend('train','val'); xlabel('epoch'); ylabel('MSE (standardized coeff space)');
