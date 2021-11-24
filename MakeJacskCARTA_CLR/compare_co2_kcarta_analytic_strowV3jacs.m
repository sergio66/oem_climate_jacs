%sergio = load('Anomaly365_16_12p8/RESULTS/kcarta_365_M_TS_jac_all_5_97_97_97_2645.mat');

addpath /asl/matlib/h4tools
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS

iLatbin = 20; dTimeStep = 50;

iLatbin = 3; dTimeStep = 5;

for iTimeStep = 2 : 50 : 365

  sergio = load(['Anomaly365_16_12p8/' num2str(iTimeStep,'%03d') '/jac_results_' num2str(iLatbin) '.mat']);
  sergio = load(['Anomaly365_16_12p8/RESULTS/kcarta_' num2str(iTimeStep,'%03d') '_M_TS_jac_all_5_97_97_97_2645.mat']);

  %%% OH OH THIS HAS LARGE HOLES IN IT, NEED TO BE FILLED (GUESS CLUSTER CRASHED EVER SO OFTEN)
  %strow0  = load(['Anomaly365_16_12p8_tillAug25_2019/001/strowfinitejac_convolved_kcarta_airs_' num2str(iLatbin) '_jac3.mat']);
  %strow   = load(['Anomaly365_16_12p8_tillAug25_2019/' num2str(iTimeStep,'%03d') '/strowfinitejac_convolved_kcarta_airs_' num2str(iLatbin) '_jac3.mat']);
  %strowx  = load(['Anomaly365_16_12p8_tillAug25_2019/RESULTS_FiniteDiff_Try3_noCFC12/kcarta_' num2str(iTimeStep,'%03d') '_tracegas_finitediff_4_2645_V3.mat']);
  strow0  = load(['Anomaly365_16_12p8/001/strowfinitejac_convolved_kcarta_airs_' num2str(iLatbin) '_jac4.mat']);
  strow   = load(['Anomaly365_16_12p8/' num2str(iTimeStep,'%03d') '/strowfinitejac_convolved_kcarta_airs_' num2str(iLatbin) '_jac4.mat']);
  strowx  = load(['Anomaly365_16_12p8/RESULTS_FiniteDiff_Try3/kcarta_' num2str(iTimeStep,'%03d') '_tracegas_finitediff_5_2645_V4.mat']);

  use_this_rtp    = ['AnomSym/timestep_' num2str(iTimeStep,'%03d') '16day_avg.rp.rtp'];
  use_this_rtp370 = 'AnomSym/timestep_001_16day_avg.rp.rtp';

  %fsergio = sergio.fKc;
  fsergio = sergio.f;
  fstrow  = strowx.f;
  
  %co2sergio = sergio.tracegas(:,1);
  co2sergio = squeeze(sergio.M_TS_jac_all(iLatbin,:,1));
  co2strow = squeeze(strowx.tracegas(iLatbin,:,1));
  figure(1)
    subplot(311); plot(fstrow,co2strow,'b.',fsergio,co2sergio,'r'); ax = axis; ax(1) = min(fstrow); ax(2) = max(fstrow); ax(2) = ax(1) + 200; axis(ax);
      title(['CO2 ' num2str(iTimeStep)]);
    subplot(312); plot(fstrow,100*(1-co2strow./co2sergio),'r'); ax = axis; ax(1) = min(fstrow); ax(2) = max(fstrow); ax(2) = ax(1) + 200;
      ax(3) = -25; ax(4) = +25; axis(ax);
     grid
    subplot(313); plot(strow.fKc,rad2bt(strow.fKc,strow.rKc(:,1))); ax = axis; ax(1) = min(fstrow); ax(2) = max(fstrow); ax(2) = ax(1) + 200; axis(ax); grid

  %ch4sergio = sergio.tracegas(:,1);
  ch4sergio = squeeze(sergio.M_TS_jac_all(iLatbin,:,3));
  ch4strow = squeeze(strowx.tracegas(iLatbin,:,3));
  figure(2)
    subplot(311); plot(fstrow,ch4strow,'b.',fsergio,ch4sergio,'r'); ax = axis; ax(1) = 1200; ax(2) = max(fstrow); ax(2) = ax(1) + 200; axis(ax);
      title(['CH4 ' num2str(iTimeStep)]);
    subplot(312); plot(fstrow,100*(1-ch4strow./ch4sergio),'r'); ax = axis; ax(1) = 1200; ax(2) = max(fstrow); ax(2) = ax(1) + 200;
      ax(3) = -25; ax(4) = +25; axis(ax);
     grid
    subplot(313); plot(strow.fKc,rad2bt(strow.fKc,strow.rKc(:,1))); ax = axis; ax(1) = 1200; ax(2) = max(fstrow); ax(2) = ax(1) + 200; axis(ax); grid

  %ch4sergio = sergio.tracegas(:,1);
  cfc11sergio = squeeze(sergio.M_TS_jac_all(iLatbin,:,4));
  cfc11strow = squeeze(strowx.tracegas(iLatbin,:,4));
  figure(3)
    subplot(311); plot(fstrow,cfc11strow,'b.',fsergio,cfc11sergio,'r'); ax = axis; ax(1) = 800; ax(2) = max(fstrow); ax(2) = ax(1) + 200; axis(ax);
      title(['CFC11 ' num2str(iTimeStep)]);
    subplot(312); plot(fstrow,100*(1-cfc11strow./cfc11sergio),'r'); ax = axis; ax(1) = 800; ax(2) = max(fstrow); ax(2) = ax(1) + 200;
      ax(3) = -5; ax(4) = +51; axis(ax);
     grid
    subplot(313); plot(strow.fKc,rad2bt(strow.fKc,strow.rKc(:,1))); ax = axis; ax(1) = 800; ax(2) = max(fstrow); ax(2) = ax(1) + 200; axis(ax); grid

  disp('ret to continue'); pause
end

