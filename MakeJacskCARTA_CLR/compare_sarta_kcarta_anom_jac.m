addpath /home/sergio/MATLABCODE

disp('first comparing SARTA clear sky jacs for TimeStep X')

iLatBin = input('Enter latbin (default 20) : ');
if length(iLatBin) == 0
  iLatBin = 20;
end

iTimeStep = input('Enter timestep (default 200) : ');
if length(iTimeStep) == 0
  iTimeStep = 200;
end

%{
ls -lt /asl/s1/sergio/MakeJacsSARTA/
drwxrwxr-x 369 sergio pi_strow 8192 Aug  8 05:10 SARTA_AIRSL1c_Anomaly365_16_no_seasonal_NewSarta
drwxrwxr-x 369 sergio pi_strow 8192 Aug  6 16:19 SARTA_AIRSL1c_Anomaly365_16_no_seasonal_NewSarta_oldDT=1_oldDQ=0.01
drwxrwxr-x 368 sergio pi_strow 8192 Aug  5 04:38 SARTA_AIRSL1c_Anomaly365_16_with_seasonal_OldSarta_largepert
drwxrwxr-x 369 sergio pi_strow 8192 Aug  5 04:36 SARTA_AIRSL1c_Anomaly365_16_no_seasonal_OldSarta_largepert
%}

a1 = load(['/asl/s1/sergio/MakeJacsSARTA/SARTA_AIRSL1c_Anomaly365_16_no_seasonal_NewSarta_oldDT=1_oldDQ=0.01/' num2str(iTimeStep,'%03d') '//xprofile' num2str(iLatBin) '.mat']);    %% new sarta, large perts     dQ=0.01
a2oops = load(['/asl/s1/sergio/MakeJacsSARTA/SARTA_AIRSL1c_Anomaly365_16_no_seasonal_NewSarta_dT=0.01_dQ=0.0001/' num2str(iTimeStep,'%03d') '/xprofile' num2str(iLatBin) '.mat']);  %% new sarta, too small perts dQ=0.0001
a2 = load(['../MakeJacsSARTA/SARTA_AIRSL1c_Anomaly365_16/' num2str(iTimeStep,'%03d') '/xprofile' num2str(iLatBin) '.mat']);                                                         %% new sarta, small perts     dQ=0.005

a3 = load(['../MakeJacsSARTA/SARTA_AIRSL1c_Anomaly365_16_no_seasonal_OldSarta_largepert/' num2str(iTimeStep,'%03d') '//xprofile' num2str(iLatBin) '.mat']);                         %% old sarta, large perts     dQ=0.01
a4 = load(['../MakeJacsSARTA/SARTA_AIRSL1c_Anomaly365_16_no_seasonal_OldSarta_smallpert/' num2str(iTimeStep,'%03d') '//xprofile' num2str(iLatBin) '.mat']);                         %% old sarta, small perts     dQ=0.005

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% always want x="new" y = "old"

iType = input('Enter (-2) old sarta, large vs small perts (-1) old vs new sarta, large perts (+1) default old vs new sarta, small perts (+2) new sarta, large vs small perts : ');
if length(iType) == 0
  iType = 1;
end

if iType == 1
  x = a4;  %% old sarta, small perts
  y = a2;  %% new sarta, small perts
elseif iType == -1
  x = a3;  %% old sarta, large perts
  y = a1;  %% new sarta, large perts
elseif iType == -2
  x = a3;  %% old sarta, large perts
  y = a4;  %% old sarta, small perts
elseif iType == +2
  x = a1;  %% new sarta, large perts
  y = a2;  %% new sarta, small perts
end


k = load(['../MakeJacskCARTA_CLR/Anomaly365_16_12p8/' num2str(iTimeStep,'%03d') '/jac_results_' num2str(iLatBin) '.mat']);  %% kcarta

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1); clf
figure(2); clf

plot(x.hx.vchan,x.aM_TS_jac(:,5)-y.aM_TS_jac(:,5)); title('stemp jac')

indT = (1:97) + 1*97+5;
indW = (1:97) + 0*97+5;
indO = (1:97) + 2*97+5;

iTorW = input('Enter (-1) WV (0) ozone (+1) T (default +1) : ');
if length(iTorW) == 0
  iTorW = 1;
end

if iTorW > 0
  ind = indT;
  str = 'T jac';
elseif iTorW < 0
  ind = indW;
  str = 'WV jac';
elseif iTorW == 0
  ind = indO;
  str = 'O3 jac';
end

indLow = ind(50:end);

figure(1)
subplot(212); plot(x.hx.vchan,sum(x.aM_TS_jac(:,ind)'),x.hx.vchan,sum(y.aM_TS_jac(:,ind)'))
  ax = axis; ax(1) = 650; ax(2) = 2780; axis(ax);
  plotaxis2;
subplot(211); plot(x.hx.vchan,100 * sum(x.aM_TS_jac(:,ind)')-sum(y.aM_TS_jac(:,ind)') ./ sum(x.aM_TS_jac(:,ind)'))
  ax = axis; ax(1) = 650; ax(2) = 2780; axis(ax);
  title(['percent diff new-old column ' str])
  plotaxis2;
disp('ret to continue'); pause;

oldX = sum(x.aM_TS_jac(:,ind)');
newX = sum(y.aM_TS_jac(:,ind)');

oldXLow = sum(x.aM_TS_jac(:,indLow)');
newXLow = sum(y.aM_TS_jac(:,indLow)');

if iTorW > 0
  k.tempr = fliplr(k.tempr) + eps;
  kcX = sum(k.tempr')/100 + eps;
  kcXLow = sum(k.tempr(:,50:97)')/100 + eps;

  kk = k.tempr/100 + eps;
  xx = x.aM_TS_jac(:,ind) + eps;
  yy = y.aM_TS_jac(:,ind) + eps;
  for ii=1:97  
    figure(1)
    subplot(211); plot(x.hx.vchan,100 * (kk(:,ii)-xx(:,ii))./kk(:,ii),'b',x.hx.vchan,100 * (kk(:,ii)-yy(:,ii))./kk(:,ii),'r');
      title(['kcarta - (b) old (r) new ' num2str(ii) ' jacs']); ylabel('percent diff')
      ax = axis; ax(3) = -50; ax(4) = +50; axis(ax);
      plotaxis2;
    subplot(212); plot(x.hx.vchan,xx(:,ii),'b',x.hx.vchan,yy(:,ii),'r',x.hx.vchan,kk(:,ii),'k'); ylabel(str)
      plotaxis2;
    pause(0.1)
  end

  figure(1)
  subplot(211); plot(x.hx.vchan,100 * (kcX-oldX)./kcX,'b',x.hx.vchan,100 * (kcX-newX)./kcX,'r');
    title('kcarta - (b) old (r) new columnX jacs'); ylabel('percent diff')
    axis([650 2780 -10 +10]); grid
    plotaxis2;
  subplot(212); plot(x.hx.vchan,oldX,'b',x.hx.vchan,newX,'r',x.hx.vchan,kcX,'k'); ylabel(str)
    axis([650 2780 0 0.012]); grid
    plotaxis2;

  figure(2);
  subplot(211); plot(x.hx.vchan,100 * (kcXLow-oldXLow)./kcXLow,'b',x.hx.vchan,100 * (kcXLow-newXLow)./kcXLow,'r');
    title('lower kcarta - (b) old (r) new columnXLow jacs'); ylabel('percent diff')
    axis([650 2780 -20 +20]); grid
    plotaxis2;
  subplot(212); plot(x.hx.vchan,oldXLow,'b',x.hx.vchan,newXLow,'r',x.hx.vchan,kcXLow,'k'); ylabel(str)
    axis([650 2780 0 0.012]); grid
    plotaxis2;
  disp('ret to continue'); pause;

  %%%%%

  figure(1)
  subplot(211); plot(x.hx.vchan,100 * (kcX-oldX)./kcX,'b',x.hx.vchan,100 * (kcX-newX)./kcX,'r');
    title('kcarta - (b) old (r) new columnX jacs'); ylabel('percent diff')
    axis([650 840 -10 +10]); grid
    plotaxis2;
  subplot(212); plot(x.hx.vchan,oldX,'b',x.hx.vchan,newX,'r',x.hx.vchan,kcX,'k'); ylabel(str)
    axis([650 840 0 0.02]); grid
    plotaxis2;

  figure(2)
  subplot(211); plot(x.hx.vchan,100 * (kcXLow-oldXLow)./kcXLow,'b',x.hx.vchan,100 * (kcXLow-newXLow)./kcXLow,'r');
    title('lower kcarta - (b) old (r) new columnXLow jacs'); ylabel('percent diff')
    axis([650 840 -10 +10]); grid
    plotaxis2;
  subplot(212); plot(x.hx.vchan,oldXLow,'b',x.hx.vchan,newXLow,'r',x.hx.vchan,kcXLow,'k'); ylabel(str)
    axis([650 840 -0.02 0.02]); grid
    plotaxis2;
  disp('ret to continue'); pause;

elseif iTorW < 0
  k.water = fliplr(k.water) + eps;
  kcX = sum(k.water')/100 + eps;
  kcXLow = sum(k.water(:,50:97)')/100 + eps;

  kk = k.water/100 + eps;
  xx = x.aM_TS_jac(:,ind) + eps;
  yy = y.aM_TS_jac(:,ind) + eps;
  for ii=1:97  
    figure(1)
    subplot(211); plot(x.hx.vchan,100 * (kk(:,ii)-xx(:,ii))./kk(:,ii),'b',x.hx.vchan,100 * (kk(:,ii)-yy(:,ii))./kk(:,ii),'r');
      title(['kcarta - (b) old (r) new ' num2str(ii) ' jacs']); ylabel('percent diff')
      ax = axis; ax(3) = -50; ax(4) = +50; axis(ax);
      plotaxis2;
    subplot(212); plot(x.hx.vchan,xx(:,ii),'b',x.hx.vchan,yy(:,ii),'r',x.hx.vchan,kk(:,ii),'k'); ylabel(str)
      plotaxis2;
    
    figure(2); clf
    plot(x.hx.vchan,xx(:,ii),'b',x.hx.vchan,yy(:,ii),'r',x.hx.vchan,kk(:,ii),'k'); ylabel(str)
    ax = axis;
    if ii < 50
      ax(1) = 1240; ax(2) = 1640; axis(ax);
    elseif ii >= 50
      ax(1) = 740; ax(2) = 1640; axis(ax);
    end
    %disp('ret to continue'); pause
    pause(0.1)
  end

  figure(1)
  subplot(211); plot(x.hx.vchan,100 * (kcX-oldX)./kcX,'b',x.hx.vchan,100 * (kcX-newX)./kcX,'r');
    title('kcarta - (b) old (r) new columnX jacs'); ylabel('percent diff')
    axis([650 2780 -50 +50]); grid
    plotaxis2;
  subplot(212); plot(x.hx.vchan,oldX,'b',x.hx.vchan,newX,'r',x.hx.vchan,kcX,'k'); ylabel(str)
    axis([650 2780 -0.14 0]); grid
    plotaxis2;

  figure(2)
  subplot(211); plot(x.hx.vchan,100 * (kcXLow-oldXLow)./kcXLow,'b',x.hx.vchan,100 * (kcXLow-newXLow)./kcXLow,'r');
    title('lower kcarta - (b) old (r) new columnXLow jacs'); ylabel('percent diff')
    axis([650 2780 -50 +50]); grid
    plotaxis2;
  subplot(212); plot(x.hx.vchan,oldXLow,'b',x.hx.vchan,newXLow,'r',x.hx.vchan,kcXLow,'k'); ylabel(str)
    axis([650 2780 -0.14 0]); grid
    plotaxis2;
  disp('ret to continue'); pause;

  figure(1)
  subplot(211); plot(x.hx.vchan,100 * (kcX-oldX)./kcX,'b',x.hx.vchan,100 * (kcX-newX)./kcX,'r');
    title('kcarta - (b) old (r) new columnX jacs'); ylabel('percent diff')
    axis([740 1650 -50 +50]); grid
    plotaxis2;
  subplot(212); plot(x.hx.vchan,oldX,'b',x.hx.vchan,newX,'r',x.hx.vchan,kcX,'k'); ylabel(str)
    axis([740 1650 -0.14 0]); grid
    plotaxis2;

  figure(2)
  subplot(211); plot(x.hx.vchan,100 * (kcXLow-oldXLow)./kcXLow,'b',x.hx.vchan,100 * (kcXLow-newXLow)./kcXLow,'r');
    title('lower kcarta - (b) old (r) new columnXLow jacs'); ylabel('percent diff')
    axis([740 1650 -50 +50]); grid
    plotaxis2;
  subplot(212); plot(x.hx.vchan,oldXLow,'b',x.hx.vchan,newXLow,'r',x.hx.vchan,kcXLow,'k'); ylabel(str)
    axis([740 1650 -0.14 0]); grid
    plotaxis2;
  disp('ret to continue'); pause;

elseif iTorW == 0
  k.ozone = fliplr(k.ozone) + eps;
  kcX = sum(k.ozone')/100 + eps;
  kcXLow = sum(k.ozone(:,50:97)')/100 + eps;

  kk = k.ozone/100 + eps;
  xx = x.aM_TS_jac(:,ind) + eps;
  yy = y.aM_TS_jac(:,ind) + eps;
  for ii=1:97  
    figure(1)
    subplot(211); plot(x.hx.vchan,100 * (kk(:,ii)-xx(:,ii))./kk(:,ii),'b',x.hx.vchan,100 * (kk(:,ii)-yy(:,ii))./kk(:,ii),'r');
      title(['kcarta - (b) old (r) new ' num2str(ii) ' jacs']); ylabel('percent diff')
      ax = axis; ax(3) = -50; ax(4) = +50; axis(ax);
      plotaxis2;
    subplot(212); plot(x.hx.vchan,xx(:,ii),'b',x.hx.vchan,yy(:,ii),'r',x.hx.vchan,kk(:,ii),'k'); ylabel(str)
      plotaxis2;
    pause(0.1)
  end

  figure(1)
  subplot(211); plot(x.hx.vchan,100 * (kcX-oldX)./kcX,'b',x.hx.vchan,100 * (kcX-newX)./kcX,'r');
    title('kcarta - (b) old (r) new columnX jacs'); ylabel('percent diff')
    axis([650 2780 -50 +50]); grid
    plotaxis2;
  subplot(212); plot(x.hx.vchan,oldX,'b',x.hx.vchan,newX,'r',x.hx.vchan,kcX,'k'); ylabel(str)
    axis([650 2780 -0.14 0]); grid
    plotaxis2;

  figure(2)
  subplot(211); plot(x.hx.vchan,100 * (kcXLow-oldXLow)./kcXLow,'b',x.hx.vchan,100 * (kcXLow-newXLow)./kcXLow,'r');
    title('lower kcarta - (b) old (r) new columnXLow jacs'); ylabel('percent diff')
    axis([650 2780 -50 +50]); grid
    plotaxis2;
  subplot(212); plot(x.hx.vchan,oldXLow,'b',x.hx.vchan,newXLow,'r',x.hx.vchan,kcXLow,'k'); ylabel(str)
    axis([650 2780 -0.14 0]); grid
    plotaxis2;
  disp('ret to continue'); pause;

  figure(1)
  subplot(211); plot(x.hx.vchan,100 * (kcX-oldX)./kcX,'b',x.hx.vchan,100 * (kcX-newX)./kcX,'r');
    title('kcarta - (b) old (r) new columnX jacs'); ylabel('percent diff')
    axis([740 1650 -50 +50]); grid
    plotaxis2;
  subplot(212); plot(x.hx.vchan,oldX,'b',x.hx.vchan,newX,'r',x.hx.vchan,kcX,'k'); ylabel(str)
    axis([740 1650 -0.14 0]); grid
    plotaxis2;

  figure(2)
  subplot(211); plot(x.hx.vchan,100 * (kcXLow-oldXLow)./kcXLow,'b',x.hx.vchan,100 * (kcXLow-newXLow)./kcXLow,'r');
    title('lower kcarta - (b) old (r) new columnXLow jacs'); ylabel('percent diff')
    axis([740 1650 -50 +50]); grid
    plotaxis2;
  subplot(212); plot(x.hx.vchan,oldXLow,'b',x.hx.vchan,newXLow,'r',x.hx.vchan,kcXLow,'k'); ylabel(str)
    axis([740 1650 -0.14 0]); grid
    plotaxis2;
  disp('ret to continue'); pause;


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
