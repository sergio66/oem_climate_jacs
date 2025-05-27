function trends_stats = find_trends_lagcoeff(out,quants);
%% see also z = load('/umbc/xfs2/strow/asl/s1/sergio/home/git/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_for_TileTrends/../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin32/LonBin36/iQAX_3_fits_LonBin36_LatBin32_V1_200200090001_201700080031_TimeStepsX342.mat');

%% z = load('/umbc/xfs2/strow/asl/s1/sergio/home/git/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_for_TileTrends/../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin32/LonBin36/iQAX_3_fits_LonBin36_LatBin32_V1_TimeSteps457.mat');
%% z = load('/umbc/xfs2/strow/asl/s1/sergio/home/git/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_for_TileTrends/../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin32/LonBin36/iQAX_3_fits_LonBin36_LatBin32_V1_TimeSteps457.mat');
%% z = load('/umbc/xfs2/strow/asl/s1/sergio/home/git/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_for_TileTrends/../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin32/LonBin36/iQAX_3_fits_LonBin36_LatBin32_V1_TimeSteps457.mat');

  
%% see Code_for_TileTrends/tile_fits_quantiles.m

addpath /asl/matlib/aslutil
addpath /asl/matlib/time
addpath /home/strow/Matlab/Math

load ../Code_for_TileTrends/airs_f.mat

%mtime = tai2dtime(airs2tai(d.tai93_desc + offset1958_to_1993));
%mtime = tai2dtime(airs2tai(d.tai93_desc));
mtime = tai2dtime(airs2tai(out.mean_rtime)); 
dtime = datenum(mtime); 

k = find(out.mean_rad_1231 > 0);
k_desc = k;
k_asc = k;

numQuant = length(quants)-1;

b_asc          = NaN(2645,numQuant,10);
b_desc         = NaN(2645,numQuant,10);
berr_asc       = NaN(2645,numQuant,10);
berr_desc      = NaN(2645,numQuant,10);
lag_asc        = NaN(2645,numQuant);
lag_desc       = NaN(2645,numQuant);
resid_asc_std  = NaN(2645,numQuant);
resid_desc_std = NaN(2645,numQuant);
dbt_asc        = NaN(2645,numQuant);
dbt_desc       = NaN(2645,numQuant);
dbt_err_asc    = NaN(2645,numQuant);
dbt_err_desc   = NaN(2645,numQuant);

iNumSineCosCycles = 4;

warning off
for qi = 1:numQuant
  fprintf(1,'\n');
  fprintf(1,'qi = %2i of %2i \n',qi,numQuant);
  for ch = 1:2645
    if mod(ch,1000) == 0
      fprintf(1,'x');
    elseif mod(ch,100) == 0
      fprintf(1,'.');
    end
    
    % Asc
    r = squeeze(out.asc_quantile.rad_asc(:,qi,ch));
    % bt = rad2bt(fairs(ch),squeeze(out.asc_quantile.rad_asc(:,ch,qi)));
    [b_asc(ch,qi,:) stats] = Math_tsfit_lin_robust(dtime(k_asc)-dtime(k_asc(1)),r(k_asc),iNumSineCosCycles);
    berr_asc(ch,qi,:) = stats.se;
    stats_asc(ch,qi,:) = [stats.ols_s stats.robust_s stats.mad_s stats.s stats.t(2) stats.p(2)];
    l = xcorr(stats.resid,1,'coeff');
    lag_asc(ch,qi) = l(1);
    deriv = drdbt(fairs(ch),rad2bt(fairs(ch),r(k_asc)));
    bt_resid = stats.resid./deriv;
    resid_asc_std(ch,qi) = nanstd(real(bt_resid));
	     
    % Desc
    r = squeeze(out.desc_quantile.rad_desc(:,qi,ch));
    % bt = rad2bt(fairs(ch),squeeze(out.desc_quantile.rad_desc(:,ch,qi)));
    [b_desc(ch,qi,:) stats] = Math_tsfit_lin_robust(dtime(k_desc)-dtime(k_desc(1)),r(k_desc),iNumSineCosCycles);
    berr_desc(ch,qi,:) = stats.se;
    stats_desc(ch,qi,:) = [stats.ols_s stats.robust_s stats.mad_s stats.s stats.t(2) stats.p(2)];
    l = xcorr(stats.resid,1,'coeff');
    lag_desc(ch,qi) = l(1);
    deriv = drdbt(fairs(ch),rad2bt(fairs(ch),r(k_desc)));
    bt_resid = stats.resid./deriv;
    resid_desc_std(ch,qi) = nanstd(real(bt_resid));
  end

  % Convert b_trends and uncertainties to BT units
  % <<< *** /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/driver_put_together_QuantileChoose_trends.m uses these *** >>>
  %      b_asc(iLon,iLat,:) = x.dbt_asc(:,iQuantile);
  %      b_desc(iLon,iLat,:) = x.dbt_desc(:,iQuantile);
  % <<< *** /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/driver_put_together_QuantileChoose_trends.m uses these *** >>>
  deriv = drdbt(fairs,rad2bt(fairs,squeeze(b_desc(:,qi,1))));
  dbt_desc(:,qi)     = b_desc(:,qi,2)./deriv;
  dbt_err_desc(:,qi) = berr_desc(:,qi,2)./deriv;
  deriv = drdbt(fairs,rad2bt(fairs,squeeze(b_asc(:,qi,1))));
  dbt_asc(:,qi)     = b_asc(:,qi,2)./deriv;
  dbt_err_asc(:,qi) = berr_asc(:,qi,2)./deriv;
  % <<< *** /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/driver_put_together_QuantileChoose_trends.m uses these *** >>>     
     
  % Correct dbt_ for lag-1 correlations (note b*(:,2) values NOT corrected for lag-1)
  lagc = sqrt( ( 1 + lag_desc(:,qi) ) ./ ( 1 - lag_desc(:,qi) ) ) ;
  dbt_err_desc(:,qi) = lagc .* dbt_err_desc(:,qi);
    
  lagc = sqrt( ( 1 + lag_asc(:,qi) ) ./ ( 1 - lag_asc(:,qi) ) ) ;
  dbt_err_asc(:,qi) = lagc .* dbt_err_asc(:,qi);
  
end
warning on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

trends_stats.b_asc          = b_asc;
trends_stats.b_desc         = b_desc;
trends_stats.berr_asc       = berr_asc;
trends_stats.berr_desc      = berr_desc;
trends_stats.lag_asc        = lag_asc;
trends_stats.lag_desc       = lag_desc;
trends_stats.resid_asc_std  = resid_asc_std;
trends_stats.resid_desc_std = resid_desc_std;
trends_stats.dbt_asc        = dbt_asc;
trends_stats.dbt_desc       = dbt_desc;
trends_stats.dbt_err_asc    = dbt_err_asc;
trends_stats.dbt_err_desc   = dbt_err_desc;

