addpath /home/sergio/MATLABCODE/COLORMAP

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

figure(1);  errorbar(1:40,all.stemprate,all.stempratestd); title('stemp')
figure(2);  errorbar(1:40,all.mmwrate,all.mmwratestd); title('mmw')
figure(3); pcolor(all.ptemprate');      shading flat; colorbar; colormap jet; title('ptemp rates')
figure(4); pcolor(all.waterrate'); shading flat; colorbar; colormap jet; title('frac_gas_1 rates')
figure(5); pcolor(all.ozonerate'); shading flat; colorbar; colormap jet; title('frac_gas_3 rates')

for ii = 3 : 5
  figure(ii); set(gca,'ydir','reverse'); colormap(usa2);
end

saver = ['save ' dirOUT '/all40latbins_profilerates.mat all'];
eval(saver);
