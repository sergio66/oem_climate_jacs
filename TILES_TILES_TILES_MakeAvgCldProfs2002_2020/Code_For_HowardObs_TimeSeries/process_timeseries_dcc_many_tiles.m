addpath ../../StrowCodeforTrendsAndAnomalies/
addpath /home/sergio/MATLABCODE/TIME

hhh = load('h2645structure.mat');
f = hhh.h.vchan;

load('dcc_t23years_lat35_lon66.mat');
x = dcc_t23_35_66;

    frac = (eps+x.min.count230K)./(eps+x.avg.count);

    rtime = x.avg.mean_rtime + offset1958_to_1993;
    [yy,mm,dd,hh] = tai2utcSergio(rtime);
    
    mtime = tai2dtime(airs2tai(x.avg.mean_rtime));
    dtime = datenum(mtime);
    HHH = hour(mtime);
    MMM = minute(mtime);
    
    timeSince2002 = (2002.75 + (dtime-dtime(1))/365.25);

    x0 = dtime - dtime(1);
    N = 4;  
    [min_B,min_stats,min_btanomaly,min_radanomaly] = compute_anomaly_wrapper(1:length(mtime),x0,frac,N);

    figure(1); clf; plot(timeSince2002,frac); 
    figure(2); clf; plot(timeSince2002,min_radanomaly);
    figure(1); clf; plot(timeSince2002,smooth(frac,7)); 
    figure(2); clf; plot(timeSince2002,smooth(min_radanomaly,7));
    figure(3); clf; plot(timeSince2002,x.avg.mean_sol);
    figure(4); clf; plot(timeSince2002,hh,timeSince2002,HHH+MMM/60);    

   figure(1); xlim([2002.75 2025.5]); xlim([2020.5 2025.5]);
   figure(2); xlim([2002.75 2025.5]); xlim([2020.5 2025.5]);
   figure(3); xlim([2002.75 2025.5]); xlim([2020.5 2025.5]);
   figure(4); xlim([2002.75 2025.5]); xlim([2020.5 2025.5]);
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

latbin = 26;
latbin = 31;
iNumYear = 23;
for jj = 1 : 72
  lonbin = jj;
  fout = ['DCC_CNT/dcc_day_all_t' num2str(iNumYear,'%02i') '_' num2str(lonbin,'%02i') '_' num2str(latbin,'%02i') '.mat'];
  if exist(fout)
    loader = ['load ' fout];
    eval(loader);
    frac = (eps+x.min.count230K)./(eps+x.avg.count);

    rtime = x.avg.mean_rtime + offset1958_to_1993;
    [yy,mm,dd,hh] = tai2utcSergio(rtime);
    
    mtime = tai2dtime(airs2tai(x.avg.mean_rtime));
    dtime = datenum(mtime);
    timeSince2002 = (2002.75 + (dtime-dtime(1))/365.25);

    x0 = dtime - dtime(1);
    N = 4;  
    [min_B,min_stats,min_btanomaly,min_radanomaly] = compute_anomaly_wrapper(1:length(mtime),x0,frac,N);

    figure(1); clf; plot(timeSince2002,frac); title(num2str(jj));
    figure(2); clf; plot(timeSince2002,min_radanomaly); title(num2str(jj));

    raFrac(jj,:) = frac;
    raAnom(jj,:) = min_radanomaly;
    raHH(jj,:)   = hh;
    raSol(jj,:)  = x.avg.mean_sol;
    raLat(jj,:)  = x.avg.mean_lat;
    raLon(jj,:)  = x.avg.mean_lon;    
    
    pause(0.1);
  end    
end

figure(1); clf; scatter_coast(nanmean(raLon,2),nanmean(raLat,2),10,nanmean(raSol,2)); colormap jet; axis([-180 +180 -90 +90]); title('Solzen')
figure(1); clf; scatter_coast(nanmean(raLon,2),nanmean(raLat,2),10,nanmax(raFrac'));  colormap jet; axis([-180 +180 -90 +90]); title('Max Frac')
figure(2); clf; plot(timeSince2002,mean(raHH,1)); title('Mean HH');
figure(3); clf; plot(timeSince2002,mean(raSol,1)); title('Mean Sol');
figure(4); clf; plot(timeSince2002,mean(raAnom,1));           title('Mean Anom Frac');
figure(4); clf; plot(timeSince2002,smooth(mean(raAnom,1),7)); title('Mean Anom Frac');
