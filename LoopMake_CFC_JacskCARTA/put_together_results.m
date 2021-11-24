function put_together_results(iInstr,iiBin)

r = load(['JUNK/individual_prof_convolved_kcarta_crisHI_' num2str(iiBin) '.mat']);
%j = load(['JUNK/individual_prof_convolved_kcarta_AIRS_crisHI_' num2str(iiBin) '_jac.mat']);
c = load(['JUNK/individual_prof_convolved_kcarta_AIRS_crisHI_' num2str(iiBin) '_coljac.mat']);

r
c

[mm,nnr] = size(r.rKc);
r.rKc = r.rKc(:,nnr);    %% remember if there are 2 slab clouds, then 5 rads are output, need 5th one

tracegas = rad2bt(c.fKc,c.rKc(:,[1])) - rad2bt(c.fKc,r.rKc);
stemp    = rad2bt(c.fKc,c.rKc(:,[3])) - rad2bt(c.fKc,r.rKc);

figure(4); plot(r.fKc,tracegas);  title('tracegas jac');
figure(5); plot(r.fKc,stemp);     title('stemp jac');
figure(6); plot(c.fKc,rad2bt(c.fKc,r.rKc)); title('btcalc')

fKc = r.fKc;
saver = ['save JUNK/jac_results_' num2str(iiBin) '.mat fKc tracegas stemp'];
eval(saver);
fprintf(1,'final results : %s \n',saver)
