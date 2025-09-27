%% see separate_s_into_asc_desc_quants.m

desc = find(a.asc_flag(ianpts) == 68);  

N = length(desc);
index = desc;

out.name{tt} = fname;

out.desc_lump.mean_lat(tt)      = nanmean(a.lat(index));
out.desc_lump.mean_lon(tt)      = nanmean(a.lon(index));

out.desc_lump.mean_rtime(tt)    = nanmean(a.tai93(index));
[yy,mm,dd] = tai2utcSergio(out.desc_lump.mean_rtime + offset1958_to_1993);
doy = change2days(yy,mm,dd,2002);
out.desc_lump.yy(tt) = yy(tt);     
out.desc_lump.mm(tt) = mm(tt);     
out.desc_lump.dd(tt) = dd(tt);     
out.desc_lump.doy(tt) = doy(tt);  
out.desc_lump.time(tt) = 2002+doy(tt)/365;

out.desc_lump.mean_rad(:,tt)    = nanmean(a.rad(:,index),2);
out.desc_lump.std_rad(:,tt)     = nanstd(a.rad(:,index),[],2);
out.desc_lump.max_rad(:,tt)     = nanmax(a.rad(:,index),[],2);
out.desc_lump.min_rad(:,tt)     = nanmin(a.rad(:,index),[],2);

out.desc_lump.mean_rad_1231(tt) = nanmean(a.rad(1520,index));
out.desc_lump.std_rad_1231(tt)  = nanstd(a.rad(1520,index));
out.desc_lump.max_rad_1231(tt)  = nanmax(a.rad(1520,index));
out.desc_lump.min_rad_1231(tt)  = nanmin(a.rad(1520,index));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X = rad2bt(1231,a.rad(1520,desc)); 
Y = quantile(X,quants);

for qq = 1 : length(quants)-1

  select_Zdata_based_on_iQAX_and_qq %%%% <<<<<<<<<<<<<<<<<<<<< this is the selector >>>>>>>>>>>>>>>>>>>>>>>>
  out.desc_quantile.Z{qq} = desc(Z);

  out.desc_quantile.quantile1231_desc(tt,qq) = Y(qq);
  out.desc_quantile.count_quantile1231_desc(tt,qq) = length(Z);
  if length(Z) >= 2
    out.desc_quantile.rad_desc(tt,qq,:)    = nanmean(a.rad(:,desc(Z)),2);   
    out.desc_quantile.stdrad_desc(tt,qq,:) = nanstd(a.rad(:,desc(Z)),[],2);   
    out.desc_quantile.satzen_quantile1231_desc(tt,qq) = nanmean(a.sat_zen(desc(Z)));
    out.desc_quantile.solzen_quantile1231_desc(tt,qq) = nanmean(a.sol_zen(desc(Z)));
    out.desc_quantile.lat_quantile1231_desc(tt,qq)    = nanmean(a.lat(desc(Z)));
    out.desc_quantile.lon_quantile1231_desc(tt,qq)    = nanmean(a.lon(desc(Z)));
  elseif length(Z) == 1
    out.desc_quantile.rad_desc(tt,qq,:) = a.rad(:,desc(Z));   
    out.desc_quantile.stdrad_desc(tt,qq,:) = 0*a.rad(:,desc(Z));   
    out.desc_quantile.satzen_quantile1231_desc(tt,qq) = a.sat_zen(desc(Z));
    out.desc_quantile.solzen_quantile1231_desc(tt,qq) = a.sol_zen(desc(Z));
    out.desc_quantile.lat_quantile1231_desc(tt,qq)    = a.lat(desc(Z));
    out.desc_quantile.lon_quantile1231_desc(tt,qq)    = a.lon(desc(Z));
  elseif length(Z) == 0
    out.desc_quantile.rad_desc(tt,qq,:) = NaN;
    out.desc_quantile.stdrad_desc(tt,qq,:) = NaN;
    out.desc_quantile.satzen_quantile1231_desc(tt,qq) = NaN;
    out.desc_quantile.solzen_quantile1231_desc(tt,qq) = NaN;
    out.desc_quantile.lat_quantile1231_desc(tt,qq)    = NaN;
    out.desc_quantile.lon_quantile1231_desc(tt,qq)    = NaN;
  end
end

if iPlot > 0
  figure(3); clf
  plot(2002+doy/365,out.desc_quantile.quantile1231_desc)
  title('BT 1231 DESC Q1-5'); 
  pause(0.1)
end

