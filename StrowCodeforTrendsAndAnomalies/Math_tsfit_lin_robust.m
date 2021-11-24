function [B, stats, err]=Math_tsfit_lin_robust(x,y,n)

% copied from /home/strow/Matlab/Math/ 
% NOTE he did NOT have err as third argument

% function [fitc err]=Math_tsfit_lin(x,y,n)
% x - days
% y - ppm
% n - 0,1,2,3,4 - number of sine functions
%
% fitc = [ b Trent Amplitude0 Phase0 A1 P1]

f = @(c,x) Math_timeseries_2(x,c);

nloop = 2*n + 2;
fc = zeros(1,nloop);
for i=1:nloop
   fc(i) = 1;
   X(:,i) = f(fc,x(:));
   fc(i) = 0;
end
[B, stats]=robustfit(X,y(:),[],[],'off');

%% copied from ~/MATLABCODE/FIND_TRENDS/Math_tsfit_lin_robust.m
if n == 6
  err=stats.se(1:14)*2; 
elseif n == 5
  err=stats.se(1:12)*2; 
elseif n == 4
  err=stats.se(1:10)*2; 
elseif n == 3
  err=stats.se(1:8)*2; 
elseif n == 2
  err=stats.se(1:6)*2; 
elseif n == 1
  err=stats.se(1:4)*2; 
elseif n == 0
  err=stats.se(1:2)*2;
else
  error('hmm err == ????')
end
