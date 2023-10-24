summCount = sum(count,1);
for JOB = 1 : 64
  for ii = 1 : 72
    normalize(ii,JOB) = count(ii,JOB)/summCount(JOB);
  end
end

for JOB = 1 : 64
  for ii = 1 : 72
    xhist_bt1231cld(ii,JOB,:) = hist_bt1231cld(ii,JOB,:) * normalize(ii,JOB);
    xhist_bt1231obs(ii,JOB,:) = hist_bt1231obs(ii,JOB,:) * normalize(ii,JOB);
    xhist_stemp(ii,JOB,:) = hist_stemp(ii,JOB,:)         * normalize(ii,JOB);

    xquants_bt1231cld(ii,JOB,:) = quants_bt1231cld(ii,JOB,:); % * normalize(ii,JOB);
    xquants_bt1231obs(ii,JOB,:) = quants_bt1231obs(ii,JOB,:); % * normalize(ii,JOB);
    xquants_stemp(ii,JOB,:) = quants_stemp(ii,JOB,:);         % * normalize(ii,JOB);
  end
end

jett = jet; jett(1,:) = 1;
figure(1); clf; pcolor(dbtt,latt,squeeze(nanmean(hist_stemp,1))); title('Stemp'); colormap(jett); colorbar; shading interp
ylim([-90 +90])
figure(2); clf; pcolor(dbtt,latt,squeeze(nanmean(hist_bt1231obs,1))); title('BT1231 obs'); colormap(jett); colorbar; shading interp
ylim([-90 +90])
figure(3); clf; pcolor(dbtt,latt,squeeze(nanmean(hist_bt1231cld,1))); title('BT1231 cld'); colormap(jett); colorbar; shading interp
ylim([-90 +90])
figure(4); clf; pcolor(iaFound'); title('iaFound'); colorbar
ylim([-90 +90])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(5); clf
plot(squeeze(nanmean(xquants_bt1231obs,1)),latt,'linewidth',2); 
hold on; plot(squeeze(nanmean(xquants_bt1231cld,1)),latt,'--',squeeze(nanmean(xquants_stemp,1)),latt,':'); hold off
hl = legend(num2str(quants'),'location','best','fontsize',10);
ylim([-90 +90])

figure(5); clf
plot(squeeze(nanmean(xquants_bt1231obs,1)),latt,'linewidth',2); 
hl = legend(num2str(quants'),'location','best','fontsize',10);
ylim([-90 +90])

dadaX = mean_bt1231cld; dadaY = medn_bt1231cld; dada0 = min_bt1231cld; dada1 = max_bt1231cld; dada = xhist_bt1231cld; baba = xquants_bt1231cld; str = 'BT1231 cld';
dadaX = mean_stemp;     dadaY = medn_stemp;     dada0 = min_stemp;     dada1 = max_stemp;     dada = xhist_stemp;     baba = xquants_stemp;     str = 'stemp';
dadaX = mean_bt1231obs; dadaY = medn_bt1231obs; dada0 = min_bt1231obs; dada1 = max_bt1231obs; dada = xhist_bt1231obs; baba = xquants_bt1231obs; str = 'BT1231 obs';

figure(5); clf 
pcolor(dbtt,latt,squeeze(nansum(dada,1))); title(str); colormap(jett); colorbar; shading interp
%imagesc(dbtt,latt,squeeze(nansum(dada,1))); title(str); colormap(jett); colorbar; shading interp
hold on;
plot(squeeze(nansum(baba(:,:,1:4),1)),latt,'linewidth',2); 
plot(squeeze(nansum(baba(:,:,5),1)),latt,'k.-','linewidth',6); 
plot(squeeze(nansum(baba(:,:,6:8),1)),latt,'linewidth',2); 
hold off
xlim([200 340])
%hl = legend(num2str([-1 quants]'),'location','best','fontsize',8);
wah = [['    ']; num2str(quants')];
hl = legend(wah,'location','best','fontsize',8);
set(gca,'ydir','normal')
ylim([-90 +90])

[Y,IA,IB] = intersect(quants,[0.5 0.8 0.9 0.95 0.97]);
[Y,IA,IB] = intersect(quants,[0.5 0.8 0.95 0.97]);
iQ = find(quants == 0.9); 

figure(5); clf 
pcolor(dbtt,latt,squeeze(nansum(dada,1))); colormap(jett); colorbar; shading interp
hold on;
plot(nanmin(dada0),latt,'linewidth',2);
plot(squeeze(nansum(dadaX,1)),latt,'r','linewidth',6); 
plot(squeeze(nansum(baba(:,:,IA(1:2)),1)),latt,'linewidth',2); 
plot(squeeze(nansum(baba(:,:,iQ),1)),latt,'k','linewidth',6); 
plot(squeeze(nansum(baba(:,:,IA(3:4)),1)),latt,'linewidth',2); 
plot(nanmax(dada1),latt,'linewidth',2);
hold off
xlim([210 310])
wah = [['    ']; ['min ']; ['mean']; num2str(quants(IA(1:2))','%4.2f'); ['0.90']; num2str(quants(IA(3:4))'); ['max ']];
hl = legend(wah,'location','west','fontsize',8);
set(gca,'ydir','normal')
ylim([-90 +90])
xlabel('BT 1231 (K)'); ylabel('Latitude')

%%%%%%%%%%%%%%%%%%%%%%%%%

figure(6); clf
wada = squeeze(dada(36,:,:));
pcolor(dbtt,latt,cumsum(wada)); colormap(jett); colorbar; shading interp

figure(6); clf 
pcolor(dbtt,latt,cumsum(squeeze(nansum(dada,1)))); colormap(jett); colorbar; shading interp
hold on;
plot(nanmin(dada0),latt,'linewidth',2);
plot(squeeze(nansum(dadaX,1)),latt,'r','linewidth',6); 
plot(squeeze(nansum(baba(:,:,IA(1:2)),1)),latt,'linewidth',2); 
plot(squeeze(nansum(baba(:,:,iQ),1)),latt,'k','linewidth',6); 
plot(squeeze(nansum(baba(:,:,IA(3:4)),1)),latt,'linewidth',2); 
plot(nanmax(dada1),latt,'linewidth',2);
hold off
xlim([210 310])
wah = [['    ']; ['min ']; ['mean']; num2str(quants(IA(1:2))','%4.2f'); ['0.90']; num2str(quants(IA(3:4))'); ['max ']];
hl = legend(wah,'location','west','fontsize',8);
set(gca,'ydir','normal')
ylim([-90 +90])
xlabel('BT 1231 (K)'); ylabel('Latitude')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(7); clf %% this shows the mean is almost, but not, on top of quantile 0.5 .. while median is on top
iQ = find(quants == 0.5); plot(nanmean(dadaX),latt,'b.-',nanmean(dadaY),latt,'g.-',nanmean(squeeze(baba(:,:,iQ))),latt); title(str)
  hl = legend('mean','meadian','Quantile 0.5','location','best','fontsize',10);
iQ = find(quants == 0.5); plot(nanmean(dada0),latt,'k',nanmean(dadaX),latt,'b.-',nanmean(dadaY),latt,'g.-',nanmean(squeeze(baba(:,:,iQ))),latt,'r',nanmean(dada1),latt,'m'); title(str)
  hl = legend('min','mean','meadian','Quantile 0.5','max','location','best','fontsize',10);
ylim([-90 +90])

figure(7); clf %% this proves the min and max are on top of quantile 0, quantile 1
iQ = find(quants == 1.0); plot(nanmin(dada0),latt,'b.-',nanmin(squeeze(baba(:,:,1))),latt,'b',nanmax(dada1),latt,'r.-',nanmax(squeeze(baba(:,:,iQ))),latt,'r'); title(str)
ylim([-90 +90])

figure(7); clf %% so how about min and mean, max and mean? AHA THEY ARE NOT
iQ = find(quants == 1.0); plot(nanmean(dada0,1),latt,'b.-',nanmin(squeeze(baba(:,:,1))),latt,'b',nanmean(dada1,1),latt,'r.-',nanmax(squeeze(baba(:,:,iQ))),latt,'r'); title(str)
ylim([-90 +90])

figure(7); clf  %% so put it all together
pcolor(dbtt,latt,squeeze(nansum(dada,1))); title(str); colormap(jett); colorbar; shading interp
hold on; 
plot(nanmean(dada0,1),latt,'b.-',nanmin(squeeze(baba(:,:,1))),latt,'b',nanmean(dada1,1),latt,'r.-',nanmax(squeeze(baba(:,:,iQ))),latt,'r'); title(str)
hold off
xlim([200 340])
wah = ['                              '; ...
       'mean(min)=mean(quantile min)  '; ...
       'min(min)=true min             '; ...
       'mean(max) = mean(quantile max)'; ...
       'max(max)=true max             '];
hl = legend(wah,'location','best','fontsize',8);
ylim([-90 +90])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath /asl/matlib/plotutils
% figure(5); aslprint(['/home/sergio/PAPERS/SUBMITPAPERS/trends/Figs/histogramBT1231_obs_desc_20_years_Q50_Q80_Q90_Q95_Q97.pdf']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
