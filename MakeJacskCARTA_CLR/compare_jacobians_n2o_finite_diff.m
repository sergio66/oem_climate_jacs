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

disp('comparing current N2O_315_340 : n2o_jac_2834_latbin21.mat vs n2o_jac_2834_latbin21v2.mat = sergio jac vs strow jac')
a0 = load('N2O_315_340/n2o_jac_2834_latbin21.mat');
a1 = load('N2O_315_340/n2o_jac_2834_latbin21v2.mat');

figure(1); plot(a0.fc(1:2378),a0.qcx(1:2378,[1 2 6])./a1.qcx(1:2378,[1 2 6])); grid; axis([1200 1400 0.8 1.2])
figure(2); plot(a0.fc(1:2378),a0.qcx(1:2378,1),'b.-',a1.fc(1:2378),a1.qcx(1:2378,1),'r')
figure(3); plot(a0.fc(1:2378),a0.qcx(1:2378,:),'b',a1.fc(1:2378),a1.qcx(1:2378,:),'r')
figure(4); plot(a0.fc(1:2378),a0.qcx(1:2378,:) ./ a1.qcx(1:2378,:)); axis([1200 1400 0.8 1.1]); grid
disp('ret to continue'); pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('comparing current N2O_315_340 : small pert vs large pert')
a0 = load('N2O_315_340/n2o_jac_2834_latbin21.mat');
a1 = load('N2O_315_340_dQpert0.1_dTpert1.0/n2o_jac_2834_latbin21.mat');

figure(1); plot(a0.fc(1:2378),a0.qcx(1:2378,[1 2 6])./a1.qcx(1:2378,[1 2 6])); grid; axis([1200 1400 0.8 1.2])
figure(2); plot(a0.fc(1:2378),a0.qcx(1:2378,1),'b.-',a1.fc(1:2378),a1.qcx(1:2378,1),'r')
figure(3); plot(a0.fc(1:2378),a0.qcx(1:2378,:),'b',a1.fc(1:2378),a1.qcx(1:2378,:),'r')
figure(4); plot(a0.fc(1:2378),a0.qcx(1:2378,:) ./ a1.qcx(1:2378,:)); axis([1200 1400 0.8 1.1]); grid
disp('ret to continue'); pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


