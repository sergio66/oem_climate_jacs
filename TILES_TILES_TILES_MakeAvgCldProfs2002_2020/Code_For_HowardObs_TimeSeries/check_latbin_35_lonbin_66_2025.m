thedir = dir('/umbc/rs/strow/asl/airs/tile_test7/2025_s*/N05p50/tile_2025_s52*_N05p50_E145p00.nc');

iDorA = -1;

for tt = 1 : length(thedir)
  junk = thedir(tt).name;
  junk = junk(12:14);
  fname = ['/umbc/rs/strow/asl/airs/tile_test7/2025_s' junk '/N05p50/'  thedir(tt).name];
  fprintf(1,'%2i %s \n',tt,fname);
  
  a = read_netcdf_lls(fname);

  N = a.total_obs;
  ianpts = 1 : N;

  %% see lump_all_together_dcc_onetile_timestep.m
  [a.salti(ianpts), a.landfrac(ianpts)] = usgs_deg10_dem(a.lat(ianpts), a.lon(ianpts));
  land  = find(a.landfrac(ianpts) > 1 - eps);
  ocean = find(a.landfrac(ianpts) < eps);

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

  out.avg.count(tt)         = length(inds);
  out.avg.mean_lat(tt)      = nanmean(a.lat(inds));
  out.avg.mean_lon(tt)      = nanmean(a.lon(inds));
  out.avg.mean_sol(tt)      = nanmean(a.sol_zen(inds));
  out.avg.mean_sat(tt)      = nanmean(a.sat_zen(inds));
  
  out.avg.mean_rtime(tt)    = nanmean(a.tai93(inds));

  [yy,mm,dd,hh] = tai2utcSergio(out.avg.mean_rtime(tt) + offset1958_to_1993);
  doy = change2days(yy,mm,dd,2002);
  out.avg.yy(tt) = yy;     
  out.avg.mm(tt) = mm;     
  out.avg.dd(tt) = dd;
  out.avg.hh(tt) = hh;       
  out.avg.doy(tt) = doy;  
  out.avg.time(tt) = 2002+doy/365;

  %%%%%%%%%%%%%%%%%%%%%%%%%

  mtimet = tai2dtime(airs2tai(nanmean(a.tai93(inds))));
  dtimet = datenum(mtimet);
  hht = hour(mtimet) + minute(mtimet)/60;  
  xsolt  = nanmean(a.sol_zen(inds));  

indx0 = 1 : N;
  mtime0 = tai2dtime(airs2tai(a.tai93(indx0)));
  dtime0 = datenum(mtime0);
  hh0    = hour(mtime0) + minute(mtime0)/60;
  xsol0  = a.sol_zen(indx0);  
indx1 = inds;
  mtime1 = tai2dtime(airs2tai(a.tai93(indx1)));
  dtime1 = datenum(mtime1);
  hh1    = hour(mtime1) + minute(mtime1)/60;  
  xsol1  = a.sol_zen(indx1);
figure(3); plot(xsol0,hh0,'b.',xsol1,hh1,'ro',out.avg.mean_sol(tt),out.avg.hh(tt),'k+',xsolt,hht,'go'); xlabel('Solzen'); ylabel('HH');

plot(a.sol_zen(1:N),a.tai93(1:N),'.',a.sol_zen(inds),a.tai93(inds),'x')
figure(1); plot(a.sol_zen(1:N),a.tai93(1:N),'.',a.sol_zen(inds),a.tai93(inds),'x'); xlabel('Solzen'); ylabel('tai93')
figure(2); plot(a.sol_zen(1:N),hh0,'.',a.sol_zen(inds),hh1,'x'); xlabel('Solzen'); ylabel('HH +  MM/60')

% keyboard_nowindow  

end
