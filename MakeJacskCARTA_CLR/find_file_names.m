global iRunAmomaly  iColJacOnly tempscratchdir

if iRunAmomaly == -1
  %% usual 40 latbins only, simple
  outdirtemp  = ['JUNK/'];   %% scratch for the huge jacobian and .nml files
  outdir      = outdirtemp;  %% where the final jac_results_XY.mat file will be stored      
  
  outname    = [outdirtemp 'rad.dat' num2str(iiBin)];
  outnamejac = [outdirtemp 'jac.dat' num2str(iiBin)];
  outnml     = [outdirtemp 'run_nml' num2str(iiBin)];
  status     = [outdirtemp 'status'  num2str(iiBin)];

  outnamec    = [outdirtemp 'radc.dat' num2str(iiBin)];
  outnamejacc = [outdirtemp 'jacc.dat' num2str(iiBin)];
  outnmlc     = [outdirtemp 'runc_nml' num2str(iiBin)];
  statusc     = [outdirtemp 'statusc'  num2str(iiBin)];

elseif iRunAmomaly == +1
  %% 365 timesteps x 40 latbins only, harder

  disp('see << find_file_names.m >> and list_anomaly_files_to_be_made.m and put_together_results.m')

  caLBLRTM = '12.4';  %% fun test of the cluster
  caLBLRTM = '12.8';  %% default

  if strfind(caLBLRTM,'12.8') & iAIRSorCRIS == 1
    %% default; use LBLRTMv12.8 for CO2 and CH4
    outdir     = ['Anomaly365_16_12p8/' num2str(iTimeStep,'%03d') '/'];
    outdirR    = ['Anomaly365_16_12p8/RESULTS/'];  %% this is where the M_TS files will sit

    outdirtemp = ['/scratch/Anomaly365_16_12p8/' num2str(iTimeStep,'%03d') '/'];                          %% v1 suggested by Roy Prouty
    outdirtemp = ['/umbc/lustre/strow/sergio/scratch/Anomaly365_16_12p8/' num2str(iTimeStep,'%03d') '/']; %% v2 suggested by Larrabee
    outdirtemp = [tempscratchdir '/Anomaly365_16_12p8/' num2str(iTimeStep,'%03d') '/'];                   %% v3 suggested by Howard and Steve

  elseif strfind(caLBLRTM,'12.4') & iAIRSorCRIS == 1
    %% use LBLRTMv12.4 for CO2 and CH4
    outdir     = ['Anomaly365_16_12p4/' num2str(iTimeStep,'%03d') '/'];
    outdirR    = ['Anomaly365_16_12p4/RESULTS/'];  %% this is where the M_TS files will sit

    outdirtemp = ['/scratch/Anomaly365_16_12p4/' num2str(iTimeStep,'%03d') '/'];                          %% v1 suggested by Roy Prouty
    outdirtemp = ['/umbc/lustre/strow/sergio/scratch/Anomaly365_16_12p4/' num2str(iTimeStep,'%03d') '/']; %% v2 suggested by Larrabee
    outdirtemp = [tempscratchdir '/Anomaly365_16_12p4/' num2str(iTimeStep,'%03d') '/'];                   %% v3 suggested by Howard and Steve

  elseif strfind(caLBLRTM,'12.8') & iAIRSorCRIS == 2
    %% default; use LBLRTMv12.8 for CO2 and CH4
    outdir     = ['CLO_Anomaly137_16_12p8/' num2str(iTimeStep,'%03d') '/'];
    outdirR    = ['CLO_Anomaly137_16_12p8/RESULTS/'];  %% this is where the M_TS files will sit

    outdirtemp = ['/scratch/Anomaly137_16_12p8/' num2str(iTimeStep,'%03d') '/'];                          %% v1 suggested by Roy Prouty
    outdirtemp = ['/umbc/lustre/strow/sergio/scratch/Anomaly137_16_12p8/' num2str(iTimeStep,'%03d') '/']; %% v2 suggested by Larrabee
    outdirtemp = [tempscratchdir '/Anomaly137_16_12p8/' num2str(iTimeStep,'%03d') '/'];                   %% v3 suggested by Howard and Steve

  else
    caLBLRTM
    error('caLBLRTM unknowm')
  end

  if ~exist(outdir)
    fprintf(1,'making %s \n',outdir);
    mker = ['!/bin/mkdir ' outdir];
    eval(mker)
  end

  if ~exist(outdirR)
    fprintf(1,'making %s \n',outdirR);
    mker = ['!/bin/mkdir ' outdirR];
    eval(mker)
  end

  if ~exist(outdirtemp)
    fprintf(1,'making %s \n',outdirtemp);
    mker = ['!/bin/mkdir -p ' outdirtemp];
    eval(mker)
  end

  outname    = [outdirtemp '/rad.dat'  num2str(iiBin)];
  outnamejac = [outdirtemp '/jac.dat'  num2str(iiBin)];
  outnml     = [outdirtemp '/run_nml'  num2str(iiBin)];
  status     = [outdirtemp '/status'   num2str(iiBin)];

  outnamec    = [outdirtemp '/radc.dat'  num2str(iiBin)];
  outnamejacc = [outdirtemp '/jacc.dat'  num2str(iiBin)];
  outnmlc     = [outdirtemp '/runc_nml'  num2str(iiBin)];
  statusc     = [outdirtemp '/statusc'   num2str(iiBin)];
end

