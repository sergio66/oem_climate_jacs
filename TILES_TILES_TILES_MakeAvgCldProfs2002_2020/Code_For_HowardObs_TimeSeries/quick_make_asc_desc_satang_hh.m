addpath /home/sergio/MATLABCODE/PLOTTER

for jj = 1 : 64
  if mod(jj,10) == 0
    fprintf(1,'+')
  else
    fprintf(1,'.')
  end
  for ii = 1 : 72
    JOBB = (jj-1)*72 + ii;
    xy = translator_wrong2correct(JOBB);
    iix = xy.wrong2correct_I_J_lon_lat(1);
    jjy = xy.wrong2correct_I_J_lon_lat(2);

    %% hmmmmm
    fname = ['/home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/DATAObsStats_StartSept2002/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/stats_data_2022_s455.mat'];
    fname = ['/home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/DATAObsStats_StartSept2002/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/stats_data_2002_s001.mat'];
    boo = load(fname,'meanhour_desc'); xmeanhour_desc(iix,jjy) = boo.meanhour_desc;
    boo = load(fname,'meanhour_asc');  xmeanhour_asc(iix,jjy)  = boo.meanhour_asc;

    %%%% see eg cluster_loop_make_correct_timeseriesV2.m
    fname = ['/home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/DATAObsStats_StartSept2002/LatBin' num2str(jjy,'%02d') '/LonBin' num2str(iix,'%02d') '/stats_data_2002_s001.mat'];
    boo = load(fname,'meanhour_desc'); meanhour_desc(ii,jj) = boo.meanhour_desc;
    boo = load(fname,'meanhour_asc');  meanhour_asc(ii,jj)  = boo.meanhour_asc;

  end
end
fprintf(1,'\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load latB64.mat
rlon = -180 : +180;          rlat = -90 : +90;
drlon = 5;                   drlat = 3;
rlon = -180 : drlon : +180;  rlat = -90 : drlat : +90;
rlon = rlon;                 rlat = latB2;

x = 0.5*(rlon(1:end-1)+rlon(2:end));  y = 0.5*(rlat(1:end-1)+rlat(2:end));

[Y,X] = meshgrid(y,x);
%Y = Y(:);
%X = X(:);
%plot(X(1:73), Y(1:73),'o')

figure(1); colormap jet
pcolor(X',Y',meanhour_desc'); colorbar; shading flat; title('DESC')
pcolor(X,Y,meanhour_desc); colorbar; shading flat; title('DESC')
scatter_coast(X,Y,50,meanhour_desc); colorbar; shading flat; title('desc hh UTC')
% wonk = zeros(size(meanhour_desc));
% wonk(:,01:32) = xmeanhour_desc(:,33:64);
% wonk(:,33:64) = xmeanhour_desc(:,01:32);
% wonk = flipud(wonk);
% pcolor(wonk'); colorbar; shading flat; title('DESC')

figure(2); colormap jet
pcolor(X',Y',meanhour_asc'); colorbar; shading flat; title('ASC')
pcolor(X,Y,meanhour_asc); colorbar; shading flat; title('ASC')
scatter_coast(X,Y,50,meanhour_asc); colorbar; shading flat; title('asc hh UTC')
% wonk = zeros(size(meanhour_asc));
% wonk(:,01:32) = xmeanhour_asc(:,33:64);
% wonk(:,33:64) = xmeanhour_asc(:,01:32);
% wonk = flipud(wonk);
% pcolor(wonk'); colorbar; shading flat; title('ASC')

save quick_asc_desc_hh.mat X Y meanhour_asc meanhour_desc
