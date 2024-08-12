function [B,se,anomaly] = Math_sincosfit_wrapper(x,y,N,iDebug)

%% input
%%   x       = days
%%   y       = data
%%   N       = number of sines/cosines
%%   iDebug  = [optional -1] do not print/print some stuff, plot some stuff
%% output
%%   B(1)    = costaant, B(2) = trend, B(3:N+2) = sin/cos amplitues
%%   se      = unc
%%   anomaly = y - f(const + sum over sines.cosines) ... the trend is kept in there

x0 = x;
y0 = y;

if nargin == 2
  N      = 4;
  iDebug = -1;
elseif nargin == 3
  iDebug = -1;
end

if size(x) ~= size(y)
  x = x';
end

[mm,nn] = size(x);
if nn == 1
  x = x';
  y = y';
end

moo1 = find(isfinite(x));
moo2 = find(isfinite(y));
moo = union(moo1,moo2);

x = x(moo);
y = y(moo);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if length(x) > 20
  if N == 1
    [B,se,anomaly] = Math_sincosfit1(x,y,iDebug);
  elseif N == 2
    [B,se,anomaly] = Math_sincosfit2(x,y,iDebug);
  elseif N == 3
    [B,se,anomaly] = Math_sincosfit3(x,y,iDebug);
  elseif N == 4
    [B,se,anomaly] = Math_sincosfit4(x,y,iDebug);
  else
    error('Math_sincosfit_wrapper.m can only handle N=1,2,3,4')
  end
else
  disp('not enough finite x,y points to do fminsearch')
  B  = nan(1,2+2*N);
  se = nan(1,2+2*N);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% B(2),se(2) = trend, error in trend, change from /day  --> /year
B(2)  = B(2) * 365;
se(2) = se(2) * 365;

junkanomaly = zeros(size(y0));
junkanomaly(moo) = anomaly;
anomaly = junkanomaly;

if size(B) ~= size(se)
  se = se';
end

if iDebug > 0
  disp('RetrValue    Unc')
  printarray([B; se]');
end
