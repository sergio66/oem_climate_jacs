%% to weight the samples -- remember if you do hist(p.stemp) the majority will be between 270-305 K, at least for ocean

wavenumbersBand = wavenumbers';
surfTemp = p.stemp';

trainLossHistory = zeros(numEpochs,1);
valLossHistory   = zeros(numEpochs,1);

for epoch = 1:numEpochs
    order = randperm(nTrainSamples);
    epochLoss = 0;

    for b = 1:numBatchesPerEpoch
        batchIdx = order((b-1)*miniBatchSize+1 : b*miniBatchSize);

        % earlier code
        % Xb = dlarray(single(Xtrain(batchIdx,:))', 'CB');  % (features x batch)
        % Yb = dlarray(single(Ytrain(batchIdx,:))', 'CB');  % (nPCA_BT x batch)
        % Wb = dlarray(single(sampleWeight(batchIdx))', 'CB'); ;
        % [loss, grads] = dlfeval(@modelGradients, params, Xb, Yb, Wb, iHidden);

        % this code
        % layerFeaturesAll_batch: cell{nLayers}, each (10 x miniBatchSize), sliced from your precomputed per-layer predictor arrays for this batch's profiles
	%layerFeaturesAll_batch = dlarray(single(squeeze(X(batchIdx,:,:))),'CB');

        layerFeaturesAll_batch = cell(nLayersMax,1);
        for k = 1:nLayersMax
          layerFeaturesAll_batch{k} = dlarray(single(squeeze(X(batchIdx, k, :)))', 'CB');  % (10 x miniBatchSize)
        end
	
        % layerTempAll_batch:     (nLayers x miniBatchSize)
	layerTempAll_batch     = dlarray(single(T(batchIdx,:))', 'CB');             % (nLayers x miniBatchSize).
	
        % Rtrue_batch: dlarray 'CB', (nChannelsBand x miniBatchSize), your ACTUAL  stored KCARTA (or KCARTA-SARTA residual) radiance for this band
        Rtrue_batch    = dlarray(single(Ytrain(batchIdx,:))', 'CB');
	surfTempBatch  = dlarray(single(surfTemp(batchIdx))', 'CB');                % (1 x miniBatchSize)
	emisBatch      = dlarray(single(emissivityRaw(batchIdx,:))', 'CB');         % (nChannelsBand x miniBatchSize)
	muBatch        = dlarray(single(1./viewAngleSecant_00(batchIdx))', 'CB');   % (1 x miniBatchSize)
	
        [loss, grads] = dlfeval(@modelGradientsLayerRT, params, layerFeaturesAll_batch, ...
                                layerTempAll_batch, surfTempBatch, emisBatch, muBatch, wavenumbersBand, Rtrue_batch);

        iteration = iteration + 1;
        [params, avgGrad, avgGradSq] = adamupdate(params, grads, avgGrad, avgGradSq, iteration, learnRate);	

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
