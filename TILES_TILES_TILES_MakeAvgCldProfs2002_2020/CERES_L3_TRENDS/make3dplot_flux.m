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

addpath /home/sergio/MATLABCODE/COLORMAP
addpath /home/sergio/MATLABCODE/PLOTTER

do_XX_YY_from_X_Y

figure(1); clf

i22or4 = +1;
if i22or4 > 0
  load ceres_trends_22year_C_T.mat
else
  load xxmodis_L3_cloud_trends_2002_0009_2024_0006.mat
end

yymm = thetime.yymm;
[Y3,X3,Z3] = meshgrid(rlat,rlon,yymm);

[iNumT] = length(ceres_trend.anom_lw);
xanom_cldarea_total_daynight_4608 = reshape(ceres_trend.anom_cldarea_total_daynight_4608,72,64,iNumT);
for ii = 1 : iNumT
  coslat3d(:,:,ii) = cos(Y*pi/180);
end

xanom_cldarea_total_daynight_4608_cos = xanom_cldarea_total_daynight_4608 .* coslat3d;

figure(1); clf; plot(yymm,nanmean(

figure(2); clf; scatter3(X3(:),Y3(:),Z3(:),20,xanom_cldarea_total_daynight_4608_cos(:)); 
colormap(usa2); colorbar; caxis([-1 +1]*10); 
xlabel('Longitude'); ylabel('Latitude'); zlabel('Time'); title('CERES Cloud Frac Anomaly')
set(gca,'fontsize',10)

%%%%%%%%%%%%%%%%%%%%%%%%%

%[m,n,p] = size(xanom_cldarea_total_daynight_4608_cos);
%[X,Y,Z] = meshgrid(1:n,1:m,1:p);
%isosurface(X,Y,Z,xanom_cldarea_total_daynight_4608_cos)

cst = load('coast');

[m,n,p] = size(xanom_cldarea_total_daynight_4608_cos);
[X3,Y3,Z3] = meshgrid(1:n,1:m,1:p);
  zslice = 1:5:length(yymm);
[X3,Y3,Z3] = meshgrid(rlat,rlon,yymm);
  zslice = 2004:2024;
  zslice = 2020:2024;
xslice = [];
yslice = [];

slice(X3,Y3,Z3,xanom_cldarea_total_daynight_4608_cos,xslice,yslice,zslice)
shading interp
colormap(usa2); colorbar; caxis([-1 +1]*10); 
ylabel('Longitude'); xlabel('Latitude'); zlabel('Time'); title('CERES Cloud Frac Anomaly')
set(gca,'fontsize',10)
hold on; plot3(cst.lat,cst.long,ones(size(cst.lat))*2024,'k','linewidth',2); hold off
view([-60 60])
set(gca,'ydir','reverse')

%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2); clf; scatter_coast(X,Y,100,nanmean(xanom_cldarea_total_daynight_4608,3)); colormap(usa2); caxis([-1 +1]*10); title('mean CERES CLDFRAC anomaly')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath /home/sergio/MATLABCODE/PLOTTER/PCOLOR3/pcolor3
%% https://www.mathworks.com/matlabcentral/fileexchange/49985-pcolor3
figure(3); clf;  pcolor3(X3,Y3,Z3,xanom_cldarea_total_daynight_4608_cos,'alpha',0.1,'alphalim',[-10 +10],'Nz',20);
figure(3); clf;  pcolor3(X3,Y3,Z3,xanom_cldarea_total_daynight_4608_cos,'alpha',0.1,'alphalim',[  0 +5],'Nz',20);
caxis([-1 +1]*10); colormap(usa2); colorbar
ylabel('Longitude'); xlabel('Latitude'); zlabel('Time'); title('CERES Cloud Frac Anomaly')
set(gca,'fontsize',10)
hold on; plot3(cst.lat,cst.long,ones(size(cst.lat))*2024,'k','linewidth',2); hold off
view([-60 60])
set(gca,'ydir','reverse')
axis([-90 +90 -180 +180 2015 2025])

figure(4); clf;
  pcolor(yymm,rlat,squeeze(nanmean(xanom_cldarea_total_daynight_4608,1)))
shading interp; colorbar; colormap(usa2); caxis([-1 +1]*5)
return

%{
  #set Alpha of new colormap to be small in the middle of the colormap range using a bump function
    # this can be changed to emphasize different areas of the range that are of interest.   
    nA=cmapO.N    
    xA=np.linspace(-1,1,nA)
    epsilon=5 #Width of range to exclude from alpha channel
    x_0=0#Center of range to exclude from alpha channel
    
    def f_AlphaControl(x):
        u=(x-x_0)/epsilon
        return 1-np.exp(-u**2/(1-u**2))*(np.abs(u)<1.)

 def f_AlphaControl(x):
        u=(x-x_0)/epsilon
        return 1-np.exp(-u**2/(1-u**2))*(np.abs(u)<1.)

    yA=f_AlphaControl(xA) 
    plt.plot(xA,f_AlphaControl(xA))
    plt.xlim([-1,1])
    plt.ylim([0,1])
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = 1 : 12 : p;
img = [];
for ii = 1 : length(ind)
  img = [img; squeeze(xanom_cldarea_total_daynight_4608_cos(:,:,ind(ii)))'];
end
img = xanom_cldarea_total_daynight_4608_cos(:,:,ind);
addpath /home/sergio/MATLABCODE/PLOTTER/VOL3D
figure(4); clf; vol3d(img)

figure(4); clf; volshow(img);

intensity = [0 20 40 120 220 1024];
alpha = [0 0 0.15 0.3 0.38 0.5];
color = [0 0 0; 43 0 0; 103 37 20; 199 155 97; 216 213 201; 255 255 255]/255;
queryPoints = linspace(min(intensity),max(intensity),256);
alphamap = interp1(intensity,alpha,queryPoints)';
colormap = interp1(intensity,color,queryPoints);
colormap = usa2;
figure(4); volshow(img,Colormap=colormap,Alphamap=alphamap,Transformation=tform);
