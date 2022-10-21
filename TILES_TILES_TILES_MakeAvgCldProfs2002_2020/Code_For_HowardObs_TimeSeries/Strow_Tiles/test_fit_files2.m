% read_tile_fits

addpath /asl/matlib/aslutil
addpath /asl/matlib/time
addpath ~/Matlab/Math

load_fairs

for lati = 1:5
   lati
   for loni = 1:5
      fdirpre = 'Data/Quantv1_fits';
      fnout = sprintf('LatBin%1$02d/LonBin%2$02d/fits_LonBin%2$02d_LatBin%1$02d_V1.mat',lati,loni);
      fnout = fullfile(fdirpre,fnout);
      d=load(fnout);
      if isfield(d,'desc_tsurf')
         tsok(lati,loni) = 1;
      else
         tsok(lati,loni) = 0;
      end
   end
end




