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
