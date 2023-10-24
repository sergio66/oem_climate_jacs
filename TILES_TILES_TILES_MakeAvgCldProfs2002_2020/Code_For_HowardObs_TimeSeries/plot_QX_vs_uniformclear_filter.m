iX = input('Enter which quantile to look at (90,95,97) when comparing to uniform-clear (default 90) : ');
if length(iX) == 0
  iX = 90;
end
if iX == 90
  clr_rlat  = clr90_rlat;
  clr_rlon  = clr90_rlon;
  clr_r1231 = clr90_r1231;
elseif iX == 95
  clr_rlat  = clr95_rlat;
  clr_rlon  = clr95_rlon;
  clr_r1231 = clr95_r1231;
elseif iX == 97
  clr_rlat  = clr97_rlat;
  clr_rlon  = clr97_rlon;
  clr_r1231 = clr97_r1231;
end
 
load pclear_Aug2012.mat
figure(8); clf; clrfilter_map = simplemap(pclear.rlat,pclear.rlon,rad2bt(1231,pclear.r1231)); colormap jet
figure(9); clf; qXfilter_map  = simplemap(clr_rlat,clr_rlon,clr_r1231); colormap jet
figure(9); cx = caxis;
figure(8); caxis(cx);
figure(10); plot(clrfilter_map(:),qXfilter_map(:),clrfilter_map(:),clrfilter_map(:),'k'); xlabel('clr filter'); ylabel('qX filter')

addpath /home/sergio/MATLABCODE/NANROUTINES/
[r,chisqr,P,sigP,numpts] = nanlinearcorrelation(clrfilter_map(:),clrfilter_map(:));

rlat180 = -90:+90; rlat180 = meanvaluebin(rlat180);
good = find(isfinite(clrfilter_map));
bad  = find(isnan(clrfilter_map));
qXfilter_mapNaN = qXfilter_map; qXfilter_mapNaN(bad) = NaN;
mean_qXfilter_mapNaN = nanmean(qXfilter_mapNaN,2);
std_qXfilter_mapNaN  = nanstd(qXfilter_mapNaN,[],2);
mean_clrfilter_mapNaN = nanmean(clrfilter_map,2);
std_clrfilter_mapNaN  = nanstd(clrfilter_map,[],2);

figure(13); clf; simplemap(pclear.rlat,pclear.rlon,rad2bt(1231,pclear.r1231)); colormap jet; cxU = caxis; title('Uniform clear')
figure(14); clf; simplemap(qXfilter_mapNaN); colormap jet; caxis(cxU); title('Q90')
figure(15); clf; junkdiff = simplemap(clrfilter_map-qXfilter_mapNaN); colormap(usa2);caxis([-1 +1]*5); title('Difference U/Clr-QX')
figure(16); dbbb = -5 : 0.1 : +5; plot(dbbb,histc(junkdiff(:),dbbb)); plotaxis2;; title('Histogram difference'); [nanmean(junkdiff(:)) nanstd(junkdiff(:))]

figure(11); errorbar(rlat180,mean_qXfilter_mapNaN,std_qXfilter_mapNaN,'b'); hold on; errorbar(rlat180,mean_clrfilter_mapNaN,std_clrfilter_mapNaN,'r'); hold off
hl = legend('QX filter','clear filter','location','south');
xlim([-90 +90])

addpath /home/sergio/MATLABCODE/PLOTMISC
figure(11);
  plot(rlat180,mean_qXfilter_mapNaN,'b',rlat180,mean_clrfilter_mapNaN,'r','linewidth',2);
  hold on
  shadedErrorBar(rlat180,mean_qXfilter_mapNaN,std_qXfilter_mapNaN,'b',0.3);
  shadedErrorBar(rlat180,mean_clrfilter_mapNaN,std_clrfilter_mapNaN,'r',0.3);
  hold off
hl = legend('QX filter','clear filter','location','south');
xlim([-90 +90]); ylabel('BT1231 observed (K)'); xlabel('Latitude [deg]');

figure(12); clf
mean_clrfilter_diff_mapNaN = nanmean(clrfilter_map - qXfilter_mapNaN,2);
std_clrfilter_diff_mapNaN  = nanstd(clrfilter_map - qXfilter_mapNaN,[],2);
errorbar(rlat180,mean_clrfilter_diff_mapNaN,std_clrfilter_diff_mapNaN,'r'); plotaxis2;
ylabel('uniform clear filter -  QX filter')

