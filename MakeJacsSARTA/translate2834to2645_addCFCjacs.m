iUsualORAnom = +1;   %% usual
iUsualORAnom = -1;   %% Anomaly

dKCARTA   = '../MakeJacskCARTA_CLD/JUNK/';

%%% subset 2834 down to L1c 2645
load sarta_chans_for_l1c.mat

foutdir = 'SARTA_AIRSL1c_Anomaly365_16_no_seasonal_OldSarta_smallpert/';
foutdir = 'SARTA_AIRSL1c_Anomaly365_16/';    %% usually the default output

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
    %fsartaIN  = ['SARTA_AIRSL1c_Anomaly365_16/' num2str(iTimeStep,'%03d') '/sarta_origM_TS_jac_all_5_97_97_97.mat'];  
    fsartaIN  = [foutdir '/' num2str(iTimeStep,'%03d') '/sarta_origM_TS_jac_all_5_97_97_97.mat'];  

    %fsartaOUT = [dirOUT '/sarta_origM_TS_jac_all_5_97_97_97_' num2str(iTimeStep,'%03d') '.mat'];
    fsartaOUT = [dirOUT '/sarta_' num2str(iTimeStep,'%03d') '_fixCFC_M_TS_jac_all_5_97_97_97_2645.mat'];  
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if ~exist(fsartaOUT) & exist(fsartaIN)
  
      s = load(fsartaIN);
  
      figure(1); plot(s.f,squeeze(s.M_TS_jac_all(:,:,4))); title(['SARTA CFC default ' num2str(iTimeStep,'%03d')])
      figure(2); plot(s.f,squeeze(s.M_TS_jac_all(:,:,5))); title(['SARTA stemp default ' num2str(iTimeStep,'%03d')])
  
      iaFound = zeros(1,40);
      for ii = 1 : 40
        k = [dKCARTA '/jac_results_' num2str(ii) '.mat'];
        if exist(k)
          a = load(k);
          iaFound(ii) = +1;
  %        ak_stemp(:,ii) = a.stemp(1:2378)*0.1;        %% 0.1 is the scale factor
  %        ak_cfc(:,ii)   = a.tracegas(1:2378,4)/1300;  %% recall kCARTA has 10% jacs
          ak_stemp(:,ii) = a.stemp(1:2834)*0.1;        %% 0.1 is the scale factor
          ak_cfc(:,ii)   = a.tracegas(1:2834,4)/1300;  %% recall kCARTA has 10% jacs
        end 
      end
      fprintf(1,'iTImeStep = %3i found %2i latbins of 40 \n',iTimeStep,sum(iaFound))
  
      figure(3); plot(s.f,ak_cfc);   title(['KCARTA CFC default ' num2str(iTimeStep,'%03d')])
      figure(4); plot(s.f,ak_stemp); title(['KCARTA stemp default ' num2str(iTimeStep,'%03d')])
  
      s.M_TS_jac_all(:,:,4) = ak_cfc';
  
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      s.M_TS_jac_all = s.M_TS_jac_all(:,ichan,:);
      s.f            = s.f(ichan);
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
      save(fsartaOUT,'-struct','s');
    elseif exist(fsartaOUT) & exist(fsartaIN)
      fprintf(1,'output %s already exists \n',fsartaOUT)
    elseif ~exist(fsartaOUT) & ~exist(fsartaIN)
      fprintf(1,'input %s DNE exist \n',fsartaIN)
    end
  end
else
  disp('see add_kcarta_cfc.m')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% now compare to kCARTA
clear all

if iUsualORAnom < 0
  akcarta = load('../MakeJacskCARTA_CLR/Anomaly365_16/RESULTS/kcarta_182_M_TS_jac_all_5_97_97_97_2645.mat');
  asarta  = load('SARTA_AIRSL1c_Anomaly365_16/RESULTS/sarta_182_fixCFC_M_TS_jac_all_5_97_97_97_2645.mat');

  f = asarta.f;
  kc = squeeze(akcarta.M_TS_jac_all(20,:,:));
  sa = squeeze(asarta.M_TS_jac_all(20,:,:));

  for ii = 1 : 5
    plot(f,kc(:,ii),'b.-',f,sa(:,ii),'r'); pause;
  end
  ii = (1:97) + 97*0 + 5; plot(f,sum(kc(:,ii)'),'b.-',f,sum(sa(:,ii)'),'r'); pause
  ii = (1:97) + 97*1 + 5; plot(f,sum(kc(:,ii)'),'b.-',f,sum(sa(:,ii)'),'r'); pause
  ii = (1:97) + 97*2 + 5; plot(f,sum(kc(:,ii)'),'b.-',f,sum(sa(:,ii)'),'r'); pause
end


