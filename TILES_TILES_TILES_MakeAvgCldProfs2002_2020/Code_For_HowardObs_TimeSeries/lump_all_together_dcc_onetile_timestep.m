N = a.total_obs;
ianpts = 1 : N;

[a.salti(ianpts), a.landfrac(ianpts)] = usgs_deg10_dem(a.lat(ianpts), a.lon(ianpts));
land  = find(a.landfrac(ianpts) > 1 - eps);
ocean = find(a.landfrac(ianpts) < eps);

dbt = 180:320;

inds = ianpts;
if iLorOorA == 0
  asc  = find(a.asc_flag(ianpts) == 65);
  desc = find(a.asc_flag(ianpts) == 68);
  if iDorA > 0
    % desc
    inds = ianpts(desc);
  elseif iDorA < 0
    % asc
    inds = ianpts(asc);
  else
    % both
    inds = ianpts;
  end
elseif iLorOorA == 1
  asc  = find(a.asc_flag(ianpts) == 65 & a.landfrac(ianpts) > 1 - eps);
  desc = find(a.asc_flag(ianpts) == 68 & a.landfrac(ianpts) > 1 - eps);
  if iDorA > 0
    % desc
    inds = ianpts(desc);
  elseif iDorA < 0
    % asc
    inds = ianpts(asc);
  else
    % both
    inds = ianpts;
  end
elseif iLorOorA == -1
  asc  = find(a.asc_flag(ianpts) == 65 & a.landfrac(ianpts) < eps);
  desc = find(a.asc_flag(ianpts) == 68 & a.landfrac(ianpts) < eps);
  if iDorA > 0
    % desc
    inds = ianpts(desc);
  elseif iDorA < 0
    % asc
    inds = ianpts(asc);
  else
    % both
    inds = ianpts;
  end
end

out.name{tt} = fname;

bt1231 = rad2bt(1231,a.rad(1520,inds));
quantsx = sort([0.01 0.499 0.99 quants]);
quantsx = setdiff(quantsx,1.00);

qx = quantile(bt1231,quantsx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% this is the average

out.avg.count(tt)         = length(inds);
out.avg.mean_lat(tt)      = nanmean(a.lat(inds));
out.avg.mean_lon(tt)      = nanmean(a.lon(inds));
out.avg.mean_sol(tt)      = nanmean(a.sol_zen(inds));
out.avg.mean_sat(tt)      = nanmean(a.sat_zen(inds));

out.avg.mean_rtime(tt)    = nanmean(a.tai93(inds));
[yy,mm,dd] = tai2utcSergio(out.avg.mean_rtime(tt) + offset1958_to_1993);
doy = change2days(yy,mm,dd,2002);
out.avg.yy(tt) = yy;     
out.avg.mm(tt) = mm;     
out.avg.dd(tt) = dd;     
out.avg.doy(tt) = doy;  
out.avg.time(tt) = 2002+doy/365;

out.avg.mean_rad(:,tt)    = nanmean(a.rad(:,inds),2);
out.avg.std_rad(:,tt)     = nanstd(a.rad(:,inds),[],2);
out.avg.max_rad(:,tt)     = nanmax(a.rad(:,inds),[],2);
out.avg.min_rad(:,tt)     = nanmin(a.rad(:,inds),[],2);

out.avg.mean_rad_1231(tt) = nanmean(a.rad(1520,inds));
out.avg.std_rad_1231(tt)  = nanstd(a.rad(1520,inds));
out.avg.max_rad_1231(tt)  = nanmax(a.rad(1520,inds));
out.avg.min_rad_1231(tt)  = nanmin(a.rad(1520,inds));

out.avg.histall(:,tt)       = histc(bt1231,dbt)/length(bt1231);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% this is the min, and thos below 230 K
boo = find(bt1231 <= 230);
boo = inds(boo);
out.min.count230K(tt) = length(boo);
out.min.rad230k(:,tt) = nanmean(a.rad(:,boo),2);

%%%%%%%%%%%%%%%%%%%%%%%%%

boo = find(bt1231 == min(bt1231),1);
indsX = inds(boo);

out.min.mean_lat(tt)      = a.lat(indsX);
out.min.mean_lon(tt)      = a.lon(indsX);
out.min.mean_sol(tt)      = a.sol_zen(indsX);
out.min.mean_sat(tt)      = a.sat_zen(indsX);

out.min.rtime(tt)    = a.tai93(indsX);
[yy,mm,dd] = tai2utcSergio(out.min.rtime(tt) + offset1958_to_1993);
doy = change2days(yy,mm,dd,2002);
out.min.yy(tt) = yy;     
out.min.mm(tt) = mm;     
out.min.dd(tt) = dd;     
out.min.doy(tt) = doy;  
out.min.time(tt) = 2002+doy/365;

out.min.rad(:,tt)    = a.rad(:,indsX);

