for JOBB = 1 : 72*64
  latbin = floor((JOBB-1)/72)+1;
  lonbin = JOBB - 72*(latbin-1);
  fprintf(1,'%4i %2i %2i \n',JOBB,latbin,lonbin)
  fout = ['DATA/LatBin' num2str(latbin,'%02i') '/summary_trends_latbin_' num2str(latbin,'%02i') '_lonbin_' num2str(lonbin,'%02i') '.mat'];
  clear x
  if exist(fout)  
    loader = ['x = load(''' fout ''');'];
    eval(loader)

    trend.stemp(JOBB) = x.stemp;
    trend.ptemp(:,JOBB) = x.ptemp;
    trend.gas_1(:,JOBB) = x.gas_1;
    trend.gas_3(:,JOBB) = x.gas_3;
    trend.stemp_err(JOBB) = x.stemp_err;
    trend.ptemp_err(:,JOBB) = x.ptemp_err;
    trend.gas_1_err(:,JOBB) = x.gas_1_err;
    trend.gas_3_err(:,JOBB) = x.gas_3_err;

    trend.btobs(:,JOBB) = x.btobs;
    trend.btclr(:,JOBB) = x.btclr;
    trend.btcld(:,JOBB) = x.btcld;
    trend.btobs_err(:,JOBB) = x.btobs_err;
    trend.btclr_err(:,JOBB) = x.btclr_err;
    trend.btcld_err(:,JOBB) = x.btcld_err;

    trend.icecngwat(JOBB) = x.icecngwat;
    trend.iceOD(JOBB) = x.iceOD;
    trend.icetop(JOBB) = x.icetop;
    trend.icesze(JOBB) = x.icesze;
    trend.icecngwat_err(JOBB) = x.icecngwat_err;
    trend.iceOD_err(JOBB) = x.iceOD_err;
    trend.icetop_err(JOBB) = x.icetop_err;
    trend.icesze_err(JOBB) = x.icesze_err;

    trend.watercngwat(JOBB) = x.watercngwat;
    trend.waterOD(JOBB) = x.waterOD;
    trend.watertop(JOBB) = x.watertop;
    trend.watersze(JOBB) = x.watersze;
    trend.watercngwat_err(JOBB) = x.watercngwat_err;
    trend.waterOD_err(JOBB) = x.waterOD_err;
    trend.watertop_err(JOBB) = x.watertop_err;
    trend.watersze_err(JOBB) = x.watersze_err;

  end
end

addpath /home/sergio/MATLABCODE/COLORMAP
addpath /home/sergio/MATLABCODE/PLOTTER

clear x
trend

%{
save trends_era_calcs_profiles.mat trend
%}

%{
kc = load('/asl/s1/sergio/rtp/MakeAvgProfs2002_2020/Retrieval/LatBin65/SubsetJacLatbin/kcarta_subjacLatBin32.mat');
sa = load('/asl/s1/sergio/rtp/MakeAvgProfs2002_2020/Retrieval/LatBin65/SubsetJacLatbin/subjacLatBin32.mat');
kcc = nanmean(kc.subjac.jacST,2);
saa = nanmean(sa.subjac.jacST,2);
plot(1:2645,kcc,1:2645,saa)
xlim([2160 2260])
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load /home/motteler/shome/obs_stats/airs_tiling/latB64.mat
rlon = -180 : 5 : +180;  rlat = latB2;
rlon = 0.5*(rlon(1:end-1)+rlon(2:end));
rlat = 0.5*(rlat(1:end-1)+rlat(2:end));
[Y,X] = meshgrid(rlat,rlon);
X = X; Y = Y;

plevs = load('/home/sergio/MATLABCODE/airslevels.dat');
playsN = plevs(1:100)-plevs(2:101);
playsD = log(plevs(1:100)./plevs(2:101));
plays = playsN./playsD;
plays = flipud(plays);
for ii = 1 : 20
  iavg = (1:5) + (ii-1)*5;
  pavg(ii) = mean(plays(iavg));
end

len = length(trend.stemp);
ptemprate = ones(20,64*72)*NaN;
gas_1rate = ones(20,64*72)*NaN;
gas_3rate = ones(20,64*72)*NaN;
for ii = 1 : 20
  moo = (1:5) + (ii-1)*5;
  ptemprate(ii,1:len) = nanmean(trend.ptemp(moo,:),1);
  gas_1rate(ii,1:len) = nanmean(trend.gas_1(moo,:),1);
  gas_3rate(ii,1:len) = nanmean(trend.gas_3(moo,:),1);
end

figure(1);
woo = ones(1,64*72)*NaN; woo(1:1:length(trend.stemp)) = trend.stemp;
pcolor(reshape(woo,72,64)'); shading flat; colormap jet; title('ERA stemp trend'); colorbar; caxis([-0.2 +0.2]); colormap(usa2); 
stemprate = reshape(woo,72,64);
scatter_coast(X(:),Y(:),50,stemprate(:)); shading flat; colormap jet; title('ERA stemp trend'); colorbar; caxis([-0.2 +0.2]); colormap(usa2); 

figure(2);
ptempX = reshape(ptemprate,20,72,64);
pcolor(rlat,pavg,squeeze(nanmean(ptempX,2))); shading interp; colorbar; caxis([-0.05 +0.05]); colormap(usa2);
set(gca,'ydir','reverse'); set(gca,'yscale','log'); ylim([10 1000]); title('ERA T(z) trend')

figure(3);
gas_1X = reshape(gas_1rate,20,72,64);
pcolor(rlat,pavg,squeeze(nanmean(gas_1X,2))); shading interp; colorbar; caxis([-0.01 +0.01]); colormap(usa2);
set(gca,'ydir','reverse'); set(gca,'yscale','log'); ylim([10 1000]); title('ERA WV(z) trend')

figure(4);
gas_3X = reshape(gas_3rate,20,72,64);
pcolor(rlat,pavg,squeeze(nanmean(gas_3X,2))); shading interp; colorbar; caxis([-0.05 +0.05]); colormap(usa2);
set(gca,'ydir','reverse'); set(gca,'yscale','log'); ylim([10 1000]); title('ERA O3(z) trend')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
lls4 = load('llsmap4');
lls4.llsmap4 = lls4.llsmap4(2:end,:);

%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2);
ptempX = reshape(ptemprate,20,72,64);
pcolor(rlat,pavg,squeeze(nanmean(ptempX,2))); shading interp; colorbar; caxis([-0.05 +0.05]); colormap(lls4.llsmap4);
set(gca,'ydir','reverse'); set(gca,'yscale','log'); ylim([10 1000]); 
ylabel('Pressure (mb)'); xlabel('Latitude');

figure(3);
gas_1X = reshape(gas_1rate,20,72,64);
pcolor(rlat,pavg,squeeze(nanmean(gas_1X,2))); shading interp; colorbar; caxis([-0.01 +0.01]); colormap(lls4.llsmap4);
set(gca,'ydir','reverse'); set(gca,'yscale','log'); ylim([10 1000]); 
ylabel('Pressure (mb)'); xlabel('Latitude');

figure(4);
gas_3X = reshape(gas_3rate,20,72,64);
pcolor(rlat,pavg,squeeze(nanmean(gas_3X,2))); shading interp; colorbar; caxis([-0.05 +0.05]); colormap(lls4.llsmap4);
set(gca,'ydir','reverse'); set(gca,'yscale','log'); ylim([10 1000]); 
ylabel('Pressure (mb)'); xlabel('Latitude');

addpath /asl/matlib/plotutils
figure(2); aslprint('/home/sergio/PAPERS/AIRS/AIRS_STM_Oct2020/GriddedRetrievals/Figs/era_trends_Tz_vs_lat.pdf');
figure(3); aslprint('/home/sergio/PAPERS/AIRS/AIRS_STM_Oct2020/GriddedRetrievals/Figs/era_trends_WVz_vs_lat.pdf');
figure(4); aslprint('/home/sergio/PAPERS/AIRS/AIRS_STM_Oct2020/GriddedRetrievals/Figs/era_trends_O3z_vs_lat.pdf');

%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2);
ptempX = reshape(ptemprate,20,72,64);
pcolor(rlat,pavg,squeeze(nanmean(ptempX,2))); shading flat; colorbar; caxis([-0.05 +0.05]); colormap(lls4.llsmap4);
set(gca,'ydir','reverse'); set(gca,'yscale','log'); ylim([10 1000]); 
ylabel('Pressure (mb)'); xlabel('Latitude');

figure(3);
gas_1X = reshape(gas_1rate,20,72,64);
pcolor(rlat,pavg,squeeze(nanmean(gas_1X,2))); shading flat; colorbar; caxis([-0.01 +0.01]); colormap(lls4.llsmap4);
set(gca,'ydir','reverse'); set(gca,'yscale','log'); ylim([10 1000]); 
ylabel('Pressure (mb)'); xlabel('Latitude');

figure(4);
gas_3X = reshape(gas_3rate,20,72,64);
pcolor(rlat,pavg,squeeze(nanmean(gas_3X,2))); shading flat; colorbar; caxis([-0.05 +0.05]); colormap(lls4.llsmap4);
set(gca,'ydir','reverse'); set(gca,'yscale','log'); ylim([10 1000]); 
ylabel('Pressure (mb)'); xlabel('Latitude');

addpath /asl/matlib/plotutils
figure(2); aslprint('/home/sergio/PAPERS/AIRS/AIRS_STM_Oct2020/GriddedRetrievals/Figs/eraX_trends_Tz_vs_lat.pdf');
figure(3); aslprint('/home/sergio/PAPERS/AIRS/AIRS_STM_Oct2020/GriddedRetrievals/Figs/eraX_trends_WVz_vs_lat.pdf');
figure(4); aslprint('/home/sergio/PAPERS/AIRS/AIRS_STM_Oct2020/GriddedRetrievals/Figs/eraX_trends_O3z_vs_lat.pdf');
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% save_calcs_trends
