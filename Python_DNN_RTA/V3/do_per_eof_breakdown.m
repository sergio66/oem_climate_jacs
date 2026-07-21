btTargetResidualVal = btReconVal;
coeffErr = predCoeffsVal - encodeSpectral(btPCA, btTargetResidualVal, false);  % (nVal x nPCA_BT), your current best model
coeffErrStd = std(coeffErr, 0, 1);                     % (1 x nPCA_BT)
coeffContribution = coeffErrStd .* sqrt(sum(btPCA.coeff.^2, 1));  % rough per-component contribution to spectral RMS

[sortedContrib, order] = sort(coeffContribution, 'descend');
fprintf('Top 5 error-contributing components: %s\n', mat2str(order(1:5)));
fprintf('Their std errors: %s\n', mat2str(coeffErrStd(order(1:5)), 3));
fprintf('Explained variance ratio of those same components (from btPCA): %s\n', ...
        mat2str(btPCA.explainedVarRatio(order(1:5))', 3));

figure(15); clf
  plot(wavenumbers, btPCA.coeff(:,1), 'r',wavenumbers, nanmean(btTargetResidualVal,1)/200,'k', wavenumbers, nanstd(btTargetResidualVal,1)/200,'g');
  xlabel('wavenumber (cm^{-1})'); ylabel('EOF1 loading');
  plotaxis2;
  legend('EOF1','mean(Target Val)','std(Traget Val)');

figure(16); clf
  scatter(surfTemp(valIdx), coeffErr(:,1), 8, 'filled');
  xlabel('surf temp (K)'); ylabel('component-1 coefficient error');
  hold on
    plot(surfTemp(valIdx), (btReconVal(:,i1231) - btTrueVal(:,i1231))/100/20,'r.')
  hold off
  legend('EOF components1 error','BT1231 fitting error','location','best')
  
