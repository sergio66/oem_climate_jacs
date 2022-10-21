function [x_anom,b] = generic_compute_anomaly(dtime,r,k,iWhich,iNterms);

% see also compute_anomaly

% k is logical for r (raw measured radiance and times) -- optional
% dtime are the measurement times (days)
% r is the raw signal
% iWhich = +1 (linear fit, sin(2pi n))  DEFAULT
%          -1 (linear fit, sin(2pi/n))  
%           0 (linear fit, sin(2pi/n) and sin(2pi n))  
%           2 (quad fit, sin(2pi n))
% iNTerms = 0,1,2,3,4
%
% x_anom is the output anomaly

boo = find(isfinite(r));
if length(boo) < 10
  x_anom = nan(size(r));
  disp('generic_compute_anomaly : less than 10 points are finite');
  return
end

[mt,nt] = size(dtime);
[mr,nr] = size(r);

if nt > 1
  dtime = dtime';
end
if nr > 1
  r = r';
end

if nargin == 2
  k = 1:length(dtime);
  iWhich = 1;
  iNterms = 4;
elseif nargin == 3
  iWhich = 1;
  iNterms = 4;
elseif nargin == 4
  iNterms = 4;
end

x_anom = zeros(size(r));

if iWhich == 1
  b  = Math_tsfit_lin_robust(dtime,r,iNterms);
  %bj = oem_Math_tsfit_lin_robust(dtime,r,iNterms,b);
  [y g] = Math_timeseries_2(dtime, b );
  x_anom(k) = (r(k) - y) + g(:,2)*b(2);
elseif iWhich == -1
  b = Math_tsfit_lin_robust_lowfreq(dtime,r,iNterms);
  [y g] = Math_timeseries_2_lowfreq(dtime, b );
  x_anom(k) = (r(k) - y) + g(:,2)*b(2);
elseif iWhich == 2
  b = Math_tsfit_quad_robust(dtime,r,iNterms);
  [y g] = Math_timeseries_quad(dtime, b );
  x_anom(k) = (r(k) - y) + g(:,2)*b(2) + g(:,3)*b(3);
elseif iWhich == 0
  b  = Math_tsfit_lin_robust_LOWnHIGH(dtime,r,iNterms);
  %bj = oem_Math_tsfit_lin_robust_LOWnHIGH(dtime,r,iNterms,b);
  [y g] = Math_timeseries_2_LOWnHIGH(dtime,r);
  x_anom(k) = (r(k) - y) + g(:,2)*b(2);
end

iDebug = +1;
iDebug = -1;
if iDebug > 0
  plot(dtime,r,dtime,y,dtime,x_anom+b(1))
  plot(dtime,r,dtime,y,dtime,x_anom+b(1),'linewidth',2)
  plot(dtime,r-b(1),dtime,y-b(1),dtime,x_anom,'linewidth',2); plotaxis2;
  keyboard_nowindow
end
