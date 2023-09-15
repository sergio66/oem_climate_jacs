
rlat = load('/home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/latB64.mat'); rlat65 = rlat.latB2; rlat = 0.5*(rlat.latB2(1:end-1)+rlat.latB2(2:end));
rlon73 = (1:73); rlon73 = -180 + (rlon73-1)*5;  rlon = (1:72); rlon = -177.5 + (rlon-1)*5;
[Y,X] = meshgrid(rlat,rlon); 
[salti, landfrac] = usgs_deg10_dem(Y,X);

lf = landfrac; lf = lf(:);
XX = X; XX = XX(:); %% MAN THIS IS CONFUSING BUT IT IS RIGHT  ie do not do XX = X'; see pcolor below
YY = Y; YY = YY(:); %% MAN THIS IS CONFUSING BUT IT IS RIGHT  ie do not do XX = X'; see pcolor below

globalmean = squeeze(nanmean(timeseries1231(:,3,:),1));
plot(nanmean(thetime,1),rad2bt(1231,globalmean));
plot(nanmean(thetime,1),rad2bt(1231,globalmean)-nanmean(rad2bt(1231,globalmean)));grid

tropics = find(abs(YY) <= 30);
tml     = find(abs(YY) <= 60 & lf == 0);
tS = [2003 2008 2013 2018 2020 2022 2023 2024];

iQshow = 3;
figure(1); clf
clear meanrad
for yy = 1 : length(tS)-1
  for mm = 1 : 12
    boo = find(savedate(:,1) >= tS(yy) & savedate(:,1) < tS(yy+1) & savedate(:,2) == mm);
    junk = squeeze(timeseries1231(:,iQshow,boo));
    junk = nanmean(junk,2);
%    pcolor(reshape(XX,72,64),reshape(YY,72,64),reshape(junk,72,64)); shading flat
    junkx = junk(tropics,:);
    junkx = junk(tml,:);
    meanrad(yy,mm) = nanmean(junkx);
  end
end
plot(1:12,rad2bt(1231,meanrad(1:length(tS)-2,:))-273.15,'linewidth',2)
hold on; plot(1:12,rad2bt(1231,meanrad(length(tS)-1,:))-273.15,'x-','linewidth',4)
hl = legend('2003/01-2007/12','2008/01-2012/12','2013/01-2017/12','2018/01-2019/12','2020/01-2021/12','2022/01-2022/12','2023/01-2023/12','location','best','fontsize',8);
xlim([1 12])
names = {'J';'F';'M';'A';'M';'J';'J';'A';'S';'O';'N';'D'};
set(gca,'xtick',[1:12],'xticklabel',names)
ylabel('BT 1231 deg C'); grid;

figure(2); clf
clear meanskt
for yy = 1 : length(tS)-1
  for mm = 1 : 12
    boo = find(savedate(:,1) >= tS(yy) & savedate(:,1) < tS(yy+1) & savedate(:,2) == mm);
    junk = squeeze(timeseriesSKT(:,iQshow-2,boo));
    junk = nanmean(junk,2);
%    pcolor(reshape(XX,72,64),reshape(YY,72,64),reshape(junk,72,64)); shading flat
    junkx = junk(tropics,:);
    junkx = junk(tml,:);
    meanskt(yy,mm) = nanmean(junkx);
  end
end
plot(1:12,meanskt(1:length(tS)-2,:)-273.15,'linewidth',2)
hold on; plot(1:12,meanskt(length(tS)-1,:)-273.15,'x-','linewidth',4)
hl = legend('2003/01-2007/12','2008/01-2012/12','2013/01-2017/12','2018/01-2019/12','2020/01-2021/12','2022/01-2022/12','2023/01-2023/12','location','best','fontsize',8);
xlim([1 12])
names = {'J';'F';'M';'A';'M';'J';'J';'A';'S';'O';'N';'D'};
set(gca,'xtick',[1:12],'xticklabel',names)
ylabel('SKT deg C'); grid;
