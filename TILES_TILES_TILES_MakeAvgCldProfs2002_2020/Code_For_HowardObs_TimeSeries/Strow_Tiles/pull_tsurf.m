% read_tile_fits

addpath /asl/matlib/aslutil
addpath /asl/matlib/time
addpath ~/Matlab/Math

load_fairs

for lati = 1:64
   lati
   for loni = 1:72
      fdirpre = 'Data/Quantv1_fits';
      fnout = sprintf('LatBin%1$02d/LonBin%2$02d/fits_LonBin%2$02d_LatBin%1$02d_V1.mat',lati,loni);
      fnout = fullfile(fdirpre,fnout);
      d = load(fnout,'dbt_desc
      tsurf_desc_rate(lati,loni) = d.dbt_desc_tsurf
end


            desc_tsurf: [412x1 double]
        dbt_desc_tsurf: [5x10 double]
    dbt_desc_tsurf_err: [5x2 double]
             asc_tsurf: [412x1 double]
         dbt_asc_tsurf: [5x10 double]
     dbt_asc_tsurf_err: [5x2 double]


