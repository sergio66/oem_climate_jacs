coslat    = cos(ceres.lat*pi/180);
coslatAll = cos(ceres.lat*pi/180) * ones(1,iCnt);

iExist = -1;
if exist('ceres_trend')
  iExist = +1;
else
  disp('doing anomaly ... ')
end

if iExist < 0 
  data = nansum(ceres.lwdata .*  coslat)./nansum(coslat); 
  [B,err,ceres_trend.anom_lw] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
  data = nansum(ceres.swdata .*  coslat)./nansum(coslat); 
  [B,err,ceres_trend.anom_sw] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
  data = nansum(ceres.netdata .*  coslat)./nansum(coslat); 
  [B,err,ceres_trend.anom_net] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
  data = nansum(ceres.solardata .*  coslat)./nansum(coslat); 
  [B,err,ceres_trend.anom_solar] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
  
  for ii = 1 : iCnt; junk = ceres.lwdata(:,ii); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
    [B,err,ceres_trend.anom_lw] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
  for ii = 1 : iCnt; junk = ceres.swdata(:,ii); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
    [B,err,ceres_trend.anom_sw] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
  for ii = 1 : iCnt; junk = ceres.netdata(:,ii); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
    [B,err,ceres_trend.anom_net] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
  for ii = 1 : iCnt; junk = ceres.solardata(:,ii); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
    [B,err,ceres_trend.anom_solar] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
end
  
figure(1); clf; plot(yymm_ceres,ceres_trend.anom_lw,'r',yymm_ceres,ceres_trend.anom_sw,'b',yymm_ceres,ceres_trend.anom_net,'g',yymm_ceres,ceres_trend.anom_solar,'k','linewidth',2); 
plotaxis2; legend('LW','SW','Net','Solar','location','best','fontsize',10); title('CERES allsky flux anomaly')
xlim([floor(min(yymm_ceres)) ceil(max(yymm_ceres))])

%%%%%

if iExist < 0
  data = nansum(ceres.lwdata_clr .*  coslat)./nansum(coslat); 
  [B,err,ceres_trend.anom_lw_clr] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
  data = nansum(ceres.swdata_clr .*  coslat)./nansum(coslat); 
  [B,err,ceres_trend.anom_sw_clr] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
  data = nansum(ceres.netdata_clr .*  coslat)./nansum(coslat); 
  [B,err,ceres_trend.anom_net_clr] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
  
  for ii = 1 : iCnt; junk = ceres.lwdata_clr(:,ii); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
    [B,err,ceres_trend.anom_lw_clr] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
  for ii = 1 : iCnt; junk = ceres.swdata_clr(:,ii); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
    [B,err,ceres_trend.anom_sw_clr] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
  for ii = 1 : iCnt; junk = ceres.netdata_clr(:,ii); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
    [B,err,ceres_trend.anom_net_clr] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
end

figure(2); clf; plot(yymm_ceres,ceres_trend.anom_lw_clr,'r',yymm_ceres,ceres_trend.anom_sw_clr,'b',yymm_ceres,ceres_trend.anom_net_clr,'g','linewidth',2)
plotaxis2; legend('LW','SW','Net','location','best','fontsize',10); title('CERES clrsky flux anomaly')
xlim([floor(min(yymm_ceres)) ceil(max(yymm_ceres))])

%%%%%

if iExist < 0
  data = nansum(ceres.crelwdata .*  coslat)./nansum(coslat); 
  [B,err,ceres_trend.anom_crelw] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
  data = nansum(ceres.creswdata .*  coslat)./nansum(coslat); 
  [B,err,ceres_trend.anom_cresw] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
  data = nansum(ceres.crenetdata .*  coslat)./nansum(coslat); 
  [B,err,ceres_trend.anom_crenet] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
  
  for ii = 1 : iCnt; junk = ceres.crelwdata(:,ii); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
    [B,err,ceres_trend.anom_crelw] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
  for ii = 1 : iCnt; junk = ceres.creswdata(:,ii); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
    [B,err,ceres_trend.anom_cresw] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
  for ii = 1 : iCnt; junk = ceres.crenetdata(:,ii); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
    [B,err,ceres_trend.anom_crenet] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
end

figure(3); clf; plot(yymm_ceres,ceres_trend.anom_crelw,'r',yymm_ceres,ceres_trend.anom_cresw,'b',yymm_ceres,ceres_trend.anom_crenet,'g','linewidth',2)
plotaxis2; legend('LW','SW','Net','location','best','fontsize',10); title('CERES CRE flux anomaly')
xlim([floor(min(yymm_ceres)) ceil(max(yymm_ceres))])

%%%%%

if iExist < 0
  data = nansum(ceres.cldareadata .*  coslat)./nansum(coslat); 
  [B,err,ceres_trend.anom_cldarea] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
  data = nansum(ceres.cldpressdata .*  coslat)./nansum(coslat); 
  [B,err,ceres_trend.anom_cldpress] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
  data = nansum(ceres.cldtempdata .*  coslat)./nansum(coslat); 
  [B,err,ceres_trend.anom_cldtemp] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
  data = nansum(ceres.cldtaudata .*  coslat)./nansum(coslat); 
  [B,err,ceres_trend.anom_cldtau] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
  
  for ii = 1 : iCnt; junk = ceres.cldareadata(:,ii); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
    [B,err,ceres_trend.anom_cldarea] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
  for ii = 1 : iCnt; junk = ceres.cldpressdata(:,ii); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
    [B,err,ceres_trend.anom_cldpress] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
  for ii = 1 : iCnt; junk = ceres.cldtempdata(:,ii); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
    [B,err,ceres_trend.anom_cldtemp] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
  for ii = 1 : iCnt; junk = ceres.cldtaudata(:,ii); boo = find(isfinite(junk)); data(ii) = nansum(junk(boo).*coslat(boo))/sum(coslat(boo)); end
    [B,err,ceres_trend.anom_cldtau] = compute_anomaly_wrapper(1:iCnt,dayOFtime,data,4,-1,-1);
end
  
figure(4); clf; plot(yymm_ceres,ceres_trend.anom_cldtau*10,'r',yymm_ceres,ceres_trend.anom_cldarea,'b',yymm_ceres,ceres_trend.anom_cldtemp,'g',yymm_ceres,ceres_trend.anom_cldpress/10,'k','linewidth',2)
plotaxis2; legend('\tau * 10','area','Temp','Press/10','location','best','fontsize',10); title('CERES Cloud anomaly')
xlim([floor(min(yymm_ceres)) ceil(max(yymm_ceres))])

%%%%%%%%%%%%%%%%%%%%%%%%%

figure(5); clf; 
plot(yymm_ceres,ceres_trend.anom_net,'b',yymm_ceres,-(ceres_trend.anom_lw + ceres_trend.anom_sw),'b--',...
     yymm_ceres,ceres_trend.anom_net_clr,'r',yymm_ceres,-(ceres_trend.anom_lw_clr + ceres_trend.anom_sw_clr),'r--'); xlim([2020 2025])
plot(yymm_ceres,-ceres_trend.anom_crelw,'b.',yymm_ceres,ceres_trend.anom_lw - ceres_trend.anom_lw_clr,'b--',...
     yymm_ceres,-ceres_trend.anom_cresw,'r.',yymm_ceres,ceres_trend.anom_sw -ceres_trend.anom_sw_clr,'r--'); xlim([2020 2025])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iExist < 0
  disp('doing zonal average timeseries trends ... 180 bins')
  for ii = 1 : 180
    if mod(ii,100) == 0 
      fprintf(1,'+')
    elseif mod(ii,10) == 0 
      fprintf(1,'.')
    end
  
    data = ceres.lwdata(ii,:);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats] = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      ceres_trend.trend_lw(ii) = B(2);  
      ceres_trend.trend_lw_err(ii) = stats.se(2);
    else
      ceres_trend.trend_lw(ii) = NaN;
      ceres_trend.trend_lw_err(ii) = NaN;
    end
  
    data = ceres.swdata(ii,:);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats] = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      ceres_trend.trend_sw(ii) = B(2);  
      ceres_trend.trend_sw_err(ii) = stats.se(2);
    else
      ceres_trend.trend_sw(ii) = NaN;
      ceres_trend.trend_sw_err(ii) = NaN;
    end
  
    data = ceres.netdata(ii,:);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats] = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      ceres_trend.trend_net(ii) = B(2);  
      ceres_trend.trend_net_err(ii) = stats.se(2);
    else
      ceres_trend.trend_net(ii) = NaN;
      ceres_trend.trend_net_err(ii) = NaN;
    end
  
    %%%%%%%%%%%%%%%%%%%%%%%%%
  
    data = ceres.lwdata_clr(ii,:);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats] = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      ceres_trend.trend_lw_clr(ii) = B(2);  
      ceres_trend.trend_lw_clr_err(ii) = stats.se(2);
    else
      ceres_trend.trend_lw_clr(ii) = NaN;
      ceres_trend.trend_lw_clr_err(ii) = NaN;
    end
  
    data = ceres.swdata_clr(ii,:);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats] = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      ceres_trend.trend_sw_clr(ii) = B(2);  
      ceres_trend.trend_sw_clr_err(ii) = stats.se(2);
    else
      ceres_trend.trend_sw_clr(ii) = NaN;
      ceres_trend.trend_sw_clr_err(ii) = NaN;
    end
  
    data = ceres.netdata_clr(ii,:);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats] = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      ceres_trend.trend_net_clr(ii) = B(2);  
      ceres_trend.trend_net_clr_err(ii) = stats.se(2);
    else
      ceres_trend.trend_net_clr(ii) = NaN;
      ceres_trend.trend_net_clr_err(ii) = NaN;
    end
  
    %%%%%%%%%%%%%%%%%%%%%%%%%
    data = ceres.crelwdata(ii,:);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats] = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      ceres_trend.trend_crelw(ii) = B(2);  
      ceres_trend.trend_crelw_err(ii) = stats.se(2);
    else
      ceres_trend.trend_crelw(ii) = NaN;
      ceres_trend.trend_crelw_err(ii) = NaN;
    end
  
    data = ceres.creswdata(ii,:);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats] = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      ceres_trend.trend_cresw(ii) = B(2);  
      ceres_trend.trend_cresw_err(ii) = stats.se(2);
    else
      ceres_trend.trend_cresw(ii) = NaN;
      ceres_trend.trend_cresw_err(ii) = NaN;
    end
  
    data = ceres.crenetdata(ii,:);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats] = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      ceres_trend.trend_crenet(ii) = B(2);  
      ceres_trend.trend_crenet_err(ii) = stats.se(2);
    else
      ceres_trend.trend_crenet(ii) = NaN;
      ceres_trend.trend_crenet_err(ii) = NaN;
    end
  
    %%%%%%%%%%%%%%%%%%%%%%%%%
  
    data = ceres.solardata(ii,:);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats] = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      ceres_trend.trend_solar(ii) = B(2);  
      ceres_trend.trend_solar_err(ii) = stats.se(2);
    else
      ceres_trend.trend_solar(ii) = NaN;
      ceres_trend.trend_solar_err(ii) = NaN;
    end
  
    data = ceres.cldareadata(ii,:);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats] = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      ceres_trend.trend_cldarea(ii) = B(2);  
      ceres_trend.trend_cldarea_err(ii) = stats.se(2);
    else
      ceres_trend.trend_cldarea(ii) = NaN;
      ceres_trend.trend_cldarea_err(ii) = NaN;
    end
  
    data = ceres.cldpressdata(ii,:);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats] = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      ceres_trend.trend_cldpress(ii) = B(2);  
      ceres_trend.trend_cldpress_err(ii) = stats.se(2);
    else
      ceres_trend.trend_cldpress(ii) = NaN;
      ceres_trend.trend_cldpress_err(ii) = NaN;
    end
  
    data = ceres.cldtempdata(ii,:);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats] = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      ceres_trend.trend_cldtemp(ii) = B(2);  
      ceres_trend.trend_cldtemp_err(ii) = stats.se(2);
    else
      ceres_trend.trend_cldtemp(ii) = NaN;
      ceres_trend.trend_cldtemp_err(ii) = NaN;
    end
  
    data = ceres.cldtaudata(ii,:);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats] = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      ceres_trend.trend_cldtau(ii) = B(2);  
      ceres_trend.trend_cldtau_err(ii) = stats.se(2);
    else
      ceres_trend.trend_cldtau(ii) = NaN;
      ceres_trend.trend_cldtau_err(ii) = NaN;
    end
  end  
end
fprintf(1,'\n')

%%%%%%%%%%%%%%%%%%%%%%%%%
if iExist < 0
  disp('doing 4608 tiles timeseries trends and anomalies ... ')
  for ii = 1 : 4608
    if mod(ii,1000) == 0 
      fprintf(1,'+')
    elseif mod(ii,100) == 0 
      fprintf(1,'.')
    end
  
    data = ceres.solar_4608_center(:,ii);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats]      = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      [B, stats,anom] = compute_anomaly_wrapper(boo,dayOFtime,data,4,4,-1,-1);
      ceres_trend.anom_solar_4608(ii,:) = anom;
      ceres_trend.trend_solar_4608(ii) = B(2);  
      ceres_trend.trend_solar_4608_err(ii) = stats.se(2);
    else
      ceres_trend.anom_solar_4608(ii,:) = NaN;
      ceres_trend.trend_solar_4608(ii) = NaN;
      ceres_trend.trend_solar_4608_err(ii) = NaN;
    end
  
    %%%%%%%%%%%%%%%%%%%%%%%%%
  
    data = ceres.cldarea_total_daynight_4608_center(:,ii);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats]      = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      [B, stats,anom] = compute_anomaly_wrapper(boo,dayOFtime,data,4,4,-1,-1);
      ceres_trend.anom_cldarea_total_daynight_4608(ii,:) = anom;
      ceres_trend.trend_cldarea_total_daynight_4608(ii) = B(2);  
      ceres_trend.trend_cldarea_total_daynight_4608_err(ii) = stats.se(2);
    else
      ceres_trend.anom_cldarea_total_daynight_4608(ii,:) = NaN;
      ceres_trend.trend_cldarea_total_daynight_4608(ii) = NaN;
      ceres_trend.trend_cldarea_total_daynight_4608_err(ii) = NaN;
    end
  
    data = ceres.cldpress_total_daynight_4608_center(:,ii);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats]      = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      [B, stats,anom] = compute_anomaly_wrapper(boo,dayOFtime,data,4,4,-1,-1);
      ceres_trend.anom_cldpress_total_daynight_4608(ii,:) = anom;
      ceres_trend.trend_cldpress_total_daynight_4608(ii) = B(2);  
      ceres_trend.trend_cldpress_total_daynight_4608_err(ii) = stats.se(2);
    else
      ceres_trend.anom_cldpress_total_daynight_4608(ii,:) = NaN;
      ceres_trend.trend_cldpress_total_daynight_4608(ii) = NaN;
      ceres_trend.trend_cldpress_total_daynight_4608_err(ii) = NaN;
    end
  
    data = ceres.cldtemp_total_daynight_4608_center(:,ii);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats]      = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      [B, stats,anom] = compute_anomaly_wrapper(boo,dayOFtime,data,4,4,-1,-1);
      ceres_trend.anom_cldtemp_total_daynight_4608(ii,:) = anom;
      ceres_trend.trend_cldtemp_total_daynight_4608(ii) = B(2);  
      ceres_trend.trend_cldtemp_total_daynight_4608_err(ii) = stats.se(2);
    else
      ceres_trend.anom_cldtemp_total_daynight_4608(ii,:) = NaN;
      ceres_trend.trend_cldtemp_total_daynight_4608(ii) = NaN;
      ceres_trend.trend_cldtemp_total_daynight_4608_err(ii) = NaN;
    end
  
    data = ceres.cldtau_total_day_4608_center(:,ii);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats]      = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      [B, stats,anom] = compute_anomaly_wrapper(boo,dayOFtime,data,4,4,-1,-1);
      ceres_trend.anom_cldtau_total_daynight_4608(ii,:) = anom;
      ceres_trend.trend_cldtau_total_day_4608(ii) = B(2);  
      ceres_trend.trend_cldtau_total_day_4608_err(ii) = stats.se(2);
    else
      ceres_trend.anom_cldtau_total_daynight_4608(ii,:) = NaN;
      ceres_trend.trend_cldtau_total_day_4608(ii) = NaN;
      ceres_trend.trend_cldtau_total_day_4608_err(ii) = NaN;
    end
  
    %%%%%%%%%%%%%%%%%%%%%%%%%
  
    data = ceres.toa_lw_all_4608_center(:,ii);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats]      = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      [B, stats,anom] = compute_anomaly_wrapper(boo,dayOFtime,data,4,4,-1,-1);
      ceres_trend.anom_toa_lw_all_4608(ii,:) = anom;
      ceres_trend.trend_toa_lw_all_4608(ii) = B(2);  
      ceres_trend.trend_toa_lw_all_4608_err(ii) = stats.se(2);
    else
      ceres_trend.anom_toa_lw_all_4608(ii,:) = NaN;
      ceres_trend.trend_toa_lw_all_4608(ii) = NaN;
      ceres_trend.trend_toa_lw_all_4608_err(ii) = NaN;
    end
  
    data = ceres.toa_sw_all_4608_center(:,ii);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats]      = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      [B, stats,anom] = compute_anomaly_wrapper(boo,dayOFtime,data,4,4,-1,-1);
      ceres_trend.anom_toa_sw_all_4608(ii,:) = anom;
      ceres_trend.trend_toa_sw_all_4608(ii) = B(2);  
      ceres_trend.trend_toa_sw_all_4608_err(ii) = stats.se(2);
    else
      ceres_trend.anom_toa_sw_all_4608(ii,:) = NaN;
      ceres_trend.trend_toa_sw_all_4608(ii) = NaN;
      ceres_trend.trend_toa_sw_all_4608_err(ii) = NaN;
    end
  
    data = ceres.toa_net_all_4608_center(:,ii);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats]      = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      [B, stats,anom] = compute_anomaly_wrapper(boo,dayOFtime,data,4,4,-1,-1);
      ceres_trend.anom_toa_net_all_4608(ii,:) = anom;
      ceres_trend.trend_toa_net_all_4608(ii) = B(2);  
      ceres_trend.trend_toa_net_all_4608_err(ii) = stats.se(2);
    else
      ceres_trend.anom_toa_net_all_4608(ii,:) = NaN;
      ceres_trend.trend_toa_net_all_4608(ii) = NaN;
      ceres_trend.trend_toa_net_all_4608_err(ii) = NaN;
    end
  
    %%%%%%%%%%%%%%%%%%%%%%%%%
  
    data = ceres.toa_lw_clr_c_4608_center(:,ii);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats]      = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      [B, stats,anom] = compute_anomaly_wrapper(boo,dayOFtime,data,4,4,-1,-1);
      ceres_trend.anom_toa_lw_clr_c_4608(ii,:) = anom;
      ceres_trend.trend_toa_lw_clr_c_4608(ii) = B(2);  
      ceres_trend.trend_toa_lw_clr_c_4608_err(ii) = stats.se(2);
    else
      ceres_trend.anom_toa_lw_clr_c_4608(ii,:) = NaN;
      ceres_trend.trend_toa_lw_clr_c_4608(ii) = NaN;
      ceres_trend.trend_toa_lw_clr_c_4608_err(ii) = NaN;
    end
  
    data = ceres.toa_sw_clr_c_4608_center(:,ii);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats]      = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      [B, stats,anom] = compute_anomaly_wrapper(boo,dayOFtime,data,4,4,-1,-1);
      ceres_trend.anom_toa_sw_clr_c_4608(ii,:) = anom;
      ceres_trend.trend_toa_sw_clr_c_4608(ii) = B(2);  
      ceres_trend.trend_toa_sw_clr_c_4608_err(ii) = stats.se(2);
    else
      ceres_trend.anom_toa_ww_clr_c_4608(ii,:) = NaN;
      ceres_trend.trend_toa_sw_clr_c_4608(ii) = NaN;
      ceres_trend.trend_toa_sw_clr_c_4608_err(ii) = NaN;
    end
  
    data = ceres.toa_net_clr_c_4608_center(:,ii);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats]      = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      [B, stats,anom] = compute_anomaly_wrapper(boo,dayOFtime,data,4,4,-1,-1);
      ceres_trend.anom_toa_net_clr_c_4608(ii,:) = anom;
      ceres_trend.trend_toa_net_clr_c_4608(ii) = B(2);  
      ceres_trend.trend_toa_net_clr_c_4608_err(ii) = stats.se(2);
    else
      ceres_trend.anom_toa_net_clr_c_4608(ii,:) = NaN;
      ceres_trend.trend_toa_net_clr_c_4608(ii) = NaN;
      ceres_trend.trend_toa_net_clr_c_4608_err(ii) = NaN;
    end
  
    %%%%%%%%%%%%%%%%%%%%%%%%%
  
    data = ceres.toa_lw_clr_t_4608_center(:,ii);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats]      = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      [B, stats,anom] = compute_anomaly_wrapper(boo,dayOFtime,data,4,4,-1,-1);
      ceres_trend.anom_toa_lw_clr_t_4608(ii,:) = anom;
      ceres_trend.trend_toa_lw_clr_t_4608(ii) = B(2);  
      ceres_trend.trend_toa_lw_clr_t_4608_err(ii) = stats.se(2);
    else
      ceres_trend.anom_toa_lw_clr_t_4608(ii,:) = NaN;
      ceres_trend.trend_toa_lw_clr_t_4608(ii) = NaN;
      ceres_trend.trend_toa_lw_clr_t_4608_err(ii) = NaN;
    end
  
    data = ceres.toa_sw_clr_t_4608_center(:,ii);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats]      = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      [B, stats,anom] = compute_anomaly_wrapper(boo,dayOFtime,data,4,4,-1,-1);
      ceres_trend.anom_toa_sw_clr_t_4608(ii,:) = anom;
      ceres_trend.trend_toa_sw_clr_t_4608(ii) = B(2);  
      ceres_trend.trend_toa_sw_clr_t_4608_err(ii) = stats.se(2);
    else
      ceres_trend.anom_toa_sw_clr_t_4608(ii,:) = NaN;
      ceres_trend.trend_toa_sw_clr_t_4608(ii) = NaN;
      ceres_trend.trend_toa_sw_clr_t_4608_err(ii) = NaN;
    end
  
    data = ceres.toa_net_clr_t_4608_center(:,ii);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats]      = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      [B, stats,anom] = compute_anomaly_wrapper(boo,dayOFtime,data,4,4,-1,-1);
      ceres_trend.anom_toa_net_clr_t_4608(ii,:) = anom;
      ceres_trend.trend_toa_net_clr_t_4608(ii) = B(2);  
      ceres_trend.trend_toa_net_clr_t_4608_err(ii) = stats.se(2);
    else
      ceres_trend.anom_toa_net_clr_t_4608(ii,:) = NaN;
      ceres_trend.trend_toa_net_clr_t_4608(ii) = NaN;
      ceres_trend.trend_toa_net_clr_t_4608_err(ii) = NaN;
    end
  
    %%%%%%%%%%%%%%%%%%%%%%%%%
  
    data = ceres.toa_cre_net_4608_center(:,ii);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats]      = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      [B, stats,anom] = compute_anomaly_wrapper(boo,dayOFtime,data,4,4,-1,-1);
      ceres_trend.anom_toa_cre_net_4608(ii,:) = NaN;
      ceres_trend.trend_toa_cre_net_4608(ii) = B(2);  
      ceres_trend.trend_toa_cre_net_4608_err(ii) = stats.se(2);
    else
      ceres_trend.anom_toa_cre_net_4608(ii,:) = NaN;
      ceres_trend.trend_toa_cre_net_4608(ii) = NaN;
      ceres_trend.trend_toa_cre_net_4608_err(ii) = NaN;
    end
  
    data = ceres.toa_cre_lw_4608_center(:,ii);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats]      = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      [B, stats,anom] = compute_anomaly_wrapper(boo,dayOFtime,data,4,4,-1,-1);
      ceres_trend.anom_toa_cre_lw_4608(ii,:) = NaN;
      ceres_trend.trend_toa_cre_lw_4608(ii) = B(2);  
      ceres_trend.trend_toa_cre_lw_4608_err(ii) = stats.se(2);
    else
      ceres_trend.anom_toa_cre_lw_4608(ii,:) = NaN;
      ceres_trend.trend_toa_cre_lw_4608(ii) = NaN;
      ceres_trend.trend_toa_cre_lw_4608_err(ii) = NaN;
    end
  
    data = ceres.toa_cre_sw_4608_center(:,ii);
    boo = find(isfinite(data));
    if length(boo) > 20
      [B, stats]      = Math_tsfit_lin_robust(dayOFtime(boo),data(boo),4);
      [B, stats,anom] = compute_anomaly_wrapper(boo,dayOFtime,data,4,4,-1,-1);
      ceres_trend.anom_toa_cre_sw_4608(ii,:) = NaN;
      ceres_trend.trend_toa_cre_sw_4608(ii) = B(2);  
      ceres_trend.trend_toa_cre_sw_4608_err(ii) = stats.se(2);
    else
      ceres_trend.anom_toa_cre_sw_4608(ii,:) = NaN;
      ceres_trend.trend_toa_cre_sw_4608(ii) = NaN;
      ceres_trend.trend_toa_cre_sw_4608_err(ii) = NaN;
    end
  end  
end
fprintf(1,'\n')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ceres_trend.lat = ceres.lat;
ceres_trend.lon = ceres.lon;
plot(ceres_trend.lat,ceres_trend.trend_lw,ceres_trend.lat,ceres_trend.trend_lw_clr,'linewidth',2); plotaxis2; hl = legend('allsky','clrsky','location','best');
xlabel('Latitude'); ylabel('Trend'); title('W/m2/K/yr')

if iExist < 0
  ceres_trend.fnameA           = ceres_fnameA;
  ceres_trend.fnameB           = ceres_fnameB;
end

find_ceres_trends_from_anom_slopes

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% zonal
%{
ceres_trend.trend_lw         = trend_ceres.lw;
ceres_trend.trend_lw_err     = trend_ceres.lw_err;
ceres_trend.trend_sw         = trend_ceres.sw;
ceres_trend.trend_sw_err     = trend_ceres.sw_err;
ceres_trend.trend_net        = trend_ceres.net;
ceres_trend.trend_net_err    = trend_ceres.net_err;

ceres_trend.trend_lw_clr      = trend_ceres.lw_clr;
ceres_trend.trend_lw_clr_err  = trend_ceres.lw_clr_err;
ceres_trend.trend_sw_clr      = trend_ceres.sw_clr;
ceres_trend.trend_sw_clr_err  = trend_ceres.sw_clr_err;
ceres_trend.trend_net_clr     = trend_ceres.net_clr;
ceres_trend.trend_net_clr_err = trend_ceres.net_clr_err;

ceres_trend.trend_crelw      = trend_ceres.crelw;
ceres_trend.trend_crelw_err  = trend_ceres.crelw_err;
ceres_trend.trend_cresw      = trend_ceres.cresw;
ceres_trend.trend_cresw_err  = trend_ceres.sw_clr_err;
ceres_trend.trend_crenet     = trend_ceres.crenet;
ceres_trend.trend_crenet_err = trend_ceres.crenet_err;

ceres_trend.trend_solar        = trend_ceres.solar;
ceres_trend.trend_solar_err    = trend_ceres.solar_err;
ceres_trend.trend_cldarea      = trend_ceres.cldarea;
ceres_trend.trend_cldarea_err  = trend_ceres.cldarea_err;
ceres_trend.trend_cldpress     = trend_ceres.cldpress;
ceres_trend.trend_cldpress_err = trend_ceres.cldpress_err;
ceres_trend.trend_cldtemp      = trend_ceres.cldtemp;
ceres_trend.trend_cldtemp_err  = trend_ceres.cldtemp_err;
ceres_trend.trend_cldtau       = trend_ceres.cldtau;
ceres_trend.trend_cldtau_err   = trend_ceres.cldtau_err;

%% 4608
%ceres_trend.trend_toa_lw_all_4608     = trend_ceres_toa_lw_all_4608;
%ceres_trend.trend_toa_lw_all_4608_err = trend_ceres_toa_lw_all_4608_err;
%ceres_trend.trend_toa_lw_clr_4608     = trend_ceres_toa_lw_clr_4608;
%ceres_trend.trend_toa_lw_clr_4608_err = trend_ceres_toa_lw_clr_4608_err;
%}
