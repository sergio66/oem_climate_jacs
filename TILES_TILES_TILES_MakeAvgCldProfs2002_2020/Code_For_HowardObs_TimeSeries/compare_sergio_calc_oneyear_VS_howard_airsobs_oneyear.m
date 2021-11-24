dirS = 'DATA_OneYear/0011';
%{
data organized by grid box eg ls ls DATA_OneYear/0011
pall_gridbox_0011_16daytimestep_001_2013_01_01_to_2013_01_16.mat  pall_gridbox_0011_16daytimestep_013_2013_07_12_to_2013_07_27.mat
pall_gridbox_0011_16daytimestep_002_2013_01_17_to_2013_02_01.mat  pall_gridbox_0011_16daytimestep_014_2013_07_28_to_2013_08_12.mat
pall_gridbox_0011_16daytimestep_003_2013_02_02_to_2013_02_17.mat  pall_gridbox_0011_16daytimestep_015_2013_08_13_to_2013_08_28.mat
pall_gridbox_0011_16daytimestep_004_2013_02_18_to_2013_03_05.mat  pall_gridbox_0011_16daytimestep_016_2013_08_29_to_2013_09_13.mat
pall_gridbox_0011_16daytimestep_005_2013_03_06_to_2013_03_21.mat  pall_gridbox_0011_16daytimestep_017_2013_09_14_to_2013_09_29.mat
pall_gridbox_0011_16daytimestep_006_2013_03_22_to_2013_04_06.mat  pall_gridbox_0011_16daytimestep_018_2013_09_30_to_2013_10_15.mat
pall_gridbox_0011_16daytimestep_007_2013_04_07_to_2013_04_22.mat  pall_gridbox_0011_16daytimestep_019_2013_10_16_to_2013_10_31.mat
pall_gridbox_0011_16daytimestep_008_2013_04_23_to_2013_05_08.mat  pall_gridbox_0011_16daytimestep_020_2013_11_01_to_2013_11_16.mat
pall_gridbox_0011_16daytimestep_009_2013_05_09_to_2013_05_24.mat  pall_gridbox_0011_16daytimestep_021_2013_11_17_to_2013_12_02.mat
pall_gridbox_0011_16daytimestep_010_2013_05_25_to_2013_06_09.mat  pall_gridbox_0011_16daytimestep_022_2013_12_03_to_2013_12_18.mat
pall_gridbox_0011_16daytimestep_011_2013_06_10_to_2013_06_25.mat  pall_gridbox_0011_16daytimestep_023_2013_12_19_to_2014_01_03.mat
pall_gridbox_0011_16daytimestep_012_2013_06_26_to_2013_07_11.mat
%}

dirH = '/asl/isilon/airs/tile_test7/';
%{
data organized by YYYY_sTIMESTEP/GRIDBOX/tile_YYYY_sTIMESTEP_N00p00_E000p00.nc

look at eg check_daily_howard_raw_gridded.m

[sergio@strow-interact MakeAvgCldProfs2002_2020]$ ls /asl/isilon/airs/tile_test7/2002_s008/N00p00
tile_2002_s008_N00p00_E000p00.nc  tile_2002_s008_N00p00_E090p00.nc  tile_2002_s008_N00p00_W005p00.nc  tile_2002_s008_N00p00_W095p00.nc
tile_2002_s008_N00p00_E005p00.nc  tile_2002_s008_N00p00_E095p00.nc  tile_2002_s008_N00p00_W010p00.nc  tile_2002_s008_N00p00_W100p00.nc
tile_2002_s008_N00p00_E010p00.nc  tile_2002_s008_N00p00_E100p00.nc  tile_2002_s008_N00p00_W015p00.nc  tile_2002_s008_N00p00_W105p00.nc
tile_2002_s008_N00p00_E015p00.nc  tile_2002_s008_N00p00_E105p00.nc  tile_2002_s008_N00p00_W020p00.nc  tile_2002_s008_N00p00_W110p00.nc
tile_2002_s008_N00p00_E020p00.nc  tile_2002_s008_N00p00_E110p00.nc  tile_2002_s008_N00p00_W025p00.nc  tile_2002_s008_N00p00_W115p00.nc
tile_2002_s008_N00p00_E025p00.nc  tile_2002_s008_N00p00_E115p00.nc  tile_2002_s008_N00p00_W030p00.nc  tile_2002_s008_N00p00_W120p00.nc
tile_2002_s008_N00p00_E030p00.nc  tile_2002_s008_N00p00_E120p00.nc  tile_2002_s008_N00p00_W035p00.nc  tile_2002_s008_N00p00_W125p00.nc
tile_2002_s008_N00p00_E035p00.nc  tile_2002_s008_N00p00_E125p00.nc  tile_2002_s008_N00p00_W040p00.nc  tile_2002_s008_N00p00_W130p00.nc
tile_2002_s008_N00p00_E040p00.nc  tile_2002_s008_N00p00_E130p00.nc  tile_2002_s008_N00p00_W045p00.nc  tile_2002_s008_N00p00_W135p00.nc
tile_2002_s008_N00p00_E045p00.nc  tile_2002_s008_N00p00_E135p00.nc  tile_2002_s008_N00p00_W050p00.nc  tile_2002_s008_N00p00_W140p00.nc
tile_2002_s008_N00p00_E050p00.nc  tile_2002_s008_N00p00_E140p00.nc  tile_2002_s008_N00p00_W055p00.nc  tile_2002_s008_N00p00_W145p00.nc
tile_2002_s008_N00p00_E055p00.nc  tile_2002_s008_N00p00_E145p00.nc  tile_2002_s008_N00p00_W060p00.nc  tile_2002_s008_N00p00_W150p00.nc
tile_2002_s008_N00p00_E060p00.nc  tile_2002_s008_N00p00_E150p00.nc  tile_2002_s008_N00p00_W065p00.nc  tile_2002_s008_N00p00_W155p00.nc
tile_2002_s008_N00p00_E065p00.nc  tile_2002_s008_N00p00_E155p00.nc  tile_2002_s008_N00p00_W070p00.nc  tile_2002_s008_N00p00_W160p00.nc
tile_2002_s008_N00p00_E070p00.nc  tile_2002_s008_N00p00_E160p00.nc  tile_2002_s008_N00p00_W075p00.nc  tile_2002_s008_N00p00_W165p00.nc
tile_2002_s008_N00p00_E075p00.nc  tile_2002_s008_N00p00_E165p00.nc  tile_2002_s008_N00p00_W080p00.nc  tile_2002_s008_N00p00_W170p00.nc
tile_2002_s008_N00p00_E080p00.nc  tile_2002_s008_N00p00_E170p00.nc  tile_2002_s008_N00p00_W085p00.nc  tile_2002_s008_N00p00_W175p00.nc
tile_2002_s008_N00p00_E085p00.nc  tile_2002_s008_N00p00_E175p00.nc  tile_2002_s008_N00p00_W090p00.nc  tile_2002_s008_N00p00_W180p00.nc

%}

%{
check_howard_16daytimesetps_2013_raw_gridded
check_sergio_16daytimesetps_2013_raw_gridded
%}
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /asl/matlib/aslutil

h = load('stats_howard_16daytimesetps_2013_raw_gridded.mat');
s = load('stats_sergio_16daytimesetps_2013_raw_gridded.mat');

figure(1); scatter_coast(s.thesave.lon_desc,s.thesave.lat_desc,50,s.thesave.max1231_desc); colormap jet; title('S max 1231')
figure(2); scatter_coast(s.thesave.lon_desc,s.thesave.lat_desc,50,rad2bt(1231,s.thesave.mean_rad_desc(:,5))); colormap jet; title('S mean 1231')
figure(3); scatter_coast(s.thesave.lon_desc,s.thesave.lat_desc,50,s.thesave.max1231_desc'-rad2bt(1231,s.thesave.mean_rad_desc(:,5))); colormap jet; title('S max-mean')
figure(4); scatter_coast(s.thesave.lon_desc,s.thesave.lat_desc,50,rad2bt(1231,s.thesave.hot_rad_desc(:,5))); colormap jet; title('S 95 percetile 1231')

figure(5); scatter_coast(h.thesave.lon_desc,h.thesave.lat_desc,50,h.thesave.max1231_desc); colormap jet; title('H max 1231')
figure(6); scatter_coast(h.thesave.lon_desc,h.thesave.lat_desc,50,rad2bt(1231,h.thesave.mean_rad_desc(:,1520))); colormap jet; title('H mean 1231')
figure(7); scatter_coast(h.thesave.lon_desc,h.thesave.lat_desc,50,h.thesave.max1231_desc'-rad2bt(1231,h.thesave.mean_rad_desc(:,1520))); colormap jet; title('H max-mean')
figure(8); scatter_coast(h.thesave.lon_desc,h.thesave.lat_desc,50,rad2bt(1231,h.thesave.hot_rad_desc(:,1520))); colormap jet; title('H 95 percetile 1231')

dbt = s.dbt;
figure(9); oo = find(s.thesave.lon_desc <= -175); plot(dbt,s.thesave.hot_hist_desc(oo,:))
figure(9); oo = find(s.thesave.lon_desc <= -175); pcolor(s.thesave.lat_desc(oo),dbt,log10(s.thesave.hot_hist_desc(oo,:)'));
  colormap jet; colorbar; shading interp; title('S hist BT1231')

dbt = s.dbt;
figure(10); oo = find(h.thesave.lon_desc <= -175); plot(dbt,h.thesave.hot_hist_desc(oo,:))
figure(10); oo = find(h.thesave.lon_desc <= -175); [Y,I] = sort(h.thesave.lat_desc(oo)); pcolor(h.thesave.lat_desc(oo(I)),dbt,log10(h.thesave.hot_hist_desc(oo(I),:)'));
  colormap jet; colorbar; shading interp; title('H hist BT1231')

figure(9); caxis([-3.500 -0.75]);
figure(10); caxis([-3.500 -0.75]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1); caxis([240 310]); figure(5); caxis([240 310]);
figure(2); caxis([220 310]); figure(6); caxis([220 310]);
figure(4); caxis([220 310]); figure(8); caxis([220 310]);

