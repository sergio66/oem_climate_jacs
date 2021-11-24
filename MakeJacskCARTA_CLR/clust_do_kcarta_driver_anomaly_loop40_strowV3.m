%% % /bin/rm slurm* JUNK/rad.dat*; ; sbatch --array=1-365 sergio_matlab_anom40.sbatch

%% need to modify template_QXYZ.nml CORRECTLY for the rtp file to process!

addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/REGR_PROFILES_SARTA/RUN_KCARTA/

global iRunAmomal iColJacOnly tempscratchdir
system_slurm_stats;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

iRunAmomaly = +1;
if ~exist('iColJacOnly','var')
  iColJacOnly = -1; %% do coljacs and profilejacs
end
if length(iColJacOnly) == 0
  iColJacOnly = -1; %% do coljacs and profilejacs
end
iColJacOnly = -1;

iAIRSorCRIS = 1; %% AIRS
iAIRSorCRIS = 2; %% CRIS lo res

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));

%% jobmax for AIRS    2002/09 - 2018/08 is 365 [365(days/year) * 16(years) /16(days/timestep) = 365]
%% jobmax for CRIS lo 2012/05 - 2018/04 is 136 [365(days/year) * 06(years) /16(days/timestep) = 137]
%% jobmax for CRIS lo 2012/05 - 2019/04 is 157 [365(days/year) * 07(years) /16(days/timestep) = 157]
% JOB = 365
% JOB = 27

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
lser = ['!du -h /scratch/Anomaly365_16_12p4/' num2str(JOB,'%03d') '/*'];
eval(lser);
rmer = ['!/bin/rm -r /scratch/Anomaly365_16_12p4/' num2str(JOB,'%03d') '/*'];
eval(lser);

lser = ['!du -h /scratch/Anomaly365_16_12p8/' num2str(JOB,'%03d') '/*'];
eval(lser);
rmer = ['!/bin/rm -r /scratch/Anomaly365_16_12p8/' num2str(JOB,'%03d') '/*'];
eval(lser);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lser = ['!du -h /umbc/lustre/strow/sergio/scratch/Anomaly365_16_12p4/' num2str(JOB,'%03d') '/*'];
eval(lser);
rmer = ['!/bin/rm -r /umbc/lustre/strow/sergio/scratch/Anomaly365_16_12p4/' num2str(JOB,'%03d') '/*'];
eval(lser);

lser = ['!du -h /umbc/lustre/strow/sergio/scratch/Anomaly365_16_12p8/' num2str(JOB,'%03d') '/*'];
eval(lser);
rmer = ['!/bin/rm -r /umbc/lustre/strow/sergio/scratch/Anomaly365_16_12p8/' num2str(JOB,'%03d') '/*'];
eval(lser);
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set_gasOD_cumOD_rad_jac_flux_cloud_lblrtm  %% mostly to set kcarta execs and run params (ODs/rads/fluxes/jacs) etc

disp('>>>>>')
fprintf(1,'kcartaexec   = %s \n',kcartaexec);
fprintf(1,'f1,f2        = %4i %4i \n',f1,f2);
fprintf(1,'iDoRad       = %2i \n',iDoRad);
if iDoJac > 0
  fprintf(1,'  doing jacs for %3i \n',gg)
else
  disp('  no jacs')
end
fprintf(1,'iDoFlux      = %2i \n',iDoFlux);
fprintf(1,'iDoCloud     = %2i \n',iDoCloud);
fprintf(1,'iDoLBLRTM    = %2i \n',iDoLBLRTM);
fprintf(1,'iDo_rt_1vs43 = %2i \n',iDo_rt_1vs43);
fprintf(1,'iHITRAN      = %2i \n',iHITRAN);
fprintf(1,'iKCKD        = %2i \n',iKCKD);
disp('>>>>>')

%for iiBin = 40 : - 1 : 1
for iiBin = 1 : 40
  set_rtp_anomaly_loop40
  use_this_rtp370 = ['AnomSym/timestep_' num2str(1,'%03d') '_16day_avg.rp.rtp'];

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% DO NOT TOUCH THESE LAST TWO LINES. EDIT set_convolver as needed
  use_this_rtp0     = use_this_rtp;
  use_this_rtp370_0 = use_this_rtp370;
  set_convolver
  %% DO NOT TOUCH THESE LAST TWO LINES. EDIT set_convolver as needed
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %% everywhere you find '/' in use_this_rtp, replace it with '\/'
  ooh = strfind(use_this_rtp,'/');
  if length(ooh) > 0
    use_this_rtp = strrep(use_this_rtp, '/', '\/');
  end

  %% everywhere you find '/' in use_this_rtp, replace it with '\/'
  ooh = strfind(use_this_rtp370,'/');
  if length(ooh) > 0
    use_this_rtp370 = strrep(use_this_rtp370, '/', '\/');
  end

  %% everywhere you find '/' in strIceCloud, replace it with '\/'
  ooh = strfind(strIceCloud,'/');
  if length(ooh) > 0
    strIceCloud = strrep(strIceCloud, '/', '\/');
  end

  %% everywhere you find '/' in strWaterCloud, replace it with '\/'
  ooh = strfind(strWaterCloud,'/');
  if length(ooh) > 0
    strWaterCloud = strrep(strWaterCloud, '/', '\/');
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  kcvers = 121;

  %% iiBin = iLatbin;
  iLatbin = iiBin;

  iTimeStep = iTimeStep;
  fprintf(1,'processing JOB %5i ==> timestep %3i profile %5i \n',JOB,iTimeStep,iLatbin);
  fprintf(1,'  use this rtp = %s \n',use_this_rtp);

  find_file_names   %% keep same file names

  %% see MATLABCODE/oem_pkg_run_sergio_AuxJacs/MakeProfs/compare_timeanom_co2_profiles.m
  if iAIRSorCRIS == 1
    outputmatfile = [outdir '/strowfinitejac_convolved_kcarta_airs_' num2str(iLatbin) '_jac.mat'];  %% done June30-July1 problems with CO2/N2O/CH4 profs
                                                                                                    %% used AnomSym/June04_2019/timestep_*_16day_avg.rp.rtp
    outputmatfile = [outdir '/strowfinitejac_convolved_kcarta_airs_' num2str(iLatbin) '_jac2.mat']; %% done July 2, 2019  better        CO2/N2O/CH4 profs
                                                                                                    %% used AnomSym/timestep_*_16day_avg.rp.rtp
    outputmatfile = [outdir '/strowfinitejac_convolved_kcarta_airs_' num2str(iLatbin) '_jac3.mat']; %% done Aug 18. 2019  better        CO2/N2O/CH4/CFC11/CFC12 profs
                                                                                                    %% used AnomSym/timestep_*_16day_avg.rp.rtp
                                                                                                    %% some very wierd results
    outputmatfile = [outdir '/strowfinitejac_convolved_kcarta_airs_' num2str(iLatbin) '_jac4.mat']; %% done Aug 28. 2019  better        CO2/N2O/CH4/CFC11/CFC12 profs
                                                                                                  %% used AnomSym/timestep_*_16day_avg.rp.rtp
    %% this is only done for AIRS
    %% outputmatfile = [outdir '/strowfinitejac_convolved_kcarta_airs_' num2str(iLatbin) '_jac5.mat']; %% done Dec 05. 2019  better        CO2/N2O/CH4/CFC11/CFC12 profs
    %%                                                                                                 %% used AnomSym/timestep_*_16day_avg_co2ageofair.rp.rtp
  elseif iAIRSorCRIS == 2
    outputmatfile = [outdir '/strowfinitejac_convolved_kcarta_cris_' num2str(iLatbin) '_jac.mat'];  %% done June30-July1 problems with CO2/N2O/CH4 profs
                                                                                                    %% used AnomSym/June04_2019/timestep_*_16day_avg.rp.rtp
    outputmatfile = [outdir '/strowfinitejac_convolved_kcarta_cris_' num2str(iLatbin) '_jac2.mat']; %% done July 2, 2019  better        CO2/N2O/CH4 profs
                                                                                                    %% used AnomSym/timestep_*_16day_avg.rp.rtp
    outputmatfile = [outdir '/strowfinitejac_convolved_kcarta_cris_' num2str(iLatbin) '_jac3.mat']; %% done Aug 18. 2019  better        CO2/N2O/CH4/CFC11/CFC12 profs
                                                                                                    %% used AnomSym/timestep_*_16day_avg.rp.rtp
                                                                                                    %% some very wierd results
    outputmatfile = [outdir '/strowfinitejac_convolved_kcarta_cris_' num2str(iLatbin) '_jac4.mat']; %% done Aug 28. 2019  better        CO2/N2O/CH4/CFC11/CFC12 profs
                                                                                                  %% used AnomSym/timestep_*_16day_avg.rp.rtp
    %% this is only done for AIRS
    %% outputmatfile = [outdir '/strowfinitejac_convolved_kcarta_cris_' num2str(iLatbin) '_jac5.mat']; %% done Dec 05. 2019  better        CO2/N2O/CH4/CFC11/CFC12 profs
    %%                                                                                                 %% used AnomSym/timestep_*_16day_avg_co2ageofair.rp.rtp
  end
                                                                                                  
  fprintf(1,'  final file = %s \n',outputmatfile);

  if exist(outputmatfile)
    fprintf(1,'%s already exists \n',outputmatfile)
    iProcess = -1;
  else
    rad(1,:) = do_kcartaV3(caComment,f1,f2,iiBin,iDoLBLRTM,iDo_rt_1vs43,iKCKD,...
                           use_this_rtp,use_this_rtp370,0,outdirtemp,outnml,outname,status,kcartaexec);

    iaGasID = [2 4 6 51 52];
    for iGasID = 1 : length(iaGasID)
      rad(1+iGasID,:) = ...
		   do_kcartaV3(caComment,f1,f2,iiBin,iDoLBLRTM,iDo_rt_1vs43,iKCKD,...
			       use_this_rtp,use_this_rtp370,iaGasID(iGasID),outdirtemp,outnml,outname,status,kcartaexec);
    end

  w = 1 : length(rad);
  w = (w-1)*0.0025 + 605;

  if (iAIRSorCRIS == 1) 
    clist = 1:2378;
    sfile = '/asl/matlib/srftest/srftables_m140f_withfake_mar08.hdf'; 
    sfile = '/asl/matlab2012/srftest/srftables_m140f_withfake_mar08.hdf';
    airs_convolve_file_numchans  
    [fKc,rKc] = convolve_airs(w,rad,clist,sfile);
  elseif (iAIRSorCRIS == 2)   
    addpath /asl/matlib/h4tools/
    % /asl/matlab/fftconv/s2fconvkc.m
    % addpath /home/sergio/MATLABCODE/FCONV/
    % addpath /home/sergio/MATLABCODE/FFTCONV/
    addpath /asl/matlib/fconv
    addpath /asl/packages/ccast/source/
    % atype = 'hamming';
    % aparg = 6;   %% for hamming, this is irrelevant
    % fcris = load('cris_hires_chans.mat');
    % fcris = fcris.wnum;
    
    addpath /home/sergio/MATLABCODE/REGR_PROFILES_SARTA/RUN_KCARTA    
    [crisLW crisMW crisSW frqLW frqMW frqSW] = cal_flat(w',rad',4);
    fcris  = [frqLW;       frqMW;       frqSW];
    cris0  = [crisLW; crisMW; crisSW];
    cris   = cris_sinc2hamming(frqLW,frqMW,frqSW,cris0);

    fKc = fcris;
    rKc = cris;
    sfile = 'this is cris';
  end

%{
  whos dall fKc rKc
  tKc = rad2bt(fKc,rKc);; plot(fKc,tKc(:,1)*ones(1,4)-tKc(:,2:5))
%}
  saver = ['save ' outputmatfile ' fKc rKc sfile  use_this_rtp0 use_this_rtp370_0 iAIRSorCRIS'];
  if ~exist(outputmatfile)
    eval(saver)
  else
    fprintf(1,'oops %s exists skip saving \n',outputmatfile)
  end

  rmer = ['!/bin/rm ' outdirtemp '/*'];
  eval(rmer)

  toc

  end
  disp('------------------------------------------------------------------------')
  disp(' ')
  disp(' ')
  disp('ls Anomaly365_16_12p8/*/strowfin* | wc -l ')
  disp(' ')
  disp(' ')
end

disp('eample output : Anomaly365_16_12p8/001/strowfinitejac_convolved_kcarta_airs_9_jac5.mat')
disp('now run put_together_results_coljacV3.m')
