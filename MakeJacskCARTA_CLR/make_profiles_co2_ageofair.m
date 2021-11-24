addpath /asl/matlib/h4tools
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS
addpath /home/sergio/MATLABCODE/COLORMAP
addpath /home/sergio/MATLABCODE/PLOTMISC
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/

%% Figure 6(a) https://www.atmos-chem-phys.net/17/3861/2017/acp-17-3861-2017.pdf 
%% estimate data at lat [-75 -50 -25 0 +25 +50 +75]  and at height [5 10 15 20 25] km
%% each colorbar unit is 5/8 ppm (5 ppm in 8 steps)
delta = 5/8;
hgts = 0:5:25; lats = -75 : 25 : 75;

%% january 2010
data1x = 385 + delta * [0  1  2  5  6  9  9; ...     %% 5 km
                        3  0  2  5  6  4  4; ...     %% 10 km
                       -2 -1  3  5  6  0 -2; ...     %% 15 km
                       -6 -4 -1  1 -1 -7 -7; ...     %% 20 km
                       -8 -8 -4  0 -1 -7 -7;];       %% 25 km
%% march 2010
data3x = 385 + delta * [1  1  2  5  7 12 12; ...     %% 5 km
                        0  1  3  7  9  9  3; ...     %% 10 km
                       -2  1  3  6  8  1 -2; ...     %% 15 km
                       -8 -7 -4  3  4 -1 -3; ...     %% 20 km
                       -8 -8 -6  1 -2 -8 -8;];       %% 25 km
%% may 2010
data5x = 385 + delta * [3  4  5  8  12 12 12; ...     %% 5 km
                        3  4  6  8  10  8  6; ...     %% 10 km
                       -3  1  5  8  8  -3 -1; ...     %% 15 km
                       -8 -4 1   6  3 -2 -4; ...     %% 20 km
                       -8 -6 -1  0 -1 -3 -5;];       %% 25 km
%% july 2010
data7x = 385 + delta * [4  4  6  8  8  1 -3; ...     %% 5 km
                        3  3  6  8  8  3  3; ...     %% 10 km
                       -3 -2  6  8  8  6  4; ...     %% 15 km
                       -8 -5 -2  8  5 -2 -2; ...     %% 20 km
                       -8 -5 -1  1  1 -1 -2;];       %% 25 km
%% sept 2010
data9x = 385 + delta * [5  5  6  5  5  4 -2; ...     %% 5 km
                        4  4  6  5  4  4  4; ...     %% 10 km
                       -3 3   5  5  5  6  6; ...     %% 15 km
                       -6 -6 3   6  5  3 3; ...     %% 20 km
                       -7 -5 -1  1  1 -1 -2;];       %% 25 km
%% nov 2010
data11x = 385 + delta * [4  5  5  6  7  8  9; ...     %% 5 km
                         3  4  6  6  7  7  6; ...     %% 10 km
                        -3  3  5  6  5  4  3; ...     %% 15 km
                        -6 -4  3  6  4 -2 -4; ...     %% 20 km
                        -6 -3 -3  1  1 -3 -4;];       %% 25 km
data1 = zeros(6,7);  data1(1,:) =  data1x(1,:);  data1(2:6,:) =  data1x;  imagesc(lats,hgts,data1);  pcolor(lats,hgts,data1);  colormap jet; colorbar; shading interp; set(gca,'ydir','normal'); 
data3 = zeros(6,7);  data3(1,:) =  data3x(1,:);  data3(2:6,:) =  data3x;  imagesc(lats,hgts,data3);  pcolor(lats,hgts,data3);  colormap jet; colorbar; shading interp; set(gca,'ydir','normal'); 
data5 = zeros(6,7);  data5(1,:) =  data5x(1,:);  data5(2:6,:) =  data5x;  imagesc(lats,hgts,data5);  pcolor(lats,hgts,data5);  colormap jet; colorbar; shading interp; set(gca,'ydir','normal'); 
data7 = zeros(6,7);  data7(1,:) =  data7x(1,:);  data7(2:6,:) =  data7x;  imagesc(lats,hgts,data7);  pcolor(lats,hgts,data7);  colormap jet; colorbar; shading interp; set(gca,'ydir','normal'); 
data9 = zeros(6,7);  data9(1,:) =  data9x(1,:);  data9(2:6,:) =  data9x;  imagesc(lats,hgts,data9);  pcolor(lats,hgts,data9);  colormap jet; colorbar; shading interp; set(gca,'ydir','normal'); 
data11 = zeros(6,7); data11(1,:) = data11x(1,:); data11(2:6,:) = data11x; imagesc(lats,hgts,data11); pcolor(lats,hgts,data11); colormap jet; colorbar; shading interp; set(gca,'ydir','normal'); 

%% co2junk = 370 + (yyjunk-2002)*2.2
co2_2010 = (2010.5-2002)*2.2 + 370; 
for ii = 1 : 2 : 11
  str = ['xdata = data' num2str(ii) ';']; eval(str);
  pcolor(lats,hgts,xdata); caxis([380 395]); colormap jet; colorbar; shading interp; set(gca,'ydir','normal'); title(num2str(ii)); pause(0.1)
end
for ii = 1 : 2 : 11
  str = ['xdata = data' num2str(ii) ';']; eval(str);
  pcolor(lats,hgts,xdata-co2_2010); caxis([-7 +7]); colormap(usa2); colorbar; shading interp; set(gca,'ydir','normal'); title(num2str(ii)); pause(0.1)
end

alldata(1,:,:) = data1;
alldata(2,:,:) = data3;
alldata(3,:,:) = data5;
alldata(4,:,:) = data7;
alldata(5,:,:) = data9;
alldata(6,:,:) = data11;

iaDates = [1 3 5 7 9 11];
for month = 0 : 12
  for ll = 1 : 7
    for hh = 1 : 6
      junk(hh,ll) = interp1(iaDates,squeeze(alldata(:,hh,ll)),month,[],'extrap');
    end
  end
  figure(1);
  pcolor(lats,hgts,junk-co2_2010); caxis([-7 +7]); colormap(usa2); colorbar; shading interp; 
    set(gca,'ydir','normal'); title(num2str(month)); pause(0.1)
  savex00(month+1,:) = junk(1,:);
  savex10(month+1,:) = junk(3,:);
  savex20(month+1,:) = junk(5,:);

  if month == 0
    save_start = junk;
  elseif month == 12
    save_stop = junk;
  end
end

figure(2); 
pcolor(0:12,lats,savex00' - co2_2010); shading interp; ylabel('Latitude'); xlabel('time in months'); 
title('Surface CO2 change wrt mid year (ppm)')

figure(3); 
pcolor(0:12,lats,savex10' - co2_2010); shading interp; ylabel('Latitude'); xlabel('time in months'); 
title('10 km CO2 change wrt mid year (ppm)')

figure(4); 
pcolor(0:12,lats,savex20' - co2_2010); shading interp; ylabel('Latitude'); xlabel('time in months'); 
title('20 km CO2 change wrt mid year (ppm)')

figure(1);
  pcolor(lats,hgts,save_stop - save_start); caxis([-3 +3]); colormap(usa2); colorbar; shading interp; 
    set(gca,'ydir','normal'); title('12 months change');

figure(5)
plot(lats,save_stop'-save_start','o-'); title('Oh Oh change in 1 year should be 2.2 ppmv!!')
grid
plotaxis2;

for ii = 2 : 5
  figure(ii); caxis([-5 5]); colormap(usa2); colorbar
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% so now redo the data
disp('ret to continue to redone data ...'); pause
slope = save_stop-save_start;
slope = slope;
data1new = (2.2 - slope)*1/12 + data1;
data3new = (2.2 - slope)*3/12 + data3;
data5new = (2.2 - slope)*5/12 + data5;
data7new = (2.2 - slope)*7/12 + data7;
data9new = (2.2 - slope)*9/12 + data9;
data11new = (2.2 - slope)*11/12 + data11;

alldatanew(1,:,:) = data1new;
alldatanew(2,:,:) = data3new;
alldatanew(3,:,:) = data5new;
alldatanew(4,:,:) = data7new;
alldatanew(5,:,:) = data9new;
alldatanew(6,:,:) = data11new;

iaDates = [1 3 5 7 9 11];
for month = 0 : 12
  for ll = 1 : 7
    for hh = 1 : 6
      junk(hh,ll) = interp1(iaDates,squeeze(alldata(:,hh,ll)),month,[],'extrap');
      junknew(hh,ll) = interp1(iaDates,squeeze(alldatanew(:,hh,ll)),month,[],'extrap');
    end
  end
  figure(1);
  pcolor(lats,hgts,junk-co2_2010); caxis([-7 +7]); colormap(usa2); colorbar; shading interp; 
    set(gca,'ydir','normal'); title([num2str(month) 'ORIG']); 
  figure(2);
  pcolor(lats,hgts,junknew-co2_2010); caxis([-7 +7]); colormap(usa2); colorbar; shading interp; 
    set(gca,'ydir','normal'); title([num2str(month) 'NEW']); pause
  savex00(month+1,:) = junknew(1,:);
  savex10(month+1,:) = junknew(3,:);
  savex20(month+1,:) = junknew(5,:);

  if month == 0
    save_start = junknew;
  elseif month == 12
    save_stop = junknew;
  end
end

figure(2); 
pcolor(0:12,lats,savex00' - co2_2010); shading interp; ylabel('Latitude'); xlabel('time in months'); 
title('Surface CO2 change wrt mid year (ppm)')

figure(3); 
pcolor(0:12,lats,savex10' - co2_2010); shading interp; ylabel('Latitude'); xlabel('time in months'); 
title('10 km CO2 change wrt mid year (ppm)')

figure(4); 
pcolor(0:12,lats,savex20' - co2_2010); shading interp; ylabel('Latitude'); xlabel('time in months'); 
title('20 km CO2 change wrt mid year (ppm)')

figure(1);
  pcolor(lats,hgts,save_stop - save_start); caxis([-3 +3]); colormap(usa2); colorbar; shading interp; 
    set(gca,'ydir','normal'); title('12 months change');

figure(5)
plot(lats,save_stop'-save_start','o-'); title('NOW change in 1 year should be 2.2 ppmv!!')
grid
plotaxis2;

for ii = 2 : 5
  figure(ii); caxis([-5 5]); colormap(usa2); colorbar
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('ret to continue for 4 years')
iaDatesN = [1 3 5 7 9 11];
alldatanewN = alldatanew;
for month = 13 : 48
  if mod(month,12) == 1
    iaDatesN    = iaDatesN + 12;
    alldatanewN = alldatanewN + 2.2;
  end
  for ll = 1 : 7
    for hh = 1 : 6
      junk(hh,ll) = interp1(iaDates,squeeze(alldata(:,hh,ll)),month,[],'extrap');
      junknew(hh,ll) = interp1(iaDatesN,squeeze(alldatanewN(:,hh,ll)),month,[],'extrap');
    end
  end
  figure(1);
  pcolor(lats,hgts,junk-co2_2010); caxis([-7 +7]); colormap(usa2); colorbar; shading interp; 
    set(gca,'ydir','normal'); title([num2str(month) 'ORIG']); 
  figure(2);
  pcolor(lats,hgts,junknew-co2_2010); caxis([-7 +7]); colormap(usa2); colorbar; shading interp; 
    set(gca,'ydir','normal'); title([num2str(month) 'NEW']); pause(0.1)
  savex00(month+1,:) = junknew(1,:);
  savex10(month+1,:) = junknew(3,:);
  savex20(month+1,:) = junknew(5,:);

  if month == 24
    save_stop24 = junknew;
  elseif month == 36
    save_stop36 = junknew;
  elseif month == 48
    save_stop48 = junknew;
  end
end

comment1 = 'see make_profiles_co2_ageofair.m, this is for 2010';
comment2 = 'size(alldatanew) = 6 months(1,3,5,7,9) x 6 heights x 7 lats';
% save co2_age_of_air_profiles.mat lats hgts iaDates alldatanew comment1 comment2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
