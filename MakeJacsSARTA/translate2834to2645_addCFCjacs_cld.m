%% called by clust_translate2834to2645_addCFCjacs_cld.m

iUsualORAnom = +1;   %% usual
iUsualORAnom = -1;   %% Anomaly

dKCARTA   = '../MakeJacskCARTA_CLD/JUNK/';

%%% subset 2834 down to L1c 2645
load sarta_chans_for_l1c.mat

foutdir = 'SARTA_AIRSL1c_Anomaly365_16_no_seasonal_OldSarta_smallpert_CLD/';
foutdir = 'SARTA_AIRSL1c_Anomaly365_16_CLD/';    %% usually the default output

disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
fprintf(1,'looking for files in %s \n',foutdir)
disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')

if iUsualORAnom < 0
  %dirOUT = ['SARTA_AIRSL1c_Anomaly365_16/RESULTS/'];
  dirOUT = [foutdir '/RESULTS/'];

  if ~exist(dirOUT)
    mker = ['!mkdir ' dirOUT];
    fprintf(1,'need to make output dir %s \n',mker)
    eval(mker)
  end

  for iTimeStep = JOB
    fsartaIN  = [foutdir '/' num2str(iTimeStep,'%03d') '/sarta_M_TS_jac_all_5_6_97_97_97_cld.mat'];  
    fsartaOUT = [dirOUT '/sarta_' num2str(iTimeStep,'%03d') '_fixCFC_M_TS_jac_all_5_6_97_97_97_2645_cld.mat'];  
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if ~exist(fsartaOUT) & exist(fsartaIN)
  
      s = load(fsartaIN);
  
      junkjunk.qrenorm = zeros(1,303);
      junkjunk.qrenorm(1:4) = s.qrenorm(1:4);
      junkjunk.qrenorm(5) = s.qrenorm(4);
      junkjunk.qrenorm(6:303) = s.qrenorm(5:302);
      s.qrenorm = junkjunk.qrenorm;
      s.str3 = 'dont forget CFC12 is included, so str1 should be CO2,N2O,CH4,CFC11,CFC12,stemp ... and str2 should be [2.2 1.0 5 1 1 0.1] ...';
      
      figure(1); plot(s.f,squeeze(s.M_TS_jac_all(:,:,4))); title(['SARTA CFC11 default ' num2str(iTimeStep,'%03d')])
      figure(2); plot(s.f,squeeze(s.M_TS_jac_all(:,:,5))); title(['SARTA CFC12 default ' num2str(iTimeStep,'%03d')])
      figure(3); plot(s.f,squeeze(s.M_TS_jac_all(:,:,6))); title(['SARTA stemp default ' num2str(iTimeStep,'%03d')])
  
      iaFound = zeros(1,40);
      for ii = 1 : 40
        k = [dKCARTA '/jac_results_' num2str(ii) '.mat'];
        k = ['../MakeJacskCARTA_CLD/Anomaly365_16_12p8/' num2str(iTimeStep,'%03d') '/jac_results_' num2str(ii) '.mat'];
        if exist(k)
          a = load(k);
          iaFound(ii) = +1;
  %        ak_stemp(:,ii) = a.stemp(1:2378)*0.1;        %% 0.1 is the scale factor
  %        ak_cfc(:,ii)   = a.tracegas(1:2378,4)/1300;  %% recall kCARTA has 10% jacs
          ak_stemp(:,ii)  = a.stemp(1:2834)*0.1;         %% 0.1 is the scale factor
          ak_cfc11(:,ii)  = a.tracegas(1:2834,4)/250;    %% recall kCARTA has 10% jacs ... was originally 1/1300
          ak_cfc12(:,ii)  = a.tracegas(1:2834,5)/525;    %% recall kCARTA has 10% jacs ... was originally 1/1300
        else
          iaFound(ii) = 0;
  %        ak_stemp(:,ii) = a.stemp(1:2378)*0.1;        %% 0.1 is the scale factor
  %        ak_cfc(:,ii)   = a.tracegas(1:2378,4)/1300;  %% recall kCARTA has 10% jacs
          ak_stemp(:,ii)  = a.stemp(1:2834)*0.1;         %% 0.1 is the scale factor
          ak_cfc11(:,ii)  = a.stemp(1:2834)*0;    %% recall kCARTA has 10% jacs ... was originally 1/1300
          ak_cfc12(:,ii)  = a.stemp(1:2834)*0;    %% recall kCARTA has 10% jacs ... was originally 1/1300
        end 
      end
      fprintf(1,'iTImeStep = %3i found %2i latbins of 40 \n',iTimeStep,sum(iaFound))
  
      figure(3); plot(s.f,ak_cfc11); title(['KCARTA CFC11 default ' num2str(iTimeStep,'%03d')])
      figure(4); plot(s.f,ak_stemp); title(['KCARTA stemp default ' num2str(iTimeStep,'%03d')])
  
      s.M_TS_jac_all(:,:,4) = ak_cfc11';
      s.M_TS_jac_all(:,:,5) = ak_cfc12';
  
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      s.M_TS_jac_all = s.M_TS_jac_all(:,ichan,:);
      s.f            = s.f(ichan);
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

      save(fsartaOUT,'-struct','s');
      fprintf(1,'saved to %s \n',fsartaOUT)

    elseif exist(fsartaOUT) & exist(fsartaIN)
      fprintf(1,'output %s already exists \n',fsartaOUT)
    elseif ~exist(fsartaOUT) & ~exist(fsartaIN)
      fprintf(1,'input %s DNE exist \n',fsartaIN)
    end
  end
else
  disp('see add_kcarta_cfc.m')
end

error('oioioi')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% now compare to kCARTA
clear all

if iUsualORAnom < 0
  akcarta = load('../MakeJacskCARTA_CLR/Anomaly365_16/RESULTS/kcarta_182_M_TS_jac_all_5_6_97_97_97_2645.mat');
  asarta  = load('SARTA_AIRSL1c_Anomaly365_16/RESULTS/sarta_182_fixCFC_M_TS_jac_all_5_6_97_97_97_2645.mat');

  f = asarta.f;
  kc = squeeze(akcarta.M_TS_jac_all(20,:,:));
  sa = squeeze(asarta.M_TS_jac_all(20,:,:));

  for ii = 1 : 12
    plot(f,kc(:,ii),'b.-',f,sa(:,ii),'r'); pause;
  end
  ii = (1:97) + 97*0 + 12; plot(f,sum(kc(:,ii)'),'b.-',f,sum(sa(:,ii)'),'r'); pause
  ii = (1:97) + 97*1 + 12; plot(f,sum(kc(:,ii)'),'b.-',f,sum(sa(:,ii)'),'r'); pause
  ii = (1:97) + 97*2 + 12; plot(f,sum(kc(:,ii)'),'b.-',f,sum(sa(:,ii)'),'r'); pause
end


