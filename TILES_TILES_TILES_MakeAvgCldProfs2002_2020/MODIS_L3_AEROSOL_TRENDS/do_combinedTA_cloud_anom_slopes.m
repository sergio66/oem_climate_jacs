yymmSlope = 2002.0;
yymmSlope = 2020.5;
%yymmSlope = 2022.5;

fprintf(1,'doing slopes of cloud anomalies starting %8.2f \n',yymmSlope)

for ii = 1 : 180
  data = xavg_zonal_anom_cldfrac(ii,:);
  boo = find(isfinite(data));
  boo = find(isfinite(data) & yymm >= yymmSlope);
  P = polyfit(yymm(boo)-yymm(boo(1)),data(boo),1);
  slope_xavg_zonal_anom_cldfrac(ii) = P(1);

  data = xavg_zonal_anom_cldfracHi(ii,:);
  boo = find(isfinite(data));
  boo = find(isfinite(data) & yymm >= yymmSlope);
  P = polyfit(yymm(boo)-yymm(boo(1)),data(boo),1);
  slope_xavg_zonal_anom_cldfracHi(ii) = P(1);

  data = xavg_zonal_anom_cldfracMid(ii,:);
  boo = find(isfinite(data));
  boo = find(isfinite(data) & yymm >= yymmSlope);
  P = polyfit(yymm(boo)-yymm(boo(1)),data(boo),1);
  slope_xavg_zonal_anom_cldfracMid(ii) = P(1);

  data = xavg_zonal_anom_cldfracLo(ii,:);
  boo = find(isfinite(data));
  boo = find(isfinite(data) & yymm >= yymmSlope);
  P = polyfit(yymm(boo)-yymm(boo(1)),data(boo),1);
  slope_xavg_zonal_anom_cldfracLo(ii) = P(1);

  data = xavg_zonal_anom_cldtop(ii,:);
  boo = find(isfinite(data));
  boo = find(isfinite(data) & yymm >= yymmSlope);
  P = polyfit(yymm(boo)-yymm(boo(1)),data(boo),1);
  slope_xavg_zonal_anom_cldtop(ii) = P(1);

  data = xavg_zonal_anom_od_ice(ii,:);
  boo = find(isfinite(data));
  boo = find(isfinite(data) & yymm >= yymmSlope);
  P = polyfit(yymm(boo)-yymm(boo(1)),data(boo),1);
  slope_xavg_zonal_anom_od_ice(ii) = P(1);

  data = xavg_zonal_anom_od_water(ii,:);
  boo = find(isfinite(data));
  boo = find(isfinite(data) & yymm >= yymmSlope);
  P = polyfit(yymm(boo)-yymm(boo(1)),data(boo),1);
  slope_xavg_zonal_anom_od_water(ii) = P(1);
end

figure(22);
plot(modis_lat,slope_xavg_zonal_anom_cldfrac,modis_lat,slope_xavg_zonal_anom_cldfracHi,...
     modis_lat,slope_xavg_zonal_anom_cldfracMid,modis_lat,slope_xavg_zonal_anom_cldfracLo,'kx-','linewidth',2);
plotaxis2; ylabel('Trend CldFrac'); legend('Avg','Hi','Mid','Lo','location','best');
title(['Anomaly --> Trends since ' num2str(yymmSlope)])

plot(modis_lat,cos(modis_lat*pi/180).*slope_xavg_zonal_anom_cldfrac,modis_lat,cos(modis_lat*pi/180).*slope_xavg_zonal_anom_cldfracHi,...
     modis_lat,cos(modis_lat*pi/180).*slope_xavg_zonal_anom_cldfracMid,modis_lat,cos(modis_lat*pi/180).*slope_xavg_zonal_anom_cldfracLo,'kx-','linewidth',2);
plotaxis2; ylabel('Trend Cos(lat)*CldFrac'); legend('Avg','Hi','Mid','Lo','location','best');
title(['Anomaly --> Trends since ' num2str(yymmSlope)])

%%%%%%%%%%%%%%%%%%%%%%%%%

modis_lat = unique(a.summary.Latitude)';
figure(22);
plot(modis_lat,cos(modis_lat*pi/180).*slope_xavg_zonal_anom_cldfrac,modis_lat,cos(modis_lat*pi/180).*slope_xavg_zonal_anom_cldfracHi,...
     modis_lat,cos(modis_lat*pi/180).*slope_xavg_zonal_anom_cldfracMid,modis_lat,cos(modis_lat*pi/180).*slope_xavg_zonal_anom_cldfracLo,'kx-','linewidth',2);
plotaxis2; ylabel('Trend Cos(lat)*CldFrac'); legend('Avg','Hi','Mid','Lo','location','best');
title(['Anomaly --> Trends since ' num2str(yymmSlope)])

figure(23);
plot(modis_lat,cos(modis_lat*pi/180).*slope_xavg_zonal_anom_cldtop/10,'k',...
     modis_lat,cos(modis_lat*pi/180).*slope_xavg_zonal_anom_od_water,'b',modis_lat,cos(modis_lat*pi/180).*slope_xavg_zonal_anom_od_ice,'r','linewidth',2);
plotaxis2; ylabel('Trend Cos(lat)*CldFrac'); legend('CldTop/10','OD water','OD ice','location','best');
title(['Anomaly --> Trends since ' num2str(yymmSlope)])
