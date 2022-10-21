function [] = tile_fits2(ilon,ilat)

addpath /asl/matlib/aslutil
addpath /asl/matlib/time
addpath ~/Matlab/Math
load_fairs

fdirpre = 'Data/Quantv2';
fdirpre_out = 'Data/Quantv2_fits';

p = [-0.17 -0.15 -1.66  1.06];

fn = sprintf('LatBin%1$02d/LonBin%2$02d/cfbins_LatBin%1$02d_LonBin%2$02d_V2.mat',ilat,ilon);
fn = fullfile(fdirpre,fn);

d = merge_v2(ilon,ilat);

mtime = tai2dtime(airs2tai(d.tai93_desc));
dtime = datenum(mtime);

k_desc = d.count_desc./nanmedian(d.count_desc) > 0.95 & (mtime <= datetime(2021,9,1));
k_asc = d.count_asc./nanmedian(d.count_asc) > 0.95 & (mtime <= datetime(2021,9,1));

count_desc = d.count_desc;
count_asc = d.count_asc;

b_asc = NaN(2645,8,10);
b_desc = NaN(2645,8,10);
berr_asc = NaN(2645,8,10);
berr_desc = NaN(2645,8,10);

dbt_asc = NaN(2645,8);
dbt_desc = NaN(2645,8);
dbt_err_asc = NaN(2645,8);
dbt_err_desc = NaN(2645,8);

resid_desc_std = NaN(2645,8);
resid_asc_std = NaN(2645,8);

% 6 values are:  ols_s, robust_s, mad_s, s, t(2), p(2) 
stats_desc = NaN(2645,8,6);
stats_asc = NaN(2645,8,6);

% Save channs 1513, 1520, 2600 for later work
rad1513_desc = d.r_desc(:,1,1513);
rad1520_desc = d.r_desc(:,1,1520);
rad2616_desc = d.r_desc(:,1,2600);

rad1513_asc = d.r_asc(:,1,1513);
rad1520_asc = d.r_asc(:,1,1520);
rad2616_asc = d.r_asc(:,1,2600);

tai93_asc = d.tai93_asc;
tai93_desc = d.tai93_desc;

% Run off tsurf using bt1231/bt1228 regression for qi = 8;  
for qi = 1:7
   if length(find(d.counts_desc_bin(:,qi))> 0) > 40
      [dbt_desc_tsurf(:,qi) stats] = Math_tsfit_lin_robust(dtime(k_desc)-dtime(1),d.tsurf_desc(k_desc,qi),4);
      dbt_desc_tsurf_err(:,qi) = stats.se(2);
      l = xcorr(stats.resid,1,'coeff');
      dbt_desc_tsurf_lag(qi) = l(1);
   else
      dbt_desc_tsurf_err(:,qi) = NaN;
      dbt_desc_tsurf_lag(qi) = NaN;
   end
   
   if length(find(d.counts_asc_bin(:,qi))> 0) > 40
      [dbt_asc_tsurf(:,qi) stats] = Math_tsfit_lin_robust(dtime(k_asc)-dtime(1),d.tsurf_asc(k_asc,qi),4);
      dbt_asc_tsurf_err(:,qi) = stats.se(2);
      l = xcorr(stats.resid,1,'coeff');
      dbt_asc_tsurf_lag(qi) = l(1);
   else
      dbt_asc_tsurf_err(:,qi) = NaN;
      dbt_asc_tsurf_lag(qi) = NaN;
   end
end

warning off   
% Desc
for qi = 1:7
qi
   
   if (length(find(d.counts_desc_bin(:,qi))> 0) > 40  &   length(find(d.counts_asc_bin(:,qi))> 0) > 40)
      [ b_satzen_desc(qi,:) stats] = Math_tsfit_lin_robust(dtime(k_desc)-dtime(1),d.satzen_desc(k_desc,qi),1);
      berr_satzen_desc(qi,:) = stats.se;

      [ b_satzen_asc(qi,:) stats] = Math_tsfit_lin_robust(dtime(k_asc)-dtime(1),d.satzen_asc(k_asc,qi),1);
      berr_satzen_asc(qi,:) = stats.se;
      
      [ b_solzen_desc(qi,:) stats] = Math_tsfit_lin_robust(dtime(k_desc)-dtime(1),d.solzen_desc(k_desc,qi),1);
      berr_solzen_desc(qi,:) = stats.se;

      [ b_solzen_asc(qi,:) stats] = Math_tsfit_lin_robust(dtime(k_asc)-dtime(1),d.solzen_asc(k_asc,qi),1);
      berr_solzen_asc(qi,:) = stats.se;
      
      for ch = 1:2645
         r = squeeze(d.r_desc(:,qi,ch));
         [b_desc(ch,qi,:) stats] = Math_tsfit_lin_robust(dtime(k_desc)-dtime(1),r(k_desc),4);
         berr_desc(ch,qi,:) = stats.se;
         stats_desc(ch,qi,:) = [stats.ols_s stats.robust_s stats.mad_s stats.s stats.t(2) stats.p(2)];
         l = xcorr(stats.resid,1,'coeff');
         lag_desc(ch,qi) = l(1);
         deriv = drdbt(fairs(ch),rad2bt(fairs(ch),r(k_desc)));
         bt_resid = stats.resid./deriv;
         resid_desc_std(ch,qi) = nanstd(real(bt_resid));
         
% Asc

         r = squeeze(d.r_asc(:,qi,ch));
%     bt = rad2bt(fairs(ch),squeeze(d.rad_asc(:,ch,qi)));
         [b_asc(ch,qi,:) stats] = Math_tsfit_lin_robust(dtime(k_asc)-dtime(1),r(k_asc),4);
         berr_asc(ch,qi,:) = stats.se;
         stats_asc(ch,qi,:) = [stats.ols_s stats.robust_s stats.mad_s stats.s stats.t(2) stats.p(2)];
         l = xcorr(stats.resid,1,'coeff');
         lag_asc(ch,qi) = l(1);
         deriv = drdbt(fairs(ch),rad2bt(fairs(ch),r(k_asc)));
         bt_resid = stats.resid./deriv;
         resid_asc_std(ch,qi) = nanstd(real(bt_resid));
         end


% Convert b_ trends and uncertainties to BT units
      deriv = drdbt(fairs,rad2bt(fairs,squeeze(b_desc(:,qi,1))));
      dbt_desc(:,qi)     = b_desc(:,qi,2)./deriv;
      dbt_err_desc(:,qi) = berr_desc(:,qi,2)./deriv;
      
      deriv = drdbt(fairs,rad2bt(fairs,squeeze(b_asc(:,qi,1))));
      dbt_asc(:,qi)     = b_asc(:,qi,2)./deriv;
      dbt_err_asc(:,qi) = berr_asc(:,qi,2)./deriv;
      

% Correct dbt_ for lag-1 correilatons (note b*(:,2) values NOT corrected for lag-1)
      lagc = sqrt( ( 1 + lag_desc(:,qi) ) ./ ( 1 - lag_desc(:,qi) ) ) ;
      dbt_err_desc(:,qi) = lagc .* dbt_err_desc(:,qi);
      
      lagc = sqrt( ( 1 + lag_asc(:,qi) ) ./ ( 1 - lag_asc(:,qi) ) ) ;
      dbt_err_asc(:,qi) = lagc .* dbt_err_asc(:,qi);
   else
   end
end


qi = 8;  % do fits for averaged radiances
for ch = 1:2645
   r = squeeze(d.r_desc_all(:,ch));
   [b_desc(ch,qi,:) stats] = Math_tsfit_lin_robust(dtime(k_desc)-dtime(1),r(k_desc),4);
   berr_desc(ch,qi,:) = stats.se;
   stats_desc(ch,qi,:) = [stats.ols_s stats.robust_s stats.mad_s stats.s stats.t(2) stats.p(2)];
   l = xcorr(stats.resid,1,'coeff');
   lag_desc(ch,qi) = l(1);
   deriv = drdbt(fairs(ch),rad2bt(fairs(ch),r(k_desc)));
   bt_resid = stats.resid./deriv;
   resid_desc_std(ch,qi) = nanstd(real(bt_resid));
   
% Asc
   r = squeeze(d.r_asc_all(:,ch));
%     bt = rad2bt(fairs(ch),squeeze(d.rad_asc(:,ch,qi)));
   [b_asc(ch,qi,:) stats] = Math_tsfit_lin_robust(dtime(k_asc)-dtime(1),r(k_asc),4);
   berr_asc(ch,qi,:) = stats.se;
   stats_asc(ch,qi,:) = [stats.ols_s stats.robust_s stats.mad_s stats.s stats.t(2) stats.p(2)];
   l = xcorr(stats.resid,1,'coeff');
   lag_asc(ch,qi) = l(1);
   deriv = drdbt(fairs(ch),rad2bt(fairs(ch),r(k_asc)));
   bt_resid = stats.resid./deriv;
   resid_asc_std(ch,qi) = nanstd(real(bt_resid));

% Convert b_ trends and uncertainties to BT units
   deriv = drdbt(fairs,rad2bt(fairs,squeeze(b_desc(:,qi,1))));
   dbt_desc(:,qi)     = b_desc(:,qi,2)./deriv;
   dbt_err_desc(:,qi) = berr_desc(:,qi,2)./deriv;
   
   deriv = drdbt(fairs,rad2bt(fairs,squeeze(b_asc(:,qi,1))));
   dbt_asc(:,qi)     = b_asc(:,qi,2)./deriv;
   dbt_err_asc(:,qi) = berr_asc(:,qi,2)./deriv;
   

% Correct dbt_ for lag-1 correilatons (note b*(:,2) values NOT corrected for lag-1)
   lagc = sqrt( ( 1 + lag_desc(:,qi) ) ./ ( 1 - lag_desc(:,qi) ) ) ;
   dbt_err_desc(:,qi) = lagc .* dbt_err_desc(:,qi);
   
   lagc = sqrt( ( 1 + lag_asc(:,qi) ) ./ ( 1 - lag_asc(:,qi) ) ) ;
   dbt_err_asc(:,qi) = lagc .* dbt_err_asc(:,qi);
end

warning on

% Get rid of variables I don't want to save
quants = d.quants; % want to save these

% keep counts
counts_desc_bin = d.counts_desc_bin;
counts_asc_bin = d.counts_asc_bin;

clear d r deriv f lagc qi stats ans ch l 

% Create output dir if needed
fnout_dir = sprintf('LatBin%1$02d/LonBin%2$02d',ilat,ilon);
fnout_dir = fullfile(fdirpre_out,fnout_dir)
if exist(fnout_dir) == 0
   mkdir(fnout_dir)
end

% Create outputfile name and save

fnout = sprintf('LatBin%1$02d/LonBin%2$02d/fits_19year_LatBin%1$02d_LonBin%2$02d_V2.mat',ilat,ilon);
fnout = fullfile(fdirpre_out,fnout);

save(fnout);


%   count_asc                        1x412                     3296  double                
%   count_desc                       1x412                     3296  double                
% 
%   lat_asc                          1x412                     3296  double                
%   lat_desc                         1x412                     3296  double                
%   
%   lon_asc                          1x412                     3296  double                
%   lon_desc                         1x412                     3296  double                
%   
%   meanBT_asc                     412x2645                 4358960  single                
%   meanBT_desc                    412x2645                 4358960  single                
%   
%   quantile1231_asc               412x16                     52736  double                
%   quantile1231_desc              412x16                     52736  double                
%   quants                           1x17                       136  double                
%   
%   rad_quantile_asc               412x2645x16            139486720  double                
%   rad_quantile_desc              412x2645x16            139486720  double                
%   
%   satzen_asc                       1x412                     3296  double                
%   satzen_desc                      1x412                     3296  double                
%   
%   satzen_quantile1231_asc        412x16                     52736  double                
%   satzen_quantile1231_desc       412x16                     52736  double                
%   
%   solzen_asc                       1x412                     3296  double                
%   solzen_desc                      1x412                     3296  double                
%   
%   solzen_quantile1231_asc        412x16                     52736  double                
%   solzen_quantile1231_desc       412x16                     52736  double                
% 
%   tai93_asc                        1x412                     3296  double                
%   tai93_desc                       1x412                     3296  double                





end

