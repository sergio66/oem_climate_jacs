addpath /asl/matlib/aslutil
addpath ~/Matlab/Math
load_fairs

b = NaN(64,72,2645,10);
berr = NaN(64,72,2645,10);
dbt =  NaN(64,72,2645);
dbt_err =  NaN(64,72,2645);
lag = NaN(64,72,2645);

fdir1 = '/asl/stats/airs/L1c_v672/gridded/grid_by_time/';

for ilat=1:64
   ilat
   for ilon = 1:72
      fdir2 = ['lat_' int2str(ilat)];
      fdir = fullfile(fdir1,fdir2);

      fn = fullfile(fdir,['short_fit_var_grid_lat_lon_' int2str(ilat) '_' int2str(ilon)]);

      g = load(fn);
      b(ilat,ilon,:,:) = g.b;
      berr(ilat,ilon,:,:) = g.berr;
      dbt(ilat,ilon,:) = g.dbt;
      dbt_err(ilat,ilon,:) = g.dbt_err;
      lag(ilat,ilon,:) = g.lag;
   end
end

% 
b = single(b);
berr = single(berr);
dbt = single(dbt);
dbt_err = single(dbt_err);
lag = single(lag);
