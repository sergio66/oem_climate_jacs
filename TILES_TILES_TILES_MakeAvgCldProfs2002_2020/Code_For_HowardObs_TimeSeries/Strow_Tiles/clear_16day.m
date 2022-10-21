ilon = 23;ilat = 32;
iset = 352;

thome = 'Data/Fulltiles';

addpath /asl/packages/ccast/source
addpath /asl/packages/ccast/motmsc/time
addpath /home/motteler/shome/obs_stats/sst_source

load latB64
load_fairs

quants =[0.01  0.02 0.03  0.04  0.05  0.10   0.25  0.50 ...
         0.75   0.90 0.95  0.96  0.97  0.98  0.99  1.00];

% Tsurf regression coefficients
p = [-0.17 -0.15 -1.66  1.06];

ilat_ocean = [];
ilon_ocean = [];

% No ocean ilat == 1 | 2 so skip
for ilat = 3:64
   ilat
   for ilon = 1:72
      [tname, tpath] = tile_file(ilat, ilon, latB2, [-180:5:180], iset, 'tile');
      tfull = fullfile(thome, tpath, tname);

      d = read_netcdf_lls(tfull);

      bt1231 = rad2bt(fairs(1520),d.rad(1520,:));
      bt1228 = rad2bt(fairs(1513),d.rad(1513,:));

      pv = polyval(p,bt1228 - bt1231);
      tsurf = bt1231 + pv;

% Desc/Asc over ocean
      kd = (d.asc_flag == 68 & d.land_frac == 0);
      ka = (d.asc_flag == 65 & d.land_frac == 0);

      if (length(find(kd == 1)) > 10) & (length(find(kd == 1)) > 10)

% Pick hottest 2% using tsurf
% Descending, must subset
         pqts = quantile(tsurf(kd),quants);
         tsurfd = tsurf(kd);
         bt1231d = bt1231(kd);
         tai_d = d.tai93(kd);
         lat_d = d.lat(kd);
         lon_d = d.lon(kd);
         satzen_d = d.sat_zen(kd);
         solzen_d = d.sol_zen(kd);

         [n,~,bint] =  histcounts(tsurfd,pqts(14:16));
         khot = (bint == 1 | bint == 2);
         bt1231d = bt1231d(khot);
         tai_d = tai_d(khot);
         lat_d = lat_d(khot);
         lon_d = lon_d(khot);
         satzen_d = satzen_d(khot);
         solzen_d = solzen_d(khot);
         tsurf_d = tsurfd(khot);

         sst_d = oisst_match(tai_d,lat_d,lon_d) + 273.15;

% Ascending, must subset
         pqts = quantile(tsurf(ka),quants);
         tsurfa = tsurf(ka);
         bt1231a = bt1231(ka);
         tai_a = d.tai93(ka);
         lat_a = d.lat(ka);
         lon_a = d.lon(ka);
         satzen_a = d.sat_zen(ka);
         solzen_a = d.sol_zen(ka);

         [n,~,bint] =  histcounts(tsurfa,pqts(14:16));
         khot = (bint == 1 | bint == 2);
         bt1231a = bt1231a(khot);
         tai_a = tai_a(khot);
         lat_a = lat_a(khot);
         lon_a = lon_a(khot);
         satzen_a = satzen_a(khot);
         solzen_a = solzen_a(khot);
         tsurf_a = tsurfa(khot);

         sst_a = oisst_match(tai_a,lat_a,lon_a) + 273.15;

         save(['hotsub_lat' int2str(ilat) '_lon' int2str(ilon)],...
              'bt1231d', 'bt1231a', 'tai_d', 'tai_a', 'lat_d', 'lat_a', ...
              'satzen_d','satzen_a','solzen_d','solzen_a','sst_d','sst_a','tsurf_d','tsurf_a');

         ilon_ocean = [ilon_ocean ilon];
         ilat_ocean = [ilat_ocean ilat];
      end
   end
end
