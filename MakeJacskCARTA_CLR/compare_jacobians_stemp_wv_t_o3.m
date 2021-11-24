co = [0 0.4470 0.7410;
    0.85 0.3250 0.098;
    0.9290 0.6940 0.1250;
    0.4940 0.1840 0.5560;
    0.4660 0.6740 0.1880;
    0.6350 0.0780 0.1840;
    0.3010 0.7450 0.9330];
co = [1 0 0;
      0 1 0;
      0 0 1;
      0 0 0];

fig=figure(1);
set(fig,'defaultAxesColorOrder',co)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('comparing v12.8 old pertvs v12.8 new pert');
a0 = load('Anomaly365_16_12p8_dQpert0.1_dTpert1.0/RESULTS/kcarta_365_M_TS_jac_all_5_97_97_97_2645.mat');
a1 = load('Anomaly365_16_12p8/RESULTS/kcarta_365_M_TS_jac_all_5_97_97_97_2645.mat');

figure(1); plot(a0.f,squeeze(a0.M_TS_jac_all(20,:,1)),a0.f,squeeze(a1.M_TS_jac_all(20,:,1)))
figure(2); plot(a0.f,squeeze(a0.M_TS_jac_all(20,:,1))./squeeze(a1.M_TS_jac_all(20,:,1)))
disp('ret'); pause

figure(1); plot(a0.f,squeeze(a0.M_TS_jac_all(20,:,5)),a0.f,squeeze(a1.M_TS_jac_all(20,:,5)))
figure(2); plot(a0.f,squeeze(a0.M_TS_jac_all(20,:,5))./squeeze(a1.M_TS_jac_all(20,:,5)))
disp('ret'); pause

wv0 = sum(squeeze(a0.M_TS_jac_all(20,:,6:102))'); wv1 = sum(squeeze(a0.M_TS_jac_all(20,:,6:102))');
figure(1); plot(a0.f,wv0,a0.f,wv1); figure(2); plot(a0.f,wv0./wv1);
disp('ret'); pause

t0 = sum(squeeze(a0.M_TS_jac_all(20,:,103:199))'); t1 = sum(squeeze(a0.M_TS_jac_all(20,:,103:199))');
figure(1); plot(a0.f,t0,a0.f,t1); figure(2); plot(a0.f,t0./t1);
disp('ret'); pause

oz0 = sum(squeeze(a0.M_TS_jac_all(20,:,200:296))'); oz1 = sum(squeeze(a0.M_TS_jac_all(20,:,200:296))');
figure(1); plot(a0.f,oz0,a0.f,oz1); figure(2); plot(a0.f,oz0./oz1);
disp('ret'); pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


