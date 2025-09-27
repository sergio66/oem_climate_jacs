%% see separate_s_into_asc_desc_quants.m

asc = find(a.asc_flag(ianpts) == 65);  

N = length(asc);
index = asc;

out.name{tt} = fname;

out.asc_lump.mean_lat(tt)      = nanmean(a.lat(index));
out.asc_lump.mean_lon(tt)      = nanmean(a.lon(index));

out.asc_lump.mean_rtime(tt)    = nanmean(a.tai93(index));
[yy,mm,dd] = tai2utcSergio(out.asc_lump.mean_rtime + offset1958_to_1993);
doy = change2days(yy,mm,dd,2002);
out.asc_lump.yy(tt) = yy(tt);     
out.asc_lump.mm(tt) = mm(tt);     
out.asc_lump.dd(tt) = dd(tt);     
out.asc_lump.doy(tt) = doy(tt);  
out.asc_lump.time(tt) = 2002+doy(tt)/365;

out.asc_lump.mean_rad(:,tt)    = nanmean(a.rad(:,index),2);
out.asc_lump.std_rad(:,tt)     = nanstd(a.rad(:,index),[],2);
out.asc_lump.max_rad(:,tt)     = nanmax(a.rad(:,index),[],2);
out.asc_lump.min_rad(:,tt)     = nanmin(a.rad(:,index),[],2);

out.asc_lump.mean_rad_1231(tt) = nanmean(a.rad(1520,index));
out.asc_lump.std_rad_1231(tt)  = nanstd(a.rad(1520,index));
out.asc_lump.max_rad_1231(tt)  = nanmax(a.rad(1520,index));
out.asc_lump.min_rad_1231(tt)  = nanmin(a.rad(1520,index));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X = rad2bt(1231,a.rad(1520,asc)); 
Y = quantile(X,quants);

for qq = 1 : length(quants)-1

  select_Zdata_based_on_iQAX_and_qq %%%% <<<<<<<<<<<<<<<<<<<<< this is the selector >>>>>>>>>>>>>>>>>>>>>>>>
  out.asc_quantile.Z{qq} = asc(Z);

  out.asc_quantile.quantile1231_asc(tt,qq) = Y(qq);
  out.asc_quantile.count_quantile1231_asc(tt,qq) = length(Z);
  if length(Z) >= 2
    out.asc_quantile.rad_asc(tt,qq,:)    = nanmean(a.rad(:,asc(Z)),2);   
    out.asc_quantile.stdrad_asc(tt,qq,:) = nanstd(a.rad(:,asc(Z)),[],2);   
    out.asc_quantile.satzen_quantile1231_asc(tt,qq) = nanmean(a.sat_zen(asc(Z)));
    out.asc_quantile.solzen_quantile1231_asc(tt,qq) = nanmean(a.sol_zen(asc(Z)));
    out.asc_quantile.lat_quantile1231_asc(tt,qq)    = nanmean(a.lat(asc(Z)));
    out.asc_quantile.lon_quantile1231_asc(tt,qq)    = nanmean(a.lon(asc(Z)));
  elseif length(Z) == 1
    out.asc_quantile.rad_asc(tt,qq,:) = a.rad(:,asc(Z));   
    out.asc_quantile.stdrad_asc(tt,qq,:) = 0*a.rad(:,asc(Z));   
    out.asc_quantile.satzen_quantile1231_asc(tt,qq) = a.sat_zen(asc(Z));
    out.asc_quantile.solzen_quantile1231_asc(tt,qq) = a.sol_zen(asc(Z));
    out.asc_quantile.lat_quantile1231_asc(tt,qq) = a.lat(asc(Z));
    out.asc_quantile.lon_quantile1231_asc(tt,qq) = a.lon(asc(Z));
  elseif length(Z) == 0
    out.asc_quantile.rad_asc(tt,qq,:) = NaN;
    out.asc_quantile.stdrad_asc(tt,qq,:) = NaN;
    out.asc_quantile.satzen_quantile1231_asc(tt,qq) = NaN;
    out.asc_quantile.solzen_quantile1231_asc(tt,qq) = NaN;
    out.asc_quantile.lat_quantile1231_asc(tt,qq) = NaN;
    out.asc_quantile.lon_quantile1231_asc(tt,qq) = NaN;
  end

  %if qq == 3
  %  figure(3); clf
  %  plot(a.lon(asc(Z)),a.lat(asc(Z)),'.',out.asc_quantile.lon_quantile1231_asc(tt,qq),out.asc_quantile.lat_quantile1231_asc(tt,qq),'rx'); title([num2str(qq) ' ' num2str(tt)])
  %end
  
end


if iPlot > 0
  figure(2); clf
  plot(2002+doy/365,out.asc_quantile.quantile1231_asc)
  title('BT 1231 ASC Q1-5');

  figure(3); clf
  plot(a.lon(asc(Z)),a.lat(asc(Z)),'.',out.asc_quantile.lon_quantile1231_asc(tt,qq),out.asc_quantile.lat_quantile1231_asc(tt,qq),'rx'); title(num2str(qq))
  
  pause(0.1)
end
