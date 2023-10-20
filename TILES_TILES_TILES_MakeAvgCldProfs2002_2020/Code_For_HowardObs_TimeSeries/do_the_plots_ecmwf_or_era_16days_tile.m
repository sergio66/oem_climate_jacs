jett = jet; jett(1,:) = 1;
figure(1); pcolor(dbtt,latt,squeeze(nanmean(hist_stemp,1))); title('Stemp'); colormap(jett); colorbar; shading interp
figure(2); pcolor(dbtt,latt,squeeze(nanmean(hist_bt1231obs,1))); title('BT1231 obs'); colormap(jett); colorbar; shading interp
figure(3); pcolor(dbtt,latt,squeeze(nanmean(hist_bt1231cal,1))); title('BT1231 cal'); colormap(jett); colorbar; shading interp
figure(4); pcolor(iaFound'); title('iaFound'); colorbar

figure(5); 
plot(squeeze(nanmean(quants_bt1231obs,1)),latt,'linewidth',2); 
hold on; plot(squeeze(nanmean(quants_bt1231cal,1)),latt,'--',squeeze(nanmean(quants_stemp,1)),latt,':'); hold off
hl = legend(num2str(quants'),'location','best','fontsize',10);

figure(5); 
plot(squeeze(nanmean(quants_bt1231obs,1)),latt,'linewidth',2); 
hl = legend(num2str(quants'),'location','best','fontsize',10);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dada0 = min_bt1231cal; dada1 = max_bt1231cal; dada = hist_bt1231cal; baba = quants_bt1231cal; str = 'BT1231 cal';
dada0 = min_stemp;     dada1 = max_stemp;     dada = hist_stemp;     baba = quants_stemp;     str = 'stemp';
dada0 = min_bt1231obs; dada1 = max_bt1231obs; dada = hist_bt1231obs; baba = quants_bt1231obs; str = 'BT1231 obs';

figure(5); clf 
pcolor(dbtt,latt,squeeze(nanmean(dada,1))); title(str); colormap(jett); colorbar; shading interp
%imagesc(dbtt,latt,squeeze(nanmean(dada,1))); title(str); colormap(jett); colorbar; shading interp
hold on;
plot(squeeze(nanmean(baba(:,:,1:4),1)),latt,'linewidth',2); 
plot(squeeze(nanmean(baba(:,:,5),1)),latt,'k.-','linewidth',6); 
plot(squeeze(nanmean(baba(:,:,6:8),1)),latt,'linewidth',2); 
hold off
xlim([200 340])
hl = legend(num2str([-1 quants]'),'location','best','fontsize',8);
set(gca,'ydir','normal')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(6); clf %% this proves the min and max are on top of quantile 0, quantile 1
plot(nanmin(dada0),latt,'b.-',nanmin(squeeze(baba(:,:,1))),latt,'b',nanmax(dada1),latt,'r.-',nanmax(squeeze(baba(:,:,8))),latt,'r'); title(str)

figure(6); clf %% so how about min and mean, max and mean? AHA THEY ARE NOT
plot(nanmean(dada0,1),latt,'b.-',nanmin(squeeze(baba(:,:,1))),latt,'b',nanmean(dada1,1),latt,'r.-',nanmax(squeeze(baba(:,:,8))),latt,'r'); title(str)

figure(6); clf  %% so put it all together
pcolor(dbtt,latt,squeeze(nanmean(dada,1))); title(str); colormap(jett); colorbar; shading interp
hold on; 
plot(nanmean(dada0,1),latt,'b.-',nanmin(squeeze(baba(:,:,1))),latt,'b',nanmean(dada1,1),latt,'r.-',nanmax(squeeze(baba(:,:,8))),latt,'r'); title(str)
hold off
xlim([200 340])
hl = legend('pcolor','mean(min)=mean(quantile min)','min(min)=true min','mean(max) = mean(quantile max)','max(max)=true max','location','best','fontsize',8);
