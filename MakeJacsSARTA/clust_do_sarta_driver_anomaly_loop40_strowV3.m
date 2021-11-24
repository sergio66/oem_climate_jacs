%% % /bin/rm slurm* JUNK/rad.dat*; ; sbatch --array=1-365 sergio_matlab_anom40.sbatch

%% need to modify template_QXYZ.nml CORRECTLY for the rtp file to process!

addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS
addpath /home/sergio/MATLABCODE/REGR_PROFILES_SARTA/RUN_KCARTA/
addpath /asl/matlib/aslutil/

global iRunAmomal iColJacOnly tempscratchdir iTimeStep
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

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
% JOB = 365
% JOB = 237

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iTimeStep = JOB

%for iiBin = 40 : - 1 : 1
for iiBin = 1 : 40
% for iiBin = 20
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  set_file_override_settings_anom40  %% give the name of the .m file which sets all relevant drive parameters

  fprintf(1,'timestep = %3i latbin = %2i \n',JOB,iiBin);
  params = override_defaults(file_override_settings);

  fprintf(1,'sarta = %s \n',params.sarta)

  if ~exist(params.savedir)
    fprintf(1,'%s DNE, making \n',params.savedir)
    mker = ['!mkdir ' params.savedir]
    eval(mker)
  end

  params.fip = mktemp('junk.ip.rtp');
  params.fop = mktemp('junk.op.rtp');
  params.frp = mktemp('junk.rp.rtp');
  sarta = params.sarta;
  sartaer = ['!' sarta ' fin=' params.fop ' fout=' params.frp];

  params.iiBin = iiBin;

  use_this_rtp370 = ['AnomSym_no_seasonal/timestep_' num2str(1,'%03d') '_16day_avg.rp.rtp'];
  use_this_rtp    = ['AnomSym_no_seasonal/timestep_' num2str(iTimeStep,'%03d') '_16day_avg.rp.rtp'];

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  use_this_rtp0     = use_this_rtp;
  use_this_rtp370_0 = use_this_rtp370;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  fprintf(1,'%s %s \n',use_this_rtp0,use_this_rtp370_0)

  outfile = [params.savedir '/xprofile_finite_jac_anomaly_strow_latbin_'  num2str(iiBin,'%02d')];
  outfile = [outfile '_timestemp_' num2str(iTimeStep,'%03d') '.mat'];
  iExist = -1;
  if exist(outfile)
    thedir = dir(outfile);
    if thedir.bytes > 5e5
      iExist = 1;
    end
  end

  [h,ha,ptime,pa] = rtpread(use_this_rtp);
  [h,ha,p0,pa]    = rtpread(use_this_rtp370);

  [co2jac,deltaco2] = do_finite_jac_anomaly_strow(h,ptime,p0,params,sartaer,2);
  [n2ojac,deltan2o] = do_finite_jac_anomaly_strow(h,ptime,p0,params,sartaer,4);
  [ch4jac,deltach4] = do_finite_jac_anomaly_strow(h,ptime,p0,params,sartaer,6);

  saver = ['save ' outfile ' co2jac deltaco2 n2ojac deltan2o ch4jac deltach4'];
  eval(saver)
end
