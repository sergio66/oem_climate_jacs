addpath  /asl/s1/strow/Camel/Matlab/MEASURES_CAMEL_hsremis_matlab_V002_v02r01_del_10092018/mfiles             

cameldir = '/asl/s1/strow/Camel';
camelcoef = 'Matlab/MEASURES_CAMEL_hsremis_matlab_V002_v02r01_del_10092018/coef/pchsr_v12.2.mat';

load(fullfile(cameldir,camelcoef));

hsr_wavenum = fliplr([2778:-5:694]);
cfile = '/asl/data/iremis/CAMEL/CAM5K30CF.002/2007.xx.01/CAM5K30CF_coef_2007xx_V002.nc'

load Data/latB64
tlat = (latB2(2:end) + latB2(1:end-1))/2;
tlon = -177.5:5:177.5;

[xm ym]= meshgrid(tlon,tlat);
temis = NaN(12,3,64,72);

numwave = 3;
idwave = [10 108 385];  % guessing

for moni=1:12
   mon = sprintf('%02d',moni)
   fn = replace(cfile,'xx',mon)

   camel = read_CAMEL_coef_V002(fn);
   if moni == 1
      clon = double(camel.lon');
      clat = double(camel.lat');
   end

   [a, numemis] = size(camel.coef);
   numwave = length(hsr_wavenum);

   hsremis = NaN.*ones(length(idwave),numemis) ;
   for i = 1:numemis
      col2 = PC.U(:,1:9)*camel.coef(1:9,i) + PC.M;
      hsremis(:,i) = col2(idwave);
   end
% convert to tile grid

   hsremis = reshape(hsremis,3,7200,3600);
   for ch = 1:3
      temis(moni,ch,:,:) = interp2(clon,clat,squeeze(hsremis(ch,:,:))',xm,ym);
   end
end
