clc

disp('checking the 10 jacs from CO2_370_385_400_415_12p4 and CO2_370_385_400_415_12p8 (CO2 = 370 375 380 385 390 395 400 405 410 415')
old = load('CO2_370_385_400_415_12p4/co2_jac_2834_latbin21.mat');
new = load('CO2_370_385_400_415_12p8/co2_jac_2834_latbin21.mat');

figure(1); plot(old.fc,old.qcx); axis([640 840 -0.1 +0.1]); title('12.4 jacs from CO2\_370\_385\_400\_415\_12p4'); grid
figure(2); plot(old.fc,old.qcx ./ new.qcx); axis([640 840 0.95 1.05]); title('12.4/12.8 jacs from \newline CO2\_370\_385\_400\_415\_12p4/12.8'); grid
disp('ret to continue'); pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('checking the same jacs individually <370 ppm>')

addpath /home/sergio/MATLABCODE
addpath /home/sergio/KCARTA/MATLAB

[d4,w] = readkcstd('CO2_370_385_400_415_12p4/junkCO2_latbin_21_co2pert_1.dat');
[d8,w] = readkcstd('CO2_370_385_400_415_12p8/junkCO2_latbin_21_co2pert_1.dat');

[j4,w] = readkcBasic('CO2_370_385_400_415_12p4/junkCO2_latbin_21_co2pert_1.jac_COL');
[j8,w] = readkcBasic('CO2_370_385_400_415_12p8/junkCO2_latbin_21_co2pert_1.jac_COL');

[fc,qc] = quickconvolve(w,[d4 d8],0.5,0.5); tc = rad2bt(fc,qc);
figure(3); subplot(211); plot(fc,tc); axis([640 840 200 300]); grid
figure(3); subplot(212); plot(fc,tc(:,2)-tc(:,1)); axis([640 840 -0.4 +0.4]); grid
disp('A ret to continue'); pause

[fc,qcx] = quickconvolve(w,[j4(:,1) j8(:,1)],0.5,0.5); tcx = rad2bt(fc,qcx);
figure(3); subplot(211); plot(fc,tcx); axis([640 840 200 300]); grid
figure(3); subplot(212); plot(fc,tcx(:,2)-tcx(:,1)); axis([640 840 -0.4 +0.4]); grid
disp('B ret to continue'); pause

figure(3); subplot(211); plot(fc,tc,'b',fc,tcx,'r'); axis([640 840 200 300]); grid
figure(3); subplot(212); plot(fc,tc(:,2)-tc(:,1),'b',fc,tcx(:,2)-tcx(:,1),'r'); axis([640 840 -0.4 +0.4]); grid
disp('C ret to continue'); pause

jac4 = rad2bt(w,j4(:,1)) - rad2bt(w,d4);
jac8 = rad2bt(w,j8(:,1)) - rad2bt(w,d8);
[fc,jc370] = quickconvolve(w,[jac4 jac8],0.5,0.5); 

figure(3)
subplot(211); plot(fc,jc370(:,1)*2.2/370/0.1);   axis([640 840 -0.1 +0.1]); grid on; title('jac at 370 ppm')
subplot(212); plot(fc,diff(jc370')*2.2/370/0.1); axis([640 840 -0.002 +0.002]); grid on; ylabel('12.8-12.4')

savedjc370 = jc370*2.2/370/0.1;

disp('ret to continue'); pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('checking the same jacs individually <415 ppm>')

addpath /home/sergio/MATLABCODE
addpath /home/sergio/KCARTA/MATLAB

[d4,w] = readkcstd('CO2_370_385_400_415_12p4/junkCO2_latbin_21_co2pert_10.dat');
[d8,w] = readkcstd('CO2_370_385_400_415_12p8/junkCO2_latbin_21_co2pert_10.dat');

[j4,w] = readkcBasic('CO2_370_385_400_415_12p4/junkCO2_latbin_21_co2pert_10.jac_COL');
[j8,w] = readkcBasic('CO2_370_385_400_415_12p8/junkCO2_latbin_21_co2pert_10.jac_COL');

jac4 = rad2bt(w,j4(:,1)) - rad2bt(w,d4);
jac8 = rad2bt(w,j8(:,1)) - rad2bt(w,d8);
[fc,jc415] = quickconvolve(w,[jac4 jac8],0.5,0.5); 

figure(4)
subplot(211); plot(fc,jc415(:,1)*2.2/415/0.1);   axis([640 840 -0.1 +0.1]); grid on; title('jac at 415 ppm')
subplot(212); plot(fc,diff(jc415')*2.2/415/0.1); axis([640 840 -0.002 +0.002]); grid on; ylabel('12.8-12.4')

savedjc415 = jc415*2.2/415/0.1;

disp('ret to continue'); pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('this is KEY!!!!')
figure(5); subplot(211); plot(fc,jc370./jc415); axis([640 840 0.5 1.5]); grid; ylabel('raw 370/415'); title('this is KEY')
figure(5); subplot(212); plot(fc,savedjc370./savedjc415); axis([640 840 0.5 1.5]); grid; ylabel('renorm 370/415')

disp('ret to continue'); pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('now compare these handmade jacs to what OEM is using ie compare old/new vs savedjc')
figure(6); plot(old.fc,new.qcx(:,1),'b',old.fc,new.qcx(:,10),'r'); title('what OEM uses 12.8 at 370,415 ppm'); axis([640 840 -0.1 +0.1]); grid on
figure(6); plot(fc,savedjc370(:,2),'b',fc,savedjc415(:,2),'r'); 
  title('what I did by hand (v12.8) at 370,415 ppm'); axis([640 840 -0.1 +0.1]); grid on

figure(6); 
  plot(old.fc,new.qcx(:,1),'b.-',old.fc,new.qcx(:,10),'r.-',fc,savedjc370(:,2),'c',fc,savedjc415(:,2),'m'); 
  axis([640 840 -0.1 +0.1]); grid on; title('So this is what OEM pkg uses : renormed stuff')
