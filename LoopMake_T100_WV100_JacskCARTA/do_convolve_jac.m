function [w,d] = do_convolve_jac(iInstr,ii,iDoJac);

addpath /home/sergio/MATLABCODE
addpath /home/sergio/KCARTA/MATLAB
addpath /asl/matlib/h4tools
addpath /asl/matlib/rtptools

addpath /asl/matlib/fconv
addpath /asl/packages/ccast/source/

addpath /home/sergio/MATLABCODE/FCONV/
addpath /home/sergio/MATLABCODE/FFTCONV/
addpath /home/sergio/Backup_asl_matlab_Feb2013
addpath /asl/matlab2012/sconv
%addpath /asl/matlab2012/fconv

set_rtp;
% iInstr = input('enter (1) AIRS (2) IASI (3) CrIS lo (4) CrIS hi (14) AIRS and CRIS Hi : ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% this is so we can call airs_convolve_file_numchans
addpath /home/sergio/MATLABCODE/REGR_PROFILES_SARTA/RUN_KCARTA/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iDoJac == 1
  [dall,w,natmos, numlay, ngases] = readkcjac(['JUNK/jac.dat' num2str(ii)]);
elseif iDoJac == 100
  [dall,w] = readkcBasic(['JUNK/jacc.dat' num2str(ii) '_COL']);
  %[junk_rad,dall,w] = readkcPCLSAM_coljac(['JUNK/radc.dat' num2str(ii)],['JUNK/jacc.dat' num2str(ii) '_COL']);
end

[mm,nn] = size(dall);
if iDoJac == 1
%  mm
%  nn
%  natmos
%  numlay
%  ngases
  junk = [mm nn natmos numlay(1) ngases];
  fprintf(1,'jacobian is of size %8i x %3i for %2i atmospheres each with %3i layers and %3i gases \n',junk);
else
  junk = [mm nn];
  fprintf(1,'col jacobian is of size %8i x %3i  \n',junk);
end

if iInstr == 1
  clist = 1:2378;
  sfile = '/asl/matlib/srftest/srftables_m140f_withfake_mar08.hdf'; 
  sfile = '/asl/matlab2012/srftest/srftables_m140f_withfake_mar08.hdf';
  airs_convolve_file_numchans  
  [fKc,rKc] = convolve_airs(w,dall,clist,sfile);
  whos dall fKc rKc

  if iDoJac == 1
    saver = ['save JUNK/individual_prof_convolved_kcarta_airs_' num2str(ii) '_jac.mat fKc rKc sfile  use_this_rtp '];
  else
    saver = ['save JUNK/individual_prof_convolved_kcarta_airs_' num2str(ii) '_coljac.mat fKc rKc sfile  use_this_rtp '];
  end
  eval(saver)
  
elseif iInstr == 2
  fiasi = instr_chans('iasi')';

  %/asl/matlab/fftconv/s2fconvkc.m

  iMax = nn;   
  mod20 = ceil(iMax/20);

  for ix = 1 : mod20
    iLay = (1:20) + (ix-1)*20;
    fprintf(1,'kcarta jac output chunk %4i of %4i iLay(1) iLay(end) = %3i %3i \n',ix,mod20,iLay(1),iLay(end));
    if max(iLay) > iMax
      iLay = iLay(1):iMax;
    end
    if length(iLay) > 1
      [rch,wch]=xfconvkc_serg_iasi(dall(:,iLay),w,'iasi12992','gauss',6);
      rKcIasi = interp1(wch',rch',fiasi);
    else
      [rch,wch]=xfconvkc_serg_iasi(dall(:,iLay),w,'iasi12992','gauss',6);
      rKcIasi = interp1(wch',rch',fiasi);
    end
    rKcIasi_all(:,iLay) = rKcIasi;
  end
  if iDoJac == 1  
    saver = ['save JUNK/individual_prof_convolved_kcarta_iasi_' num2str(ii) '_jac.mat fiasi rKcIasi_all use_this_rtp'];
  else
    saver = ['save JUNK/individual_prof_convolved_kcarta_iasi_' num2str(ii) '_coljac.mat fiasi rKcIasi_all use_this_rtp'];
  end
  eval(saver)

elseif iInstr == 3
  error('too lazy to do CrIS LO')
elseif iInstr == 4 | iInstr == 14 | iInstr == 124

  iMax = nn;   
  mod20 = ceil(iMax/20);
  
  addpath /home/sergio/MATLABCODE
  addpath /home/sergio/KCARTA/MATLAB
  addpath /asl/matlib/h4tools/

  addpath /asl/matlib/fconv
  addpath /asl/packages/ccast/source/

  for ix = 1 : mod20
    iLay = (1:20) + (ix-1)*20;
    if max(iLay) > iMax
      iLay = iLay(1):iMax;
    end
    fprintf(1,'kcarta jac output chunk %4i of %4i iLay(1) iLay(end) = %3i %3i \n',ix,mod20,iLay(1),iLay(end));
    if length(iLay) > 1
      [radLW radMW radSW frqLW frqMW frqSW] = cal_flat(w,dall(:,iLay),4);
    else
      [radLW radMW radSW frqLW frqMW frqSW] = cal_flat(w,dall,4);
    end
    fcris = [frqLW; frqMW; frqSW];
    rcris = [radLW; radMW; radSW];

    rcris_all(:,iLay) = rcris;  
  end

  %% change apodization
  %new way
  addpath /asl/packages/airs_decon/source
  band1 = 1 : length(frqLW); band1 = band1 + 0;
  band2 = 1 : length(frqMW); band2 = band2 + length(band1);
  band3 = 1 : length(frqSW); band3 = band3 + length(band1) + length(band2);
  
  %% check everything ok
  %wah = [band1 band2 band3]; plot(wah-(1:length(fcris))); setdiff(1:length(fcris),wah); sum(wah-(1:length(fcris)))
  %[band1(1) band1(end) band2(1) band2(end) band3(1) band3(end)]

  rcrisx = rcris_all;
  aa = rcrisx(band1,:); aa = hamm_app(aa);
  bb = rcrisx(band2,:); bb = hamm_app(bb);
  cc = rcrisx(band3,:); cc = hamm_app(cc);

  rcris_all = [aa; bb; cc];

  %solzen = p.solzen;
  %scanang = p.scanang;
  %satzen = p.satzen;
  %stemp = p.stemp;
  if iDoJac == 1    
    saver = ['save JUNK/individual_prof_convolved_kcarta_crisHI_' num2str(ii) '_jac.mat rcris_all fcris use_this_rtp'];
  else
    saver = ['save JUNK/individual_prof_convolved_kcarta_crisHI_' num2str(ii) '_coljac.mat rcris_all fcris use_this_rtp'];
  end
  
  if iInstr == 14 | iInstr == 124
    disp('also doing AIRS')
    clist = 1:2378;
    sfile = '/asl/matlib/srftest/srftables_m140f_withfake_mar08.hdf';
    sfile = '/asl/matlab2012/srftest/srftables_m140f_withfake_mar08.hdf';
    airs_convolve_file_numchans    
    [fKc,rKc] = convolve_airs(w,dall,clist,sfile);
    if iDoJac == 1      
      saver = ['save JUNK/individual_prof_convolved_kcarta_AIRS_crisHI_' num2str(ii) '_jac.mat rcris_all fcris use_this_rtp'];
      saver = [saver ' fKc rKc sfile'];
    else
      saver = ['save JUNK/individual_prof_convolved_kcarta_AIRS_crisHI_' num2str(ii) '_coljac.mat rcris_all fcris use_this_rtp'];
      saver = [saver ' fKc rKc sfile'];
    end
  end

  if iInstr == 24 | iInstr == 124
    disp('also doing IASI')

    fiasi = instr_chans('iasi')';

    %/asl/matlab/fftconv/s2fconvkc.m
    [rch,wch]=xfconvkc_serg_iasi(dall,w,'iasi12992','gauss',6);
    rKcIasi = interp1(wch',rch',fiasi);
    saver = [saver ' fiasi rKcIasi'];
  end
  
  eval(saver);
  
end
fprintf(1,'do_convolve_jac.m : iInstr,ii,iDoJac = %3i %3i %3i\n',iInstr,ii,iDoJac)
fprintf(1,'do_convolve_jac.m : saver = %s\n',saver)
