yayA = 1 : 72;
yayD = 1 : 72;

%% comment = 'see driver_tile_angle_trends_scan_lonbin.m';
%% save latbin32_all_lonbins_trend_unc.mat trend_satzenD trend_satzenA unc_trend_satzenA unc_trend_satzenD comment

disp('using MEAN trend, mean UNC')
fprintf(1,'all of the ascending  trends +/- uncertainty misses 0 : %8.6f +/- %8.6f \n',mean(trend_satzenA(yayA)),mean(unc_trend_satzenA(yayA)))
fprintf(1,'all of the descending trends +/- uncertainty misses 0 : %8.6f +/- %8.6f \n',mean(trend_satzenD(yayD)),mean(unc_trend_satzenD(yayD)))

disp('using MEAN trend, std TREND')
fprintf(1,'all of the ascending  trends +/- uncertainty misses 0 : %8.6f +/- %8.6f \n',mean(trend_satzenA(yayA)),std(trend_satzenA(yayA)))
fprintf(1,'all of the descending trends +/- uncertainty misses 0 : %8.6f +/- %8.6f \n',mean(trend_satzenD(yayD)),std(trend_satzenD(yayD)))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

booM = trend_satzenA - unc_trend_satzenA; booP = trend_satzenA + unc_trend_satzenA;
for ii = 1 : 64
  if booM(ii) < 0 & booP(ii) > 0
    yayA(ii) = 1;
  else
    yayA(ii) = 0;
  end
end
booM = trend_satzenD - unc_trend_satzenD; booP = trend_satzenD + unc_trend_satzenD;
for ii = 1 : 64
  if booM(ii) < 0 & booP(ii) > 0
    yayD(ii) = 1;
  else
    yayD(ii) = 0;
  end
end

fprintf(1,'good ascending  trends +/- uncertainty encompasses 0 = % 2i out of %2i \n',sum(yayA),sum(iaFound))
fprintf(1,'good descending trends +/- uncertainty encompasses 0 = % 2i out of %2i \n',sum(yayD),sum(iaFound))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
yayA = find(yayA > 0);
yayD = find(yayD > 0);

disp('using MEAN trend, mean UNC')
fprintf(1,'good ascending  trends +/- uncertainty misses 0 : %8.6f +/- %8.6f \n',mean(trend_satzenA(yayA)),mean(unc_trend_satzenA(yayA)))
fprintf(1,'good descending trends +/- uncertainty misses 0 : %8.6f +/- %8.6f \n',mean(trend_satzenD(yayD)),mean(unc_trend_satzenD(yayD)))

disp('using MEAN trend, std TREND')
fprintf(1,'good ascending  trends +/- uncertainty misses 0 : %8.6f +/- %8.6f \n',mean(trend_satzenA(yayA)),std(trend_satzenA(yayA)))
fprintf(1,'good descending trends +/- uncertainty misses 0 : %8.6f +/- %8.6f \n',mean(trend_satzenD(yayD)),std(trend_satzenD(yayD)))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

booA = setdiff(1:72,find(yayA > 0));
booD = setdiff(1:72,find(yayD > 0));

disp('using MEAN trend, mean UNC')
fprintf(1,'bad ascending  trends +/- uncertainty misses 0 : %8.6f +/- %8.6f \n',mean(trend_satzenA(booA)),mean(unc_trend_satzenA(booA)))
fprintf(1,'bad descending trends +/- uncertainty misses 0 : %8.6f +/- %8.6f \n',mean(trend_satzenD(booD)),mean(unc_trend_satzenD(booD)))

disp('using MEAN trend, std TREND')
fprintf(1,'bad ascending  trends +/- uncertainty misses 0 : %8.6f +/- %8.6f \n',mean(trend_satzenA(booA)),std(trend_satzenA(booA)))
fprintf(1,'bad descending trends +/- uncertainty misses 0 : %8.6f +/- %8.6f \n',mean(trend_satzenD(booD)),std(trend_satzenD(booD)))
