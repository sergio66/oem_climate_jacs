load latB64.mat
latt = meanvaluebin(latB2);
figure(1); clf; plot(latt,nanmean(mean_stemp,1),'kx-',latt,nanmean(mean_bt1231clr,1),'b',latt,nanmean(mean_bt1231cld,1),'g',latt,nanmean(mean_bt1231obs,1),'r','linewidth',2)
  plotaxis2; xlim([-90 +90])
  hl = legend('Stemp','BT1231 clr','BT1231 cld','BT1231 obs','location','best','fontsize',10);

figure(2); clf; plot(latt,nanmean(mean_stemp,1),'kx-',latt,squeeze(nanmean(quants_bt1231obs,1)),'linewidth',2)
  plotaxis2; xlim([-90 +90])
  hl = legend(num2str([-1 quants]'),'location','best','fontsize',6);
figure(3); clf
  junk = squeeze(nanmean(quants_bt1231obs(:,:,1))); 
  iMin = find(junk == min(junk(20:40))); %% latbin(36) = 1.65 N
  plot(quants,squeeze(nanmean(quants_bt1231clr(:,iMin,:),1)),'b',quants,squeeze(nanmean(quants_bt1231cld(:,iMin,:),1)),'k',quants,squeeze(nanmean(quants_bt1231obs(:,iMin,:),1)),'r','linewidth',2)
  hl = legend('BT1231 clr','BT1231 cld','BT1231 obs','location','best','fontsize',10); xlabel('Quantile'); ylabel('Zonal avg BT1231'); grid; title(['Quantile stats at latbin ' num2str(latt(iMin))])

[oceanI,oceanJ] = find(landfrac == 0);
figure(4); clf; plot(latt,nanmean(mean_stemp-mean_bt1231clr,1),'b',latt(oceanJ),nanmean(mean_stemp(oceanI,oceanJ)-mean_bt1231clr(oceanI,oceanJ),1),'c',...
                     latt,nanmean(mean_stemp-mean_bt1231cld,1),'g',latt,nanmean(mean_stemp-mean_bt1231obs,1),'r','linewidth',2)
  plotaxis2; title('Stemp - X'); xlim([-90 +90])
  hl = legend('BT1231 clr','BT1231 clr ocean','BT1231 cld','BT1231 obs','location','best','fontsize',10);
figure(5); clf; pcolor(landfrac'); title('landfrac so far'); colorbar; shading interp
figure(6); clf; pcolor(iaFound'); title('iaFound   so far'); colorbar; shading flat
