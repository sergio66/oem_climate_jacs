function put_together_results_coljac(iInstr,iTimeStep,iiBin,iAIRSorCRIS)

find_file_names

disp('see << find_file_names.m >> and list_anomaly_files_to_be_made.m and put_together_results.m')
if iTimeStep < 0
  outdirX = 'JUNK/';
  outdir = outdirX;
  r = load(['JUNK/individual_prof_convolved_kcarta_crisHI_' num2str(iiBin) '.mat']);
  c = load(['JUNK/individual_prof_convolved_kcarta_AIRS_crisHI_' num2str(iiBin) '_coljac.mat']);
else
  outdirX = ['Anomaly365_16/' num2str(iTimeStep,'%03d') '/'];
  r = load([outdirtemp '/individual_prof_convolved_kcarta_crisHI_' num2str(iiBin) '.mat']);
  c = load([outdirtemp '/individual_prof_convolved_kcarta_AIRS_crisHI_' num2str(iiBin) '_coljac.mat']);
end

[mm,nnr] = size(r.rKc);
r.rKc = r.rKc(:,nnr);    %% remember if there are 2 slab clouds, then 5 rads are output, need 5th one

dQkc = 0.1;    dTkc = 1.0;   %% originally kcarta did  coljacs of 0.1   perturbation and 1.0 K perturbation
dQkc = 0.001;  dTkc = 0.01;  %% now        kcarta does coljacs of 0.001 perturbation and 0.01 K perturbation

%% saved CO2 N2O CO CH4 CFC = 1 2 3 4 5 ... so save off [1 2 4 5]
tracegas = rad2bt(c.fKc,c.rKc(:,[1 2 4 5])) - rad2bt(c.fKc,r.rKc)*ones(1,4);  %%% need to translate to 100% jac
tracegas = tracegas * 1/dQkc;                                                 %%% the translation to 100% jac ... SARTA code does deltaGas = 100% jacs
stemp    = (rad2bt(c.fKc,c.rKc(:,[7])) - rad2bt(c.fKc,r.rKc))/dTkc;           %%% jacobians

figure(4); clf; plot(r.fKc,tracegas);            title('tracegas jac');
figure(5); clf; plot(r.fKc,stemp);               title('stemp jac');
figure(6); clf; plot(c.fKc,rad2bt(c.fKc,r.rKc)); title('btcalc')

fKc = c.fKc;
if iTimeStep < 0
  outname = ['JUNK/coljac_results_' num2str(iiBin) '.mat'];
  saver = ['save JUNK/coljac_results_' num2str(iiBin) '.mat fKc water ozone tempr tracegas stemp'];
else
  outname = [outdir '/coljac_results_' num2str(iiBin) '.mat'];
  saver = ['save ' outdir '/coljac_results_' num2str(iiBin) '.mat fKc water ozone tempr tracegas stemp'];
end

if ~exist(outname)
  eval(saver);
  fprintf(1,'final results : %s \n',saver)
else
  fprintf(1,'output file %s already exists ... skipping\n',outname)
end

