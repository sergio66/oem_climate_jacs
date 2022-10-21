% read_tile_fits

addpath /asl/matlib/aslutil
addpath /asl/matlib/time
addpath ~/Matlab/Math

load_fairs

fdirpre = 'Data/Quantv3';

hotday = NaN(64,72,433,2);
hotdaylf = NaN(64,72,433,2);
hotlatday = NaN(64,72,433,2);
hotlonday = NaN(64,72,433,2);
hotnight = NaN(64,72,433,2);
hotnightlat = NaN(64,72,433,2);
hotnightlf = NaN(64,72,433,2);
hotnightlon = NaN(64,72,433,2);

hotdaytime = NaT(64,72,433,2);
hotnighttime = NaT(64,72,433,2);

for lati = 1:64
   lati
   for loni = 1:72
      loni;
      fnout = sprintf('LatBin%1$02d/LonBin%2$02d/hotfire_LatBin%1$02d_LonBin%2$02d.mat',lati,loni);
      fnout = fullfile(fdirpre,fnout);
      d = load(fnout);

      hotday(lati,loni,:,:) = d.hot.day_bt1231;
      hotnight(lati,loni,:,:) = d.hot.night_bt1231;
      hotday_sw(lati,loni,:,:) = d.hot.day_bt2616;
      hotnight_sw(lati,loni,:,:) = d.hot.night_bt2616;

   end
end



% Any fires at all





