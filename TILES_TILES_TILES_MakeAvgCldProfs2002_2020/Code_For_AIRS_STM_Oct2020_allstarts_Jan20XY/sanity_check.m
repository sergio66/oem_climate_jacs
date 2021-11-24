function prof = sanity_check(pIN0);

%% checks cloud params, and that all fields have finite values

prof = pIN0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove cloud fractions less than some minimum

%disp('checking cfrac after smoothing ....')

set_cloud_minmax_params

hcmin = 0.5*cmin;

ix=find(prof.cfrac < cmin);
prof.cfrac(ix)  = 0;
prof.cfrac12(ix)= 0;
prof.cngwat(ix) = 0;
prof.ctype(ix)  = -1;
prof.cprtop(ix) = -9999;
prof.cprbot(ix) = -9999;

ix=find(prof.cfrac2 < cmin);
prof.cfrac2(ix)  = 0;
prof.cfrac12(ix) = 0;
prof.cngwat2(ix) = 0;
prof.ctype2(ix)  = -1;
prof.cprtop2(ix) = -9999;
prof.cprbot2(ix) = -9999;

%{
%%% WOW did not have this in the 
ix=find(prof.ctype == 101 & prof.cprtop < 400);
prof.cfrac(ix)  = 0;
prof.cfrac12(ix) = 0;
prof.cngwat(ix) = 0;
prof.ctype(ix)  = -1;
prof.cprtop(ix) = -9999;
prof.cprbot(ix) = -9999;

ix=find(prof.ctype2 == 101 & prof.cprtop2 < 400);
prof.cfrac2(ix)  = 0;
prof.cfrac12(ix) = 0;
prof.cngwat2(ix) = 0;
prof.ctype2(ix)  = -1;
prof.cprtop2(ix) = -9999;
prof.cprbot2(ix) = -9999;
%}

ix=find(prof.cngwat < 0.00001);
prof.cfrac(ix)  = 0;
prof.cfrac12(ix)= 0;
prof.cngwat(ix) = 0;
prof.ctype(ix)  = -1;
prof.cprtop(ix) = -9999;
prof.cprbot(ix) = -9999;

ix=find(prof.cngwat2 < 0.00001);
prof.cfrac2(ix)  = 0;
prof.cfrac12(ix) = 0;
prof.cngwat2(ix) = 0;
prof.ctype2(ix)  = -1;
prof.cprtop2(ix) = -9999;
prof.cprbot2(ix) = -9999;

ix = find(prof.cfrac12 >= hcmin & prof.cfrac12 < cmin);
prof.cfrac12(ix) = cmin;
ix = find(prof.cfrac12 < hcmin);
prof.cfrac12(ix) = 0;
junk = prof.cfrac(ix) + prof.cfrac2(ix);
lljunk = ix( find(junk > 1) );
lljunk1 = lljunk( find(prof.cfrac(lljunk) > prof.cfrac2(lljunk)) );
lljunk2 = setdiff(lljunk,lljunk1);
prof.cfrac(lljunk1) = prof.cfrac(lljunk1)-hcmin;
prof.cfrac2(lljunk2) = prof.cfrac2(lljunk2)-hcmin;

cfracx  = prof.cfrac - prof.cfrac12;
cfrac2x = prof.cfrac2 - prof.cfrac12;
ctot = cfracx + cfrac2x + prof.cfrac12;
ix = find(ctot > 1);
%% prof.cfrac12(ix) =  max(prof.cfrac(ix) + prof.cfrac2(ix) - 1 + eps,0);
%% prof.cfrac12(ix) =  max(1-cfracx(ix)-cfrac2x(ix) + eps,0);   %% new Jan 2016

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% black cloud check
oo = find(prof.ctype < 100);
prof.cfrac12(oo) = 0.0;
prof.cngwat(oo)  = 0.0;
prof.cfrac(oo)  = 0.0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% now check cprtop
%disp('---> checking cprtop vs cprbot vs spres')
prof = fix_clouds_as_needed(prof);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% now check for finite values
iBad = -1;
fdnames = fieldnames(prof);
for lljunk = 1 : length(fdnames)
  fxname = fdnames{lljunk};
  str = ['junk = prof.' fxname ';'];
  eval(str);
  oo = find(~isfinite(junk));
  if length(oo) > 0 & ~strcmp(fxname,'icetop') & ~strcmp(fxname,'watertop') 
    iBad = +1;
    fprintf(1,'oh no %s has %8i values which are not finite \n',fxname,length(oo));
  end
end
if iBad > 0
  %error('hey buddy ya got some non finite values ...');
  warning('hey buddy ya got some non finite values ...');
end
