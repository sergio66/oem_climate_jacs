%sergio = load('Anomaly365_16_12p8/RESULTS/kcarta_365_M_TS_jac_all_5_97_97_97_2645.mat');

addpath /asl/matlib/h4tools
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS

iLatbin = 3; dTimeStep = 5;
iLatbin = 20; dTimeStep = 50;


for iTimeStep = 2 : 50 : 365

  %%% OH OH THIS HAS LARGE HOLES IN IT, NEED TO BE FILLED (GUESS CLUSTER CRASHED EVER SO OFTEN)
  strowA0  = load(['Anomaly365_16_12p8_tillAug25_2019/001/strowfinitejac_convolved_kcarta_airs_' num2str(iLatbin) '_jac3.mat']);
  strowA   = load(['Anomaly365_16_12p8_tillAug25_2019/' num2str(iTimeStep,'%03d') '/strowfinitejac_convolved_kcarta_airs_' num2str(iLatbin) '_jac3.mat']);

  %%% FILLING THEM IN
  strowB0  = load(['Anomaly365_16_12p8/001/strowfinitejac_convolved_kcarta_airs_' num2str(iLatbin) '_jac4.mat']);
  strowB   = load(['Anomaly365_16_12p8/' num2str(iTimeStep,'%03d') '/strowfinitejac_convolved_kcarta_airs_' num2str(iLatbin) '_jac4.mat']);

  use_this_rtp    = ['AnomSym/timestep_' num2str(iTimeStep,'%03d') '16day_avg.rp.rtp'];
  use_this_rtp370 = 'AnomSym/timestep_001_16day_avg.rp.rtp';

  fstrow  = strowA.fKc;
  
  t0A = rad2bt(fstrow,strowA0.rKc);
  t0B = rad2bt(fstrow,strowB0.rKc);
  tA  = rad2bt(fstrow,strowA.rKc);
  tB  = rad2bt(fstrow,strowB.rKc);

  figure(1); plot(fstrow,t0A-t0B);
  figure(2); plot(fstrow,t0A);
  figure(3); plot(fstrow,t0A(:,1)*ones(1,6)-t0A);

  jacA = tA-t0A;
  jacB = tB-t0B;
  jacA = tA(:,1)*ones(1,5)-tA(2:6);
  jacB = tB(:,1)*ones(1,5)-tB(2:6);
  figure(4); 
    subplot(511); plot(fstrow,jacA(:,1));
    subplot(512); plot(fstrow,jacA(:,2));
    subplot(513); plot(fstrow,jacA(:,3));
    subplot(514); plot(fstrow,jacA(:,4));
    subplot(515); plot(fstrow,jacA(:,5));

  figure(5); plot(fstrow,jacA-jacB);

  disp('ret to continue'); pause
end

