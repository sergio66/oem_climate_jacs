function [] = tile_fits_just_tsurf(loni,lati)

loni
lati

addpath /asl/matlib/aslutil
addpath /asl/matlib/time
addpath ~/Matlab/Math
load_fairs

fdirpre = 'Data/Quantv1';
fdirpre_out = 'Data/Quantv1_fits';

% loni = 40;
% lati = 1;

% % AIRS channel ID
% ch = 1520;

p = [-0.17 -0.15 -1.66  1.06];

fn = sprintf('LatBin%1$02d/LonBin%2$02d/summarystats_LatBin%1$02d_LonBin%2$02d_timesetps_001_412_V1.mat',lati,loni);
fn = fullfile(fdirpre,fn);

d = load(fn);

mtime = tai2dtime(airs2tai(d.tai93_desc));
dtime = datenum(mtime);

k_desc = d.count_desc./median(d.count_desc) > 0.90 & (mtime <= datetime(2020,8,28));
k_asc = d.count_asc./median(d.count_asc) > 0.90 & (mtime <= datetime(2020,8,28));

b_asc = NaN(2645,16,10);
b_desc = NaN(2645,16,10);
berr_asc = NaN(2645,16,10);
berr_desc = NaN(2645,16,10);

dbt_asc = NaN(2645,16);
dbt_desc = NaN(2645,16);
dbt_err_asc = NaN(2645,16);
dbt_err_desc = NaN(2645,16);

resid_desc_std = NaN(2645,16);
resid_asc_std = NaN(2645,16);

% 6 values are:  ols_s, robust_s, mad_s, s, t(2), p(2) 
stats_desc = NaN(2645,16,6);
stats_asc = NaN(2645,16,6);

% Run off tsurf using bt1231/bt1228 regression for qi = 16;  
for qi = 12:16
   r1231 = squeeze(d.rad_quantile_desc(:,1520,qi));
   r1228 = squeeze(d.rad_quantile_desc(:,1513,qi));
   bt1231 = rad2bt(fairs(1520),r1231);
   bt1228 = rad2bt(fairs(1513),r1228);
   desc_tsurf = bt1231 + polyval(p,bt1228 - bt1231);
   all_desc_tsurf(qi-11,:) = desc_tsurf;
   [dbt_desc_tsurf(qi-11,:) stats] = Math_tsfit_lin_robust(dtime(k_desc)-dtime(1),desc_tsurf(k_desc),4);
%   dbt_desc_tsurf(qi-11,2)
   dbt_desc_tsurf_err(qi-11,2) = stats.se(2);
%   dbt_desc_tsurf_err(qi-11,2)
    l = xcorr(stats.resid,1,'coeff');
    lag_desc_tsurf(qi-11) = l(1);

   
   r1231 = squeeze(d.rad_quantile_asc(:,1520,qi));
   r1228 = squeeze(d.rad_quantile_asc(:,1513,qi));
   bt1231 = rad2bt(fairs(1520),r1231);
   bt1228 = rad2bt(fairs(1513),r1228);
   asc_tsurf = bt1231 + polyval(p,bt1228 - bt1231);
   all_asc_tsurf(qi-11,:) = asc_tsurf;
   [dbt_asc_tsurf(qi-11,:) stats] = Math_tsfit_lin_robust(dtime(k_asc)-dtime(1),asc_tsurf(k_asc),4);
%   dbt_asc_tsurf(qi-11,2)
   dbt_asc_tsurf_err(qi-11,2) = stats.se(2);
%   dbt_asc_tsurf_err(qi-11,2)
    l = xcorr(stats.resid,1,'coeff');
    lag_asc_tsurf(qi-11) = l(1);


end


% warning off   
% % Desc
% for qi = 1:16
% qi   
%    [ b_satzen_desc(qi,:) stats] = Math_tsfit_lin_robust(dtime(k_desc)-dtime(1),d.satzen_quantile1231_desc(k_desc,qi),1);
%    berr_satzen_desc(qi,:) = stats.se;
% 
%    [ b_satzen_asc(qi,:) stats] = Math_tsfit_lin_robust(dtime(k_asc)-dtime(1),d.satzen_quantile1231_asc(k_asc,qi),1);
%    berr_satzen_asc(qi,:) = stats.se;
% 
% 
%    
%    for ch = 1:2645
%       r = squeeze(d.rad_quantile_desc(:,ch,qi));
% %       bt = rad2bt(fairs(ch),squeeze(d.rad_quantile_desc(:,ch,qi)));
%       [b_desc(ch,qi,:) stats] = Math_tsfit_lin_robust(dtime(k_desc)-dtime(1),r(k_desc),4);
%       berr_desc(ch,qi,:) = stats.se;
%       stats_desc(ch,qi,:) = [stats.ols_s stats.robust_s stats.mad_s stats.s stats.t(2) stats.p(2)];
%       l = xcorr(stats.resid,1,'coeff');
%       lag_desc(ch,qi) = l(1);
%       deriv = drdbt(fairs(ch),rad2bt(fairs(ch),r(k_desc)));
%       bt_resid = stats.resid./deriv;
%       resid_desc_std(ch,qi) = nanstd(real(bt_resid));
%       
% % Asc
%       r = squeeze(d.rad_quantile_asc(:,ch,qi));
% %     bt = rad2bt(fairs(ch),squeeze(d.rad_quantile_asc(:,ch,qi)));
%       [b_asc(ch,qi,:) stats] = Math_tsfit_lin_robust(dtime(k_asc)-dtime(1),r(k_asc),4);
%       berr_asc(ch,qi,:) = stats.se;
%       stats_asc(ch,qi,:) = [stats.ols_s stats.robust_s stats.mad_s stats.s stats.t(2) stats.p(2)];
%       l = xcorr(stats.resid,1,'coeff');
%       lag_asc(ch,qi) = l(1);
%       deriv = drdbt(fairs(ch),rad2bt(fairs(ch),r(k_asc)));
%       bt_resid = stats.resid./deriv;
%       resid_asc_std(ch,qi) = nanstd(real(bt_resid));
%    end
% 
%    % Convert b_ trends and uncertainties to BT units
%      deriv = drdbt(fairs,rad2bt(fairs,squeeze(b_desc(:,qi,1))));
%      dbt_desc(:,qi)     = b_desc(:,qi,2)./deriv;
%      dbt_err_desc(:,qi) = berr_desc(:,qi,2)./deriv;
%      
%      deriv = drdbt(fairs,rad2bt(fairs,squeeze(b_asc(:,qi,1))));
%      dbt_asc(:,qi)     = b_asc(:,qi,2)./deriv;
%      dbt_err_asc(:,qi) = berr_asc(:,qi,2)./deriv;
%      
% 
% % Correct dbt_ for lag-1 correlations (note b*(:,2) values NOT corrected for lag-1)
%      lagc = sqrt( ( 1 + lag_desc(:,qi) ) ./ ( 1 - lag_desc(:,qi) ) ) ;
%      dbt_err_desc(:,qi) = lagc .* dbt_err_desc(:,qi);
%      
%      lagc = sqrt( ( 1 + lag_asc(:,qi) ) ./ ( 1 - lag_asc(:,qi) ) ) ;
%      dbt_err_asc(:,qi) = lagc .* dbt_err_asc(:,qi);
%      
% end
% warning on
% 
% Get rid of variables I don't want to save
quants = d.quants; % want to save these

clear d r deriv f lagc qi stats ans ch l 

% Create output dir if needed
fnout_dir = sprintf('LatBin%1$02d/LonBin%2$02d',lati,loni);
fnout_dir = fullfile(fdirpre_out,fnout_dir)
if exist(fnout_dir) == 0
   mkdir(fnout_dir)
end

% Create outputfile name and save

fnout = sprintf('LatBin%1$02d/LonBin%2$02d/tsurf_lag_fits_LonBin%2$02d_LatBin%1$02d_V1.mat',lati,loni);
fnout = fullfile(fdirpre_out,fnout);

save(fnout,'lag_desc_tsurf','lag_asc_tsurf');


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

