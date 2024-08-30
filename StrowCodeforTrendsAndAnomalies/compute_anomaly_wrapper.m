function [B,stats,btanomaly,radanomaly] = compute_anomaly_wrapper(k,x0,y0,N,f,iRad_or_OD,iDebug)

%% input
%%   k          = index of (x0,y0) to use
%%   x0         = days
%%   y0         = data
%%   N          = number of sines/cosines
%%   iRad_or_OD = [optional -1] is this just eg OD [-1], or radiance that needs to become BT [+1] 
%%   iDebug     = [optional -1] do not print/print some stuff, plot some stuff
%% output
%%   B(1)     = costaant, B(2) = trend, B(3:N+2) = sin/cos amplitues
%%   stats.se = unc
%%   anomaly  = y - f(const + sum over sines.cosines) ... the trend is kept in there
%%      if iRad_or_OD == +1, radanomaly --> BTanomaly, else if if iRad_or_OD == -1, radanomaly == BTanomaly

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

if length(x) > 2 + N*2
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

if iDebug > 0
  disp('RetrValue    Unc')
  printarray([B; stats.se]);
end

