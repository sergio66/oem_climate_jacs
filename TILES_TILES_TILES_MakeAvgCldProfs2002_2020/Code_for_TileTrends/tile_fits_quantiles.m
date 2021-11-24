function [] = tile_fits_quantiles(loni,lati,fdirpre,fnout,i16daysSteps,stopdate,startdate)

%% copied from /home/strow/Work/Airs/Tiles/tile_fits.m

if nargin < 5
  error('need 5 arguments loni,lati,fdirpre,fout,i16daysSteps')
end
if nargin == 5
  startdate = [2002 09 01];
  stopdate = [];
end
if nargin == 6
  startdate = [2002 09 01];
end

addpath /asl/matlib/aslutil
addpath /asl/matlib/time
addpath /home/strow/Matlab/Math
load_fairs

% loni = 40;
% lati = 1;

% % AIRS channel ID
% ch = 1520;

p = [-0.17 -0.15 -1.66  1.06];

fn = sprintf('LatBin%1$02d/LonBin%2$02d/summarystats_LatBin%1$02d_LonBin%2$02d_timesetps_001_%3$03d_V1.mat',lati,loni,i16daysSteps);
fn = fullfile(fdirpre,fn);

if exist(fn)
  fprintf(1,'tile_fits_quantiles.m :lati,loni = %2i %2i  loading %s with %3i i16daysSteps\n',lati,loni,fn,i16daysSteps)
  d = load(fn);
  if length(d.lat_asc) < i16daysSteps
    [length(d.lat_asc) i16daysSteps]
    error('length(d.lat_asc) < i16daysSteps')
  end
else
  fprintf(1,'tile_fits_quantiles.m :lati,loni = %2i %2i  %s with %3i i16daysSteps DNE \n',lati,loni,fn,i16daysSteps)
end

mtime = tai2dtime(airs2tai(d.tai93_desc));
dtime = datenum(mtime);

%k_desc = d.count_desc./median(d.count_desc) > 0.98 & (mtime <= datetime(2015,8,28));
%k_asc = d.count_asc./median(d.count_asc) > 0.98 & (mtime <= datetime(2015,8,28));
if nargin == 5
  fprintf(1,'  fitting entire data set \n')
  k_desc = d.count_desc./median(d.count_desc) > 0.98; % all data
  k_asc = d.count_asc./median(d.count_asc) > 0.98;    % all data
elseif nargin == 6
  fprintf(1,'  fitting till %4i/%2i/%2i \n',stopdate)
  k_desc = d.count_desc./median(d.count_desc) > 0.98 & (mtime <= datetime(stopdate(1),stopdate(2),stopdate(3)));
  k_asc = d.count_asc./median(d.count_asc) > 0.98 & (mtime <= datetime(stopdate(1),stopdate(2),stopdate(3)));
elseif nargin == 7
  fprintf(1,'  fitting between %4i/%2i/%2i and %4i/%2i/%2i \n',startdate,stopdate)
  k_desc = d.count_desc./median(d.count_desc) > 0.98 & (mtime >= datetime(startdate(1),startdate(2),startdate(3)) & mtime <= datetime(stopdate(1),stopdate(2),stopdate(3)));
  k_asc = d.count_asc./median(d.count_asc) > 0.98 & (mtime >= datetime(startdate(1),startdate(2),startdate(3)) & mtime <= datetime(stopdate(1),stopdate(2),stopdate(3)));
end

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
   [dbt_desc_tsurf(qi-11,:) stats] = Math_tsfit_lin_robust(dtime(k_desc)-dtime(1),desc_tsurf(k_desc),4);
%   dbt_desc_tsurf(qi-11,2)
   dbt_desc_tsurf_err(qi-11,2) = stats.se(2);
%   dbt_desc_tsurf_err(qi-11,2)

   r1231 = squeeze(d.rad_quantile_asc(:,1520,qi));
   r1228 = squeeze(d.rad_quantile_asc(:,1513,qi));
   bt1231 = rad2bt(fairs(1520),r1231);
   bt1228 = rad2bt(fairs(1513),r1228);
   asc_tsurf = bt1231 + polyval(p,bt1228 - bt1231);
   [dbt_asc_tsurf(qi-11,:) stats] = Math_tsfit_lin_robust(dtime(k_asc)-dtime(1),asc_tsurf(k_asc),4);
%   dbt_asc_tsurf(qi-11,2)
   dbt_asc_tsurf_err(qi-11,2) = stats.se(2);
%   dbt_asc_tsurf_err(qi-11,2)
end


warning off   
for qi = 1:16
  fprintf(1,'qi = %2i of 16 \n',qi);
  [ b_satzen_desc(qi,:) stats] = Math_tsfit_lin_robust(dtime(k_desc)-dtime(1),d.satzen_quantile1231_desc(k_desc,qi),1);
  berr_satzen_desc(qi,:) = stats.se;

  [ b_satzen_asc(qi,:) stats] = Math_tsfit_lin_robust(dtime(k_asc)-dtime(1),d.satzen_quantile1231_asc(k_asc,qi),1);
  berr_satzen_asc(qi,:) = stats.se;

  for ch = 1:2645
    % Desc
    r = squeeze(d.rad_quantile_desc(:,ch,qi));
    % bt = rad2bt(fairs(ch),squeeze(d.rad_quantile_desc(:,ch,qi)));
    [b_desc(ch,qi,:) stats] = Math_tsfit_lin_robust(dtime(k_desc)-dtime(1),r(k_desc),4);
    berr_desc(ch,qi,:) = stats.se;
    stats_desc(ch,qi,:) = [stats.ols_s stats.robust_s stats.mad_s stats.s stats.t(2) stats.p(2)];
    l = xcorr(stats.resid,1,'coeff');
    lag_desc(ch,qi) = l(1);
    deriv = drdbt(fairs(ch),rad2bt(fairs(ch),r(k_desc)));
    bt_resid = stats.resid./deriv;
    resid_desc_std(ch,qi) = nanstd(real(bt_resid));
      
    % Asc
    r = squeeze(d.rad_quantile_asc(:,ch,qi));
    %   bt = rad2bt(fairs(ch),squeeze(d.rad_quantile_asc(:,ch,qi)));
    [b_asc(ch,qi,:) stats] = Math_tsfit_lin_robust(dtime(k_asc)-dtime(1),r(k_asc),4);
    berr_asc(ch,qi,:) = stats.se;
    stats_asc(ch,qi,:) = [stats.ols_s stats.robust_s stats.mad_s stats.s stats.t(2) stats.p(2)];
    l = xcorr(stats.resid,1,'coeff');
    lag_asc(ch,qi) = l(1);
    deriv = drdbt(fairs(ch),rad2bt(fairs(ch),r(k_asc)));
    bt_resid = stats.resid./deriv;
    resid_asc_std(ch,qi) = nanstd(real(bt_resid));
  end

  % Convert b_trends and uncertainties to BT units
  deriv = drdbt(fairs,rad2bt(fairs,squeeze(b_desc(:,qi,1))));
  dbt_desc(:,qi)     = b_desc(:,qi,2)./deriv;
  dbt_err_desc(:,qi) = berr_desc(:,qi,2)./deriv;
     
  deriv = drdbt(fairs,rad2bt(fairs,squeeze(b_asc(:,qi,1))));
  dbt_asc(:,qi)     = b_asc(:,qi,2)./deriv;
  dbt_err_asc(:,qi) = berr_asc(:,qi,2)./deriv;
     
  % Correct dbt_ for lag-1 correlations (note b*(:,2) values NOT corrected for lag-1)
  lagc = sqrt( ( 1 + lag_desc(:,qi) ) ./ ( 1 - lag_desc(:,qi) ) ) ;
  dbt_err_desc(:,qi) = lagc .* dbt_err_desc(:,qi);
    
  lagc = sqrt( ( 1 + lag_asc(:,qi) ) ./ ( 1 - lag_asc(:,qi) ) ) ;
  dbt_err_asc(:,qi) = lagc .* dbt_err_asc(:,qi);
     
end
warning on

% Get rid of variables I don't want to save
quants = d.quants; % want to save these

clear d r deriv f lagc qi stats ans ch l 

% Create output dir if needed
%fout_dir = sprintf('LatBin%1$02d/LonBin%2$02d',lati,loni);
%fout_dir = fullfile(fdirpre_out,fout_dir)
%if exist(fout_dir) == 0
%   mkdir(fout_dir)
%end

if ~exist(fnout)
  fprintf(1,'saving to %s \n',fnout);
  save(fnout);
else
  fprintf(1,'oops %s already exists \n',fnout)
end

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

