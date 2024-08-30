smN = 3;
smN = 5;
smN = 9;

figure(33); clf
plot(yymm,smooth(avg_anom_cldfrac*50,smN),'k',yymm,smooth(avg_anom_cldfracD*50,smN),'g',yymm,smooth(avg_anom_cldfracN*50,smN),'r','linewidth',2)
shade(33,2023,-2,1,4,'b',0.1);
plotaxis2;
legend('cldfrac*50','cldfracD*50','cldfracN*50','location','best','fontsize',10); 
ylabel('Anomaly')
title('MODIS L3 72x64 \newline cloudfrac x 50 nomalies')

figure(32); clf
plot(yymm,smooth(avg_anom_cldtop,smN),'k',yymm,smooth(avg_anom_cldtopD,smN),'g',yymm,smooth(avg_anom_cldtopN,smN),'r','linewidth',2)
shade(32,2023,-10,1,20,'b',0.1)
plotaxis2;
legend('cldtop','cldtopD','cldtopN','location','best','fontsize',10); 
ylabel('Anomaly')
title('MODIS L3 72x64 \newline cloudtop anomalies')

figure(31); clf
plot(yymm,smooth(xavg_anom_cldfrac*50,smN),'k',yymm,smooth(xavg_anom_cldfracD*50,smN),'g',yymm,smooth(xavg_anom_cldfracN*50,smN),'r','linewidth',2); plotaxis2;
shade(31,2023,-6,1,12,'b',0.1)
legend('cldfrac*50','cldfracD*50','cldfracN*50','location','best','fontsize',10); 
ylabel('Anomaly')
title('MODIS L3 cloudfrac anomalies \newline directly from 180x360xTime')

figure(30); clf
plot(yymm,smooth(xavg_anom_cldtop,smN),'k',yymm,smooth(xavg_anom_cldtopD,smN),'g',yymm,smooth(xavg_anom_cldtopN,smN),'r','linewidth',2); plotaxis2;
shade(30,2023,-6,1,12,'b',0.1)
legend('cldtop','cldtopD','cldtopN','location','best','fontsize',10); 
ylabel('Anomaly')
title('MODIS L3 cloudop anomalies \newline directly from 180x360xTime')

%%%%%%%%%%%%%%%%%%%%%%%%%
figure(21); clf
%plot(yymm,avg_anom_cldfrac*100,'k',yymm,avg_anom_cldtop,'g',yymm,avg_anom_od_ice,'b',yymm,avg_anom_od_liq,'r',yymm,avg_anom_dme_ice,'c',yymm,avg_anom_dme_liq,'m','linewidth',2); plotaxis2;
plot(yymm,smooth(avg_anom_cldfrac*50,smN),'k',yymm,smooth(avg_anom_cldtop/3,smN),'g',...
     yymm,smooth(avg_anom_od_ice,smN),'b',yymm,smooth(avg_anom_od_liq,smN),'r',yymm,smooth(avg_anom_dme_ice,smN),'c',yymm,smooth(avg_anom_dme_liq,smN),'m','linewidth',2); plotaxis2;
shade(21,2023,-6,1,12,'b',0.1)
legend('cldfrac*50','cldtop/3','ice OD','liq OD','ice DME','liq DME','location','best','fontsize',10); 
ylabel('Anomaly')
title('MODIS L3 cloud anomalies')

figure(22); clf;
plot(yymm,smooth(xavg_anom_cldfrac,smN)*50,'k',yymm,smooth(xavg_anom_cldtop/3,smN),'g',...
     yymm,smooth(xavg_anom_od_ice,smN),'b',yymm,smooth(xavg_anom_od_liq,smN),'r',yymm,smooth(xavg_anom_dme_ice,smN),'c',yymm,smooth(xavg_anom_dme_liq,smN),'m','linewidth',2); plotaxis2;
shade(22,2023,-6,1,12,'b',0.1)
legend('cldfrac*50','cldtop/3','ice OD','liq OD','ice DME','liq DME','location','best','fontsize',10); 
xlim([floor(min(yymm)) ceil(max(yymm))])
ylabel('Anomaly')
title('MODIS cld anomalies \newline directly from 180x360xTime')

figure(23); clf;
plot(yymm,smooth(avg_anom_cldfrac,smN)*50,'k',yymm,smooth(avg_anom_cldtop/3,smN),'g',yymm,smooth(xavg_anom_cldfrac,smN)*50,'k--',yymm,smooth(xavg_anom_cldtop/3,smN),'g--','linewidth',2)
plotaxis2; shade(23,2023,-6,1,12,'b',0.1)
legend('72x64 cldfrac*50','72x64 cldtop/3','360x180 xlcdfrac*50','360 x 180 xcldtop/3','location','best','fontsize',10); 

figure(24); clf
plot(yymm,smooth(avg_anom_od_ice,smN),'b',yymm,smooth(avg_anom_od_liq,smN),'r',yymm,smooth(xavg_anom_od_ice,smN),'c--',yymm,smooth(xavg_anom_od_liq,smN),'m--','linewidth',2)
plotaxis2; shade(23,2023,-6,1,12,'b',0.1)
legend('72x64 ice od','72x64 liq od','360x180 ice od','360 x 180 liq od','location','best','fontsize',10); 

figure(25); clf
plot(yymm,smooth(avg_anom_dme_ice,smN),'b',yymm,smooth(avg_anom_dme_liq,smN),'r',yymm,smooth(xavg_anom_dme_ice,smN),'c--',yymm,smooth(xavg_anom_dme_liq,smN),'m--','linewidth',2)
plotaxis2; shade(23,2023,-6,1,12,'b',0.1)
legend('72x64 ice dme','72x64 liq dme','360x180 ice dme','360 x 180 liq dme','location','best','fontsize',10); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1); clf; aslmapSergio(rlat65,rlon73,smoothn(avg_od_ice',1),  [-90 +90],[-180 +180]); caxis([0 +1]*60); title('Annual Average : OD ICE 72x64'); colormap(jett); colorbar
figure(2); clf; aslmapSergio(rlat65,rlon73,smoothn(avg_od_liq',1),  [-90 +90],[-180 +180]); caxis([0 +1]*10); title('Annual Average : OD_LIQ 72x64');          colormap(jett); colorbar
figure(3); clf; aslmapSergio(rlat65,rlon73,smoothn(avg_cldtop',1),  [-90 +90],[-180 +180]); caxis([0 +1]*10); title('Annual Average : Cldtop 72x64');     colormap(jett); colorbar

figure(4); clf; aslmapSergio(rlat65,rlon73,smoothn(trend_od_ice',1), [-90 +90],[-180 +180]); caxis([-1 +1]*0.5); title('Annual Trends : OD ICE 72x64'); colormap(usa2); colorbar
figure(5); clf; aslmapSergio(rlat65,rlon73,smoothn(trend_od_liq',1), [-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Annual Trends : OD_LIQ 72x64');          colormap(usa2); colorbar
figure(6); clf; aslmapSergio(rlat65,rlon73,smoothn(trend_cldtop',1), [-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Annual Trends : Cldtop 72x64');     colormap(usa2); colorbar

if iDo_sincosfit > 0
  figure(7); clf; aslmapSergio(rlat65,rlon73,smoothn(sctrend_od_ice',1), [-90 +90],[-180 +180]); caxis([-1 +1]*0.5); title('Annual Trends New : OD ICE 72x64'); colormap(usa2); colorbar
  figure(8); clf; aslmapSergio(rlat65,rlon73,smoothn(sctrend_od_liq',1), [-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Annual Trends New : OD_LIQ 72x64');          colormap(usa2); colorbar
  figure(9); clf; aslmapSergio(rlat65,rlon73,smoothn(sctrend_cldtop',1), [-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Annual Trends New : Cldtop 72x64');     colormap(usa2); colorbar
end
  
frac_od_ice = trend_od_ice./(avg_od_ice + eps);
frac_od_liq = trend_od_liq./(avg_od_liq + eps);
frac_cldtop = trend_cldtop./(avg_cldtop + eps);
figure(10); clf; aslmapSergio(rlat65,rlon73,smoothn(frac_od_ice',1), [-90 +90],[-180 +180]); caxis([-1 +1]*0.5); title('Fractional Trends : OD ICE 72x64'); colormap(usa2); colorbar
figure(11); clf; aslmapSergio(rlat65,rlon73,smoothn(frac_od_liq',1), [-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Fractional Trends : OD_LIQ 72x64');          colormap(usa2); colorbar
figure(12); clf; aslmapSergio(rlat65,rlon73,smoothn(frac_cldtop',1), [-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Fractional Trends : Cldtop 72x64');     colormap(usa2); colorbar

%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1); clf; aslmapSergio(rlat65,rlon73,avg_cldtop', [-90 +90],[-180 +180]); caxis([0 +1]*1000); title('Annual Average : Cldtop 72x64');  colormap(jett); colorbar
figure(2); clf; aslmapSergio(rlat65,rlon73,avg_cldfrac',[-90 +90],[-180 +180]); caxis([0 +1]*1.25); title('Annual Average : Cldfrac 72x64'); colormap(blues); colorbar
figure(3); clf; aslmapSergio(rlat65,rlon73,avg_od_ice', [-90 +90],[-180 +180]); caxis([0 +1]*20);   title('Annual Average : OD ICE 72x64');  colormap(jett); colorbar
figure(4); clf; aslmapSergio(rlat65,rlon73,avg_od_liq', [-90 +90],[-180 +180]); caxis([0 +1]*20);   title('Annual Average : OD LIQ 72x64');  colormap(jett); colorbar
figure(5); clf; aslmapSergio(rlat65,rlon73,avg_dme_ice',[-90 +90],[-180 +180]); caxis([0 +1]*50);   title('Annual Average : DME ICE 72x64'); colormap(jett); colorbar
figure(6); clf; aslmapSergio(rlat65,rlon73,avg_dme_liq',[-90 +90],[-180 +180]); caxis([0 +1]*20);   title('Annual Average : DME LIQ 72x64'); colormap(jett); colorbar

figure(7);  clf; aslmapSergio(rlat65,rlon73,trend_cldtop', [-90 +90],[-180 +180]); caxis([-1 +1]*5);    title('Annual Trends : Cldtop  72x64');  colormap(usa2); colorbar
figure(8);  clf; aslmapSergio(rlat65,rlon73,trend_cldfrac',[-90 +90],[-180 +180]); caxis([-1 +1]*0.01); title('Annual Trends : CldFrac 72x64');  colormap(usa2); colorbar
figure(9);  clf; aslmapSergio(rlat65,rlon73,trend_od_ice', [-90 +90],[-180 +180]); caxis([-1 +1]*0.2);  title('Annual Trends : OD ICE  72x64');  colormap(usa2); colorbar
figure(10); clf; aslmapSergio(rlat65,rlon73,trend_od_liq', [-90 +90],[-180 +180]); caxis([-1 +1]*0.2);  title('Annual Trends : OD LIQ  72x64');  colormap(usa2); colorbar
figure(11); clf; aslmapSergio(rlat65,rlon73,trend_dme_ice',[-90 +90],[-180 +180]); caxis([-1 +1]*0.2);  title('Annual Trends : DME ICE  72x64'); colormap(usa2); colorbar
figure(12); clf; aslmapSergio(rlat65,rlon73,trend_dme_liq',[-90 +90],[-180 +180]); caxis([-1 +1]*0.2);  title('Annual Trends : DME LIQ  72x64'); colormap(usa2); colorbar

if iDo_sincosfit > 0
  figure(13); clf; aslmapSergio(rlat65,rlon73,sctrend_od_ice', [-90 +90],[-180 +180]); caxis([-1 +1]*0.5); title('Annual Trends New : OD ICE 72x64'); colormap(usa2); colorbar
  figure(14); clf; aslmapSergio(rlat65,rlon73,sctrend_od_liq', [-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Annual Trends New : OD LIQ 72x64');          colormap(usa2); colorbar
  figure(15); clf; aslmapSergio(rlat65,rlon73,sctrend_cldtop', [-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Annual Trends New : Cldtop 72x64');     colormap(usa2); colorbar
end

frac_od_ice = trend_od_ice./(avg_od_ice + eps);
frac_od_liq = trend_od_liq./(avg_od_liq + eps);
frac_cldtop = trend_cldtop./(avg_cldtop + eps);
figure(13); clf; aslmapSergio(rlat65,rlon73,frac_od_ice', [-90 +90],[-180 +180]); caxis([-1 +1]*0.5); title('Fractional Trends : OD ICE 72x64'); colormap(usa2); colorbar
figure(14); clf; aslmapSergio(rlat65,rlon73,frac_od_liq', [-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Fractional Trends : OD LIQ 72x64');          colormap(usa2); colorbar
figure(15); clf; aslmapSergio(rlat65,rlon73,frac_cldtop', [-90 +90],[-180 +180]); caxis([-1 +1]*0.1); title('Fractional Trends : Cldtop 72x64');     colormap(usa2); colorbar

%%%%%%%%%%%%%%%%%%%%%%%%%
