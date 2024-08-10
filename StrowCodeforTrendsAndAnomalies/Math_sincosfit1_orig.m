function [B] = Math_sincosfit1(x,y)

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

fit = @(b,x)  b(1) + b(2).*x + b(3).*sin(2*pi*x/365) + b(4).*cos(2*pi*x/365);    % Function to fit
fcn = @(b) sum((fit(b,x) - y).^2);                                               % Least-Squares cost function
s0 = [ym;  lin; yr;  yr];
s = fminsearch(fcn, s0);                                                         % Minimise Least-Squares

xp = linspace(min(x),max(x));
figure(1); plot(x,y,'b',  xp,fit(s,xp), 'r'); grid
figure(1); plot(x,y,'b',  x, fit(s,x), 'r'); grid
figure(2); plot(x,y - fit(s,x), 'r'); ;grid

B(1) = s(1);   %% offset
B(2) = s(2);   %% trend
B(3) = s(3);   %% sine wave amplitude 
B(4) = s(4);   %% cosine wave amplitude 

