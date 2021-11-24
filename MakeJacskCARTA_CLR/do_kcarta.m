%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sedder = ['!sed -e "s/FF1/' num2str(f1) '/g"  -e "s/FF2/' num2str(f2) '/g" '];
sedder = [sedder ' -e "s/MMM/'     num2str(iiBin) '/g"'];
sedder = [sedder ' -e "s/TTT/'     num2str(iDo_rt_1vs43) '/g"'];
sedder = [sedder ' -e "s/XYZXYZ/'  use_this_rtp   '/g"'];  %%%<<<-- to sed rtpfname
sedder = [sedder ' -e "s/CKDCKD/'  num2str(iKCKD) '/g"'];  

if iDoLBLRTM > 0
  %% do three gases : CO2, O3 and CH4 using LBLRTM ods  
  fprintf(1,' >>>>>>>>> iDoLBLRTM = %2i ... using other ods \n',iDoLBLRTM);
  %sedder = [sedder ' -e "s/DOLBLRTM/3/g"'];
  sedder = [sedder ' -e "s/DOLBLRTM/' num2str(iDoLBLRTM) '/g"'];  
else
  sedder = [sedder ' -e "s/DOLBLRTM/-1/g"'];
end
sedder = [sedder ' -e "s/COMMENTCOMMENT/'     caComment '/g"'];
sedderc = sedder;

if iColJacOnly == -1
  iDoJac = 101;    %% do profilejac and coljac
elseif iColJacOnly == +1
  iDoJac = 102;    %% do coljac only
end

iDoCloud = 1;
iDoFlux = -1;

if iDoJac == 101
  disp('do_kcarta.m here A1 (cld sky rads and W/O3/T jacs)')
  sedder = [sedder ' -e "s/GGG/'    num2str(gg) '/g"'];   %% this gives gasID for jacobian
  sedder = [sedder ' templatejac_WTO.nml  > ' outnml];      
  kcartaer = ['!time ' kcartaexec ' ' outnml ' ' outname ' ' outnamejac '; echo $? >& ' status];
  
  disp('do_kcarta.m here A2 (cld sky rads and col jacs)')
  sedderc = [sedderc ' -e "s/GGG/'    num2str(gg) '/g"'];   %% this gives gasID for jacobian
  sedderc = [sedderc ' templatejac_col.nml  > ' outnmlc];      
  kcartaerc = ['!time ' kcartaexec ' ' outnmlc ' ' outnamec ' ' outnamejacc '; echo $? >& ' statusc];

  disp(' ')
  fprintf(1,'sedder for namelist = %s \n',sedder)
  disp(' ')
  fprintf(1,'kcartaer = %s \n',kcartaer)
  disp(' ')
  fprintf(1,'sedder for namelist = %s \n',sedderc)
  disp(' ')
  fprintf(1,'kcartaer = %s \n',kcartaerc)
  disp(' ')

  eval(sedder)
  eval(kcartaer)

  eval(sedderc)
  eval(kcartaerc)

  junk = status;
  loader = ['exitcode = load(''' junk ''');'];
  eval(loader);
  fprintf(1,'iiBin,exitcode = %6i %2i \n',iiBin,exitcode)

  junkc = statusc;
  loader = ['exitcodec = load(''' junk ''');'];
  eval(loader);
  fprintf(1,'iiBin,exitcodec = %6i %2i \n',iiBin,exitcodec)

  rmer = ['!/bin/rm ' outnml ' ' status];
  eval(rmer);
  rmer = ['!/bin/rm ' outnmlc ' ' statusc];
  eval(rmer);

  if iDoCloud == 100 
    rmer = ['!/bin/rm ' outcloud100]; eval(rmer);
  end

elseif iDoJac == 102
  disp('do_kcarta.m here A2 (cld sky rads and col jacs)')
  sedderc = [sedderc ' -e "s/GGG/'    num2str(gg) '/g"'];   %% this gives gasID for jacobian
  sedderc = [sedderc ' templatejac_col.nml  > ' outnmlc];      
  kcartaerc = ['!time ' kcartaexec ' ' outnmlc ' ' outnamec ' ' outnamejacc '; echo $? >& ' statusc];

  fprintf(1,'sedder for namelist = %s \n',sedderc)
  disp(' ')
  fprintf(1,'kcartaer = %s \n',kcartaerc)
  disp(' ')

  eval(sedderc)
  eval(kcartaerc)

  junkc = statusc;
  loader = ['exitcodec = load(''' junkc ''');'];
  eval(loader)
  fprintf(1,'iiBin,exitcodec = %6i %2i \n',iiBin,exitcodec)

  rmer = ['!/bin/rm ' outnmlc ' ' statusc];
  eval(rmer);

  if iDoCloud == 100 
    rmer = ['!/bin/rm ' outcloud100]; eval(rmer);
  end
end
