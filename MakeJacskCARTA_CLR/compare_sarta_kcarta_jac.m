clear all
disp('this is comparing clear calcs')
disp('this is comparing clear calcs')
disp('this is comparing clear calcs')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iiBin = input('iiBin to compare against kcarta jac : ');

disp('see ../MakeJacsSARTA/normer_clr.m')
%sarta = load('../MakeJacsSARTA/SARTA_AIRSL1c_Oct2018_CLR2/sarta_origM_TS_jac_all_5_97_97_97.mat');
sarta = load('../MakeJacsSARTA/SARTA_AIRSL1c_Oct2018_CLR/sarta_origM_TS_jac_all_5_97_97_97.mat');     
%sarta = load('../MakeJacsSARTA/SARTA_AIRSL1c_Anomaly365_16/sarta_origM_TS_jac_all_5_97_97_97.mat');  %% oops still have not done the 40 avg jacs
iAll = (1:97);
iW = iAll + 5 + 97*0; sW = squeeze(sarta.M_TS_jac_all(iiBin,:,iW));  sW = fliplr(sW);
iT = iAll + 5 + 97*1; sT = squeeze(sarta.M_TS_jac_all(iiBin,:,iT));  sT = fliplr(sT);
iO = iAll + 5 + 97*2; sO = squeeze(sarta.M_TS_jac_all(iiBin,:,iO));  sO = fliplr(sO);
iG = 1:5;             sG = squeeze(sarta.M_TS_jac_all(iiBin,:,iG));

mapp = load('map2645to2378.mat');
mapp.closest2645to2378_ind = 1:2378;

kcarta = load(['../MakeJacskCARTA_CLR/JUNK/jac_results_' num2str(iiBin) '.mat']);
kcW = kcarta.water(mapp.closest2645to2378_ind,:);
kcT = kcarta.tempr(mapp.closest2645to2378_ind,:);
kcO = kcarta.ozone(mapp.closest2645to2378_ind,:);
kcG = [kcarta.tracegas(mapp.closest2645to2378_ind,:) kcarta.stemp(mapp.closest2645to2378_ind,1)];

%plot(sarta.f,sarta.f - fKc(mapp.closest2645to2378_ind))

%% see ../MakeJacsSARTA/normer_clr.m
%{
  normer.normCO2 = 2.2/370;   %% ppm/yr out of 370
  normer.normN2O = 1.0/300;   %% ppb/yr outof 300
  normer.normCH4 = 5/1860;    %% ppb/yr out of 1800
  normer.normCFC = 1/1300;    %% ppt/yr out of 1300
  normer.normST  = 0.1;       %% K/yr

  normer.normO3  = 0.01;  %% frac/yr
  normer.normWV  = 0.01;  %% frac/yr
  normer.normT   = 0.01;  %% K/yr
%}

kcG(:,1) = kcG(:,1)*sarta.qrenorm(1)/370;  %% CO2
kcG(:,2) = kcG(:,2)*sarta.qrenorm(2)/300;  %% N2O
kcG(:,3) = kcG(:,3)*sarta.qrenorm(3)/1860;  %% CH4
kcG(:,4) = kcG(:,4)*sarta.qrenorm(4)/1300;  %% CFC
kcG(:,5) = kcG(:,5)*sarta.qrenorm(5);

for ii=1:13; figure(ii); clf; colormap jet; end

%%%%%%%%%%%%%%%%%%%%%%%%%
%% sarta.qrenorm = 0.01 for T, WV, O3 so divide kcarta layer jacs by 100
[sarta.qrenorm(iW(1)) sarta.qrenorm(iT(1)) sarta.qrenorm(iO(1))]

figure(1); plot(sarta.f(1:2378),sW(1:2378),'b',sarta.f(1:2378),kcW/100,'r'); title('W jacs (b) Sarta (r) kCARTA')
figure(2); plot(sarta.f(1:2378),sT(1:2378),'b',sarta.f(1:2378),kcT/100,'r'); title('T jacs (b) Sarta (r) kCARTA')
figure(3); plot(sarta.f(1:2378),sO(1:2378),'b',sarta.f(1:2378),kcO/100,'r'); title('O jacs (b) Sarta (r) kCARTA')

figure(4); plot(sarta.f(1:2378),sum(sW(1:2378,:)'),'b.-',sarta.f(1:2378),sum(kcW(1:2378,:)')/100,'r'); title('water')
legend('sarta','kcarta','location','best'); grid
figure(5); plot(sarta.f(1:2378),sum(sT(1:2378,:)'),'b.-',sarta.f(1:2378),sum(kcT(1:2378,:)')/100,'r'); title('tempr')
legend('sarta','kcarta','location','best'); grid
figure(6); plot(sarta.f(1:2378),sum(sO(1:2378,:)'),'b.-',sarta.f(1:2378),sum(kcO(1:2378,:)')/100,'r'); title('ozone')
legend('sarta','kcarta','location','best'); grid

figure(7); pcolor(sarta.f(1:2378),1:97,sT(1:2378,:)');  shading flat; colorbar; colormap jet; title('sarta T')
figure(8); pcolor(sarta.f(1:2378),1:97,kcT'/100); shading flat; colorbar; colormap jet; title('kcarta T')

figure(9); pcolor(sarta.f(1:2378),1:97,sW(1:2378,:)');  shading flat; colorbar; colormap jet; title('sarta W')
figure(10); pcolor(sarta.f(1:2378),1:97,kcW'/100); shading flat; colorbar; colormap jet; title('kcarta W')
%%%%%%%%%%%%%%%%%%%%%%%%%

figure(11);
subplot(211); plot(sarta.f(1:2378),kcG); ylabel('kCARTA tracegas'); ax = axis; grid
subplot(212); plot(sarta.f(1:2378),sG(1:2378)); ylabel('SARTA tracegas');   axis(ax);  grid

figure(12); plot(sarta.f(1:2378),sG(1:2378,5),'b',sarta.f(1:2378),kcG(1:2378,5),'r'); title('Stemp (b) SARTA (r) kCARTA')
figure(13); subplot(221); plot(sarta.f(1:2378),sG(1:2378,1),'b',sarta.f(1:2378),kcG(1:2378,1),'r'); title('CO2 (b) SARTA (r) kCARTA')
figure(13); subplot(222); plot(sarta.f(1:2378),sG(1:2378,2),'b',sarta.f(1:2378),kcG(1:2378,2),'r'); title('N2O (b) SARTA (r) kCARTA')
figure(13); subplot(223); plot(sarta.f(1:2378),sG(1:2378,3),'b',sarta.f(1:2378),kcG(1:2378,3),'r'); title('CH4 (b) SARTA (r) kCARTA')
figure(13); subplot(224); plot(sarta.f(1:2378),sG(1:2378,4),'b',sarta.f(1:2378),kcG(1:2378,4),'r'); title('CFC (b) SARTA (r) kCARTA')

%figure(13); subplot(223); plot(sarta.f(1:2378),sG(1:2378,3),'b',sarta.f(1:2378),kcG(1:2378,3)/50,'r'); title('CH4 (b) SARTA (r) kCARTA')
%figure(13); subplot(224); plot(sarta.f(1:2378),sG(1:2378,4),'b',sarta.f(1:2378),kcG(1:2378,4)/10,'r'); title('CFC (b) SARTA (r) kCARTA')
