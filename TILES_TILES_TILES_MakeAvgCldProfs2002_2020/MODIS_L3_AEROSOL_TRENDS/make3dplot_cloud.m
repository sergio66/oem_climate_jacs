% https://www.youtube.com/watch?v=U3bpTieC0Ow
%
% data = reshape(1:175, 5,5,7);  % Fake data,  5x5x7
% [X,Y,Z] = meshgrid(1:size(data,1), 1:size(data,2),1:size(data,3)); 
% scatter3(X(:),Y(:),Z(:), 80, data(:),'filled')
% whos X Y Z data
%  Name      Size             Bytes  Class     Attributes
%
%  X         5x5x7             1400  double
%  Y         5x5x7             1400  double
%  Z         5x5x7             1400  double
%  data      5x5x7             1400  double

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

do_XX_YY_from_X_Y

figure(1); clf

i22or4 = -1;
if i22or4 > 0
  load modis_L3_cloud_trends_2002_0009_2024_0006.mat
else
  load modis_L3_cloud_trends_2020_0007_2024_0006.mat
end

[Y3,X3,Z3] = meshgrid(rlat,rlon,yymm);

[~,~,iNumT] = size(anom_cldfrac);
for ii = 1 : iNumT
  coslat3d(:,:,ii) = cos(Y*pi/180);
end

anom_cldfrac_cos = anom_cldfrac .* coslat3d;

scatter3(X3(:),Y3(:),Z3(:),20,anom_cldfrac_cos(:)); 
colormap(usa2); colorbar; caxis([-1 +1]*0.25); 
xlabel('Longitude'); ylabel('Latitude'); zlabel('Time'); title('MODIS Cloud Frac Anomaly')
set(gca,'fontsize',10)

%%%%%%%%%%%%%%%%%%%%%%%%%

%[m,n,p] = size(anom_cldfrac_cos);
%[X,Y,Z] = meshgrid(1:n,1:m,1:p);
%isosurface(X,Y,Z,anom_cldfrac_cos)

cst = load('coast');

[m,n,p] = size(anom_cldfrac_cos);
[X3,Y3,Z3] = meshgrid(1:n,1:m,1:p);
  zslice = 1:5:length(yymm);
[X3,Y3,Z3] = meshgrid(rlat,rlon,yymm);
  zslice = 2004:2024;
  zslice = 2020:2024;
xslice = [];
yslice = [];

slice(X3,Y3,Z3,anom_cldfrac_cos,xslice,yslice,zslice)
shading interp
colormap(usa2); colorbar; caxis([-1 +1]*0.25); 
ylabel('Longitude'); xlabel('Latitude'); zlabel('Time'); title('MODIS Cloud Frac Anomaly')
set(gca,'fontsize',10)
hold on; plot3(cst.lat,cst.long,ones(size(cst.lat))*2024,'k','linewidth',2); hold off
view([-60 60])
set(gca,'ydir','reverse')

%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2); clf; scatter_coast(X,Y,100,nanmean(anom_cldfrac,3)); colormap(usa2); caxis([-1 +1]*0.125); title('mean MODIS CLDFRAC anomaly')
