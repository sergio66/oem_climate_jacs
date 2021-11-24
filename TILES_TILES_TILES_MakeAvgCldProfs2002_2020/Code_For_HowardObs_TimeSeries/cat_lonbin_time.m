function y = cat_lonbin_time(yIN,tt,a,iQAX);

%% iQAX = +1,0,-1 == quantile, quantile+extreme, extreme
if nargin < 4
  iQAX = +1;   %% asume quantile
end

y = yIN;
y.comment = a.comment;
y.dbt = a.dbt;          %% for histogram
y.quants = a.quants;    %% for quantiles
y.wnum   = a.wnum; 

y.count_asc(tt) = a.count_asc;
y.lat_asc(tt) = a.lat_asc;
y.lon_asc(tt) = a.lon_asc;

y.solzen_asc(tt) = a.meansolzen_asc;
y.satzen_asc(tt) = a.meansatzen_asc;

y.day_asc(tt) = a.meanday_asc;
y.month_asc(tt) = a.meanmonth_asc;
y.year_asc(tt) = a.meanyear_asc;
y.hour_asc(tt) = a.meanhour_asc;
y.tai93_asc(tt) = a.meantai93_asc;

y.meanBT_asc(tt,:) = rad2bt(a.wnum,a.mean_rad_asc);
y.meanBT1231_asc(tt) = rad2bt(a.wnum(1520),a.mean_rad_asc(1520));
y.maxBT1231_asc(tt)  = a.max1231_asc;
y.minBT1231_asc(tt)  = a.min1231_asc;
y.cntDCCBT1231_asc(tt) = a.DCC1231_asc;

y.hist1231_asc(tt,:) = a.hist_asc;
if iQAX >= 0
  y.quantile1231_asc(tt,:) = a.quantile1231_asc;
  y.rad_quantile_asc(tt,:,:) = a.rad_quantile_asc;   %% OH OH this is RAD
  y.satzen_quantile1231_asc(tt,:) = a.satzen_quantile1231_asc;
  y.solzen_quantile1231_asc(tt,:) = a.solzen_quantile1231_asc;
  y.count_quantile1231_asc(tt,:) = a.count_quantile1231_asc;   %% was initially a mistake, y.count_quantile1231_asc(tt,:) = a.quantile1231_asc;
end
if iQAX <= 0
  y.rad_max_asc(tt,:,:) = a.rad_max_asc(1:16,:);
  y.rad_min_asc(tt,:,:) = a.rad_min_asc(1:16,:);;
  y.rad_blockmax_asc(tt,:) = a.rad_blockmax_asc;
  y.rad_blockmin_asc(tt,:) = a.rad_blockmin_asc;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

y.count_desc(tt) = a.count_desc;
y.lat_desc(tt) = a.lat_desc;
y.lon_desc(tt) = a.lon_desc;

y.solzen_desc(tt) = a.meansolzen_desc;
y.satzen_desc(tt) = a.meansatzen_desc;

y.day_desc(tt) = a.meanday_desc;
y.month_desc(tt) = a.meanmonth_desc;
y.year_desc(tt) = a.meanyear_desc;
y.hour_desc(tt) = a.meanhour_desc;
y.tai93_desc(tt) = a.meantai93_desc;

if iQAX >= 0
  y.meanBT_desc(tt,:) = rad2bt(a.wnum,a.mean_rad_desc);
end
y.meanBT1231_desc(tt) = rad2bt(a.wnum(1520),a.mean_rad_desc(1520));
y.maxBT1231_desc(tt)  = a.max1231_desc;
y.minBT1231_desc(tt)  = a.min1231_desc;
y.cntDCCBT1231_desc(tt) = a.DCC1231_desc;

y.hist1231_desc(tt,:) = a.hist_desc;
if iQAX >= 0
  y.quantile1231_desc(tt,:) = a.quantile1231_desc;
  y.rad_quantile_desc(tt,:,:) = a.rad_quantile_desc;   %% OH OH this is RAD
  y.satzen_quantile1231_desc(tt,:) = a.satzen_quantile1231_desc;
  y.solzen_quantile1231_desc(tt,:) = a.solzen_quantile1231_desc;
  y.count_quantile1231_desc(tt,:) = a.count_quantile1231_desc;   %% was initially a mistake, y.count_quantile1231_desc(tt,:) = a.quantile1231_desc;
end
if iQAX <= 0
  y.rad_max_desc(tt,:,:) = a.rad_max_desc(1:16,:);
  y.rad_min_desc(tt,:,:) = a.rad_min_desc(1:16,:);
  y.rad_blockmax_desc(tt,:) = a.rad_blockmax_desc;
  y.rad_blockmin_desc(tt,:) = a.rad_blockmin_desc;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


