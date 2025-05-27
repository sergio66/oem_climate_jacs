N = a.total_obs;
ianpts = 1 : N;

asc  = find(a.asc_flag(ianpts) == 65);
desc = find(a.asc_flag(ianpts) == 68);

out.name{tt} = fname;

out.mean_lat(tt)      = nanmean(a.lat(1:N));
out.mean_lon(tt)      = nanmean(a.lon(1:N));

out.mean_rtime(tt)    = nanmean(a.tai93(1:N));
[yy,mm,dd] = tai2utcSergio(out.mean_rtime + offset1958_to_1993);
doy = change2days(yy,mm,dd,2002);
out.yy(tt) = yy(tt);     
out.mm(tt) = mm(tt);     
out.dd(tt) = dd(tt);     
out.doy(tt) = doy(tt);  
out.time(tt) = 2002+doy(tt)/365;

out.mean_rad(:,tt)    = nanmean(a.rad(:,1:N),2);
out.std_rad(:,tt)     = nanstd(a.rad(:,1:N),[],2);
out.max_rad(:,tt)     = nanmax(a.rad(:,1:N),[],2);
out.min_rad(:,tt)     = nanmin(a.rad(:,1:N),[],2);

out.mean_rad_1231(tt) = nanmean(a.rad(1520,1:N));
out.std_rad_1231(tt)  = nanstd(a.rad(1520,1:N));
out.max_rad_1231(tt)  = nanmax(a.rad(1520,1:N));
out.min_rad_1231(tt)  = nanmin(a.rad(1520,1:N));

if iPlot > 0
  figure(1); clf
  plot(2002+doy/365,rad2bt(1231,out.min_rad_1231),'b',2002+doy/365,rad2bt(1231,out.mean_rad_1231),'g',2002+doy/365,rad2bt(1231,out.max_rad_1231),'r'); 
  title('BT 1231 ALL'); legend('min','mean','max','location','best','fontsize',10);
  pause(0.1)
end
