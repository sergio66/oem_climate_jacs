function [] = test_unc_fminsearch()

% https://comp.soft-sys.matlab.narkive.com/g357ivOW/standard-errors-of-fminsearch-parameters
% John D'Errico17 years ago
% Permalink
% Post by Cecilia Persson
% does someone know how I can get the standard errors of the
% parameters found by fminsearch? (i.e. not the errors of
% each data value compared to the calculated one but the
% parameters fitted to my nonlinear data)

n = 200;
% n data points, in the interval [-1,1].
x = rand(n,1)*2-1;

% true parameters
ab0 = [2 .5 7.0];
ab0 = [5 .5 7.0];

% a function that predicts y, given x and the parameters
predfun = @(ab) ab(1)*exp(ab(2)*x) + ab(3);

% our data, to be used for estimation
NeDT = 0.10;
NeDT = 0.01;
NeDT = 0.20;
y = randn(size(x))*NeDT + predfun(ab0);

plot(x,y,'o'); title('Function to be fitted')

% the estimation step, using fminsearch
sumofsquares = @(ab) sum((y - predfun(ab)).^2);
abstart = [1 1 1];
abfinal = fminsearch(sumofsquares,abstart);

% degrees of freedom in the problem
dof = n - 2;
dof = n - 3;
dof = n - length(abstart);

% standard deviation of the residuals
sdr = sqrt(sum((y - predfun(abfinal)).^2)/dof);

yjunk = predfun(abfinal);
[Y,I] = sort(x);
plot(x,y,'o',x(I),yjunk(I),'r'); hl = legend('data','fit','location','best');

% jacobian matrix
J = jacobianest(predfun,abfinal);

% I'll be lazy here, and use inv. Please, no flames,
% if you want a better approach, look in my tips and
% tricks doc.
Sigma = sdr^2*inv(J'*J);

% Parameter standard errors
se = sqrt(diag(Sigma))';

% which suggest rough confidence intervalues around
% the parameters might be...
abupper = abfinal + 2*se;
ablower = abfinal - 2*se;

printarray([ab0; abfinal; se]','True value    RetrValue    Unc')

% I'll let you decide what the confidence level is, or if
% you would prefer to use a t-statistic for the above
% computation.
% 
% The output from the code above is...
% 
% 
% abfinal =
% 1.98856241997929 0.503604377341979
% 
% sdr =
% 0.102056089110678
% 
% se =
% 0.00786391742840254 0.0063796968802395
% 
% abupper =
% 2.00429025483609 0.516363771102458
% 
% ablower =
% 1.97283458512248 0.4908449835815
% 
% 
% You can find my optimization tips and tricks document at:
% 
%%%% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.doobjectId=8553&objectType=FILE
% < https://www.mathworks.com/matlabcentral/fileexchange/8553-optimization-tips-and-tricks > downloaded into TIPS
% 
% (Beware, the newsreader tends to wrap these URLs. Paste
% in BOTH lines!)
% 
% You can find jacobianest here:
% 
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?
% objectId=13490&objectType=FILE#
% 
% CAVEATS:
% The computations above assume many things about
% your problem. These assumptions include a normal
% (Gaussian) iid error structure, that the optimizaton
% has converged to a minimizer of the error surface,
% no lack of fit in the model, and probably a few other
% things I've forgotten to list here.
% 
% HTH,
% John D'Errico
