addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/NANROUTINES
addpath /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/StrowCodeforTrendsAndAnomalies
addpath /asl/matlib/aslutil

%% see /umbc/xfs2/strow/asl/s1/sergio/home/MATLABCODE_Git/PLOTTER/plot_72x64_tiles.m
india = [1434 2419 2491 2716 2787 2788 2859 2860 2392 3004];
india = [2716 2787 2788 2859 2860];
india = [[2571:2573] [2643:2645] [2715:2717] [2787:2789]];
india = [[2571:2573] [2643:2645] [2715:2717] [2787:2789] [2859:2862] [2929:2935] [3000:3008]];
india = [[2571:2573] [2643:2645] [2715:2717] [2787:2789] [2859:2862] [2931:2934]];
india = [[2571:2573] [2643:2645] [2715:2717] [2787:2789] [2859:2862] [2931:2934] [3004 3076]];

india = [2716 2788 2860];
colormap jet; plot_72x64_tiles(india);

%% siberia warming in 
siberia = [4293:4300];
siberia = [[4293:4308]-3*72 [4293:4308]-2*72 [4293:4308]-1*72  [4293:4308]+0   [4293:4308]+72];
siberia = [4293-3*72   4293-2*72  4293-1*72  4293-0*72 4293+1*72];
siberia = [4285:4294];
colormap jet; plot_72x64_tiles(siberia);

%% hunga-tonga               = [20.5700 S, 175.3800 W] = findtile_72x64_tiles_for_lonlat(-175,-20.6); = 1729
%% try east flow hunga-tonga = [20.5700 S, 175.3800 E] = findtile_72x64_tiles_for_lonlat(+174,-20.6); = 1799
hoto = 1729; 
hoto = 1799; 
colormap jet; plot_72x64_tiles(hoto);

%% from /home/sergio/MATLABCODE/oem_pkg_run/FIND_NWP_MODEL_TRENDS/prep_colWV_T_WV_trends_Day_vs_Night.m
dirERA5 = '/home/sergio/MATLABCODE/oem_pkg_run/FIND_NWP_MODEL_TRENDS/';
era5_day_file    = [dirERA5 'ERA5_atm_N_cld_data_2002_09_to_2022_08_trends_asc.mat'];
era5_night_file  = [dirERA5 'ERA5_atm_N_cld_data_2002_09_to_2022_08_trends_desc.mat'];
fERA5_night = load(era5_night_file,'trend_stemp');
fERA5_day   = load(era5_day_file,'trend_stemp');
[~,I] = sort(fERA5_day.trend_stemp,'descend');
plot(fERA5_day.trend_stemp(I),'.'); plotaxis2;
scatter(1:4608,fERA5_day.trend_stemp(I),50,ceil(I/72),'filled'); colorbar; colormap jet
scatter(1:4608,fERA5_day.trend_stemp(I),50,I,'filled'); colorbar; colormap jet

pcolor(reshape(fERA5_day.trend_stemp,72,64)'); caxis([-1 +1]*0.15); colormap(usa2); colorbar; shading interp
hottest = I(9); 
hottest = 4227 : 4250; 
hottest = 4227 : 4248; 
plot_72x64_tiles(hottest);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load h2645structure.mat

chans38 = [        41          54         181         273         317         359         445         449 ...
                  532         758         903         904        1000        1020        1034        1055 ...
                 1075        1103        1249        1282        1291        1447        1475        1557 ...
                 1604        1614        1618        1660        1790        1866        1867        1868 ...
                 1878        1888        2112        2140        2321        2333];
chans41 = [chans38 2325        2339        2353]; chans41 = sort(chans41);
[Y,~,inds41] = intersect(chans41,h.ichan);
arr = [inds41'; h.ichan(inds41)'; h.vchan(inds41)']; whos arr; 
freqs41 =  h.vchan(inds41);

disp('chans41  h.ichan    h.vchan')
disp('---------------------------')
printarray(arr')
disp('---------------------------')

if ~exist('radA')
  iNumTimeSteps = 487;
  radA = nan(4608,iNumTimeSteps,41,5);
  radD = nan(4608,iNumTimeSteps,41,5);
  
  fdir0 = '/home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/DATAObsStats_StartSept2002_CORRECT_LatLon/';
  iCnt = 0;
  for jj = 1 : 64
    for ii = 1 : 72
      if mod(ii,10) == 0
        fprintf(1,'+');
      else
        fprintf(1,'.');
      end
      iCnt = iCnt + 1;
      fname = [fdir0 '/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/iQAX_3_summarystats_LatBin' num2str(jj,'%02i') '_LonBin' num2str(ii,'%02i') '_timesetps_001_457_V1.mat'];  %% 2002/09-2022/08
      fname = [fdir0 '/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/iQAX_3_summarystats_LatBin' num2str(jj,'%02i') '_LonBin' num2str(ii,'%02i') '_timesetps_001_479_V1.mat'];  %% 2002/09-2023/08
      fname = [fdir0 '/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/iQAX_3_summarystats_LatBin' num2str(jj,'%02i') '_LonBin' num2str(ii,'%02i') '_timesetps_001_487_V1.mat'];  %% 2002/09-2023/12
      a = load(fname);
      radA(iCnt,:,:,:) = squeeze(a.rad_quantile_asc(:,inds41,:));
      radD(iCnt,:,:,:) = squeeze(a.rad_quantile_desc(:,inds41,:));
    end
    fprintf(1,' %2i of 64 \n',jj);
  
    thetime = a.year_desc + (a.month_desc-1)/12 + (a.day_desc-1)/12/30;
    figure(1); wahA = rad2bt(1231,squeeze(radA(1:iCnt,:,21,3))); pcolor(thetime,1:iCnt,wahA); shading interp; colormap jet; colorbar;  title('A BT1231'); xlabel('time'); ylabel('tile'); caxis([220 300])
    figure(2); wahD = rad2bt(1231,squeeze(radD(1:iCnt,:,21,3))); pcolor(thetime,1:iCnt,wahD); shading interp; colormap jet; colorbar;  title('D BT1231'); xlabel('time'); ylabel('tile'); caxis([220 300])
    figure(3); pcolor(thetime,1:iCnt,wahA - wahD); shading interp; colormap jet; colorbar;  title('BT1231 A-D'); xlabel('time'); ylabel('tile'); caxis([-1 +1]*10); colormap(usa2)
  
    pause(1)
  end
end

do_XX_YY_from_X_Y
NP = find(YY > 60); SP = find(YY < -60); T = find(abs(YY) <= 30); NML = find(YY > 30 & YY <= 60); SML = find(YY < -30 & YY >= -60);

tai_asc  = a.tai93_asc;
tai_desc = a.tai93_desc;
thetime = a.year_desc + (a.month_desc-1)/12 + (a.day_desc-1)/12/30;

[yyjunk,mmjunk,ddjunk] = tai2utcSergio(a.tai93_desc+offset1958_to_1993);
d2002junk = change2days(yyjunk,mmjunk,ddjunk,2002);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
Xlon = XX; Ylat = YY;
fname_example = fname;
chans41L1B = chans41;
inds41L1C  = inds41;
freqs41L1C = freqs41;
set_iQAX
comment1 = 'chans41L1B = L1B indices = sarta ICHAN eg 1291 = 1231 cm-1;   inds41L1C = L1C indices eg 1520 - Ch!D 1291 = 1231 cm-1 ; freqs41L1C = AIRS L1C channel center freqs; rest is self explanatory';
comment2 = '4608 tiles x 480 timesteps x 41 channels x 5 quantiles -- D and A; tai_A/D = seconds_since_1993; thetime = simple conversions to yy + mm/12 + dd/12/30';
comment3 = 'see /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries/driver_load_41selected_chans_timeseries.m';
saver = ['save -v7.3 ' fdir0 '/chans41_timeseries.mat radA radD chans41L1B inds41L1C freqs41L1C tai_asc tai_desc iNumTimeSteps fname_example thetime Xlon Ylat comment* iQAX quants'];
disp('in other window type      watch "ls -lth /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/DATAObsStats_StartSept2002_CORRECT_LatLon//chans41_timeseries.mat" ')
eval(saver)
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iQPlot = 3; %% Q03
iQPlot = 5; %% Q05
iNumYearSmooth = 4;
iNumYearSmooth = 2;

iNumYearSmooth = 1; iQPlot = 3; %% Q03

daysSince2002 = change2days(a.year_desc,a.month_desc,a.day_desc,2002);

ix = find(freqs41 >= 1419,1); strix = num2str(round(freqs41(ix)),'%04d');
ix = find(freqs41 >= 2616,1); strix = num2str(round(freqs41(ix)),'%04d');
ix = find(freqs41 >= 0727,1); strix = num2str(round(freqs41(ix)),'%04d');

ix = find(freqs41 >= 1231,1); strix = num2str(round(freqs41(ix)),'%04d');
ix2 = find(freqs41 >= 1226,1); strix2 = num2str(round(freqs41(ix2)),'%04d'); wgtChan2 = 0;

plot_41selected_chans_timeseries

region = india;    strregion = 'India';
region = hoto;     strregion = 'Hunga Tonga';
region = siberia;  strregion = 'Siberia';
region = hottest;  strregion = 'Largest dST/dt';

plot_41selected_chans_timeseries_region

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
