clear all
iiBin = input('iiBin to compare against kcarta jac : ');

mapp = load('map2645to2378.mat');

mapp.closest2645to2378_ind = 1:2378;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear rads
for iLoop = 1 : 99
  fout = ['JUNK/individual_prof_convolved_kcarta_crisHI_' num2str(iLoop) '.mat'];
  a = load(fout);
  rads(:,iLoop) = a.rKc;
end

f = a.fKc;
i1231 = find(f >= 1231,1);

jacloop = rad2bt(f,rads);
jacloop = jacloop(:,1:98) - jacloop(:,99)*ones(1,98);
jacloop = jacloop(mapp.closest2645to2378_ind,1:97);
jacloop = fliplr(jacloop);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sarta = load('../MakeJacsSARTA/SARTA_AIRSL1c_Oct2018_CLR2/sarta_origM_TS_jac_all_5_97_97_97.mat');
iAll = (1:97);
iW = iAll + 5 + 97*0; sW = squeeze(sarta.M_TS_jac_all(iiBin,:,iW));  sW = fliplr(sW);
iT = iAll + 5 + 97*1; sT = squeeze(sarta.M_TS_jac_all(iiBin,:,iT));  sT = fliplr(sT);
iO = iAll + 5 + 97*2; sO = squeeze(sarta.M_TS_jac_all(iiBin,:,iO));  sO = fliplr(sO);
iG = 1:5;             sG = squeeze(sarta.M_TS_jac_all(iiBin,:,iG));

kcarta = load(['../MakeJacskCARTA/CLEAR_JACS/JUNK/jac_results_' num2str(iiBin) '.mat']);
kcW = kcarta.water(mapp.closest2645to2378_ind,:);
kcT = kcarta.tempr(mapp.closest2645to2378_ind,:);
kcO = kcarta.ozone(mapp.closest2645to2378_ind,:);
kcG = [kcarta.tracegas(mapp.closest2645to2378_ind,:) kcarta.stemp(mapp.closest2645to2378_ind,1)];

kcG(:,1) = kcG(:,1)*sarta.qrenorm(1)/370*10;  %% recall column jacs in kcarta are for 0.1 perturbation
kcG(:,2) = kcG(:,2)*sarta.qrenorm(2)/300*10;  %% recall column jacs in kcarta are for 0.1 perturbation
kcG(:,3) = kcG(:,3)*sarta.qrenorm(3)/300*10;  %% recall column jacs in kcarta are for 0.1 perturbation
kcG(:,4) = kcG(:,4)*sarta.qrenorm(4)/300*10;  %% recall column jacs in kcarta are for 0.1 perturbation
kcG(:,5) = kcG(:,5)*sarta.qrenorm(5);

figure(1);
subplot(211); plot(sarta.f,kcG); ylabel('kCARTA'); ax = axis; grid
subplot(212); plot(sarta.f,sG); ylabel('SARTA');   axis(ax);  grid

figure(2); plot(sarta.f,sW,'b',sarta.f,kcW/100,'r'); title('water')
figure(3); plot(sarta.f,sT,'b',sarta.f,kcT/100,'r'); title('tempr')
figure(4); plot(sarta.f,sO,'b',sarta.f,kcO/100,'r'); title('ozone')

figure(5); plot(sarta.f,sum(sW'),'b.-',sarta.f,sum(kcW')/100,'r'); title('water')
legend('sarta','kcarta','location','best'); grid

figure(6); plot(sarta.f,sum(sT'),'b.-',sarta.f,sum(kcT')/100,'r'); title('tempr')
legend('sarta','kcarta','location','best'); grid
figure(6); plot(sarta.f,sT,'b',sarta.f,kcT/100,'r',sarta.f,jacloop/100,'k');
figure(6); plot(sarta.f,sum(sT'),'b',sarta.f,sum(kcT'/100),'r',sarta.f,sum(jacloop'/100),'k','linewidth',2);
  hl = legend('sarta','kcarta jac','kcarta jac LOOP','location','best'); grid

figure(7); plot(sarta.f,sum(sO'),'b.-',sarta.f,sum(kcO')/100,'r'); title('ozone')
legend('sarta','kcarta','location','best'); grid

[sarta.qrenorm(iW(1)) sarta.qrenorm(iT(1)) sarta.qrenorm(iO(1))]

figure(8); pcolor(sarta.f,1:97,sT');           shading flat; colorbar; colormap jet; title('sarta T')
figure(9); pcolor(sarta.f,1:97,kcT'/100);      shading flat; colorbar; colormap jet; title('kcarta T')
figure(10); pcolor(sarta.f,1:97,jacloop'/100); shading flat; colorbar; colormap jet; title('kcarta LOOP T')

figure(11); pcolor(sarta.f,1:97,sW');  shading flat; colorbar; colormap jet; title('sarta W')
figure(12); pcolor(sarta.f,1:97,kcW'*sarta.qrenorm(iW(1))/10); shading flat; colorbar; colormap jet; title('kcarta W')

figure(13); pcolor(sarta.f,1:97,sT'*100 ./ kcT'); shading flat; colorbar; colormap jet; caxis([-2 +2]); colorbar
figure(13); pcolor(sarta.f,1:97,sT'*100 ./ jacloop'); shading flat; colorbar; colormap jet; caxis([-2 +2]); colorbar
figure(13);
for ii = 1:97
  plot(sarta.f,sT(:,ii)*100 ./ jacloop(:,ii), sarta.f,sT(:,ii)*100 ./ kcT(:,ii)); axis([640 2800 -4 +4])
  title(num2str(ii)); pause(0.1); 
end
