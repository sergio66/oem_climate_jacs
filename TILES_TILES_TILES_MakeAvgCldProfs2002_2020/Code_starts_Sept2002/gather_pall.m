function [pnew] = gather_pall(h2x,pall,iPlot);

pnew = pall.pavg(1);
xnames = fieldnames(pnew);
for ii = 2 : length(pall.pavg)
  pjunk = pall.pavg(ii);
  [hjunk,pnew] = cat_rtp(h2x,pnew,h2x,pjunk);
end

if nargin == 2
  iPlot = -1;
end

if iPlot < 0
  return
end

str = [    num2str(pall.yymmddS(1)) '/' num2str(pall.yymmddS(2),'%02d') '/' num2str(pall.yymmddS(3),'%02d') '-'];
str = [str num2str(pall.yymmddE(1)) '/' num2str(pall.yymmddE(2),'%02d') '/' num2str(pall.yymmddE(3),'%02d')    ];

figure(1); simplemap(pnew.rlat,pnew.rlon,pnew.stemp,5); title(['Stemp ' str])
  caxis([200 320])
figure(2); simplemap(pnew.rlat,pnew.rlon,pnew.mmw,5);   title(['mmw ' str])
  caxis([0 60])
figure(3); simplemap(pnew.rlat,pnew.rlon,rad2bt(1231,pnew.sarta_rclearcalc(5,:)),5); title(['BT1231 clr ' str]);
  caxis([200 320])
figure(4); simplemap(pnew.rlat,pnew.rlon,rad2bt(1231,pnew.rcalc(5,:)),5);            title(['BT 1231 cld ' str]);
  caxis([200 320])

disp('ret to continue'); pause
pause(1);

figure(1); simplemap(pnew.rlat,pnew.rlon,pnew.iceOD,5);   title(['IceOD ' str])
  caxis([0 5])
figure(2); simplemap(pnew.rlat,pnew.rlon,pnew.icesze,5);  title(['icesze ' str ' (um)'])
  caxis([20 160])
figure(3); simplemap(pnew.rlat,pnew.rlon,pnew.icetop,5);  title(['Icetop ' str ' (mb)'])
  caxis([100 600])
figure(4); simplemap(pnew.rlat,pnew.rlon,pnew.icefrac,5); title(['icefrac ' str '(0-1)'])
  caxis([0 1])

disp('ret to continue'); pause
pause(1);

figure(1); simplemap(pnew.rlat,pnew.rlon,pnew.waterOD,5);   title(['WaterOD ' str])
  caxis([0 40])
figure(2); simplemap(pnew.rlat,pnew.rlon,pnew.watersze,5);  title(['watersze ' str ' (um)'])
  caxis([15 25])
figure(3); simplemap(pnew.rlat,pnew.rlon,pnew.watertop,5);  title(['Watertop ' str ' (mb)'])
  caxis([300 1000])
figure(4); simplemap(pnew.rlat,pnew.rlon,pnew.waterfrac,5); title(['waterfrac ' str '(0-1)'])
  caxis([0 1])
