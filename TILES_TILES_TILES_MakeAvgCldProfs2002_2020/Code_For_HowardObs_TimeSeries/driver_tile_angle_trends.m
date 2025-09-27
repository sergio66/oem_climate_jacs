clearvars -except JOB
addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/PLOTMISC
addpath ../../StrowCodeforTrendsAndAnomalies

iQuant = 1; %% Q50
iQuant = 3; %% Q90, default

lon = 36;

for lat = 1 : 1 : 64
  JOB = (lat-1)*72 + lon;

  %disp(' ')
  %for JOB=1:4608
  %  lati = floor((JOB-1)/72)+1;
  %  loni = JOB-(lati-1)*72;  fprintf(1,'JOB,lati,loni : %4i %3i %3i \n',JOB,lati,loni)
  %end
  %disp(' ')
  
  latbin = floor((JOB-1)/72) + 1;
  lonbin = JOB - (latbin-1)*72;
  
  iaFound(lat) = 0;
  savenamex = ['../TrendsPaper_Reviewer_UNC/tile_timeseries_latbin_' num2str(latbin) '_lonbin_' num2str(lonbin) '_quantiledata.mat'];
  if exist(savenamex)
    iaFound(lat) = 1;
    fprintf(1,'%4i %3i %2i %s already exists \n',JOB,latbin,lonbin,savenamex)
    a = load(savenamex);

    %disp('printing mean satzen asc/solzen asc/satzen desc/satzen desc/solzen')
    junk1 = [mean(a.asc_quantile.satzen_quantile1231_asc,1); mean(a.asc_quantile.solzen_quantile1231_asc,1); mean(a.desc_quantile.satzen_quantile1231_desc,1); mean(a.desc_quantile.solzen_quantile1231_desc,1)];
    %disp('printing std satzen asc/solzen asc/satzen desc/satzen desc/solzen')
    junk2 = [std(a.asc_quantile.satzen_quantile1231_asc,1); std(a.asc_quantile.solzen_quantile1231_asc,1); std(a.desc_quantile.satzen_quantile1231_desc,1); std(a.desc_quantile.solzen_quantile1231_desc,1)];

    [B, stats, err] = Math_tsfit_lin_robust(a.doy,a.asc_quantile.satzen_quantile1231_asc(:,iQuant),4);   trend_satzenA(lat) = B(2); unc_trend_satzenA(lat) = stats.se(2);
    [B, stats, err] = Math_tsfit_lin_robust(a.doy,a.asc_quantile.solzen_quantile1231_asc(:,iQuant),4);   trend_solzenA(lat) = B(2); unc_trend_solzenA(lat) = stats.se(2);
    [B, stats, err] = Math_tsfit_lin_robust(a.doy,a.desc_quantile.satzen_quantile1231_desc(:,iQuant),4); trend_satzenD(lat) = B(2); unc_trend_satzenD(lat) = stats.se(2);
    [B, stats, err] = Math_tsfit_lin_robust(a.doy,a.desc_quantile.solzen_quantile1231_desc(:,iQuant),4); trend_solzenD(lat) = B(2); unc_trend_solzenD(lat) = stats.se(2);

    fprintf(1,'latbin = %2i    sat/A    sol/A   sat/D    sol/D \n',latbin)
    ix = 1 : 5;
    junk1 = [ix; junk1];
    junk2 = [ix; junk2];
    fprintf(1,' mean Q %2i : %8.4f %8.4f %8.4f %8.4f \n',junk1);
    fprintf(1,' std  Q %2i : %8.4f %8.4f %8.4f %8.4f \n',junk2);

    save_meanQ90(lat,:) = junk1(2:5,iQuant);
    save_stddQ90(lat,:) = junk2(2:5,iQuant);

  else
    save_meanQ90(lat,:) = nan(1,4);
    save_stddQ90(lat,:) = nan(1,4);

    trend_satzenA(lat) = NaN;
    trend_satzenD(lat) = NaN;
    trend_solzenA(lat) = NaN;
    trend_solzenD(lat) = NaN;

    unc_trend_satzenA(lat) = NaN;
    unc_trend_satzenD(lat) = NaN;
    unc_trend_solzenA(lat) = NaN;
    unc_trend_solzenD(lat) = NaN;

  end

  clearvars -except JOB save_stdQ90 save_meanQ90 save_stddQ90 iQuant unc_trend_satzenA unc_trend_solzenA unc_trend_satzenD unc_trend_solzenD trend_satzenA trend_solzenA trend_satzenD trend_solzenD lon iaFound
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load latB64.mat
rlat65 = latB2; rlon73 = -180 : 5 : +180;
rlon = -180 : 5 : +180;  rlat = latB2;
rlon = 0.5*(rlon(1:end-1)+rlon(2:end));
rlat = 0.5*(rlat(1:end-1)+rlat(2:end));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Y,X] = meshgrid(rlat,rlon);
X = X; Y = Y;
XX = X;  XX = XX(:); XX = XX';   %%%% MUST BE RIGHT MUST BE RIGHT MUST BE RIGHT MUST BE RIGHT
YY = Y;  YY = YY(:); YY = YY';   %%%% MUST BE RIGHT MUST BE RIGHT MUST BE RIGHT MUST BE RIGHT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1); plot(rlat,save_meanQ90(:,[1 3]),'+-'); plotaxis2(0,22);                   legend('A','D','location','best'); title('Mean SatZen Q90')

figure(2); plot(rlat,save_meanQ90(:,[2 4]),'+-'); plotaxis2(0,90);                   legend('A','D','location','best'); title('Mean SolZen Q90')
figure(2); shadedErrorBar(rlat,save_meanQ90(:,1),save_stddQ90(:,1),'b.-',1.75); hold on
           shadedErrorBar(rlat,save_meanQ90(:,3),save_stddQ90(:,3),'r.-',1.75); hold off
  plotaxis2(0,22); legend('A','D','location','best'); title('Mean + Unc SatZen Q90')

figure(3); plot(rlat,trend_satzenA,'+-',rlat,trend_satzenD,'+-'); plotaxis2;         legend('A','D','location','best'); title('Trend SatZen Q90 yr-1')

figure(4); plot(rlat,unc_trend_satzenA,'+-',rlat,unc_trend_satzenD,'+-'); plotaxis2; legend('A','D','location','best'); title('Unc Trend SatZen Q90 yr-1')
%figure(4); plot(rlat,trend_solzenA,'+-',rlat,trend_solzenD,'+-'); plotaxis2;        legend('A','D','location','best'); title('Trend SolZen Q90 yr-1')
figure(4); errorbar(rlat,trend_satzenA,unc_trend_satzenA,'color','b'); hold on
           errorbar(rlat,trend_satzenD,unc_trend_satzenD,'color','r'); hold off
figure(4); shadedErrorBar(rlat,trend_satzenA,unc_trend_satzenA,'b.-',0.3); hold on
           shadedErrorBar(rlat,trend_satzenD,unc_trend_satzenD,'r.-',0.3); hold off
  plotaxis2; legend('A','D','location','best'); title('Unc+Trend SatZen Q90 yr-1')
figure(4); shadedErrorBar(rlat,trend_satzenA,unc_trend_satzenA,'b.-',1.75); hold on
           shadedErrorBar(rlat,trend_satzenD,unc_trend_satzenD,'r.-',1.75); hold off
  plotaxis2; legend('A','D','location','best'); title('Unc+Trend SatZen Q90 yr-1')

figure(5); 
  errorbar(rlat,save_meanQ90(:,1),save_stddQ90(:,1),'color','b'); hold on
  errorbar(rlat,save_meanQ90(:,3),save_stddQ90(:,3),'color','r'); hold off
  plotaxis2(0,22);           legend('A','D','location','best'); title('Mean SatZen Q90')

figure(6); plot(rlat,save_meanQ90(:,[1 3]) - 22,'+-'); plotaxis2; legend('A','D','location','best'); title('Mean SatZen Q90')
  hold on
  delta = zeros(size(rlat));
    wah = find(rlat >= 0); delta(wah) = +0.1 * rlat(wah) - 4;
    wah = find(rlat < 0);  delta(wah) = -0.1 * rlat(wah) - 4;
  plot(rlat,delta);
  hold off

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
fprintf(1,'ascending  trends +/- uncertainty encompasses 0 = % 2i out of %2i \n',sum(yayA),sum(iaFound))
fprintf(1,'descending trends +/- uncertainty encompasses 0 = % 2i out of %2i \n',sum(yayD),sum(iaFound))

%{
comment = 'see driver_tile_angle_trends.m; save_meanQ90[1 2 3 4] = satzenA solzenA satzenD solzenD';
save tile_angle_trends.mat rlat save_meanQ90 save_meanQ90 unc_trend_satzenA unc_trend_satzenD unc_trend_solzenA unc_trend_solzenD trend_satzenA trend_solzenA trend_satzenD trend_solzenD comment
%}
