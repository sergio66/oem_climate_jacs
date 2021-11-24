addpath /asl/matlib/h4tools
addpath /asl/matlib/aslutil
addpath //home/sergio/MATLABCODE/CONVERT_GAS_UNITS

iEnd = 136; %% 6 year
iEnd = 157; %% 7 year

lstrow = load('fcris2235.mat');
lstrow.ichan = 1 : 2235;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
use_this_rtp370 = ['AnomSym/timestep_' num2str(1,'%03d') '_16day_avg.rp.rtp'];
[h,ha,p370,pa] = rtpread(use_this_rtp370);
[yy,mm,dd,hh] = tai2utcSergio(mean(p370.rtime));
co2est = 370 + 2.2*(yy+(mm-1)/12-2002);
fprintf(1,'Start time for CRIS use_this_rtp370 = %s is %4i/%2i/%2i co2 estimate = %8.4f ppmv\n',use_this_rtp370,yy,mm,dd,co2est)

%[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(hIN,pIN,index,gid)
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p370,1:length(p370.stemp),2);
i500 = find(pavgLAY(:,21) >= 500,1);

[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p370,1:length(p370.stemp),2);  ppmv_CO2_start = ppmvLAY(i500,:);
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p370,1:length(p370.stemp),4);  ppmv_N2O_start = ppmvLAY(i500,:);
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p370,1:length(p370.stemp),6);  ppmv_CH4_start = ppmvLAY(i500,:);
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p370,1:length(p370.stemp),51); ppmv_CFC11_start = ppmvLAY(i500,:);
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p370,1:length(p370.stemp),52); ppmv_CFC12_start = ppmvLAY(i500,:);

ppmv_CO2_start = ppmv_CO2_start(1:iMaxLatbin);
ppmv_N2O_start = ppmv_N2O_start(1:iMaxLatbin);
ppmv_CH4_start = ppmv_CH4_start(1:iMaxLatbin);
ppmv_CFC11_start = ppmv_CFC11_start(1:iMaxLatbin);
ppmv_CFC12_start = ppmv_CFC12_start(1:iMaxLatbin);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
use_this_rtp = ['AnomSym/timestep_' num2str(iEnd,'%03d') '_16day_avg.rp.rtp'];
[h,ha,p,pa] = rtpread(use_this_rtp);
[yy,mm,dd,hh] = tai2utcSergio(mean(p.rtime));
co2est = 370 + 2.2*(yy+(mm-1)/12-2002);
fprintf(1,'Stop time for CRIS use_this_rtp (timestep %3i) = %s is %4i/%2i/%2i co2 estimate = %8.4f ppmv\n',use_this_rtp,iEnd,yy,mm,dd,co2est)

[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p,1:length(p.stemp),2);  ppmv_CO2_stop = ppmvLAY(i500,:);
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p,1:length(p.stemp),4);  ppmv_N2O_stop = ppmvLAY(i500,:);
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p,1:length(p.stemp),6);  ppmv_CH4_stop = ppmvLAY(i500,:);
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p,1:length(p.stemp),51); ppmv_CFC11_stop = ppmvLAY(i500,:);
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p,1:length(p.stemp),52); ppmv_CFC12_stop = ppmvLAY(i500,:);

ppmv_CO2_stop = ppmv_CO2_stop(1:iMaxLatbin);
ppmv_N2O_stop = ppmv_N2O_stop(1:iMaxLatbin);
ppmv_CH4_stop = ppmv_CH4_stop(1:iMaxLatbin);
ppmv_CFC11_stop = ppmv_CFC11_stop(1:iMaxLatbin);
ppmv_CFC12_stop = ppmv_CFC12_stop(1:iMaxLatbin);

figure(1); plot(1:length(ppmv_CO2_start),ppmv_CO2_start,'bx-',1:length(ppmv_CO2_start),ppmv_CO2_stop,'ro-'); hl = legend('CO2 CRIS start','CO2 CRIS end','location','best');
figure(2); plot(1:length(ppmv_CO2_start),ppmv_N2O_start,'bx-',1:length(ppmv_CO2_start),ppmv_N2O_stop,'ro-'); hl = legend('N2O CRIS start','N2O CRIS end','location','best');
figure(3); plot(1:length(ppmv_CO2_start),ppmv_CH4_start,'bx-',1:length(ppmv_CO2_start),ppmv_CH4_stop,'ro-'); hl = legend('CH4 CRIS start','CH4 CRIS end','location','best');
figure(4); plot(1:length(ppmv_CO2_start),ppmv_CFC11_start,'bx-',1:length(ppmv_CO2_start),ppmv_CFC11_stop,'ro-'); hl = legend('C11 CRIS start','C11 CRIS end','location','best');
figure(5); plot(1:length(ppmv_CO2_start),ppmv_CFC12_start,'bx-',1:length(ppmv_CO2_start),ppmv_CFC12_stop,'ro-'); hl = legend('C12 CRIS start','C12 CRIS end','location','best');
disp('ret to continue'); pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% iVers = 1; %% this was done ZZZ June 30/July 1, but using bad(?) CO2/CH4/N2o profiles ... 
% iVers = 2; %% this was done AAA July 2, using much better(?) CO2/CH4/N2o profiles ... 
% iVers = 3; %% this was done XXX July 11, using much better(?) CO2/CH4/N2o profiles ... trying to figure out what is wrong with v2
% iVers = 3; %% this was done XXX Aug 20, using much better(?) CO2/CH4/N2o/CFC11/CFC12 ... but bizarre results
iVers = 4; %% this was done Jan 12, 2020, using much better(?) CO2/CH4/N2o/CFC11/CFC12 ... 
% iVers = 5; %% this was done Dec 05, using much better(?) CO2/CH4/N2o/CFC11/CFC12 ... and has age of air effects, only done for AIRS

if iVers == 1
  %% this was done June 30/July 1, but using bad(?) CO2/CH4/N2o/CFC11 profiles ... 
  outdirResults = 'CLO_Anomaly137_16_12p8/RESULTS_FiniteDiff/';
  outdirResults = 'CLO_Anomaly137_16_12p8/RESULTS_FiniteDiff_Try1/';
elseif iVers == 2
  %% this was done July 2, using much better(?) CO2/CH4/N2o/CFC11 profiles ... 
  outdirResults = 'CLO_Anomaly137_16_12p8/RESULTS_FiniteDiff_Try2/';
elseif iVers == 3
  %% this was done July 11, using much better(?) CO2/CH4/N2o/CFC11 profiles ... trying to figure out what is wrong with v2
  outdirResults = 'CLO_Anomaly137_16_12p8_tillAug25_2019/RESULTS_FiniteDiff_Try3_noCFC12/';
  %% this was done Aug 20, using much better(?) CO2/CH4/N2o/CFC11/CFC12 profiles ... but seems to have problems
  outdirResults = 'CLO_Anomaly137_16_12p8_tillAug25_2019/RESULTS_FiniteDiff_Try3/';  %% also seeAnomaly365_16_12p8/RESULTS_FiniteDiff_Try3/OldV5
elseif iVers == 4
  %% this was done Aug 28, using much better(?) CO2/CH4/N2o/CFC11/CFC12 profiles ... works quite well
  outdirResults = 'CLO_Anomaly137_16_12p8/RESULTS_FiniteDiff_Try3/';
elseif iVers == 5
  %% this was done Dec 05, using much better(?) CO2/CH4/N2o/CFC11/CFC12 profiles ... and has age of air effects for CO2
  outdirResults = 'CLO_Anomaly137_16_12p8/RESULTS_FiniteDiff_Try4/';
end

if ~exist(outdirResults)
  fprintf(1,'oops have to make %s \n',outdirResults)
  mker = ['!mkdir ' outdirResults];
  eval(mker)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% timestep 1 is a special case, just use "original" derivative
if iVers == 1
  outfile = [outdirResults '/kcarta_001_tracegas_finitediff_4_2235.mat'];
  outfile = [outdirResults '/kcarta_001_tracegas_finitediff_4_2235.mat'];
elseif iVers == 2
  outfile = [outdirResults '/kcarta_001_tracegas_finitediff_4_2235_V2.mat'];
elseif iVers == 3
  outfile = [outdirResults '/kcarta_001_tracegas_finitediff_4_2235_V3.mat'];  %% careful there is a subdir there with 4 tracegases
  outfile = [outdirResults '/kcarta_001_tracegas_finitediff_5_2235_V3.mat'];  %% careful there is a subdir there 
elseif iVers == 4
  outfile = [outdirResults '/kcarta_001_tracegas_finitediff_5_2235_V4.mat']; %% best but no age of air delta
elseif iVers == 5
  outfile = [outdirResults '/kcarta_001_tracegas_finitediff_5_2235_V5.mat']; %% has CO2 age of air 5 ppm delta to strat .....
end

fprintf(1,'doing 001 %s \n',outfile)
a = load('CLO_Anomaly137_16_12p8/RESULTS/kcarta_001_M_TS_jac_all_5_97_97_97_2235.mat');
tracegas = squeeze(a.M_TS_jac_all(1:38,:,1:4)); %%% <<< really, should be doing 1:5 and not worrying about adding on things anymore
tracegas = squeeze(a.M_TS_jac_all(1:38,:,1:5)); %%% <<< really, should be doing 1:5 and not worrying about adding on things anymore
comment = ['see put_together_results_coljacV3_cris.m and clust_do_kcarta_driver_anomaly_loop40_strowV3.m'];
  
f = a.f;

  %% ooer, need to load CFC12
  use_this_rtp = ['AnomSym/timestep_' num2str(1,'%03d') '_16day_avg.rp.rtp'];
  use_this_rtp = ['AnomSym/timestep_' num2str(2,'%03d') '_16day_avg.rp.rtp'];
    [h,ha,p,pa] = rtpread(use_this_rtp);
  
    [ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p,1:length(p.stemp),2);  ppmv_CO2 = ppmvLAY(i500,:);
    [ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p,1:length(p.stemp),4);  ppmv_N2O = ppmvLAY(i500,:);
    [ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p,1:length(p.stemp),6);  ppmv_CH4 = ppmvLAY(i500,:);
    [ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p,1:length(p.stemp),51); ppmv_CFC11 = ppmvLAY(i500,:);
    [ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p,1:length(p.stemp),52); ppmv_CFC12 = ppmvLAY(i500,:);
  
    ppmv_CO2 = ppmv_CO2(1:iMaxLatbin);
    ppmv_N2O = ppmv_N2O(1:iMaxLatbin);
    ppmv_CH4 = ppmv_CH4(1:iMaxLatbin);
    ppmv_CFC11 = ppmv_CFC11(1:iMaxLatbin);
    ppmv_CFC12 = ppmv_CFC12(1:iMaxLatbin);

    deltaJunkCFC12 = ppmv_CFC12-ppmv_CFC12_start;
   
  clear jacCFC*
  for ii = 1 : length(ppmv_CO2_start)
    f40 = ['CLO_Anomaly137_16_12p8/001/strowfinitejac_convolved_kcarta_cris_' num2str(ii) '_jac3.mat'];
    if iVers == 3
      f40 = ['CLO_Anomaly137_16_12p8/002/strowfinitejac_convolved_kcarta_cris_' num2str(ii) '_jac3.mat'];
    elseif iVers == 4
      f40 = ['CLO_Anomaly137_16_12p8/002/strowfinitejac_convolved_kcarta_cris_' num2str(ii) '_jac4.mat'];
    elseif iVers == 5
      f40 = ['CLO_Anomaly137_16_12p8/002/strowfinitejac_convolved_kcarta_cris_' num2str(ii) '_jac5.mat'];
    end
  
    load(f40);
    tKc = rad2bt(fKc,rKc);; 
    %plot(fKc,tKc(:,1)*ones(1,4)-tKc(:,2:5));
  
    %jac = tKc(:,1)*ones(1,4)-tKc(:,2:5);  %%dBT = BT(X(t),geo(t),other_trace_gases(t))-BT(X(0),geo(t),other_trace_gases(t))
    jac = tKc(:,1)*ones(1,5)-tKc(:,2:6);  %%dBT = BT(X(t),geo(t),other_trace_gases(t))-BT(X(0),geo(t),other_trace_gases(t))
  
    jacCFC11(:,ii) = jac(:,4)/(0.001*ppmv_CFC11(ii));  %% remember kcarta does 0.001 perturbation
    jacCFC12(:,ii) = jac(:,5)/(0.001*ppmv_CFC12(ii));  %% remember kcarta does 0.001 perturbation
  end
    
  jacCFC11 = jacCFC11(lstrow.ichan,:)'*1e-6; 
  jacCFC12 = jacCFC12(lstrow.ichan,:)'*1e-6; 
  
  plot(1:2235,squeeze(tracegas(20,:,4)),'b.-',1:2235,jacCFC11(20,:),'r')
  plot(1:2235,jacCFC12(20,:),'b.-',1:2235,jacCFC11(20,:),'r')
  
  qrenorm = a.qrenorm(1:4);
  str1 = '{''CO2''  ''N2O''  ''CH4''  ''CFC11''}';
  str2 = '[2.2 1.0 5 1]';
  if ~exist(outfile)
    saver = ['save ' outfile ' tracegas f qrenorm str1 str2 comment'];
  else
    fprintf(1,'%s already exists ... skipping \n',outfile)
  end

  %{  
  qrenorm = [a.qrenorm(1:4) a.qrenorm(4)];
  xtracegas = cat(3,tracegas,jacCFC12);
  sum(sum(sum(tracegas-xtracegas(:,:,1:4))))
  sum(sum(sum(abs(tracegas-xtracegas(:,:,1:4)))))
  tracegas = xtracegas;
  %}
  qrenorm = [a.qrenorm(1:5)];
  xtracegas = tracegas;
  str1 = '{''CO2''  ''N2O''  ''CH4''  ''CFC11'' ''CFC12''}';
  str2 = '[2.2 1.0 5 1 1]';

if ~exist(outfile)    
  saver = ['save ' outfile ' tracegas f qrenorm str1 str2 comment'];
  fprintf(1,'saver for 001 = %s \n',saver)
  eval(saver)
else
  fprintf(1,'%s already exists ... skipping \n',outfile)
end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

outdir     = ['CLO_Anomaly137_16_12p8/'];
iCnt = 0;

iaDoTimeSteps = [50 70];
iaDoTimeSteps = 001:137;
iaDoTimeSteps = 137:157;

for iii = 1 : length(iaDoTimeSteps)
  iTimeStep = iaDoTimeSteps(iii);

  if iVers == 1
    outfile = [outdirResults '/kcarta_' num2str(iTimeStep,'%03d') '_tracegas_finitediff_4_2235.mat']; %% only CFC11
  elseif iVers == 2
    outfile = [outdirResults '/kcarta_' num2str(iTimeStep,'%03d') '_tracegas_finitediff_4_2235_V2.mat']; %% only CFC11
  elseif iVers == 3
    outfile = [outdirResults '/kcarta_' num2str(iTimeStep,'%03d') '_tracegas_finitediff_4_2235_V3.mat']; %% only CFC11
    outfile = [outdirResults '/kcarta_' num2str(iTimeStep,'%03d') '_tracegas_finitediff_5_2235_V3.mat']; %% also has CFC12
  elseif iVers == 4
    outfile = [outdirResults '/kcarta_' num2str(iTimeStep,'%03d') '_tracegas_finitediff_5_2235_V4.mat']; %% also has CFC12
  elseif iVers == 5
    outfile = [outdirResults '/kcarta_' num2str(iTimeStep,'%03d') '_tracegas_finitediff_5_2235_V5.mat']; %% also has CFC12 and CO2 age of air
  else
    iVers
    error('iVers = 1--5 ... so huh?')
  end

  if ~exist(outfile)
    fprintf(1,'>>>>>> TimeStep %3i of 365 \n',iTimeStep);
    if iVers == 1
       %%% use_this_rtp = ['AnomSym/June04_2019/timestep_' num2str(iTimeStep,'%03d') '_16day_avg.rp.rtp'];
    elseif iVers == 2 | iVers == 3 | iVers == 4 | iVers == 5
       use_this_rtp = ['AnomSym/timestep_' num2str(iTimeStep,'%03d') '_16day_avg.rp.rtp'];
    else
      error('huh?')
    end
  
    [h,ha,p,pa] = rtpread(use_this_rtp);
  
    [ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p,1:length(p.stemp),2);  ppmv_CO2 = ppmvLAY(i500,:);
    [ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p,1:length(p.stemp),4);  ppmv_N2O = ppmvLAY(i500,:);
    [ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p,1:length(p.stemp),6);  ppmv_CH4 = ppmvLAY(i500,:);
    [ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p,1:length(p.stemp),51); ppmv_CFC11 = ppmvLAY(i500,:);
    [ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p,1:length(p.stemp),52); ppmv_CFC12 = ppmvLAY(i500,:);
  
    ppmv_CO2 = ppmv_CO2(1:iMaxLatbin);
    ppmv_N2O = ppmv_N2O(1:iMaxLatbin);
    ppmv_CH4 = ppmv_CH4(1:iMaxLatbin);
    ppmv_CFC11 = ppmv_CFC11(1:iMaxLatbin);
    ppmv_CFC12 = ppmv_CFC12(1:iMaxLatbin);

    ax = load(['CLO_Anomaly137_16_12p8/RESULTS/kcarta_' num2str(iTimeStep,'%03d') '_M_TS_jac_all_5_97_97_97_2235.mat']);
    tracegasx = squeeze(ax.M_TS_jac_all(:,:,1:5));
  
    deltaCO2 = ppmv_CO2 - ppmv_CO2_start;
    deltaN2O = ppmv_N2O - ppmv_N2O_start;
    deltaCH4 = ppmv_CH4 - ppmv_CH4_start;
    deltaCFC11 = ppmv_CFC11 - ppmv_CFC11_start;
    deltaCFC12 = ppmv_CFC12 - ppmv_CFC12_start;
  
    figure(10); 
      subplot(221); plot(deltaCO2); title(num2str(iTimeStep));
      subplot(222); plot(deltaN2O); 
      subplot(223); plot(deltaCH4); 
      subplot(224); plot(1:length(deltaCFC11),deltaCFC11,1:length(deltaCFC12),deltaCFC12); 
  
  %{
    %% this is better way
    deltaCO2 = [370*dQkc 5 10 15 20 25 30 35 40 45]; %% delta ppm
    iaDelta = ones(length(qcx),1) * 2.2./(deltaCO2);
    qcx = qc .* iaDelta;
  
    %% this is better way
    deltaN2O = [315*dQkc 5 10 15 20 25]; %% delta ppmay
    iaDelta = ones(length(qcx),1) * 1.0./(deltaN2O);
    qcx = qc .* iaDelta;
  
    %% this is better way
    deltaCH4 = 0 : 25 : 300; detlaCH4(1) = 1700*dQkc;
    iaDelta = ones(length(qcx),1) * 5.0./(deltaCH4);
    qcx = qc .* iaDelta;
  %}
   
    %{
    [head,prof] = read_glatm_adjust;
  >> semilogy(prof.gas_2,prof.plevs,'o-'); set(gca,'ydir','reverse');
  >> semilogy(prof.gas_4,prof.plevs,'o-'); set(gca,'ydir','reverse');
  >> semilogy(prof.gas_6,prof.plevs,'o-'); set(gca,'ydir','reverse');
  >> semilogy(prof.gas_51,prof.plevs,'o-'); set(gca,'ydir','reverse');
  >> semilogy(prof.gas_52,prof.plevs,'o-'); set(gca,'ydir','reverse');
    %}

    tracegas = [];
    for iLatbin = 1 : length(ppmv_CO2_start)
      %delta   = ones(2235,1) * [deltaCO2(iLatbin) deltaN2O(iLatbin) deltaCH4(iLatbin) deltaCFC11(iLatbin)];  %% this is delta at time t = whatever
      %scaling = ones(2235,1) * [2.2 1.0*1e-3 5.0*1e-3 1.0*1e-6];
      delta   = ones(2235,1) * [deltaCO2(iLatbin) deltaN2O(iLatbin) deltaCH4(iLatbin) deltaCFC11(iLatbin) deltaCFC12(iLatbin)];  %% this is delta at time t = whatever
      scaling = ones(2235,1) * [2.2 1.0*1e-3 5.0*1e-3 1.0*1e-6 1.0*1e-6];   
      %% in 2002, 2.2ppm/370  1e-3/0.3=1/300 5e-3/1.86=5/1860 1e-6/2.4e-4=1/240  1e-6/5.4e-4=1/540
      %% in 2018, 2.2ppm/400  1e-3/0.3=1/320 5e-3/1.86=5/2000 1e-6/2.2e-4=1/220  1e-6/5.2e-4=1/520
  
      if iVers == 1
        fout = [outdir '/' num2str(iTimeStep,'%03d') '/strowfinitejac_convolved_kcarta_cris_' num2str(iLatbin) '_jac.mat'];  
      elseif iVers == 2
        fout = [outdir '/' num2str(iTimeStep,'%03d') '/strowfinitejac_convolved_kcarta_cris_' num2str(iLatbin) '_jac2.mat'];  
      elseif iVers == 3
        fout = [outdir '/' num2str(iTimeStep,'%03d') '/strowfinitejac_convolved_kcarta_cris_' num2str(iLatbin) '_jac3.mat'];  
      elseif iVers == 4
        fout = [outdir '/' num2str(iTimeStep,'%03d') '/strowfinitejac_convolved_kcarta_cris_' num2str(iLatbin) '_jac4.mat'];  
      elseif iVers == 5
        fout = [outdir '/' num2str(iTimeStep,'%03d') '/strowfinitejac_convolved_kcarta_cris_' num2str(iLatbin) '_jac5.mat'];  
      else
        error('huh2')
      end
      if exist(fout)
        clear fKc rKc
        loader = ['load ' fout];
        eval(loader);
        tKc = rad2bt(fKc,rKc);; 
        %plot(fKc,tKc(:,1)*ones(1,4)-tKc(:,2:5));
  
        %jac = tKc(:,1)*ones(1,4)-tKc(:,2:5);  %%dBT = BT(X(t),geo(t),other_trace_gases(t))-BT(X(0),geo(t),other_trace_gases(t))
        jac = tKc(:,1)*ones(1,5)-tKc(:,2:6);  %%dBT = BT(X(t),geo(t),other_trace_gases(t))-BT(X(0),geo(t),other_trace_gases(t))
  
        tracegas(iLatbin,:,:) = jac(lstrow.ichan,:) .* scaling ./delta;
      else
        fprintf(1,'%s DNE \n',fout);
        error('jacobian file DNE so cannot put things together ')
      end  %% if file exist
    end    %% latbin
  
    figure(1); plot(f,squeeze(tracegasx(:,:,1)),'b.-',f,squeeze(tracegas(:,:,1)),'r'); grid
    figure(2); plot(f,squeeze(tracegasx(:,:,2)),'b.-',f,squeeze(tracegas(:,:,2)),'r'); grid
    figure(3); plot(f,squeeze(tracegasx(:,:,3)),'b.-',f,squeeze(tracegas(:,:,3)),'r'); grid
    figure(4); plot(f,squeeze(tracegasx(:,:,4)),'b.-',f,squeeze(tracegas(:,:,4)),'r'); grid
  
    [mmm,nnn,ooo] = size(tracegas);
    mmm = 38;
    boo = find(f >= 0791.7,1); figure(5); plot(1:mmm,squeeze(tracegasx(1:mmm,boo,1)),'b.-',1:mmm,squeeze(tracegas(1:mmm,boo,1)),'rx-'); title('CO2 0791 cm-1'); grid
      hl = legend('sergio kcarta dQ=0.001','strow dQ=Q(t)-Q(0)','location','best'); set(hl,'fontsize',10);
    boo = find(f >= 1278.4,1); figure(6); plot(1:mmm,squeeze(tracegasx(1:mmm,boo,2)),'b.-',1:mmm,squeeze(tracegas(1:mmm,boo,2)),'rx-'); title('N2O 1278 cm-1'); grid
      hl = legend('sergio kcarta dQ=0.001','strow dQ=Q(t)-Q(0)','location','best'); set(hl,'fontsize',10);
    boo = find(f >= 1303.7,1); figure(7); plot(1:mmm,squeeze(tracegasx(1:mmm,boo,3)),'b.-',1:mmm,squeeze(tracegas(1:mmm,boo,3)),'rx-'); title('CH4 1303 cm-1'); grid
      hl = legend('sergio kcarta dQ=0.001','strow dQ=Q(t)-Q(0)','location','best'); set(hl,'fontsize',10);
    boo = find(f >= 0847.0,1); figure(8); plot(1:mmm,squeeze(tracegasx(1:mmm,boo,4)),'b.-',1:mmm,squeeze(tracegas(1:mmm,boo,4)),'rx-'); title('CFC11 0847 cm-1'); grid
      hl = legend('sergio kcarta dQ=0.001','strow dQ=Q(t)-Q(0)','location','best'); set(hl,'fontsize',10);  
   boo = find(f >= 0930.0,1); figure(9); plot(1:mmm,squeeze(tracegasx(1:mmm,boo,5)),'b.-',1:mmm,squeeze(tracegas(1:mmm,boo,5)),'rx-'); title('CFC12 0930 cm-1'); grid
     hl = legend('sergio kcarta dQ=0.001','strow dQ=Q(t)-Q(0)','location','best'); set(hl,'fontsize',10);
   %boo = find(f >= 0930.0,1); figure(9); plot(1:mmm,squeeze(tracegas(1:mmm,boo,5)),'b.-',1:mmm,squeeze(tracegas(1:mmm,boo,5)),'rx-'); title('CFC12 0930 cm-1'); grid
   %   hl = legend('err sergio kcarta dQ=0.001','strow dQ=Q(t)-Q(0)','location','best'); set(hl,'fontsize',10);
    if mmm < length(ppmv_CO2_start)
      fprintf(1,'oops only have done %3i of %3i jacs for timestep %3i \n',mmm,iTimeStep,length(ppmv_CO2_start));
      error('HALT HERE')  
    end
  
    pause(0.1)
    %disp('ret to continue'); pause
    
    saver = ['save ' outfile ' tracegas f qrenorm str1 str2 comment'];
  
    fprintf(1,'saver for iTimeStep %3i  = %s \n',iTimeStep,saver)
    if ~exist(outfile)
      eval(saver)
    else
      fprintf(1,'%s already exists ... skipping \n',outfile)
    end

    pause(0.1)
  else
    fprintf(1,'timestep %3i : %s already exists \n',iTimeStep,outfile);
  end

end      %% timestep
