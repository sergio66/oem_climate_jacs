clear all
iiBin = input('iiBin to compare against kcarta jac : ');

sarta = load('../MakeJacsSARTA/SARTA_AIRSL1c_Oct2018/sarta_M_TS_jac_all_5_6_97_97_97_cld.mat');
iAll = (1:97);
iW = iAll + 11 + 97*0; sW = squeeze(sarta.M_TS_jac_all(iiBin,:,iW));  sW = fliplr(sW);
iT = iAll + 11 + 97*1; sT = squeeze(sarta.M_TS_jac_all(iiBin,:,iT));  sT = fliplr(sT);
iO = iAll + 11 + 97*2; sO = squeeze(sarta.M_TS_jac_all(iiBin,:,iO));  sO = fliplr(sO);
iG = 1:5;              sG = squeeze(sarta.M_TS_jac_all(iiBin,:,iG));

mapp = load('map2645to2378.mat');

mapp.closest2645to2378_ind = 1:2378;

kcarta = load(['JUNK/jac_results_' num2str(iiBin) '.mat']);
kcW = kcarta.water(mapp.closest2645to2378_ind,:);
kcT = kcarta.tempr(mapp.closest2645to2378_ind,:);
kcO = kcarta.ozone(mapp.closest2645to2378_ind,:);
kcG = [kcarta.tracegas(mapp.closest2645to2378_ind,:) kcarta.stemp(mapp.closest2645to2378_ind,1)];

%% see ../MakeJacsSARTA/normer_cld.m
%{
  normer.normCO2 = 2.2/370;   %% ppm/yr out of 370
  normer.normO3  = 0.01;      %% frac/yr
  normer.normN2O = 1.0/300;   %% ppb/yr outof 300
  normer.normCH4 = 5/1860;    %% ppb/yr out of 1800
  normer.normCFC = 1/1300;    %% ppt/yr out of 1300
  normer.normST  = 0.1;       %% K/yr
%}

iVers = 1;
if iVers == 1
  kcG(:,1) = kcG(:,1)*2.2/370*10;  %% recall column jacs in kcarta are for 0.1 perturbation
  kcG(:,2) = kcG(:,2)*1.0/300*10;  %% recall column jacs in kcarta are for 0.1 perturbation
  kcG(:,3) = kcG(:,3)*5/1860*10;  %% recall column jacs in kcarta are for 0.1 perturbation
  kcG(:,4) = kcG(:,4)*1/1300*10;  %% recall column jacs in kcarta are for 0.1 perturbation
  kcG(:,5) = kcG(:,5)*0.1;
else
  kcG(:,1) = kcG(:,1)*sarta.qrenorm(1)*10;  %% recall column jacs in kcarta are for 0.1 perturbation
  kcG(:,2) = kcG(:,2)*sarta.qrenorm(2)*10;  %% recall column jacs in kcarta are for 0.1 perturbation
  kcG(:,3) = kcG(:,3)*sarta.qrenorm(3)*10;  %% recall column jacs in kcarta are for 0.1 perturbation
  kcG(:,4) = kcG(:,4)*sarta.qrenorm(4)*10;  %% recall column jacs in kcarta are for 0.1 perturbation
  kcG(:,5) = kcG(:,5)*sarta.qrenorm(5);
end

figure(1); clf
subplot(211); plot(sarta.f,kcG); ylabel('kCARTA'); ax = axis; grid
subplot(212); plot(sarta.f,sG); ylabel('SARTA');   axis(ax);  grid

figure(1); clf
subplot(221); plot(sarta.f,kcG(:,1),'b.-',sarta.f,sG(:,1),'r'); ylabel('CO2, stemp'); grid
hold on; plot(sarta.f,kcG(:,5),'c.-',sarta.f,sG(:,5),'m'); ylabel('CO2, stemp'); hold off
  hl = legend('kcarta CO2','sarta CO2','kcarta Stemp','sarta stemp','location','best'); 
subplot(222); plot(sarta.f,kcG(:,2),'b.-',sarta.f,sG(:,2),'r'); ylabel('N2O'); grid
  hl = legend('kcarta','sarta','location','best'); 
subplot(223); plot(sarta.f,kcG(:,3),'b.-',sarta.f,sG(:,3),'r'); ylabel('CH4'); grid
  hl = legend('kcarta','sarta','location','best'); 
subplot(224); plot(sarta.f,kcG(:,4),'b.-',sarta.f,sG(:,4),'r'); ylabel('CFC11'); grid
  hl = legend('kcarta','sarta','location','best'); 

figure(2); plot(sarta.f,sW,'b',sarta.f,kcW*sarta.qrenorm(iW(1)),'r'); title('water')
figure(3); plot(sarta.f,sT,'b',sarta.f,kcT*sarta.qrenorm(iT(1)),'r'); title('tempr')
figure(4); plot(sarta.f,sO,'b',sarta.f,kcO*sarta.qrenorm(iO(1)),'r'); title('ozone')

figure(5); plot(sarta.f,sum(sW'),'b.-',sarta.f,sum(kcW')*sarta.qrenorm(iW(1))/10,'r'); title('water')
legend('sarta','kcarta','location','best'); grid
figure(6); plot(sarta.f,sum(sT'),'b.-',sarta.f,sum(kcT')*sarta.qrenorm(iT(1))/50,'r'); title('tempr')
legend('sarta','kcarta','location','best'); grid
figure(7); plot(sarta.f,sum(sO'),'b.-',sarta.f,sum(kcO')*sarta.qrenorm(iO(1)),'r'); title('ozone')
legend('sarta','kcarta','location','best'); grid

[sarta.qrenorm(iW(1))/10 sarta.qrenorm(iT(1))/50 sarta.qrenorm(iO(1))]

figure(8); pcolor(sarta.f,1:97,sT');  shading flat; colorbar; colormap jet; title('sarta T')
  cx = caxis;
figure(9); pcolor(sarta.f,1:97,kcT'*sarta.qrenorm(iT(1))/50); shading flat; colorbar; colormap jet; title('kcarta T')
  caxis(cx);

figure(10); pcolor(sarta.f,1:97,sW');  shading flat; colorbar; colormap jet; title('sarta W')
  cx = caxis;
figure(11); pcolor(sarta.f,1:97,kcW'*sarta.qrenorm(iW(1))/10); shading flat; colorbar; colormap jet; title('kcarta W')
  caxis(cx);
