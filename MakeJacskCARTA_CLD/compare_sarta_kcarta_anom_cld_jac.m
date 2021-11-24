addpath /home/sergio/MATLABCODE

disp('first comparing SARTA allsky jacs for TimeStep X')

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

x = load(['../MakeJacsSARTA/SARTA_AIRSL1c_Anomaly365_16_CLD/' num2str(iTimeStep,'%03d') '/xprofile' num2str(iLatBin) '.mat']);                                                         %% new sarta, small perts     dQ=0.005

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k = load(['../MakeJacskCARTA_CLD/Anomaly365_16_12p8/' num2str(iTimeStep,'%03d') '/jac_results_' num2str(iLatBin) '.mat']);  %% kcarta

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1); clf
figure(2); clf

indT = (1:97) + 1*97+12;
indW = (1:97) + 0*97+12;
indO = (1:97) + 2*97+12;

figure(1); clf
clf; plot(k.fKc,k.tracegas(:,1)*2.2/370,'b.-',k.fKc,x.aM_TS_jac(:,1),'r'); title('(b) kcarta (r) sarta : CO2'); disp('ret'); pause
clf; plot(k.fKc,k.tracegas(:,2)*1/300,'b.-',k.fKc,x.aM_TS_jac(:,2),'r'); title('(b) kcarta (r) sarta : N2O');   disp('ret'); pause
clf; plot(k.fKc,k.tracegas(:,3)*5/1860,'b.-',k.fKc,x.aM_TS_jac(:,3),'r'); title('(b) kcarta (r) sarta : CH4');  disp('ret'); pause
clf; plot(k.fKc,k.tracegas(:,4)*1/250,'b.-',k.fKc,x.aM_TS_jac(:,4),'r'); title('(b) kcarta (r) sarta : CFC11'); disp('ret'); pause
clf; plot(k.fKc,k.tracegas(:,5)*1/500,'b.-',k.fKc,x.aM_TS_jac(:,5),'r'); title('(b) kcarta (r) sarta : CFC12'); disp('ret'); pause
clf; plot(k.fKc,k.stemp*0.1,'b.-',k.fKc,x.aM_TS_jac(:,6),'r'); title('(b) kcarta (r) sarta : stemp');           disp('ret'); pause

clf; plot(k.fKc,k.stemp*0.0,'b.-',k.fKc,x.aM_TS_jac(:,07),'r'); title('sarta : CA1');  disp('ret'); pause
clf; plot(k.fKc,k.stemp*0.0,'b.-',k.fKc,x.aM_TS_jac(:,08),'r'); title('sarta : CA2');  disp('ret'); pause
clf; plot(k.fKc,k.stemp*0.0,'b.-',k.fKc,x.aM_TS_jac(:,09),'r'); title('sarta : CB1');  disp('ret'); pause
clf; plot(k.fKc,k.stemp*0.0,'b.-',k.fKc,x.aM_TS_jac(:,10),'r'); title('sarta : CB2');  disp('ret'); pause
clf; plot(k.fKc,k.stemp*0.0,'b.-',k.fKc,x.aM_TS_jac(:,11),'r'); title('sarta : CC1');  disp('ret'); pause
clf; plot(k.fKc,k.stemp*0.0,'b.-',k.fKc,x.aM_TS_jac(:,12),'r'); title('sarta : CC2');  disp('ret'); pause


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

oldX = sum(x.aM_TS_jac(:,ind)');
oldXLow = sum(x.aM_TS_jac(:,indLow)');

if iTorW > 0
  k.tempr = fliplr(k.tempr) + eps;
  kcX = sum(k.tempr')/100 + eps;
  kcXLow = sum(k.tempr(:,50:97)')/100 + eps;

  kk = k.tempr/100 + eps;
  xx = x.aM_TS_jac(:,ind) + eps;
  for ii=1:97  
    figure(1)
    subplot(211); plot(x.hx.vchan,100 * (kk(:,ii)-xx(:,ii))./kk(:,ii),'b.-')
      title(['kcarta - sarta ' num2str(ii) ' jacs']); ylabel('percent diff')
      ax = axis; ax(3) = -50; ax(4) = +50; axis(ax);
      plotaxis2;
    subplot(212); plot(x.hx.vchan,xx(:,ii),'b.-',x.hx.vchan,kk(:,ii),'k'); ylabel(str)
      plotaxis2;
    pause(0.1)
  end

  figure(1)
  subplot(211); plot(x.hx.vchan,100 * (kcX-oldX)./kcX,'b.-')
    title('kcarta - sarta new columnX jacs'); ylabel('percent diff')
    axis([650 2780 -10 +10]); grid
    plotaxis2;
  subplot(212); plot(x.hx.vchan,oldX,'b.-',x.hx.vchan,kcX,'k'); ylabel(str)
    axis([650 2780 0 0.012]); grid
    plotaxis2;

  figure(2);
  subplot(211); plot(x.hx.vchan,100 * (kcXLow-oldXLow)./kcXLow,'b.-')
    title('lower kcarta - sarta columnXLow jacs'); ylabel('percent diff')
    axis([650 2780 -20 +20]); grid
    plotaxis2;
  subplot(212); plot(x.hx.vchan,oldXLow,'b.-',x.hx.vchan,kcXLow,'k'); ylabel(str)
    axis([650 2780 0 0.012]); grid
    plotaxis2;
  disp('ret to continue'); pause;

  %%%%%

  figure(1)
  subplot(211); plot(x.hx.vchan,100 * (kcX-oldX)./kcX,'b.-')
    title('kcarta - sarta columnX jacs'); ylabel('percent diff')
    axis([650 840 -10 +10]); grid
    plotaxis2;
  subplot(212); plot(x.hx.vchan,oldX,'b.-',x.hx.vchan,kcX,'k'); ylabel(str)
    axis([650 840 0 0.02]); grid
    plotaxis2;

  figure(2)
  subplot(211); plot(x.hx.vchan,100 * (kcXLow-oldXLow)./kcXLow,'b.-')
    title('lower kcarta - sarta columnXLow jacs'); ylabel('percent diff')
    axis([650 840 -10 +10]); grid
    plotaxis2;
  subplot(212); plot(x.hx.vchan,oldXLow,'b.-',x.hx.vchan,kcXLow,'k'); ylabel(str)
    axis([650 840 -0.02 0.02]); grid
    plotaxis2;
  disp('ret to continue'); pause;

elseif iTorW < 0
  k.water = fliplr(k.water) + eps;
  kcX = sum(k.water')/100 + eps;
  kcXLow = sum(k.water(:,50:97)')/100 + eps;

  kk = k.water/100 + eps;
  xx = x.aM_TS_jac(:,ind) + eps;
  for ii=1:97  
    figure(1)
    subplot(211); plot(x.hx.vchan,100 * (kk(:,ii)-xx(:,ii))./kk(:,ii),'b.-')
      title(['kcarta - sarta ' num2str(ii) ' jacs']); ylabel('percent diff')
      ax = axis; ax(3) = -50; ax(4) = +50; axis(ax);
      plotaxis2;
    subplot(212); plot(x.hx.vchan,xx(:,ii),'b.-',x.hx.vchan,kk(:,ii),'k'); ylabel(str)
      plotaxis2;
    
    figure(2); clf
    plot(x.hx.vchan,xx(:,ii),'b.-',x.hx.vchan,kk(:,ii),'k'); ylabel(str)
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
  subplot(211); plot(x.hx.vchan,100 * (kcX-oldX)./kcX,'b.-')
    title('kcarta - sarta columnX jacs'); ylabel('percent diff')
    axis([650 2780 -50 +50]); grid
    plotaxis2;
  subplot(212); plot(x.hx.vchan,oldX,'b.-',x.hx.vchan,kcX,'k'); ylabel(str)
    axis([650 2780 -0.14 0]); grid
    plotaxis2;

  figure(2)
  subplot(211); plot(x.hx.vchan,100 * (kcXLow-oldXLow)./kcXLow,'b.-')
    title('lower kcarta - sarta columnXLow jacs'); ylabel('percent diff')
    axis([650 2780 -50 +50]); grid
    plotaxis2;
  subplot(212); plot(x.hx.vchan,oldXLow,'b.-',x.hx.vchan,kcXLow,'k'); ylabel(str)
    axis([650 2780 -0.14 0]); grid
    plotaxis2;
  disp('ret to continue'); pause;

  figure(1)
  subplot(211); plot(x.hx.vchan,100 * (kcX-oldX)./kcX,'b.-')
    title('kcarta - sarta columnX jacs'); ylabel('percent diff')
    axis([740 1650 -50 +50]); grid
    plotaxis2;
  subplot(212); plot(x.hx.vchan,oldX,'b.-',x.hx.vchan,kcX,'k'); ylabel(str)
    axis([740 1650 -0.14 0]); grid
    plotaxis2;

  figure(2)
  subplot(211); plot(x.hx.vchan,100 * (kcXLow-oldXLow)./kcXLow,'b.-')
    title('lower kcarta - columnXLow jacs'); ylabel('percent diff')
    axis([740 1650 -50 +50]); grid
    plotaxis2;
  subplot(212); plot(x.hx.vchan,oldXLow,'b.-',x.hx.vchan,kcXLow,'k'); ylabel(str)
    axis([740 1650 -0.14 0]); grid
    plotaxis2;
  disp('ret to continue'); pause;

elseif iTorW == 0
  k.ozone = fliplr(k.ozone) + eps;
  kcX = sum(k.ozone')/100 + eps;
  kcXLow = sum(k.ozone(:,50:97)')/100 + eps;

  kk = k.ozone/100 + eps;
  xx = x.aM_TS_jac(:,ind) + eps;
  for ii=1:97  
    figure(1)
    subplot(211); plot(x.hx.vchan,100 * (kk(:,ii)-xx(:,ii))./kk(:,ii),'b.-')
      title(['kcarta - sarta ' num2str(ii) ' jacs']); ylabel('percent diff')
      ax = axis; ax(3) = -50; ax(4) = +50; axis(ax);
      plotaxis2;
    subplot(212); plot(x.hx.vchan,xx(:,ii),'b.-',x.hx.vchan,kk(:,ii),'k'); ylabel(str)
      plotaxis2;
    pause(0.1)
  end

  figure(1)
  subplot(211); plot(x.hx.vchan,100 * (kcX-oldX)./kcX,'b.-')
    title('kcarta - sarta columnX jacs'); ylabel('percent diff')
    axis([650 2780 -50 +50]); grid
    plotaxis2;
  subplot(212); plot(x.hx.vchan,oldX,'b.-',x.hx.vchan,kcX,'k'); ylabel(str)
    axis([650 2780 -0.14 0]); grid
    plotaxis2;

  figure(2)
  subplot(211); plot(x.hx.vchan,100 * (kcXLow-oldXLow)./kcXLow,'b.-')
    title('lower kcarta - sarta columnXLow jacs'); ylabel('percent diff')
    axis([650 2780 -50 +50]); grid
    plotaxis2;
  subplot(212); plot(x.hx.vchan,oldXLow,'b.-',x.hx.vchan,kcXLow,'k'); ylabel(str)
    axis([650 2780 -0.14 0]); grid
    plotaxis2;
  disp('ret to continue'); pause;

  figure(1)
  subplot(211); plot(x.hx.vchan,100 * (kcX-oldX)./kcX,'b.-')
    title('kcarta - sarta columnX jacs'); ylabel('percent diff')
    axis([740 1650 -50 +50]); grid
    plotaxis2;
  subplot(212); plot(x.hx.vchan,oldX,'b.-',x.hx.vchan,kcX,'k'); ylabel(str)
    axis([740 1650 -0.14 0]); grid
    plotaxis2;

  figure(2)
  subplot(211); plot(x.hx.vchan,100 * (kcXLow-oldXLow)./kcXLow,'b.-')
    title('lower kcarta - sarta columnXLow jacs'); ylabel('percent diff')
    axis([740 1650 -50 +50]); grid
    plotaxis2;
  subplot(212); plot(x.hx.vchan,oldXLow,'b.-',x.hx.vchan,kcXLow,'k'); ylabel(str)
    axis([740 1650 -0.14 0]); grid
    plotaxis2;
  disp('ret to continue'); pause;


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
