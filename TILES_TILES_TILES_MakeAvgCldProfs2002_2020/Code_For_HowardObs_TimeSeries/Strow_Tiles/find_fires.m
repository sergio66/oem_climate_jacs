function [] = find_fires(ilon,ilat);

ilon
ilat

addpath /asl/matlib/aslutil
addpath /asl/matlib/time
addpath  /umbc/xfs2/strow/asl/s1/motteler/airs_tiling
addpath ~/Matlab/

load latB64
load_fairs

load_fairs
load tsurf_minus_bt1231_net3.mat
load camel_tile_grid_2007
load Data/latB64

addpath ~/Work/Airs/Tiles

% Tsurf regression coefficients
pocean = [-0.17 -0.15 -1.66  1.06];

for iiset = 1:433
   iiset

   [tname, tpath] = tile_file(ilat, ilon, latB2, [-180:5:180], iiset, 'tile')
   thome = '/asl/isilon/airs/tile_test7';
   tfull = fullfile(thome, tpath, tname);
   if exist(tfull)
      d.tai93 = ncread(tfull,'tai93');
      d.lat = ncread(tfull,'lat');
      d.lon = ncread(tfull,'lon');
      d.land_frac = ncread(tfull,'land_frac');
      d.sol_zen = ncread(tfull,'sol_zen');
      d.sat_zen = ncread(tfull,'sat_zen');
      d.asc_flag = ncread(tfull,'asc_flag');
      d.rad = ncread(tfull,'rad');
      d.total_obs = ncread(tfull,'total_obs');
%     d = read_netcdf_lls(tfull);
      nobs = d.total_obs;
      obsl = logical(ones(length(d.lat),1));
      obsl(nobs:end) = 0;

      t1231 = NaN(1,nobs);
      
% First create tsurf find 2 highest temperature scenes
% These are on individual footprints!

% Separate by land/ocean since different emissivities
      kl = d.land_frac > 0.5 & obsl;

      if length(find(kl == 1)) > 10
         mtime = airs2dtime(d.tai93(kl));
         moni = month(nanmean(mtime));

         bt1231 = rad2bt(fairs(1520),d.rad(1520,kl));
         bt1228 = rad2bt(fairs(1513),d.rad(1513,kl));
         t1231 = NaN(1,length(bt1231));

% First need surface emis to get t1231
         x1 = squeeze(temis(moni,2,ilat,ilon)).*ones(1,length(bt1231));
         x2 = bt1231 - bt1228;
%         x3 = bt1231;
%         x = double([x1; x2; x3]);
         x = double([x1; x2]);
% Neural net solution for t1231
         t1231(kl)  = tsurf_minus_bt1231(x) + bt1231;
      end

      ko = d.land_frac <= 0.5 & obsl;

      if length(find(ko ==1)) > 0
         bt1231 = rad2bt(fairs(1520),d.rad(1520,ko));
         bt1228 = rad2bt(fairs(1513),d.rad(1513,ko));
         pv = polyval(pocean,bt1228 - bt1231);
% Regression solution for t1231 over ocean 
         t1231(ko) = bt1231 + pv;
      end

% Get max BTs before doing fires, night and day (but no ocean/land subsetting)
% Night
      asc_flag = 68;  % day == 65, night == 68
      kn = d.asc_flag == asc_flag & obsl;

      mtime = airs2dtime(d.tai93(kn));
      lat = d.lat(kn);
      lon = d.lon(kn);
      landfrac = d.land_frac(kn);
      bt1231 = rad2bt(fairs(1520),d.rad(1520,kn));
      bt1228 = rad2bt(fairs(1513),d.rad(1513,kn));
      bt2616 = rad2bt(fairs(2600),d.rad(2600,kn));
      t1231n = t1231(kn);

      [bh,ih] = maxk(t1231n,2);
      hot.night_t1231(iiset,:) = bh;
      hot.night_bt1231(iiset,:) = bt1231(ih);
      hot.night_bt1228(iiset,:) = bt1228(ih);
      hot.night_bt2616(iiset,:) = bt2616(ih);
      hot.night_lat(iiset,:) = lat(ih);
      hot.night_lon(iiset,:) = lon(ih);
      hot.night_time(iiset,:) = mtime(ih);
      %%%%%%  Add hot landfrac
      hot.night_landfrac(iiset,:) = landfrac(ih);
      
% Day
      asc_flag = 65;  % day == 65, night == 68
      kd = d.asc_flag == asc_flag & obsl;

      mtime = airs2dtime(d.tai93(kd));
      lat = d.lat(kd);
      lon = d.lon(kd);
      landfrac = d.land_frac(kd);

      bt1231 = rad2bt(fairs(1520),d.rad(1520,kd));
      bt1228 = rad2bt(fairs(1513),d.rad(1513,kd));
      bt2616 = rad2bt(fairs(2600),d.rad(2600,kd));
      t1231d = t1231(kd);

      [bh,ih] = maxk(t1231d,2);
      hot.day_t1231(iiset,:) = bh;
      hot.day_bt1231(iiset,:) = bt1231(ih);
      hot.day_bt1228(iiset,:) = bt1228(ih);
      hot.day_bt2616(iiset,:) = bt2616(ih);
      hot.day_lat(iiset,:) = lat(ih);
      hot.day_lon(iiset,:) = lon(ih);
      hot.day_time(iiset,:) = mtime(ih);
      %%%%%%  Add hot landfrac
      hot.day_landfrac(iiset,:) = landfrac(ih);
      
% Now do fires
% If most scenes are over ocean, skip to the end
      kl = d.land_frac > 0.5 & obsl;
      nland = length(find(kl == 1));
% If 10% or more of tile is land, go ahead with fires
      if nland > nobs/10
         dofire = true;
      else
         dofire = false;
         fires = [];
      end
      
      if dofire
% Night first  (ignore land vs ocean)
         asc_flag = 68;  % day == 65, night == 68
         kn = d.asc_flag == asc_flag & obsl;

         mtime = airs2dtime(d.tai93(kn));
         lat = d.lat(kn);
         lon = d.lon(kn);
         sat_zen = d.sat_zen(kn);
         sol_zen = d.sol_zen(kn);
         asc_flag = d.asc_flag(kn);

         bt810 = rad2bt(fairs(540),d.rad(540,kn));
         bt960 = rad2bt(fairs(958),d.rad(958,kn));
         bt1231 = rad2bt(fairs(1520),d.rad(1520,kn));
         bt1228 = rad2bt(fairs(1513),d.rad(1513,kn));
         bt2616 = rad2bt(fairs(2600),d.rad(2600,kn));
         t1231n = t1231(kn);
         rad = d.rad(:,kn);
         
         q = quantile(bt2616,0:0.1:1);
         q2 = quantile(bt1231,0:0.1:1);

         i1 = bt2616  >= q(10)  &  bt960 - bt810 < 1 &  bt1231 >= q2(10);

         p = polyfit(t1231n(i1),bt2616(i1),1);
         pc = polyval(p,t1231n(i1));

         tf = isoutlier(bt2616(i1) - pc,'grubbs') & bt2616(i1) - pc > 2;

         tfi = find(tf == 1);
         i1i = find(i1 == 1);
         firei = i1i(tfi);

         if length(firei) == 0
            latf = [];
            lonf = [];
            mtimef = nanmean(mtime);
            bt_fire = [];
            satzenf = [];
            solzenf = [];
            ascen = [];
            firei = [];
         else
            fire(iiset).night.latf = lat(firei);
            fire(iiset).night.lonf = lon(firei);
            fire(iiset).night.mtimef = mtime(firei);
            fire(iiset).night.bt_fire = rad2bt(fairs,rad(:,firei));
            fire(iiset).night.t1231 = t1231n(firei);
            fire(iiset).night.satzenf = sat_zen(firei);
            fire(iiset).night.solzenf = sol_zen(firei);
            fire(iiset).night.ascen =  char(asc_flag(firei));
         end
         
% Now Day
         asc_flag = 65;  % day == 65, night == 68
         kn = d.asc_flag == asc_flag;
         
         mtime = airs2dtime(d.tai93(kd));
         lat = d.lat(kd);
         lon = d.lon(kd);
         sat_zen = d.sat_zen(kd);
         sol_zen = d.sol_zen(kd);
         asc_flag = d.asc_flag(kd);
         
%       bt810 = rad2bt(fairs(540),d.rad(540,kn));
%       bt960 = rad2bt(fairs(958),d.rad(958,kn));
         bt1231 = rad2bt(fairs(1520),d.rad(1520,kd));
         bt1228 = rad2bt(fairs(1513),d.rad(1513,kd));
         bt2616 = rad2bt(fairs(2600),d.rad(2600,kd));
         t1231d = t1231(kd);
         rad = d.rad(:,kd);

         q = quantile(bt2616,0:0.1:1);
         q2 = quantile(bt1231,0:0.1:1);

         i1 = bt2616  >= q(10)  &  bt1231 >= q2(10);

         p = polyfit(t1231d(i1),bt2616(i1),1);
         pc = polyval(p,t1231d(i1));

         tf = isoutlier(bt2616(i1) - pc,'grubbs') & bt2616(i1) - pc > 2;

         tfi = find(tf == 1);
         i1i = find(i1 == 1);
         firei = i1i(tfi);

         if length(firei) == 0
            latf = [];
            lonf = [];
            mtimef = nanmean(mtime);
            bt_fire = [];
            satzenf = [];
            solzenf = [];
            ascen = [];
            firei = [];
         else
            fire(iiset).day.latf = lat(firei);
            fire(iiset).day.lonf = lon(firei);
            fire(iiset).day.mtimef = mtime(firei);
            fire(iiset).day.bt_fire = rad2bt(fairs,rad(:,firei));
            fire(iiset).day.t1231 = t1231d(firei);
            fire(iiset).day.satzenf = sat_zen(firei);
            fire(iiset).day.solzenf = sol_zen(firei);
            fire(iiset).day.ascen =  char(asc_flag(firei));
         end
      end % fires
   end % if file exists
end % iiset


if exist('fire')
   save('testorig_ilon39_ilat41', 'hot','fire');
else
   save('testorig_ilon39_ilat41','hot');
end

% fdirpre_out = 'Data/Quantv3';
% fnout_dir = sprintf('LatBin%1$02d/LonBin%2$02d',ilat,ilon);
% fnout_dir = fullfile(fdirpre_out,fnout_dir)
% if exist(fnout_dir) == 0
%    mkdir(fnout_dir)
% end
% fnout = sprintf('xLatBin%1$02d/LonBin%2$02d/hotfire_LatBin%1$02d_LonBin%2$02d_v2.mat',ilat,ilon,iiset)
% fnout = fullfile(fdirpre_out,fnout)
% 
% if exist('fire')
%    save(fnout, 'hot','fire');
% else
%    save(fnout,'hot');
% end
% 
% 
