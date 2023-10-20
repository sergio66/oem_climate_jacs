function [y g] = Math_timeseries_2(x,c);
% function [y] = Math_timeseries(x,coef)
% 
% Usage:
% x=....
% y=....
% fitc=fminsearch(@(c) Math_timeseries_err(x,y,c),[370;1;1;1;1;1;1;1;1;1]);
% plot(x,y,'b'); hold; plot(x,Math_timeseries(x,fitc),'r');
%
% OR
%
% fitc=fminunc(@(c) Math_timeseries_err(x,y,c),[370;1;1;1;1;1;1;1;1;1]);

y = c(1)       + ...
    c(2)*x/365 ;
for ii = 1:(length(c)-2)/2
  y = y + c(2*ii+1)*cos(ii*2*pi/365*x) + c(2*ii+2)*sin(ii*2*pi/365*x);
end

if(nargout>1)
   g(:,1) = 1*ones(size(x));
   g(:,2) = x/365;
   for ii = 1:(length(c)-2)/2
      g(:,2*ii+1) =           cos(ii*2*pi/365*x);
      g(:,2*ii+2) =           sin(ii*2*pi/365*x);
   end
end
