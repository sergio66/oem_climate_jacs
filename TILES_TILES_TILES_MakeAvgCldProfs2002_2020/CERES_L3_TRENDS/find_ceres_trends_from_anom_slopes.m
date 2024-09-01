if ~exist('yymm_ceres')
  yymm_ceres = thetime.yymm;
  do_XX_YY_from_X_Y
end

yymmSlope = 2002.0;
yymmSlope = 2020.5;
%yymmSlope = 2022.5;

for ii = 1 : 4608
  data = ceres_trend.anom_solar_4608(ii,:);
  boo = find(isfinite(data));
  boo = find(isfinite(data) & yymm_ceres >= yymmSlope);
  P = polyfit(yymm_ceres(boo),data(boo),1);
  slope_anom_solar(ii) = P(1);

  data = ceres_trend.anom_cldarea_total_daynight_4608(ii,:);
  boo = find(isfinite(data));
  boo = find(isfinite(data) & yymm_ceres >= yymmSlope);
  P = polyfit(yymm_ceres(boo),data(boo),1);
  slope_anom_cldarea(ii) = P(1);

  data = ceres_trend.anom_cldpress_total_daynight_4608(ii,:);
  boo = find(isfinite(data));
  boo = find(isfinite(data) & yymm_ceres >= yymmSlope);
  P = polyfit(yymm_ceres(boo),data(boo),1);
  slope_anom_cldpress(ii) = P(1);

  data = ceres_trend.anom_cldtemp_total_daynight_4608(ii,:);
  boo = find(isfinite(data));
  boo = find(isfinite(data) & yymm_ceres >= yymmSlope);
  P = polyfit(yymm_ceres(boo),data(boo),1);
  slope_anom_cldtemp(ii) = P(1);

  data = ceres_trend.anom_cldtau_total_daynight_4608(ii,:);
  boo = find(isfinite(data));
  boo = find(isfinite(data) & yymm_ceres >= yymmSlope);
  P = polyfit(yymm_ceres(boo),data(boo),1);
  slope_anom_cldtau(ii) = P(1);

  %%%%%%%%%%%%%%%%%%%%%%%%%

  data = ceres_trend.anom_toa_lw_all_4608(ii,:);
  boo = find(isfinite(data));
  boo = find(isfinite(data) & yymm_ceres >= yymmSlope);
  P = polyfit(yymm_ceres(boo),data(boo),1);
  slope_anom_toa_lw(ii) = P(1);

  data = ceres_trend.anom_toa_sw_all_4608(ii,:);
  boo = find(isfinite(data));
  boo = find(isfinite(data) & yymm_ceres >= yymmSlope);
  P = polyfit(yymm_ceres(boo),data(boo),1);
  slope_anom_toa_sw(ii) = P(1);

  data = ceres_trend.anom_toa_net_all_4608(ii,:);
  boo = find(isfinite(data));
  boo = find(isfinite(data) & yymm_ceres >= yymmSlope);
  P = polyfit(yymm_ceres(boo),data(boo),1);
  slope_anom_toa_net(ii) = P(1);

  data = ceres_trend.anom_toa_lw_clr_c_4608(ii,:);
  boo = find(isfinite(data));
  boo = find(isfinite(data) & yymm_ceres >= yymmSlope);
  P = polyfit(yymm_ceres(boo),data(boo),1);
  slope_anom_toa_lw_clr(ii) = P(1);

  data = ceres_trend.anom_toa_sw_clr_c_4608(ii,:);
  boo = find(isfinite(data));
  boo = find(isfinite(data) & yymm_ceres >= yymmSlope);
  P = polyfit(yymm_ceres(boo),data(boo),1);
  slope_anom_toa_sw_clr(ii) = P(1);

  data = ceres_trend.anom_toa_net_clr_c_4608(ii,:);
  boo = find(isfinite(data));
  boo = find(isfinite(data) & yymm_ceres >= yymmSlope);
  P = polyfit(yymm_ceres(boo),data(boo),1);
  slope_anom_toa_net_clr(ii) = P(1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(22); clf
plot(YY,slope_anom_cldarea,YY,slope_anom_cldpress/10,YY,slope_anom_cldtemp,YY,slope_anom_cldtau,'linewidth',2);

figure(22); clf
plot(rlat,nanmean(reshape(slope_anom_cldarea,72,64),1),rlat,nanmean(reshape(slope_anom_cldpress,72,64),1)/10,...
     rlat,nanmean(reshape(slope_anom_cldtemp,72,64),1),rlat,nanmean(reshape(slope_anom_cldtau,72,64),1),'linewidth',2);
plotaxis2;
hl = legend('CldFrac','CldPress/10','CldTemp','CldTau','location','best','fontsize',10); title(['CERES anomalies --> trends \newline Since ' num2str(yymmSlope)]);
ylim([-1 +1]*0.1)
set(gca,'fontsize',10)

figure(22); clf
plot(rlat,cos(rlat'*pi/180).*nanmean(reshape(slope_anom_cldarea,72,64),1),'kx-',rlat,cos(rlat'*pi/180).*nanmean(reshape(slope_anom_cldpress,72,64),1)/10,...
     rlat,cos(rlat'*pi/180).*nanmean(reshape(slope_anom_cldtemp,72,64),1),rlat,cos(rlat'*pi/180).*nanmean(reshape(slope_anom_cldtau,72,64),1),'linewidth',2);
plotaxis2;
hl = legend('CldFrac','CldPress/10','CldTemp','CldTau','location','best'); title(['CERES anomalies --> trends cos(lat)*Param \newline Since ' num2str(yymmSlope)]);
%ylim([-1 +1]*0.1)
set(gca,'fontsize',10)

figure(23); clf
plot(rlat,cos(rlat'*pi/180).*nanmean(reshape(slope_anom_toa_net_clr,72,64),1),'k',...
     rlat,cos(rlat'*pi/180).*nanmean(reshape(slope_anom_toa_lw_clr,72,64),1),'r',rlat,cos(rlat'*pi/180).*nanmean(reshape(slope_anom_toa_sw_clr,72,64),1),'b','linewidth',2);
plotaxis2;
hl = legend('Net TOA Clr','LW Clr','SW Clr','location','best'); title(['CERES anomalies --> trends cos(lat)*Param \newline Since ' num2str(yymmSlope)]);
%ylim([-1 +1]*0.1)
set(gca,'fontsize',10)
