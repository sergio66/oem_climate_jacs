function [B] = Math_sincosfit4(x,y)

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

fit = @(b,x)  b(1) + b(2)*x + b(3)*sin(2*pi*1*x/365) +  b(4)*cos(2*pi*1*x/365) + ...
                              b(5)*sin(2*pi*2*x/365) +  b(6)*cos(2*pi*2*x/365) + ...
                              b(7)*sin(2*pi*3*x/365) +  b(8)*cos(2*pi*3*x/365) + ...
                              b(9)*sin(2*pi*4*x/365) + b(10)*cos(2*pi*4*x/365);    % Function to fit
fcn = @(b) sum((fit(b,x) - y).^2);                                               % Least-Squares cost function
s = fminsearch(fcn, [ym;  lin; yr*[1 1 1/2 1/2 1/4 1/4 1/8 1/8]';]);               % Minimise Least-Squares

xp = linspace(min(x),max(x));
figure(1); plot(x,y,'b',  xp,fit(s,xp), 'r'); grid
figure(1); plot(x,y,'b',  x, fit(s,x), 'r'); grid
figure(2); plot(x,y - fit(s,x), 'r'); ;grid

B(1)   = s(1);    %% offset
B(2)   = s(2);    %% trend
B(3:4) = s(3:4);  %% sine/cosine wave amplitude, fundamental
B(5:6) = s(5:6);  %% sine/cosine wave amplitude, harmonic 2
B(7:8) = s(7:8);  %% sine/cosine wave amplitude, harmonic 3
B(9:10)= s(9:10); %% sine/cosine wave amplitude, harmonic 4

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
a sin (wt + c) = a sin wt cos c + a cos wt sin c
b cos (wt - d) = b cos wt cos d + b sin wt sin d

b cos wt cos d = a cos wt sin c ==> b cos d = a sin c
b sin wt sin d = a sin wt cos c ==> b sin d = a cos c
thus b^2 = a^2
%}
