addpath ../../StrowCodeforTrendsAndAnomalies/
hhh = load('h2645structure.mat');
f = hhh.h.vchan;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mtime = tai2dtime(airs2tai(t23_35_66.avg.mean_rtime));
dtime = datenum(mtime);
timeSince2002 = (2002.75 + (dtime-dtime(1))/365.25);

plot(timeSince2002,sum(t23_35_66.quant.count(:,[2 3]),2)./t23_35_66.avg.count')  %% just checking the count
plot(timeSince2002,t23_35_66.min.count230K./t23_35_66.avg.count)                 %% fraction of (BT1231 < 230)/all
plot(timeSince2002,smooth(t23_35_66.min.count230K./t23_35_66.avg.count,7))       %% fraction of (BT1231 < 230)/all
  xlim([2002.75 2025.5])
  title('Fraction of FOVs with BT1231 < 230 K')
x0 = dtime - dtime(1);
N = 4;  
[min_B,min_stats,min_btanomaly,min_radanomaly] = compute_anomaly_wrapper(1:length(mtime),x0,t23_35_66.min.count230K./t23_35_66.avg.count,N);
plot(timeSince2002,t23_35_66.min.count230K./t23_35_66.avg.count,timeSince2002,min_btanomaly)
plot(timeSince2002,smooth(t23_35_66.min.count230K./t23_35_66.avg.count,7),timeSince2002,smooth(min_btanomaly,7))
plotaxis2; axis([2002.5 2025.5 -0.2 +0.2])

plot(rad2bt(1231,t23_35_66.avg.mean_rad(1520,:)))


plot(dtime,rad2bt(1231,t23_35_66.avg.mean_rad(1520,:)))
plot(mtime,rad2bt(1231,t23_35_66.avg.mean_rad(1520,:)))
plot(mtime,t23_35_66.avg.mean_sol,'linewidth',2); ylabel('SolZen')

%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1); clf
scatter(t23_35_66.avg.mean_sol,rad2bt(1231,t23_35_66.avg.mean_rad(1520,:)),50,timeSince2002,'filled'); colorbar
  xlabel('Solzen'); ylabel('BT 1231'); title('Avg daytime BT 1231');

figure(2); clf
scatter(t23_35_66.avg.mean_sol,rad2bt(1231,t23_35_66.min.rad(1520,:)),50,timeSince2002,'filled'); colorbar
  xlabel('Solzen'); ylabel('BT 1231'); title('Min daytime BT 1231');

figure(3); clf
scatter(t23_35_66.avg.mean_sol,rad2bt(1231,t23_35_66.max.rad(1520,:)),50,timeSince2002,'filled'); colorbar
  xlabel('Solzen'); ylabel('BT 1231'); title('Max daytime BT 1231');

figure(4); clf; 
mavg = -nanmean(rad2bt(1231,t23_35_66.avg.mean_rad(1520,:)))+rad2bt(1231,t23_35_66.avg.mean_rad(1520,:));
mmin = -nanmean(rad2bt(1231,t23_35_66.min.rad(1520,:)))+rad2bt(1231,t23_35_66.min.rad(1520,:));
mmax = -nanmean(rad2bt(1231,t23_35_66.max.rad(1520,:)))+rad2bt(1231,t23_35_66.max.rad(1520,:));
plot(timeSince2002,rad2bt(1231,t23_35_66.avg.mean_rad(1520,:)),'k',timeSince2002,rad2bt(1231,t23_35_66.min.rad(1520,:)),'b',timeSince2002,rad2bt(1231,t23_35_66.max.rad(1520,:)),'r')
plot(timeSince2002,mavg,'k',timeSince2002,mmin,'b',timeSince2002,mmax,'r')

plot(timeSince2002,smooth(mavg,11),'k',timeSince2002,smooth(mmin,11),'b',timeSince2002,smooth(mmax,11),'r')
  xlim([2020 2026])
  legend('Avg BT1231','MIN BT1231','MAX BT1231','location','best');
  plotaxis2;

timesteps = 2002.75 : 0.25 : 2026.50;
for ii = 1 : length(timesteps)-1
  boo = find(timeSince2002 >= timesteps(ii) & timeSince2002 < timesteps(ii+1));
  minrad_avg(:,ii) = nanmean(t23_35_66.min.rad(:,boo),2);
  minrad_std(:,ii) = nanstd(t23_35_66.min.rad(:,boo),[],2);
  minrad_time(ii)  = nanmean(t23_35_66.min.rtime(boo));
  minrad_sol(ii)   = nanmean(t23_35_66.min.mean_sol(boo));  
end
min_mtime = tai2dtime(airs2tai(minrad_time));
min_dtime = datenum(min_mtime);
min_timeSince2002 = (2002.75 + (min_dtime-min_dtime(1))/365.25);
plot(minrad_sol,rad2bt(1231,minrad_avg(1520,:)),'o')
scatter(minrad_sol,rad2bt(1231,minrad_avg(1520,:)),50,min_timeSince2002,'filled'); colorbar

min_bt = rad2bt(f,minrad_avg);
x0 = min_dtime - min_dtime(1);
N = 4;
for ii = 1 : 2645
  y0 = min_bt(ii,:);
  k = find(y0 > 0 & x0 >= 0 & isfinite(y0));
  [min_B,min_stats,min_btanomaly,min_radanomaly] = compute_anomaly_wrapper(k,x0,y0,N);
  min_trend(ii) = min_B(2);
  min_trend_unc(ii) = min_stats.se(2);
  min_anomaly(ii,:) = min_btanomaly;
end
errorbar(f,min_trend,min_trend_unc)
plot(f,min_trend); plotaxis2;

pcolor(f,min_timeSince2002,min_anomaly'); colorbar; shading interp; colormap(usa2); caxis([-1 +1]*12);  xlim([645 1620])
pcolor(min_timeSince2002,f,min_anomaly);  colorbar; shading interp; colormap(usa2); caxis([-1 +1]*12);  ylim([645 1620])

%%%%%%%%%%%%%%%%%%%%%%%%%

x0 = dtime - dtime(1);
N = 4;

y0 = mavg;
  k = find(y0 > 0 & x0 >= 0 & isfinite(y0));
  [B_avg,stats_avg,btanomaly_avg,radanomaly_avg] = compute_anomaly_wrapper(k,x0,y0,N);

y0 = mmin;
  k = find(y0 > 0 & x0 >= 0 & isfinite(y0));
  [B_min,stats_min,btanomaly_min,radanomaly_min] = compute_anomaly_wrapper(k,x0,y0,N);
  
y0 = mmax;
  k = find(y0 > 0 & x0 >= 0 & isfinite(y0));
  [B_max,stats_max,btanomaly_max,radanomaly_max] = compute_anomaly_wrapper(k,x0,y0,N);
plot(timeSince2002,btanomaly_avg,'k',timeSince2002,btanomaly_min,'b',timeSince2002,btanomaly_max,'r')
plot(timeSince2002,smooth(btanomaly_avg,11),'k',timeSince2002,smooth(btanomaly_min,11),'b',timeSince2002,smooth(btanomaly_max,11),'r')
plot(timeSince2002,smooth(btanomaly_avg,23),'k',timeSince2002,smooth(btanomaly_min,23),'b',timeSince2002,smooth(btanomaly_max,23),'r')
  ylim([645 1620])
  xlim([2020 2026])
  plotaxis2; legend('Avg BT1231','MIN BT1231','MAX BT1231','location','best');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x0 = dtime - dtime(1);
N = 4;

for ii = 1 : 2645
  if mod(ii,1000) == 0
    fprintf(1,'+')
  elseif mod(ii,100) == 0
    fprintf(1,'.')
  end

  for qq = 1 : length(t23_35_66.quantsx)

    y0 = t23_35_66.quant.mean_rad(:,qq,ii);
    y0 = y0';
    k = find(y0 > 0 & x0 >= 0 & isfinite(y0));
    [B,stats,btanomaly,radanomaly] = compute_anomaly_wrapper(k,x0,y0,N,f(ii),1);
  
    y0 = rad2bt(f(ii),t23_35_66.quant.mean_rad(:,qq,ii));
    y0 = y0';    
    k = find(y0 > 0 & x0 >= 0 & isfinite(y0));
    [xB,xstats,xbtanomaly,xradanomaly] = compute_anomaly_wrapper(k,x0,y0,N);
  
    qtrend(qq,ii)     = B.BTunits(2);
    qtrend_unc(qq,ii) = stats.BTunits(2); 
    qanom(qq,ii,:) = btanomaly;
  
    qxtrend(qq,ii)     = xB(2);
    qxtrend_unc(qq,ii) = xstats.se(2); 
    qxanom(qq,ii,:) = xbtanomaly;
  
  end
end

fprintf(1,'\n');
qq = 1;
errorbar(f,qtrend(qq,:),qtrend_unc(qq,:))
plot(f,qtrend(qq,:),f,qxtrend(qq,:)); xlim([645 1620]); plotaxis2;
pcolor(mtime,f,squeeze(qanom(qq,:,:))); colorbar; shading interp; colormap(usa2); caxis([-1 +1]*20)
pcolor(timeSince2002,f,squeeze(qanom(qq,:,:))); colorbar; shading interp; colormap(usa2); caxis([-1 +1]*12)
  ylim([645 1620])
  xlim([2020 2026])

plot(mtime,smooth(anom(1520,:),7),mtime,smooth(xanom(1520,:),7),mtime,0*smooth(anom(1520,:),7),'k')
  xlim([datetime(2020,1,1) datetime(2026,1,31)])
  xlim([datetime(2020,1,1) datetime(2025,7,31)])
title('BT 1231 anomaly')
grid


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dbt = t23_35_66.dbt;
histall = t23_35_66.avg.histall;
semilogy(dbt,nanmean(histall,2)); title('Mean hisogram'); xlabel('BT 1231')
for ii = 1 : length(dbt)
  y0 = histall(ii,:);
  k = find(y0 > 0 & x0 >= 0 & isfinite(y0));
  [xB,xstats,xbtanomaly,xradanomaly] = compute_anomaly_wrapper(k,x0,y0,N);

  hist_trend(ii)     = xB(2);
  hist_trend_unc(ii) = xstats.se(2); 
  hist_anom(ii,:) = xbtanomaly;
end

bad = find(isnan(hist_trend)); hist_trend(bad) = 0; hist_trend_unc(bad) = 0;

yyaxis left;  plot(dbt,nanmean(histall,2)); ylabel('Mean histogram'); xlabel('BT 1231')
yyaxis right; plot(dbt,hist_trend);         ylabel('d/dt Mean histogram'); plotaxis2;

yyaxis left;  plot(dbt,smooth(nanmean(histall,2),3)); ylabel('Mean histogram'); xlabel('BT 1231')
yyaxis right; plot(dbt,smooth(hist_trend,3));         ylabel('d/dt Mean histogram'); plotaxis2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x0 = dtime - dtime(1);
N = 4;

for ii = 1 : 2645
  if mod(ii,1000) == 0
    fprintf(1,'+')
  elseif mod(ii,100) == 0
    fprintf(1,'.')
  end

  y0 = t23_35_66.avg.mean_rad(ii,:);
  k = find(y0 > 0 & x0 >= 0 & isfinite(y0));
  [B,stats,btanomaly,radanomaly] = compute_anomaly_wrapper(k,x0,y0,N,f(ii),1);

  y0 = rad2bt(f(ii),t23_35_66.avg.mean_rad(ii,:));
  k = find(y0 > 0 & x0 >= 0 & isfinite(y0));
  [xB,xstats,xbtanomaly,xradanomaly] = compute_anomaly_wrapper(k,x0,y0,N);

  trend(ii)     = B.BTunits(2);
  trend_unc(ii) = stats.BTunits(2); 
  anom(ii,:) = btanomaly;

  xtrend(ii)     = xB(2);
  xtrend_unc(ii) = xstats.se(2); 
  xanom(ii,:) = xbtanomaly;

end
fprintf(1,'\n');
errorbar(f,trend,trend_unc)
plot(f,trend,f,xtrend); xlim([645 1620]); plotaxis2;
pcolor(mtime,f,anom); colorbar; shading interp; colormap(usa2); caxis([-1 +1]*20)
plot(mtime,smooth(anom(1520,:),7),mtime,smooth(xanom(1520,:),7),mtime,0*smooth(anom(1520,:),7),'k')
  xlim([datetime(2020,1,1) datetime(2026,1,31)])
  xlim([datetime(2020,1,1) datetime(2025,7,31)])
title('BT 1231 anomaly')
grid

