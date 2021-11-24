function put_together_results(iInstr,iTimeStep,iiBin)

find_file_names

disp('see << find_file_names.m >> and list_anomaly_files_to_be_made.m and put_together_results.m')
if iInstr == 124
  if iTimeStep < 0
    outdirX = 'JUNK/';
    outdir = outdirX;
    r = load(['JUNK/individual_prof_convolved_kcarta_crisHI_' num2str(iiBin) '.mat']);
    j = load(['JUNK/individual_prof_convolved_kcarta_AIRS_crisHI_' num2str(iiBin) '_jac.mat']);
    c = load(['JUNK/individual_prof_convolved_kcarta_AIRS_crisHI_' num2str(iiBin) '_coljac.mat']);
  else
    outdirX = ['Anomaly365_16/' num2str(iTimeStep,'%03d') '/'];
    r = load([outdirtemp '/individual_prof_convolved_kcarta_crisHI_' num2str(iiBin) '.mat']);
    j = load([outdirtemp '/individual_prof_convolved_kcarta_AIRS_crisHI_' num2str(iiBin) '_jac.mat']);
    c = load([outdirtemp '/individual_prof_convolved_kcarta_AIRS_crisHI_' num2str(iiBin) '_coljac.mat']);
  end
elseif iInstr == 1
  if iTimeStep < 0
    outdirX = 'JUNK/';
    outdir = outdirX;
    r = load(['JUNK/individual_prof_convolved_kcarta_airs_' num2str(iiBin) '.mat']);
    j = load(['JUNK/individual_prof_convolved_kcarta_airs_' num2str(iiBin) '_jac.mat']);
    c = load(['JUNK/individual_prof_convolved_kcarta_airs_' num2str(iiBin) '_coljac.mat']);
  else
    outdirX = ['Anomaly365_16/' num2str(iTimeStep,'%03d') '/'];
    r = load([outdirtemp '/individual_prof_convolved_kcarta_airs_' num2str(iiBin) '.mat']);
    j = load([outdirtemp '/individual_prof_convolved_kcarta_airs_' num2str(iiBin) '_jac.mat']);
    c = load([outdirtemp '/individual_prof_convolved_kcarta_airs_' num2str(iiBin) '_coljac.mat']);
  end
end
  
[mm,nnr] = size(r.rKc);
r.rKc = r.rKc(:,nnr);    %% remember if there are 2 slab clouds, then 5 rads are output, need 5th one
fprintf(1,'size r.rKc = %5i x %5i \n',mm,nnr);

[mm,nn] = size(j.rKc);
nlay = (nn-4)/7;   %% [W,O3,Self,Forn,HDO]             [T Wgt] [4 surface]
nlay = (nn-4)/9;   %% [W,O3,Self,Forn,HDO] [G201 G202] [T Wgt] [4 surface]
ix = (1:nlay);
fprintf(1,'size j.rKc = %5i x %5i ; nlay = %5i \n',mm,nn,nlay);

iW = ix + 0*nlay;
iS = ix + 2*nlay;
iF = ix + 3*nlay;
iD = ix + 4*nlay;

iO = 2; iO = ix + (iO-1)*nlay; 

iT = 8; iT = ix + (iT-1)*nlay;

iWgt = 9; iWgt = ix + (iWgt-1)*nlay;

[min(iWgt) max(iWgt) size(j.rKc)]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

water = j.rKc(:,iW) + j.rKc(:,iS) + j.rKc(:,iF) + j.rKc(:,iD);
ozone = j.rKc(:,iO);
tempr = j.rKc(:,iT);

figure(1); clf; plot(r.fKc,sum(water')); title('sum(W jac)')
figure(2); clf; plot(r.fKc,sum(ozone')); title('sum(O jac)')
figure(3); clf; plot(r.fKc,sum(tempr')); title('sum(T jac)')

% iJacob     = 6
% iaJacob(1) = 2
% iaJacob(2) = 4
% iaJacob(3) = 5
% iaJacob(4) = 6
% iaJacob(5) = 51
% iaJacob(6) = 52
% iaJacob(7) = T(z) + dT
% iaJacob(8) = stemp + dT

dQkc = 0.1;    dTkc = 1.0;   %% originally kcarta did  coljacs of 0.1   perturbation and 1.0 K perturbation
dQkc = 0.001;  dTkc = 0.01;  %% now        kcarta does coljacs of 0.001 perturbation and 0.01 K perturbation

[mmc,nnc] = size(c.rKc);
fprintf(1,'size j.rKc = %5i x %5i \n',mmc,nnc);
tracegas = rad2bt(c.fKc,c.rKc(:,[1 2 4 5 6])) - rad2bt(c.fKc,r.rKc)*ones(1,5);  %%% need to translate to 100% jac
tracegas = tracegas * 1/dQkc;                                                   %%% the translation to 100% jac ... SARTA code does deltaGas = 100% jacs
stemp    = (rad2bt(c.fKc,c.rKc(:,[8])) - rad2bt(c.fKc,r.rKc))/dTkc;           %%% jacobians

figure(4); clf; plot(r.fKc,tracegas);            title('tracegas jac');
figure(5); clf; plot(r.fKc,stemp);               title('stemp jac');
figure(6); clf; plot(c.fKc,rad2bt(c.fKc,r.rKc)); title('btcalc')

fKc = c.fKc;
if iTimeStep < 0
  saver = ['save JUNK/jac_results_' num2str(iiBin) '.mat fKc water ozone tempr tracegas stemp'];
else
  saver = ['save ' outdir '/jac_results_' num2str(iiBin) '.mat fKc water ozone tempr tracegas stemp'];
end

eval(saver);
fprintf(1,'final results : %s \n',saver)
