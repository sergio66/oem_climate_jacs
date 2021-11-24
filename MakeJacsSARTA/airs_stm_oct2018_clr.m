%% verify against ../Aux_jacs_AIRS_August2018_2002_2017/SARTA_multiCLOUD_JACS/Desc_ocean/
%% verify against ../Aux_jacs_AIRS_August2018_2002_2017/SARTA_multiCLOUD_JACS/Desc_ocean/
%% verify against ../Aux_jacs_AIRS_August2018_2002_2017/SARTA_multiCLOUD_JACS/Desc_ocean/

topts.iJacType = 0;   %% clr sky jacs!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

topts.fINPUT_rtp = '/home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/MakeJacskCARTA/CLEAR_JACS/latbin1_40.clr.rp.rtp';
topts.savedir  = 'SARTA_AIRSL1c_Oct2018_CLR2';

statsType = ['Desc'];         %% late  Aug 2018
statsType = ['Desc_ocean'];   %% early Aug 2018
topts.fINPUT_rtp = '/home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs_before2019/Aux_jacs_AIRS_August2018_2002_2017/';
topts.fINPUT_rtp = [topts.fINPUT_rtp '/LATS40_avg/' statsType '/latbin1_40.rp.rtp'];
topts.savedir  = 'SARTA_AIRSL1c_Oct2018_CLR';

