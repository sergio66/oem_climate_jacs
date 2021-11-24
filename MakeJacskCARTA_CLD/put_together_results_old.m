function put_together_results(iInstr,iiBin)

r = load(['JUNK/individual_prof_convolved_kcarta_crisHI_' num2str(iiBin) '.mat']);
j = load(['JUNK/individual_prof_convolved_kcarta_AIRS_crisHI_' num2str(iiBin) '_jac.mat']);
c = load(['JUNK/individual_prof_convolved_kcarta_AIRS_crisHI_' num2str(iiBin) '_coljac.mat']);

[mm,nnr] = size(r.rKc);
r.rKc = r.rKc(:,nnr);    %% remember if there are 2 slab clouds, then 5 rads are output, need 5th one

[mm,nn] = size(j.rKc);
nlay = (nn-4)/9;   %% [W,O3,Self,Forn,HDO] [G201 G202] [T Wgt] [4 surface]
ix = (1:nlay);

nlay

iW = ix + 0*nlay;
iS = ix + 2*nlay;
iF = ix + 3*nlay;
iD = ix + 4*nlay;

iO = 2; iO = ix + (iO-1)*nlay; 

iT = 8; iT = ix + (iT-1)*nlay;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

water = j.rKc(:,iW) + j.rKc(:,iS) + j.rKc(:,iF) + j.rKc(:,iD);
ozone = j.rKc(:,iO);
tempr = j.rKc(:,iT);

figure(1); plot(r.fKc,sum(water')); title('sum(W jac)')
figure(2); plot(r.fKc,sum(ozone')); title('sum(O jac)')
figure(3); plot(r.fKc,sum(tempr')); title('sum(T jac)')

% iJacob     = 5
% iaJacob(1) = 2
% iaJacob(2) = 4
% iaJacob(3) = 5
% iaJacob(4) = 6
% iaJacob(5) = 51
tracegas = rad2bt(c.fKc,c.rKc(:,[1 2 4 5])) - rad2bt(c.fKc,r.rKc)*ones(1,4);  %%% 10% jacobians, not 100%
tracegas = tracegas * 10;   %% remember kCARTA does deltaX = 10% jacs, while SARTA does deltaGas = 100% jacs
stemp    = rad2bt(c.fKc,c.rKc(:,[7]))       - rad2bt(c.fKc,r.rKc);            %%% 1 K jacobians

figure(4); plot(r.fKc,tracegas);  title('tracegas jac');
figure(5); plot(r.fKc,stemp);     title('stemp jac');
figure(6); plot(c.fKc,rad2bt(c.fKc,r.rKc)); title('btcalc')

fKc = r.fKc;
saver = ['save JUNK/jac_results_' num2str(iiBin) '.mat fKc water ozone tempr tracegas stemp'];
eval(saver);
fprintf(1,'final results : %s \n',saver)
