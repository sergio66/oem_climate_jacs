wahA = rad2bt(freqs41(ix),squeeze(radA(region,:,ix,iQPlot))); 
wahD = rad2bt(freqs41(ix),squeeze(radD(region,:,ix,iQPlot))); 

clear leg mraLat raLat wahAlat wahDlat trendA trendD
clear wahAanom wahDanom wahAmean wahDmean wahCount

for mmmm = 1 : 12
  %boo = find(a.month_desc == mmmm);
  boo = find(a.month_desc >= mmmm & a.month_desc < mmmm + 1);
  wahCount(mmmm) = length(boo);

  wahAanom(:,boo) = wahA(:,boo) - nanmean(wahA(:,boo),2)*ones(1,length(boo));
  wahDanom(:,boo) = wahD(:,boo) - nanmean(wahD(:,boo),2)*ones(1,length(boo));

  wahAmean(:,boo) = nanmean(wahA(:,boo),2)*ones(1,length(boo));
  wahDmean(:,boo) = nanmean(wahD(:,boo),2)*ones(1,length(boo));  
end

%%%%%%%%%%%%%%%%%%%%%%%%%

clear x_anomA x_anomD x_anom_WgtA x_anom_WgtD
for ii = 1 : size(wahA,1)
  [x_anomA(ii,:) b stats] = generic_compute_anomaly(d2002junk,wahA(ii,:));
  [x_anomD(ii,:) b stats] = generic_compute_anomaly(d2002junk,wahD(ii,:));
end

%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1); plot(thetime,nanmean(wahD,1),'b',thetime,nanmean(wahA,1),'r','linewidth',2);
  plotaxis2; hl = legend('D','A','location','best','fontsize',10); xlabel('time'); title(['region = ' strregion ' BT ' strix ' A/D']); 
  xlim([min(thetime) max(thetime)]);

%{
% figure(2); plot(thetime,nanmean(wahDanom,1),'b',thetime,nanmean(wahAanom,1),'r','linewidth',2);
%   plotaxis2; hl = legend('D','A','location','best','fontsize',10); xlabel('time'); 
%   title(['monthly anomaly \newline region = ' strregion ' BT ' strix ' A/D']); 
%   xlim([min(thetime) max(thetime)]);
% 
% figure(3); plot(thetime,smoothn(nanmean(wahDanom,1),23*iNumYearSmooth),'b',thetime,smoothn(nanmean(wahAanom,1),23*iNumYearSmooth),'r','linewidth',2);
%   title([num2str(iNumYearSmooth) ' year smoothed monthly anomaly \newline region = ' strregion ' BT ' strix ' A/D']); 
%   plotaxis2; hl = legend('D','A','location','best','fontsize',10); xlabel('time'); 
%   xlim([min(thetime) max(thetime)]);
%}

figure(2); plot(thetime,nanmean(x_anomD,1),'b',thetime,nanmean(x_anomA,1),'r','linewidth',2);
  plotaxis2; hl = legend('D','A','location','best','fontsize',10); xlabel('time'); 
  title(['monthly anomaly \newline region = ' strregion ' BT ' strix ' A/D']); 
  xlim([min(thetime) max(thetime)]);

figure(3); plot(thetime,smooth(nanmean(x_anomD,1),23*iNumYearSmooth*0.25,'loess'),'b',thetime,smooth(nanmean(x_anomA,1),23*iNumYearSmooth*0.25,'loess'),'r','linewidth',2);
  title([num2str(iNumYearSmooth) ' year smoothed monthly anomaly \newline region = ' strregion ' BT ' strix ' A/D']); 
  plotaxis2; hl = legend('D','A','location','best','fontsize',10); xlabel('time'); 
  xlim([min(thetime) max(thetime)]);

figure(4); plot_72x64_tiles(region); colormap jet
