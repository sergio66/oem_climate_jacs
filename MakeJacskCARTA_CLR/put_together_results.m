function put_together_results(iInstr,iTimeStep,iiBin,iAIRSorCRIS)

find_file_names

disp('see << find_file_names.m >> and list_anomaly_files_to_be_made.m and put_together_results.m')
if iTimeStep < 0
  outdirX = 'JUNK/';
  outdir = outdirX;
  r = load(['JUNK/individual_prof_convolved_kcarta_crisHI_' num2str(iiBin) '.mat']);
  j = load(['JUNK/individual_prof_convolved_kcarta_AIRS_crisHI_' num2str(iiBin) '_jac.mat']);
  c = load(['JUNK/individual_prof_convolved_kcarta_AIRS_crisHI_' num2str(iiBin) '_coljac.mat']);
else
  %outdirX = ['Anomaly365_16/' num2str(iTimeStep,'%03d') '/'];
  r = load([outdirtemp '/individual_prof_convolved_kcarta_crisHI_' num2str(iiBin) '.mat']);
  j = load([outdirtemp '/individual_prof_convolved_kcarta_AIRS_crisHI_' num2str(iiBin) '_jac.mat']);
  c = load([outdirtemp '/individual_prof_convolved_kcarta_AIRS_crisHI_' num2str(iiBin) '_coljac.mat']);
end

r
j
c

if iAIRSorCRIS == 1
  [mm,nnr] = size(r.rKc);
  r.rKc = r.rKc(:,nnr);    %% remember if there are 2 slab clouds, then 5 rads are output, need 5th one
elseif iAIRSorCRIS == 2
  [mm,nnr] = size(r.rcris_all);
  r.rcris_all = r.rcris_all(:,nnr);    %% remember if there are 2 slab clouds, then 5 rads are output, need 5th one
elseif iAIRSorCRIS == 3
  [mm,nnr] = size(r.rKciasi);
  r.rKciasi = r.rKciasi(:,nnr);    %% remember if there are 2 slab clouds, then 5 rads are output, need 5th one
end

if iAIRSorCRIS == 1
  [mm,nn] = size(j.rKc)
elseif iAIRSorCRIS == 2
  [mm,nn] = size(j.rcris_all)
elseif iAIRSorCRIS == 3
  [mm,nn] = size(j.rKciasi)
end

nlay = (nn-4)/9;   %% [W,O3,Self,Forn,HDO] [G201 G202] [T Wgt] [4 surface]
nlay = (nn-4)/7;   %% [W,O3,Self,Forn,HDO]             [T Wgt] [4 surface]
ix = (1:nlay);

nlay

iJunk = 1; iW = ix + 0*nlay;
%X%X%X o3 %X%X%X o3 %X%X%X o3 %X%X%X iJunk = 2
iJunk = 3; iS = ix + 2*nlay;
iJunk = 4; iF = ix + 3*nlay;
iJunk = 5; iD = ix + 4*nlay;
%X%X%X Tz  %X%X%X Tz  %X%X%X Tz  %X%X%X iJunk = 6
%X%X%X Wgt %X%X%X Wgt %X%X%X Wgt %X%X%X iJunk = 7

iO = 2; iO = ix + (iO-1)*nlay; 

iT = 6; iT = ix + (iT-1)*nlay;

iWgt = 7; iWgt = ix + (iWgt-1)*nlay;

[min(iWgt) max(iWgt) mm nn]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iAIRSorCRIS == 1
  water = j.rKc(:,iW) + j.rKc(:,iS) + j.rKc(:,iF) + j.rKc(:,iD);
  ozone = j.rKc(:,iO);
  tempr = j.rKc(:,iT);
  ff = r.fKc;
elseif iAIRSorCRIS == 2
  water = j.rcris_all(:,iW) + j.rcris_all(:,iS) + j.rcris_all(:,iF) + j.rcris_all(:,iD);
  ozone = j.rcris_all(:,iO);
  tempr = j.rcris_all(:,iT);
  ff = r.fcris;
elseif iAIRSorCRIS == 3
  water = j.rKciasi(:,iW) + j.rKciasi(:,iS) + j.rKciasi(:,iF) + j.rKciasi(:,iD);
  ozone = j.rKciasi(:,iO);
  tempr = j.rKciasi(:,iT);
  ff = r.fiasi;
end

figure(1); clf; plot(ff,sum(water')); title('sum(W jac)')
figure(2); clf; plot(ff,sum(ozone')); title('sum(O jac)')
figure(3); clf; plot(ff,sum(tempr')); title('sum(T jac)')

% iJacob     = 5
% iaJacob(1) = 2
% iaJacob(2) = 4
% iaJacob(3) = 5
% iaJacob(4) = 6
% iaJacob(5) = 51

dQkc = 0.1;    dTkc = 1.0;   %% originally kcarta did  coljacs of 0.1   perturbation and 1.0 K perturbation
dQkc = 0.001;  dTkc = 0.01;  %% now        kcarta does coljacs of 0.001 perturbation and 0.01 K perturbation

if iAIRSorCRIS == 1
  tracegas = rad2bt(ff,c.rKc(:,[1 2 4 5 6])) - rad2bt(ff,r.rKc)*ones(1,5);  %%% need to translate to 100% jac
  tracegas = tracegas * 1/dQkc;                                             %%% the translation to 100% jac ... SARTA code does deltaGas = 100% jacs
  stemp    = (rad2bt(ff,c.rKc(:,[8])) - rad2bt(ff,r.rKc))/dTkc;             %%% jacobians
  rad = r.rKc;
elseif iAIRSorCRIS == 2
  tracegas = rad2bt(ff,c.rcris_all(:,[1 2 4 5 6])) - rad2bt(ff,r.rcris_all)*ones(1,5);  %%% need to translate to 100% jac
  tracegas = tracegas * 1/dQkc;                                                         %%% the translation to 100% jac ... SARTA code does deltaGas = 100% jacs
  stemp    = (rad2bt(ff,c.rcris_all(:,[8])) - rad2bt(ff,r.rcris_all))/dTkc;             %%% jacobians
  rad = r.rcris_all;
elseif iAIRSorCRIS == 3
  tracegas = rad2bt(ff,c.rKciasi(:,[1 2 4 5 6])) - rad2bt(ff,r.rKciasi)*ones(1,5);  %%% need to translate to 100% jac
  tracegas = tracegas * 1/dQkc;                                                     %%% the translation to 100% jac ... SARTA code does deltaGas = 100% jacs
  stemp    = (rad2bt(ff,c.rKciasi(:,[8])) - rad2bt(ff,r.rKciasi))/dTkc;             %%% jacobians
  rad = r.rKciasi;
end

figure(4); clf; plot(ff,tracegas);            title('tracegas jac');
figure(5); clf; plot(ff,stemp);               title('stemp jac');
figure(6); clf; plot(ff,rad2bt(ff,rad)); title('btcalc')

fKc = ff;
if iTimeStep < 0
  outname = ['JUNK/jac_results_' num2str(iiBin) '.mat'];
  saver = ['save JUNK/jac_results_' num2str(iiBin) '.mat fKc water ozone tempr tracegas stemp'];
else
  outname = [outdir '/jac_results_' num2str(iiBin) '.mat'];
  saver = ['save ' outdir '/jac_results_' num2str(iiBin) '.mat fKc water ozone tempr tracegas stemp'];
end

if ~exist(outname)
  whos fKc water ozone tempr tracegas stemp
  eval(saver);
  fprintf(1,'final jac results saved to : %s \n',saver)
else
  fprintf(1,'output file %s already exists ... skipping\n',outname)
end

