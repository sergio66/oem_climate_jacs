function saveall = fill_tile_to_subgrids(h,s,iQAX,iCnt,tt,saveall,quants,dbt);

[yy,mm,dd,hh] = tai2utcSergio(s.tai93 + offset1958_to_1993);

ianpts = 1:length(s.lon);

booD = find(s.asc_flag(ianpts) == 68); desc = booD;
booA = find(s.asc_flag(ianpts) == 65); asc  = booA;

t1231 = rad2bt(1231,s.rad(1520,:));
bt = rad2bt(h.vchan,s.rad);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

saveall.cntDCCBT1231_asc(iCnt,tt) = length(find(t1231(booA) < 220));
saveall.count_asc(iCnt,tt)        = length(booA);
saveall.landfrac_asc(iCnt,tt)     = mean(s.land_frac(booA));
saveall.lat_asc(iCnt,tt)          = mean(s.lat(booA));
saveall.lon_asc(iCnt,tt)          = mean(s.lon(booA));
saveall.tai_asc(iCnt,tt)          = mean(s.tai93(booA));
saveall.day_asc(iCnt,tt)          = mean(dd(booA));
saveall.hour_asc(iCnt,tt)         = mean(hh(booA));
saveall.month_asc(iCnt,tt)        = mean(mm(booA));
saveall.year_asc(iCnt,tt)         = mean(yy(booA));
saveall.solzen_asc(iCnt,tt)       = mean(s.sol_zen(booA));
saveall.satzen_asc(iCnt,tt)       = mean(s.sat_zen(booA));
saveall.maxBT1231_asc(iCnt,tt)    = max(t1231(booA));
saveall.minBT1231_asc(iCnt,tt)    = min(t1231(booA));
saveall.meanBT1231_asc(iCnt,tt)   = mean(t1231(booA));
saveall.meanBT_asc(iCnt,tt,:)     = nanmean(bt(:,booA),2);

X = rad2bt(1231,s.rad(1520,booA)); 
Y = quantile(X,quants);

saveall.quantile1231_asc(iCnt,tt,:) = Y(1:end-1);
for qq = 1 : length(quants)-1
  select_Zdata_based_on_iQAX_and_qq %%%% <<<<<<<<<<<<<<<<<<<<< this is the selector >>>>>>>>>>>>>>>>>>>>>>>>
  %% thesave.desc_Z{qq} = desc(Z);
  saveall.quantile1231_asc(iCnt,tt,qq) = Y(qq);
  saveall.count_quantile1231_asc(iCnt,tt,qq) = length(Z);
  if length(Z) >= 2
    saveall.rad_asc(iCnt,tt,qq,:) = nanmean(s.rad(:,asc(Z)),2);   
    saveall.satzen_quantile1231_asc(iCnt,tt,qq) = nanmean(s.sat_zen(asc(Z)));
    saveall.solzen_quantile1231_asc(iCnt,tt,qq) = nanmean(s.sol_zen(asc(Z)));
  elseif length(Z) == 1
    saveall.rad_asc(iCnt,tt,qq,:) = s.rad(:,asc(Z));   
    saveall.satzen_quantile1231_asc(iCnt,tt,qq) = s.sat_zen(asc(Z));
    saveall.solzen_quantile1231_asc(iCnt,tt,qq) = s.sol_zen(asc(Z));
  elseif length(Z) == 0
    saveall.rad_asc(iCnt,tt,qq,:) = NaN;
    saveall.satzen_quantile1231_asc(iCnt,tt,qq) = NaN;
    saveall.solzen_quantile1231_asc(iCnt,tt,qq) = NaN;
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

saveall.cntDCCBT1231_desc(iCnt,tt) = length(find(t1231(booD) < 220));
saveall.count_desc(iCnt,tt)        = length(booD);
saveall.landfrac_desc(iCnt,tt)     = mean(s.land_frac(booD));
saveall.lat_desc(iCnt,tt)          = mean(s.lat(booD));
saveall.lon_desc(iCnt,tt)          = mean(s.lon(booD));
saveall.tai_desc(iCnt,tt)          = mean(s.tai93(booD));
saveall.day_desc(iCnt,tt)          = mean(dd(booD));
saveall.hour_desc(iCnt,tt)         = mean(hh(booD));
saveall.month_desc(iCnt,tt)        = mean(mm(booD));
saveall.year_desc(iCnt,tt)         = mean(yy(booD));
saveall.solzen_desc(iCnt,tt)       = mean(s.sol_zen(booD));
saveall.satzen_desc(iCnt,tt)       = mean(s.sat_zen(booD));
saveall.maxBT1231_desc(iCnt,tt)    = max(t1231(booD));
saveall.minBT1231_desc(iCnt,tt)    = min(t1231(booD));
saveall.meanBT1231_desc(iCnt,tt)   = mean(t1231(booD));
saveall.meanBT_desc(iCnt,tt,:)     = nanmean(bt(:,booD),2);

X = rad2bt(1231,s.rad(1520,booD)); 
Y = quantile(X,quants);

saveall.quantile1231_desc(iCnt,tt,:) = Y(1:end-1);
for qq = 1 : length(quants)-1
  select_Zdata_based_on_iQAX_and_qq %%%% <<<<<<<<<<<<<<<<<<<<< this is the selector >>>>>>>>>>>>>>>>>>>>>>>>
  %% thesave.desc_Z{qq} = desc(Z);
  saveall.quantile1231_desc(iCnt,tt,qq) = Y(qq);
  saveall.count_quantile1231_desc(iCnt,tt,qq) = length(Z);
  if length(Z) >= 2
    saveall.rad_desc(iCnt,tt,qq,:) = nanmean(s.rad(:,desc(Z)),2);   
    saveall.satzen_quantile1231_desc(iCnt,tt,qq) = nanmean(s.sat_zen(desc(Z)));
    saveall.solzen_quantile1231_desc(iCnt,tt,qq) = nanmean(s.sol_zen(desc(Z)));
  elseif length(Z) == 1
    saveall.rad_desc(iCnt,tt,qq,:) = s.rad(:,desc(Z));   
    saveall.satzen_quantile1231_desc(iCnt,tt,qq) = s.sat_zen(desc(Z));
    saveall.solzen_quantile1231_desc(iCnt,tt,qq) = s.sol_zen(desc(Z));
  elseif length(Z) == 0
    saveall.rad_desc(iCnt,tt,qq,:) = NaN;
    saveall.satzen_quantile1231_desc(iCnt,tt,qq) = NaN;
    saveall.solzen_quantile1231_desc(iCnt,tt,qq) = NaN;
  end
end
