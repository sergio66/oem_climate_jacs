iaTimeStep = [1:50:365];
iaTimeStep = [2 52 102 152 202 252 302 352];

iSubORDiv = 1;

%% see how delta changes with time

%hgload ~chepplew/projects/sarta/prod_2019/airs_l1c/dec2018/figs/kc_sar_r49_reflthrm_mean_stdv_vs_emiss_vs_satzen.fig
hgload ../MakeJacsSARTA/kc_sar_r49_reflthrm_mean_stdv_vs_emiss_vs_satzen.fig

for ii = 1 : length(iaTimeStep)
  iTimeStep = iaTimeStep(ii);
  iStr = num2str(iTimeStep,'%03d');
  fileS = ['../MakeJacsSARTA/SARTA_AIRSL1c_Anomaly365_16_no_seasonal_OldSarta/RESULTS_FiniteDiff_Try3/sarta_' iStr '_tracegas_finitediff_3gas_2645_V3.mat']; %% old sarta, no seasonal
  fileS = ['../MakeJacsSARTA/SARTA_AIRSL1c_Anomaly365_16/RESULTS_FiniteDiff_Try3/sarta_' iStr '_tracegas_finitediff_3gas_2645_V3.mat'];   %% new SARTA, no seasonal
  fileK = ['../MakeJacskCARTA_CLR/Anomaly365_16_12p8/RESULTS_FiniteDiff_Try3/kcarta_' iStr '_tracegas_finitediff_4_2645_V3.mat']; 
  aS = load(fileS);
  aK = load(fileK);

  if iSubORDiv < 0
    figure(1); plot(aS.f,squeeze(aS.tracegas(20,:,1)),'b',aS.f,squeeze(aK.tracegas(20,:,1)),'r'); hl = legend('sarta','kcarta','location','best'); title(iStr); grid
      ax = axis; ax(1) = 640; ax(2) = 2780; axis(ax);
    figure(2); plot(aS.f,squeeze(aS.tracegas(20,:,1))./squeeze(aK.tracegas(20,:,1)),'r'); title(iStr); grid; legend('sarta/kcarta','location','best');
      ax = axis; ax(1) = 640; ax(2) = 2780; ax(3) = -1; ax(4) = 2; axis(ax);
      ax = axis; ax(1) = 640; ax(2) = 2780; ax(3) = 0.5; ax(4) = 1.5; axis(ax);
    deltajac(ii,:) = squeeze(aS.tracegas(20,:,1))./squeeze(aK.tracegas(20,:,1));

    figure(3); plot(aS.f,squeeze(aS.tracegas(20,:,1)),'b',aS.f,squeeze(aK.tracegas(20,:,1)),'r'); hl = legend('sarta','kcarta','location','best'); title(iStr); grid
      ax = axis; ax(1) = 640; ax(2) = 840; axis(ax);
    figure(4); plot(aS.f,squeeze(aS.tracegas(20,:,1))./squeeze(aK.tracegas(20,:,1)),'r'); title(iStr); grid; legend('sarta/kcarta','location','best');
      ax = axis; ax(1) = 640; ax(2) = 840; ax(3) = -1; ax(4) = 2; axis(ax);
      ax = axis; ax(1) = 640; ax(2) = 840; ax(3) = 0.5; ax(4) = 1.5; axis(ax);
  
    figure(5); plot(aS.f,squeeze(aS.tracegas(20,:,1)),'b',aS.f,squeeze(aK.tracegas(20,:,1)),'r'); hl = legend('sarta','kcarta','location','best'); title(iStr); grid
      ax = axis; ax(1) = 790; ax(2) = 795; axis(ax);
    figure(6); plot(aS.f,squeeze(aS.tracegas(20,:,1))./squeeze(aK.tracegas(20,:,1)),'r'); title(iStr); grid; legend('sarta/kcarta','location','best');
      ax = axis; ax(1) = 790; ax(2) = 795; ax(3) = -1; ax(4) = 2; axis(ax);
      ax = axis; ax(1) = 790; ax(2) = 795; ax(3) = 0.5; ax(4) = 1.5; axis(ax);
  
  else
    figure(1); plot(aS.f,squeeze(aS.tracegas(20,:,1)),'b',aS.f,squeeze(aK.tracegas(20,:,1)),'r'); hl = legend('sarta','kcarta','location','best'); title(iStr); grid
      ax = axis; ax(1) = 640; ax(2) = 2780; axis(ax);
    figure(2); plot(aS.f,squeeze(aS.tracegas(20,:,1))-squeeze(aK.tracegas(20,:,1)),'r'); title(iStr); grid; legend('sarta-kcarta','location','best');
      ax = axis; ax(1) = 640; ax(2) = 2780; ax(3) = -1; ax(4) = 2; axis(ax);
      ax = axis; ax(1) = 640; ax(2) = 2780; ax(3) = -0.01; ax(4) = 0.01; axis(ax);
    deltajac(ii,:) = squeeze(aS.tracegas(20,:,1))-squeeze(aK.tracegas(20,:,1));
  
    figure(3); plot(aS.f,squeeze(aS.tracegas(20,:,1)),'b',aS.f,squeeze(aK.tracegas(20,:,1)),'r'); hl = legend('sarta','kcarta','location','best'); title(iStr); grid
      ax = axis; ax(1) = 640; ax(2) = 840; axis(ax);
    figure(4); plot(aS.f,squeeze(aS.tracegas(20,:,1))-squeeze(aK.tracegas(20,:,1)),'r'); title(iStr); grid; legend('sarta-kcarta','location','best');
      ax = axis; ax(1) = 640; ax(2) = 840; ax(3) = -1; ax(4) = 2; axis(ax);
      ax = axis; ax(1) = 640; ax(2) = 840; ax(3) = -0.01; ax(4) = 0.01; axis(ax);
  
    figure(5); plot(aS.f,squeeze(aS.tracegas(20,:,1)),'b',aS.f,squeeze(aK.tracegas(20,:,1)),'r'); hl = legend('sarta','kcarta','location','best'); title(iStr); grid
      ax = axis; ax(1) = 790; ax(2) = 795; axis(ax);
    figure(6); plot(aS.f,squeeze(aS.tracegas(20,:,1))-squeeze(aK.tracegas(20,:,1)),'r'); title(iStr); grid; legend('sarta-kcarta','location','best');
      ax = axis; ax(1) = 790; ax(2) = 795; ax(3) = -1; ax(4) = 2; axis(ax);
      ax = axis; ax(1) = 790; ax(2) = 795; ax(3) = -0.01; ax(4) = 0.01; axis(ax);
  end
  disp('ret to continue'); pause
end

figure(7);
  pcolor(aS.f,iaTimeStep,deltajac); colorbar; shading interp; axis([640 840 0 365]); caxis([-0.005 +0.005]); colorbar
  title('sarta-kcarta'); xlabel('wavenumber'); ylabel('TimeSTep');

iaT = 0.5 * (iaTimeStep(1:end-1) + iaTimeStep(2:end));
timechange = 50*16/365;   %% 365 timesteps in 16 year, and each of the above snapshots is 50 timesteps apart
figure(7);
  pcolor(aS.f,iaT,diff(deltajac)/timechange); colorbar; shading interp; axis([640 840 0 365]); caxis([-0.0002 +0.0002]); colorbar
  title('d(sarta-kcarta)/dt = K/yr'); xlabel('wavenumber'); ylabel('TimeSTep');
