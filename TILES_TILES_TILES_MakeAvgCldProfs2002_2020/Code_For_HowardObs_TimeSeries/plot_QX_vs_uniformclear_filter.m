iX = input('Enter which quantile to look at (90,95,97) when comparing to uniform-clear (default 90) : ');
if length(iX) == 0
  iX = 90;
end
if iX == 90
  clr_rlat  = clr90_rlat;
  clr_rlon  = clr90_rlon;
  clr_r1231 = clr90_r1231;
elseif iX == 95
  clr_rlat  = clr95_rlat;
  clr_rlon  = clr95_rlon;
  clr_r1231 = clr95_r1231;
elseif iX == 97
  clr_rlat  = clr97_rlat;
  clr_rlon  = clr97_rlon;
  clr_r1231 = clr97_r1231;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% if these files DNE then run read_in_16days_clear
%% if these files DNE then run read_in_16days_clear
if iTimeStep == 230 
  pclrfile = 'pclear_Aug2012.mat';
elseif iTimeStep == 230 - 6
  pclrfile = 'pclear_Jun2012.mat';
elseif iTimeStep == 230 - 12
  pclrfile = 'pclear_Feb2012.mat';
elseif iTimeStep == 230 + 6
  pclrfile = 'pclear_Dec2012.mat';
end
%% if these files DNE then run read_in_16days_clear
%% if these files DNE then run read_in_16days_clear
if ~exist(pclrfile)
  fprintf(1,'in plot_QX_vs_uniformclear_filter.m : pclrfile = %s DNE : run "read_in_16days_clear" first \n',pclrfile);
  error('pclrfile DNE')
end
loader = ['load ' pclrfile];
eval(loader)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(8); clf; clrfilter_map = simplemap(pclear.rlat,pclear.rlon,rad2bt(1231,pclear.r1231)); colormap jet
figure(9); clf; qXfilter_map  = simplemap(clr_rlat,clr_rlon,clr_r1231); colormap jet
figure(9); cx = caxis;
figure(8); caxis(cx);
figure(10); plot(clrfilter_map(:),qXfilter_map(:),clrfilter_map(:),clrfilter_map(:),'k'); xlabel('clr filter'); ylabel('qX filter')
cx300 = cx;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath /home/sergio/MATLABCODE/NANROUTINES/
[r,chisqr,P,sigP,numpts] = nanlinearcorrelation(clrfilter_map(:),clrfilter_map(:));

rlon360 = -180:+180; rlon360 = meanvaluebin(rlon360);
rlat180 = -90:+90;   rlat180 = meanvaluebin(rlat180);
good = find(isfinite(clrfilter_map));
bad  = find(isnan(clrfilter_map));
qXfilter_mapNaN = qXfilter_map; qXfilter_mapNaN(bad) = NaN;
mean_qXfilter_mapNaN = nanmean(qXfilter_mapNaN,2);
std_qXfilter_mapNaN  = nanstd(qXfilter_mapNaN,[],2);
mean_clrfilter_mapNaN = nanmean(clrfilter_map,2);
std_clrfilter_mapNaN  = nanstd(clrfilter_map,[],2);

figure(13); clf; simplemap(pclear.rlat,pclear.rlon,rad2bt(1231,pclear.r1231)); colormap jet; cxU = caxis; title('Uniform clear')
figure(14); clf; simplemap(qXfilter_mapNaN); colormap jet; caxis(cxU); title('Q90')
figure(15); clf; junkdiff = simplemap(clrfilter_map-qXfilter_mapNaN); colormap(usa2);caxis([-1 +1]*5); title('Difference U/Clr-QX')
figure(16); dbbb = -5 : 0.1 : +5; plot(dbbb,histc(junkdiff(:),dbbb)); plotaxis2;; title('Histogram difference'); 

[YY] = rlat180' * ones(1,360); 
cosYY = cos(YY*pi/180);
[mw,sw] = weighted_mean_stddev(junkdiff,cosYY);
fprintf(1,'GLOBAL  : uniform/clear vs QX : mean,std dev and weighted mean/stddev : %8.6f +/- %8.6f K      %8.6f +/- %8.6f K \n',[nanmean(junkdiff(:)) nanstd(junkdiff(:)) mw sw])

moo = find(abs(YY) > 30); cosYYT = cosYY; cosYYY(moo) = NaN; junkdiffT = junkdiff; junkdiffT(moo) = NaN;
[mw,sw] = weighted_mean_stddev(junkdiffT,cosYYT);
fprintf(1,'TROPICS : uniform/clear vs QX : mean,std dev and weighted mean/stddev : %8.6f +/- %8.6f K      %8.6f +/- %8.6f K \n',[nanmean(junkdiff(:)) nanstd(junkdiff(:)) mw sw])

figure(11); errorbar(rlat180,mean_qXfilter_mapNaN,std_qXfilter_mapNaN,'b'); hold on; errorbar(rlat180,mean_clrfilter_mapNaN,std_clrfilter_mapNaN,'r'); hold off
hl = legend('QX filter','clear filter','location','south');
xlim([-90 +90])

addpath /home/sergio/MATLABCODE/PLOTMISC
figure(11);
  plot(rlat180,mean_qXfilter_mapNaN,'b',rlat180,mean_clrfilter_mapNaN,'r','linewidth',2);
  hold on
  shadedErrorBar(rlat180,mean_qXfilter_mapNaN,std_qXfilter_mapNaN,'b',0.3);
  shadedErrorBar(rlat180,mean_clrfilter_mapNaN,std_clrfilter_mapNaN,'r',0.3);
  hold off
hl = legend('QX filter','clear filter','location','south');
xlim([-90 +90]); ylabel('BT1231 observed (K)'); xlabel('Latitude [deg]');

figure(12); clf
mean_clrfilter_diff_mapNaN = nanmean(clrfilter_map - qXfilter_mapNaN,2);
std_clrfilter_diff_mapNaN  = nanstd(clrfilter_map - qXfilter_mapNaN,[],2);
errorbar(rlat180,mean_clrfilter_diff_mapNaN,std_clrfilter_diff_mapNaN,'r'); plotaxis2;
ylabel('uniform clear filter -  QX filter')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(8); figure(9); figure(11)
pos008 = gcf_location_position(008);
pos009 = gcf_location_position(009);
pos011 = gcf_location_position(011);
%% note they are all 560 W x 420 W

figure(300); close
junk = figure(300);
junk.Position = [100 100 560*3 420];
%junk.Position = [100 100 560*3/2 420*3/2];
%junk.Position = [100 100 1680 1260];
%junk.Position = [100 100 1680 800];


%% figure(300); close
%% h300 = figure(300);
%% set(h300, 'Resize', 'off');
%% set(h300,'Units', 'pixels', 'Position', [100 100 568*3/2 420*3/2]);
%% %ax = axes('Parent', f, 'Units', 'pixels', 'Position', [75 75 650 450]);
%% 
%% f = figure('Units', 'pixels', 'Position', [100 100 800 600]);
%% 

%% figure(300); close
%% h300 = figure(300);
%% left = 50;
%% bottom = 50;
%% width = 560*3;
%% height = 420*3 ;
%% h300.Position = [left, bottom, width, height];
%% 
%% % Create a new figure with the specified position
%% set(h300, 'Resize', 'off');
%% % set(h300,'Position', [left, bottom, width, height]);

%%%%%%%%%%%%%%%%%%%%%%%%%

pos300 = gcf_location_position(300);

ta = tiledlayout(1,3);
ta.OuterPosition = [0.0375 0.0375 0.925 0.925];

tafov(1) = nexttile;
clrfilter_map = simplemap(pclear.rlat,pclear.rlon,rad2bt(1231,pclear.r1231)); colormap jet; caxis(cx300);
set(gca,'fontsize',18)

tafov(2) = nexttile;
qXfilter_map  = simplemap(clr_rlat,clr_rlon,clr_r1231); caxis(cx300);
set(gca,'fontsize',18)

tafov(3) = nexttile; 
  plot(rlat180,mean_qXfilter_mapNaN,'b',rlat180,mean_clrfilter_mapNaN,'r','linewidth',2);
  hold on
  shadedErrorBar(rlat180,mean_qXfilter_mapNaN,std_qXfilter_mapNaN,'b',0.3);
  shadedErrorBar(rlat180,mean_clrfilter_mapNaN,std_clrfilter_mapNaN,'r',0.3);
  hold off
hl = legend('QX filter','clear filter','location','south');
xlim([-90 +90]); ylabel('BT1231 observed (K)'); xlabel('Latitude [deg]');
set(gca,'fontsize',18)

  % Get rid of all extra space I can
  ta.Padding = 'none';
  ta.TileSpacing = 'none';
  % Get rid of all extra space I can
  ta.Padding = 'tight';
  ta.TileSpacing = 'tight';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if iSaveJGR > 0
  data_fig2.comment = 'see ~/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries/do_the_plots_ecmwf_or_era_16days_tile_v2.m and then plot_QX_vs_uniformclear_filter.m';

  data_fig2.rlon360 = rlon360;
  data_fig2.rlat180 = rlat180;

  %data_fig2.uniform_clear_raw.rlat   = pclear.rlat;
  %data_fig2.uniform_clear_raw.rlon   = pclear.rlon;
  %data_fig2.uniform_clear_raw.bt1231 = rad2bt(1231,pclear.r1231);
  data_fig2.uniform_clear_180x380.bt1231 = clrfilter_map;

  %data_fig2.tileQ90_raw.rlat   = clr_rlat;
  %data_fig2.tileQ90_raw.rlon   = clr_rlon;
  %data_fig2.tileQ90_raw.bt1231 = clr_r1231;
  data_fig2.tileQ90_180x380.bt1231 = qXfilter_map;

  data_fig2.zonal.uniform_clear_mean = mean_qXfilter_mapNaN;
  data_fig2.zonal.uniform_clear_std  = std_qXfilter_mapNaN;
  data_fig2.zonal.Q90_mean = mean_clrfilter_mapNaN;
  data_fig2.zonal.Q90_std  = std_clrfilter_mapNaN;

  figure(108); clf; simplemap(data_fig2.uniform_clear_180x380.bt1231); colormap jet
  figure(109); clf; simplemap(data_fig2.tileQ90_180x380.bt1231); colormap jet
  figure(109); cx = caxis;
  figure(108); caxis(cx);

  figure(111);
  plot(data_fig2.rlat180,data_fig2.zonal.uniform_clear_mean,'b',data_fig2.rlat180,data_fig2.zonal.Q90_mean,'r','linewidth',2);
  hold on
  shadedErrorBar(data_fig2.rlat180,data_fig2.zonal.uniform_clear_mean,data_fig2.zonal.uniform_clear_std,'b',0.3);
  shadedErrorBar(data_fig2.rlat180,data_fig2.zonal.Q90_mean,data_fig2.zonal.Q90_std,'r',0.3);
  hold off
  hl = legend('QX filter','clear filter','location','south');
  xlim([-90 +90]); ylabel('BT1231 observed (K)'); xlabel('Latitude [deg]');

  figure(108); set(gca,'fontsize',18)
  figure(109); set(gca,'fontsize',18)
  figure(111); set(gca,'fontsize',18)

  %% save /home/sergio/MATLABCODE/oem_pkg_run/MATFILES_for_JGR_trends_paper/fig2.mat data_fig2
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
