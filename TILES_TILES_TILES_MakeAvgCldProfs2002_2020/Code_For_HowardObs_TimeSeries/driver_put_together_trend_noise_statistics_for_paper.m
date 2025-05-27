% z=load('/umbc/xfs2/strow/asl/s1/sergio/home/git/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_for_TileTrends/../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin02/LonBin06/iQAX_3_fits_LonBin06_LatBin02_V1_TimeSteps457.mat');

stats.bt_avg_asc      = nan(4608,2645);
stats.bt_trend_asc    = nan(4608,2645);
stats.bterr_avg_asc   = nan(4608,2645);
stats.bterr_trend_asc = nan(4608,2645);
stats.resid_std_asc   = nan(4608,2645);
stats.lag_asc         = nan(4608,2645);

stats.bt_avg_desc     = nan(4608,2645);
stats.bt_trend_desc   = nan(4608,2645);
stats.bterr_avg_desc  = nan(4608,2645);
stats.bterr_trend_desc= nan(4608,2645);
stats.resid_std_desc  = nan(4608,2645);
stats.lag_desc        = nan(4608,2645);

iQ = 3; %% 5 quantiles, takes iQuant = 3
dir0 = ['/umbc/xfs2/strow/asl/s1/sergio/home/git/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_for_TileTrends/../DATAObsStats_StartSept2002_CORRECT_LatLon/'];
dir0 = ['/umbc/xfs2/strow/asl/s1/sergio/home/git/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/DATAObsStats_StartSept2002_CORRECT_LatLon/'];
for jj = 1 : 64
  for ii = 1 : 72
    JOB = (jj-1)*72 + ii;
    latbin = floor((JOB-1)/72) + 1;
    lonbin = JOB - (latbin-1)*72;
    fname = [dir0 '/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/iQAX_3_fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_TimeSteps457.mat'];
    ee = exist(fname);
    fprintf(1,'%4i %2i %2i     %2i %2i     %2i %2i       %2i \n',JOB,latbin,lonbin,jj,ii,latbin-jj,lonbin-ii,ee)

    a = load(fname);

    stats.bt_avg_asc(JOB,:)      = squeeze(a.b_asc(:,iQ,1));
    stats.bt_trend_asc(JOB,:)    = squeeze(a.b_asc(:,iQ,2));
    stats.bterr_avg_asc(JOB,:)   = squeeze(a.berr_asc(:,iQ,1));
    stats.bterr_trend_asc(JOB,:) = squeeze(a.berr_asc(:,iQ,2));
    stats.resid_std_asc(JOB,:)   = a.resid_asc_std(:,iQ);
    stats.lag_asc(JOB,:)         = a.lag_asc(:,iQ);

    stats.bt_avg_desc(JOB,:)      = squeeze(a.b_desc(:,iQ,1));
    stats.bt_trend_desc(JOB,:)    = squeeze(a.b_desc(:,iQ,2));
    stats.bterr_avg_desc(JOB,:)   = squeeze(a.berr_desc(:,iQ,1));
    stats.bterr_trend_desc(JOB,:) = squeeze(a.berr_desc(:,iQ,2));
    stats.resid_std_desc(JOB,:)   = a.resid_desc_std(:,iQ);
    stats.lag_desc(JOB,:)         = a.lag_desc(:,iQ);


%  dbt_desc(:,qi)     = b_desc(:,qi,2)./deriv;
%  dbt_err_desc(:,qi) = berr_desc(:,qi,2)./deriv;
%  dbt_asc(:,qi)     = b_asc(:,qi,2)./deriv;
%  dbt_err_asc(:,qi) = berr_asc(:,qi,2)./deriv;

  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load ../Code_for_TileTrends/airs_f.mat
stats.fairs = fairs;

savename = ['../TrendsPaper_Reviewer_UNC/quicksummary_64x72_Q03.mat'];
stats.comment      = 'see /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries/driver_put_together_trend_noise_statistics_for_paper.m';
stats.examplefname = fname;

saver = ['save(savename,''-struct'',''stats'');'];
eval(saver);

figure(1); plot(stats.fairs,nanmean(stats.bt_avg_asc,1));      title('Avg Value (rad)')
figure(2); plot(stats.fairs,nanmean(stats.bt_trend_asc,1));    title('Avg Trend (rad)')
figure(3); plot(stats.fairs,nanmean(stats.bterr_trend_asc,1)); title('Avg Trend unc (rad)')
figure(4); plot(stats.fairs,nanmean(stats.resid_std_asc,1));   title('Avg StdResid (K)')
