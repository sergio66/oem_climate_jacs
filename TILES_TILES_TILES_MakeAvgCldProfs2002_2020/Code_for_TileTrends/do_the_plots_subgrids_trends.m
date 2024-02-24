[Y,I] = sort(subgrids_lon);
[Y,I] = sort(subgrids_lon);

matr = [subgrids_lat(I); subgrids_lon(I)]'; [matr,I] = sortrows(matr,[1 2]); % printarray(matr);
%% india is 4 tiles across x 8 tiles high; subgrids have nxx = 3 and nyy = 2 boxes
nX = 4; nY = 8;  nsubX = 3; nsubY = 2;
ind0 = 1:nsubY:nX*nsubX*nsubY;;
I = [];
for jj = 1 : nY
  for kk = 1 : nsubY
    indtemp = ind0 + (kk-1);
    indtemp = indtemp + (jj-1)*nsubX*nsubY*nX;
    I = [I indtemp];
  end
end
%% I = 1 : length(subgrids_lon);

scsize = 50;
scsize = 150;
figure(1); scatter_coast(subgrids_lon(I),subgrids_lat(I),scsize,subgrids_asc(I)); colorbar; colormap jet
   rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
   title(['Q03 Asc node BT1231 trend K/yr']); caxis([-1 +1]*0.15); colormap(usa2)
figure(2); scatter_coast(subgrids_lon(I),subgrids_lat(I),scsize,subgrids_desc(I)); colorbar; colormap jet
   rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
   title(['Q03 Desc node BT1231 trend K/yr']); caxis([-1 +1]*0.15); colormap(usa2)
vertices2 = [vertices(1)-3 vertices(2)+3 vertices(3)-3 vertices(4)+3];
figure(1); axis(vertices2); rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','r','linewidth',2);
figure(2); axis(vertices2); rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','r','linewidth',2);

figure(1); simplemap(subgrids_lat(I),subgrids_lon(I),subgrids_asc(I),2); colorbar; colormap jet
   rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
   title(['Q03 Asc node BT1231 trend K/yr']); caxis([-1 +1]*0.15); colormap(usa2)
figure(2); simplemap(subgrids_lat(I),subgrids_lon(I),subgrids_desc(I),2); colorbar; colormap jet
   rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
   title(['Q03 Desc node BT1231 trend K/yr']); caxis([-1 +1]*0.15); colormap(usa2)
vertices2 = [vertices(1)-3 vertices(2)+3 vertices(3)-3 vertices(4)+3];
figure(1); axis(vertices2); rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','r','linewidth',2);
figure(2); axis(vertices2); rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','r','linewidth',2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2003-2017

[xg,yg] = meshgrid(floor(min(subgrids_lon)):1.0:ceil(max(subgrids_lon)),floor(min(subgrids_lat)):1.0:ceil(max(subgrids_lat)));
FD = scatteredInterpolant(subgrids_lon',subgrids_lat',subgrids_asc');
FN = scatteredInterpolant(subgrids_lon',subgrids_lat',subgrids_desc');
VD = FD(xg,yg);
VN = FN(xg,yg);

figure(1); simplemap(subgrids_lat(I),subgrids_lon(I),subgrids_asc2(I),2); colorbar; colormap jet
   rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
   title(['2003-2017 Q03 Asc node \newline BT1231 trend K/yr']); caxis([-1 +1]*0.15); colormap(usa2)
figure(2); simplemap(subgrids_lat(I),subgrids_lon(I),subgrids_desc2(I),2); colorbar; colormap jet
   rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
   title(['2003-2017 Q03 Desc node \newline BT1231 trend K/yr']); caxis([-1 +1]*0.15); colormap(usa2)
figure(1); scatter_coast(subgrids_lon(I),subgrids_lat(I),scsize*2,subgrids_asc2(I),2); colorbar; colormap jet
   rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
   title(['2003-2017 Q03 Asc node \newline BT1231 trend K/yr']); caxis([-1 +1]*0.15); colormap(usa2)
figure(2); scatter_coast(subgrids_lon(I),subgrids_lat(I),scsize*2,subgrids_desc2(I),2); colorbar; colormap jet
   rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
   title(['2003-2017 Q03 Desc node \newline BT1231 trend K/yr']); caxis([-1 +1]*0.15); colormap(usa2)
%{
figure(1); pcolor(xg,yg,VD); colorbar; colormap jet; shading interp
   rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
   title(['2003-2017 Q03 Asc node \newline BT1231 trend K/yr']); caxis([-1 +1]*0.15); colormap(usa2)
figure(2); pcolor(xg,yg,VN); colorbar; colormap jet; shading interp
   rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
   title(['2003-2017 Q03 Desc node \newline BT1231 trend K/yr']); caxis([-1 +1]*0.15); colormap(usa2)
figure(1); pcolor(reshape(subgrids_lon(I),nX*nsubX,nY*nsubY),reshape(subgrids_lat(I),nX*nsubX,nY*nsubY),reshape(subgrids_asc(I),nX*nsubX,nY*nsubY)); shading interp
   rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
   title(['2003-2017 Q03 Asc node \newline BT1231 trend K/yr']); caxis([-1 +1]*0.15); colormap(usa2); colorbar
figure(2); pcolor(reshape(subgrids_lon(I),nX*nsubX,nY*nsubY),reshape(subgrids_lat(I),nX*nsubX,nY*nsubY),reshape(subgrids_desc(I),nX*nsubX,nY*nsubY)); shading interp
   rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
   title(['2003-2017 Q03 Desc node \newline BT1231 trend K/yr']); caxis([-1 +1]*0.15); colormap(usa2)l colorbar
%}
vertices2 = [vertices(1)-3 vertices(2)+3 vertices(3)-3 vertices(4)+3];
figure(1); axis(vertices2); rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','r','linewidth',2);
figure(2); axis(vertices2); rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','r','linewidth',2);

sprakash_day = load('/asl/s1/sergio/NSD_India_Met_Data/MODIS_ANNUAL_LST_DAY_TREND_2003_2017.csv');
sprakash_ngt = load('/asl/s1/sergio/NSD_India_Met_Data/MODIS_ANNUAL_LST_NIGHT_TREND_2003_2017.csv');
%[xg,yg] = meshgrid(sprakash_day(:,1),sprakash_day(:,2));
%FD = scatteredInterpolant(sprakash_day(:,1),sprakash_day(:,2),sprakash_day(:,3)/10);
%FN = scatteredInterpolant(sprakash_ngt(:,1),sprakash_ngt(:,2),sprakash_ngt(:,3)/10);
%VD = FD(xg,yg);
%VN = FN(xg,yg);
figure(3); simplemap(sprakash_day(:,1),sprakash_day(:,2),sprakash_day(:,3)/10,2); colorbar; colormap jet
   rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
   title(['2003-2017 MODIS ASC node \newline BT1231 trend K/yr']); caxis([-1 +1]*0.15); colormap(usa2)
figure(4); simplemap(sprakash_ngt(:,1),sprakash_ngt(:,2),sprakash_ngt(:,3)/10,2); colorbar; colormap jet
   rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
   title(['2003-2017 MODIS DESC node \newline BT1231 trend K/yr']); caxis([-1 +1]*0.15); colormap(usa2)
figure(3); scatter_coast(sprakash_day(:,2),sprakash_day(:,1),scsize/10,sprakash_day(:,3)/10); colorbar; colormap jet; shading interp
   rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
   title(['2003-2017 MODIS ASC node \newline BT1231 trend K/yr']); caxis([-1 +1]*0.15); colormap(usa2)
figure(4); scatter_coast(sprakash_ngt(:,2),sprakash_ngt(:,1),scsize/10,sprakash_ngt(:,3)/10); colorbar; colormap jet; shading interp
   rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
   title(['2003-2017 MODIS DESC node \newline BT1231 trend K/yr']); caxis([-1 +1]*0.15); colormap(usa2)
vertices2 = [vertices(1)-3 vertices(2)+3 vertices(3)-3 vertices(4)+3];
figure(3); axis(vertices2); rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','r','linewidth',2);
figure(4); axis(vertices2); rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','r','linewidth',2);

moo = load('coast.mat');
for ii = 1 : 4
  figure(ii); hold on; 
  plot(moo.long,moo.lat,'k','linewidth',2); 
  borders('india','linewidth',2,'color','k');
  hold off
end

