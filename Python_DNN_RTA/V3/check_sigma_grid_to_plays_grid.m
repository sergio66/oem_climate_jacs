sampleIdx = ceil(rand(1,200)*length(p.stemp));
sampleIdx = sampleIdx(sampleIdx <= length(p.stemp));

sigmaSrc    = zeros(length(sampleIdx),101);
nativePlays = zeros(length(sampleIdx),101);
nativeTErr  = zeros(length(sampleIdx),101);
nativeQErr  = zeros(length(sampleIdx),101);
nativeO3Err = zeros(length(sampleIdx),101);
nativeT1    = zeros(length(sampleIdx),101);
nativeT2    = zeros(length(sampleIdx),101);
nativeQ1    = zeros(length(sampleIdx),101);
nativeQ2    = zeros(length(sampleIdx),101);
nativeO31    = zeros(length(sampleIdx),101);
nativeO32    = zeros(length(sampleIdx),101);
for ij = 1 : length(sampleIdx)

  ii = sampleIdx(ij);

  nlays = p.nlevs(ii)-1;
  plays = p.plays(1:nlays,ii);
  plevs = p.plevs(1:nlays+1,ii);  

  x2frac  = (plevs(nlays) - p.spres(ii))/(plevs(nlays)-plevs(nlays+1));
  x2plays = (plevs(nlays)-p.spres(ii))/log(plevs(nlays)/p.spres(ii));
  plays(end) = x2plays;

  p_end = p.spres(ii);
  p_end = plays(end);
  p_end = max(plays);  

  y = p.ptemp(1:nlays,ii);
  y(end) = interp1(log(plays),y,log(xplays(ii)),[],'extrap');

  nativePlays(ij,1:length(y)) = plays;
  
  interpBack = interp1(refSigma, T_00(ii,:), plays/p_end, 'linear','extrap');
  sigmaSrc(ij,1:length(y)) = plays/p_end;  
  nativeT1(ij,1:length(y)) = interpBack;
  nativeT2(ij,1:length(y)) = y;    
  nativeTErr(ij,1:length(y)) = interpBack - y;

  y = p.gas_1(1:nlays,ii);
  y(end) = y(end)*x2frac;
  interpBack = interp1(refSigma, Q_00(ii,:), plays/p_end, 'linear','extrap');
  nativeQ1(ij,1:length(y)) = interpBack;
  nativeQ2(ij,1:length(y)) = y;    
  nativeQErr(ij,1:length(y)) = (interpBack - y)./y;

  y = p.gas_3(1:nlays,ii);
  y(end) = y(end)*x2frac;
  interpBack = interp1(refSigma, O3_00(ii,:), plays/p_end, 'linear','extrap');
  nativeO31(ij,1:length(y)) = interpBack;
  nativeO32(ij,1:length(y)) = y;    
  nativeO3Err(ij,1:length(y)) = (interpBack - y)./y;

end

fprintf('Native-grid T interpolation RMSE: %.3f K\n', sqrt(mean(nativeTErr(:).^2)));
figure(1); clf; 
plot(nativeTErr,1:101); set(gca,'ydir','reverse'); ylim([1 101])
plot(nanmean(nativeT1,1),1:101,'bo-',nanmean(nativeT2,1),1:101,'r.-')
subplot(131);
  plot(nanmean(nativeT1 - nativeT2,1),1:101,'r.-')
  set(gca,'ydir','reverse'); ylim([1 101])
  title('avg \delta T')
subplot(132);
  plot(nanmean(nativeT2,1),1:101,'r.-',nanmean(nativeT1,1),1:101,'k--')
  set(gca,'ydir','reverse'); ylim([1 101])
  title('avg T')
subplot(133);
  wah = max(nanmean(nativeT2,1));
  plot(nanmean(nativeT2,1)/wah,1:101,'r.-')
  set(gca,'ydir','reverse'); ylim([1 101])
  title('avg T/max(avg(T))')
  
fprintf('Native-grid Q interpolation RMSE: %.3f frac\n', sqrt(mean(nativeQErr(:).^2)));
figure(2); clf; 
plot(nativeQErr,1:101); set(gca,'ydir','reverse'); ylim([1 101])
plot(nanmean(nativeQ1,1),1:101,'bo-',nanmean(nativeQ2,1),1:101,'r.-')
subplot(131);
  plot(nanmean(nativeQ1./nativeQ2 - 1,1),1:101,'b.-')
  set(gca,'ydir','reverse'); ylim([1 101])
  title('avg \delta WV')  
subplot(132);
  semilogx(nanmean(nativeQ2,1),1:101,'b.-',nanmean(nativeQ1,1),1:101,'k--')
  set(gca,'ydir','reverse'); ylim([1 101])
  title('avg WV')
subplot(133);
  wah = max(nanmean(nativeQ2,1));
  semilogx(nanmean(nativeQ2,1)/wah,1:101,'b.-')
  set(gca,'ydir','reverse'); ylim([1 101])
  title('avg WV/max(avg(WV))')
  
fprintf('Native-grid OZ interpolation RMSE: %.3f frac\n', sqrt(mean(nativeO3Err(:).^2)));
figure(3); clf; 
plot(nativeO3Err,1:101); set(gca,'ydir','reverse'); ylim([1 101])
plot(nanmean(nativeO31,1),1:101,'bo-',nanmean(nativeO32,1),1:101,'r.-')
subplot(131)
  plot(nanmean(nativeO31./nativeO32 - 1,1),1:101,'g.-')
  set(gca,'ydir','reverse'); ylim([1 101])
  xlim([-1 +2])
  title('avg \delta O3')  
subplot(132)
  semilogx(nanmean(nativeO32,1),1:101,'g.-',nanmean(nativeO31,1),1:101,'k--')
  set(gca,'ydir','reverse'); ylim([1 101])
  title('avg O3')  
subplot(133);
  wah = max(nanmean(nativeO32,1));
  semilogx(nanmean(nativeO32,1)/wah,1:101,'b.-')
  set(gca,'ydir','reverse'); ylim([1 101])
  title('avg O3/max(avg(O3))')

disp(' ')
fprintf(1,'how many of your 100 reference points (refSigma) actually land up there (refSigma < 0.1) ? %2i \n if < 10 this may be problem %2i \n',    sum(refSigma < 0.1))
disp(' ')

worstIdx = nativeT1 - nativeT2;
worstIdx = abs(worstIdx);
worstIdx = sum(worstIdx,1);
worstIdx = find(worstIdx == max(worstIdx),1);
ij = worstIdx(1);
printarray(sigmaSrc(ij,:),'this is SigmaSrc for worst index')
printarray([refSigma(1:20); sigmaSrc(ij,1:20)]','comparison of (L) refSigma vs (R) sigmaSrc')
