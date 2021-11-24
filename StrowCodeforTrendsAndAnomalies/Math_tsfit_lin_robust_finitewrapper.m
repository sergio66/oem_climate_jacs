function [B, stats] = Math_tsfit_lin_robust_finitewrapper(xin,yin,n)

% copied from /home/strow/Matlab/Math/

% function [fitc err]=Math_tsfit_lin(x,y,n)
% x - days
% y - ppm
% n - 0,1,2,3,4 - number of sine functions
%
% fitc = [ b Trent Amplitude0 Phase0 A1 P1]

oo = find(isfinite(xin) & isfinite(yin));

if length(oo) > 20

  x = xin(oo);
  y = yin(oo);
  
  f = @(c,x) Math_timeseries_2(x,c);
  
  nloop = 2*n + 2;
  fc = zeros(1,nloop);
  for i=1:nloop
     fc(i) = 1;
     X(:,i) = f(fc,x(:));
     fc(i) = 0;
  end
  [B, stats]=robustfit(X,y(:),[],[],'off');
  
else
  fprintf(1,' oops : /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/StrowCodeforTrendsAndAnomalies/Math_tsfit_lin_robust_finitewrapper.m : sent in %5i points but < 20 were finite, setting trends/errors to NaN \n',length(xin));
  B = nan(1,2+n*2);
  stats.se = nan(1,2+n*2);
end
