%{
can drive it using

for JOB = 1 : 365
  put_together_sarta_jacs_anom40
end

or

append it after calling
  cluster_driver_sartajac_anom40.m
in
  sergio_matlab_jobB.sbatch

as done at last few lines of cluster_driver_sartajac_anom40.m 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('finished : now running put_together_sarta_jacs_anom40.m')
put_together_sarta_jacs_anom40
disp('FINISHED you may have to translate from 2834 chans to 2645 chans, and put in CFC jacs ... ');
disp('      see eg add_kcarta_cfc.m and translate2834to2645_addCFCjacs.m');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mkdir SARTA_AIRSL1c_Anomaly365_16/RESULTS
translate2834to2645_addCFCjacs
%}

addpath /asl/matlib/h4tools
addpath /asl/matlib/rtptools
addpath /asl/matlib/aslutil

global iTimeStep
iTimeStep = JOB;
iLoop = -1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set_file_override_settings_anom40  %% give the name of the .m file which sets all relevant drive parameters
params = override_defaults(file_override_settings);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iMin = 01; iMax = params.numProfs;

iCnt = 0;

clear iaFound t0 aM_TS_jac kt0 kaM_TS_jac

ix = params.iJacType;
thedir0 = params.savedir;
fprintf(1,'reading saved .mat files from %s \n',thedir0);

%%%%%%%%%%%%%%%%%%%%%%%%%
if abs(params.iInstr) == 1
  oldmat = load('/home/sergio/MATLABCODE/oem_pkg/Test/M_TS_jac_all.mat'); %% this gives 
                                                                          %% f qrenorm str1 str2 str3
  f = oldmat.f;								   

  %%%%% trying to do 2834 chans
  hdffile = '/home/sergio/MATLABCODE/airs_l1c_srf_tables_lls_20181205.hdf';   % what he gave in Dec 2018
  vchan2834 = hdfread(hdffile,'freq');
  f = vchan2834;

elseif abs(iInstr) == +2;   %% CRIS (lo res for now)
  load /home/sergio/MATLABCODE/cris_chans_june2016_1317chans.mat
  f = hcris.vchan;
end

%%%%%%%%%%%%%%%%%%%%%%%%%

thedir = [thedir0 '/'];

disp('see normer')
if params.iJacType == 0
  fprintf(1,'params.iJacType = %3i so CLR',params.iJacType)
  %% see normer.clr
  str1 = {'CO2'  'N2O'  'CH4'  'CFC11'  'ST'  'WV(97)'  'T(97)' 'O3(97)'};
  str2 = '[ [2.2 1.0 5 1 0.1] [0.01*ones(1,97)] [0.01*ones(1,97)] [0.01*ones(1,97)]]';
  qrenorm = [[2.2 1.0 5 1 0.1] [0.01*ones(1,97)] [0.01*ones(1,97)] [0.01*ones(1,97)]];
  normer = normer_clr(params);  
elseif params.iJacType == 100
  fprintf(1,'params.iJacType = %3i so CLD',params.iJacType)

  %% ORIG
  str1 = {'CO2' 'N2O'  'CH4' 'CFC11'  'CFC12' 'ST'  'CNG1' 'CNG2' 'CSZ1' 'CSZ2' 'CPR1' 'CPR2' 'WV(97)'  'T(97)'  ' O3(97)'};
  str2 = '[ [2.2 1.0 5 1 1 0.1][0.001 0.001 0.001 0.001 0.001 0.001] [0.1*ones(1,97)] [0.5*ones(1,97)]] [0.01*ones(1,97)]]';
  qrenorm = [[2.2 1.0 5 1 1 0.1] [0.001*ones(1,6)] [0.1*ones(1,97)] [0.5*ones(1,97)] [0.01*ones(1,97)]];

  %% NEW, see normer.cld
  str1 = {'CO2' 'N2O'  'CH4' 'CFC11'  'CFC12' 'ST'  'CNG1' 'CNG2' 'CSZ1' 'CSZ2' 'CPR1' 'CPR2' 'WV(97)'  'T(97)'  ' O3(97)'};
  str2 = '[ [2.2 1.0 5 1 1 0.1][0.001 0.001 0.001 0.001 0.001 0.001] [0.01*ones(1,97)] [0.01*ones(1,97)]] [0.01*ones(1,97)]]';
  qrenorm = [[2.2 1.0 5 1 1 0.1] [0.01*ones(1,6)] [0.01*ones(1,97)] [0.01*ones(1,97)] [0.01*ones(1,97)]];

  clear norm*    
  normer = normer_cld(params);
else
  error('huh params.iJacType?')  
end

for iiBin = iMin : iMax
  clear coljac slayjac tlayjac wlayjac aM_TS_jac

  thename = [thedir 'xprofile' num2str(iiBin) '.mat'];

  ee = exist(thename);
  if ee > 0
    fprintf(1,'.');
    iCnt = iCnt + 1;
    iaFound(iCnt) = iiBin;

    aM_TS_jac = [];   %% this already exists in eg SARTA_JACS/profile_ozone_4lays_5.mat so NO NEED to build it
    clear t0        %%%%%%%% t0 is the mean BT for this latbin!!!!!

    loader = ['load  ' thename];
    eval(loader)

    %% column jacs are for 0.1 frac change, need to renorm
    %% make_sarta_test_jacobians

    [mmjunk,nnjunk] = size(aM_TS_jac);
    if params.iJacType == 100 & nnjunk == 299
      disp('whooops too few layers (96)!!')
      aM_TS_jacjunk = zeros(2378,302);
      aM_TS_jacjunk = zeros(2834,302);
      indjunk0 = [001:011]; indjunk1 = [001:011]; aM_TS_jacjunk(:,indjunk1) = aM_TS_jac(:,indjunk0);
      indjunk0 = [012:107]; indjunk1 = [012:107]; aM_TS_jacjunk(:,indjunk1) = aM_TS_jac(:,indjunk0);
      indjunk0 = [108:203]; indjunk1 = [109:204]; aM_TS_jacjunk(:,indjunk1) = aM_TS_jac(:,indjunk0);            
      indjunk0 = [204:299]; indjunk1 = [206:301]; aM_TS_jacjunk(:,indjunk1) = aM_TS_jac(:,indjunk0);            
      aM_TS_jac = aM_TS_jacjunk;
      clear aM_TS_jacjunk
    end
    
    kcM_TS_jac(iiBin,:,:) = aM_TS_jac;
    if exist('t0','var')
      kt0(iiBin,:) = t0;
    end

    if length(iaFound) == 1 & iaFound(1) == 1
      %% everything cool
      hxall = hx;
      pxall = px;
    elseif length(iaFound) == 1 & iaFound(1) > 1
      %% not everything cool, did not find first latbin so gotta fake
      hxall = hx;
      pxall = px;
      [hxall,pxall] = cat_rtp(hxall,pxall,hx,px);
      pxall.ptemp(:,1) = 0;
      pxall.stemp(1) = 0;
      pxall.cngwat(1) = 0;
      pxall.cngwat2(1) = 0;
    else
      %% everything cool
      [hxall,pxall] = cat_rtp(hxall,pxall,hx,px);
    end
  end
end
fprintf(1,'\n');

disp('---------------')
fprintf(1,'of the expected %4i files, %4i were found \n',params.numProfs,length(iaFound))
disp(' ... what was found ...')
iaFound
disp('... not found ... not found ....')
setdiff(1:params.numProfs,iaFound)
disp('---------------')

M_TS_jac_all = kcM_TS_jac;
if exist('kt0','var')
  t0 = kt0;
  clear kt0;
end

if params.iJacType == 0
  saver = ['save ' thedir 'sarta_origM_TS_jac_all_5_97_97_97.mat M_TS_jac_all f qrenorm str1 str2 iaFound'];
elseif params.iJacType == 100
  clear t0
  saver = ['save ' thedir 'sarta_M_TS_jac_all_5_6_97_97_97_cld.mat M_TS_jac_all f qrenorm str1 str2 iaFound hxall pxall'];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[aaaa,bbbb,cccc] = size(M_TS_jac_all);
[dddd] = length(f);
if dddd ~= bbbb
  [dddd bbbb]
  error('length(f) and length(jac f) do NOT match')
else
  fprintf(1,'saving jacs for %4i channels \n',dddd)
end  
%{
disp('hit ret 1 of 5 to save BIG fat file'); pause
disp('hit ret 2 of 5 to save BIG fat file'); pause
disp('hit ret 3 of 5 to save BIG fat file'); pause
disp('hit ret 4 of 5 to save BIG fat file'); pause
disp('hit ret 5 of 5 to save BIG fat file'); pause
%}
eval(saver)

