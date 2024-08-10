function [fitc err R]=Math_tsfit_lin(x,y,n)

% copied from /home/strow/Matlab/Math/

% function [fitc err]=Math_tsfit_lin(x,y,n)
% x - days
% y - ppm
% n - 0,1,2,3,4 - number of sine functions
%
% fitc = [ b Trent Amplitude0 Phase0 A1 P1]


  f = @(c,x) Math_timeseries_2(x,c);

if(n == 0)
  X(:,1) = f([1 0 ],x(:));
  X(:,2) = f([0 1 ],x(:));
elseif(n == 1)
  X(:,1) = f([1 0 0 0 ],x(:));
  X(:,2) = f([0 1 0 0 ],x(:));
  X(:,3) = f([0 0 1 0 ],x(:));
  X(:,4) = f([0 0 0 1 ],x(:));
elseif(n == 2)
  X(:,1) = f([1 0 0 0 0 0 ],x(:));
  X(:,2) = f([0 1 0 0 0 0 ],x(:));
  X(:,3) = f([0 0 1 0 0 0 ],x(:));
  X(:,4) = f([0 0 0 1 0 0 ],x(:));
  X(:,5) = f([0 0 0 0 1 0 ],x(:));
  X(:,6) = f([0 0 0 0 0 1 ],x(:));
elseif(n == 3)
  X(:,1) = f([1 0 0 0 0 0 0 0 ],x(:));
  X(:,2) = f([0 1 0 0 0 0 0 0 ],x(:));
  X(:,3) = f([0 0 1 0 0 0 0 0 ],x(:));
  X(:,4) = f([0 0 0 1 0 0 0 0 ],x(:));
  X(:,5) = f([0 0 0 0 1 0 0 0 ],x(:));
  X(:,6) = f([0 0 0 0 0 1 0 0 ],x(:));
  X(:,7) = f([0 0 0 0 0 0 1 0 ],x(:));
  X(:,8) = f([0 0 0 0 0 0 0 1 ],x(:));
elseif(n == y4)
  X(:,1) = f([1 0 0 0 0 0 0 0 0 0],x(:));
  X(:,2) = f([0 1 0 0 0 0 0 0 0 0],x(:));
  X(:,3) = f([0 0 1 0 0 0 0 0 0 0],x(:));
  X(:,4) = f([0 0 0 1 0 0 0 0 0 0],x(:));
  X(:,5) = f([0 0 0 0 1 0 0 0 0 0],x(:));
  X(:,6) = f([0 0 0 0 0 1 0 0 0 0],x(:));
  X(:,7) = f([0 0 0 0 0 0 1 0 0 0],x(:));
  X(:,8) = f([0 0 0 0 0 0 0 1 0 0],x(:));
  X(:,9) = f([0 0 0 0 0 0 0 0 1 0],x(:));
  X(:,10) = f([0 0 0 0 0 0 0 0 0 1],x(:));

  %  [Coef Res Jac Cov Mse]=nlinfit(x,y,f,[370 1 1 1 1 1 1 1 1 1]);
else 
  error('Math_tsfit_lin.m : need n <= 4')  
end

[B, BINT, R, RINT, STATS] = regress(y(:),X);
fitc = B; 
err = diff(BINT')'; 

