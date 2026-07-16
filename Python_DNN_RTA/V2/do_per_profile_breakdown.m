addpath /home/sergio/git/matlabcode/PLOTTER  

perProfileRMSE = sqrt(mean((btReconVal - btTrueVal).^2, 2));  % (nVal x 1)

figure(10); clf; colormap jet;

subplot(141); 
scatter(surfPressure(valIdx), perProfileRMSE, 10, 'filled');
xlabel('surface pressure (hPa)'); ylabel('per-profile RMSE (K)');

subplot(142)
scatter(surfTemp(valIdx), perProfileRMSE, 10, 'filled');
xlabel('surface temperature (K)'); ylabel('per-profile RMSE (K)');

subplot(143)
scatter(mmw(valIdx), perProfileRMSE, 10, 'filled');
xlabel('mmw (mm)'); ylabel('per-profile RMSE (K)');

subplot(144)
scatter(p.scanang(valIdx), perProfileRMSE, 10, 'filled');
xlabel('scanang'); ylabel('per-profile RMSE (K)');

disp('ret to continue'); pause
%%%%%%%%%%%%%%%%%%%%%%%%%
figure(11);
scatter_coast(p.rlon(valIdx),p.rlat(valIdx),20,perProfileRMSE); title('RMSE [K]')
if iJac < 0
  caxis([0 0.25])
else
  caxis([0 5e-3])
end  
disp('ret to continue'); pause

if iJac < 0
  dBTstats = 0:0.25:10;           %% look at stats for a sarta (Profile --> radiance)
else
  dBTstats = (-10:0.1:+10)*1e-3;  %% look at stats for a delta(jac)  (Profile --> kcarta J - sartaJ )
end

figure(11);
[nn,nx,ny,nmean,nstd] = myhist2d(surfPressure(valIdx), perProfileRMSE, 500 : 25 : 1100, dBTstats);
errorbar(500 : 25 : 1100,nmean,nstd); plotaxis2;
  xlabel('spres (mb)'); ylabel('RMSE [K]')
disp('ret to continue'); pause

[nn,nx,ny,nmean,nstd] = myhist2d(surfTemp(valIdx), perProfileRMSE, 190:2.5:320, dBTstats);
errorbar(190:2.5:320,nmean,nstd); plotaxis2;
  xlabel('SKT'); ylabel('RMSE [K]')
disp('ret to continue'); pause

[nn,nx,ny,nmean,nstd] = myhist2d(mmw(valIdx), perProfileRMSE, 0:2.5:100, dBTstats);
errorbar(0:2.5:100,nmean,nstd); plotaxis2;
  xlabel('mmw'); ylabel('RMSE [K]')
disp('ret to continue'); pause

[nn,nx,ny,nmean,nstd] = myhist2d(p.scanang(valIdx), perProfileRMSE, 0:2.5:75, dBTstats);
errorbar(0:2.5:75,nmean,nstd); plotaxis2;
  xlabel('scanang'); ylabel('RMSE [K]')
disp('ret to continue'); pause

[nn,nx,ny,nmean,nstd] = myhist2d(p.landfrac(valIdx), perProfileRMSE, 0:0.02:1, dBTstats);
errorbar(0:0.02:1,nmean,nstd); plotaxis2;
  xlabel('landfrac'); ylabel('RMSE [K]')
scatter_coast(p.rlon(valIdx),p.rlat(valIdx),10,p.landfrac(valIdx)); title('landfrac')
disp('ret to continue'); pause

[nn,nx,ny,nmean,nstd] = myhist2d(emissivityRaw(valIdx,i1231), perProfileRMSE, 0:0.02:1, dBTstats);
errorbar(0:0.02:1,nmean,nstd); plotaxis2;
  xlabel('emissivity at 1231 cm-1'); ylabel('RMSE [K]')
scatter_coast(p.rlon(valIdx),p.rlat(valIdx),10,emissivityRaw(valIdx,i1231)); title('1231 cm-1 emissivity')
disp('ret to continue'); pause

scatter(surfTemp(valIdx),mmw(valIdx),10,surfPressure(valIdx),'filled'); colorbar;
  xlabel('validation SKT');   ylabel('validation mmw'); title('Colorbar = spres')
disp('ret to continue'); pause

scatter(surfTemp(valIdx),mmw(valIdx),10,perProfileRMSE,'filled'); colorbar;
  xlabel('validation SKT');   ylabel('validation mmw'); title('Colorbar = RMSE'); caxis([0 1]);
if iJac < 0
  badThresh = 0.2;
else
  badThresh = 2e-3;
end
hold on; bad = find(perProfileRMSE > badThresh); plot(surfTemp(valIdx(bad)),mmw(valIdx(bad)),'x','color',[1 1 1]*0.6); hold off

oceanx = find(p.landfrac(valIdx) == 0);
landx  = find(p.landfrac(valIdx) >  0);

badOcean = find(perProfileRMSE(oceanx) > badThresh);
badLand  = find(perProfileRMSE(landx)  > badThresh);

%% check
if length(oceanx) + length(landx) ~= length(valIdx)
  error('something fishy')
end  
whos bad oceanx landx badOcean badLand   perProfileRMSE
disp('ret to continue'); pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(12);
plot(sort(emissivityRaw(valIdx,i1231)))
plot(p.landfrac(valIdx),emissivityRaw(valIdx,i1231),'.')
  xlabel('landfrac'); ylabel('1231 emissivity'); 
scatter(p.landfrac(valIdx),emissivityRaw(valIdx,i1231),10,perProfileRMSE,'filled'); colorbar
  xlabel('landfrac'); ylabel('1231 emissivity'); title('colorbar = RMSE [K]')

plot(emissivityRaw(valIdx(oceanx),i1231),perProfileRMSE(oceanx),'b.',emissivityRaw(valIdx(landx),i1231),perProfileRMSE(landx),'r.')
  xlabel('1231 emissivity');   ylabel('RMSE [K]'); legend('ocean','land','location','best')
plot(emissivityRaw(valIdx(oceanx),i1231),perProfileRMSE(oceanx),'b.',emissivityRaw(valIdx(landx),i1231),perProfileRMSE(landx),'r.')
  xlabel('1231 emissivity');   ylabel('RMSE [K]'); legend('ocean','land','location','best')
  ax = axis; line([ax(1) ax(2)],[badThresh badThresh],'color','k')
