function [all] = find_fires_orig(ilon,ilat);

ilon
ilat


% To Do: high-res 1231 PDF
addpath /asl/matlib/aslutil
addpath  /umbc/xfs2/strow/asl/s1/motteler/airs_tiling

load latB64
load_fairs


load_fairs
load tsurf_minus_bt1231_net2.mat
load camel_tile_grid_2007
load Data/latB64

addpath ~/Work/Airs/Tiles

%cd ~/Work/Airs/Tiles/Data/Gridtiles/

%d = read_netcdf_lls('tile_2021_s427_N49p50_W125p00.nc');
%d = read_netcdf_lls('Data/Gridtiles/tile_2016_s320_N49p50_W125p00.nc');
%d = read_netcdf_lls('Data/Gridtiles/tile_2020_s405_N49p50_W125p00.nc');
% Next is good test tile, B.C. in 2021
%d = read_netcdf_lls('Data/Gridtiles/tile_2021_s430_N49p50_W125p00.nc');
%d = read_netcdf_lls('Data/Gridtiles/tile_2019_s385_N57p75_E105p00.nc');


for iiset = 1:433
   iiset

   [tname, tpath] = tile_file(ilat, ilon, latB2, [-180:5:180], iiset, 'tile')
   thome = '/asl/isilon/airs/tile_test7';
   tfull = fullfile(thome, tpath, tname);
   if exist(tfull)
      d = read_netcdf_lls(tfull);



      mtime = airs2dtime(d.tai93);

      bt810 = rad2bt(fairs(540),d.rad(540,:));
      bt960 = rad2bt(fairs(958),d.rad(958,:));
      bt1231 = rad2bt(fairs(1520),d.rad(1520,:));
      bt1228 = rad2bt(fairs(1513),d.rad(1513,:));
      bt2616 = rad2bt(fairs(2600),d.rad(2600,:));

% Night first
      asc_flag = 68;  % day == 65, night == 68
      k = d.asc_flag == asc_flag;
      q = quantile(bt2616(k),0:0.1:1);
      q2 = quantile(bt1231(k),0:0.1:1);

      i1 = bt2616  >= q(10)  &  bt960 - bt810 < 1 & d.asc_flag' == asc_flag & bt1231 >= q2(10);

      moni = month(nanmean(mtime));
      xlat = min(d.lat);
      xlon = min(d.lon);
      [ilat,ilon,latB,lonB] = tile_index(latB2,5,xlat,xlon);

      x1 = squeeze(temis(moni,2,ilat,ilon)).*ones(1,length(bt1231));
      x2 = bt1231 - bt1228;
      x3 = bt1231;
      x = double([x1; x2; x3]);
      t1231  = tsurf_minus_bt1231(x) + bt1231;

      p = polyfit(t1231(i1),bt2616(i1),1);
      pc = polyval(p,t1231(i1));

      tf = isoutlier(bt2616(i1) - pc,'grubbs') & bt2616(i1) - pc > 0.5;

      tfi = find(tf == 1);
      i1i = find(i1 == 1);
      firei = i1i(tfi);

      if length(firei) == 0
         latf = [];
         lonf = [];
         mtimef = nanmean(mtime(k));
         bt_fire = [];
         satzenf = [];
         solzenf = [];
         ascen = [];
         firei = [];
      else
         all(iiset).night.latf = d.lat(firei);
         all(iiset).night.lonf = d.lon(firei);
         all(iiset).night.mtimef = mtime(firei);
         all(iiset).night.bt_fire = rad2bt(fairs,d.rad(:,firei));
         all(iiset).night.satzenf = d.sat_zen(firei);
         all(iiset).night.solzenf = d.sol_zen(firei);
         all(iiset).night.ascen =  char(d.asc_flag(firei));
         all(iiset).night.firei = firei;
      end

% Now get 2 hottest
      [bh,ih] = maxk(t1231,2);
      all(iiset).night.hott1231 = bh;
      all(iiset).night.hotbt1231 = bt1231(ih);
      ih2 =  d.asc_flag' == asc_flag & bt1231 == bh;
      all(iiset).night.hotbt1228) = bt1228(ih2);
      [bh,ih] = maxk(bt2616,2);
      all(iiset).night.hotbt2616) = bh;
      all(iiset).night.hotlat = d.lat(ih2);
      all(iiset).night.hotlon = d.lon(ih2);
      all(iiset).night.hottime = mtime(ih2);
      
%-------------------------------------------------------------------------------
% Now Day
%-------------------------------------------------------------------------------

      asc_flag = 65; 
      k = d.asc_flag == asc_flag;
      q = quantile(bt2616(k),0:0.1:1);
      q2 = quantile(bt1231(k),0:0.1:1);

% Removed longwave cirrus test??
      i1 = bt2616  >= q(10)  &  d.asc_flag' == asc_flag & bt1231 >= q2(10);

      x1 = squeeze(temis(moni,2,ilat,ilon)).*ones(1,length(bt1231));
      x2 = bt1231 - bt1228;
      x3 = bt1231;
      x = double([x1; x2; x3]);
      t1231  = tsurf_minus_bt1231(x) + bt1231;

      p = polyfit(t1231(i1),bt2616(i1),1);
      pc = polyval(p,t1231(i1));

      tf = isoutlier(bt2616(i1) - pc,'grubbs') & bt2616(i1) - pc > 2 ;

      tfi = find(tf == 1);
      i1i = find(i1 == 1);
      firei = i1i(tfi);

      if length(firei) == 0;
         latf = [];
         lonf = [];
         mtimef = nanmean(mtime(k));
         bt_fire =  [];
         satzenf =  [];
         solzenf =  [];
         ascen =  [];
         firei_day =  [];
         allfirei =  [];
      else
         all(iiset).day.latf = d.lat(firei);
         all(iiset).day.lonf = d.lon(firei);
         all(iiset).day.mtimef = mtime(firei);
         all(iiset).day.bt_fire = rad2bt(fairs,d.rad(:,firei));
         all(iiset).day.satzenf = d.sat_zen(firei);
         all(iiset).day.solzenf = d.sol_zen(firei);
         all(iiset).day.ascen =  char(d.asc_flag(firei));
         all(iiset).day.firei = firei;
      end
% Now get 2 hottest
      [bh,ih] = maxk(t1231,2);
      all(iiset).day.hott1231 = bh;
      all(iiset).day.hotbt1231 = bt1231(ih);
      ih2 =  d.asc_flag' == asc_flag & bt1231 == bh;
      all(iiset).day.hotbt1228) = bt1228(ih2);
      [bh,ih] = maxk(bt2616,2);
      all(iiset).day.hotbt2616) = bh;
      all(iiset).day.hotlat = d.lat(ih2);
      all(iiset).day.hotlon = d.lon(ih2);
      all(iiset).day.hottime = mtime(ih2);
   end
end

%       fdirpre_out = 'Data/Quantv3';
%       fnout_dir = sprintf('LatBin%1$02d/LonBin%2$02d',ilat,ilon);
%       fnout_dir = fullfile(fdirpre_out,fnout_dir)
%       if exist(fnout_dir) == 0
%          mkdir(fnout_dir)
%       end
% 
%       fnout = sprintf('LatBin%1$02d/LonBin%2$02d/cfbins_LatBin%1$02d_LonBin%2$02d_V2_iset433p.mat',ilat,ilon,iiset);
%       fnout = fullfile(fdirpre_out,fnout)
% 
%       save(fnout, 'all');

