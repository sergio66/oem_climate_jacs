function rmer_all(iiBin)

%-rw-rw-r-- 1 sergio pi_strow   69331758 Feb 17 11:16 individual_prof_convolved_kcarta_AIRS_crisHI_1_jac.mat
%-rw-rw-r-- 1 sergio pi_strow     751578 Feb 17 11:07 individual_prof_convolved_kcarta_AIRS_crisHI_1_coljac.mat
%-rw-rw-r-- 1 sergio pi_strow     140643 Feb 17 10:34 individual_prof_convolved_kcarta_crisHI_1.mat
%-rw-rw-r-- 1 sergio pi_strow   24925360 Feb 17 10:24 jac.dat1_COL
%-rw-rw-r-- 1 sergio pi_strow    3735136 Feb 17 10:24 radc.dat1
%-rw-rw-r-- 1 sergio pi_strow 2432007952 Feb 17 10:22 jac.dat1
%-rw-rw-r-- 1 sergio pi_strow    3735136 Feb 17 10:22 rad.dat1
%-rw-rw-r-- 1 sergio pi_strow 124625296 Feb 26 22:00 jacc.dat1_COL
%-rw-rw-r-- 1 sergio pi_strow      1085 Feb 26 21:57 radc.dat1_CLD
%-rw-rw-r-- 1 sergio pi_strow      1085 Feb 26 21:55 rad.dat1_CLD

%-rw-rw-r-- 1 sergio pi_strow 119M Feb 27 04:42 jacc.dat21_COL
%-rw-rw-r-- 1 sergio pi_strow  18M Feb 27 04:42 radc.dat21
%-rw-rw-r-- 1 sergio pi_strow 1.1K Feb 27 04:38 radc.dat21_CLD
%-rw-rw-r-- 1 sergio pi_strow 3.0G Feb 27 04:38 jac.dat21
%-rw-rw-r-- 1 sergio pi_strow  18M Feb 27 04:38 rad.dat21
%-rw-rw-r-- 1 sergio pi_strow 1.1K Feb 27 04:36 rad.dat21_CLD

%-rw-rw-r-- 1 sergio pi_strow  124625296 Feb 27 04:42 jacc.dat21_COL
%-rw-rw-r-- 1 sergio pi_strow   17995584 Feb 27 04:42 radc.dat21
%-rw-rw-r-- 1 sergio pi_strow       1085 Feb 27 04:38 radc.dat21_CLD
%-rw-rw-r-- 1 sergio pi_strow 3122797912 Feb 27 04:38 jac.dat21
%-rw-rw-r-- 1 sergio pi_strow   17995584 Feb 27 04:38 rad.dat21
%-rw-rw-r-- 1 sergio pi_strow       1085 Feb 27 04:36 rad.dat21_CLD

rmer = ['!/bin/rm JUNK/individual_prof_convolved_kcarta_crisHI_' num2str(iiBin) '.mat'];
rmer = [rmer ' JUNK/individual_prof_convolved_kcarta_AIRS_crisHI_' num2str(iiBin) '_jac.mat '];
rmer = [rmer ' JUNK/individual_prof_convolved_kcarta_AIRS_crisHI_' num2str(iiBin) '_coljac.mat '];
rmer = [rmer ' JUNK/jacc.dat' num2str(iiBin) '_COL'];
rmer = [rmer ' JUNK/radc.dat' num2str(iiBin)];
rmer = [rmer ' JUNK/jac.dat' num2str(iiBin)];
rmer = [rmer ' JUNK/rad.dat' num2str(iiBin)];
rmer = [rmer ' JUNK/radc.dat' num2str(iiBin) '_CLD'];
rmer = [rmer ' JUNK/rad.dat' num2str(iiBin) '_CLD'];
eval(rmer)
