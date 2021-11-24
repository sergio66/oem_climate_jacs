set_dirIN_dirOUT

iaFound = zeros(1,40);
for ii = 1 : 40
  fin = [dirOUT '/latbin' num2str(ii) '_rates.mat'];
  if exist(fin)
    iaFound(ii) = 1;
  end
end
oo = find(iaFound == 0)

junk = load('/home/sergio/MATLABCODE/ROSES_2013_GRANT/NewClearPDFs/era_geo_rates_allsky_AIRIBRAD.mat');
for ii = 1 : 40
  fin = [dirOUT '/latbin' num2str(ii) '_rates.mat'];
  if exist(fin)
    str = ['a = load(''' fin ''');'];
    eval(str)
    thestats.waterrate(ii,:) = a.rate.frac_gas_1;
    thestats.waterratestd(ii,:) = a.rate.frac_gas_1_err;
    thestats.ozonerate(ii,:) = a.rate.frac_gas_3;
    thestats.ozoneratestd(ii,:) = a.rate.frac_gas_3_err;
    thestats.ptemprate(ii,:) = a.rate.ptemp;
    thestats.ptempratestd(ii,:) = a.rate.ptemp_err;
    thestats.stemprate(ii) = a.rate.stemp;
    thestats.stempratestd(ii) = a.rate.stemp_err;    

    if isfield(a.rate,'mmw')
      thestats.mmwrate(ii) = a.rate.mmw;
      thestats.mmwratestd(ii) = a.rate.mmw_err;    
    end
  end
end

thestats.lats = junk.thestats.lats;
airslevels = flipud(junk.airslevels);
latx = junk.latx;
airslevels = junk.airslevels(1:98);
pN = airslevels(1:end-1)-airslevels(2:end);
pD = log(airslevels(1:end-1)./airslevels(2:end));
airslays = pN./pD;
airslays = airslays(1:97);

figure(1); errorbar(thestats.lats,thestats.stemprate,thestats.stempratestd); title('Stemp K/yr'); grid
figure(2); pcolor(latx,airslays,10*thestats.waterrate'); set(gca,'yscale','log'); set(gca,'ydir','reverse'); title('Water frac/decade');
  caxis([-0.1 +0.1]);
figure(3); pcolor(latx,airslays,10*thestats.ozonerate'); set(gca,'yscale','log'); set(gca,'ydir','reverse'); title('Ozone frac/decade');
  caxis([-0.2 +0.2]);
figure(4); pcolor(latx,airslays,10*thestats.ptemprate'); set(gca,'yscale','log'); set(gca,'ydir','reverse'); title('Temp K/decade');
  caxis([-0.5 +0.5]);
for ii = 2 : 4; figure(ii); shading interp; axis([-90 +90 10 1000]); colorbar; end

fsave = [dirOUT '/all_latbins_rates.mat'];
saver = ['save ' fsave ' airslevels airslays latx thestats'];
eval(saver)
