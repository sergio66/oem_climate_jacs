%% see /home/sergio/MATLABCODE/oem_pkg_run/FIND_NWP_MODEL_TRENDS/driver_computeERA5_monthly_trends_NIGHT_or_DAY_or_BOTH.m

addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/StrowCodeforTrendsAndAnomalies/
addpath /home/sergio/MATLABCODE/COLORMAP
addpath /home/sergio/MATLABCODE/COLORMAP/LLS

system_slurm_stats

%JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
%if length(JOB) == 0
%  JOB = 1;
%end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('doing AMSU calc')
for JOB = 1 : -240
  fprintf(1,'JOB = %3i \n',JOB);

  fdir = '/asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_v3/TimeSeries/ERA5/Tile_Center/DESC/';
  fname = ['era5_tile_center_monthly_' num2str(JOB,'%03d') '.mat'];
  
  fop = ['AMSU_12channels_20years/SARTA_CALCS/junk' num2str(JOB,'%03d') '.op.rtp'];
  frp = ['AMSU_12channels_20years/SARTA_CALCS/junk' num2str(JOB,'%03d') '.rp.rtp'];
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  loader = ['load ' fdir fname];
  eval(loader);
  h = hnew_op;
  p = pnew_op;
    h.nchan = 13;
    h.ichan = (1:13)';
    h = rmfield(h,'vchan');
    p.robs1 = zeros(13,4608);
    p.rcalc = zeros(13,4608);
    p = rmfield(p,'sarta_rclearcalc');
    p = rmfield(p,'nemis');
    p = rmfield(p,'emis');
    p = rmfield(p,'rho');
  
  rtpwrite(fop,h,[],p,[]);
  
  sarta = '/home/sergio/SARTA_CLOUDY_RTP_KLAYERS_NLEVELS/SARTA_MW/mrta_rtp201/BinV201/mwsarta_amsua';
  sartaer = ['!time ' sarta ' fin=' fop ' fout=' frp ' >& ugh'];
  eval(sartaer);
  
  [h2,ha,p2,pa] = rtpread(frp);
  
  rmer = ['!/bin/rm ' fop ' ' frp];
  eval(rmer)
  
  fchan = h2.vchan;
  rcalc = p2.rcalc;
  
  fout = ['AMSU_12channels_20years/SARTA_CALCS/amsu_sarta' num2str(JOB,'%03d') '.mat'];
  comment = 'see /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/AMSU_12channels_20years_Trends_Anomalies/clust_driver_compute_AMSU_BT_20years_ERA5.m';
  saver = ['save ' fout ' comment fchan rcalc'];
  eval(saver)
end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('gathering AMSU calc')
radsall = zeros(240,13,4608);
for JOB = 1 : 240
  fout = ['AMSU_12channels_20years/SARTA_CALCS/amsu_sarta' num2str(JOB,'%03d') '.mat'];
  loader = ['load ' fout];
  eval(loader);
  radsall(JOB,:,:) = rcalc;
end
  
days = (1:240)*365.25/12;
for iTile = 1 : 4608
  if mod(iTile,1000) == 0
    fprintf(1,'+')
  elseif mod(iTile,100) == 0
    fprintf(1,'.')
  end
  for iChan = 1 : 13
    data = squeeze(radsall(:,iChan,iTile));
    good = find(isfinite(data));
    if length(good) > 10
      [B, stats, err] = Math_tsfit_lin_robust(days(good),data(good)',4);
      trend_sarta(iChan,iTile) = B(2);
      trend_sarta_err(iChan,iTile) = stats.se(2);
    else
      trend_sarta(iChan,iTile) = NaN;
      trend_sarta_err(iChan,iTile) = NaN;
    end
  end
end

%% https://www.star.nesdis.noaa.gov/jpss/documents/AMM_All/ATMS_SDR/Provisional/ATMS-GPS-RO-calibration.pdf
pseudo_p = [1085 892 606 351 253 165 86 49 24 10 5] ;

load llsmap5
wah = trend_sarta(4:13,:);
wah = reshape(wah,10,72,64);
wah = squeeze(nanmean(wah,2));
figure(3); pcolor(1:64,pseudo_p(1:10),wah); shading interp; caxis([-1 +1]*0.15); colormap(llsmap5); colorbar; set(gca,'ydir','reverse'); set(gca,'yscale','log');
title('ERA5 through SARTA AMSU')

%{
save AMSU_12channels_20years/SARTA_CALCS/amsu_sarta_trends trend_sarta trend_sarta_err pseudo_p days comment
%}
