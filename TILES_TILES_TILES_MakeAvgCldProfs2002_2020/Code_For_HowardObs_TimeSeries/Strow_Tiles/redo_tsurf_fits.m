addpath /asl/matlib/aslutil
addpath /asl/matlib/time
addpath ~/Matlab/Math
load_fairs

fdirpre = 'Data/Quantv2_fits/';
fdirpre_out = 'Data/Quantv1_fits';

desc_tsurf = NaN(64,72,437);
asc_tsurf = NaN(64,72,437);

for ilat = 1:64
   ilat
   for ilon = 1:72
      fn = sprintf('LatBin%1$02d/LonBin%2$02d/fits_19year_LatBin%1$02d_LonBin%2$02d_V2.mat',ilat,ilon);
      fn = fullfile(fdirpre,fn);

      load(fn,'all_desc_tsurf','all_asc_tsurf');
      desc_tsurf(ilat,ilon,:) = nanmean(all_desc_tsurf);
      asc_tsurf(ilat,ilon,:) = nanmean(all_asc_tsurf);

      
   
   end
end



