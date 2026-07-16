iVers = 0;  %% nothing fancy in scanang (all 22 deg), spres (all 1100)
iVers = 1;  %% fancy scanang and spres

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

file1 = '/home/sergio/git/matlabcode/REGR_PROFILES_SARTA/REGR49_PROFILES_for_kCARTA_breakouts_for_SARTA/regr49_1013.op.rtp';
file1 = '/home/sergio/git/matlabcode/REGR_PROFILES_SARTA/REGR49_PROFILES_for_kCARTA_breakouts_for_SARTA/regr49_1100.op.rtp';
file1 = '/home/sergio/git/matlabcode/REGR_PROFILES_SARTA/RUN_KCARTA/REGR49_400ppm_H2024_Mar2026_AIRS2834_3CrIS_IASI/regr49_1100_400ppm_unitemiss.op.rtp';
  
file2 = '/home/sergio/git/matlabcode/REGR_PROFILES_SARTA/RUN_KCARTA/REGR49_400ppm_H2024_Apr2026_ECMWF83Profiles_AIRS2834_3CrIS_IASI/ecmwf_co2_400ppm_1100mb.op.rtp';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% positive skew
% 1. Parameters
nItems = 500;
minVal = 900;
maxVal = 1000;
alpha = 2; % Shape parameter 1 (lower = more right-skew)
beta = 8;  % Shape parameter 2 (higher = more right-skew)

% 2. Generate positively skewed data [0, 1]
% betarnd generates a beta distribution; with alpha < beta, it's right-skewed.
data = betarnd(alpha, beta, nItems, 1);

% 3. Scale and shift to range [900, 1000]
skewedData = minVal + (data * (maxVal - minVal));

% 4. Verification & Visualization
fprintf('Skewness: %f\n', skewness(skewedData));
histogram(skewedData, 20);
title('Positively Skewed Distribution (900-1000)');
xlabel('Value');
ylabel('Frequency');

%%%%%%%%%%%%%%%%%%%%%%%%%

% positive skew
% 1. Set parameters
N = 500;
minVal = 900;
maxVal = 1000;
skewnessPower = 3; % Higher power = stronger negative skew

% 2. Generate negatively skewed data between 0 and 1
% Using rand(1,N).^power creates left skewness
data = rand(1, N).^ (1/skewnessPower);

% 3. Scale the data to the desired range (900-1000)
finalData = minVal + (maxVal - minVal) * data;

% 4. Visualize
histogram(finalData, 20)
title('Negatively Skewed Distribution (900-1000)')
set(gca,'xdir','reverse')
fprintf('Skewness: %f\n', skewness(finalData));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath_convolve %% from /home/sergio/git/matlabcode/REGR_PROFILES_SARTA/RUN_KCARTA/

[h1,ha,p1,pa] = rtpread(file1);
[h2,ha,p2,pa] = rtpread(file2);

[h2,p2] = subset_rtp(h2,p2,[],[],1:83);
p2 = rmfield(p2,'gas_11');

fields1 = fieldnames(p1);
fields2 = fieldnames(p2);
for ii = 1 : length(fields2)
  x2 = fields2{ii};
  iaFound(ii) = 0;
  for jj = 1 : length(fields1)
    x1 = fields1{jj};
    if strcmp(x1,x2)
      iaFound(ii) = 1;
    end
  end
  fprintf(1,'%s %2i \n',x2,iaFound(ii))
end  
p2 = rmfield(p2,'rfill');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[h3,p3] = cat_rtp(h1,p2,h1,p1);

%% eventually have to make the angles more realistic ie vary them between 20 and 30 deg
%%   or maybe    22 +/-9 random deg 
%% also, need to have spres = 1013 mb, not 1100 mb
%%   so maybe 1010 +/- 100 mb with a big skew 

if iVers == 0
  p3.scanang = 22 * ones(size(p3.stemp));
  p3.zobs    = 705000 * ones(size(p3.stemp));
  p3.satzen  = vaconv(p3.scanang, p3.zobs, zeros(size(p3.zobs)));
elseif iVers == 1
  p3.scanang = 22 + randn(size(p3.stemp)) * 5/2;
  p3.zobs    = 705000 * ones(size(p3.stemp));
  p3.satzen  = vaconv(p3.scanang, p3.zobs, zeros(size(p3.zobs)));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% now do CO2 and CH4
%p3.gas_2(:,1:83) = p3.gas_2(:,132) * ones(1,83);
p3.gas_2(:,84:132) = p3.gas_2(:,83) * ones(1,49);

%p3.gas_6(:,1:83) = p3.gas_6(:,132) * ones(1,83);
p3.gas_6(:,84:132) = p3.gas_6(:,83) * ones(1,49);

%% assume every 5 years
CH4 = linspace(1775,1925,5)/1000;
CO2 = linspace(370,430,5);
N2O = linspace(310,340,5)/1000;

[ppmvLAY2,ppmvAVG2,ppmvMAX2,pavgLAY2,tavgLAY2,ppmv5002,ppmv752,ppmvSURF2] = layers2ppmv(h3,p3,1:length(p3.stemp),2);
[ppmvLAY4,ppmvAVG4,ppmvMAX4,pavgLAY4,tavgLAY4,ppmv5004,ppmv754,ppmvSURF4] = layers2ppmv(h3,p3,1:length(p3.stemp),4);
[ppmvLAY6,ppmvAVG6,ppmvMAX6,pavgLAY6,tavgLAY6,ppmv5006,ppmv756,ppmvSURF6] = layers2ppmv(h3,p3,1:length(p3.stemp),6);
pcolor(ppmvLAY2)
  colormap jet; colorbar; shading interp;
pcolor(ppmvLAY4)
  colormap jet; colorbar; shading interp;
pcolor(ppmvLAY6)
  colormap jet; colorbar; shading interp;

for ii = 1 : 132
  junkA = ppmvLAY2(:,ii);
  junkB = p3.gas_2(1:100,ii);
  %p3.gas_2(1:100,ii) = junkB * 400/junkA;
  %p3.gas_2(1:100,ii) = junkB * 400/ppmv5002(ii);
  p3.gas_2(1:100,ii) = junkB * 400/ppmvSURF2(ii);

  junkA = ppmvLAY4(:,ii);
  junkB = p3.gas_4(1:100,ii);
  %p3.gas_4(1:100,ii) = junkB * 0.325/junkA;
  %p3.gas_4(1:100,ii) = junkB * 0.325/ppmv5004(ii);
  p3.gas_4(1:100,ii) = junkB * 0.325/ppmvSURF4(ii);  

  junkA = ppmvLAY6(:,ii);
  junkB = p3.gas_6(1:100,ii);
  %p3.gas_6(1:100,ii) = junkB * 1.85/junkA;
  %p3.gas_6(1:100,ii) = junkB * 1.85/ppmv5006(ii);
  p3.gas_6(1:100,ii) = junkB * 1.85/ppmvSURF6(ii);  
end

[ppmvLAY2,ppmvAVG2,ppmvMAX2,pavgLAY2,tavgLAY2,ppmv5002,ppmv752,ppmvSURF2] = layers2ppmv(h3,p3,1:length(p3.stemp),2);
[ppmvLAY4,ppmvAVG4,ppmvMAX4,pavgLAY4,tavgLAY4,ppmv5004,ppmv754,ppmvSURF4] = layers2ppmv(h3,p3,1:length(p3.stemp),4);
[ppmvLAY6,ppmvAVG6,ppmvMAX6,pavgLAY6,tavgLAY6,ppmv5006,ppmv756,ppmvSURF6] = layers2ppmv(h3,p3,1:length(p3.stemp),6);
pcolor(ppmvLAY2)
  colormap jet; colorbar; shading interp;
pcolor(ppmvLAY4)
  colormap jet; colorbar; shading interp;
pcolor(ppmvLAY6)
  colormap jet; colorbar; shading interp;

plot(ppmvLAY2,pavgLAY2); set(gca,'ydir','reverse'); ylim([0.1 1020])
plot(ppmvLAY4,pavgLAY4); set(gca,'ydir','reverse'); ylim([0.1 1020])
plot(ppmvLAY6,pavgLAY6); set(gca,'ydir','reverse'); ylim([0.1 1020])

if iVers == 0
  rtpwrite('combine_83_49_400ppmv_v0.op.rtp',h3,ha,p3,pa);
elseif iVers == 1
  rtpwrite('combine_83_49_400ppmv_v1.op.rtp',h3,ha,p3,pa);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dT = 0.03;  %% K/yr, -ve above 100 mb
dT = 0.03;  %% K/yr
dWVfrac = 0.0025; %% frac, till 100 mb, about 0 above that

raDT = zeros(101,1);
booL = find(p3.plevs(:,1) >= 100); booL = find(p3.plevs(:,1) >= 300);
booU = find(p3.plevs(:,1) <  100); booU = find(p3.plevs(:,1)  < 050);
raDT(booL) = +1; raDT(booU) = -1;
  x1 = max(booU); y1 = -1; x2 = min(booL); y2 = +1; slope = (1 - -1)/(x2-x1);  intercept = y2 - slope*x2; x = x1+1:x2-1; y = slope*x + intercept; raDT(x) = y;
  raDT = raDT * dT; semilogy(raDT,p3.plevs(:,1),'x-'); set(gca,'ydir','reverse'); ylim([0.005 1100])
raDWV = zeros(101,1);
booL = find(p3.plevs(:,1) >= 100); booL = find(p3.plevs(:,1) >= 300);
booU = find(p3.plevs(:,1) <  100); booU = find(p3.plevs(:,1)  < 050);
raDWV(booL) = +1; raDWV(booU) = 0;
  x1 = max(booU); y1 = 0; x2 = min(booL); y2 = +1; slope = (1 - 0)/(x2-x1);  intercept = y2 - slope*x2; x = x1+1:x2-1; y = slope*x + intercept; raDWV(x) = y;
  raDWV = raDWV * dWVfrac; plot(raDWV,p3.plevs(:,1),'x-'); set(gca,'ydir','reverse'); ylim([0.005 1100])
raDOZ = zeros(101,1);
booL = find(p3.plevs(:,1) >= 100); booL = find(p3.plevs(:,1) >= 300);
booU = find(p3.plevs(:,1) <  100); booU = find(p3.plevs(:,1)  < 050);
raDOZ(booL) = 0; raDOZ(booU) = 1;
  x1 = max(booU); y1 = 1; x2 = min(booL); y2 = 0; slope = (0 - 1)/(x2-x1);  intercept = y2 - slope*x2; x = x1+1:x2-1; y = slope*x + intercept; raDOZ(x) = y;
  raDOZ = raDOZ * dWVfrac/2; plot(raDOZ,p3.plevs(:,1),'x-'); set(gca,'ydir','reverse'); ylim([0.005 1100])
  
px370 = p3;
  px370.gas_2 = p3.gas_2 * CO2(1)/400; px370.gas_4 = p3.gas_4 * N2O(1)/0.325; px370.gas_6 = p3.gas_6 * CH4(1)/1.85;
  rr = randn(size(p3.stemp)) * dT/10;      px370.stemp = px370.stemp + (dT*0 + rr);
  rr = randn(size(p3.ptemp)) * dT/10;      px370.ptemp = px370.ptemp + (rr + (raDT*0) * ones(1,132));
  rr = randn(size(p3.ptemp)) * dWVfrac/10; px370.gas_1 = px370.gas_1 .* (1  + rr + (raDWV*0) * ones(1,132));
  rr = randn(size(p3.ptemp)) * dWVfrac/50; px370.gas_3 = px370.gas_3 .* (1  + rr + (raDOZ*0) * ones(1,132));       
px385 = p3;
  px385.gas_2 = p3.gas_2 * CO2(2)/400; px385.gas_4 = p3.gas_4 * N2O(2)/0.325; px385.gas_6 = p3.gas_6 * CH4(2)/1.85;
  rr = randn(size(p3.stemp)) * dT/10;      px385.stemp = px385.stemp + (dT*5 + rr);
  rr = randn(size(p3.ptemp)) * dT/10;      px385.ptemp = px385.ptemp + (rr + (raDT*5) * ones(1,132));
  rr = randn(size(p3.ptemp)) * dWVfrac/10; px385.gas_1 = px385.gas_1 .* (1  + rr + (raDWV*5) * ones(1,132));
  rr = randn(size(p3.ptemp)) * dWVfrac/50; px385.gas_3 = px385.gas_3 .* (1  + rr + (raDOZ*5) * ones(1,132));       
px400 = p3;
  px400.gas_2 = p3.gas_2 * CO2(3)/400; px400.gas_4 = p3.gas_4 * N2O(3)/0.325; px400.gas_6 = p3.gas_6 * CH4(3)/1.85;
  rr = randn(size(p3.stemp)) * dT/10;      px400.stemp = px400.stemp + (dT*10 + rr);
  rr = randn(size(p3.ptemp)) * dT/10;      px400.ptemp = px400.ptemp + (rr + (raDT*10) * ones(1,132));
  rr = randn(size(p3.ptemp)) * dWVfrac/10; px400.gas_1 = px400.gas_1 .* (1  + rr + (raDWV*10) * ones(1,132));
  rr = randn(size(p3.ptemp)) * dWVfrac/50; px400.gas_3 = px400.gas_3 .* (1  + rr + (raDOZ*10) * ones(1,132));         
px415 = p3;
  px415.gas_2 = p3.gas_2 * CO2(4)/400; px415.gas_4 = p3.gas_4 * N2O(4)/0.325; px415.gas_6 = p3.gas_6 * CH4(4)/1.85;
  rr = randn(size(p3.stemp)) * dT/10;      px415.stemp = px415.stemp + (dT*15 + rr);
  rr = randn(size(p3.ptemp)) * dT/10;      px415.ptemp = px415.ptemp + (rr + (raDT*15) * ones(1,132));
  rr = randn(size(p3.ptemp)) * dWVfrac/10; px415.gas_1 = px415.gas_1 .* (1  + rr + (raDWV*15) * ones(1,132));
  rr = randn(size(p3.ptemp)) * dWVfrac/50; px415.gas_3 = px415.gas_3 .* (1  + rr + (raDOZ*15) * ones(1,132));         
px430 = p3;
  px430.gas_2 = p3.gas_2 * CO2(5)/400; px430.gas_4 = p3.gas_4 * N2O(5)/0.325; px430.gas_6 = p3.gas_6 * CH4(5)/1.85;
  rr = randn(size(p3.stemp)) * dT/10;      px430.stemp = px430.stemp + (dT*20 + rr);
  rr = randn(size(p3.ptemp)) * dT/10;      px430.ptemp = px430.ptemp + (rr + (raDT*20) * ones(1,132));
  rr = randn(size(p3.ptemp)) * dWVfrac/10; px430.gas_1 = px430.gas_1 .* (1  + rr + (raDWV*20) * ones(1,132));
  rr = randn(size(p3.ptemp)) * dWVfrac/50; px430.gas_3 = px430.gas_3 .* (1  + rr + (raDOZ*20) * ones(1,132));       

[hx,px] = cat_rtp(h3,px370,h3,px385);
[hx,px] = cat_rtp(h3,px,   h3,px400);
[hx,px] = cat_rtp(h3,px,   h3,px415);
[hx,px] = cat_rtp(h3,px,   h3,px430);

[ppmvx2,ppmvAVG2,ppmvMAX2,pavgLAY2,tavgLAY2,ppmv5002,ppmv752,ppmvSURF2] = layers2ppmv(h3,px,1:length(px.stemp),2);
  pcolor(ppmvx2); shading interp; colorbar
plot(ppmvx2,pavgLAY2); set(gca,'ydir','reverse'); ylim([100 1020])
  
[ppmvx4,ppmvAVG4,ppmvMAX4,pavgLAY4,tavgLAY4,ppmv5004,ppmv754,ppmvSURF4] = layers2ppmv(h3,px,1:length(px.stemp),4);
  pcolor(ppmvx4); shading interp; colorbar
plot(ppmvx4,pavgLAY4); set(gca,'ydir','reverse'); ylim([100 1020])
  
[ppmvx6,ppmvAVG6,ppmvMAX6,pavgLAY6,tavgLAY6,ppmv5006,ppmv756,ppmvSURF6] = layers2ppmv(h3,px,1:length(px.stemp),6);
  pcolor(ppmvx6); shading interp; colorbar
plot(ppmvx6,pavgLAY6); set(gca,'ydir','reverse'); ylim([100 1020])

copy_stemp = [];
copy_ptemp = [];
copy_gas_1 = [];
copy_gas_3 = [];
for ii = 1 : 5
  copy_stemp = [copy_stemp px370.stemp];
  copy_ptemp = [copy_ptemp px370.ptemp];
  copy_gas_1 = [copy_gas_1 px370.gas_1];
  copy_gas_3 = [copy_gas_3 px370.gas_3];  
end
plot(1:660,px.stemp - copy_stemp);
pcolor(1:660,px.plevs,px.ptemp - copy_ptemp); shading interp; colorbar; set(gca,'ydir','reverse'); set(gca,'yscale','log'); ylim([0.005 1100])
pcolor(1:660,px.plevs,px.gas_1 ./ copy_gas_1 - 1); shading interp; colorbar; set(gca,'ydir','reverse'); set(gca,'yscale','log'); ylim([0.005 1100])
pcolor(1:660,px.plevs,px.gas_3 ./ copy_gas_3 - 1); shading interp; colorbar; set(gca,'ydir','reverse'); set(gca,'yscale','log'); ylim([0.005 1100])

%%%%%%%%%%%%%%%%%%%%%%%%%
px.scanang = 22 + randn(size(px.stemp)) * 5/2;
px.zobs    = 705000 * ones(size(px.stemp));
px.satzen  = vaconv(px.scanang, px.zobs, zeros(size(px.zobs)));

%%%%%%%%%%%%%%%%%%%%%%%%%
% positive skew
% 1. Set parameters
N = length(px.stemp);
minVal = 900;
maxVal = 1015;
skewnessPower = 3; % Higher power = stronger negative skew

% 2. Generate negatively skewed data between 0 and 1
% Using rand(1,N).^power creates left skewness
data = rand(1, N).^ (1/skewnessPower);

% 3. Scale the data to the desired range (900-1000)
finalData = minVal + (maxVal - minVal) * data;

% 4. Visualize
histogram(finalData, 20)
title('Negatively Skewed Distribution (900-1000)')
set(gca,'xdir','reverse')
fprintf('Skewness: %f\n', skewness(finalData));

px.spres = finalData;
hist(px.spres)

for ii = 1 : length(px.stemp)
  plevs = px.plevs(:,ii);
  boo = find(plevs >= px.spres(ii));
  px.nlevs(ii) = min(boo);
end
plot(px.spres,px.nlevs,'+')
%%%%%%%%%%%%%%%%%%%%%%%%%

if iVers == 0
  rtpwrite('combine_83_49_370to430ppmv_v0.op.rtp',h3,ha,px,pa);
elseif iVers == 1
  rtpwrite('combine_83_49_370to430ppmv_v1.op.rtp',h3,ha,px,pa);
end
