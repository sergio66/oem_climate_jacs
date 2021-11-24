function params = override_defaults(file_override_settings);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% set the defaults

%% instrument type
params.iInstr = +2;  strInstr = 'CrIS hi-res';
params.iInstr = -2;  strInstr = 'CrIS lo-res';
params.iInstr = -3;  strInstr = 'IASI RTP1';
params.iInstr = +3;  strInstr = 'IASI RTP2';
params.iInstr = -1;  strInstr = 'AIRS L1b';
params.iInstr = +1;  strInstr = 'AIRS L1c';

%% name of input rtp file for jacobians
params.fINPUT_rtp = 'cloudNclear40latbinsAIRS.op.rtp';  %% satzen = 22

%% number of profiles in the rtp file
params.numProfs = 40; 

%% klayers exec : not needed since we assume LAYERS profiles
params.klayers = '/asl/packages/klayers/Bin/klayers_airs';

%% what type of jacobian is needed
%params.ix = 41; %% cloud jacs (with O3) from layers
params.iJacType = 0;   %% clear sky T(z), WV(z), O3(z), stemp jacs + col CO2,CH4,N2O
params.iJacType = 100; %% cloud sky T(z), WV(z), O3(z), stemp jacs + col CO2,CH4,N2O +  cpsize/cngwat/cprtop 

%%%%%%%%%%%%%%%%%%%%%%%%%
%% set output dir based on iJacType
if params.iJacType == 0
  params.savedir = 'SARTA_CLRJACS_97_T_WV_O3_stemp_col_CO2_CH4_N2O';
elseif params.iJacType == 100
  params.savedir = 'SARTA_CLDJACS_97_T_WV_O3_stemp_col_CO2_CH4_N2O_cpsize_cngwat_cprtop';
else
  params.savedir = 'JUNK';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% over ride the defaults
allowedparams = [{'iInstr'},{'iJacType'},{'klayers'},{'sarta'},{'fINPUT_rtp'},{'numProfs'},{'savedir'}];

if ~strcmp(file_override_settings,[])
  if ~exist(file_override_settings)
    fprintf(1,'your input for file_override_settings = %s DNE \n',file_override_settings);
    error('file_override_settings file DNE');
  else
    fprintf(1,'processing %s to override defaults\n',file_override_settings)
    junkstr = file_override_settings(1:length(file_override_settings)-2);
    eval(junkstr);
    optvar = fieldnames(topts);
    for i = 1 : length(optvar)
       if (length(intersect(allowedparams,optvar{i})) == 1)
         eval(sprintf('params.%s = topts.%s;', optvar{i}, optvar{i}));
       else
         fprintf(1,'topts param not in allowed list ... %s \n',optvar{i});
         error('quitting cluster_driver_sartajac.m')
       end   %% if length(intersect(allowedparams,optvar{i}))
     end     %% for i
  end        %% ~exist(file_override_settings)
end          %% file_override_settings ~= []


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% now start checking params

switch params.iJacType
  case 0
    strJac = '97 layer clear sky T(z), WV(z), O3(z) jacs, plus surftemp, col CO2,CH4,N2O';
  case 100
    strJac = '97 layer cloud sky T(z), WV(z), O3(z) jacs, plus surftemp, col CO2,CH4,N2O, plus cpsize/cngwat/cprtop';
  otherwise
    fprintf(1,'params.iJacType = %3i unknown \n',params.iJacType)
    disp('need it to be 0 (clr sky 100 layer jacs) or 100 (cld sky 100 layer jacs)')
    error('please fix params.iJacType')
end

switch params.iInstr
  case -1
    strInstr = 'AIRS L1b';
  case +1
    strInstr = 'AIRS L1c';
  case -2
    strInstr = 'Cris lo-res';
  case +2
    strInstr = 'Cris hi-res';
  case -3
    strInstr = 'IASI RTP1';
  case +3
    strInstr = 'IASI RTP2';
  otherwise
    fprintf(1,'params.iInstr = %3i unknown \n',params.iInstr)
    disp('need it to be +/-1 (AIRS) +/-2 (CrIS) +/-3 (IASI)')
    error('please fix params.iInstr')    
end

iNewOrOldSarta = -1;
iNewOrOldSarta = +1;

%% set sarta based on the instrument type and clr/cld jacs needed
if params.iJacType < 100
  disp('setting CLEAR SKY sarta')
  %% CLEAR
  if params.iInstr == -1
    params.sarta = '/asl/packages/sartaV108/BinV201/sarta_apr08_m140_wcon_nte_nh3';
    params.sarta = '/asl/packages/sartaV108/BinV201/sarta_apr08_m140_pge_v6_tunmlt';
    if iNewOrOldSarta == +1
      params.sarta = '/home/chepplew/gitLib/sarta/bin/airs_l1c_2834_cloudy_may19';   %% new sarta
    end
    iInstr = 'AIRS L1b';
  elseif params.iInstr == +1
    params.sarta = '/asl/packages/sartaV108/BinV201/sarta_apr08_m140_wcon_nte_nh3';
    params.sarta = '/asl/packages/sartaV108/BinV201/sarta_apr08_m140_pge_v6_tunmlt';
    if iNewOrOldSarta == +1
      params.sarta = '/home/chepplew/gitLib/sarta/bin/airs_l1c_2834_cloudy_may19';   %% new sarta
    end
    iInstr = 'AIRS L1c';
  elseif params.iInstr == -2
    params.sarta = '/asl/packages/sartaV108/BinV201/sarta_crisg4_nov09_wcon_nte_nh3';
    iInstr = 'Cris LoRes';  
  elseif params.iInstr == +2
    params.sarta = '/asl/packages/sartaV108/BinV201/sarta_crisg4_nov09_wcon_nte_nh3'; 
    iInstr = 'Cris HiRes';   
  elseif params.iInstr == +1
    params.sarta = '/asl/packages/sartaV108/BinV201/sarta_iasi_may09_wcon_nte_swch4_nh3';
    iInstr = 'IASI';
  end
elseif params.iJacType >= 100
  disp('setting CLOUD SKY sarta')
  %% CLOUDY
  if params.iInstr == -1
    params.sarta = '/home/sergio/SARTA_CLOUDY/BinV201/sarta_apr08_m140x_iceGHMbaum_waterdrop_desertdust_slabcloud_hg3';
    params.sarta = '/asl/packages/sartaV108/BinV201/sarta_apr08_m140_iceGHMbaum_waterdrop_desertdust_slabcloud_hg3';
    if iNewOrOldSarta == +1
      params.sarta = '/home/chepplew/gitLib/sarta/bin/airs_l1c_2834_cloudy_may19';   %% new sarta
    end
    iInstr = 'AIRS L1b';
  elseif params.iInstr == +1
    params.sarta = '/home/sergio/SARTA_CLOUDY/BinV201/sarta_apr08_m140x_iceGHMbaum_waterdrop_desertdust_slabcloud_hg3';
    params.sarta = '/asl/packages/sartaV108/BinV201/sarta_apr08_m140_iceGHMbaum_waterdrop_desertdust_slabcloud_hg3';    
    if iNewOrOldSarta == +1
      params.sarta = '/home/chepplew/gitLib/sarta/bin/airs_l1c_2834_cloudy_may19';   %% new sarta
    end
    iInstr = 'AIRS L1c';
  elseif params.iInstr == -2
    params.sarta = '/asl/packages/sartaV108/BinV201/sarta_crisg4_nov09_wcon_nte';
    params.sarta = '/asl/packages/sartaV108/BinV201/sarta_crisg4_nov09_iceGHMbaum_waterdropMODIS_desertdust_slabcloud_hg3_wcon_nte';
    iInstr = 'Cris LoRes';  
  elseif params.iInstr == +2
    params.sarta = '/asl/packages/sartaV108/BinV201/sarta_crisg4_nov09_wcon_nte';
    params.sarta = '/asl/packages/sartaV108/BinV201/sarta_crisg4_nov09_iceGHMbaum_waterdropMODIS_desertdust_slabcloud_hg3_wcon_nte';    
    iInstr = 'Cris HiRes';   
  elseif params.iInstr == +1
    params.sarta = '/asl/packages/sartaV108/BinV201/sarta_iasi_may09_iceaggr_waterdrop_desertdust_slabcloud_hg3_wcon_nte_swch4';
    params.sarta = '/asl/packages/sartaV108/BinV201/sarta_iasi_may09_iceaggr_waterdrop_desertdust_slabcloud_hg3_wcon_nte_swch4';
    iInstr = 'IASI';
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist(params.fINPUT_rtp)
  fprintf(1,'params.fINPUT_rtp %s DNE \n',params.fINPUT_rtp)
  error('please chceck input rtp file');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% passed basic checks : ready to proceed, though impending failures can include
%% 1) trying to process more profiles than actually exist in rtp file
%% 2) a LVLS file rather than LAYERS file

disp('  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
fprintf(1,'  params.iJacType    = %3i : jacs  = %s \n',params.iJacType,strJac);
fprintf(1,'  params.iInstr      = %3i : instr = %s \n',params.iInstr,strInstr);
fprintf(1,'  params.fINPUT_rtp  = %s \n',params.fINPUT_rtp);
fprintf(1,'  params.numProfs    = %3i \n',params.numProfs);
fprintf(1,'  params.savedir     = %s \n',params.savedir);
fprintf(1,'  params.sarta       = %s \n',params.sarta);
disp('  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
