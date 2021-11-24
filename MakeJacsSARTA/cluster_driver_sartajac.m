%% based on ../Aux_jacs_AIRS_August2018_2002_2017

%% copied from /home/sergio/MATLABCODE/RATES_NEW/
addpath /asl/matlib/aslutil/
addpath /asl/matlib/h4tools
addpath /asl/matlib/rtptools
%addpath /home/sergio/MATLABCODE
%addpath /home/sergio/MATLABCODE/UTILITY/

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
JOB = 2;
%JOB = iLoop

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set_file_override_settings  %% give the name of the .m file which sets all relevant drive parameters

fprintf(1,'latbin = %2i, override file = %s \n',JOB,file_override_settings);
params = override_defaults(file_override_settings);

if ~exist(params.savedir)
  mker = ['!mkdir ' params.savedir]
  eval(mker)
end

iiBin = JOB;
params.iiBin = iiBin;

%% for testing
%params.fip = 'junk.ip.rtp';
%params.fop = 'junk.op.rtp';
%params.frp = 'junk.rp.rtp';

params.fip = mktemp('junk.ip.rtp');
params.fop = mktemp('junk.op.rtp');
params.frp = mktemp('junk.rp.rtp');

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('finished : now run put_together_sarta_jacs.m')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
