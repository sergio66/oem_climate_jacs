addpath /asl/matlib/h4tools
addpath /asl/matlib/aslutil
addpath /asl/matlib/rtptools

iiBin = 21; %% tropical
iiBin = 6; %% mid lat
iiBin = 3;  %% polar

for ii = 1 : 365
  frp = ['AnomSym_no_seasonal/timestep_' num2str(ii,'%03d') '_16day_avg.rp.rtp'];
  [h,ha,p,pa] = rtpread(frp);
  [h,p] = subset_rtp(h,p,[],[],iiBin);
  if ii == 1
    h365 = h;
    p365 = p;
  else
    [h365,p365] = cat_rtp(h365,p365,h,p);
  end
end
plot(1:365,p365.stemp,1:365,smooth(p365.stemp,23),'r')   %% each timestep is 16 days, so 23 * 16 =    365
grid

sarta = '/home/chepplew/gitLib/sarta/bin/airs_l1c_2834_cloudy_may19';

if iiBin == 21
  str = 'tropical';
elseif iiBin == 3
  str = 'spolar';
elseif iiBin == 6
  str = 'smidlat';
end

rtpwrite(['make_365_anom_' str '_profs_for_sartaVSkcarta_radscomparison.op.rtp'],h365,ha,p365,pa);
%sartaer = ['!' sarta ' fin=../MakeJacsSARTA/make_365_anom_' str '_profs_for_sartaVSkcarta_radscomparison.op.rtp fout=../MakeJacsSARTA/make_365_anom_' str '_profs_for_sartaVSkcarta_radscomparison.rp.rtp'];
sartaer = ['!time ' sarta ' fin=make_365_anom_' str '_profs_for_sartaVSkcarta_radscomparison.op.rtp fout=make_365_anom_' str '_profs_for_sartaVSkcarta_radscomparison.rp.rtp'];
eval(sartaer);
%[hres,ha,pres,pa] = rtpread(['../MakeJacsSARTA/make_365_anom_' str '_profs_for_sartaVSkcarta_radscomparison.rp.rtp']);
[hres,ha,pres,pa] = rtpread(['make_365_anom_' str '_profs_for_sartaVSkcarta_radscomparison.rp.rtp']);

error('kjgskljsg')

if ~exist(['../MakeJacsSARTA/kcarta_365_' str '.mat'])
  iaFound = [];
  clear kcarta
  for ii = 1 : 365
    fkc = ['/home/sergio/KCARTA/WORK/RUN_TARA/GENERIC_RADSnJACS_MANYPROFILES/JUNK/individual_prof_convolved_kcarta_crisHI_' num2str(ii) '.mat'];
    if mod(ii,50) == 0
      fprintf(1,'.')
    end
    
    if exist(fkc)
      iaFound(ii) = +1;
      a = load(fkc);
      kcarta(ii,:) = a.rKc;
    else
      iaFound(ii) = 0;
      kcarta(ii,:) = zeros(2834,1);
    end
  end
  fprintf(1,'\n');
    
  kcarta = kcarta(:,1:2378);
  
  tsarta  = rad2bt(hres.vchan,pres.rcalc);
  tkcarta = rad2bt(hres.vchan,kcarta');
  saver = ['save kcarta_365_' str '.mat tsarta tkcarta'];
  eval(saver)
else
  loader = ['load  kcarta_365_' str '.mat'];
  eval(loader);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
plot(hres.vchan,nanmean(tsarta'-tkcarta'),hres.vchan,nanstd(tsarta'-tkcarta'))
axis([640 2780 -0.3 +0.3]); grid on
title('365 timesteps, tropical (latbin21)')
ylabel('\delta BT sarta-kcarta (K)'); hl = legend('mean','std','location','best');
axis([640 840 -0.3 +0.3]); grid on

plot(hres.vchan,tsarta(:,365)-tsarta(:,1),'b',hres.vchan,tkcarta(:,365)-tkcarta(:,1),'r')
axis([640 840 -3 +3])

plot(hres.vchan,(tsarta(:,365)-tsarta(:,1)) - (tkcarta(:,365)-tkcarta(:,1)),'r')
axis([640 840 -3 +3])


addpath /home/sergio/MATLABCODE/COLORMAP
pcolor(hres.vchan,1:365,tsarta'-tkcarta'); shading interp; colormap(usa2); colorbar
title('365 timesteps, tropical (latbin21)')
caxis([-0.2 +0.2]);
xlabel('Wavenumber cm-1'); ylabel('Timestep'); axis([640 840 1 365]); grid on

pcolor(hres.vchan,1:364,diff(tsarta'-tkcarta')); shading interp; colormap(usa2); colorbar
title('365 timesteps, diff(tropical (latbin21))')
caxis([-0.02 +0.02]);
xlabel('Wavenumber cm-1'); ylabel('Timestep'); axis([640 840 1 365]); grid on
