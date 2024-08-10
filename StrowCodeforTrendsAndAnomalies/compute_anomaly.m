function [bt_anom r_anom] = compute_anomaly(k,dtime,B,f,radiance,iConvertToBT);

% input 
%   k           logical for r (raw measured radiance and times)
%   dtime       measurement times
%   B           generally 1 x 10 set of fitted coefficients, slope is B(2) which comes from 
%               [B, stats, err] = Math_tsfit_lin_robust(dtime(k),r(k),4);
%   radiance    raw measured radiance/data
%   f           observation wavenumber
%  iConvertToBT  +1 [OPTIONAL, DEFAULT] if you want RADanomaly --> BTanomaly 
%                -1 (but you do not want this if eg "radiance" is really MODIS OD!!!)

% output
% if iConvertToBT > 0
%   r_anom    is the radiance anomaly
%   bt_anom is the bt anomaly
% elseif iConvertToBT < 0
%   r_anom = bt_anom = anomaly

%% example use : AIRS
%    [b_desc(ch,qi,:)     stats] = Math_tsfit_lin_robust(dtime(k_desc)-dtime(k_desc(1)),r(k_desc),iNumSineCosCycles);
%    [bt_anom_desc(qi,ch,:) rad_anom_desc(qi,ch,:)] = compute_anomaly(k_desc,dtime,squeeze(b_desc(ch,qi,:)),fairs(ch),r);
%% example use : MODIS 
%    data = squeeze(dblue(:,ii,jj));
%    boo = find(isfinite(data));
%      [B, stats, err] = Math_tsfit_lin_robust(doy(boo),data(boo),4);
%      anom_deepblue(ii,jj,:)    = compute_anomaly(boo,doy,B,[],data,-1);

if nargin == 5
  iConvertToBT = +1;
end

r_anom = zeros(size(k));
bt_anom = zeros(size(k));

%% [y g] = Math_timeseries_2( dtime(k)-1*dtime(k(1)), B );   %% y = B(1) + B(2)*dtime + sum_j=1^4 B(j)cos(n*dtime*2*pi) + C(j)sin(n*dtime*2*pi)  = fitted signal   OLD WRONG SINCE 2018
%% r_anom(k) = (radiance(k) - y') + 0*g(:,2)*B(2);           %% anomaly = (raw signal - fitted signal) + B(2)*dtime                                                TESTING SOME RUBBISH
[y g] = Math_timeseries_2( dtime(k)-0*dtime(k(1)), B );      %% y = B(1) + B(2)*dtime + sum_j=1^4 B(j)cos(n*dtime*2*pi) + C(j)sin(n*dtime*2*pi)  = fitted signal   FIXED AUGUSTR 2024
r_anom(k) = (radiance(k) - y') + g(:,2)*B(2);                %% anomaly = (raw signal - fitted signal) + B(2)*dtime

if iConvertToBT > 0
  % Convert to BT
  deriv = drdbt(f,rad2bt(f,radiance(k)));
  bt_anom(k) = r_anom(k)./deriv';
else
  bt_anom(k) = r_anom(k);
end

