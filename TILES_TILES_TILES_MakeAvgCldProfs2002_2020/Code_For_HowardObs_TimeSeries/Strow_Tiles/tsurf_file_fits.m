% read_tile_fits

addpath /asl/matlib/aslutil
addpath /asl/matlib/time
addpath ~/Matlab/Math

load_fairs

warning on
for lati = 1:64
   lati
   for loni = 1:72
      fdirpre = 'Data/Quantv1_fits';
      fnout = sprintf('LatBin%1$02d/LonBin%2$02d/fits_LonBin%2$02d_LatBin%1$02d_V1.mat',lati,loni);
      fnout = fullfile(fdirpre,fnout);
      d = load(fnout);
% Trends
% Select time period
      kd = d.k_desc;
      mtime = d.mtime;
      kt = mtime >= datetime(2003,1,1) & mtime <= datetime(2017,12,31);
      kd = kd & kt;
      kdi = find(kd == 1,1);
      
      ka = d.k_asc;
      mtime = d.mtime;
      kt = mtime >= datetime(2003,1,1) & mtime <= datetime(2017,12,31);
      ka = ka & kt;
      kai = find(ka == 1,1);
      
      [b_desc(lati,loni,:) stats_desc] = Math_tsfit_lin_robust(d.dtime(kd)-d.dtime(kdi),d.desc_tsurf(kd),4);
      [b_asc(lati,loni,:)  stats_asc]  = Math_tsfit_lin_robust(d.dtime(ka)-d.dtime(kai),d.asc_tsurf(ka),4);
% Lag-1 uncertainty correctionss
      l = xcorr(stats_desc.resid,1,'coeff');
      lag_desc = l(1);
      lag_desc_c = sqrt( (1 + lag_desc) ./ ( 1 - lag_desc));

      l = xcorr(stats_asc.resid,1,'coeff');
      lag_asc = l(1);
      lag_asc_c = sqrt( (1 + lag_asc) ./ ( 1 - lag_asc));

      b_err_desc(lati,loni) = stats_desc.se(2).*lag_desc;
      b_err_asc(lati,loni) = stats_asc.se(2).*lag_asc;

      desc_resid_std(lati,loni) = nanstd(stats_desc.resid);
      asc_resid_std(lati,loni) = nanstd(stats_asc.resid);
   end
end
warning off



