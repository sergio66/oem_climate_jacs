outname    = ['JUNK/rad.dat' num2str(iiBin)];
outnamejac = ['JUNK/jac.dat'  num2str(iiBin)];
outnml     = ['JUNK/run_nml'  num2str(iiBin)];

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

iDoFlux = -1;
kcartaexec = '/home/sergio/KCARTA/BIN/kcarta.x_f90_400ppmv_H16_6gasjacob';

sedder = [sedder ' -e "s/GGG/'    num2str(gg) '/g"'];   %% this gives gasID for jacobian
sedder = [sedder ' template_rad.nml  > ' outnml];      
kcartaer = ['!time ' kcartaexec ' ' outnml ' ' outname '; echo $? >& status' num2str(iiBin)];
  
fprintf(1,'sedder for namelist = %s \n',sedder)
fprintf(1,'kcartaer = %s \n',kcartaer)

eval(sedder)
eval(kcartaer)

junk = ['status' num2str(iiBin)];
loader = ['exitcode = load(''' junk ''');'];
eval(loader);
fprintf(1,'iiBin,exitcode = %6i %2i \n',iiBin,exitcode)

rmer = ['!/bin/rm ' outnml ' status' num2str(iiBin)];
eval(rmer);
