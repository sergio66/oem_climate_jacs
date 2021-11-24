[s, a] = read_netcdf_h5(fname);
ianpts = 1:s.total_obs;
%scatter(s.lon(ianpts),s.lat(ianpts),1,s.asc_flag(ianpts)); colorbar
%plot(double(s.sol_zen(ianpts)),s.asc_flag(ianpts))

thesave.iii(iCnt) = iii-2;
thesave.jjj(iCnt) = jjj;
thesave.fname{iCnt} = fname;

[yy,mm,dd,hh] = tai2utcSergio(s.tai93(ianpts)+offset1958_to_1993);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ascend
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
thesave.max1231_asc(iCnt) = max(X);
thesave.min1231_asc(iCnt) = min(X);
thesave.DCC1231_asc(iCnt) = length(find(X < 220));
thesave.hist_asc(iCnt,:) = histc(X,dbt)/length(X);
if iQAX >= 0
  tic
  Y = quantile(X,quants);
  for qq = 1 : length(quants)-1
    if qq <  length(quants)-1
      Z = find(X >= Y(qq) & X < Y(qq+1));
    else
      Z = find(X >= Y(qq) & X <= Y(qq+1));
      Z = find(X >= Y(qq));
    end
    thesave.quantile1231_asc(iCnt,qq) = Y(qq);
    thesave.count_quantile1231_asc(iCnt,qq) = length(Z);
    if length(Z) >= 2
      thesave.rad_asc(iCnt,qq,:) = nanmean(s.rad(:,asc(Z)),2);   
      thesave.satzen_quantile1231_asc(iCnt,qq) = nanmean(s.sat_zen(asc(Z)));
      thesave.solzen_quantile1231_asc(iCnt,qq) = nanmean(s.sol_zen(asc(Z)));
    else
      thesave.rad_asc(iCnt,qq,:) = s.rad(:,asc(Z));   
      thesave.satzen_quantile1231_asc(iCnt,qq) = s.sat_zen(asc(Z));
      thesave.solzen_quantile1231_asc(iCnt,qq) = s.sol_zen(asc(Z));
    end
  toccc(qq) = toc;
  end

  % fprintf(1,'diff(toccc) = %8.6f \n',diff(toccc))
end

if iQAX <= 0
  iiix = iii-2; jjjx = jjj; asc_or_desc = +1; adsc = asc; do_the_max_min_daily_fast
  %{
  thesave = do_the_max_min_daily(iCnt,iii-2,jjj,s,asc,thesave,ianpts,+1);
  rad2bt(1231,squeeze(thesave.rad_min_asc(1:2,1520,:)))'
  rad2bt(1231,squeeze(thesave.rad_blockmin_asc(1:2,1520)))'

  rad2bt(1231,squeeze(thesave.rad_max_asc(1:2,1520,:)))'
  rad2bt(1231,squeeze(thesave.rad_blockmax_asc(1:2,1520)))'
  %}
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% descend     
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
thesave.max1231_desc(iCnt) = max(X);
thesave.min1231_desc(iCnt) = min(X);
thesave.DCC1231_desc(iCnt) = length(find(X < 220));
thesave.hist_desc(iCnt,:) = histc(X,dbt)/length(X);
if iQAX >= 0
  Y = quantile(X,quants);
  for qq = 1 : length(quants)-1
    if qq <  length(quants)-1
      Z = find(X >= Y(qq) & X < Y(qq+1));
    else
      Z = find(X >= Y(qq) & X <= Y(qq+1));
      Z = find(X >= Y(qq));
    end
    thesave.quantile1231_desc(iCnt,qq) = Y(qq);
    thesave.count_quantile1231_desc(iCnt,qq) = length(Z);
    if length(Z) >= 2
      thesave.rad_desc(iCnt,qq,:) = nanmean(s.rad(:,desc(Z)),2);   
      thesave.satzen_quantile1231_desc(iCnt,qq) = nanmean(s.sat_zen(desc(Z)));
      thesave.solzen_quantile1231_desc(iCnt,qq) = nanmean(s.sol_zen(desc(Z)));
    else
      thesave.rad_desc(iCnt,qq,:) = s.rad(:,desc(Z));   
      thesave.satzen_quantile1231_desc(iCnt,qq) = s.sat_zen(desc(Z));
      thesave.solzen_quantile1231_desc(iCnt,qq) = s.sol_zen(desc(Z));
    end
  end
end
if iQAX <= 0
  iiix = iii-2; jjjx = jjj; asc_or_desc = -1; adsc = desc; do_the_max_min_daily_fast
  %thesave = do_the_max_min_daily(iCnt,iii-2,jjj,s,desc,thesave,ianpts,-1);
end

