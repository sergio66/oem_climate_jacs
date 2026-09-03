%disp(' ')
%% see eg ~/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries/clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m
isilon_tiledir = '/asl/isilon/airs/tile_test7/';  %% 417 timesteps till Nov 2020
isilon_tiledir = '/asl/isilon/airs/tile_test7/';  %% 433 timesteps till Nov 2021
isilon_tiledir = '/asl/isilon/airs/tile_test7/';  %% 457 timesteps till Nov 2020
isilon_tiledir = '/umbc/rs/strow/asl/airs/tile_test7/'; %% 523 timesteps till Nov 2026

isilon_tiledir = '/asl/isilon/airs/tile_test7/';          %% on taki, before Apr 2025
isilon_tiledir = '/umbc/rs/strow/asl/airs/tile_test7/';   %% on chip, after  Apr 2025
isilon_tiledir = '/umbc/rs/strow/asl/airs/tile_test7/';   %% on chip, after  Mar 2026

% hugedir = dir(isilon_tiledir);
% %disp('>>>>>>>> looking at /asl/isilon/airs/tile_test7/ ')
% fprintf(1,'found %3i hard tile timesteps in %s \n',length(hugedir)-2,isilon_tiledir); %% remember first two are . and ..
