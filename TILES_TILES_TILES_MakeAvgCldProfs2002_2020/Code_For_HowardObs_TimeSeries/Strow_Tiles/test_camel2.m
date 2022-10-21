addpath  /asl/s1/strow/Camel/Matlab/MEASURES_CAMEL_hsremis_matlab_V002_v02r01_del_10092018/mfiles

hsr_wavenum = fliplr([2778:-5:694]);
cfile = '/asl/data/iremis/CAMEL/CAM5K30CF.002/2007.xx.01/CAM5K30CF_coef_2007xx_V002.nc'
%cfile = '~/Desktop/CAM5K30CF_coef_2007xx_V002.nc'

cameldir = '/asl/s1/strow/Camel';
camelpc = 'Matlab/MEASURES_CAMEL_hsremis_matlab_V002_v02r01_del_10092018/coef/pchsr_vxx';

% cameldir = '~/Desktop';
% camelpc = 'pchsr_vxx';  

load ~/Work/Airs/Tiles/Data/latB64
tlat = (latB2(2:end) + latB2(1:end-1))/2;
tlon = -177.5:5:177.5;

[xm ym]= meshgrid(tlon,tlat);
temis = NaN(12,3,64,72);

numwave = 3;
idwave = [42 108 385];  % guessing

% test   1331,3831 (dessert)

for moni=1:12
   %for moni=9
   mon = sprintf('%02d',moni)
   fn = replace(cfile,'xx',mon)

   camel = lls_read_CAMEL_coef_V002(fn);
   [npc, nlon, nlat] = size(camel.coef);
   pclabvs = reshape(camel.pclabvs,1,nlon*nlat);
   coef = reshape(camel.coef,npc,nlon*nlat);
   numwave = length(hsr_wavenum);
   hsremis = NaN.*ones(length(idwave),nlon*nlat) ;
   
% For first month, generate lat/lon boundaries and lf (landfrac)
   if moni == 1
      clat = -90:0.05:90;
      clon = -180:0.05:180;

% Match camel to latB2 boundaries (all latB2 boundaries match some clat/clon boundaries)
      for bi=1:65
         le(bi) = find(clat >= latB2(bi) ,1);
      end

   end

   kg = ~isnan(pclabvs);
   vs = unique(pclabvs(kg));

   for l = 1:length(vs)
      k = pclabvs == vs(l);
      camelcoef_vs = replace(camelpc,'xx',int2str(vs(l)));
      camelcoef_vs = [camelcoef_vs '.2.mat'];
      load(fullfile(cameldir,camelcoef_vs));

      col2 = PC.U(:,1:9)*coef(:,k) + PC.M;
      hsremis(:,k) = col2(idwave,:);
   end
   hsremis2 = reshape(hsremis,3,nlon,nlat);
   
   
   for ch = 1:3
      e = squeeze(hsremis2(ch,:,:));
% Very first time (moni, ch) compute the landfrac (lf)
      if moni ==1 & ch == 1
         for ii = 1:64
            for jj = 1:72
               i = [le(ii):(le(ii+1)-1)];
               j = [(100*jj - 99):(100*jj)];
               y = e(j,i);
%            ee(ii,jj) = nanmean(y,[1 2]);
               [nyx nyy] = size(y);
               totaln = nyx * nyy;
               nl = length(find( ~isnan(y(:)) == 1));
               lf(ii,jj) = nl/totaln;
            end
         end
      else
         for ii = 1:64
            for jj = 1:72
               i = [le(ii):(le(ii+1)-1)];
               j = [(100*jj - 99):(100*jj)];
               temis(moni,ch,ii,jj) = nanmean(e(j,i),[1 2]);
            end
         end
      end
   end
end
   
save temis_new temis lf

   