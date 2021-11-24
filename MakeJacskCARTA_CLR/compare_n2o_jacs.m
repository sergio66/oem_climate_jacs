ilat = 20;
ilat = input('Enter latitude bin (1:40) : ');

varyn2o = load(['N2O_315_340/n2o_jac_2834_latbin' num2str(ilat) '.mat']);

constN2O = load(['JUNK/jac_results_' num2str(ilat) '.mat']);
M_T = load('JUNK/kcarta_M_TS_jac_all_5_97_97_97_2645.mat');

plot(constN2O.fKc,constN2O.tracegas(:,2)*(1/300),'k.-',constN2O.fKc,varyn2o.qcx(:,[1]),'b',constN2O.fKc,varyn2o.qcx(:,[6]),'r',...
     M_T.f,squeeze(M_T.M_TS_jac_all(ilat,:,2)),'g')

plotaxis2; axis([1000 2400 -40/1000 0])
