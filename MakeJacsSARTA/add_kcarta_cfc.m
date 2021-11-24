%% CLR, March 09
fsartaIN  = '2378chans/SARTA_AIRSL1c_Oct2018_CLR/sarta_origM_TS_jac_all_5_97_97_97.mat';
fsartaOUT = '2378chans/SARTA_AIRSL1c_Oct2018_CLR/sarta_fixCFC_M_TS_jac_all_5_97_97_97.mat';
dKCARTA   = '../MakeJacskCARTA_CLD/JUNK/';

%% CLR2, March 09
%fsartaIN  = '2378chans/SARTA_AIRSL1c_Oct2018_CLR2/sarta_origM_TS_jac_all_5_97_97_97.mat';
%fsartaOUT = '2378chans/SARTA_AIRSL1c_Oct2018_CLR2/sarta_fixCFC_M_TS_jac_all_5_97_97_97.mat';
%dKCARTA   = '../MakeJacskCARTA_CLD/JUNK/';

%% CLD, March 09
fsartaIN  = '2378chans/SARTA_AIRSL1c_Oct2018/sarta_M_TS_jac_all_5_6_97_97_97_cld.mat';
fsartaOUT = '2378chans/SARTA_AIRSL1c_Oct2018/sarta_fixCFC_M_TS_jac_all_5_6_97_97_97_cld.mat';
dKCARTA   = '../MakeJacskCARTA_CLD/JUNK/';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CLD, March 26
fsartaIN  = 'SARTA_AIRSL1c_Oct2018/sarta_M_TS_jac_all_5_6_97_97_97_cld.mat';          %% 2834
fsartaOUT = 'SARTA_AIRSL1c_Oct2018/sarta_fixCFC_M_TS_jac_all_5_6_97_97_97_cld.mat';   %% 2635
dKCARTA   = '../MakeJacskCARTA_CLD/JUNK/';

%% CLR, March 26
fsartaIN  = 'SARTA_AIRSL1c_Oct2018_CLR/sarta_origM_TS_jac_all_5_97_97_97.mat';        %% 2834
fsartaOUT = 'SARTA_AIRSL1c_Oct2018_CLR/sarta_fixCFC_M_TS_jac_all_5_97_97_97.mat';     %% 2635
dKCARTA   = '../MakeJacskCARTA_CLD/JUNK/';

%% CLD, March 26
fsartaIN  = 'SARTA_AIRSL1c_Apr2019_DescOcean/sarta_M_TS_jac_all_5_6_97_97_97_cld.mat';          %% 2834
fsartaOUT = 'SARTA_AIRSL1c_Apr2019_DescOcean/sarta_fixCFC_M_TS_jac_all_5_6_97_97_97_cld.mat';   %% 2635
dKCARTA   = '../MakeJacskCARTA_CLD/JUNK/';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

s = load(fsartaIN);

figure(1); plot(s.f,squeeze(s.M_TS_jac_all(:,:,4))); title('SARTA CFC default')
figure(2); plot(s.f,squeeze(s.M_TS_jac_all(:,:,5))); title('SARTA stemp default')

iaFound = zeros(1,40);
for ii = 1 : 40
  k = [dKCARTA '/jac_results_' num2str(ii) '.mat'];
  if exist(k)
    a = load(k);
    iaFound(ii) = +1;
%    ak_stemp(:,ii) = a.stemp(1:2378)*0.1;        %% 0.1 is the scale factor
%    ak_cfc(:,ii)   = a.tracegas(1:2378,4)/1300;  %% recall kCARTA has 10% jacs
    ak_stemp(:,ii) = a.stemp(1:2834)*0.1;        %% 0.1 is the scale factor
    ak_cfc(:,ii)   = a.tracegas(1:2834,4)/1300;  %% recall kCARTA has 10% jacs
  end
end
[sum(iaFound) 40]

figure(3); plot(s.f,ak_cfc);   title('KCARTA CFC default')
figure(4); plot(s.f,ak_stemp); title('KCARTA stemp default')

s.M_TS_jac_all(:,:,4) = ak_cfc';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% subset 2834 down to L1c 2645
load sarta_chans_for_l1c.mat
s.M_TS_jac_all = s.M_TS_jac_all(:,ichan,:);
s.f            = s.f(ichan);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

save(fsartaOUT,'-struct','s');
