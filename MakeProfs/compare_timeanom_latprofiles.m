addpath /asl/matlib/h4tools

dirA = ['LATS40_avg_made_Mar29_2019_Clr/Desc//16DayAvg/'];     %% profiles have seasonal remaining before doing 16 day average
dirB = ['LATS40_avg_made_Mar29_2019_Clr/Desc//16DayAvgNoS/'];  %% profiles have seasonal removed   before doing 16 day average

iLatbin = input('Enter latbin (1:40) -1 to end : ');
while iLatbin > 0
  f1 = [dirA '/June04_2019/latbin' num2str(iLatbin) '_16day_avg.op.rtp'];   %% bad CO2/CH4/N2O .... as compared to VMR
  f2 = [dirA '/latbin' num2str(iLatbin) '_16day_avg.op.rtp'];               %% fixed the CO2/CH4/N2O .... as compared to VMR

  f1 = [dirA '/latbin' num2str(iLatbin) '_16day_avg.op.rtp'];               %% fixed the CO2/CH4/N2O .... as compared to VMR, but profiles still have seasonal
  f2 = [dirB '/latbin' num2str(iLatbin) '_16day_avg.op.rtp'];               %% fixed the CO2/CH4/N2O .... as compared to VMR, and profiles have seasonal removed
 
  lser = ['!ls -lt ' f1]; eval(lser)
  lser = ['!ls -lt ' f2]; eval(lser)

  [h,ha,p1,pa] = rtpread(f1);
  [h,ha,p2,pa] = rtpread(f2);

figure(1); clf; plot(p1.ptemp-p2.ptemp,1:101); set(gca,'ydir','reverse'); title('delta T');
figure(2); clf; plot(p1.gas_1./p2.gas_1,1:101); set(gca,'ydir','reverse'); title('WV ratio')
figure(3); clf; plot(p1.gas_2./p2.gas_2,1:101); set(gca,'ydir','reverse'); title('CO2 ratio')
figure(4); clf; plot(p1.gas_3./p2.gas_3,1:101); set(gca,'ydir','reverse'); title('O3 ratio')
figure(5); clf; plot(1:365,p1.stemp,1:365,p2.stemp); title('\delta (stemp)')
disp('ret to continue'); pause

  [timeppmvLAY1,timeppmvAVG1,timeppmvMAX1,pavgLAY,tavgLAY,~,~] = layers2ppmv(h,p1,1:length(p1.stemp),1);
  [timeppmvLAY2,timeppmvAVG2,timeppmvMAX2,pavgLAY,tavgLAY,~,~] = layers2ppmv(h,p2,1:length(p2.stemp),1);
  figure(1); clf
  subplot(211)
    plot(1:length(p1.stemp),timeppmvAVG1,'bo-',1:length(p1.stemp),timeppmvAVG2,'rx-','linewidth',2); title('Avg WV ppm')
    hl = legend('old','new');
  subplot(212)
    plot(1:length(p1.stemp),timeppmvLAY1(76,:),'bo-',1:length(p1.stemp),timeppmvLAY2(76,:),'rx-','linewidth',2); 
    title('500 mb WV ppm')
    hl = legend('old','new');

  [timeppmvLAY1,timeppmvAVG1,timeppmvMAX1,pavgLAY,tavgLAY,~,~] = layers2ppmv(h,p1,1:length(p1.stemp),2);
  [timeppmvLAY2,timeppmvAVG2,timeppmvMAX2,pavgLAY,tavgLAY,~,~] = layers2ppmv(h,p2,1:length(p2.stemp),2);
  figure(2); clf
  subplot(211)
    plot(1:length(p1.stemp),timeppmvAVG1,'bo-',1:length(p1.stemp),timeppmvAVG2,'rx-','linewidth',2); title('Avg CO2 ppm')
    hl = legend('old','new');
  subplot(212)
    plot(1:length(p1.stemp),timeppmvLAY1(76,:),'bo-',1:length(p1.stemp),timeppmvLAY2(76,:),'rx-','linewidth',2); 
    title('500 mb CO2 ppm')
    hl = legend('old','new');

  [timeppmvLAY1,timeppmvAVG1,timeppmvMAX1,pavgLAY,tavgLAY,~,~] = layers2ppmv(h,p1,1:length(p1.stemp),3);
  [timeppmvLAY2,timeppmvAVG2,timeppmvMAX2,pavgLAY,tavgLAY,~,~] = layers2ppmv(h,p2,1:length(p2.stemp),3);
  figure(3); clf
  subplot(211)
    plot(1:length(p1.stemp),timeppmvAVG1,'bo-',1:length(p1.stemp),timeppmvAVG2,'rx-','linewidth',2); title('Avg O3 ppm')
    hl = legend('old','new');
  subplot(212)
    plot(1:length(p1.stemp),timeppmvLAY1(76,:),'bo-',1:length(p1.stemp),timeppmvLAY2(76,:),'rx-','linewidth',2); 
    title('500 mb O3 ppm')
    hl = legend('old','new');

  [timeppmvLAY1,timeppmvAVG1,timeppmvMAX1,pavgLAY,tavgLAY,~,~] = layers2ppmv(h,p1,1:length(p1.stemp),4);
  [timeppmvLAY2,timeppmvAVG2,timeppmvMAX2,pavgLAY,tavgLAY,~,~] = layers2ppmv(h,p2,1:length(p2.stemp),4);
  figure(4); clf
  subplot(211)
    plot(1:length(p1.stemp),timeppmvAVG1,'bo-',1:length(p1.stemp),timeppmvAVG2,'rx-','linewidth',2); title('Avg N2O ppm')
    hl = legend('old','new');
  subplot(212)
    plot(1:length(p1.stemp),timeppmvLAY1(76,:),'bo-',1:length(p1.stemp),timeppmvLAY2(76,:),'rx-','linewidth',2); 
    title('500 mb N2O ppm')
    hl = legend('old','new');

  [timeppmvLAY1,timeppmvAVG1,timeppmvMAX1,pavgLAY,tavgLAY,~,~] = layers2ppmv(h,p1,1:length(p1.stemp),6);
  [timeppmvLAY2,timeppmvAVG2,timeppmvMAX2,pavgLAY,tavgLAY,~,~] = layers2ppmv(h,p2,1:length(p2.stemp),6);
  figure(5); clf
  subplot(211)
    plot(1:length(p1.stemp),timeppmvAVG1,'bo-',1:length(p1.stemp),timeppmvAVG2,'rx-','linewidth',2); title('Avg CH4 ppm')
    hl = legend('old','new');
  subplot(212)
    plot(1:length(p1.stemp),timeppmvLAY1(76,:),'bo-',1:length(p1.stemp),timeppmvLAY2(76,:),'rx-','linewidth',2); 
    title('500 mb CH4 ppm')
    hl = legend('old','new');

  iLatbin = input('Enter latbin (1:40) -1 to end: ');
end
