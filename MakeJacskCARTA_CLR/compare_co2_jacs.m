ilat = 20;
ilat = input('Enter latitude bin (1:40) : ');

varyco2 = load(['CO2_370_385_400_415/co2_jac_2834_latbin' num2str(ilat) '.mat']);

constCO2 = load(['JUNK/jac_results_' num2str(ilat) '.mat']);
M_T = load('JUNK/kcarta_M_TS_jac_all_5_97_97_97_2645.mat');

plot(constCO2.fKc,constCO2.tracegas(:,1)*(2.2/370),'k.-',constCO2.fKc,varyco2.qcx(:,[1]),'b',constCO2.fKc,varyco2.qcx(:,[10]),'r',...
     M_T.f,squeeze(M_T.M_TS_jac_all(ilat,:,1)),'g')

plotaxis2; axis([640 840 -0.1 +0.05])
