function [B] = Math_sinfit(x,y)

if size(x) ~= size(y)
  x = x';
end

[mm,nn] = size(x);
if nn == 1
  x = x';
  y = y';
end

%% see https://www.mathworks.com/matlabcentral/answers/121579-curve-fitting-to-a-sinusoidal-function

yu = max(y);
yl = min(y);
yr = (yu-yl);                               % Range of ‘y’

yz = y-yu+(yr/2);
zx = x(yz .* circshift(yz,[0 1]) <= 0);     % Find zero-crossings
per = 2*mean(diff(zx));                     % Estimate period
lin = (y(end)-y(1))/(x(end)-x(1));          % estimate trend
ym = mean(y);                               % Estimate offset

fit = @(b,x)  b(1).*(sin(2*pi*x./b(2) + 2*pi/b(3))) + b(4) + b(5).*x;    % Function to fit
fcn = @(b) sum((fit(b,x) - y).^2);                                       % Least-Squares cost function
s = fminsearch(fcn, [yr;  per;  -1;  ym; lin]);                               % Minimise Least-Squares

xp = linspace(min(x),max(x));
figure(1); plot(x,y,'b',  xp,fit(s,xp), 'r'); grid
figure(1); plot(x,y,'b',  x, fit(s,x), 'r'); grid
figure(2); plot(x,y - fit(s,x), 'r'); ;grid

B(1) = s(4);   %% offset
B(2) = s(5);   %% trend
B(3) = s(1);   %% sine wave amplitude 
B(4) = s(2);   %% time period
B(5) = s(3);   %% phase

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
a sin (wt + c) = a sin wt cos c + a cos wt sin c
b cos (wt - d) = b cos wt cos d + b sin wt sin d

b cos wt cos d = a cos wt sin c ==> b cos d = a sin c
b sin wt sin d = a sin wt cos c ==> b sin d = a cos c
thus b^2 = a^2
%}
