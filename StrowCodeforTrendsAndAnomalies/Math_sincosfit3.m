function [B,se,anomaly] = Math_sincosfit3(x,y,iDebug)

if nargin == 2
  iDebug = -1;
end

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

fit = @(b)  b(1) + b(2)*x + b(3)*sin(2*pi*1*x/365) +  b(4)*cos(2*pi*1*x/365) + ...
                            b(5)*sin(2*pi*2*x/365) +  b(6)*cos(2*pi*2*x/365) + ...
                            b(7)*sin(2*pi*3*x/365) +  b(8)*cos(2*pi*3*x/365);      % Function to fit
fcn = @(b) sum((fit(b) - y).^2);                                                   % Least-Squares cost function
s0 = [ym;  lin; yr*[1 1 1/2 1/2 1/4 1/4]'];                                        % startimg guess
s = fminsearch(fcn, s0);                                                           % Minimise Least-Squares

%%%%%%%%%%%%%%%%%%%%%%%%%

B(1)   = s(1);    %% offset
B(2)   = s(2);    %% trend
B(3:4) = s(3:4);  %% sine/cosine wave amplitude, fundamental
B(5:6) = s(5:6);  %% sine/cosine wave amplitude, harmonic 2
B(7:8) = s(7:8);  %% sine/cosine wave amplitude, harmonic 3
sanom = s; sanom(2) = 0; anomaly = y-fit(sanom);

if iDebug > 0
  %xp = linspace(min(x),max(x));
  %figure(1); plot(x,y,'b',  xp,fit(s,xp), 'r'); grid
  figure(1); plot(x,y,'b',  x, fit(s), 'r'); grid
  figure(2); plot(x,anomaly,'b',x,y - fit(s), 'r'); grid
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% see test_unc_fminsearch.m

% degrees of freedom in the problem
n = length(x);
dof = n - 2;
dof = n - 3;
dof = n - length(s0);

% standard deviation of the residuals
sdr = sqrt(sum((y - fit(s)).^2)/dof);

% jacobian matrix
J = jacobianest(fit,s);

% I'll be lazy here, and use inv. Please, no flames,
% if you want a better approach, look in my tips and
% tricks doc.
Sigma = sdr^2*inv(J'*J);

% Parameter standard errors
se = sqrt(diag(Sigma));
if iDebug > 0
  printarray([s se],'RetrValue    Unc')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
