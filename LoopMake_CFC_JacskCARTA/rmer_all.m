function rmer_all(iiBin)

rmer = ['!/bin/rm JUNK/individual_prof_convolved_kcarta_crisHI_' num2str(iiBin) '.mat'];
rmer = [rmer ' JUNK/individual_prof_convolved_kcarta_AIRS_crisHI_' num2str(iiBin) '_coljac.mat '];

rmer = [rmer ' JUNK/jacc.dat' num2str(iiBin) '_COL'];
rmer = [rmer ' JUNK/radc.dat' num2str(iiBin)];
rmer = [rmer ' JUNK/radc.dat' num2str(iiBin) '_CLD'];

%rmer = [rmer ' JUNK/individual_prof_convolved_kcarta_AIRS_crisHI_' num2str(iiBin) '_jac.mat '];
%rmer = [rmer ' JUNK/jac.dat' num2str(iiBin)];
%rmer = [rmer ' JUNK/rad.dat' num2str(iiBin)];
%rmer = [rmer ' JUNK/rad.dat' num2str(iiBin) '_CLD'];

eval(rmer)
