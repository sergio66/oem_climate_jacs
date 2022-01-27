function bjn = oem_Math_tsfit_lin_robust(dtime,r,iNterms,b00);

b0 = b00;

%% first guess, g also gives the jacs!!!!
b0 = 0 * b00; b0(1) = mean(r);
[y jac] = Math_timeseries_2(dtime, b0 );

%for ii = 1 : 10
% bx = b0;
% bx(ii) = bx(ii) + 1;
% [yx] = Math_timeseries_2(dtime, bx );
% jacx(:,ii) = yx-y;
%end

dbt = 0.25 * ones(size(r));
seinv = diag(1./(dbt.*dbt));

bjn = b0;
sb = 10 * ones(size(bjn));
sbinv = diag(1./(sb .* sb));

chisqr = zeros(1,10);
junk   = (r-y)./dbt; chisqr(1) = sum(junk.*junk)/length(r);
for ii = 2 : 10
  db = pinv(jac' * seinv * jac + sbinv) * ((jac' * seinv * (r-y)) - sbinv * (bjn - b0));
  bjn = bjn + db;
  [y] = Math_timeseries_2(dtime, bjn );
  junk   = (r-y)./dbt; chisqr(ii) = sum(junk.*junk)/length(r);
end
