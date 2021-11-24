%% based on ../Aux_jacs_AIRS_August2018_2002_2017

%% copied from /home/sergio/MATLABCODE/RATES_NEW/
addpath /asl/matlib/aslutil/
addpath /asl/matlib/h4tools
addpath /asl/matlib/rtptools
%addpath /home/sergio/MATLABCODE
%addpath /home/sergio/MATLABCODE/UTILITY/

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
%JOB = 238

global iTimeStep
iTimeStep = JOB;

for iLoop = 1 : 40
%for iLoop = 40 : -1 : 1

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  set_file_override_settings_anom40  %% give the name of the .m file which sets all relevant drive parameters

  fprintf(1,'timestep = %3i latbin = %2i, override file = %s \n',JOB,iLoop,file_override_settings);
  params = override_defaults(file_override_settings);

  fprintf(1,'sarta = %s \n',params.sarta)

  if ~exist(params.savedir)
    fprintf(1,'%s DNE, making \n',params.savedir)
    mker = ['!mkdir ' params.savedir]
    eval(mker)
  end

  iiBin = iLoop;
  params.iiBin = iiBin;

  %% for testing
  %params.fip = 'junk.ip.rtp';
  %params.fop = 'junk.op.rtp';
  %params.frp = 'junk.rp.rtp';

  params.fip = mktemp('junk.ip.rtp');
  params.fop = mktemp('junk.op.rtp');
  params.frp = mktemp('junk.rp.rtp');

  outfile = [params.savedir '/xprofile' num2str(iiBin) '.mat'];
  iExist = -1;
  minsize = 5e5;
  minsize = 3e5;
  minsize = 2e5;
  if exist(outfile)
    thedir = dir(outfile);
    if thedir.bytes > minsize
      iExist = 1;
    end
  end

  if iExist < 0
    [hx,ha,px,pa,cfc11jac] = initialize_hand_jacs(params.fINPUT_rtp,iiBin,...
                              params.sarta,params.klayers,params.fip,params.fop,params.frp,params.iInstr);

    saver = ['save ' params.savedir '/hx.mat hx'];
    eval(saver)

    saver = ['save ' params.savedir '/xprofile' num2str(iiBin) '.mat px params'];
    eval(saver);

    if params.iJacType == 0
      compute_sarta_clr_jacobians_twodelta(hx,ha,px,pa,params,cfc11jac);
    elseif params.iJacType == 100
      compute_sarta_cld_jacobians_onedelta(hx,ha,px,pa,params,cfc11jac);
    end

  elseif exist(outfile)
    fprintf(1,'%s already exisits, skipping \n',outfile)
  end
  disp(' ')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('finished : now running put_together_sarta_jacs_anom40.m')
put_together_sarta_jacs_anom40
disp('FINISHED you may have to translate from 2834 chans to 2645 chans, and put in CFC jacs ... ');
disp('      see eg add_kcarta_cfc.m and translate2834to2645_addCFCjacs.m');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
