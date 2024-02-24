asc = find(s.asc_flag(ianpts) == 65);  
thesave.count_asc(iCnt) = length(asc);
thesave.lat_asc(iCnt)  = nanmean(s.lat(asc));
thesave.lon_asc(iCnt)  = nanmean(s.lon(asc));
thesave.meanyear_asc(iCnt) = nanmean(yy(asc));
thesave.stdyear_asc(iCnt)  = nanstd(yy(asc));
thesave.meanmonth_asc(iCnt) = nanmean(mm(asc));
thesave.stdmonth_asc(iCnt)  = nanstd(mm(asc));
thesave.meanday_asc(iCnt) = nanmean(dd(asc));
thesave.stdday_asc(iCnt)  = nanstd(dd(asc));
thesave.meanhour_asc(iCnt) = nanmean(hh(asc));
thesave.stdhour_asc(iCnt)  = nanstd(hh(asc));
thesave.meantai93_asc(iCnt) = nanmean(s.tai93(asc));
thesave.stdtai93_asc(iCnt)  = nanstd(s.tai93(asc));
thesave.meansolzen_asc(iCnt) = nanmean(s.sol_zen(asc));
thesave.stdsolzen_asc(iCnt)  = nanstd(s.sol_zen(asc));
thesave.meansatzen_asc(iCnt) = nanmean(s.sat_zen(asc));
thesave.stdsatzen_asc(iCnt)  = nanstd(s.sat_zen(asc));
thesave.mean_rad_asc(iCnt,:) = nanmean(s.rad(:,asc),2);
thesave.std_rad_asc(iCnt,:)  = nanstd(s.rad(:,asc),0,2);    
X = rad2bt(1231,s.rad(1520,asc)); 
Y = quantile(X,quants);
thesave.max1231_asc(iCnt) = max(X);
thesave.min1231_asc(iCnt) = min(X);
thesave.DCC1231_asc(iCnt) = length(find(X < 220));
thesave.hist_asc(iCnt,:) = histc(X,dbt)/length(X);
for qq = 1 : length(quants)-1

  select_Zdata_based_on_iQAX_and_qq %%%% <<<<<<<<<<<<<<<<<<<<< this is the selector >>>>>>>>>>>>>>>>>>>>>>>>
  thesave.asc_Z{qq} = asc(Z);

  thesave.quantile1231_asc(iCnt,qq) = Y(qq);
  thesave.count_quantile1231_asc(iCnt,qq) = length(Z);
  if length(Z) >= 2
    thesave.rad_asc(iCnt,qq,:) = nanmean(s.rad(:,asc(Z)),2);   
    thesave.satzen_quantile1231_asc(iCnt,qq) = nanmean(s.sat_zen(asc(Z)));
    thesave.solzen_quantile1231_asc(iCnt,qq) = nanmean(s.sol_zen(asc(Z)));
  elseif length(Z) == 1
    thesave.rad_asc(iCnt,qq,:) = s.rad(:,asc(Z));   
    thesave.satzen_quantile1231_asc(iCnt,qq) = s.sat_zen(asc(Z));
    thesave.solzen_quantile1231_asc(iCnt,qq) = s.sol_zen(asc(Z));
  elseif length(Z) == 0
    thesave.rad_asc(iCnt,qq,:) = NaN;
    thesave.satzen_quantile1231_asc(iCnt,qq) = NaN;
    thesave.solzen_quantile1231_asc(iCnt,qq) = NaN;
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
desc = find(s.asc_flag(ianpts) == 68);  
thesave.count_desc(iCnt) = length(desc);
thesave.lat_desc(iCnt)  = nanmean(s.lat(desc));
thesave.lon_desc(iCnt)  = nanmean(s.lon(desc));
thesave.meanyear_desc(iCnt) = nanmean(yy(desc));
thesave.stdyear_desc(iCnt)  = nanstd(yy(desc));
thesave.meanmonth_desc(iCnt) = nanmean(mm(desc));
thesave.stdmonth_desc(iCnt)  = nanstd(mm(desc));
thesave.meanday_desc(iCnt) = nanmean(dd(desc));
thesave.stdday_desc(iCnt)  = nanstd(dd(desc));
thesave.meanhour_desc(iCnt) = nanmean(hh(desc));
thesave.stdhour_desc(iCnt)  = nanstd(hh(desc));
thesave.meantai93_desc(iCnt) = nanmean(s.tai93(desc));
thesave.stdtai93_desc(iCnt)  = nanstd(s.tai93(desc));
thesave.meansolzen_desc(iCnt) = nanmean(s.sol_zen(desc));
thesave.stdsolzen_desc(iCnt)  = nanstd(s.sol_zen(desc));
thesave.meansatzen_desc(iCnt) = nanmean(s.sat_zen(desc));
thesave.stdsatzen_desc(iCnt)  = nanstd(s.sat_zen(desc));
thesave.mean_rad_desc(iCnt,:) = nanmean(s.rad(:,desc),2);
thesave.std_rad_desc(iCnt,:)  = nanstd(s.rad(:,desc),0,2);
X = rad2bt(1231,s.rad(1520,desc)); 
Y = quantile(X,quants);
thesave.max1231_desc(iCnt) = max(X);
thesave.min1231_desc(iCnt) = min(X);
thesave.DCC1231_desc(iCnt) = length(find(X < 220));
thesave.hist_desc(iCnt,:) = histc(X,dbt)/length(X);
for qq = 1 : length(quants)-1

  select_Zdata_based_on_iQAX_and_qq %%%% <<<<<<<<<<<<<<<<<<<<< this is the selector >>>>>>>>>>>>>>>>>>>>>>>>
  thesave.desc_Z{qq} = desc(Z);

  thesave.quantile1231_desc(iCnt,qq) = Y(qq);
  thesave.count_quantile1231_desc(iCnt,qq) = length(Z);
  if length(Z) >= 2
    thesave.rad_desc(iCnt,qq,:) = nanmean(s.rad(:,desc(Z)),2);   
    thesave.satzen_quantile1231_desc(iCnt,qq) = nanmean(s.sat_zen(desc(Z)));
    thesave.solzen_quantile1231_desc(iCnt,qq) = nanmean(s.sol_zen(desc(Z)));
  elseif length(Z) == 1
    thesave.rad_desc(iCnt,qq,:) = s.rad(:,desc(Z));   
    thesave.satzen_quantile1231_desc(iCnt,qq) = s.sat_zen(desc(Z));
    thesave.solzen_quantile1231_desc(iCnt,qq) = s.sol_zen(desc(Z));
  elseif length(Z) == 0
    thesave.rad_desc(iCnt,qq,:) = NaN;
    thesave.satzen_quantile1231_desc(iCnt,qq) = NaN;
    thesave.solzen_quantile1231_desc(iCnt,qq) = NaN;
  end
end
