function [B,stats,btanomaly,radanomaly] = compute_anomaly_wrapper(k,x0,y0,N,f,iRad_or_OD,iDebug)

%% input
%%   k          = index of (x0,y0) to use
%%   x0         = days
%%   y0         = data
%%   N          = number of sines/cosines
%%   
%%   f          = [optional : default = [] ] if this is OD, ignore! else this is wavenumber for radiances  
%%   iRad_or_OD = [optional : default = -1 ] is this just eg OD or BT [-1],    or radiance that needs to become BT [+1] 
%%   iDebug     = [optional : default = -1 ] do not print/print some stuff,    or plot some stuff
%%  
%% output
%%   B(1)     = costaant, B(2) = trend, B(3:N+2) = sin/cos amplitues
%%   stats.se = unc
%%   anomaly  = y - f(const + sum over sines.cosines) ... the trend is kept in there
%%      if iRad_or_OD == +1, radanomaly --> BTanomaly, else if iRad_or_OD == -1, radanomaly == BTanomaly

x = x0;
y = y0;

if nargin < 3
  error('compute_anomaly_wrapper needs at least 3 arguments : k,x,y')
elseif   nargin == 3
  N          = 4;
  f          = [];
  iRad_or_OD = -1;   
  iDebug     = -1;
elseif   nargin == 4
  f          = [];
  iRad_or_OD = -1;   
  iDebug     = -1;
elseif   nargin == 5
  iRad_or_OD = -1;   
  iDebug     = -1;
elseif   nargin == 6
  iDebug     = -1;
end

if size(x) ~= size(y)
  x = x';
end

[mm,nn] = size(x);
if nn == 1
  x = x';
  y = y';
end

y = y';

good1 = find(isfinite(x));
good2 = find(isfinite(y));
good = union(good1,good2);

boo = setdiff(good,k);
%if length(good) ~= length(k)
%  disp('hmm : found slightly different nan (x,y) compared to k index sent in  (lengths are different)');
%elseif length(good) == length(k) & length(boo) > 0
%  disp('hmm : found slightly different nan (x,y) compared to k index sent in (lengths re same, lists are different)');
%end

good = k;

x = x(good);
y = y(good);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if length(x) > 2*(2 + N*2)
  [B, stats]             = Math_tsfit_lin_robust(x-x(1),y,N);
  [btanomaly,radanomaly] = compute_anomaly(1:length(x),x-x(1),B,f,y,iRad_or_OD);
else
  B = nan(1,2 + N*2);
  stats.se = nan(1,2 + N*2);
  btanomaly = nan(size(x));
  radanomaly = nan(size(x));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% B(2),se(2) = trend, error in trend, change from /year  --> /year
%% B(2)  = B(2) * 365;
%% se(2) = se(2) * 365;

junkanomaly = zeros(size(y0));
junkanomaly(good) = btanomaly;
btanomaly = junkanomaly;

junkanomaly = zeros(size(y0));
junkanomaly(good) = radanomaly;
radanomaly = junkanomaly;

if size(B) ~= size(stats.se)
  stats.se = stats.se';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
iDoThis = -1;
iDoThis = iRad_or_OD;
if iDoThis > 0
  %% see ../Code_for_TileTrends/tile_fits_quantiles.m
    % Convert b_trends and uncertainties to BT units
    % <<< *** /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/driver_put_together_QuantileChoose_trends.m uses these *** >>>
    %      b_asc(iLon,iLat,:) = x.dbt_asc(:,iQuantile);
    %      b_desc(iLon,iLat,:) = x.dbt_desc(:,iQuantile);
    % <<< *** /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/driver_put_together_QuantileChoose_trends.m uses these *** >>>
    %
    % b_desc has size 2645x5x10 : chans x quantiles x 10 fir params, 1 is the mean radiance
    % deriv = drdbt(fairs,rad2bt(fairs,squeeze(b_desc(:,qi,1))));
    % dbt_desc(:,qi)     = b_desc(:,qi,2)./deriv;
    % dbt_err_desc(:,qi) = berr_desc(:,qi,2)./deriv;
  
  if iRad_or_OD > 0
    % Convert B to BT
    deriv = drdbt(f,rad2bt(f,B(1)));  %% B(1) is the mean radiance
    BT_B        = B/deriv;            %% B(2) is the linear radiance trend --> BT_B(2) is the linear BT trend
    BT_B(1)     = rad2bt(f,B(1));     %% B(1) is the mean radiance         --> BT_B(1) is the mean BT
    BT_stats.se = stats.se/deriv;     %% stats.se(2) is linear radiance trend unc --> linear BT trends unc
  else  
    BT_B        = B;
    BT_stats.se = stats.se;  
  end
  B0 = B;
  stats0 = stats;
  
  clear B stats
  B.inputunits = B0;
  B.BTunits    = BT_B;
  stats.inputunits = stats0;
  stats.BTunits    = BT_stats.se;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iDebug > 0
  disp('RetrValue    Unc')
  printarray([B; stats.se]);
end

