addpath /asl/matlib/h4tools
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS

f0 = '../MakeProfs/LATS40_avg_made_Aug20_2019_Clr/Desc/16DayAvgNoS/timestep_180_16day_avg.rp.rtp';
fx = '../MakeProfs/LATS40_avg_made_Aug20_2019_Clr/Desc/16DayAvgNoS/timestep_180_16day_avg_co2ageofair.rp.rtp';

[h,ha,p0,pa] = rtpread(f0);
[h,ha,px,pa] = rtpread(fx);


[ppmvLAY2,ppmvAVG2,ppmvMAX2,pavgLAY2,tavgLAY2,ppmv500,ppmv75] = layers2ppmv(h,p0,1:40,2);
[ppmvLAY4,ppmvAVG4,ppmvMAX4,pavgLAY4,tavgLAY4,ppmv500,ppmv75] = layers2ppmv(h,p0,1:40,4);
[ppmvLAY6,ppmvAVG6,ppmvMAX6,pavgLAY6,tavgLAY6,ppmv500,ppmv75] = layers2ppmv(h,p0,1:40,6);

[ppmvLAY2x,ppmvAVG2x,ppmvMAX2x,pavgLAY2x,tavgLAY2x,ppmv500,ppmv75] = layers2ppmv(h,px,1:40,2);

figure(1); plot(ppmvLAY2,pavgLAY2,'b',ppmvLAY2x,pavgLAY2x,'r'); set(gca,'ydir','reverse'); set(gca,'yscale','log');
  ax = axis; ax(3) = 0.001; ax(4) = 1000; axis(ax); title('CO2 ppmv')

figure(2); plot(ppmvLAY4,pavgLAY4); set(gca,'ydir','reverse'); set(gca,'yscale','log');
  ax = axis; ax(3) = 0.001; ax(4) = 1000; axis(ax); title('N2O ppmv')

figure(3); plot(ppmvLAY6,pavgLAY6); set(gca,'ydir','reverse'); set(gca,'yscale','log');
  ax = axis; ax(3) = 0.001; ax(4) = 1000; axis(ax); title('CH4 ppmv')

%{
save profiles_for_paper.mat ppmvLAY2 pavgLAY2 ppmvLAY2x pavgLAY2x ppmvLAY4 pavgLAY4 ppmvLAY6 pavgLAY6
%}
