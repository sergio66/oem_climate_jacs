function [B, stats, err]=Math_tsfit_lin_robust_LOWnHIGH(x,y,n)

warning off
% copied from /home/strow/Matlab/Math/ 
% NOTE he did NOT have err as third argument

% function [fitc err]=Math_tsfit_lin(x,y,n)
% x - days
% y - ppm
% n - 0,1,2,3,4 - number of sine functions
%
% fitc = [ b Trent Amplitude0 Phase0 A1 P1]

f = @(c,x) Math_timeseries_2_LOWnHIGH(x,c);

if n <= 1
  nloop = 2*n + 2;
else
  nloop = 4*n + 2 - 2 ;     %% because sin(2 pi / n t) and sin(2 pi n t) have n= 1 as common
end

fc = zeros(1,nloop);
for i=1:nloop
   fc(i) = 1;
   X(:,i) = f(fc,x(:));
   fc(i) = 0;
end
[B, stats]=robustfit(X,y(:),[],[],'off');

%% copied from ~/MATLABCODE/FIND_TRENDS/Math_tsfit_lin_robust.m
if n == 4
  err=stats.se(1:16)*2; %% a + bt + csinwt+dcoswt + csin2wt+dcos2wt + csinwt/2+dcoswt/2 + csin3wt+dcos3wt + csinwt/3+dcoswt/3 + csin4wt+dcos4wt + csinwt/4+dcoswt/4
elseif n == 3
  err=stats.se(1:12)*2; %% a + bt + csinwt+dcoswt + csin2wt+dcos2wt + csinwt/2+dcoswt/2 + csin3wt+dcos3wt + csinwt/3+dcoswt/3
elseif n == 2
  err=stats.se(1:8)*2;  %% a + bt + csinwt+dcoswt + csin2wt+dcos2wt + csinwt/2+dcoswt/2
elseif n == 1
  err=stats.se(1:4)*2;  %% a + bt + csinwt+dcoswt
elseif n == 0
  err=stats.se(1:2)*2;  %% a + bt
else
  error('hmm err == ????')
end

warning on
