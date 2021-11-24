%% % /bin/rm slurm* JUNK/rad.dat*; ; sbatch --array=1-365 sergio_matlab_anom40.sbatch

%% need to modify template_QXYZ.nml CORRECTLY for the rtp file to process!

addpath /home/sergio/MATLABCODE
global iRunAmomaly iColJacOnly tempscratchdir

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

iAIRSorCRIS = 1; %% AIRS
iAIRSorCRIS = 2; %% CRIS lo res

if iAIRSorCRIS == 1 
  iiBinMin = 1;
  iiBinMax = 40;
elseif iAIRSorCRIS == 2
  iiBinMin = 1;
  iiBinMax = 38;
end

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
% JOB = 49;
% JOB = 21;
% JOB = 269
% JOB = 16
% JOB = 10
% JOB = 1
% JOB = 2
% JOB = 3
% JOB = 365

lser_and_rmer

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

for iiBin = iiBinMin : iiBinMax
  lser_and_rmer
  set_rtp_anomaly_loop40

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% DO NOT TOUCH THESE LAST TWO LINES. EDIT set_convolver as needed
  use_this_rtp0 = use_this_rtp;
  set_convolver
  %% DO NOT TOUCH THESE LAST TWO LINES. EDIT set_convolver as needed
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %% everywhere you find '/' in use_this_rtp, replace it with '\/'
  ooh = strfind(use_this_rtp,'/');
  if length(ooh) > 0
    use_this_rtp = strrep(use_this_rtp, '/', '\/');
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

  %kcvers = 118;
  %kcvers = 116;
  %kcvers = 112;
  %kcvers = 120;
  kcvers = 121;

  %% iiBin = iLatbin;
  iLatbin = iiBin;

  iTimeStep = iTimeStep;
  fprintf(1,'processing JOB %5i ==> timestep %3i profile %5i \n',JOB,iTimeStep,iLatbin);
  fprintf(1,'  use this rtp = %s \n',use_this_rtp);

  find_file_names
  rmer_old_files

  outputmatfile = ['Anomaly365_16/' num2str(iTimeStep,'%03d') '/jac_results_' num2str(iLatbin) '.mat'];
  outputmatfile = [outdir '/jac_results_' num2str(iLatbin) '.mat'];
  fprintf(1,'  final file = %s \n',outputmatfile);

  if exist(outputmatfile)
    fprintf(1,'%s already exists \n',outputmatfile)
    iProcess = -1;
  else
    do_kcarta

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if iColJacOnly < 0
      fprintf(1,'kcarta exitcode = %3i,%3i  << iDoConvolve = %3i iInstr = %3i >> iDoRad = %3i \n',exitcode,exitcodec,iDoConvolve,iInstr,iDoRad);
    elseif iColJacOnly > 0
      fprintf(1,'kcarta coljac exitcode = %3i  << iDoConvolve = %3i iInstr = %3i >> iDoRad = %3i \n',exitcodec,iDoConvolve,iInstr,iDoRad);
    end

    %  do_convolve(iInstr,iiBin);
    %  do_convolve_jac(iInstr,iiBin);

    %{
    if iDoConvolve > 0 & iDoRad == 0 & exitcode == 0
      do_convolve(iInstr,iiBin,iDoRad,kcvers);
    end
    if iDoConvolve > 0 & iDoRad == 3 & exitcode == 0
      do_convolve(iInstr,iiBin,iDoRad,kcvers);
    end
    %}

    %% iInstr = 1 %% AIRS ONLY for now

    if iColJacOnly < 0
      if iDoConvolve > 0 & iDoRad == 3 & iDoJac == 101 & exitcode == 0 & exitcodec == 0
        disp(' .... doing rad convolve ...')
        do_convolve(iInstr,iTimeStep,iiBin,iDoRad,kcvers,iAIRSorCRIS);
        disp(' .... doing jac(z) convolve ...')  
        do_convolve_jac(iInstr,iTimeStep,iiBin,1,kcvers,iAIRSorCRIS);    %% do the 100 layer T/W/O
        disp(' .... doing jac col convolve ...')    
        do_convolve_jac(iInstr,iTimeStep,iiBin,100,kcvers,iAIRSorCRIS);  %% do the column jacs
      end
    elseif iColJacOnly > 0								     
      if iDoConvolve > 0 & iDoRad == 3 & iDoJac == 102 & exitcodec == 0
        disp(' .... doing rad convolve ...')
        do_convolve(iInstr,iTimeStep,iiBin,iDoRad,kcvers,iAIRSorCRIS);
        disp(' .... doing jac col convolve ...')    
        do_convolve_jac(iInstr,iTimeStep,iiBin,100,kcvers,iAIRSorCRIS);  %% do the column jacs
      end
    end

    disp('done with all convolutions')
    if iColJacOnly == -1
      put_together_results(iInstr,iTimeStep,iiBin,iAIRSorCRIS);
      cper_coljac(iTimeStep,iiBin,iAIRSorCRIS);
      rmer_all(iTimeStep,iiBin,iAIRSorCRIS);
    else
      put_together_results_coljac(iInstr,iTimeStep,iiBin,iAIRSorCRIS);
      cper_coljac(iTimeStep,iiBin,iAIRSorCRIS);
      rmer_all(iTimeStep,iiBin,iAIRSorCRIS);
    end

    toc

  end
  disp('------------------------------------------------------------------------')
  disp(' ')
  disp(' ')
  disp(' ')
end

disp('all done kcarta CLR jac, final check of blowing away files')
lser_and_rmer

disp('now run clust_driver_put_together_kcarta_jacs.m to comine iTempStep/latbins and put into RESULTS')
