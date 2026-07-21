%% to weight the samples -- remember if you do hist(p.stemp) the majority will be between 270-305 K, at least for ocean

stempTrain = surfTemp;

if useWeighting
  disp('>>>> epoch_loop.m : weighting stemp')
  nBins = 20;
  edges = linspace(min(stempTrain), max(stempTrain), nBins+1);
  [counts, ~, binIdx] = histcounts(stempTrain, edges);
  sampleWeight = 1 ./ counts(binIdx)';        % inverse frequency
  sampleWeight = sampleWeight / mean(sampleWeight);   % keep loss scale comparable
else
  disp('>>>> epoch_loop.m : not weighting ... unity weights')
  sampleWeight = ones(size(surfTemp));  %% noweighting
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

trainLossHistory = zeros(numEpochs,1);
valLossHistory   = zeros(numEpochs,1);

for epoch = 1:numEpochs
    order = randperm(nTrainSamples);
    epochLoss = 0;

    for b = 1:numBatchesPerEpoch
        batchIdx = order((b-1)*miniBatchSize+1 : b*miniBatchSize);
        Xb = dlarray(single(Xtrain(batchIdx,:))', 'CB');  % (features x batch)
        Yb = dlarray(single(Ytrain(batchIdx,:))', 'CB');  % (nPCA_BT x batch)
        Wb = dlarray(single(sampleWeight(batchIdx))', 'CB'); ;

        [loss, grads] = dlfeval(@modelGradients, params, Xb, Yb, Wb, iHidden);

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
