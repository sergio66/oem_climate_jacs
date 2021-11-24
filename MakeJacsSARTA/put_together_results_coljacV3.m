addpath /asl/matlib/h4tools
addpath /asl/matlib/aslutil
addpath //home/sergio/MATLABCODE/CONVERT_GAS_UNITS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
use_this_rtp370 = ['AnomSym_no_seasonal/timestep_' num2str(1,'%03d') '_16day_avg.rp.rtp'];
[h,ha,p370,pa] = rtpread(use_this_rtp370);

%[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(hIN,pIN,index,gid)
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p370,1:length(p370.stemp),2);
i500 = find(pavgLAY(:,21) >= 500,1);

[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p370,1:length(p370.stemp),2);  ppmv_CO2_start = ppmvLAY(i500,:);
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p370,1:length(p370.stemp),4);  ppmv_N2O_start = ppmvLAY(i500,:);
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p370,1:length(p370.stemp),6);  ppmv_CH4_start = ppmvLAY(i500,:);
%[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p370,1:length(p370.stemp),51); ppmv_CFC_start = ppmvLAY(i500,:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
use_this_rtp = ['AnomSym_no_seasonal/timestep_' num2str(365,'%03d') '_16day_avg.rp.rtp'];
[h,ha,p,pa] = rtpread(use_this_rtp);

[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p,1:length(p.stemp),2);  ppmv_CO2_stop = ppmvLAY(i500,:);
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p,1:length(p.stemp),4);  ppmv_N2O_stop = ppmvLAY(i500,:);
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p,1:length(p.stemp),6);  ppmv_CH4_stop = ppmvLAY(i500,:);
%[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p,1:length(p.stemp),51); ppmv_CFC_stop = ppmvLAY(i500,:);

figure(1); plot(1:40,ppmv_CO2_start,'bx-',1:40,ppmv_CO2_stop,'ro-')
figure(2); plot(1:40,ppmv_N2O_start,'bx-',1:40,ppmv_N2O_stop,'ro-')
figure(3); plot(1:40,ppmv_CH4_start,'bx-',1:40,ppmv_CH4_stop,'ro-')
%figure(4); plot(1:40,ppmv_CFC_start,'bx-',1:40,ppmv_CFC_stop,'ro-')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% iVers = 1; %% this was done June 30/July 1, but using bad(?) CO2/CH4/N2o profiles ... DNE
% iVers = 2; %% this was done July 2, using much better(?) CO2/CH4/N2o profiles ... DNE
iVers = 3; %% this was done Aug 2, using much better(?) CO2/CH4/N2o profiles ... 

outdir     = ['SARTA_AIRSL1c_Anomaly365_16/'];
if iVers == 1
  %% this was done June 30/July 1, but using bad(?) CO2/CH4/N2o profiles ... 
  outdirResults = 'Anomaly365_16_12p8/RESULTS_FiniteDiff/';
  outdirResults = 'Anomaly365_16_12p8/RESULTS_FiniteDiff_Try1/';
elseif iVers == 2
  %% this was done July 2, using much better(?) CO2/CH4/N2o profiles ... 
  outdirResults = 'Anomaly365_16_12p8/RESULTS_FiniteDiff_Try2/';
elseif iVers == 3
  %% this was done July 11, using much better(?) CO2/CH4/N2o profiles ... trying to figure out what is wrong with v2
  outdirResults = [outdir '/RESULTS_FiniteDiff_Try3/'];
end

if ~exist(outdirResults)
  fprintf(1,'oops have to make %s \n',outdirResults)
  mker = ['!mkdir ' outdirResults];
  eval(mker)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% timestep 1 is a special case, just use "original" derivative
a = load('../MakeJacskCARTA_CLR/Anomaly365_16/RESULTS/kcarta_001_M_TS_jac_all_5_97_97_97_2645.mat');
tracegas = squeeze(a.M_TS_jac_all(:,:,1:4));
comment = ['see put_together_results_coljacV3.m and clust_do_kcarta_driver_anomaly_loop40_strowV3.m'];
if iVers == 1
  outfile = [outdirResults '/sarta_001_tracegas_finitediff_3gas_2645.mat'];
elseif iVers == 2
  outfile = [outdirResults '/sarta_001_tracegas_finitediff_3gas_2645_V2.mat'];
elseif iVers == 3
  outfile = [outdirResults '/sarta_001_tracegas_finitediff_3gas_2645_V3.mat'];
end
f = a.f;
qrenorm = a.qrenorm(1:3);
str1 = '{''CO2''  ''N2O''  ''CH4''}';
str2 = '[2.2 1.0 5]';
saver = ['save ' outfile ' tracegas f qrenorm str1 str2 comment'];
eval(saver)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lstrow = load('sarta_chans_for_l1c.mat');

iCnt = 0;

%junkS = input('Enter timestep (2:365) : ');
iTimeStepS = 365;  iTimeStepE = 365; 
iTimeStepS = 3;  iTimeStepE = 3; 
iTimeStepS = 2;  iTimeStepE = 365; 
iTimeStepS = 85;  iTimeStepE = 365; 
iTimeStepS = 1;  iTimeStepE = 85; 

iTimeStepS = 2;  iTimeStepE = 365; 

for iTimeStep = iTimeStepS : iTimeStepE

  fprintf(1,'>>>>>> TimeStep %3i of 365 \n',iTimeStep);
  if iVers == 1
     use_this_rtp = ['AnomSym/June04_2019/timestep_' num2str(iTimeStep,'%03d') '_16day_avg.rp.rtp'];
  elseif iVers == 2 | iVers == 3
     use_this_rtp = ['AnomSym_no_seasonal/timestep_' num2str(iTimeStep,'%03d') '_16day_avg.rp.rtp'];
  else
    error('huh?')
  end

  [h,ha,p,pa] = rtpread(use_this_rtp);

  [ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p,1:length(p.stemp),2);  ppmv_CO2 = ppmvLAY(i500,:);
  [ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p,1:length(p.stemp),4);  ppmv_N2O = ppmvLAY(i500,:);
  [ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p,1:length(p.stemp),6);  ppmv_CH4 = ppmvLAY(i500,:);
  %[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p,1:length(p.stemp),51); ppmv_CFC = ppmvLAY(i500,:);

  ax = load(['../MakeJacskCARTA_CLR/Anomaly365_16/RESULTS/kcarta_' num2str(iTimeStep,'%03d') '_M_TS_jac_all_5_97_97_97_2645.mat']);
  tracegasx = squeeze(ax.M_TS_jac_all(:,:,1:3));

  xdeltaCO2 = ppmv_CO2 - ppmv_CO2_start;
  xdeltaN2O = ppmv_N2O - ppmv_N2O_start;
  xdeltaCH4 = ppmv_CH4 - ppmv_CH4_start;
  %deltaCFC = ppmv_CFC - ppmv_CFC_start;

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
 

  tracegas = [];
  for iLatbin = 1 : 40
    if iVers == 1
      fout = [outdir '/' num2str(iTimeStep,'%03d') '/strowfinitejac_convolved_kcarta_airs_' num2str(iLatbin) '_jac.mat'];  
    elseif iVers == 2
      fout = [outdir '/' num2str(iTimeStep,'%03d') '/strowfinitejac_convolved_kcarta_airs_' num2str(iLatbin) '_jac2.mat'];  
    elseif iVers == 3
      fout = [outdir '/' num2str(iTimeStep,'%03d') '/xprofile_finite_jac_anomaly_strow_latbin_' num2str(iLatbin,'%02i') '_timestemp_' num2str(iTimeStep,'%03d') '.mat'];  
    else
      error('huh2')
    end
    if exist(fout)  
      %% fout contains deltaCO2 etc
      clear fKc rKc
      loader = ['load ' fout];
      eval(loader);
      %tKc = rad2bt(fKc,rKc);; 
      %plot(fKc,tKc(:,1)*ones(1,4)-tKc(:,2:5));
      jac = [co2jac(:,iLatbin) n2ojac(:,iLatbin) ch4jac(:,iLatbin)];   %% oops with SARTA, I did ALL of them all the time

  figure(9); 
    subplot(221); plot(1:40,xdeltaCO2,'b',1:40,deltaco2,'r'); title(num2str(iTimeStep));
    subplot(222); plot(1:40,xdeltaN2O,'b',1:40,deltan2o,'r'); 
    subplot(223); plot(1:40,xdeltaCH4,'b',1:40,deltach4,'r'); 
    %subplot(224); plotx(1:40,deltaCFC); 
    pause(0.1)
      delta   = ones(2645,1) * [xdeltaCO2(iLatbin) xdeltaN2O(iLatbin) xdeltaCH4(iLatbin)];
      delta   = ones(2645,1) * [deltaco2(iLatbin) deltan2o(iLatbin) deltach4(iLatbin)];
      scaling = ones(2645,1) * [2.2 1.0*1e-3 5.0*1e-3];
     

      tracegas(iLatbin,:,:) = jac(lstrow.ichan,:) .* scaling ./delta;   %% this is for the kcarta code
      tracegas(iLatbin,:,:) = jac(lstrow.ichan,:) .* scaling;           %% do not need delta here since SARTA code already divides by delta
    fprintf(1,'.');
    end  %% if file exist
  end    %% latbin
  fprintf(1,'\n');

  figure(1); plot(f,squeeze(tracegasx(:,:,1)),'b.-',f,squeeze(tracegas(:,:,1)),'r'); grid
  figure(2); plot(f,squeeze(tracegasx(:,:,2)),'b.-',f,squeeze(tracegas(:,:,2)),'r'); grid
  figure(3); plot(f,squeeze(tracegasx(:,:,3)),'b.-',f,squeeze(tracegas(:,:,3)),'r'); grid
  %figure(4); plot(f,squeeze(tracegasx(:,:,4)),'b.-',f,squeeze(tracegas(:,:,4)),'r'); grid

  [mmm,nnn,ooo] = size(tracegas);
  boo = find(f >= 0791.7,1); figure(5); plot(1:mmm,squeeze(tracegasx(1:mmm,boo,1)),'b.-',1:mmm,squeeze(tracegas(1:mmm,boo,1)),'rx-'); title('CO2 0791 cm-1'); grid
    hl = legend('sergio kcarta dQ=0.001','strow dQ=Q(t)-Q(0)','location','best'); set(hl,'fontsize',10);
  boo = find(f >= 1278.4,1); figure(6); plot(1:mmm,squeeze(tracegasx(1:mmm,boo,2)),'b.-',1:mmm,squeeze(tracegas(1:mmm,boo,2)),'rx-'); title('N2O 1278 cm-1'); grid
    hl = legend('sergio kcarta dQ=0.001','strow dQ=Q(t)-Q(0)','location','best'); set(hl,'fontsize',10);
  boo = find(f >= 1303.7,1); figure(7); plot(1:mmm,squeeze(tracegasx(1:mmm,boo,3)),'b.-',1:mmm,squeeze(tracegas(1:mmm,boo,3)),'rx-'); title('CH4 1303 cm-1'); grid
    hl = legend('sergio kcarta dQ=0.001','strow dQ=Q(t)-Q(0)','location','best'); set(hl,'fontsize',10);
  %boo = find(f >= 0847.0,1); figure(8); plot(1:mmm,squeeze(tracegasx(1:mmm,boo,4)),'b.-',1:mmm,squeeze(tracegas(1:mmm,boo,4)),'rx-'); title('CFC 0847 cm-1'); grid
  %  hl = legend('sergio kcarta dQ=0.001','strow dQ=Q(t)-Q(0)','location','best'); set(hl,'fontsize',10);
  if mmm < 40
    fprintf(1,'oops only have done %3i of 40 jacs for timestep %3i \n',mmm,iTimeStep);
    error('HALT')  
  end

  pause(0.1)
  %disp('ret to continue'); pause
  
  if iVers == 1
    outfile = [outdirResults '/sarta_' num2str(iTimeStep,'%03d') '_tracegas_finitediff_3gas_2645.mat'];
  elseif iVers == 2
    outfile = [outdirResults '/sarta_' num2str(iTimeStep,'%03d') '_tracegas_finitediff_3gas_2645_V2.mat'];
  elseif iVers == 3
    outfile = [outdirResults '/sarta_' num2str(iTimeStep,'%03d') '_tracegas_finitediff_3gas_2645_V3.mat'];
  end
  saver = ['save ' outfile ' tracegas f qrenorm str1 str2 comment'];

  eval(saver)

  pause(0.1)
end      %% timestep
