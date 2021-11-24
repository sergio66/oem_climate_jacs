disp(' ')
disp('>>>>>>>>>>>>>>>>>>>>>>>>>')
disp('see find_file_names.m')
fprintf(1,' outdir      = %s \n',outdir);
fprintf(1,' outdirtemp  = %s \n',outdirtemp);
fprintf(1,' outname     = %s \n',outname);
fprintf(1,' outnamejac  = %s \n',outnamejac);
fprintf(1,' outnml      = %s \n',outnml);
fprintf(1,' status      = %s \n',status);
fprintf(1,' outnamec    = %s \n',outnamec);
fprintf(1,' outnamejacc = %s \n',outnamejacc);
fprintf(1,' outnmlc     = %s \n',outnmlc);
fprintf(1,' statusc     = %s \n',statusc);
disp('>>>>>>>>>>>>>>>>>>>>>>>>>')

%% nml and status files
junk = outnml;
if exist(junk)
  fprintf(1,'hmm %s already exists, removing .... \n',junk);
  eval(['!/bin/rm ' junk]);
end

junk = status;
if exist(junk)
  fprintf(1,'hmm %s already exists, removing .... \n',junk);
  eval(['!/bin/rm ' junk]);
end

junk = outnmlc;
if exist(junk)
  fprintf(1,'hmm %s already exists, removing .... \n',junk);
  eval(['!/bin/rm ' junk]);
end

junk = statusc;
if exist(junk)
  fprintf(1,'hmm %s already exists, removing .... \n',junk);
  eval(['!/bin/rm ' junk]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% kcarta rad file
junk = [outdirtemp '/rad.dat' num2str(iiBin)];
if exist(junk)
  fprintf(1,'hmm %s already exists, removing .... \n',junk);
  eval(['!/bin/rm ' junk]);
end

junk = [outdirtemp '/radc.dat' num2str(iiBin)];
if exist(junk)
  fprintf(1,'hmm %s already exists, removing .... \n',junk);
  eval(['!/bin/rm ' junk]);
end

%% convolved rads, airs
junk = [outdirtemp '//individual_prof_convolved_kcarta_airs_' num2str(iiBin) '.mat'];
if exist(junk)
  fprintf(1,'hmm %s already exists, removing .... \n',junk);
  eval(['!/bin/rm ' junk]);
end

%% convolved rads, iasi
junk = [outdirtemp '//individual_prof_convolved_kcarta_iasi_' num2str(iiBin) '.mat'];
if exist(junk)
  fprintf(1,'hmm %s already exists, removing .... \n',junk);
  eval(['!/bin/rm ' junk]);
end

%% convolved rads, crisHI
junk = [outdirtemp '//individual_prof_convolved_kcarta_crisHI_' num2str(iiBin) '.mat'];
if exist(junk)
  fprintf(1,'hmm %s already exists, removing .... \n',junk);
  eval(['!/bin/rm ' junk]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% kcarta jac file
junk = [outdirtemp '/jac.dat' num2str(iiBin)];
if exist(junk)
  fprintf(1,'hmm %s already exists, removing .... \n',junk);
  eval(['!/bin/rm ' junk]);
end

%% kcarta jac COL file
junk = [outdirtemp '/jacc.dat' num2str(iiBin) '_COL'];
if exist(junk)
  fprintf(1,'hmm %s already exists, removing .... \n',junk);
  eval(['!/bin/rm ' junk]);
end

junk = [outdirtemp '//individual_prof_convolved_kcarta_airs_' num2str(iiBin) '_jac.mat'];
if exist(junk)
  fprintf(1,'hmm %s already exists, removing .... \n',junk);
  eval(['!/bin/rm ' junk]);
end

junk = [outdirtemp '//individual_prof_convolved_kcarta_airs_' num2str(iiBin) '_coljac.mat'];
if exist(junk)
  fprintf(1,'hmm %s already exists, removing .... \n',junk);
  eval(['!/bin/rm ' junk]);
end

junk = [outdirtemp '//individual_prof_convolved_kcarta_iasi_' num2str(iiBin) '_jac.mat'];
if exist(junk)
  fprintf(1,'hmm %s already exists, removing .... \n',junk);
  eval(['!/bin/rm ' junk]);
end

junk = [outdirtemp '//individual_prof_convolved_kcarta_iasi_' num2str(iiBin) '_coljac.mat'];
if exist(junk)
  fprintf(1,'hmm %s already exists, removing .... \n',junk);
  eval(['!/bin/rm ' junk]);
end

junk = [outdirtemp '//individual_prof_convolved_kcarta_crisHI_' num2str(iiBin) '_jac.mat'];
if exist(junk)
  fprintf(1,'hmm %s already exists, removing .... \n',junk);
  eval(['!/bin/rm ' junk]);
end

junk = [outdirtemp '//individual_prof_convolved_kcarta_crisHI_' num2str(iiBin) '_coljac.mat'];
if exist(junk)
  fprintf(1,'hmm %s already exists, removing .... \n',junk);
  eval(['!/bin/rm ' junk]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(' ')
