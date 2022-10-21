% read_tile_fits

addpath /asl/matlib/aslutil
addpath /asl/matlib/time
addpath ~/Matlab/Math

load_fairs

fdirpre = 'Data/Quantv2';
%fdirpre = 'Data/Quantv3';
%fdirpre = 'Data/Quantv2_fits';
%fdirpre = 'Data/Quantv1_fits';


%Data/Quantv2_fits/LatBin22/LonBin10:

for lati = 1:64
   lati
   for loni = 1:72
%      fnout = sprintf('LatBin%1$02d/LonBin%2$02d/hotfire_LatBin%1$02d_LonBin%2$02d_v2.mat',lati,loni);
%      fnout = sprintf('LatBin%1$02d/LonBin%2$02d/fits_19year_LatBin%1$02d_LonBin%2$02d_V2.mat',lati,loni);
%      fnout = sprintf('LatBin%1$02d/LonBin%2$02d/cfbins_LatBin%1$02d_LonBin%2$02d_V2.mat',lati,loni);
fnout = sprintf('LatBin%1$02d/LonBin%2$02d/cfbins_LatBin%1$02d_LonBin%2$02d_V2_iset437p.mat',ilat,ilon);

%      fnout = sprintf('LatBin%1$02d/LonBin%2$02d/tsurf_fits_LonBin%2$02d_LatBin%1$02d_V1.mat',lati,loni);
%      fnout = sprintf('LatBin%1$02d/LonBin%2$02d/tsurf_lag_fits_LonBin%2$02d_LatBin%1$02d_V1.mat',lati,loni);
      fnout = fullfile(fdirpre,fnout);
      if exist(fnout)
         bad(lati,loni) = 0;
         a = dir(fnout);
         fsize(lati,loni) = a.bytes;
      else
         bad(lati,loni) = 1;
         fsize(lati,loni) = 0;
      end
   end
end




