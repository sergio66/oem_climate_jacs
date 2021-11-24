addpath /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/StrowCodeforTrendsAndAnomalies
addpath /home/sergio/MATLABCODE/COLORMAP

warning off
for ii = 1 : 4320
  boo = demall.mmw(:,ii);
  [B, stats] = Math_tsfit_lin_robust((1:365)*16,boo,4);
  trend.mmw(ii) = B(2);

  boo = demall.stemp(:,ii);
  [B, stats] = Math_tsfit_lin_robust((1:365)*16,boo,4);
  trend.stemp(ii) = B(2);

  boo = rad2bt(1231,demall.rclear(:,ii));
  [B, stats] = Math_tsfit_lin_robust((1:365)*16,boo,4);
  trend.btclear(ii) = B(2);

  boo = rad2bt(1231,demall.rcloud(:,ii));
  [B, stats] = Math_tsfit_lin_robust((1:365)*16,boo,4);
  trend.btcloud(ii) = B(2);

  boo = demall.stemp(:,ii) - rad2bt(1231,demall.rcloud(:,ii));
  [B, stats] = Math_tsfit_lin_robust((1:365)*16,boo,4);
  trend.cldforcing(ii) = B(2);

  if mod(ii,1000) == 0
    fprintf(1,'/');
  elseif mod(ii,100) == 0
    fprintf(1,'+');
  elseif mod(ii,10) == 0
    fprintf(1,'.');
  end
end

warning on

fprintf(1,'\n');

figure(1); simplemap(demall.rlat,demall.rlon,trend.stemp,5); title('Stemp trend')
  caxis([-0.5 +0.5]); colormap(usa2)
figure(2); simplemap(demall.rlat,demall.rlon,trend.mmw,5); title('Mmw trend')
  caxis([-0.5 +0.5]); colormap(usa2)
figure(3); simplemap(demall.rlat,demall.rlon,trend.btclear,5); title('BT1231 clear trend')
  caxis([-0.5 +0.5]); colormap(usa2)
figure(4); simplemap(demall.rlat,demall.rlon,trend.btcloud,5); title('BT1231 cloud trend')
  caxis([-0.5 +0.5]); colormap(usa2)
figure(5); simplemap(demall.rlat,demall.rlon,trend.cldforcing,5); title('CldForcing Stemp-BT1231cld')
  caxis([-0.5 +0.5]); colormap(usa2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

warning off
for ii = 1 : 4320
  days = (1:365)*16;
  boo = demall.icetop(:,ii);
  yes = find(isfinite(boo));
  if length(yes) > 20
    [B, stats] = Math_tsfit_lin_robust(days,boo,4);
    trend.icetop(ii) = B(2);
  else
    trend.icetop(ii) = NaN;
  end

  boo = demall.iceOD(:,ii);
  yes = find(isfinite(boo));
  if length(yes) > 20
    [B, stats] = Math_tsfit_lin_robust(days,boo,4);
    trend.iceOD(ii) = B(2);
  else
    trend.iceOD(ii) = NaN;
  end

  boo = demall.watertop(:,ii);
  yes = find(isfinite(boo));
  if length(yes) > 20
    [B, stats] = Math_tsfit_lin_robust(days,boo,4);
    trend.watertop(ii) = B(2);
  else
    trend.watertop(ii) = NaN;
  end

  boo = demall.waterOD(:,ii);
  yes = find(isfinite(boo));
  if length(yes) > 20
    [B, stats] = Math_tsfit_lin_robust(days,boo,4);
    trend.waterOD(ii) = B(2);
  else
    trend.waterOD(ii) = NaN;
  end

  if mod(ii,1000) == 0
    fprintf(1,'/');
  elseif mod(ii,100) == 0
    fprintf(1,'+');
  elseif mod(ii,10) == 0
    fprintf(1,'.');
  end
end

warning on

fprintf(1,'\n');

figure(1); simplemap(demall.rlat,demall.rlon,trend.iceOD,5); title('IceOD trend /yr')
  caxis([-0.05 +0.05]); colormap(usa2)
figure(2); simplemap(demall.rlat,demall.rlon,trend.icetop,5); title('Icetop trend mb/yr')
  caxis([-5 +5]); colormap(usa2)
figure(3); simplemap(demall.rlat,demall.rlon,trend.waterOD,5); title('WaterOD trend /yr')
  caxis([-0.5 +0.5]); colormap(usa2)
figure(4); simplemap(demall.rlat,demall.rlon,trend.watertop,5); title('Watertop trend mb/yr')
  caxis([-5 +5]); colormap(usa2)
