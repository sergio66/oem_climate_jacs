if ~exist('perProfileRMSE')
  perProfileRMSE = sqrt(mean((btReconVal - btTrueVal).^2, 2));  % (nVal x 1)
end

nnIdx = knnsearch(Xtrain, Xval, 'K', 1);
nnDist = sqrt(sum((Xval - Xtrain(nnIdx,:)).^2, 2));

fprintf('Closest train-set neighbor distance for val samples: min %.4f, median %.4f, mean %.4f, max %.4f\n', min(nnDist), median(nnDist), mean(nnDist), max(nnDist));
disp('if min(nnDist) >> 0 then you should be OK')

%nnIdx = knnsearch(Xtrain, Xval, 'K', 1);
%nnDist = sqrt(sum((Xval - Xtrain(nnIdx,:)).^2, 2));

figure(14) ; scatter(nnDist, perProfileRMSE, 10, 'filled');
figure(14) ; plot(nnDist, perProfileRMSE,'.');
figure(14) ; loglog(nnDist, perProfileRMSE,'.');
  ax = axis; line([ax(1) ax(2)],[0.25 0.25]); xlim([ax(1) ax(2)])
xlabel('distance to nearest training neighbor'); ylabel('per-profile RMSE (K)');

whos Xtrain Xval nnIdx nnDist
%  Name            Size                Bytes  Class     Attributes
%  Xtrain      30518x190            23193680  single
%  Xval         7630x190             5798800  single
%  nnIdx        7630x1                 61040  double
%  nnDist       7630x1                 30520  single

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nnIdx = knnsearch(Xtrain, Xtrain, 'K', 2);
someSmallThreshold = 0.1;
someSmallThreshold = 20.0;
closePairs = find(sqrt(sum((Xtrain - Xtrain(nnIdx(:,2),:)).^2,2)) < someSmallThreshold);
btDiff = btRaw(trainIdx(closePairs),:) - btRaw(trainIdx(nnIdx(closePairs,2)),:);
fprintf('BT std dev for near-identical inputs: %.3f K\n', nanstd(btDiff(:)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nFeat = size(Xtrain,2);
fprintf(1,'nFeat = %4i \n',nFeat);
perDimThreshold = 0.3;                          % e.g. avg 0.3 std devs/feature -- genuinely close
distThreshold = perDimThreshold * sqrt(nFeat);   % scale to raw Euclidean distance

nnIdx = knnsearch(Xtrain, Xtrain, 'K', 2);
dist = sqrt(sum((Xtrain - Xtrain(nnIdx(:,2),:)).^2, 2));
closePairs = find(dist < distThreshold);

fprintf('Pairs within tightened threshold: %d\n', numel(closePairs));
if numel(closePairs) > 20
    btDiff = btRaw(trainIdx(closePairs),:) - btRaw(trainIdx(nnIdx(closePairs,2)),:);
    fprintf('BT std dev for genuinely close inputs: %.3f K\n', std(btDiff(:)));
else
    fprintf('Too few genuinely close pairs in the training set to judge.\n');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Feature pruning')

C = corr(Xtrain);
C(logical(eye(size(C)))) = 0;
[maxCorr, idx] = max(abs(C(:)));
[i,j] = ind2sub(size(C), idx);
fprintf('Most correlated pair: features %d and %d, r=%.3f\n', i, j, maxCorr);

highlyRedundant = find(any(abs(C) > 0.95, 2));
fprintf('%d / %d features have a near-duplicate (|r|>0.95) elsewhere\n', numel(highlyRedundant), nFeat);


%%%%%%%%%%%%%%%%%%%%%%%%%

% check whether the redundant pairs are mostly within the same predictor family
% (e.g. adjacent-level partial columns of the same gas)
[iBad,jBad] = find(abs(C) > 0.95 & abs(C) < 1);
% inspect a sample of the (i,j) pairs against your feature name list
featureNames(iBad(1:10))
featureNames(jBad(1:10))
