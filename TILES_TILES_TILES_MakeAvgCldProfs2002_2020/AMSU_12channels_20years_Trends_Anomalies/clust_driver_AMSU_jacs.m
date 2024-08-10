%% see /home/sergio/MATLABCODE/oem_pkg_run/FIND_NWP_MODEL_TRENDS/driver_computeERA5_monthly_trends_NIGHT_or_DAY_or_BOTH.m

addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/StrowCodeforTrendsAndAnomalies/
addpath /home/sergio/MATLABCODE/COLORMAP
addpath /home/sergio/MATLABCODE/COLORMAP/LLS
addpath /home/sergio/MATLABCODE_Git/AIRS_IASI_AMSU_JACS_gas_T
addpath /home/sergio/MATLABCODE/matlib/rtp_prod2/util/

system_slurm_stats

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
if length(JOB) == 0
  JOB = 0001;   %% JOB = 1 : 4608
  JOB = 2001;   %% JOB = 1 : 4608
  JOB = 1598;   %% JOB = 1 : 4608
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('doing AMSU calc')
  fprintf(1,'JOB = %3i \n',JOB);

  favg = '/home/sergio/KCARTA/WORK/RUN_TARA/GENERIC_RADSnJACS_MANYPROFILES/RTP/summary_20years_all_lat_all_lon_2002_2022_monthlyERA5.rp.rtp';
  [h,ha,p,pa] = rtpread(favg);
  [p.salti,p.landfrac] = usgs_deg10_dem(p.rlat, p.rlon);
  [hnew_op,pnew_op] = subset_rtp(h,p,[],[],JOB);

  fop = ['junk' num2str(JOB,'%04d') '.op.rtp'];
  frp = ['junk' num2str(JOB,'%04d') '.rp.rtp'];
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  h = hnew_op;
  p = pnew_op;
    h.nchan = 13;
    h.ichan = int32((1:13)');
    h = rmfield(h,'vchan');
    p.robs1 = zeros(13,4608);
    p.rcalc = zeros(13,4608);
    if isfield(p,'sarta_rclearcalc')
      p = rmfield(p,'sarta_rclearcalc');
    end
    p = rmfield(p,'nemis');
    p = rmfield(p,'emis');
    p = rmfield(p,'rho');
  
  jac = driver_amsu_jacs(h,p,1,fop,frp);

  comment = 'see /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/AMSU_12channels_20years_Trends_Anomalies/clust_driver_AMSU_jacs.m';
  saver = ['save JAC_20year_avg/amsu_jacT_ST_WV_' num2str(JOB,'%04d') '.mat jac comment'];
  eval(saver)

figure(1); clf; pcolor(jac.wvnm,meanvaluebin(jac.plevs),jac.T'); shading interp;  xlabel('wavenumber GHz'); colorbar; colormap(jet); set(gca,'ydir','reverse'); title('T jac');
figure(2); clf; pcolor(jac.wvnm,meanvaluebin(jac.plevs),jac.WV'); shading interp; xlabel('wavenumber GHz'); colorbar; colormap(jet); set(gca,'ydir','reverse'); title('WV jac');
figure(3); clf; plot(jac.wvnm,jac.ST'); title('ST jac');; plotaxis2; xlabel('wavenumber GHz');
