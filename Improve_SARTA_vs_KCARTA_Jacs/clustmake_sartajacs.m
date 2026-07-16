%% original code is in git/sarta_scatter_rtp_klayers_sergio/JACvers/MATLABCODE/

addpath_convolve
addpath /home/sergio/git/kcarta_gen/MATLAB

sarta = '/home/sergio/git/SARTA_CLOUDY_RTP_KLAYERS_NLEVELS/JACvers/bin/jac_airs_l1c_2834_cloudy_apr26_H2024';

%{
liststr = 'DATA/40000profiles/SartaColJac_00001_20000/prof_'
endstr = 'coljac.mat';
check_all_jobs_done(liststr,20000,endstr);
%}

%% so that we can handloop through using "loop_clust_do_kcarta_driver.m" when cluster is dead; see sergio_matlab_chip.sbatch
if ~exist('JOBB')
  JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
else
  JOB = JOBB;
end
if length(JOB) == 0
  JOB = 1401;  %% middle of SeeBor
  JOB = 1001;  %% ECM 83
  JOB = 0999;
%  JOB = 1;
end

numperjob = 20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% sbatch --array=1-33 --output='/dev/null/' sergio_matlab_chip.sbatch 1      since 660/20 = 33
fop = 'combine_83_49_370to430ppmv_v1.op.rtp';
savedir = ['DATA/v1/SARTA/'];
iSave =  0; %% save both 97 layer jacs and column jacs
iSave = -1; %% only save column jacs
iSave = +1; %% only save 97 layer jacs

%%%%%%%%%%%%%%%%%%%%%%%%%

%% sbatch --array=1-2000%512 --output='/dev/null/' sergio_matlab_chip.sbatch 1      since 40000/20 = 2000
fop = '/umbc/rs/pi_sergio/WorkDirDec2025/matlabcode/REGR_PROFILES_SARTA/REGR49_PROFILES_for_kCARTA_breakouts_for_SARTA/Combine_ECM100000_TIGR_SeeBor_ECM83_Regr49/abc.rtp';
fop = 'combined_rp_raw_with_emiss_random_CO2_scanang.rtp';
savedir = ['DATA/40000profiles/'];
if JOB <= 1000
  savedir = ['DATA/40000profiles/SartaColJac_00001_20000'];
elseif JOB > 1000
  savedir = ['DATA/40000profiles/SartaColJac_20001_40000'];
end  
iSave = +1; %% only save 97 layer jacs
iSave =  0; %% save both 97 layer jacs and column jacs
iSave = -1; %% only save column jacs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ind = 1:numperjob;
ind = ind + (JOB-1)*numperjob;

iLoadKC = +1;  %% this is debugging
iLoadKC = -1;  %% this is steaming ahead
if iLoadKC > 0
  xjob = ind(1);
  h2645 = load('/home/sergio/git/matlabcode/h2645structure.mat');
  
  %% see clust_put_together_sarta_kcartajacs.
  if xjob <= 20000
    kcjacdir = '/umbc/xfs3/strow/sergio_test/git/kcarta_gen/WORK/RUN_TARA/GENERIC_RADSnJACS_MANYPROFILES/JUNK/CombinedRTP_ColJac_00001_20000/';
  elseif xjob <= 40000
    kcjacdir = '/umbc/xfs3/strow/sergio_test/git/kcarta_gen/WORK/RUN_TARA/GENERIC_RADSnJACS_MANYPROFILES/JUNK/CombinedRTP_ColJac_20001_40000/';
  else
    xjob
    error('only about 38500 profiles')
  end

  fkcrad = [kcjacdir '/individual_prof_convolved_kcarta_airs_' num2str(xjob) '.mat'];
  fkcjac = [kcjacdir '/individual_prof_convolved_kcarta_airs_' num2str(xjob) '_coljac.mat'];

  loader = ['kcrad = load(''' fkcrad ''');']; eval(loader);
  loader = ['kcjac = load(''' fkcjac ''');']; eval(loader);

  kcjacX = rad2bt(kcjac.fKc,kcjac.rKc) - rad2bt(kcrad.fKc,kcrad.rKc);
  kcjacX = kcjac.rKc;  
  kcjacX = kcjacX(h2645.h.ichan,:);
  
  %/umbc/xfs3/strow/sergio_test/git/kcarta_gen/WORK/RUN_TARA/GENERIC_RADSnJACS_MANYPROFILES/set_gasOD_cumOD_rad_jac_flux_cloud_lblrtm.m
  %iKCKD =  43; iHITRAN = 2024; iDoLBLRTM = 2; iDoRad = 3;  iDoCloud = -1; iDoJac = +100; gg = 2456;  %% clrsky, use LBLRTM ODs  COL CLR JACS G2,G4,G5,G6,G51,G52,T(z),ST
  jj = 1;
  %kcJ1(jj,:)  = zeros(1.2645);
  kcJ2(jj,:)  = kcjacX(:,1)';
  %kcJ3(jj,:)  = zeros(1,2645);
  kcJ4(jj,:)  = kcjacX(:,2)';
  kcJ5(jj,:)  = kcjacX(:,3)';
  kcJ6(jj,:)  = kcjacX(:,4)';  
  kcJT(jj,:)  = kcjacX(:,7)';
  kcSKT(jj,:) = kcjacX(:,8)';
  kcRAD(jj,:) = kcrad.rKc(h2645.h.ichan)';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for jj = 1 : length(ind)
  xjob = ind(jj);
  frp = mktempS(['/rad_' num2str(xjob) '.rtp']);

  eeALL = 0;
  eeCOL = 0;  
  if iSave >= 0
    saveALL = [savedir '/prof_' num2str(xjob) 'jac.mat'];
    eeALL = exist(saveALL);
  end
  if iSave <= 0  
    saveCOL = [savedir '/prof_' num2str(xjob) 'coljac.mat'];
    eeCOL = exist(saveCOL);    
  end

  ee = -1;
  if iSave > 0
    ee = eeALL;
  elseif iSave < 0
    ee = eeCOL;
  elseif iSave == 0
    ee = min(eeCOL,eeALL);
  end

  if ee == 0
    sarter = ['!time ' sarta ' fin=' fop ' fout=' frp ' listj=-1 listp=' num2str(xjob)];
    sarter = ['!time ' sarta ' fin=' fop ' fout=' frp ' listj=200,100,1,2,3,4,5,6 listp=' num2str(xjob)];
    eval(sarter)
    
    [hx,ha,px,pa] = rtpread(frp);
    [w,jWGT,iaProf,iaNumLay] = readsarta_jacV2([frp '_WGTFCN'],200);
    [w,jT,iaProf,iaNumLay] = readsarta_jacV2([frp '_jacTZ'],100);
    [w,j1,iaProf,iaNumLay] = readsarta_jacV2([frp '_jacG1'],1);
    [w,j2,iaProf,iaNumLay] = readsarta_jacV2([frp '_jacG2'],2);
    [w,j3,iaProf,iaNumLay] = readsarta_jacV2([frp '_jacG3'],3);
    [w,j4,iaProf,iaNumLay] = readsarta_jacV2([frp '_jacG4'],4);
    [w,j5,iaProf,iaNumLay] = readsarta_jacV2([frp '_jacG5'],5);
    [w,j6,iaProf,iaNumLay] = readsarta_jacV2([frp '_jacG6'],6);
    
    rmer = ['!/bin/rm ' frp '*'];
    eval(rmer)
  
    colSKT = jT(1+iaNumLay,:);
    colJT = sum(jT(1:iaNumLay,:),1);
    colJ1 = sum(j1(1:iaNumLay,:),1);
    colJ2 = sum(j2(1:iaNumLay,:),1);
    colJ3 = sum(j3(1:iaNumLay,:),1);
    colJ4 = sum(j4(1:iaNumLay,:),1);
    colJ5 = sum(j5(1:iaNumLay,:),1);
    colJ6 = sum(j6(1:iaNumLay,:),1);    
    rad   = px.rcalc;
    
  %{
    figure(1); clf
      plot(hx.vchan,colSKT,'r',hx.vchan,colJT,'b')
      legend('SKT','col T','location','best')
      xlim([645 1645])
    figure(2); clf
      plot(hx.vchan,colJ1,'r',hx.vchan,colJ2,'m',hx.vchan,colJ3,'b',hx.vchan,colJ4,'c',hx.vchan,colJ5,'k',hx.vchan,colJ6,'g')
      legend('col WV','col CO2','col O3','col N2O','col CO','col CH4','location','best')
      xlim([645 1645])
  %}
  
    fprintf(1,'profile xjob = %5i has iNumLay %3i \n',xjob,iaNumLay)
  
  if iLoadKC > 0
    figure(1); plot(w,jT(iaNumLay-1:iaNumLay+1,:),'.-',w,kcSKT,'k')
    figure(1); plot(w,jT(iaNumLay+1,:),'.-',w,kcSKT,'k')  
    figure(2); plot(w,sum(j2(1:iaNumLay,:),1),'.-',w,kcJ2,'k'); xlim([645 845])
    figure(3); plot(w,sum(j4(1:iaNumLay,:),1),'.-',w,kcJ4,'k'); xlim([1200 1400])
    figure(4); plot(w,sum(j6(1:iaNumLay,:),1),'.-',w,kcJ6,'k'); xlim([1200 1400])
    figure(5); plot(w,sum(jT(1:iaNumLay,:),1),'.-',w,kcJT,'k')        
    error('kdjglkjsgd')
  end
  
    if iSave >= 0
      %% 97 layer jacs
      saver = ['save ' saveALL ' hx px w rad jT j1 j2 j3 j4 j5 j6 jWGT iaNumLay'];
        eval(saver);
      fprintf(1,'saver : %3i layer jacs = %s \n',iaNumLay,saver)
    end
    if iSave <= 0
      %% column jacs
      saver = ['save ' saveCOL ' hx px w rad colJT colJ1 colJ2 colJ3 colJ4 colJ5 colJ6 colSKT iaNumLay'];
        eval(saver);
      fprintf(1,'saver : %3i layer --> column jacs = %s \n',iaNumLay,saver)      
    end
  
    %lser = ['!ls -lt DATA/v1/SARTA/prof_*.mat'];
    %lser = ['!ls -lt ' savedir '/prof_*.mat'];
    %eval(lser)
  else
    fprintf(1,'iSave = %2i     not doing anything eeALL = %2i eeCOL %2i \n',iSave,eeALL,eeCOL)    
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1); clf
  plot(hx.vchan,colSKT,'r',hx.vchan,colJT,'b')
  legend('SKT','col T','location','best')
  xlim([645 1645])
  title(['profile ' num2str(xjob)])
figure(2); clf
  plot(hx.vchan,colJ1,'r',hx.vchan,colJ2,'m',hx.vchan,colJ3,'b',hx.vchan,colJ4,'c',hx.vchan,colJ5,'k',hx.vchan,colJ6,'g')
  legend('col WV','col CO2','col O3','col N2O','col CO','col CH4','location','best')
  xlim([645 1645])
  title(['profile ' num2str(xjob)])
  
lser = ['!ls -lt ' savedir '/prof_*.mat | wc -l'];
eval(lser)
