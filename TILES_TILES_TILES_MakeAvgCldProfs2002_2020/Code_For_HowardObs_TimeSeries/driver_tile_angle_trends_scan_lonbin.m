clearvars -except JOB

addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/PLOTMISC
addpath ../../StrowCodeforTrendsAndAnomalies

iQuant = 1; %% Q50
iQuant = 3; %% Q90, default

lat = 35;   %% I did this first for TWP
lat = 32;   %% Larrabee liked this more

for lon = 1 : 1 : 72
  JOB = (lat-1)*72 + lon;

  %disp(' ')
  %for JOB=1:4608
  %  lati = floor((JOB-1)/72)+1;
  %  loni = JOB-(lati-1)*72;  fprintf(1,'JOB,lati,loni : %4i %3i %3i \n',JOB,lati,loni)
  %end
  %disp(' ')
  
  latbin = floor((JOB-1)/72) + 1;
  lonbin = JOB - (latbin-1)*72;

  iaFound(lon) = 0;  
  savenamex = ['../TrendsPaper_Reviewer_UNC/tile_timeseries_latbin_' num2str(latbin) '_lonbin_' num2str(lonbin) '_quantiledata.mat'];
  if exist(savenamex)
    iaFound(lon) = 1;  
    fprintf(1,'%4i %3i %2i %s already exists \n',JOB,latbin,lonbin,savenamex)
    a = load(savenamex);

    %disp('printing mean satzen asc/solzen asc/satzen desc/satzen desc/solzen')
    junk1 = [mean(a.asc_quantile.satzen_quantile1231_asc,1); mean(a.asc_quantile.solzen_quantile1231_asc,1); mean(a.desc_quantile.satzen_quantile1231_desc,1); mean(a.desc_quantile.solzen_quantile1231_desc,1)];
    %disp('printing std satzen asc/solzen asc/satzen desc/satzen desc/solzen')
    junk2 = [std(a.asc_quantile.satzen_quantile1231_asc,1); std(a.asc_quantile.solzen_quantile1231_asc,1); std(a.desc_quantile.satzen_quantile1231_desc,1); std(a.desc_quantile.solzen_quantile1231_desc,1)];

    [B, stats, err] = Math_tsfit_lin_robust(a.doy,a.asc_quantile.satzen_quantile1231_asc(:,iQuant),4);   trend_satzenA(lon) = B(2); unc_trend_satzenA(lon) = stats.se(2);
    [B, stats, err] = Math_tsfit_lin_robust(a.doy,a.asc_quantile.solzen_quantile1231_asc(:,iQuant),4);   trend_solzenA(lon) = B(2); unc_trend_solzenA(lon) = stats.se(2);
    [B, stats, err] = Math_tsfit_lin_robust(a.doy,a.desc_quantile.satzen_quantile1231_desc(:,iQuant),4); trend_satzenD(lon) = B(2); unc_trend_satzenD(lon) = stats.se(2);
    [B, stats, err] = Math_tsfit_lin_robust(a.doy,a.desc_quantile.solzen_quantile1231_desc(:,iQuant),4); trend_solzenD(lon) = B(2); unc_trend_solzenD(lon) = stats.se(2);

    fprintf(1,'latbin = %2i    sat/A    sol/A   sat/D    sol/D \n',latbin)
    ix = 1 : 5;
    junk1 = [ix; junk1];
    junk2 = [ix; junk2];
    fprintf(1,' mean Q %2i : %8.4f %8.4f %8.4f %8.4f \n',junk1);
    fprintf(1,' std  Q %2i : %8.4f %8.4f %8.4f %8.4f \n',junk2);

    save_meanQ90(lon,:) = junk1(2:5,iQuant);
    save_stddQ90(lon,:) = junk2(2:5,iQuant);

  else
    save_meanQ90(lon,:) = nan(1,4);
    save_stddQ90(lon,:) = nan(1,4);

    trend_satzenA(lon) = NaN;
    trend_satzenD(lon) = NaN;
    trend_solzenA(lon) = NaN;
    trend_solzenD(lon) = NaN;

    unc_trend_satzenA(lon) = NaN;
    unc_trend_satzenD(lon) = NaN;
    unc_trend_solzenA(lon) = NaN;
    unc_trend_solzenD(lon) = NaN;

  end

  clearvars -except JOB save_stdQ90 save_meanQ90 save_stddQ90 iQuant unc_trend_satzenA unc_trend_solzenA unc_trend_satzenD unc_trend_solzenD trend_satzenA trend_solzenA trend_satzenD trend_solzenD lat iaFound
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

figure(1); plot(rlon,save_meanQ90(:,[1 3]),'+-'); plotaxis2(0,22);                   legend('A','D','location','best'); title('Mean SatZen Q90')

figure(2); plot(rlon,save_meanQ90(:,[2 4]),'+-'); plotaxis2(0,90);                   legend('A','D','location','best'); title('Mean SolZen Q90')
figure(2); shadedErrorBar(rlon,save_meanQ90(:,1),save_stddQ90(:,1),'b.-',1.75); hold on
           shadedErrorBar(rlon,save_meanQ90(:,3),save_stddQ90(:,3),'r.-',1.75); hold off
  plotaxis2(0,22); legend('A','D','location','best'); title('Mean + Unc SatZen Q90')

figure(3); plot(rlon,trend_satzenA,'+-',rlon,trend_satzenD,'+-'); plotaxis2;         legend('A','D','location','best'); title('Trend SatZen Q90 yr-1')

figure(4); plot(rlon,unc_trend_satzenA,'+-',rlon,unc_trend_satzenD,'+-'); plotaxis2; legend('A','D','location','best'); title('Unc Trend SatZen Q90 yr-1')
%figure(4); plot(rlon,trend_solzenA,'+-',rlon,trend_solzenD,'+-'); plotaxis2;        legend('A','D','location','best'); title('Trend SolZen Q90 yr-1')
figure(4); errorbar(rlon,trend_satzenA,unc_trend_satzenA,'color','b'); hold on
           errorbar(rlon,trend_satzenD,unc_trend_satzenD,'color','r'); hold off
figure(4); shadedErrorBar(rlon,trend_satzenA,unc_trend_satzenA,'b.-',0.3); hold on
           shadedErrorBar(rlon,trend_satzenD,unc_trend_satzenD,'r.-',0.3); hold off
  plotaxis2; legend('A','D','location','best'); title('Unc+Trend SatZen Q90 yr-1')
figure(4); shadedErrorBar(rlon,trend_satzenA,unc_trend_satzenA,'b.-',1.75); hold on
           shadedErrorBar(rlon,trend_satzenD,unc_trend_satzenD,'r.-',1.75); hold off
  plotaxis2; legend('A','D','location','best'); title('Unc+Trend SatZen Q90 yr-1')

figure(5); 
  errorbar(rlon,save_meanQ90(:,1),save_stddQ90(:,1),'color','b'); hold on
  errorbar(rlon,save_meanQ90(:,3),save_stddQ90(:,3),'color','r'); hold off
  plotaxis2(0,22);           legend('A','D','location','best'); title('Mean SatZen Q90')

figure(6); plot(rlon,save_meanQ90(:,[1 3]) - 22,'+-'); plotaxis2; legend('A','D','location','best'); title('Mean SatZen Q90')
  hold on
  delta = zeros(size(rlon));
    wah = find(rlon >= 0); delta(wah) = +0.1 * rlon(wah) - 4;
    wah = find(rlon < 0);  delta(wah) = -0.1 * rlon(wah) - 4;
  plot(rlon,delta);
  hold off


tile_angle_trends_scan_lonbin_stats

%{
comment = 'see driver_tile_angle_trends_scan_lonbin.m; save_meanQ90[1 2 3 4] = satzenA solzenA satzenD solzenD';
save tile_angle_trends_scan_lonbin.mat rlon save_meanQ90 save_meanQ90 unc_trend_satzenA unc_trend_satzenD unc_trend_solzenA unc_trend_solzenD trend_satzenA trend_solzenA trend_satzenD trend_solzenD comment
%}
