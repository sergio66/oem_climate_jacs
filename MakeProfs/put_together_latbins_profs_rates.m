addpath /home/sergio/MATLABCODE/COLORMAP

for ii = 1 : 6; figure(ii); clf; end

junk = load('/home/sergio/MATLABCODE/ROSES_2013_GRANT/NewClearPDFs/era_geo_rates_allsky_AIRIBRAD.mat');

set_dirIN_dirOUT

for ii = 1 : 40
  fout = [dirOUT '/latbin' num2str(ii) '_rates.mat'];
  loader = ['a = load(''' fout ''');'];
  eval(loader)
  all.stemprate(ii)    = a.rate.stemp;
  all.stempratestd(ii) = a.rate.stemp_err;  
  all.mmwrate(ii)     = a.rate.mmw;
  all.mmwratestd(ii)  = a.rate.mmw_err;
  all.ptemprate(ii,:)     = a.rate.ptemp;
  all.ptempratestd(ii,:) = a.rate.ptemp_err;  
  all.waterrate(ii,:)     = a.rate.frac_gas_1;
  all.waterratestd(ii,:) = a.rate.frac_gas_1_err;  
  all.ozonerate(ii,:)     = a.rate.frac_gas_3;
  all.ozoneratestd(ii,:) = a.rate.frac_gas_3_err;  
end

thestats.lats = junk.thestats.lats;
airslevels = flipud(junk.airslevels);
latx = junk.latx;
airslevels = junk.airslevels(1:98);
pN = airslevels(1:end-1)-airslevels(2:end);
pD = log(airslevels(1:end-1)./airslevels(2:end));
airslays = pN./pD;
airslays = airslays(1:97);

figure(1);  errorbar(1:40,all.stemprate,all.stempratestd); title('stemp'); grid
  ax = axis; line([ax(1) ax(2)],[0 0 ],'color','k','linewidth',2)
figure(2);  errorbar(1:40,all.mmwrate,all.mmwratestd); title('mmw'); grid
  ax = axis; line([ax(1) ax(2)],[0 0 ],'color','k','linewidth',2)
figure(3); pcolor(latx,airslays,10*all.ptemprate');      shading interp; colorbar; colormap jet; title('temp/decade  rates')
  caxis([-0.5 +0.5]); 
figure(4); pcolor(latx,airslays,10*all.waterrate'); shading interp; colorbar; colormap jet; title('frac_gas_1/decade rates')
  caxis([-0.1 +0.1]);
figure(5); pcolor(latx,airslays,10*all.ozonerate'); shading interp; colorbar; colormap jet; title('frac_gas_3/decade rates')
  caxis([-0.2 +0.2]);
for ii = 3 : 5
  figure(ii); set(gca,'ydir','reverse'); set(gca,'yscale','log'); colormap(usa2);
  axis([-90 +90 10 1000])
end

saver = ['save ' dirOUT '/all40latbins_profilerates.mat all'];
eval(saver);
