function [kcjac,savestr] = driver_put_together_kcarta_jacs(iTimeStep)

addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS
addpath /asl/matlib/h4tools

%{
so for usual latbins can do eg
  [kcjac,savestr] = driver_put_together_kcarta_jacs(-1);eval(savestr);
and for anomalies can do
 for iTimeStep = 1 : 365
   [kcjac,savestr] = driver_put_together_kcarta_jacs(iTimeStep);eval(savestr);
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

lstrow = load('sarta_chans_for_l1c.mat');

snorm = zeros(2834,5);
snorm(:,1) = 2.2/370;   %% but remeber from 2002 -- 2018, CO2 changes from 370 to 400 ppm so this is strictly inaccurate
snorm(:,2) = 1.0/300;
snorm(:,3) = 5.0/1860;
snorm(:,4) = 1.0/1300;  %% REALLY??? WHY NOT 1/270 ppt/yr ??? https://www.esrl.noaa.gov/gmd/hats/combined/CFC11.html
snorm(:,5) = 1.0/1300;  %% REALLY??? WHY NOT 1/550 ppt/yr ??? https://www.esrl.noaa.gov/gmd/hats/combined/CFC12.html

if iTimeStep < 0
  disp('USUAL 40 latbins ....')
  outdir = ['JUNK/'];    %% usual 40 latbin rate jacss
 else
  disp('ANOMALY 365 timesteps x 40 latbins ....')
  outdir = ['Anomaly365_16_12p8/' num2str(iTimeStep,'%03d') '/'];   %% anomaly jacs, for each of 365 days
end

fprintf(1,'Looking for data in %s \n',outdir);
for ii = 1 : 40
  thename = [outdir '/jac_results_' num2str(ii) '.mat'];
  a = load(thename);

  [mm,nn] = size(a.water);
  fprintf(1,'iTimestep latbin nn = %3i %3i %3i \n',iTimeStep,ii,nn)

  if nn < 85
    nn
    error('can handle >= 85 layers, not less!')
  end

  if nn == 96
    fprintf(1,'oops : warning latbin %2i "a" has W/T/O3 jacs less than 97 layers .. setting bottommost ones to be 96th layer \n',ii)
    ax = a
    plot(a.tempr(1291,:),1:nn,'o-'); grid; title('96 layer T jacobian at 1231 cm-1')
    junk(1:2834,2:97) = a.water; junk(1:2834,1) = junk(1:2834,2); ax.water = junk;
    junk(1:2834,2:97) = a.ozone; junk(1:2834,1) = junk(1:2834,2); ax.ozone = junk;
    junk(1:2834,2:97) = a.tempr; junk(1:2834,1) = junk(1:2834,2); ax.tempr = junk;
    a = ax;
  elseif nn == 95
    fprintf(1,'oops : warning latbin %2i "a" has W/T/O3 jacs less than 97 layers .. setting bottommost ones to be 95th layer \n',ii)
    ax = a
    plot(a.tempr(1291,:),1:nn,'o-'); grid; title('95 layer T jacobian at 1231 cm-1')
    junk(1:2834,3:97) = a.water; junk(1:2834,1) = junk(1:2834,3); junk(1:2834,2) = junk(1:2834,3); ax.water = junk;
    junk(1:2834,3:97) = a.ozone; junk(1:2834,1) = junk(1:2834,3); junk(1:2834,2) = junk(1:2834,3); ax.ozone = junk;
    junk(1:2834,3:97) = a.tempr; junk(1:2834,1) = junk(1:2834,3); junk(1:2834,2) = junk(1:2834,3); ax.tempr = junk;
    a = ax;
  elseif nn >= 85 & nn <= 94
    fprintf(1,'oops : warning latbin %2i "a" has W/T/O3 jacs only has %2i layers .. \n',ii,nn)
    ax = a
    nna = 97 - nn + 1; % if shifting jacs downwards, like we did above
    nna = nn + 1;  nneed = 97 - nn;    %if keeping them from 1 : nn
[nn nna nneed]
    plot(a.tempr(1291,:),1:nn,'o-'); grid; title([num2str(nn) ' layer T jacobian at 1231 cm-1'])
    junk(1:2834,1:nn) = a.water; junk(1:2834,nna:97) = junk(1:2834,nn) * ones(1,nneed); ax.water = junk;
    junk(1:2834,1:nn) = a.ozone; junk(1:2834,nna:97) = junk(1:2834,nn) * ones(1,nneed); ax.ozone = junk;
    junk(1:2834,1:nn) = a.tempr; junk(1:2834,nna:97) = junk(1:2834,nn) * ones(1,nneed); ax.tempr = junk;
    a = ax
  end

  clear boo
  boo(:,1:5) = a.tracegas  .* snorm;
  boo(:,6) = a.stemp        * 0.1;
  boo(:,7:103)   = fliplr(a.water) * 0.01;
  boo(:,104:200) = fliplr(a.tempr) * 0.01;
  boo(:,201:297) = fliplr(a.ozone) * 0.01;

  boo = boo(lstrow.ichan,:);
  
  alljac(ii,:,:) = boo;
end
fKc = a.fKc(lstrow.ichan);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% remember as of 8/26 thi does NOT have CFC12 so have to offset some jacs
%sarta  = load('../MakeJacsSARTA/SARTA_AIRSL1c_Oct2018_CLR/sarta_origM_TS_jac_all_5_97_97_97.mat');
sarta = load('../MakeJacsSARTA/SARTA_AIRSL1c_Oct2018_CLR/sarta_fixCFC_M_TS_jac_all_5_97_97_97.mat');  

for ii = 1 : 4
  figure(1); plot(fKc,squeeze(alljac(20,:,ii)),'b.',sarta.f,squeeze(sarta.M_TS_jac_all(20,:,ii)),'r');
  %disp('ret'); pause
  pause(0.1);
end
for ii = 5 : 5
  figure(1); plot(fKc,squeeze(alljac(20,:,ii+1)),'b.',sarta.f,squeeze(sarta.M_TS_jac_all(20,:,ii)),'r');
  %disp('ret'); pause
  pause(0.1);
end
ii = 006:102; iiK=ii+1; plot(fKc,sum(squeeze(alljac(20,:,iiK))'),'b.',sarta.f,sum(squeeze(sarta.M_TS_jac_all(20,:,ii))'),'r'); title('sum W')
ii = 103:199; iiK=ii+1; plot(fKc,sum(squeeze(alljac(20,:,iiK))'),'b.',sarta.f,sum(squeeze(sarta.M_TS_jac_all(20,:,ii))'),'r'); title('sum T')
ii = 200:296; iiK=ii+1; plot(fKc,sum(squeeze(alljac(20,:,iiK))'),'b.',sarta.f,sum(squeeze(sarta.M_TS_jac_all(20,:,ii))'),'r'); title('sum O')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
kcjac.f = fKc;
kcjac.M_TS_jac_all = alljac;
kcjac.qrenorm = sarta.qrenorm;
kcjac.str1 = sarta.str1;
kcjac.str2 = sarta.str2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% NEW in 8/26/2019 .. have to correctly normalize form eg 2.2/370 to 2.2/CO2(t) etc
[ht,~,pt,~] = rtpread(['AnomSymCld/timestep_' num2str(iTimeStep,'%03d') '_16day_avg.rp.rtp']);

i500 = find(pt.plevs(1:97,1) > 500,1);
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(ht,pt,1:length(pt.stemp),2);   ppmv_CO2 = ppmvLAY(i500,:);
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(ht,pt,1:length(pt.stemp),4);   ppmv_N2O = ppmvLAY(i500,:);
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(ht,pt,1:length(pt.stemp),6);   ppmv_CH4 = ppmvLAY(i500,:);
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(ht,pt,1:length(pt.stemp),51);  ppmv_CFC11 = ppmvLAY(i500,:);
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(ht,pt,1:length(pt.stemp),52);  ppmv_CFC12 = ppmvLAY(i500,:);

iNewNorm = 0; %% stick to 2.2/370, 5/1860 etc not very smart quite nasty
iNewNorm = 1; %% adjustment for CO2(t) version 1, oops I think I made a mistake
iNewNorm = 2; %% YAY this is correct and best
if iNewNorm == 1
  ppmv_CO2   = ppmv_CO2' * ones(1,2645)/370;       %% we claim norm was for 2.2/370 but it really was for 2.2/ppmv_CO2(t) ==> fix by co2(t)/370
  ppmv_N2O   = ppmv_N2O' * ones(1,2645)/0.300;     %% we claim norm was for 1/300   but it really was for 1/ppmv_N2O(t)   ==> fix by n2o(t)/300
  ppmv_CH4   = ppmv_CH4' * ones(1,2645)/1.86;      %% we claim norm was for 5/1860  but it really was for 5/ppmv_CH4(t)   ==> fix by ch4(t)/1860
  ppmv_CFC11 = ppmv_CFC11' * ones(1,2645)/1.3e-4;  %% we claim norm was for 1/1300  but it really was for 1/ppmv_CFC11(t) ==> fix by cfc11(t)/1300
  ppmv_CFC12 = ppmv_CFC12' * ones(1,2645)/1.3e-4;  %% we claim norm was for 1/1300  but it really was for 1/ppmv_CFC12(t) ==> fix by cfc12(t)/1300
elseif iNewNorm == 2
  ppmv_CO2   = 370./ppmv_CO2' * ones(1,2645);       %% we claim norm was for 2.2/370 but it really was for 2.2/ppmv_CO2(t) ==> fix by 370/co2(t)
  ppmv_N2O   = 0.3./ppmv_N2O' * ones(1,2645);       %% we claim norm was for 1/300   but it really was for 1/ppmv_N2O(t)   ==> fix by 300/n2o(t)
  ppmv_CH4   = 1.86./ppmv_CH4' * ones(1,2645);      %% we claim norm was for 5/1860  but it really was for 5/ppmv_CH4(t)   ==> fix by 1860/ch4(t)
  ppmv_CFC11 = 1.3e-4./ppmv_CFC11' * ones(1,2645);  %% we claim norm was for 1/1300  but it really was for 1/ppmv_CFC11(t) ==> fix by 1300/cfc11(t)
  ppmv_CFC12 = 1.3e-4./ppmv_CFC12' * ones(1,2645);  %% we claim norm was for 1/1300  but it really was for 1/ppmv_CFC12(t) ==> fix by 1300/cfc12(t)
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
%% now we have to add on 6 blanks for the cloud params
alljac0 = kcjac.M_TS_jac_all;
alljac  = zeros(40,2645,297+6);
qrenorm = zeros(1,297+6);

  qrenorm(1:6)        = kcjac.qrenorm(1:6);  %% CO2,N2O,CH4,CFC11,CFC12,stemp
  qrenorm(7:12)       = 1;
  qrenorm((7:297)+6) = kcjac.qrenorm(7:297);

  alljac(:,:,1:6)  = alljac0(:,:,1:6);
  alljac(:,:,7:12) = alljac(:,:,7:12)*0;
  alljac(:,:,(7:297)+6) = alljac0(:,:,(7:297));

kcjac.qrenorm = qrenorm;
kcjac.M_TS_jac_all = alljac;

kcjac.str1 = {'CO2'  'N2O'  'CH4'  'CFC11'  'CFC12' 'ST'  'cng1' 'cng2' 'csz1' 'csz2' 'cpr1' 'cpr2' 'WV(97)'  'T(97)'  'O3(97)'};
kcjac.str2 = '[[2.2 1.0 5 1 1 0.1] [0.001*ones(1,6)] [0.01*ones(1,97)] [0.01*ones(1,97)] [0.01*ones(1,97)]]';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%save('JUNK/kcarta_M_TS_jac_all_5_97_97_97_2645.mat','-struct','kcjac');
disp('Can now save the output : ');
if iTimeStep < 0
  savestr = ['save(''JUNK/kcarta_M_TS_jac_all_5_6_97_97_97_2645.mat'',''-struct'',''kcjac'');'];
else
  savestr = ['save(''Anomaly365_16_12p8/RESULTS/kcarta_' num2str(iTimeStep,'%03d') '_M_TS_jac_all_5_6_97_97_97_2645.mat'',''-struct'',''kcjac'');'];
end
fprintf(1,'%s \n',savestr)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
for iTimeStep = 1 : 365
  fname = ['Anomaly365_16_12p8/RESULTS/kcarta_' num2str(iTimeStep,'%03d') '_M_TS_jac_all_5_6_97_97_97_2645.mat'];
  if exist(fname)
    iaFound(iTimeStep) = +1;
  else
    iaFound(iTimeStep) = 0;
  end
end
%% timestep 169 bins 28 onwards not found
%}
