function [w,d] = do_convolve(iInstr,iTimeStep,iiBin,iDoRad,kcvers,use_this_rtp);

if nargin == 2
  iDoRad = 3;  %% assume radiances so you need last one ......
  kcvers = 121;
end

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

find_file_names

fnamefind = [outdirtemp '/rad.dat' num2str(iiBin)];
if ~exist(fnamefind)
  fprintf(1,'oops where on earth is %s \n',fnamefind)
end

if kcvers >= 118
  [djunk,w,caVers] = readkcstd_smart([outdirtemp '/rad.dat' num2str(iiBin)]);
elseif kcvers == 116 | kcvers == 114 | kcvers == 112
  [djunk,w,caVers] = readkcstd_smartv116([outdirtemp '/rad.dat' num2str(iiBin)]);
else
  kcvers
  error('oopsy kcvers')  
end

%plot(w,djunk);
%whos w djunk
%error('lkjsg')

[mm,nn] = size(djunk);  %% if cloudy calc, could have 890000 x 5 rads
fprintf(1,'read in %s and found size of kcdata = %6i x %6i \n',['JUNK/rad.dat' num2str(iiBin)],mm,nn)

if iDoRad == 3
  dall = djunk(:,nn);  %%% >>>>>>>> huh, why have this line???? Becuz : if cloudy calc, could have 890000 x 5 rads and only want the last one
else  
  dall = djunk;  %% convolve all of them!
end

% iInstr = input('enter (1) AIRS (2) IASI (3) CrIS lo (4) CrIS hi (14) AIRS and CRIS Hi : ');

solzen = -1;
scanang = -1;
satzen = -1;
stemp = -1;
if nargin < 6
  'hello'
  set_rtp;
  use_this_rtp = 'junk.rtp.rtp';
end
good = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% this is so we can call airs_convolve_file_numchans
addpath /home/sergio/MATLABCODE/REGR_PROFILES_SARTA/RUN_KCARTA/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iInstr == 1
  clist = 1:2378;
  sfile = '/asl/matlib/srftest/srftables_m140f_withfake_mar08.hdf'; 
  sfile = '/asl/matlab2012/srftest/srftables_m140f_withfake_mar08.hdf';
  airs_convolve_file_numchans
  [fKc,rKc] = convolve_airs(w,dall,clist,sfile);
  whos dall fKc rKc
  
  %solzen = p.solzen;
  %scanang = p.scanang;
  %satzen = p.satzen;
  %stemp = p.stemp;
  saver = ['save ' outdirtemp '//individual_prof_convolved_kcarta_airs_' num2str(iiBin) '.mat fKc rKc sfile  use_this_rtp solzen scanang satzen stemp caVers good'];
  eval(saver)
  
elseif iInstr == 2
  fiasi = instr_chans('iasi')';

  %/asl/matlab/fftconv/s2fconvkc.m
  [rch,wch]=xfconvkc_serg_iasi(dall,w,'iasi12992','gauss',6);
  rKcIasi = interp1(wch',rch',fiasi);
  saver = ['save ' outdirtemp '//individual_prof_convolved_kcarta_iasi_' num2str(iiBin) '.mat fiasi rKcIasi use_this_rtp solzen scanang satzen stemp caVers good'];
  eval(saver)
  
elseif iInstr == 3
  error('too lazy to do CrIS LO')
  
elseif iInstr == 4 | iInstr == 14 | iInstr == 124

  iMax = 1;   %% assumes ONLY ONE RADIANCE, no ODS
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
    fprintf(1,'chunk %4i of %4i iLay(1) iLay(end) = %3i %3i \n',ix,mod20,iLay(1),iLay(end));    
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
  saver = ['save ' outdirtemp '//individual_prof_convolved_kcarta_crisHI_' num2str(iiBin) '.mat rcris_all fcris use_this_rtp solzen scanang satzen stemp caVers good'];

  if iInstr == 14 | iInstr == 124
    disp('also doing AIRS')
    clist = 1:2378;
    sfile = '/asl/matlib/srftest/srftables_m140f_withfake_mar08.hdf';
    sfile = '/asl/matlab2012/srftest/srftables_m140f_withfake_mar08.hdf';
    airs_convolve_file_numchans    
    [fKc,rKc] = convolve_airs(w,dall,clist,sfile);
    %saver = ['save ' outdirtemp '//individual_prof_convolved_kcarta_AIRS_crisHI_' num2str(iiBin) '.mat rcris_all fcris use_this_rtp solzen scanang satzen stemp caVers good'];
    saver = [saver ' fKc rKc sfile'];
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

fprintf(1,'do_convolve : saver = %s \n',saver)  
fprintf(1,'do_convolve : use_this_rtp = %s \n',use_this_rtp)  

