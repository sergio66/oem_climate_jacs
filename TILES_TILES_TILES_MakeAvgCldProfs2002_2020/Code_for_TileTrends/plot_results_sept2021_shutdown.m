timedata = bttimeseries1231; iType = +1; str0 = ['Raw BT'];  ystr = ('Raw BT [K]');
timedata = timeseries1231;   iType = -1; str0 = ['Raw Rad']; ystr = ('Raw Rad [mW/m2/cm-1/sr-1]');
timedata = bt_anomaly;       iType = 0;  str0 = ['Anom BT']; ystr = ('Anom BT [K]');

startM = 08; stopM = 12;
startM = 07; stopM = 12;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

do_XX_YY_from_X_Y
cosYY = cos(YY'*pi/180) * ones(1,length(savedate));

%% see eg  /home/sergio/git/CHECK_FILE_COUNT/check_duplicate_airs_l1c_672_674_of_672.m
%mtime = tai2mattime(save_rtime);
xtime = datetime(savedate(:,1),savedate(:,2),savedate(:,3));

%% https://modaps.modaps.eosdis.nasa.gov/services/production/outages_aqua.html
%% 2021-266 - 2021-267	September 23, 2021 - September 24, 2021	08:50:00	18:00:00	lunar deep space calibration LDSC maneuver outage

figure(1); clf; plot(xtime,squeeze(timedata(2000,1,:)),'+-');
figure(1); clf; plot(xtime,squeeze(timedata(2000,:,:)),'+-');
legend('Q01','Q02','Q03','Q04','Q05','location','best');
xlim([datetime(2021,startM,01) datetime(2021,stopM,01)])

for qq = 1 : 5
  data = squeeze(timedata(:,qq,:));
  num   = sum(data .* cosYY,1);
  denom = sum(cosYY,1);
  meandata(qq,:) = num./denom;
end

figure(1); clf; plot(xtime,meandata,'+-');
xlim([datetime(2021,startM,01) datetime(2021,stopM,01)])
axX = xlim;
axY = ylim;
hold on; plot([datetime(2021,09,23) datetime(2021,09,23)],[axY(1) axY(2)]); hold off
legend('Q01','Q02','Q03','Q04','Q05','location','best');
ylabel(ystr); title(['Global ' str0 ' Ch ' num2str(chID) ' : ' num2str(h.vchan(chID)) ])
grid on

figure(2); clf; plot(xtime,meandata,'+-');
xlim([datetime(2020,startM,01) datetime(2020,stopM,01)])
axX = xlim;
axY = ylim;
hold on; plot([datetime(2020,09,23) datetime(2020,09,23)],[axY(1) axY(2)]); hold off
legend('Q01','Q02','Q03','Q04','Q05','location','best');
ylabel(ystr); title(['Global ' str0 ' Ch ' num2str(chID) ' : ' num2str(h.vchan(chID)) ])
grid on

figure(3); clf; plot(xtime,meandata,'+-');
xlim([datetime(2022,startM,01) datetime(2022,stopM,01)])
axX = xlim;
axY = ylim;
hold on; plot([datetime(2022,09,23) datetime(2022,09,23)],[axY(1) axY(2)]); hold off
legend('Q01','Q02','Q03','Q04','Q05','location','best');
ylabel(ystr); title(['Global ' str0 ' Ch ' num2str(chID) ' : ' num2str(h.vchan(chID)) ])
grid on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear dnum* y1* y2* yy*

t17 = find(xtime >= datetime(2017,startM,01) & xtime <= datetime(2017,stopM,01)); tt17 = xtime(t17); dnum17 = datenum(tt17); y17 = meandata(:,t17);
t18 = find(xtime >= datetime(2018,startM,01) & xtime <= datetime(2018,stopM,01)); tt18 = xtime(t18); dnum18 = datenum(tt18); y18 = meandata(:,t18);
t19 = find(xtime >= datetime(2019,startM,01) & xtime <= datetime(2019,stopM,01)); tt19 = xtime(t19); dnum19 = datenum(tt19); y19 = meandata(:,t19);
t20 = find(xtime >= datetime(2020,startM,01) & xtime <= datetime(2020,stopM,01)); tt20 = xtime(t20); dnum20 = datenum(tt20); y20 = meandata(:,t20);
t21 = find(xtime >= datetime(2021,startM,01) & xtime <= datetime(2021,stopM,01)); tt21 = xtime(t21); dnum21 = datenum(tt21); y21 = meandata(:,t21);
t22 = find(xtime >= datetime(2022,startM,01) & xtime <= datetime(2022,stopM,01)); tt22 = xtime(t22); dnum22 = datenum(tt22); y22 = meandata(:,t22);
%t23 = find(xtime >= datetime(2023,startM,01) & xtime <= datetime(2023,stopM,01)); tt23 = xtime(t23); dnum23 = datenum(tt23); y23 = meandata(:,t23);

jan2017 = datenum(datetime(2017,01,01)); dnew17 = dnum17 - jan2017;
jan2018 = datenum(datetime(2018,01,01)); dnew18 = dnum18 - jan2018;
jan2019 = datenum(datetime(2019,01,01)); dnew19 = dnum19 - jan2019;
jan2020 = datenum(datetime(2020,01,01)); dnew20 = dnum20 - jan2020;
jan2021 = datenum(datetime(2021,01,01)); dnew21 = dnum21 - jan2021;
jan2022 = datenum(datetime(2022,01,01)); dnew22 = dnum22 - jan2022;
%jan2023 = datenum(datetime(2023,01,01)); dnew23 = dnum23 - jan2023;

figure(4); clf
%plot(dnew17,y17,dnew18,y18,dnew19,y19,dnew20,y20,dnew21,y21,'x-',dnew22,y22)

for ii = 1 : 5
  yy17(ii,:) = interp1(dnew17,y17(ii,:),dnew21,'linear','extrap');
  yy18(ii,:) = interp1(dnew18,y18(ii,:),dnew21,'linear','extrap');
  yy19(ii,:) = interp1(dnew19,y19(ii,:),dnew21,'linear','extrap');
  yy20(ii,:) = interp1(dnew20,y20(ii,:),dnew21,'linear','extrap');
  yy22(ii,:) = interp1(dnew22,y22(ii,:),dnew21,'linear','extrap');
  %yy23(ii,:) = interp1(dnew23,y23(ii,:),dnew21,'linear','extrap');
end
yy21 = y21;

figure(4); clf
plot(dnew21,yy17,dnew21,yy18,dnew21,yy19,dnew21,yy20,dnew21,yy21,'x-',dnew21,yy22)

meanyy_17_18_19 = (yy17 + yy18 + yy19 + yy20 + yy22)/5;
meanyy_17_18_19 = (yy17 + yy18 + yy19 + yy22)/4;
meanyy_17_18_19 = (yy17 + yy18 + yy19)/3;
plot(dnew21,meanyy_17_18_19,dnew21,y21,'x-');
plot(dnew21,meanyy_17_18_19-y21,'x-');

newdatetime0 = datetime(dnew21+jan2021,'ConvertFrom','datenum');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(4); clf

junk = meanyy_17_18_19-yy21;
if startM == 7
  t2021Jul = find(newdatetime0 >= datetime(2021,07,01) & newdatetime0 < datetime(2021,08,01)); y2021Avg(t2021Jul) = nanmean(nanmean(junk(:,t2021Jul),1));
end
t2021Aug = find(newdatetime0 >= datetime(2021,08,01) & newdatetime0 < datetime(2021,09,01)); y2021Avg(t2021Aug) = nanmean(nanmean(junk(:,t2021Aug),1));
t2021Sep = find(newdatetime0 >= datetime(2021,09,01) & newdatetime0 < datetime(2021,10,01)); y2021Avg(t2021Sep) = nanmean(nanmean(junk(:,t2021Sep),1));
t2021Oct = find(newdatetime0 >= datetime(2021,10,01) & newdatetime0 < datetime(2021,11,01)); y2021Avg(t2021Oct) = nanmean(nanmean(junk(:,t2021Oct),1));
t2021Nov = find(newdatetime0 >= datetime(2021,11,01) & newdatetime0 < datetime(2021,12,01)); y2021Avg(t2021Nov) = nanmean(nanmean(junk(:,t2021Nov),1));
t2021Dec = find(newdatetime0 >= datetime(2021,12,01) & newdatetime0 < datetime(2022,01,01)); y2021Avg(t2021Dec) = nanmean(nanmean(junk(:,t2021Dec),1));

newdatetime = datetime(dnew21+jan2021,'ConvertFrom','datenum');
plot(newdatetime,meanyy_17_18_19 - yy21,'x-');
axX = xlim;
axY = ylim;
hold on; 
plot([datetime(2021,09,23) datetime(2021,09,23)],[axY(1) axY(2)]); 
%plot(newdatetime,y2021Avg,'k','linewidth',3)
for mm = startM : stopM-1
  ind = (1:2) + (mm - startM)*2;
  plot([datetime(2021,mm,01) datetime(2021,mm+1,01)],[y2021Avg(ind)],'k','linewidth',3)
  if mm == 9
    plot([datetime(2021,mm,01) datetime(2021,mm+1,01)],[y2021Avg(ind)],'r','linewidth',5)
  end
end
hold off
legend('Q01','Q02','Q03','Q04','Q05','location','best');
ylabel(ystr); title(['Global ' str0 ' (Mean-2021) \newline Ch ' num2str(chID) ' : ' num2str(h.vchan(chID)) ])
grid on
set(gcf, 'color', [1 1 0.8]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(5); clf

junk = meanyy_17_18_19 - yy20;
if startM == 7
  t2020Jul = find(newdatetime0 >= datetime(2021,07,01) & newdatetime0 < datetime(2021,08,01)); y2020Avg(t2020Jul) = nanmean(nanmean(junk(:,t2020Jul),1));
end
t2020Aug = find(newdatetime0 >= datetime(2021,08,01) & newdatetime0 < datetime(2021,09,01)); y2020Avg(t2020Aug) = nanmean(nanmean(junk(:,t2020Aug),1));
t2020Sep = find(newdatetime0 >= datetime(2021,09,01) & newdatetime0 < datetime(2021,10,01)); y2020Avg(t2020Sep) = nanmean(nanmean(junk(:,t2020Sep),1));
t2020Oct = find(newdatetime0 >= datetime(2021,10,01) & newdatetime0 < datetime(2021,11,01)); y2020Avg(t2020Oct) = nanmean(nanmean(junk(:,t2020Oct),1));
t2020Nov = find(newdatetime0 >= datetime(2021,11,01) & newdatetime0 < datetime(2021,12,01)); y2020Avg(t2020Nov) = nanmean(nanmean(junk(:,t2020Nov),1));
t2020Dec = find(newdatetime0 >= datetime(2021,12,01) & newdatetime0 < datetime(2022,01,01)); y2020Avg(t2020Dec) = nanmean(nanmean(junk(:,t2020Dec),1));

newdatetime = datetime(dnew21+jan2020,'ConvertFrom','datenum');
plot(newdatetime,meanyy_17_18_19 - yy20,'x-');
axX = xlim;
axY = ylim;
hold on; 
plot([datetime(2020,09,23) datetime(2020,09,23)],[axY(1) axY(2)]); 
%plot(newdatetime,y2020Avg,'k','linewidth',3)
for mm = startM : stopM-1
  ind = (1:2) + (mm - startM)*2;
  plot([datetime(2020,mm,01) datetime(2020,mm+1,01)],[y2020Avg(ind)],'k','linewidth',3)
  if mm == 9
    plot([datetime(2020,mm,01) datetime(2020,mm+1,01)],[y2020Avg(ind)],'r','linewidth',5)
  end
end
hold off
legend('Q01','Q02','Q03','Q04','Q05','location','best');
ylabel(ystr); title(['Global ' str0 ' (Mean-2020) \newline Ch ' num2str(chID) ' : ' num2str(h.vchan(chID)) ])
grid on
set(gcf, 'color', [1 1 0.8]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(6); clf

junk = meanyy_17_18_19 - yy22;
if startM == 7
  t2022Jul = find(newdatetime0 >= datetime(2021,07,01) & newdatetime0 < datetime(2021,08,01)); y2022Avg(t2022Jul) = nanmean(nanmean(junk(:,t2022Jul),1));
end
t2022Aug = find(newdatetime0 >= datetime(2021,08,01) & newdatetime0 < datetime(2021,09,01)); y2022Avg(t2022Aug) = nanmean(nanmean(junk(:,t2022Aug),1));
t2022Sep = find(newdatetime0 >= datetime(2021,09,01) & newdatetime0 < datetime(2021,10,01)); y2022Avg(t2022Sep) = nanmean(nanmean(junk(:,t2022Sep),1));
t2022Oct = find(newdatetime0 >= datetime(2021,10,01) & newdatetime0 < datetime(2021,11,01)); y2022Avg(t2022Oct) = nanmean(nanmean(junk(:,t2022Oct),1));
t2022Nov = find(newdatetime0 >= datetime(2021,11,01) & newdatetime0 < datetime(2021,12,01)); y2022Avg(t2022Nov) = nanmean(nanmean(junk(:,t2022Nov),1));
t2022Dec = find(newdatetime0 >= datetime(2021,12,01) & newdatetime0 < datetime(2022,01,01)); y2022Avg(t2022Dec) = nanmean(nanmean(junk(:,t2022Dec),1));

newdatetime = datetime(dnew21+jan2022,'ConvertFrom','datenum');
plot(newdatetime,meanyy_17_18_19 - yy22,'x-');
axX = xlim;
axY = ylim;
hold on; 
plot([datetime(2022,09,23) datetime(2022,09,23)],[axY(1) axY(2)]); 
%plot(newdatetime,y2022Avg,'k','linewidth',3)
for mm = startM : stopM-1
  ind = (1:2) + (mm - startM)*2;
  plot([datetime(2022,mm,01) datetime(2022,mm+1,01)],[y2022Avg(ind)],'k','linewidth',3)
  if mm == 9
    plot([datetime(2022,mm,01) datetime(2022,mm+1,01)],[y2022Avg(ind)],'r','linewidth',5)
  end
end
hold off
legend('Q01','Q02','Q03','Q04','Q05','location','best');
ylabel(ystr); title(['Global ' str0 ' (Mean-2022) \newline Ch ' num2str(chID) ' : ' num2str(h.vchan(chID)) ])
grid on
set(gcf, 'color', [1 1 0.8]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(7); clf

ta = tiledlayout(2,1,'TileSpacing','Compact', 'Padding','Compact');
ta.OuterPosition = [0.0375 0.0375 0.925 0.925];

%%%%%%%%%%%%%%%%%%%%%%%%%

tafov(1) = nexttile;

hold on
junk = mean(y2020Avg);
for mm = startM : stopM-1
  ind = (1:2) + (mm - startM)*2;
  plot([datetime(2021,mm,01) datetime(2021,mm+1,01)],[y2020Avg(ind)-junk],'c','linewidth',2)
  if mm == 9
    plot([datetime(2021,mm,01) datetime(2021,mm+1,01)],[y2020Avg(ind)-junk],'co-','linewidth',2)
  end
end
hold off

hold on
junk = mean(y2022Avg);
for mm = startM : stopM-1
  ind = (1:2) + (mm - startM)*2;
  plot([datetime(2021,mm,01) datetime(2021,mm+1,01)],[y2022Avg(ind)-junk],'b','linewidth',2)
  if mm == 9
    plot([datetime(2021,mm,01) datetime(2021,mm+1,01)],[y2022Avg(ind)-junk],'bx-','linewidth',2)
  end
end
hold off

hold on
junk = mean(y2021Avg);
for mm = startM : stopM-1
  ind = (1:2) + (mm - startM)*2;
  plot([datetime(2021,mm,01) datetime(2021,mm+1,01)],[y2021Avg(ind)-junk],'r','linewidth',4)
  if mm == 9
    plot([datetime(2021,mm,01) datetime(2021,mm+1,01)],[y2021Avg(ind)-junk],'m','linewidth',4)
  end
end
hold off
ylabel(['No Mean \newline' ystr]); 
title(['Global ' str0  ' Ch ' num2str(chID) ' : ' num2str(h.vchan(chID)) ' \newline cyan(Mean-2020) red(Mean-2021) blue(Mean-2022)' ])
title(['Global ' str0  ' Ch ' num2str(chID) ' : ' num2str(h.vchan(chID)) ' : Mean-YY \newline cyan(2020) red(2021) blue(2022)' ])
grid on
set(gcf, 'color', [1 1 0.8]);

xlabel('Time');

set(gca,'fontsize',12)

%%%%%%%%%%%%%%%%%%%%%%%%%

tafov(2) = nexttile;

hold on
junk = 0*mean(y2020Avg);
for mm = startM : stopM-1
  ind = (1:2) + (mm - startM)*2;
  plot([datetime(2021,mm,01) datetime(2021,mm+1,01)],[y2020Avg(ind)-junk],'c','linewidth',2)
  if mm == 9
    plot([datetime(2021,mm,01) datetime(2021,mm+1,01)],[y2020Avg(ind)-junk],'co-','linewidth',2)
  end
end
hold off

hold on
junk = 0*mean(y2022Avg);
for mm = startM : stopM-1
  ind = (1:2) + (mm - startM)*2;
  plot([datetime(2021,mm,01) datetime(2021,mm+1,01)],[y2022Avg(ind)-junk],'b','linewidth',2)
  if mm == 9
    plot([datetime(2021,mm,01) datetime(2021,mm+1,01)],[y2022Avg(ind)-junk],'bx-','linewidth',2)
  end
end
hold off

hold on
junk = 0*mean(y2021Avg);
for mm = startM : stopM-1
  ind = (1:2) + (mm - startM)*2;
  plot([datetime(2021,mm,01) datetime(2021,mm+1,01)],[y2021Avg(ind)-junk],'r','linewidth',4)
  if mm == 9
    plot([datetime(2021,mm,01) datetime(2021,mm+1,01)],[y2021Avg(ind)-junk],'m','linewidth',4)
  end
end
hold off
ylabel(['Raw \newline' ystr]); 
grid on

xlabel('Time');

set(gcf, 'color', [1 1 0.8]);

set(gca,'fontsize',12)

%%%%%%%%%%%%%%%%%%%%%%%%%

% Remove all xtick labels except for 1st column
for ii = [1]
   tafov(ii).XTickLabel = '';
   tafov(ii).XLabel.String = [];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(8); clf
aslmap(8,rlat65,rlon73,smoothn(reshape(trend(:,3),72,64)',1), [-90 +90],[-180 +180]); colormap(llsmap5); caxis([-1 +1]*0.15)
title(['Trend dBT/dt [K/yr] Ch ' num2str(chID) ' : ' num2str(h.vchan(chID)) ])
