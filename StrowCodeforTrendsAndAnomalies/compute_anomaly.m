function [bt_anom r_anom] = compute_anomaly(k,dtime,b,f,r);

% k is logical for r (raw measured radiance and times)
% dtime are the measurement times
% b is the generally 1 x 10 set of fitted coefficients, slope is b(2)
% r is the raw measured radiance
%
% f is the observation wavenumber
% r_anom is the radiance anomaly
% bt_anom is the bt anomaly

r_anom = zeros(size(k));
bt_anom = zeros(size(k));

[y g] = Math_timeseries_2( dtime(k)-dtime(k(1)), b );
r_anom(k) = (r(k) - y') + g(:,2)*b(2);

% Convert to BT
deriv = drdbt(f,rad2bt(f,r(k)));
bt_anom(k) = r_anom(k)./deriv';

end

