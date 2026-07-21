figure(3); imagesc(tEOF'); colorbar; colormap(jet); caxis([-1 +1]*5); colormap(usa2); title('tEOF')
figure(4); imagesc(qEOF'); colorbar; colormap(jet); caxis([-1 +1]*5); colormap(usa2); title('qEOF')
figure(5); imagesc(o3EOF'); colorbar; colormap(jet); caxis([-1 +1]*5); colormap(usa2); title('o3EOF')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

qScores  = encodeSpectral(qPCA, Q_log, false);    % (nSamples x nPCA_Q)
o3Scores = encodeSpectral(o3PCA, O3_log, false);

%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot the 4th component since THAT EOF looks messed up
messupIdx = 4;
figure(6); clf
scatter(surfTemp(trainIdx), qScores(trainIdx,messupIdx), 8, 'filled');
xlabel('surf temp (K)'); ylabel('Q PC4 score'); title('Q EOF component 4 vs SST');

figure(7); clf
scatter(surfTemp(trainIdx), o3Scores(trainIdx,messupIdx), 8, 'filled');
xlabel('surf temp (K)'); ylabel('O3 PC4 score');

%%%%%%%%%%%%%%%%%%%%%%%%%
%% flag outliers
med4 = median(qScores(trainIdx,messupIdx));
mad4 = mad(qScores(trainIdx,messupIdx), 1);
outlierMask = abs(qScores(trainIdx,messupIdx) - med4) > 6*mad4;
fprintf('Flagged %d / %d profiles as Q-PC4 outliers\n', sum(outlierMask), numel(outlierMask));

%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot them in sigma space

flaggedIdx = find(outlierMask);
normalIdx  = find(~outlierMask);
sampleFlagged = flaggedIdx(randperm(numel(flaggedIdx), min(20,numel(flaggedIdx))));
sampleNormal  = normalIdx(randperm(numel(normalIdx), 20));

figure(8); clf; hold on;
for k = sampleFlagged', plot(Q_log(k,:), 1:nLevels, 'm-'); end
for k = sampleNormal',  plot(Q_log(k,:), 1:nLevels, 'c-'); end
set(gca,'YDir','reverse'); xlabel('log(Q)'); ylabel('sigma level index');
legend({'flagged','','','','','','','','','','normal'});
hold on
  plot(nanmean(Q_log(sampleFlagged,:),1), 1:nLevels,'r','linewidth',4);
  plot(nanmean(Q_log(sampleNormal,:),1), 1:nLevels,'b','linewidth',4);
hold off  
set(gca,'yscale','log')

%% plot them in p,Q(p) space
figure(9); clf; hold on
 plot(p.gas_1(:,iFlag(sampleFlagged)), p.plays(:,iFlag(sampleFlagged)), 'm-')
 plot(p.gas_1(:,iFlag(sampleNormal)), p.plays(:,iFlag(sampleNormal)), 'c-')
set(gca,'YDir','reverse'); xlabel('log(Q)'); ylabel('sigma level index');
legend({'flagged','','','','','','','','','','normal'});
hold on
  plot(nanmean(p.gas_1(:,iFlag(sampleFlagged)),2),nanmean(p.plays(:,iFlag(sampleFlagged)),2),'r','linewidth',4);
  plot(nanmean(p.gas_1(:,iFlag(sampleNormal)),2),nanmean(p.plays(:,iFlag(sampleNormal)),2),'b','linewidth',4);  
hold off  
set(gca,'yscale','log'); 
set(gca,'xscale','log')
axis([1e15 1e23 100 1100])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[~, peakLevel] = max(abs(qPCA.coeff(:,4)));
fprintf('PC4 loads most heavily on PC level %d ... going to plot this in real Q_log space \n', peakLevel);
figure(10); clf
histogram(Q_log(flaggedIdx, peakLevel)); hold on;
histogram(Q_log(normalIdx, peakLevel));
legend('flagged','normal'); xlabel(sprintf('log(Q) at level %d', peakLevel));
