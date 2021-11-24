function [B, stats]=Math_tsfit_quad_robust(x,y,n)

% copied from /home/strow/Matlab/Math/

% function [fitc err]=Math_tsfit_lin(x,y,n)
% x - days
% y - ppm
% n - 0,1,2,3,4 - number of sine functions
%
% fitc = [ b Trend Quad Amplitude0 Phase0 A1 P1]

% Note the flip of c and x below!
f = @(c,x) Math_timeseries_quad(x,c);

nloop = 2*n + 3;
fc = zeros(1,nloop);
for i=1:nloop
   fc(i) = 1;
   X(:,i) = f(fc,x(:));
   fc(i) = 0;
end
[B, stats]=robustfit(X,y(:),[],[],'off');

