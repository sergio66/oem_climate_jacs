function [bjn,coeffssigbjn,dofs] = oem_Math_tsfit_lin_robust_LOWnHIGH(dtime,r,iNterms,b00,unc,uncB);

[m,n] = size(dtime); 
if m == 1
  dtime = dtime';
end
[m,n] = size(r); 
if m == 1
  r = r';
end

b0 = b00;

%% first guess, g also gives the jacs!!!!
b0 = 0 * b00; b0(1) = mean(r);
[y jac] = Math_timeseries_2_LOWnHIGH(dtime, b0 );
[m,n] = size(y); 
if m == 1
  y = y';
end

%for ii = 1 : 10
% bx = b0;
% bx(ii) = bx(ii) + 1;
% [yx] = Math_timeseries_2(dtime, bx );
% jacx(:,ii) = yx-y;
%end

if nargin == 4
  disp('nargin = 4, oem_Math_tsfit_lin_robust_LOWnHIGH.m is using unc = 0.25');
  unc = 0.25;
  disp('nargin = 4, oem_Math_tsfit_lin_robust_LOWnHIGH.m is using uncB = 1');
  uncB = 1.0;
elseif nargin == 5
  disp('nargin = 5, oem_Math_tsfit_lin_robust_LOWnHIGH.m is using uncB = 1');
  uncB = 1.0;
end

dbt = unc * ones(size(r));
seinv = diag(1./(dbt.*dbt));

bjn = b0;
sb = uncB * ones(size(bjn));
sbinv = diag(1./(sb .* sb));

errorx = pinv(jac' * seinv * jac + sbinv);
dofsx  = errorx * sbinv;
dofsx  = eye(size(dofsx)) - dofsx;
dofs   = trace(dofsx);
cdofs  = diag(dofsx);                 %% so we can do cumulative d.of.f
coeffssigbjn = sqrt(diag(errorx)');

chisqr = zeros(1,10);
junk   = (r-y)./dbt; chisqr(1) = sum(junk.*junk)/length(r);
for ii = 2 : 10
  db = pinv(jac' * seinv * jac + sbinv) * ((jac' * seinv * (r-y)) - sbinv * (bjn - b0));
  bjn = bjn + db;
  [y] = Math_timeseries_2_LOWnHIGH(dtime, bjn );
  [m,n] = size(y); 
  if m == 1
    y = y';
  end
  junk   = (r-y)./dbt; chisqr(ii) = sum(junk.*junk)/length(r);
end
