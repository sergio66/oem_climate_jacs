ilat = 20;
ilat = input('Enter latitude bin (1:40) : ');

varych4 = load(['CH4_1700_2000/ch4_jac_2834_latbin' num2str(ilat) '.mat']);

constCH4 = load(['JUNK/jac_results_' num2str(ilat) '.mat']);
M_T = load('JUNK/kcarta_M_TS_jac_all_5_97_97_97_2645.mat');

plot(constCH4.fKc,constCH4.tracegas(:,3)*(5/1860),'k.-',constCH4.fKc,varych4.qcx(:,[1]),'b',constCH4.fKc,varych4.qcx(:,[13]),'r',...
     M_T.f,squeeze(M_T.M_TS_jac_all(ilat,:,3)),'g')

plotaxis2; axis([1200 1400 -40/1000 0])
