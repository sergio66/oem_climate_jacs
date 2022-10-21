addpath /asl/matlib/aslutil
addpath ~/Matlab/Math
load_fairs

anom = NaN(64,72,407,2645);

fdir1 = '/asl/stats/airs/L1c_v672/gridded/grid_by_time/';

for ilat=1:64
   ilat
   for ilon = 1:72
      fdir2 = ['lat_' int2str(ilat)];
      fdir = fullfile(fdir1,fdir2);

      fn = fullfile(fdir,['fit_grid_lat_lon_' int2str(ilat) '_' int2str(ilon)]);

      load(fn,'bt_anom');
      anom(ilat,ilon,:,:) = bt_anom';
   end
end

