addpath /asl/matlib/rtptools/
addpath /asl/matlib/aslutil
addpath /asl/matlib/h4tools
addpath /asl/matlib/science/
addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/matlib/clouds/sarta
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS

KtoC = 273.15;

rlat = load('/home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/latB64.mat'); rlat65 = rlat.latB2; rlat = 0.5*(rlat.latB2(1:end-1)+rlat.latB2(2:end));
rlon73 = (1:73); rlon73 = -180 + (rlon73-1)*5;  rlon = (1:72); rlon = -177.5 + (rlon-1)*5;
[Y,X] = meshgrid(rlat,rlon); 
[salti, landfrac] = usgs_deg10_dem(Y,X);

lf = landfrac; lf = lf(:);
XX = X; XX = XX(:); %% MAN THIS IS CONFUSING BUT IT IS RIGHT  ie do not do XX = X'; see pcolor below
YY = Y; YY = YY(:); %% MAN THIS IS CONFUSING BUT IT IS RIGHT  ie do not do XX = X'; see pcolor below

globalmean = squeeze(nanmean(timeseries1231(:,3,:),1));
plot(nanmean(thetime,1),rad2bt(fuse,globalmean));
plot(nanmean(thetime,1),rad2bt(fuse,globalmean)-nanmean(rad2bt(fuse,globalmean)));grid

tropics = find(abs(YY) <= 30);
tml     = find(abs(YY) <= 60 & lf == 0);
polar   = find(abs(YY) > 60);

tS = [2003 2008 2013 2018 2020 2022 2023 2024];

clear str
for yy = 1 : length(tS)-1
  if tS(yy+1)-tS(yy) > 1
    str{yy} = [num2str(tS(yy)) '/01 to ' num2str(tS(yy+1)-1) '/12'];
    str{yy} = [num2str(tS(yy)) '-' num2str(tS(yy+1)-1)];
  else
    str{yy} = [num2str(tS(yy))];
 end
end

iQshow = 3;
iQshow = 5;
iQshow = input('Enter quantile to show (1-5) [default 3] : ');
if length(iQshow) == 0
  iQshow = 3;
end

iMaxMeanMin = input('Plot the (-1) min (0/[default]) mean (+1) max vlaue for the month : ');
if length(iMaxMeanMin) == 0
  iMaxMeanMin = 0;
end

clear meanrad meanbt stdrad stdbt
figure(1); clf
for yy = 1 : length(tS)-1
  for mm = 1 : 12
    boo = find(savedate(:,1) >= tS(yy) & savedate(:,1) < tS(yy+1) & savedate(:,2) == mm);
    junk = squeeze(timeseries1231(:,iQshow,boo));
    junk = nanmean(junk,2);
%    pcolor(reshape(XX,72,64),reshape(YY,72,64),reshape(junk,72,64)); shading flat
    junkx = junk(tropics,:);
    junkx = junk(tml,:);

%    meanrad(yy,mm) = nanmean(junkx);
%    stdrad(yy,mm)  = nanstd(junkx);
%    oox = rad2bt(fuse,junkx);
%    meanbt(yy,mm) = nanmean(oox);
%    stdbt(yy,mm)  = nanstd(oox);

    if iMaxMeanMin == -1
      meanrad(yy,mm) = nanmin(junkx);
    elseif iMaxMeanMin == 0
      meanrad(yy,mm) = nanmean(junkx);
    elseif iMaxMeanMin == +1
      meanrad(yy,mm) = nanmax(junkx);
    end
    stdrad(yy,mm)  = nanstd(junkx);

    oox = rad2bt(fuse,junkx);
    if iMaxMeanMin == -1
      meanbt(yy,mm) = nanmin(oox);
    elseif iMaxMeanMin == 0
      meanbt(yy,mm) = nanmean(oox);
    elseif iMaxMeanMin == +1
      meanbt(yy,mm) = nanmax(oox);
    end
    stdbt(yy,mm)  = nanstd(oox);
  end
end
clf; plot((1:12)+0.5,rad2bt(fuse,meanrad(1:length(tS)-2,:)),'linewidth',2)
hold on; plot((1:12)+0.5,rad2bt(fuse,meanrad(length(tS)-1,:)),'x-','linewidth',4); hold off
clf; plot((1:12)+0.5,meanbt(1:length(tS)-2,:),'linewidth',2)
hold on; plot((1:12)+0.5,meanbt(length(tS)-1,:),'x-','linewidth',4); hold off
%hl = legend('2003/01-2007/12','2008/01-2012/12','2013/01-2017/12','2018/01-2019/12','2020/01-2021/12','2022/01-2022/12','2023/01-2023/12','location','best','fontsize',8);
hl = legend(str,'location','best','fontsize',8);
xlim([1 13])
names = {'J';'F';'M';'A';'M';'J';'J';'A';'S';'O';'N';'D'};
set(gca,'xtick',[1:12],'xticklabel',names)
ylabel(['BT ' num2str(fuse) ' K']); grid;
title('TML = -60S to +60N')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2); clf
clear meanskt stdskt
for yy = 1 : length(tS)-1
  for mm = 1 : 12
    boo = find(savedate(:,1) >= tS(yy) & savedate(:,1) < tS(yy+1) & savedate(:,2) == mm);
    junk = squeeze(timeseriesSKT(:,max(iQshow-2,1),boo));
    junk = nanmean(junk,2);
%    pcolor(reshape(XX,72,64),reshape(YY,72,64),reshape(junk,72,64)); shading flat
    junkx = junk(tropics,:);
    junkx = junk(tml,:);
    if iMaxMeanMin == -1
      meanskt(yy,mm) = nanmin(junkx);
    elseif iMaxMeanMin == 0
      meanskt(yy,mm) = nanmean(junkx);
    elseif iMaxMeanMin == +1
      meanskt(yy,mm) = nanmax(junkx);
    end
    stdskt(yy,mm)   = nanstd(junkx);
  end
end
plot((1:12)+0.5,meanskt(1:length(tS)-2,:)-273.15,'linewidth',2)
hold on; plot((1:12)+0.5,meanskt(length(tS)-1,:)-273.15,'x-','linewidth',4); hold off
%hl = legend('2003/01-2007/12','2008/01-2012/12','2013/01-2017/12','2018/01-2019/12','2020/01-2021/12','2022/01-2022/12','2023/01-2023/12','location','best','fontsize',8);
hl = legend(str,'location','best','fontsize',8);
xlim([1 13])
names = {'J';'F';'M';'A';'M';'J';'J';'A';'S';'O';'N';'D'};
set(gca,'xtick',[1:12],'xticklabel',names)
ylabel('SKT deg C'); grid;
title('TML = -60S to +60N')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear meanrad meanbt stdrad stdbt
custom = input('Enter [Start Stop] latitude : [] to quit ');
if length(custom) == 0 | length(custom) == 1 | length(custom) > 2
  return
end

custom = sort(custom);
custom = find(YY >= custom(1) & YY < custom(2));

tS = [2003 2008 2013 2018 2020 2022 2023 2024]
disp('this is current years to show : enter yours!!!');
tS = input('Enter your years [-1 for default] : ');
if length(tS) == 0
  tS = [2003 2008 2013 2018 2020 2022 2023 2024];
end
tS = sort(tS);

clear str
for yy = 1 : length(tS)-1
  if tS(yy+1)-tS(yy) > 1
    str{yy} = [num2str(tS(yy)) '/01 to ' num2str(tS(yy+1)-1) '/12'];
    str{yy} = [num2str(tS(yy)) '-' num2str(tS(yy+1)-1)];
  else
    str{yy} = [num2str(tS(yy))];
 end
end

for yy = 1 : length(tS)-1
  for mm = 1 : 12
    boo = find(savedate(:,1) >= tS(yy) & savedate(:,1) < tS(yy+1) & savedate(:,2) == mm);
    junk = squeeze(timeseries1231(:,iQshow,boo));
    junk = nanmean(junk,2);
%    pcolor(reshape(XX,72,64),reshape(YY,72,64),reshape(junk,72,64)); shading flat
    junkx = junk(tropics,:);
    junkx = junk(tml,:);
    junkx = junk(custom,:);

    if iMaxMeanMin == -1
      meanrad(yy,mm) = nanmin(junkx);
    elseif iMaxMeanMin == 0
      meanrad(yy,mm) = nanmean(junkx);
    elseif iMaxMeanMin == +1
      meanrad(yy,mm) = nanmax(junkx);
    end
    stdrad(yy,mm)  = nanstd(junkx);

    oox = rad2bt(fuse,junkx);
    if iMaxMeanMin == -1
      meanbt(yy,mm) = nanmin(oox);
    elseif iMaxMeanMin == 0
      meanbt(yy,mm) = nanmean(oox);
    elseif iMaxMeanMin == +1
      meanbt(yy,mm) = nanmax(oox);
    end
    stdbt(yy,mm)  = nanstd(oox);

  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3); 
clf; plot((1:12)+0.5,rad2bt(fuse,meanrad(1:length(tS)-2,:)),'linewidth',2)
hold on; plot((1:12)+0.5,rad2bt(fuse,meanrad(length(tS)-1,:)),'x-','linewidth',4); hold off
clf; plot((1:12)+0.5,meanbt(1:length(tS)-2,:),'linewidth',2)
hold on; plot((1:12)+0.5,meanbt(length(tS)-1,:),'x-','linewidth',4); hold off
%hl = legend('2003/01-2007/12','2008/01-2012/12','2013/01-2017/12','2018/01-2019/12','2020/01-2021/12','2022/01-2022/12','2023/01-2023/12','location','best','fontsize',8);
%hl = legend(num2str((1:length(tS)-1)'),'location','best','fontsize',8);
hl = legend(str,'location','best','fontsize',8);
xlim([1 13])
names = {'J';'F';'M';'A';'M';'J';'J';'A';'S';'O';'N';'D'};
set(gca,'xtick',[1:12],'xticklabel',names)
ylabel(['BT ' num2str(fuse) ' K']); grid;
title('Custom Lats')

figure(4); clf;
yowzaa = nanmean(meanbt,1); 
clf; plot((1:12)+0.5,meanbt(1:length(tS)-2,:)-yowzaa,'linewidth',2)
hold on; plot((1:12)+0.5,meanbt(length(tS)-1,:)-yowzaa,'x-','linewidth',4); hold off
plotaxis2;
hl = legend(str,'location','best','fontsize',8);
xlim([1 13])
names = {'J';'F';'M';'A';'M';'J';'J';'A';'S';'O';'N';'D'};
set(gca,'xtick',[1:12],'xticklabel',names)
ylabel(['BT ' num2str(fuse) ' K anomaly ']); grid;
title('Custom Lats')

figure(5); clf;
zoo = (length(tS)-1)/2;
for moo = 1:length(tS)-2
  errorbar(((1:12)+0.5)+(moo-zoo)/length(tS),meanbt(moo,:),stdbt(moo,:),'linewidth',2)
  hold on
end
moo = length(tS)-1;
  errorbar(((1:12)+0.5)+(moo-zoo)/length(tS),meanbt(moo,:),stdbt(moo,:),'linewidth',4)
  hold off
%hl = legend(num2str((1:length(tS)-1)'),'location','best','fontsize',8);
hl = legend(str,'location','best','fontsize',8);
xlim([1 13])
names = {'J';'F';'M';'A';'M';'J';'J';'A';'S';'O';'N';'D'};
set(gca,'xtick',[1:12],'xticklabel',names)
ylabel(['BT ' num2str(fuse) ' K']); grid;
title('Custom Lats')

if fChanID < 700
  yowzaa = nanmean(meanbt,1);
  bowzaa = meanbt-yowzaa;

  figure(6); clf
  plot(1:length(tS)-1,bowzaa(:,[1 2 3]),'linewidth',2); plotaxis2;
  set(gca,'xtick',[1:length(tS)-1],'xticklabel',str)
  title('January/Febraury/March')

  figure(7); clf
  plot(1:length(tS)-1,bowzaa(:,[7 8 9]),'linewidth',2); plotaxis2;
  set(gca,'xtick',[1:length(tS)-1],'xticklabel',str)
  title('Aug/Sept/Oct')
end
