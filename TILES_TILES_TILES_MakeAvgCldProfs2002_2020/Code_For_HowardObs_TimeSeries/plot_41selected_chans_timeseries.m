if wgtChan2 <= eps
  fprintf(1,'doing 1 chan     ix = %2i freq = %6.2f  iQuant = %2i smoothed over %2i years \n',ix,freqs41(ix),iQPlot,iNumYearSmooth);
  wahA = rad2bt(freqs41(ix),squeeze(radA(1:iCnt,:,ix,iQPlot)));
  wahD = rad2bt(freqs41(ix),squeeze(radD(1:iCnt,:,ix,iQPlot)));
else
  fprintf(1,'doing 2 chan BTD ix = %2i freq = %6.2f  iQuant = %2i smoothed over %2i years \n',ix,freqs41(ix),iQPlot,iNumYearSmooth);
  disp('doing 2 chans BTD')
  wahA = rad2bt(freqs41(ix),squeeze(radA(1:iCnt,:,ix,iQPlot))) - rad2bt(freqs41(ix2),squeeze(radA(1:iCnt,:,ix2,iQPlot)));
  wahD = rad2bt(freqs41(ix),squeeze(radD(1:iCnt,:,ix,iQPlot))) - rad2bt(freqs41(ix2),squeeze(radD(1:iCnt,:,ix2,iQPlot)));
end

less_smooth = 0.125;
less_smooth = 0.25;
less_smooth = 0.5;
less_smooth = 1.0;

clear leg mraLat raLat wahAlat wahDlat trendA trendD x_anomA_smooth x_anomD_smooth
clear wahAanom wahDanom wahAmean wahDmean wahCount

raLat = -90 : 15 : +90;
raLat =  00 : 30 : +90;
raLat = -90 : 30 : +90;

if min(raLat) < 0
  indjunk = 1 : length(raLat)-1;
  indstr_m = indjunk(1:length(indjunk)/2);
  indstr_p = indjunk(length(indjunk)/2+1:end);

  mraLat = meanvaluebin(raLat); 
  leg(1:length(indjunk)+1,1:6) = ' '; 
  leg(1:length(indjunk),1:5) = num2str(mraLat','%04.1f'); 
  leg(length(indjunk)+1,:) = 'GLOBAL'; 
else
  indjunk = 1 : length(raLat)-1;
  indstr_m = [];
  indstr_p = [];

  mraLat = meanvaluebin(raLat); 
  leg(1:4,1:6) = ' '; 
  leg(1,:) = ' TRP  ';
  leg(2,:) = ' MLS  ';
  leg(3,:) = ' POL  ';
  leg(length(indjunk)+1,:) = 'GLOBAL'; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cosYY = cos(YY'*pi/180) * ones(1,iNumTimeSteps);
wgtA = nansum(wahA .* cosYY,1)./nansum(cosYY,1);
wgtD = nansum(wahD .* cosYY,1)./nansum(cosYY,1);

warning off
if min(raLat) < 0
  for ii = 1 : length(raLat)-1
    boo = find(YY >= raLat(ii) & YY < raLat(ii+1));
    wahAlat(ii,:) = nanmean(wahA(boo,:),1);
    B = Math_tsfit_lin_robust(daysSince2002,wahAlat(ii,:),4);
    trendA(ii) = B(2);
  
    wahDlat(ii,:) = nanmean(wahD(boo,:),1);
    B = Math_tsfit_lin_robust(daysSince2002,wahDlat(ii,:),4);
    trendD(ii) = B(2);
  end
else
  for ii = 1 : length(raLat)-1
    boo = find(abs(YY) >= raLat(ii) & abs(YY) < raLat(ii+1));
    wahAlat(ii,:) = nanmean(wahA(boo,:),1);
    B = Math_tsfit_lin_robust(daysSince2002,wahAlat(ii,:),4);
    trendA(ii) = B(2);
  
    wahDlat(ii,:) = nanmean(wahD(boo,:),1);
    B = Math_tsfit_lin_robust(daysSince2002,wahDlat(ii,:),4);
    trendD(ii) = B(2);
  end
end
warning on
  
clear wahAanom wahDanom wahAmean wahDmean wahCount
for mmmm = 1 : 12
  %boo = find(a.month_desc == mmmm);
  boo = find(a.month_desc >= mmmm & a.month_desc < mmmm + 1);
  wahCount(mmmm) = length(boo);

  wahAanom(:,boo) = wahAlat(:,boo) - nanmean(wahAlat(:,boo),2)*ones(1,length(boo));
  wahDanom(:,boo) = wahDlat(:,boo) - nanmean(wahDlat(:,boo),2)*ones(1,length(boo));

  wahAmean(:,boo) = nanmean(wahAlat(:,boo),2)*ones(1,length(boo));
  wahDmean(:,boo) = nanmean(wahDlat(:,boo),2)*ones(1,length(boo));  

  wgtAanom(boo) = wgtA(:,boo) - nanmean(wgtA(:,boo))*ones(1,length(boo));
  wgtDanom(boo) = wgtD(:,boo) - nanmean(wgtD(:,boo))*ones(1,length(boo));
end

%%%%%%%%%%%%%%%%%%%%%%%%%

clear x_anomA x_anomD x_anom_WgtA x_anom_WgtD
for ii = 1 : length(raLat)-1
  [x_anomA(ii,:) b stats] = generic_compute_anomaly(d2002junk,wahAlat(ii,:));
  [x_anomD(ii,:) b stats] = generic_compute_anomaly(d2002junk,wahDlat(ii,:));
end

x_anom_WgtA = generic_compute_anomaly(d2002junk,wgtA);
x_anom_WgtD = generic_compute_anomaly(d2002junk,wgtD);

%%%%%%%%%%%%%%%%%%%%%%%%%

if raLat(1) < 0
  figure(4); clf; plot(thetime,wahAlat(indstr_m,:),'--',thetime,wahAlat(indstr_p,:),'-',thetime,wgtA,'kx-','linewidth',2); plotaxis2; xlim([min(thetime) max(thetime)]); title(['BT ' strix]);
  hl = legend(leg,'location','best','fontsize',10);

  figure(5); clf; plot(mraLat,trendD,'b',mraLat,trendA,'r','linewidth',2); plotaxis2; hl = legend('D','A','location','best','fontsize',10); xlabel('Latitude [deg]'); ylabel(['dBT ' strix '/dt'])
  title(['dBT ' strix '/dt']);
  
  figure(6); clf
  figure(6); plot(thetime,wgtD,'b',thetime,wgtA,'r','linewidth',2); ylabel(['BT ' strix '[K]']); xlabel('time'); plotaxis2; xlim([min(thetime) max(thetime)]); title('GLOBAL coswgt avg'); 
  hl = legend('D','A','location','best','fontsize',10);
else
  figure(4); clf; plot(thetime,wahAlat,thetime,wgtA,'kx-','linewidth',2); plotaxis2; xlim([min(thetime) max(thetime)]); title(['BT ' strix]);
  hl = legend(leg,'location','best','fontsize',10);

  figure(5); clf; plot(mraLat,trendD,'b',mraLat,trendA,'r','linewidth',2); plotaxis2; hl = legend('D','A','location','best','fontsize',10); xlabel('Latitude [deg]'); ylabel(['dBT ' strix '/dt'])
  title(['dBT ' strix '/dt']);
  
  figure(6); clf
  figure(6); plot(thetime,wgtD,'b',thetime,wgtA,'r','linewidth',2); ylabel(['BT ' strix '[K]']); xlabel('time'); plotaxis2; xlim([min(thetime) max(thetime)]); title('GLOBAL coswgt avg'); 
  hl = legend('D','A','location','best','fontsize',10);
end

%{
addpath /asl/matlib/plotutils/
figure(6); aslprint(['timeseriesplot_chan_' num2str(ix) '_' strix '.pdf'])
%}

for ii = 1 : length(raLat)-1
  %% TOOOOOO SMOOTH
  %wahAanomSmooth(ii,:) = smoothn(wahAanom(ii,:));
  %%wahDanomSmooth(ii,:) = smoothn(waDAanom(ii,:));

  %wahAanomSmooth(ii,:) = smoothn(wahAanom(ii,:),'robust');
  %%wahDanomSmooth(ii,:) = smoothn(waDAanom(ii,:),'robust');

  %wahAanomSmooth(ii,:) = smooth(wahAanom(ii,:),ceil(23*iNumYearSmooth));
  %%wahDanomSmooth(ii,:) = smooth(waDAanom(ii,:),ceil(23*iNumYearSmooth));

  wahAanomSmooth(ii,:) = smooth(wahAanom(ii,:),ceil(23*iNumYearSmooth),'rloess');
  %wahDanomSmooth(ii,:) = smooth(waDAanom(ii,:),ceil(23*iNumYearSmooth),'rloess');

 %x_anomA_smooth(ii,:) = smooth(x_anomA(ii,:),ceil(23*iNumYearSmooth),'rloess');
 %x_anomD_smooth(ii,:) = smooth(x_anomD(ii,:),ceil(23*iNumYearSmooth),'rloess');

 x_anomA_smooth(ii,:) = smooth(x_anomA(ii,:),ceil(23*iNumYearSmooth*less_smooth),'rloess');
 x_anomD_smooth(ii,:) = smooth(x_anomD(ii,:),ceil(23*iNumYearSmooth*less_smooth),'rloess');
end

[P] = nanpolyfit(thetime,smooth(x_anom_WgtA,ceil(23*iNumYearSmooth*less_smooth),'rloess'),1); PY = polyval(P,thetime);
if raLat(1) < 0
  figure(7); plot(thetime,smoothn(wahAanom(indstr_m,:),ceil(23*iNumYearSmooth)),'--',thetime,smoothn(wahAanom(indstr_p,:),ceil(23*iNumYearSmooth)),'linewidth',2); 
  figure(7); plot(thetime,wahAanomSmooth(indstr_m,:),'--',thetime,wahAanomSmooth(indstr_p,:),thetime,smoothn(wgtAanom,'robust'),'kx-','linewidth',2); 
  figure(7); plot(thetime,wahAanomSmooth(indstr_m,:),'--',thetime,wahAanomSmooth(indstr_p,:),thetime,smooth(wgtAanom,ceil(23*iNumYearSmooth)),'kx-','linewidth',2); 
  figure(7); plot(thetime,x_anomA_smooth(indstr_m,:),'--',thetime,x_anomA_smooth(indstr_p,:),thetime,smooth(x_anom_WgtA,ceil(23*iNumYearSmooth*less_smooth),'rloess'),'kx-',thetime,PY,'k','linewidth',2); 
else
  figure(7); plot(thetime,nanmean(x_anomA_smooth,1),thetime,smooth(x_anom_WgtA,ceil(23*iNumYearSmooth*less_smooth),'rloess'),'kx-',thetime,PY,'k','linewidth',2); 
  figure(7); plot(thetime,x_anomA_smooth,thetime,smooth(x_anom_WgtA,ceil(23*iNumYearSmooth*less_smooth),'rloess'),'kx-',thetime,PY,'k','linewidth',2); 
end
plotaxis2; xlim([min(thetime) max(thetime)]); hl = legend(leg(1:length(indjunk)+1,:),'location','best','fontsize',10); 
plotaxis2; xlim([min(thetime) max(thetime)]); hl = legend(leg,'location','best','fontsize',10); 
if wgtChan2 <= eps
  %% one chan only
  title([num2str(iNumYearSmooth) ' year smoothed monthly anomaly BT ' strix ])
else
  title([num2str(iNumYearSmooth) ' year smoothed monthly anomaly BTD ' strix '-' strix2])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

meanLatBin   = mraLat;
raw_anomA    = wahAanom;        smooth_anomA = x_anomA_smooth;
anom_WgtA    = x_anom_WgtA;     smmooth_anom_WgtA = smooth(x_anom_WgtA,ceil(23*iNumYearSmooth*less_smooth),'rloess');
saver = ['save anom_freq_' strix '.mat thetime raw_anomA smooth_anomA anom_WgtA smmooth_anom_WgtA meanLatBin'];

%{
eval(saver)
figure(8); clf; plot(thetime,smooth_anomA(indstr_m,:),'--',thetime,smooth_anomA(indstr_p,:),thetime,smmooth_anom_WgtA,'kx-',thetime,PY,'k','linewidth',2);
plotaxis2; xlim([min(thetime) max(thetime)]); hl = legend(leg(indjunk,:),'location','best','fontsize',10); 
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{

figure(6); plot(thetime,nanmean(wahA(NP,:),1),'b',thetime,nanmean(wahA(NML,:),1),'r',thetime,nanmean(wahA(T,:),1),'g',thetime,nanmean(wahA(SML,:),1),'m',thetime,nanmean(wahA(SP,:),1),'c',thetime,wgtA,'kx-','linewidth',2);
  plotaxis2; hl = legend('NP','NML','T','SML','SP','GLOBAL','location','best','fontsize',10); xlabel('time'); title(['BT ' strix ' A']); xlim([min(thetime) max(thetime)]);
figure(6); plot(thetime,nanmean(wahD(NP,:),1),'b',thetime,nanmean(wahD(NML,:),1),'r',thetime,nanmean(wahD(T,:),1),'g',thetime,nanmean(wahD(SML,:),1),'m',thetime,nanmean(wahD(SP,:),1),'c',thetime,wgtD,'kx-','linewidth',2);
  plotaxis2; hl = legend('NP','NML','T','SML','SP','GLOBAL','location','best','fontsize',10); xlabel('time'); title(['BT ' strix ' D']); xlim([min(thetime) max(thetime)]);

sfT = 1;  sfA = 1;
sfT = 14; sfA = 7;
figure(5); plot(thetime,nanmean(wahA(NP,:),1)-nanmean(nanmean(wahA(NP,:),1)),'b',thetime,nanmean(wahA(NML,:),1)-nanmean(nanmean(wahA(NML,:),1)),'r',...
                thetime,sfT*(nanmean(wahA(T,:),1)-nanmean(nanmean(wahA(T,:),1))),'g',thetime,nanmean(wahA(SML,:),1)-nanmean(nanmean(wahA(SML,:),1)),'m',thetime,nanmean(wahA(SP,:),1)-nanmean(nanmean(wahA(SP,:),1)),'c',...
                thetime,sfA*(wgtA-nanmean(wgtA)),'kx-','linewidth',2);
  plotaxis2; hl = legend('NP','NML','T','SML','SP','GLOBAL','location','best','fontsize',10); xlabel('time'); title(['BT ' strix ' A']); xlim([min(thetime) max(thetime)]);
figure(6); plot(thetime,nanmean(wahD(NP,:),1)-nanmean(nanmean(wahD(NP,:),1)),'b',thetime,nanmean(wahD(NML,:),1)-nanmean(nanmean(wahD(NML,:),1)),'r',...
                thetime,sfT*(nanmean(wahD(T,:),1)-nanmean(nanmean(wahD(T,:),1))),'g',thetime,nanmean(wahD(SML,:),1)-nanmean(nanmean(wahD(SML,:),1)),'m',thetime,nanmean(wahD(SP,:),1)-nanmean(nanmean(wahD(SP,:),1)),'c',...
                thetime,sfA*(wgtD-nanmean(wgtD)),'kx-','linewidth',2);
  plotaxis2; hl = legend('NP','NML','T','SML','SP','GLOBAL','location','best','fontsize',10); xlabel('time'); title(['BT ' strix ' D']); xlim([min(thetime) max(thetime)]);
%}

figure(1); pcolor(thetime,1:iCnt,wahA); shading interp; colormap jet; colorbar;  title(['A BT ' strix]); xlabel('time'); ylabel('tile'); caxis([220 300])
figure(2); pcolor(thetime,1:iCnt,wahD); shading interp; colormap jet; colorbar;  title(['D BT ' strix]); xlabel('time'); ylabel('tile'); caxis([220 300])
figure(3); pcolor(thetime,1:iCnt,wahA - wahD); shading interp; colormap jet; colorbar;  title(['BT ' strix ' A-D']); xlabel('time'); ylabel('tile'); caxis([-1 +1]*10); colormap(usa2)
