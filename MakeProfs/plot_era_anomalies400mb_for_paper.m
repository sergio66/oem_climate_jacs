cd /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/MakeProfs/

llsmap4 = load('//home/sergio/MATLABCODE/COLORMAP/llsmap4.mat'); colormap(llsmap4.llsmap4);
plevs = load('/home/sergio/MATLABCODE/airslevels.dat');
playsN = plevs(1:end-1)-plevs(2:end);
playsD = log(plevs(1:end-1)./plevs(2:end));
plays = playsN./playsD;
plays = flipud(plays);

addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/COLORMAP
iaLat = equal_area_spherical_bands(20);
iaLatx = (iaLat(1:end-1) + iaLat(2:end))*0.5;

alltropics = find(abs(iaLatx) <= 30);
ntrp       = find(iaLatx >= 27 & iaLatx <= 30);

iWhich = +1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if iWhich == 0
  tropics == alltropics;
else
  tropics = ntrp;
end

tropics = 1 : 40;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iCldOrClr = -1; iLatMin = 3; iLatMax = 40;  %% clear
iCldOrClr = +1; iLatMin = 1; iLatMax = 40;  %% cloudy

iCldOrClr = input('Enter iCldOrClr (-1 for Default Clr, +1 for Cld) : ');
if length(iCldOrClr) == 0
  iCldOrClr = -1;
end
if iCldOrClr == -1
  ; iLatMin = 3; iLatMax = 40;  %% clear
elseif iCldOrClr == +1
  iLatMin = 1; iLatMax = 40;  %% cloudy
end

xtime = (2002+9/12) + ((1:365)-1)*16/365;

stempanom = zeros(40,365);
ptempanom = zeros(40,98,365);
wvanom = zeros(40,98,365);
o3anom = zeros(40,98,365);

if iCldOrClr > 0
  load('/home/sergio/MATLABCODE/oem_pkg_run/AIRS_new_random_scan_August2019/ak40latbin_rates.mat');
else
  wah = load('/home/sergio/MATLABCODE/oem_pkg_run/AIRS_new_clear_scan_August2019/ak40latbin_rates.mat');
  %% see ~/MATLABCODE/oem_pkg_run/AIRS_new_clear_scan_August2019/Plotutils/show_AIRSL3_rates_ak_fewlays  
  for ii = 1 : 40
    junk1 = squeeze(wah.tz_ak40(ii,:,:));
    %junk2 = interp2(log10(wah.playsRET),log10(wah.playsRET),junk1,log10(plays(1:97)),log10(plays(1:97)),'linear',0.0);
    [xx,yy] = meshgrid(log10(plays(1:97)),log10(plays(1:97)));
    junk2 = interp2(log10(wah.playsRET),log10(wah.playsRET),junk1,xx,yy,'linear',0.0);
    junk2 = interp2(log10(wah.playsRET),log10(wah.playsRET),junk1,xx,yy,'spline',0.0);
    junk2(isnan(junk2)) = 0.0; 
    junk2(isinf(junk2)) = 0.0; 
    tz_ak40(ii,:,:) = junk2;

    if ii == 20
      figure(1); pcolor(log10(wah.playsRET),log10(wah.playsRET),junk1); colorbar; shading interp
      figure(2); pcolor(xx,yy,junk2); colorbar; shading interp
      disp('ret'); pause
    end
    
    junk1 = squeeze(wah.wv_ak40(ii,:,:));
    %junk2 = interp2(log10(wah.playsRET),log10(wah.playsRET),junk1,log10(plays(1:97)),log10(plays(1:97)),'linear',0.0);
    [xx,yy] = meshgrid(log10(plays(1:97)),log10(plays(1:97)));
    junk2 = interp2(log10(wah.playsRET),log10(wah.playsRET),junk1,xx,yy,'linear',0.0);
    junk2 = interp2(log10(wah.playsRET),log10(wah.playsRET),junk1,xx,yy,'spline',0.0);
    junk2(isnan(junk2)) = 0.0; 
    junk2(isinf(junk2)) = 0.0; 
    wv_ak40(ii,:,:) = junk2;

    junk1 = squeeze(wah.o3_ak40(ii,:,:));
    %junk2 = interp2(log10(wah.playsRET),log10(wah.playsRET),junk1,log10(plays(1:97)),log10(plays(1:97)),'linear',0.0);
    [xx,yy] = meshgrid(log10(plays(1:97)),log10(plays(1:97)));
    junk2 = interp2(log10(wah.playsRET),log10(wah.playsRET),junk1,xx,yy,'linear',0.0);
    junk2 = interp2(log10(wah.playsRET),log10(wah.playsRET),junk1,xx,yy,'spline',0.0);
    junk2(isnan(junk2)) = 0.0; 
    junk2(isinf(junk2)) = 0.0; 
    o3_ak40(ii,:,:) = junk2;
  end
end
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iAK = input('do not use AK (-1, default) or use AK (+1) : ');
if length(iAK) == 0
  iAK = -1;
end

for iLat = iLatMin : iLatMax
  if iCldOrClr > 0
    load(['LATS40_avg_made_Aug22_2019_Cld/Desc_ocean/16DayAvgNoS_withanom/latbin' num2str(iLat) '_16day_avg.rp.mat']);
  else
    load(['LATS40_avg_made_Aug20_2019_Clr/Desc/16DayAvgNoS_withanom/latbin' num2str(iLat) '_16day_avg.rp.mat']);  
    %load(['LATS40_avg_made_Mar29_2019_Clr/Desc/16DayAvgNoS_withanom/latbin' num2str(iLat) '_16day_avg.rp.mat']);  
  end

  clear boink; boink = smooth(p16anomaly.stempanomaly,24,'loess');
  stempanom(iLat,:) = boink;

  clear boink
  for ii = 1 : 98; boink(ii,:) = smooth(p16anomaly.ptempanomaly(ii,:),24,'loess'); end
  for ii = 1 : 98; boink(ii,:) = smooth(p16anomaly.ptempanomaly(ii,:),2*5); end
  for ii = 1 : 98; boink(ii,:) = p16anomaly.ptempanomaly(ii,:); end
  akx97 = squeeze(tz_ak40(iLat,:,:));  akx98 = zeros(98,98); akx98(1:97,1:97) = akx97;
  %if iCldOrClr < 0
  %  akx98 = eye(length(akx98));
  %end
  if iAK < 0
    akx98 = zeros(98,98);; akx98 = eye(length(akx98));
  end
  ptempanom(iLat,:,:) = akx98*boink;

  clear boink
  for ii = 1 : 98; boink(ii,:) = smooth(p16anomaly.gas_1anomalyfrac(ii,:),24,'loess'); end
  for ii = 1 : 98; boink(ii,:) = smooth(p16anomaly.gas_1anomalyfrac(ii,:),2*5); end
  for ii = 1 : 98; boink(ii,:) = p16anomaly.gas_1anomalyfrac(ii,:); end
  akx97 = squeeze(wv_ak40(iLat,:,:));  akx98 = zeros(98,98); akx98(1:97,1:97) = akx97;
  %if iCldOrClr < 0
  %  akx98 = eye(length(akx98));
  %end
  if iAK < 0
    akx98 = zeros(98,98); akx98 = eye(length(akx98));
  end
  wvanom(iLat,:,:) = akx98*boink;

  clear boink
  for ii = 1 : 98; boink(ii,:) = smooth(p16anomaly.gas_3anomalyfrac(ii,:),24,'loess'); end
  for ii = 1 : 98; boink(ii,:) = smooth(p16anomaly.gas_3anomalyfrac(ii,:),2*5); end
  for ii = 1 : 98; boink(ii,:) = p16anomaly.gas_3anomalyfrac(ii,:); end
  akx97 = squeeze(o3_ak40(iLat,:,:));  akx98 = zeros(98,98); akx98(1:97,1:97) = akx97;
  %if iCldOrClr < 0
  %  akx98 = eye(length(akx98));
  %end
  if iAK < 0
    akx98 = zeros(98,98); akx98 = eye(length(akx98));
  end
  o3anom(iLat,:,:) = akx98*boink;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i400 = find(plays >= 400,1);
i400 = i400-2:i400+2;  %% this is about 5 layers around 400 mb

addpath /home/sergio/MATLABCODE/PLOTTER
latbinsx = equal_area_spherical_bands(20);
latbins = 0.5*(latbinsx(1:end-1) + latbinsx(2:end));

figure(1); 
xx = squeeze(ptempanom(:,i400,:));
if length(tropics) > 1
  xx = squeeze(nanmean(xx,2));
else
  xx = squeeze(xx);
end
pcolor(xtime,latbins,xx); shading interp; 
  set(gca,'ydir','reverse'); colormap(llsmap4.llsmap4); caxis([-1 +1]); colorbar
title('T(lat,time) anomaly smoothed over 0.5 year');

figure(2); 
xx = squeeze(wvanom(:,i400,:));
if length(tropics) > 1
  xx = squeeze(nanmean(xx,2));
else
  xx = squeeze(xx);
end
pcolor(xtime,latbins,xx); shading interp; 
  set(gca,'ydir','reverse'); colormap(llsmap4.llsmap4); caxis([-0.2 +0.2]); colorbar
title('fracWV(lat,time) anomaly smoothed over 0.5 year');

figure(3); 
xx = squeeze(o3anom(:,i400,:));
if length(tropics) > 1
  xx = squeeze(nanmean(xx,2));
else
  xx = squeeze(xx);
end
pcolor(xtime,latbins,xx); shading interp; 
  set(gca,'ydir','reverse'); colormap(llsmap4.llsmap4); caxis([-0.2 +0.2]); colorbar
title('T=fracO3(lat,time) anomaly anomaly smoothed over 0.5 year');

for ii = 1 : 1
  figure(ii)
  shading interp;
   llsmap4 = load('//home/sergio/MATLABCODE/COLORMAP/llsmap4.mat'); colormap(llsmap4.llsmap4); caxis([-1 +1]); colorbar
  axis([2002.75 2018.75 -80 +80]); xlabel('time'); ylabel('lat')
end
for ii = 2 : 2
  figure(ii)
  shading interp;
   llsmap4 = load('//home/sergio/MATLABCODE/COLORMAP/llsmap4.mat'); colormap(llsmap4.llsmap4); caxis([-0.2 +0.2]); colorbar
  axis([2002.75 2018.75 -80 +80]); xlabel('time'); ylabel('lat')
end
for ii = 3 : 3
  figure(ii)
  shading interp;
   llsmap4 = load('//home/sergio/MATLABCODE/COLORMAP/llsmap4.mat'); colormap(llsmap4.llsmap4);; caxis([-0.2 +0.2]); colorbar
  axis([2002.75 2018.75 -80 +80]); xlabel('time'); ylabel('lat')
end

error('ooh')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
iPrint = -1;
iPrint = +1;
iPrint = input('print (-1/+1)  -1 = default : ');
if length(iPrint) == 0
  iPrint = -1;
end

if iPrint > 0
  addpath /asl/matlib/plotutils/
  addpath /home/sergio/MATLABCODE/PLOTTER
  
  xtime = (2002+9/12) + ((1:365)-1)*16/365;
  
  figure(1);
  xx = squeeze(ptempanom(tropics,:,:));
  xt = squeeze(nanmean(xx,1));
  xt = xx;
  pcolor(xtime,plays(1:98),xt); shading interp; 
    set(gca,'ydir','reverse'); colormap(llsmap4.llsmap4); caxis([-1 +1]); colorbar
  set(gca,'yscale','log'); axis([2002.75 2018.75 1 1000]); xlabel('time'); ylabel('P(mb)')
  %title('T(z,time) anomaly,\newline smoothed over one year');
  
  figure(2); 
  xx = squeeze(wvanom(tropics,:,:));
  xwv = squeeze(nanmean(xx,1));
  xwv = xx;
  pcolor(xtime,plays(1:98),xwv); shading interp; 
    set(gca,'ydir','reverse'); colormap(llsmap4.llsmap4); caxis([-0.2 +0.2]); colorbar
  set(gca,'yscale','log'); axis([2002.75 2018.75 1 1000]); xlabel('time'); ylabel('P(mb)')
  %title('fracWV(z,time) anomaly,\newline smoothed over one year');
  
  figure(3); 
  xx = squeeze(o3anom(tropics,:,:));
  xo3 = squeeze(nanmean(xx,1));
  xo3 = xx;
  pcolor(xtime,plays(1:98),xo3); shading interp; 
    set(gca,'ydir','reverse'); colormap(llsmap4.llsmap4); caxis([-0.2 +0.2]); colorbar
  set(gca,'yscale','log'); axis([2002.75 2018.75 1 1000]); xlabel('time'); ylabel('P(mb)')
  %title('fracO3(z,time) anomaly,\newline smoothed over one year');
  
  for ii = 1 : 3
    figure(ii); colormap(usa2);
    set(gca,'YTick',[1 10,100,1000])
    set(gca,'YTickLabel',{'1','10','100','1000'})
  end

  figure(4); plot(xtime,mean(stempanom(tropics,:))); 
  axis([2002.75 2018.75 -0.8 +0.8]); xlabel('time'); ylabel('SurfTemp(K)')
  %title('Stemp Anom,\newline smoothed over one year');

  if iWhich == 0  
    if iCldOrClr < 0
      figure(1); aslprint_mat('/home/sergio/PAPERS/AIRS/AIRS_STM_Sep19/Figs/ClearAnom/era_clr_ptemp_anom_200209_201808',[],1,xtime,plays(1:98),xt);
      figure(2); aslprint_mat('/home/sergio/PAPERS/AIRS/AIRS_STM_Sep19/Figs/ClearAnom/era_clr_wv_anom_200209_201808',[],1,xtime,plays(1:98),xwv);
      figure(3); aslprint_mat('/home/sergio/PAPERS/AIRS/AIRS_STM_Sep19/Figs/ClearAnom/era_clr_o3_anom_200209_201808',[],1,xtime,plays(1:98),xo3);
      figure(4); aslprint_mat('/home/sergio/PAPERS/AIRS/AIRS_STM_Sep19/Figs/ClearAnom/era_clr_stemp_anom_200209_201808.pdf');
    else
      figure(1); aslprint_mat('/home/sergio/PAPERS/AIRS/airs_stm_sep19/allsky/Figs/CloudAnom/Desc_ocean/ak_x_era_cld_ptemp_anom_200209_201808',[],1,xtime,plays(1:98),xt);
      figure(2); aslprint_mat('/home/sergio/PAPERS/AIRS/airs_stm_sep19/allsky/Figs/CloudAnom/Desc_ocean/ak_x_era_cld_wv_anom_200209_201808',[],1,xtime,plays(1:98),xwv);
      figure(3); aslprint_mat('/home/sergio/PAPERS/AIRS/airs_stm_sep19/allsky/Figs/CloudAnom/Desc_ocean/ak_x_era_cld_o3_anom_200209_201808',[],1,xtime,plays(1:98),xo3);
      figure(4); aslprint_mat('/home/sergio/PAPERS/AIRS/airs_stm_sep19/allsky/Figs/CloudAnom/Desc_ocean/ak_x_era_cld_stemp_anom_200209_201808.pdf');
    end
  elseif iWhich == 1
    if iCldOrClr < 0
      figure(1); aslprint_mat('/home/sergio/PAPERS/AIRS/AIRS_STM_Sep19/Figs/ClearAnom/ntropics27_era_clr_ptemp_anom_200209_201808',[],1,xtime,plays(1:98),xt);
      figure(2); aslprint_mat('/home/sergio/PAPERS/AIRS/AIRS_STM_Sep19/Figs/ClearAnom/ntropics27_era_clr_wv_anom_200209_201808',[],1,xtime,plays(1:98),xwv);
      figure(3); aslprint_mat('/home/sergio/PAPERS/AIRS/AIRS_STM_Sep19/Figs/ClearAnom/ntropics27_era_clr_o3_anom_200209_201808',[],1,xtime,plays(1:98),xo3);
      figure(4); aslprint_mat('/home/sergio/PAPERS/AIRS/AIRS_STM_Sep19/Figs/ClearAnom/ntropics27_era_clr_stemp_anom_200209_201808.pdf');
    else
      figure(1); aslprint_mat('/home/sergio/PAPERS/AIRS/airs_stm_sep19/allsky/Figs/CloudAnom/Desc_ocean/ak_x_ntropics27_era_cld_ptemp_anom_200209_201808',[],1,xtime,plays(1:98),xt);
      figure(2); aslprint_mat('/home/sergio/PAPERS/AIRS/airs_stm_sep19/allsky/Figs/CloudAnom/Desc_ocean/ak_x_ntropics27_era_cld_wv_anom_200209_201808',[],1,xtime,plays(1:98),xwv);
      figure(3); aslprint_mat('/home/sergio/PAPERS/AIRS/airs_stm_sep19/allsky/Figs/CloudAnom/Desc_ocean/ak_x_ntropics27_era_cld_o3_anom_200209_201808',[],1,xtime,plays(1:98),xo3);
      figure(4); aslprint_mat('/home/sergio/PAPERS/AIRS/airs_stm_sep19/allsky/Figs/CloudAnom/Desc_ocean/ak_x_ntropics27_era_cld_stemp_anom_200209_201808.pdf');
    end
  end
end
