%{
[sergio@taki-usr2 MakeJacskCARTA_CLR]$ ls -lt CO2_370_385_400_415
CO2_370_385_400_415/                          CO2_370_385_400_415_12p4_dQpert0.1_dTpert1.0/ CO2_370_385_400_415_12p8_dQpert0.1_dTpert1.0/
CO2_370_385_400_415_12p4/                     CO2_370_385_400_415_12p8/
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

disp('comparing current CO2_370_385_400_415 : o2_jac_2834_latbin21.mat vs co2_jac_2834_latbin21v2.mat = sergio jac vs strow jac')
a0 = load('CO2_370_385_400_415/co2_jac_2834_latbin21.mat');
a1 = load('CO2_370_385_400_415/co2_jac_2834_latbin21v2.mat');

figure(1); plot(a0.fc(1:549),a0.qcx(1:549,[1 2 10])./a1.qcx(1:549,[1 2 10])); grid; axis([min(a0.fc(1:549)) max(a0.fc(1:549)) 0.8 1.2])
figure(2); plot(a0.fc(1:549),a0.qcx(1:549,1),'b.-',a1.fc(1:549),a1.qcx(1:549,1),'r')
figure(3); plot(a0.fc(1:549),a0.qcx(1:549,:),'b',a1.fc(1:549),a1.qcx(1:549,:),'r')
figure(4); plot(a0.fc(1:549),a0.qcx(1:549,:) ./ a1.qcx(1:549,:)); axis([650 850 0.8 1.1]); grid
disp('ret to continue'); pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('comparing current CO2_370_385_400_415_12p4 : small pert vs large pert')
a0 = load('CO2_370_385_400_415_12p4/co2_jac_2834_latbin21.mat');
a1 = load('CO2_370_385_400_415_12p4_dQpert0.1_dTpert1.0/co2_jac_2834_latbin21.mat');

figure(1); plot(a0.fc(1:549),a0.qcx(1:549,[1 2 10])./a1.qcx(1:549,[1 2 10])); grid; axis([min(a0.fc(1:549)) max(a0.fc(1:549)) 0.8 1.2])
figure(2); plot(a0.fc(1:549),a0.qcx(1:549,1),'b.-',a1.fc(1:549),a1.qcx(1:549,1),'r')
figure(3); plot(a0.fc(1:549),a0.qcx(1:549,:),'b',a1.fc(1:549),a1.qcx(1:549,:),'r')
figure(4); plot(a0.fc(1:549),a0.qcx(1:549,:) ./ a1.qcx(1:549,:)); axis([650 850 0.8 1.1]); grid
disp('ret to continue'); pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('comparing current CO2_370_385_400_415_12p8 : small pert vs large pert')
a0 = load('CO2_370_385_400_415_12p8/co2_jac_2834_latbin21.mat');
a1 = load('CO2_370_385_400_415_12p8_dQpert0.1_dTpert1.0/co2_jac_2834_latbin21.mat');

figure(1); plot(a0.fc(1:549),a0.qcx(1:549,[1 2 10])./a1.qcx(1:549,[1 2 10])); grid; axis([min(a0.fc(1:549)) max(a0.fc(1:549)) 0.8 1.2])
figure(2); plot(a0.fc(1:549),a0.qcx(1:549,1),'b.-',a1.fc(1:549),a1.qcx(1:549,1),'r')
figure(3); plot(a0.fc(1:549),a0.qcx(1:549,:),'b',a1.fc(1:549),a1.qcx(1:549,:),'r')
figure(4); plot(a0.fc(1:549),a0.qcx(1:549,:) ./ a1.qcx(1:549,:)); axis([650 850 0.8 1.1]); grid
disp('ret to continue'); pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('comparing current CO2_370_385_400_415_12p4 vs CO2_370_385_400_415_12p8')
a0 = load('CO2_370_385_400_415_12p4/co2_jac_2834_latbin21.mat');
a1 = load('CO2_370_385_400_415_12p8/co2_jac_2834_latbin21.mat');

figure(1); plot(a0.fc(1:549),a0.qcx(1:549,[1 2 10])./a1.qcx(1:549,[1 2 10])); grid; axis([min(a0.fc(1:549)) max(a0.fc(1:549)) 0.8 1.2])
figure(2); plot(a0.fc(1:549),a0.qcx(1:549,1),'b.-',a1.fc(1:549),a1.qcx(1:549,1),'r')
figure(3); plot(a0.fc(1:549),a0.qcx(1:549,:),'b',a1.fc(1:549),a1.qcx(1:549,:),'r')
figure(4); plot(a0.fc(1:549),a0.qcx(1:549,:) ./ a1.qcx(1:549,:)); axis([650 850 0.8 1.1]); grid
disp('ret to continue'); pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

