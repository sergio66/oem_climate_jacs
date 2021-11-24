addpath /asl/matlib/h4tools
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS

figure(1); clf

set_dirIN_dirOUT    %% set the input/output directory here
  dirOUTA = [dirOUT '/16DayAvg/'];
  dirOUTB = [dirOUT '/16DayAvgNoS/'];
dirOUT = dirOUTB;

iLay = 90;
iLay = 95;  %% everything fine
iLay = 96;
iLay = 97;
iLay = input('Enter layer to check (upto 98) : ');

for tt = 1 : iNumTimeStep
  %fout = [dirOUT '/timestepCFC_' num2str(tt,'%03d') '_16day_avg.rp.rtp'];    
  fout = [dirOUT '/timestep_'    num2str(tt,'%03d') '_16day_avg.rp.rtp'];    

  [hall,ha,pall,pa] = rtpread(fout);
  stemp(tt,:) = pall.stemp;
  ptemp(tt,:) = pall.ptemp(90,:);

  [ppmvLAY1,ppmvAVG1,ppmvMAX1,pavgLAY,tavgLAY,~,~] = layers2ppmv(hall,pall,1:length(pall.stemp),1);  
  [ppmvLAY2,ppmvAVG2,ppmvMAX2,pavgLAY,tavgLAY,~,~] = layers2ppmv(hall,pall,1:length(pall.stemp),2);  
  [ppmvLAY3,ppmvAVG3,ppmvMAX3,pavgLAY,tavgLAY,~,~] = layers2ppmv(hall,pall,1:length(pall.stemp),3);  
  [ppmvLAY4,ppmvAVG4,ppmvMAX4,pavgLAY,tavgLAY,~,~] = layers2ppmv(hall,pall,1:length(pall.stemp),4);  
  [ppmvLAY6,ppmvAVG6,ppmvMAX6,pavgLAY,tavgLAY,~,~] = layers2ppmv(hall,pall,1:length(pall.stemp),6);  
  [ppmvLAY51,ppmvAVG51,ppmvMAX51,pavgLAY,tavgLAY,~,~] = layers2ppmv(hall,pall,1:length(pall.stemp),51);  
  [ppmvLAY52,ppmvAVG52,ppmvMAX52,pavgLAY,tavgLAY,~,~] = layers2ppmv(hall,pall,1:length(pall.stemp),52);  

  co2(tt,:)   = ppmvLAY2(iLay,:);
  n2o(tt,:)   = ppmvLAY4(iLay,:);
  ch4(tt,:)   = ppmvLAY6(iLay,:);
  cfc11(tt,:) = ppmvLAY51(iLay,:);
  cfc12(tt,:) = ppmvLAY52(iLay,:);
  wv(tt,:)    = ppmvLAY1(iLay,:);
  o3(tt,:)    = ppmvLAY2(iLay,:);
end
iLay
xtime = xtimestart + (1:iNumTimeStep)*16/365;
pcolor(xtime,1:iMaxLatbin,stemp'); shading flat; colorbar
pcolor(xtime,1:iMaxLatbin,co2'); title(['CO2 ppm at layer ' num2str(iLay)]); shading flat; colorbar
  caxis([380 420]); colorbar

fprintf(1,'timeStart : End = %8.6f %8.6f \n',[xtime(1) xtime(end)])

plot_bad_profs
