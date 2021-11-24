badttime = 228;
oktimes = load('/home/sergio/MATLABCODE/oem_pkg_run/AIRS_new_clear_scan_April2019/ok365times.mat');

oktimes.okdates(228)
oktimes.okdates(228)-2012

ii = 2;
%% Apr 2019 clrsky with mmw rates, also used for anomalies
statsType = ['Desc'];
dirIN  = ['/home/strow/Work/Airs/Stability/Data/' statsType '/'];
dirOUT = ['LATS40_avg_made_Mar29_2019_Clr/' statsType '/'];
fname = [dirIN '/statlat' num2str(ii) '.mat'];                                            %% done in March 2019
loader = ['a = load(''' fname ''');'];                                     
eval(loader);

if ~exist('wah')
  wah = load('//asl/data/stats/airs/clear/rtp_airicrad_era_rad_kl_2012_clear_desc.mat');
end

%/asl/rtp/rtp_airicrad_v6/clear/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath /home/sergio/MATLABCODE/TIME
[yya,mma,dda,hha] = tai2utcSergio(a.rtime_mean);
[yyw,mmw,ddw,hhw] = tai2utcSergio(wah.rtime_mean(:,2));

doya = change2days(yya,mma,dda,2002);
doyw = change2days(yyw,mmw,ddw,2002);  
junk = 2002 + doyw/365;  

closest0 = abs(junk-oktimes.okdates(228)); closest0 = find(closest0 == min(closest0),1);
[yyw(closest0) mmw(closest0) ddw(closest0) change2days(yyw(closest0),mmw(closest0),ddw(closest0),2012);]

closest1 = abs(junk-2012.3535); closest1 = find(closest1 == min(closest1),1);
[yyw(closest1) mmw(closest1) ddw(closest1) change2days(yyw(closest1),mmw(closest1),ddw(closest1),2012);]

if ~exist('p229')
  addpath /asl/matlib/htools
  [h,ha,p229,pa] = rtpread('/asl/rtp/rtp_airicrad_v6/clear/2012/era_airicrad_day229_clear.rtp');
end
if ~exist('p127')
  addpath /asl/matlib/htools
  [h,ha,p127,pa] = rtpread('/asl/rtp/rtp_airicrad_v6/clear/2012/era_airicrad_day127_clear.rtp');
end
addpath /home/sergio/MATLABCODE/PLOTTER
iaLat = equal_area_spherical_bands(20);
p = p229;
p = p127;
figure(1); scatter_coast(p.rlon,p.rlat,10,p.spres); colormap jet; axis([-180 +180 -90 +90])
oo = find(p.solzen < 90 & p.rlat >= iaLat(2) & p.rlat < iaLat(3)); [max(p.spres(oo)) mean(p.spres(oo)) min(p.spres(oo))]   %% between -71.8 and -64 = Latbin 2
oo = find(p.solzen >= 90 & p.rlat >= iaLat(2) & p.rlat < iaLat(3)); [max(p.spres(oo)) mean(p.spres(oo)) min(p.spres(oo))]   %% between -71.8 and -64 = Latbin 2
oo = find(p.iudef(4,:) == 0 & p.rlat >= iaLat(2) & p.rlat < iaLat(3)); [max(p.spres(oo)) mean(p.spres(oo)) min(p.spres(oo))]   %% between -71.8 and -64 = Latbin 2
oo = find(p.iudef(4,:) == 1 & p.rlat >= iaLat(2) & p.rlat < iaLat(3)); [max(p.spres(oo)) mean(p.spres(oo)) min(p.spres(oo))]   %% between -71.8 and -64 = Latbin 2

figure(2)
plot(doya,a.stemp_mean,'b',doyw,wah.stemp_mean(:,2),'r')
plot(2002 + doya/365,a.stemp_mean,'b',2002+doyw/365,wah.stemp_mean(:,2),'r'); ax = axis; line([oktimes.okdates(228) oktimes.okdates(228)],[ax(3) ax(4)],'color','k','linewidth',2);
  axis([2011.75 2013.25 ax(3) ax(4)]); grid

plot(2002 + doya/365,a.spres_mean,'b',2002+doyw/365,wah.spres_mean(:,2),'r'); ax = axis; line([oktimes.okdates(228) oktimes.okdates(228)],[ax(3) ax(4)],'color','k','linewidth',2);
  axis([2011.75 2013.25 ax(3) ax(4)]); grid; set(gca,'ydir','reverse')

plot(2002 + doya/365,a.nlevs_mean,'b',2002+doyw/365,wah.nlevs_mean(:,2),'r'); ax = axis; line([oktimes.okdates(228) oktimes.okdates(228)],[ax(3) ax(4)],'color','k','linewidth',2);
  axis([2011.75 2013.25 ax(3) ax(4)]); grid; set(gca,'ydir','reverse')

iL = 95;  
plot(2002 + doya/365,a.ptemp_mean(:,iL),'b',2002+doyw/365,squeeze(wah.ptemp_mean(:,2,iL)),'r'); ax = axis; line([oktimes.okdates(228) oktimes.okdates(228)],[ax(3) ax(4)],'color','k','linewidth',2);
  axis([2011.75 2013.25 ax(3) ax(4)]); grid;
