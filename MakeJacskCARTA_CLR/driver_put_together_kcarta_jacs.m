function [kcjac,savestr,outjacname] = driver_put_together_kcarta_jacs(iTimeStep,iAIRSorCRIS)

addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS
addpath /asl/matlib/h4tools

%{
so for usual latbins can do eg
  [kcjac,savestr] = driver_put_together_kcarta_jacs(-1,iAIRSorCRIS);eval(savestr);
and for AIRS anomalies can do
 for iTimeStep = 1 : 365
   iAIRSorCRIS = 1;
   [kcjac,savestr] = driver_put_together_kcarta_jacs(iTimeStep,iAIRSorCRIS);eval(savestr);
 end
and for CRIS NSR anomalies can do
 for iTimeStep = 1 : 157
   iAIRSorCRIS = 2;
   [kcjac,savestr] = driver_put_together_kcarta_jacs(iTimeStep,iAIRSorCRIS);eval(savestr);
 end
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% see ../MakeJacsSARTA/normer_clr.m
%{
function normer = normer_clr(params)

normer.dQ = 0.01;
normer.dT = 1;

%% *********** these are the normalizations we started with ************

normer.normCO2 = 2.2/370;   %% ppm/yr out of 370
normer.normO3  = 0.01;      %% frac/yr
normer.normN2O = 1.0/300;   %% ppb/yr out of 300
normer.normCH4 = 5/1860;    %% ppb/yr out of 1800
normer.normCFC = 1/1300;    %% ppt/yr out of 1300
normer.normST  = 0.1;       %% K/yr

normer.normCNG = 0.001; %% frac/yr = 0.1 g/m2 per year, avg = 100 g/m2
normer.normCSZ = 0.001; %% frac/yr = 0.1 um   per year, avg = 100 um
normer.normCPR = 0.001; %% mb/yr   = 1.0 mb   per year, avg = 500 mb

normer.normWV  = 0.01;  %% frac/yr
normer.normT   = 0.01;  %% K/yr
%}

%{
[head,prof] = read_glatm_adjust;
semilogy(prof.gas_51,prof.plevs); set(gca,'ydir','reverse');
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%iAIRSorCRIS = 2;

if iAIRSorCRIS == 1
  snorm = zeros(2834,5);
  iMaxLatbin = 40;
  i1231 = 1291;
  iFinalNumChan = 2645;
elseif iAIRSorCRIS == 2
  snorm = zeros(2235,5);
  iMaxLatbin = 38;
  iMaxLatbin = 39;
  iMaxLatbin = 40;
  i1231 = 731;
  iFinalNumChan = 2235;
end

snorm(:,1) = 2.2/370;   %% but remeber from 2002 -- 2018, CO2 changes from 370 to 400 ppm so this is strictly inaccurate
snorm(:,2) = 1.0/300;
snorm(:,3) = 5.0/1860;
snorm(:,4) = 1.0/1300;  %% REALLY??? WHY NOT 1/270 ppt/yr ??? https://www.esrl.noaa.gov/gmd/hats/combined/CFC11.html
snorm(:,5) = 1.0/1300;  %% REALLY??? WHY NOT 1/550 ppt/yr ??? https://www.esrl.noaa.gov/gmd/hats/combined/CFC12.html

if iAIRSorCRIS == 1
  disp('AIRS')
  if iTimeStep < 0
    disp('USUAL 40 latbins ....')
    outdir = ['JUNK/'];    %% usual 40 latbin rate jacss
  else
    disp('ANOMALY 365 timesteps x 40 latbins ....')
    outdir = ['Anomaly365_16/' num2str(iTimeStep,'%03d') '/'];   %% anomaly jacs, for each of 365 days
  end
elseif iAIRSorCRIS == 2
  disp('CrIS LoRes ')
  if iTimeStep < 0
    disp('USUAL 40 latbins ....')
    outdir = ['CLO_JUNK/'];    %% usual 40 latbin rate jacss
  else
    disp('ANOMALY 157 timesteps x 40 latbins ....')
    outdir = ['CLO_Anomaly137_16_12p8/' num2str(iTimeStep,'%03d') '/'];   %% anomaly jacs, for each of 365 days
  end
end

fprintf(1,'Looking for data in %s \n',outdir);
for ii = 1 : iMaxLatbin
  thename = [outdir '/jac_results_' num2str(ii) '.mat'];
  a = load(thename);
  fprintf(1,'loading in %s \n',thename)

  [mm,nn] = size(a.water);
  if nn < 95
    error('can handle 95 or 96 layers, not less!')
  end

  [numchan,numlay] = size(a.water);
  fprintf(1,'latbin ii = %3i : there are %4i channels and %3i layers in a.water \n',ii,numchan,numlay)
  if nn == 96
    fprintf(1,'oops : warning latbin %2i "a" has W/T/O3 jacs less than 97 layers .. setting bottommost ones to be 96th layer \n',ii)
    ax = a
    plot(a.tempr(i1231,:),1:nn,'o-'); grid; title('96 layer T jacobian at 1231 cm-1')
    junk(1:numchan,2:97) = a.water; junk(1:numchan,1) = junk(1:numchan,2); ax.water = junk;
    junk(1:numchan,2:97) = a.ozone; junk(1:numchan,1) = junk(1:numchan,2); ax.ozone = junk;
    junk(1:numchan,2:97) = a.tempr; junk(1:numchan,1) = junk(1:numchan,2); ax.tempr = junk;
    a = ax;
  end

  if nn == 95
    fprintf(1,'oops : warning latbin %2i "a" has W/T/O3 jacs less than 97 layers .. setting bottommost ones to be 95th layer \n',ii)
    ax = a
    plot(a.tempr(i1231,:),1:nn,'o-'); grid; title('95 layer T jacobian at 1231 cm-1')
    junk(1:numchan,3:97) = a.water; junk(1:numchan,1) = junk(1:numchan,3); junk(1:numchan,2) = junk(1:numchan,3); ax.water = junk;
    junk(1:numchan,3:97) = a.ozone; junk(1:numchan,1) = junk(1:numchan,3); junk(1:numchan,2) = junk(1:numchan,3); ax.ozone = junk;
    junk(1:numchan,3:97) = a.tempr; junk(1:numchan,1) = junk(1:numchan,3); junk(1:numchan,2) = junk(1:numchan,3); ax.tempr = junk;
    a = ax;
  end
  
  clear boo
  boo(:,1:5) = a.tracegas  .* snorm;
  boo(:,6) = a.stemp        * 0.1;
  boo(:,7:103)   = fliplr(a.water) * 0.01;
  boo(:,104:200) = fliplr(a.tempr) * 0.01;
  boo(:,201:297) = fliplr(a.ozone) * 0.01;

  if iAIRSorCRIS == 1
    lstrow = load('sarta_chans_for_l1c.mat');
    boo = boo(lstrow.ichan,:);
  end

  alljac(ii,:,:) = boo;
end

if iAIRSorCRIS == 1
  fKc = a.fKc(lstrow.ichan);
elseif iAIRSorCRIS == 2
  %{
  load /umbc/xfs2/strow/asl/s1/sergio/home/MATLABCODE/QUICKTASKS_TELECON/CriS_hires__avg_jacs/jacobians.mat
  save fcris2235 fcris
  %}
  load fcris2235.mat
  fKc = fcris;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% remember as of 8/26 this does NOT have CFC12 so have to offset some jacs
%sarta  = load('../MakeJacsSARTA/SARTA_AIRSL1c_Oct2018_CLR/sarta_origM_TS_jac_all_5_97_97_97.mat');
sarta = load('../MakeJacsSARTA/SARTA_AIRSL1c_Oct2018_CLR/sarta_fixCFC_M_TS_jac_all_5_97_97_97.mat');  

for ii = 1 : 4
  figure(1); plot(fKc,squeeze(alljac(20,:,ii)),'b.-',sarta.f,squeeze(sarta.M_TS_jac_all(20,:,ii)),'r');
  hl = legend('this CRIS','old sarta AIRS','location','best');
  if ii == 1
    title('CO2')
  elseif ii == 2
    title('N2O')
  elseif ii == 3
    title('CH4')
  elseif ii == 4
    title('CFC11')
  end
  %disp('ret'); pause
  pause(0.1);
end
for ii = 5 : 5
  figure(1); plot(fKc,squeeze(alljac(20,:,ii+1)),'b.-',sarta.f,squeeze(sarta.M_TS_jac_all(20,:,ii)),'r');
  hl = legend('this CRIS','old sarta AIRS','location','best');
  title('stemp')
  %disp('ret'); pause
  pause(0.1);
end

ii = 006:102; iiK=ii+1; plot(fKc,sum(squeeze(alljac(20,:,iiK))'),'b.-',sarta.f,sum(squeeze(sarta.M_TS_jac_all(20,:,ii))'),'r'); title('sum W'); pause(0.1)
  pause(0.1)
ii = 103:199; iiK=ii+1; plot(fKc,sum(squeeze(alljac(20,:,iiK))'),'b.-',sarta.f,sum(squeeze(sarta.M_TS_jac_all(20,:,ii))'),'r'); title('sum T'); pause(0.1)
  pause(0.1)
ii = 200:296; iiK=ii+1; plot(fKc,sum(squeeze(alljac(20,:,iiK))'),'b.-',sarta.f,sum(squeeze(sarta.M_TS_jac_all(20,:,ii))'),'r'); title('sum O'); pause(0.1)
  pause(0.1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
kcjac.f = fKc;
kcjac.M_TS_jac_all = alljac;
kcjac.qrenorm = sarta.qrenorm;
kcjac.str1 = sarta.str1;
kcjac.str2 = sarta.str2;

kcjac.str1 = {'CO2'  'N2O'  'CH4'  'CFC11'  'CFC12' 'ST'  'WV(97)'  'T(97)'  'O3(97)'};
kcjac.str2 = '[[2.2 1.0 5 1 1 0.1] [0.01*ones(1,97)] [0.01*ones(1,97)] [0.01*ones(1,97)]]';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% NEW in 8/26/2019 .. have to correctly normalize form eg 2.2/370 to 2.2/CO2(t) etc
if iAIRSorCRIS == 1
  [ht,~,pt,~] = rtpread(['AnomSym/timestep_' num2str(iTimeStep,'%03d') '_16day_avg.rp.rtp']);
  [ht,~,pt,~] = rtpread(['AnomSym_UsedforAIRS_AMTpaper2019/timestep_' num2str(iTimeStep,'%03d') '_16day_avg.rp.rtp']);
elseif iAIRSorCRIS == 2
  [ht,~,pt,~] = rtpread(['AnomSym/timestep_' num2str(iTimeStep,'%03d') '_16day_avg.rp.rtp']);
end

i500 = find(pt.plevs(1:97,1) > 500,1);
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(ht,pt,1:length(pt.stemp),2);   ppmv_CO2 = ppmvLAY(i500,:);
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(ht,pt,1:length(pt.stemp),4);   ppmv_N2O = ppmvLAY(i500,:);
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(ht,pt,1:length(pt.stemp),6);   ppmv_CH4 = ppmvLAY(i500,:);
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(ht,pt,1:length(pt.stemp),51);  ppmv_CFC11 = ppmvLAY(i500,:);
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(ht,pt,1:length(pt.stemp),52);  ppmv_CFC12 = ppmvLAY(i500,:);

if iAIRSorCRIS == 2
  ppmv_CO2 = ppmv_CO2(1:iMaxLatbin);
  ppmv_N2O = ppmv_N2O(1:iMaxLatbin);
  ppmv_CH4 = ppmv_CH4(1:iMaxLatbin);
  ppmv_CFC11 = ppmv_CFC11(1:iMaxLatbin);
  ppmv_CFC12 = ppmv_CFC12(1:iMaxLatbin);
end

iNewNorm = 0; %% stick to 2.2/370, 5/1860 etc not very smart quite nasty
iNewNorm = 1; %% adjustment for CO2(t) version 1, oops I think I made a mistake
iNewNorm = 2; %% YAY this is correct and best, except for CFC11,12 should it be 1300 --> 1.3e-4 or 1.3e-3???
iNewNorm = 3; %% YAY this is correct and best, except for CFC11/12, I think it should 1.3e-3???
if iNewNorm == 1 %% Aug 26
  ppmv_CO2   = ppmv_CO2' * ones(1,iFinalNumChan)/370;       %% we claim norm was for 2.2/370 but it really was for 2.2/ppmv_CO2(t) ==> fix by co2(t)/370
  ppmv_N2O   = ppmv_N2O' * ones(1,iFinalNumChan)/0.300;     %% we claim norm was for 1/300   but it really was for 1/ppmv_N2O(t)   ==> fix by n2o(t)/300
  ppmv_CH4   = ppmv_CH4' * ones(1,iFinalNumChan)/1.86;      %% we claim norm was for 5/1860  but it really was for 5/ppmv_CH4(t)   ==> fix by ch4(t)/1860
  ppmv_CFC11 = ppmv_CFC11' * ones(1,iFinalNumChan)/1.3e-4;  %% we claim norm was for 1/1300  but it really was for 1/ppmv_CFC11(t) ==> fix by cfc11(t)/1300
  ppmv_CFC12 = ppmv_CFC12' * ones(1,iFinalNumChan)/1.3e-4;  %% we claim norm was for 1/1300  but it really was for 1/ppmv_CFC12(t) ==> fix by cfc12(t)/1300
elseif iNewNorm == 2  %% Aug 27
  %% should CFC factor be 1300 --> 1.3e-4 or 1.3e-3???
  ppmv_CO2   = 370./ppmv_CO2' * ones(1,iFinalNumChan);       %% we claim norm was for 2.2/370 but it really was for 2.2/ppmv_CO2(t) ==> fix by 370/co2(t)
  ppmv_N2O   = 0.3./ppmv_N2O' * ones(1,iFinalNumChan);       %% we claim norm was for 1/300   but it really was for 1/ppmv_N2O(t)   ==> fix by 300/n2o(t)
  ppmv_CH4   = 1.86./ppmv_CH4' * ones(1,iFinalNumChan);      %% we claim norm was for 5/1860  but it really was for 5/ppmv_CH4(t)   ==> fix by 1860/ch4(t)
  ppmv_CFC11 = 1.3e-4./ppmv_CFC11' * ones(1,iFinalNumChan);  %% we claim norm was for 1/1300  but it really was for 1/ppmv_CFC11(t) ==> fix by 1300/cfc11(t)
  ppmv_CFC12 = 1.3e-4./ppmv_CFC12' * ones(1,iFinalNumChan);  %% we claim norm was for 1/1300  but it really was for 1/ppmv_CFC12(t) ==> fix by 1300/cfc12(t)
elseif iNewNorm == 3  %% Aug 29
  %% should CFC factor be 1300 --> 1.3e-4 or 1.3e-3???
  ppmv_CO2   = 370./ppmv_CO2' * ones(1,iFinalNumChan);       %% we claim norm was for 2.2/370 but it really was for 2.2/ppmv_CO2(t) ==> fix by 370/co2(t)
  ppmv_N2O   = 0.3./ppmv_N2O' * ones(1,iFinalNumChan);       %% we claim norm was for 1/300   but it really was for 1/ppmv_N2O(t)   ==> fix by 300/n2o(t)
  ppmv_CH4   = 1.86./ppmv_CH4' * ones(1,iFinalNumChan);      %% we claim norm was for 5/1860  but it really was for 5/ppmv_CH4(t)   ==> fix by 1860/ch4(t)
  ppmv_CFC11 = 1.3e-3./ppmv_CFC11' * ones(1,iFinalNumChan);  %% we claim norm was for 1/1300  but it really was for 1/ppmv_CFC11(t) ==> fix by 1300/cfc11(t)
  ppmv_CFC12 = 1.3e-3./ppmv_CFC12' * ones(1,iFinalNumChan);  %% we claim norm was for 1/1300  but it really was for 1/ppmv_CFC12(t) ==> fix by 1300/cfc12(t)
end
tracegas0 = alljac(:,:,1:5);
tracegas  = tracegas0;

tracegas(:,:,1) = tracegas(:,:,1) .* ppmv_CO2;
tracegas(:,:,2) = tracegas(:,:,2) .* ppmv_N2O;
tracegas(:,:,3) = tracegas(:,:,3) .* ppmv_CH4;
tracegas(:,:,4) = tracegas(:,:,4) .* ppmv_CFC11;
tracegas(:,:,5) = tracegas(:,:,5) .* ppmv_CFC12;

if iNewNorm == 0
  disp('ooops do nothing');
else
  alljac(:,:,1:5) = tracegas;
  qrenorm = zeros(1,297);
  qrenorm(1:4)   = sarta.qrenorm(1:4);
  qrenorm(5)     = sarta.qrenorm(4);
  qrenorm(6:297) = sarta.qrenorm(5:296);
  kcjac.qrenorm = qrenorm;
  kcjac.M_TS_jac_all = alljac;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%save('JUNK/kcarta_M_TS_jac_all_5_97_97_97_2645.mat','-struct','kcjac');
disp('Can now save the output : ');

if iAIRSorCRIS == 1
  if iTimeStep < 0
    savestr = ['save(''JUNK/kcarta_M_TS_jac_all_5_97_97_97_2645.mat'',''-struct'',''kcjac'');'];
    outjacname = ['JUNK/kcarta_M_TS_jac_all_5_97_97_97_2645.mat'];
  else
    savestr = ['save(''Anomaly365_16/RESULTS/kcarta_' num2str(iTimeStep,'%03d') '_M_TS_jac_all_5_97_97_97_2645.mat'',''-struct'',''kcjac'');'];
    outjacname = ['Anomaly365_16/RESULTS/kcarta_' num2str(iTimeStep,'%03d') '_M_TS_jac_all_5_97_97_97_2645.mat'];
  end
elseif iAIRSorCRIS == 2
  if iTimeStep < 0
    savestr = ['save(''CLO_JUNK/kcarta_M_TS_jac_all_5_97_97_97_2235.mat'',''-struct'',''kcjac'');'];
    outjacname = ['JUNK/kcarta_M_TS_jac_all_5_97_97_97_2235.mat'];
  else
    savestr = ['save(''CLO_Anomaly137_16_12p8/RESULTS/kcarta_' num2str(iTimeStep,'%03d') '_M_TS_jac_all_5_97_97_97_2235.mat'',''-struct'',''kcjac'');'];
    outjacname = ['CLO_Anomaly137_16_12p8/RESULTS/kcarta_' num2str(iTimeStep,'%03d') '_M_TS_jac_all_5_97_97_97_2235.mat'];
  end
end

fprintf(1,'%s \n',savestr)
