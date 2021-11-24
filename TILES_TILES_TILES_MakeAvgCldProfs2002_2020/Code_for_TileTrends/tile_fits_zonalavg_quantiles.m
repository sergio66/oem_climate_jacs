function y = tile_fits_zonalavg_quantiles(rad_quantile_asc,tai93_asc,count_asc,rad_quantile_desc,tai93_desc,count_desc,i16daysSteps,stopdate,startdate);

%% based on tile_fits_quantiles.m

if nargin < 7
  error('need 4 arguments rada,rtimea,counta,radd,rtimed,countd,i16daysSteps')
end
if nargin == 7
  startdate = [2002 09 01];
  stopdate = [];
end
if nargin == 8
  startdate = [2002 09 01];
end

addpath /asl/matlib/aslutil
addpath /asl/matlib/time
addpath /home/strow/Matlab/Math
load_fairs

% % AIRS channel ID
% ch = 1520;

p = [-0.17 -0.15 -1.66  1.06];

mtime = tai2dtime(airs2tai(tai93_desc));
dtime = datenum(mtime);

if nargin == 7
  fprintf(1,'  fitting entire data set \n')
  k_desc = count_desc./(ones(i16daysSteps,1)*median(count_desc)) > 0.98; % all data
  k_asc = count_asc./(ones(i16daysSteps,1)*median(count_asc)) > 0.98;    % all data
elseif nargin == 8
  fprintf(1,'  fitting till %4i/%2i/%2i \n',stopdate)
  k_desc = count_desc./(ones(i16daysSteps,1)*median(count_desc)) > 0.98 & (mtime <= datetime(stopdate(1),stopdate(2),stopdate(3)));
  k_asc = count_asc./(ones(i16daysSteps,1)*median(count_asc)) > 0.98 & (mtime <= datetime(stopdate(1),stopdate(2),stopdate(3)));
elseif nargin == 9
  fprintf(1,'  fitting between %4i/%2i/%2i and %4i/%2i/%2i \n',startdate,stopdate)
  k_desc = count_desc./(ones(i16daysSteps,1)*median(count_desc)) > 0.98 & (mtime >= datetime(startdate(1),startdate(2),startdate(3)) & mtime <= datetime(stopdate(1),stopdate(2),stopdate(3)));
  k_asc = count_asc./(ones(i16daysSteps,1)*median(count_asc)) > 0.98 & (mtime >= datetime(startdate(1),startdate(2),startdate(3)) & mtime <= datetime(stopdate(1),stopdate(2),stopdate(3)));
end

y.b_asc = NaN(2645,16,10);
y.b_desc = NaN(2645,16,10);
y.berr_asc = NaN(2645,16,10);
y.berr_desc = NaN(2645,16,10);

y.dbt_asc = NaN(2645,16);
y.dbt_desc = NaN(2645,16);
y.dbt_err_asc = NaN(2645,16);
y.dbt_err_desc = NaN(2645,16);

y.resid_desc_std = NaN(2645,16);
y.resid_asc_std = NaN(2645,16);

% 6 values are:  ols_s, robust_s, mad_s, s, t(2), p(2) 
stats_desc = NaN(2645,16,6);
stats_asc = NaN(2645,16,6);

% Run off tsurf using bt1231/bt1228 regression for qi = 16;  
for qi = 12:16
   r1231 = squeeze(rad_quantile_desc(:,1520,qi));
   r1228 = squeeze(rad_quantile_desc(:,1513,qi));
   bt1231 = rad2bt(fairs(1520),r1231);
   bt1228 = rad2bt(fairs(1513),r1228);
   desc_tsurf = bt1231 + polyval(p,bt1228 - bt1231);
   [y.dbt_desc_tsurf(qi-11,:) stats] = Math_tsfit_lin_robust(dtime(k_desc(:,qi))-dtime(1),desc_tsurf(k_desc(:,qi)),4);
%   dbt_desc_tsurf(qi-11,2)
   y.dbt_desc_tsurf_err(qi-11,2) = stats.se(2);
%   dbt_desc_tsurf_err(qi-11,2)

   r1231 = squeeze(rad_quantile_asc(:,1520,qi));
   r1228 = squeeze(rad_quantile_asc(:,1513,qi));
   bt1231 = rad2bt(fairs(1520),r1231);
   bt1228 = rad2bt(fairs(1513),r1228);
   asc_tsurf = bt1231 + polyval(p,bt1228 - bt1231);
   [y.dbt_asc_tsurf(qi-11,:) stats] = Math_tsfit_lin_robust(dtime(k_asc(:,qi))-dtime(1),asc_tsurf(k_asc(:,qi)),4);
%   dbt_asc_tsurf(qi-11,2)
   y.dbt_asc_tsurf_err(qi-11,2) = stats.se(2);
%   dbt_asc_tsurf_err(qi-11,2)
end

warning off   
for qi = 1:16
  fprintf(1,'qi = %2i of 16 \n',qi);
%  [ b_satzen_desc(qi,:) stats] = Math_tsfit_lin_robust(dtime(k_desc)-dtime(1),satzen_quantile1231_desc(k_desc,qi),1);
%  berr_satzen_desc(qi,:) = stats.se;

%  [ b_satzen_asc(qi,:) stats] = Math_tsfit_lin_robust(dtime(k_asc)-dtime(1),satzen_quantile1231_asc(k_asc,qi),1);
%  berr_satzen_asc(qi,:) = stats.se;

  for ch = 1:2645
    % Desc
    r = squeeze(rad_quantile_desc(:,ch,qi));
    % bt = rad2bt(fairs(ch),squeeze(rad_quantile_desc(:,ch,qi)));
    [y.b_desc(ch,qi,:) stats] = Math_tsfit_lin_robust(dtime(k_desc(:,qi))-dtime(1),r(k_desc(:,qi)),4);
    y.berr_desc(ch,qi,:) = stats.se;
    y.stats_desc(ch,qi,:) = [stats.ols_s stats.robust_s stats.mad_s stats.s stats.t(2) stats.p(2)];
    l = xcorr(stats.resid,1,'coeff');
    y.lag_desc(ch,qi) = l(1);
    deriv = drdbt(fairs(ch),rad2bt(fairs(ch),r(k_desc(:,qi))));
    y.bt_resid = stats.resid./deriv;
%keyboard_nowindow
    y.resid_desc_std(ch,qi) = nanstd(real(y.bt_resid));
      
    % Asc
    r = squeeze(rad_quantile_asc(:,ch,qi));
    %   bt = rad2bt(fairs(ch),squeeze(rad_quantile_asc(:,ch,qi)));
    [y.b_asc(ch,qi,:) stats] = Math_tsfit_lin_robust(dtime(k_asc(:,qi))-dtime(1),r(k_asc(:,qi)),4);
    y.berr_asc(ch,qi,:) = stats.se;
    y.stats_asc(ch,qi,:) = [stats.ols_s stats.robust_s stats.mad_s stats.s stats.t(2) stats.p(2)];
    l = xcorr(stats.resid,1,'coeff');
    y.lag_asc(ch,qi) = l(1);
    deriv = drdbt(fairs(ch),rad2bt(fairs(ch),r(k_asc(:,qi))));
    y.bt_resid = stats.resid./deriv;
    y.resid_asc_std(ch,qi) = nanstd(real(y.bt_resid));
  end

  % Convert b_trends and uncertainties to BT units
  deriv = drdbt(fairs,rad2bt(fairs,squeeze(y.b_desc(:,qi,1))));
  y.dbt_desc(:,qi)     = y.b_desc(:,qi,2)./deriv;
  y.dbt_err_desc(:,qi) = y.berr_desc(:,qi,2)./deriv;
     
  deriv = drdbt(fairs,rad2bt(fairs,squeeze(y.b_asc(:,qi,1))));
  y.dbt_asc(:,qi)     = y.b_asc(:,qi,2)./deriv;
  y.dbt_err_asc(:,qi) = y.berr_asc(:,qi,2)./deriv;
     
  % Correct dbt_ for lag-1 correlations (note b*(:,2) values NOT corrected for lag-1)
  lagc = sqrt( ( 1 + y.lag_desc(:,qi) ) ./ ( 1 - y.lag_desc(:,qi) ) ) ;
  y.dbt_err_desc(:,qi) = lagc .* y.dbt_err_desc(:,qi);
    
  lagc = sqrt( ( 1 + y.lag_asc(:,qi) ) ./ ( 1 - y.lag_asc(:,qi) ) ) ;
  y.dbt_err_asc(:,qi) = lagc .* y.dbt_err_asc(:,qi);
     
end
warning on

% Get rid of variables I don't want to save
%%y.quants = quants; % want to save these

