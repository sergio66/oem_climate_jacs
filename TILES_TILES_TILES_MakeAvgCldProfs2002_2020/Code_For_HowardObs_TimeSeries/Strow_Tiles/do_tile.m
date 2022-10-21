function [] = do_tile(ilon,ilat);

ilon
ilat


% To Do: high-res 1231 PDF
addpath /asl/matlib/aslutil
addpath  /umbc/xfs2/strow/asl/s1/motteler/airs_tiling

load latB64
load_fairs

quants =[0.01  0.02 0.03  0.04  0.05  0.10   0.25  0.50 ...
         0.75   0.90 0.95  0.96  0.97  0.98  0.99  1.00];

% Tsurf regression coefficients
p = [-0.17 -0.15 -1.66  1.06];

iset_start = 437;
iset_stop = 445;
% iset_start = 433;
% iset_stop = 436; 
% iset_start = 1;
% iset_stop = 416; 
iset_l = iset_stop - iset_start + 1;

r_desc       = NaN(iset_l,8,2645);
r_asc        = NaN(iset_l,8,2645);
r_desc_std   = NaN(iset_l,8,2645);
r_asc_std    = NaN(iset_l,8,2645);
r_desc_all  = NaN(iset_l,2645);
r_asc_all   = NaN(iset_l,2645);
count_asc    = NaN(iset_l,1);
count_desc   = NaN(iset_l,1);
satzen_asc   = NaN(iset_l,8);
satzen_desc  = NaN(iset_l,8);
solzen_asc   = NaN(iset_l,8);
solzen_desc  = NaN(iset_l,8);
tsurf_asc    = NaN(iset_l,8);
tsurf_desc   = NaN(iset_l,8);
tai93_asc    = NaN(iset_l,8);
tai93_desc   = NaN(iset_l,1);
counts_desc_bin = NaN(iset_l,8);
counts_asc_bin = NaN(iset_l,8);

iset = 0;
for iiset = iset_start:iset_stop
   iset = iset + 1;
   sprintf('%03d ',iiset)
   clear btbina btbind tsurf cf 
   
   [tname, tpath] = tile_file(ilat, ilon, latB2, [-180:5:180], iiset, 'tile');

   thome = '/asl/isilon/airs/tile_test7';
   tfull = fullfile(thome, tpath, tname);

   if exist(tfull)
      d = read_netcdf_lls(tfull);
      bt1231 = rad2bt(fairs(1520),d.rad(1520,:));
      bt1228 = rad2bt(fairs(1513),d.rad(1513,:));

      pv = polyval(p,bt1228 - bt1231);
      tsurf = bt1231 + pv;

      % Desc
      kd = (d.asc_flag == 68);
      ka = (d.asc_flag == 65);

      % Descending
      pqts = quantile(bt1231(kd),quants);
      xtsurf = nanmean(pqts(12:16));   % Too many maybe 15:16??
      cf = (xtsurf - pv) - bt1231;
      pqts = quantile(cf(kd),quants);
      maxb = min(xtsurf - min(bt1231(kd)),100);

      btbind = [min(cf(kd)) pqts(3) pqts(5) 10 30 50 70 100];  % 1st bin is hottest 3%, then 3-5%

% what if pqts(5) > 10?
      if pqts(5) > 10
         btbind(4) = round(pqts(5) + (btbind(5)-pqts(5))/2);
         btbind_flag(iset) = 1;
         btbind_bad(iset,:) = btbind;
      end

      [nd,ed,bind] = histcounts(cf,btbind);

      % Ascending (note: histcounts over all data, just different binning)
      pqts = quantile(bt1231(ka),quants);
      xtsurf = nanmean(pqts(12:16));
      cf = (xtsurf - pv) - bt1231;
      pqts = quantile(cf(ka),quants);
      maxb = min(xtsurf - min(bt1231(ka)),100);

      btbina = [min(cf(ka)) pqts(3) pqts(5) 10 30 50 70 100];   % 1st bin is hottest 3%, then 3-5%

% what if pqts(5) > 10?
      if pqts(5) > 10
         btbina(4) = round(pqts(5) + (btbina(5)-pqts(5))/2);
         btbina_flag(iset) = 1;
         btbina_bad(iset,:) = btbina;
      end

      [na,ea,bina] = histcounts(cf,btbina);

% Set size for r_desc and r_asc
      nx = length(d.lat);
      
% Bin the data
     r_desc_all(iset,:) = nanmean(d.rad(:,kd),2);
     bind = bind';
     for bi = 1:length(btbind)-1
         kget = kd & (bind==bi);
         r_desc(iset,bi,:) = nanmean(d.rad(:,kget),2);
         r_desc_std(iset,bi,:) = nanstd(d.rad(:,kget),0,2);
         satzen_desc(iset,bi) = nanmean(d.sat_zen(kget));
         solzen_desc(iset,bi) = nanmean(d.sol_zen(kget));
         tsurf_desc(iset,bi) = nanmean(tsurf(kget));
         counts_desc_bin(iset,bi) = length(find(kget == 1));
     end

     r_dasc_all(iset,:) = nanmean(d.rad(:,ka),2);
     bina = bina';
     for bi = 1:length(btbina)-1
        kget = ka & (bina==bi);
         r_asc(iset,bi,:) = nanmean(d.rad(:,kget),2);
         r_asc_std(iset,bi,:) = nanstd(d.rad(:,kget),0,2);
         satzen_asc(iset,bi) = nanmean(d.sat_zen(kget));
         solzen_asc(iset,bi) = nanmean(d.sol_zen(kget));
         tsurf_asc(iset,bi) = nanmean(tsurf(kget));
         counts_asc_bin(iset,bi) = length(find(kget == 1));
      end

      tai93_desc(iset) = nanmean(d.tai93(kd));
      tai93_asc(iset) = nanmean(d.tai93(ka));

      count_desc(iset) = length(find(kd == 1));
      count_asc(iset) =  length(find(ka == 1));
      
   end
end

clear band_cnt bi bina bind cf d dLon ka kd kget labB2 maxb tfull thome tname tpath tsurf xtsurf pv binsx na nd ea ed f fairs bt1228 bt1231

fdirpre_out = 'Data/Quantv2';
fnout_dir = sprintf('LatBin%1$02d/LonBin%2$02d',ilat,ilon);
fnout_dir = fullfile(fdirpre_out,fnout_dir)
if exist(fnout_dir) == 0
   mkdir(fnout_dir)
end

fnout = sprintf('LatBin%1$02d/LonBin%2$02d/cfbins_LatBin%1$02d_LonBin%2$02d_V2_iset437p.mat',ilat,ilon);
fnout = fullfile(fdirpre_out,fnout);

save(fnout);
