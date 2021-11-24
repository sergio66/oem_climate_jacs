function rad = do_kcartaV3(caComment,f1,f2,iiBin,iDoLBLRTM,iDo_rt_1vs43,iKCKD,...
                           use_this_rtp,use_this_rtp370,iWhichGas,outdirtemp,outnml,outname,status,kcartaexec);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS

gg = iWhichGas;

if exist(outname)
  rmer = ['!/bin/rm ' outname];
  fprintf(1,'hmm need to remove %s \n',outname);
  eval(rmer)
end

sedder = ['!sed -e "s/FF1/' num2str(f1) '/g"  -e "s/FF2/' num2str(f2) '/g" '];
sedder = [sedder ' -e "s/MMM/'     num2str(iiBin) '/g"'];
sedder = [sedder ' -e "s/TTT/'     num2str(iDo_rt_1vs43) '/g"'];
if iWhichGas == 0
  sedder = [sedder ' -e "s/XYZXYZ/'  use_this_rtp   '/g"'];  %%%<<<-- to sed rtpfname
else  
  junkrtp =  use_this_rtp;
  junkrtp(regexp(junkrtp,'\'))=[];
  fprintf(1,' reading %s \n',junkrtp)
  [h,ha,p0,pa] = rtpread(junkrtp);
  p00 = p0;
  [h,p] = subset_rtp(h,p0,[],[],iiBin); 

  junkrtp =  use_this_rtp370;
  junkrtp(regexp(junkrtp,'\'))=[];
  fprintf(1,' reading %s \n',junkrtp)
  [h,ha,p370,pa] = rtpread(junkrtp);
  [h,p370] = subset_rtp(h,p370,[],[],iiBin);

  str = ['p.gas_' num2str(iWhichGas) ' = p370.gas_' num2str(iWhichGas) ';'];
  fprintf(1,'str = %s \n',str)
  eval(str);
  str = ['p0.gas_' num2str(iWhichGas) '(:,' num2str(iiBin) ') = p370.gas_' num2str(iWhichGas) ';'];
  fprintf(1,'str = %s \n',str)
  eval(str);

  %keyboard_nowindow

  do_the_adjustppmv

  rtpname0 = [outdirtemp '/temprtp_' num2str(iiBin) '.rtp'];
  rtpname = rtpname0;
  ooh = strfind(rtpname,'/');
  if length(ooh) > 0
    rtpname = strrep(rtpname, '/', '\/');
  end
  sedder = [sedder ' -e "s/XYZXYZ/'  rtpname   '/g"'];  %%%<<<-- to sed rtpfname
  rtpwrite(rtpname0,h,ha,p0,pa)

end
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

iDoCloud = 1;
iDoFlux = -1;

if iWhichGas >= 0
  disp('do_kcarta.m here A1 (clr sky rads)')
  sedder = [sedder ' template_radonly.nml  > ' outnml];      
  kcartaer = ['!time ' kcartaexec ' ' outnml ' ' outname '; echo $? >& ' status];
  
  disp(' ')
  fprintf(1,'sedder for namelist = %s \n',sedder)
  disp(' ')
  fprintf(1,'kcartaer = %s \n',kcartaer)
  disp(' ')

  eval(sedder)
  eval(kcartaer)

  junk = status;
  loader = ['exitcode = load(''' junk ''');'];
  eval(loader);
  fprintf(1,'iiBin,exitcode = %6i %2i \n',iiBin,exitcode)

  rmer = ['!/bin/rm ' outnml ' ' status];
  eval(rmer);

  if exist('rtpname')
    rmer = ['!/bin/rm ' rtpname];
    eval(rmer);
  end

  addpath /home/sergio/KCARTA/MATLAB
  [rad,w] = readkcstd(outname);
end
