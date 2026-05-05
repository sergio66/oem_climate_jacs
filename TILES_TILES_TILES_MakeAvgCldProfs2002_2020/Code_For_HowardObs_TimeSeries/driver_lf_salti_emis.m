addpath /home/sergio/git/matlabcode/PLOTTER
addpath /home/sergio/git/matlabcode/COLORMAP
addpath /home/sergio/git/matlabcode/TIME
addpath /home/sergio/git/matlabcode/DEM_DigitalELeveationModel
addpath /home/sergio/git/rtpmake/CLUST_RTPMAKE/COMMON_SETTINGS/
addpath /home/sergio/git/matlabcode/matlibSergio/matlib/rtp_prod2_Aug11_2020/emis/

xgrid = -180 : 0.5 : +180;
ygrid = -090 : 0.5 : +090;
[Yg,Xg] = meshgrid(ygrid,xgrid);
Yg = Yg(:);
Xg = Xg(:);
p.rlon = Xg';
p.rlat = Yg';
p.rtime = ones(size(Xg')) * utc2taiSergio(2012,01,01,12);
p.satzen = ones(size(p.rlon)) * 22;
p.wspeed = ones(size(p.rlon)) * 10;

[p.salti,p.landfrac] = gdemm_dem_and_imerg_lf(p.rlat,p.rlon);
pa = {{'profiles','rtime','seconds since 1993'}};
add_the_DanZhou_emis

figure(1); colormap jet; scatter_coast(p.rlon,p.rlat,30,p.salti); title('salti');
figure(2); colormap jet; scatter_coast(p.rlon,p.rlat,30,p.landfrac); title('landfrac');
figure(3); colormap jet; scatter_coast(p.rlon,p.rlat,30,p.nemis); title('nemis');

figure(4); bad = find(isnan(p.salti));
if length(bad) > 0
  plot(p.rlon(bad),p.rlat(bad),'.');
  hold on;
    plot_coast
  hold off;
end
pause(0.1);


%%%%%%%%%%%%%%%%%%%%%%%%%
%%% <<< MAIN CODE    MAIN CODE    MAIN CODE    MAIN CODE    MAIN CODE >>>

do_XX_YY_from_X_Y

for jj = 1 : 64
  fprintf(1,'doing latbin %2i of 64 \n',jj);
  for ii = 1 : 72
    iX = ii + (jj-1)*72;
    [salti(iX),landfrac(iX),efreq(:,iX),emis(:,iX),rho(:,iX),nemis(iX)] = call_lf_salti_emiss(ii,jj);
    lat(iX) = rlat(jj);
    lon(iX) = rlon(ii);
  end
  moo900 = find(efreq(:,iX) >= 900,1);
  figure(1); colormap jet; scatter_coast(lon,lat,30,salti);          title('salti');
  figure(2); colormap jet; scatter_coast(lon,lat,30,landfrac);       title('landfrac');
  figure(3); colormap jet; scatter_coast(lon,lat,30,emis(moo900,:)); title('emis900');
  pause(1)
end

whos salti landfrac efreq emis rho nemis lat lon

comment = 'see /home/sergio/git/oem_climate_jacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries/driver_lf_salti_emis.m';
save tile_avg_salti_lf_emis.mat salti landfrac efreq emis rho nemis lat lon comment

%%% <<< MAIN CODE    MAIN CODE    MAIN CODE    MAIN CODE    MAIN CODE >>>
%%%%%%%%%%%%%%%%%%%%%%%%%

p.rlon = lon;
p.rlat = lat;
p.rtime = ones(size(Xg')) * utc2taiSergio(2012,01,01,12);
p.satzen = ones(size(p.rlon)) * 22;
p.wspeed = ones(size(p.rlon)) * 10;

[p.salti,p.landfrac] = gdemm_dem_and_imerg_lf(p.rlat,p.rlon);
pa = {{'profiles','rtime','seconds since 1993'}};
add_the_DanZhou_emis

ef100 = load('efreq100.mat');
for kkjunk = 1 : length(p.rlon)
  inde = 1:p.nemis(kkjunk);
  p.emis100(:,kkjunk) = interp1(double(p.efreq(inde,kkjunk)),double(p.emis(inde,kkjunk)),double(ef100.efreq100),[],'extrap');
end

figure(4); colormap jet; scatter_coast(p.rlon,p.rlat,30,p.salti);             title('salti');
figure(5); colormap jet; scatter_coast(p.rlon,p.rlat,30,p.landfrac);          title('landfrac');
figure(6); colormap jet; scatter_coast(p.rlon,p.rlat,30,p.nemis);             title('nemis');
figure(6); colormap jet; scatter_coast(p.rlon,p.rlat,30,p.emis100(moo900,:)); title('emis900');

figure(4); colormap jet; scatter_coast(p.rlon,p.rlat,30,salti./p.salti);                       caxis([-1 +1]*10);   title('salti (avg/center)');
figure(4); colormap jet; scatter_coast(p.rlon,p.rlat,30,salti-p.salti);                        caxis([-1 +1]*500);    title('salti (avg-center)'); colormap(usa2)
figure(5); colormap jet; scatter_coast(p.rlon,p.rlat,30,landfrac-p.landfrac);                  caxis([-0.05 +0.05]);  title('landfrac (avg-center)'); colormap(usa2)
figure(6); colormap jet; scatter_coast(p.rlon,p.rlat,30,emis(moo900,:)./p.emis100(moo900,:));  caxis([0.99 1.01]);    title('emis900 (avg/center)'); colormap(usa2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [salti,landfrac,efreq,emis,rho,nemis] = call_lf_salti_emiss(ii,jj)

do_XX_YY_from_X_Y

lon = rlon73(ii)+0.1;
lat = rlat65(jj)+0.1;

%% ii = chirp tile lonbin (1:72)
%% jj = chirp tile latbin (1:64)

salti = 0;
landfrac = 0;
efreq = zeros(1,100);
emis  = zeros(1,100);
rho   = zeros(1,100);
nemis = 0;

iX = ii + (jj-1)*72;

iPlot = -1;
[tile,tileX,tileY] = findtile_72x64_tiles_for_lonlat(lon,lat,iPlot);
if iPlot > 0
  title(num2str(tile))
  pause(0.1)
end

%% this is the bounding box
bb1 = [rlon73(ii)   rlat65(jj)  ];
bb2 = [rlon73(ii+1) rlat65(jj)  ];
bb3 = [rlon73(ii)   rlat65(jj+1)];
bb4 = [rlon73(ii+1) rlat65(jj+1)];
bb = [bb1; bb2; bb3; bb4];

xgrid = rlon73(ii) : 0.25 : rlon73(ii+1)-0.25;
ygrid = rlat65(jj) : 0.25 : rlat65(jj+1)-0.25;
[Yg,Xg] = meshgrid(ygrid,xgrid);
Yg = Yg(:);
Xg = Xg(:);
p.rlon = Xg';
p.rlat = Yg';
p.rtime = ones(size(Xg')) * utc2taiSergio(2012,01,01,12);
p.satzen = ones(size(p.rlon)) * 22;
p.wspeed = ones(size(p.rlon)) * 10;

[p.salti,p.landfrac] = gdemm_dem_and_imerg_lf(p.rlat,p.rlon);
pa = {{'profiles','rtime','seconds since 1993'}};
add_the_DanZhou_emis

iPlot = -1;
if iPlot > 0
  figure(1); colormap jet; scatter_coast(p.rlon,p.rlat,30,p.salti);    title('salti');
  figure(2); colormap jet; scatter_coast(p.rlon,p.rlat,30,p.landfrac); title('landfrac');
  figure(3); colormap jet; scatter_coast(p.rlon,p.rlat,30,p.nemis);    title('nemis');
  pause(0.1)
end

ef100 = load('efreq100.mat');
for kkjunk = 1 : length(p.rlon)
  inde = 1:p.nemis(kkjunk);
  emis100(:,kkjunk) = interp1(double(p.efreq(inde,kkjunk)),double(p.emis(inde,kkjunk)),double(ef100.efreq100),[],'extrap');
end

%%% equally weight all opints, no need for cosine weighting
salti    = nanmean(p.salti);
landfrac = nanmean(p.landfrac);
efreq    = ef100.efreq100;
emis     = nanmean(emis100,2);
rho      = (1-emis)/pi;
nemis    = 100;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

