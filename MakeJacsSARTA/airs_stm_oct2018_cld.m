%% verify against ../Aux_jacs_AIRS_August2018_2002_2017/SARTA_multiCLOUD_JACS/Desc_ocean/
%% verify against ../Aux_jacs_AIRS_August2018_2002_2017/SARTA_multiCLOUD_JACS/Desc_ocean/
%% verify against ../Aux_jacs_AIRS_August2018_2002_2017/SARTA_multiCLOUD_JACS/Desc_ocean/

%% to verify make sure params.sarta = '/home/sergio/SARTA_CLOUDY/BinV201/sarta_apr08_m140x_iceGHMbaum_waterdrop_desertdust_slabcloud_hg3';
%% to verify make sure params.sarta = '/home/sergio/SARTA_CLOUDY/BinV201/sarta_apr08_m140x_iceGHMbaum_waterdrop_desertdust_slabcloud_hg3';
%% to verify make sure params.sarta = '/home/sergio/SARTA_CLOUDY/BinV201/sarta_apr08_m140x_iceGHMbaum_waterdrop_desertdust_slabcloud_hg3';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% else just stick to the Steve sarta exec /asl/packages/sartaV108/BinV201/sarta_apr08_m140_iceGHMbaum_waterdrop_desertdust_slabcloud_hg3

topts.iJacType = 100;   %% cld sky jacs!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

statsType = ['Desc'];         %% late  Aug 2018
statsType = ['Desc_ocean'];   %% early Aug 2018
topts.fINPUT_rtp = ['/home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs_before2019/Aux_jacs_AIRS_August2018_2002_2017/LATS40_avg/' statsType '/latbin1_40.rp.rtp'];

topts.savedir = 'SARTA_AIRSL1c_Oct2018';
