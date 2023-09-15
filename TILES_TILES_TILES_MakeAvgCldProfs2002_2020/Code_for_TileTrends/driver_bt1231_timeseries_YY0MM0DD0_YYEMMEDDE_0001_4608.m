%% this is from clust_tile_fits_quantiles.m and tile_fits_quantiles.m

addpath /asl/matlib/rtptools/
addpath /asl/matlib/aslutil
addpath /asl/matlib/h4tools
addpath /asl/matlib/science/
addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/matlib/clouds/sarta
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS

disp('make sure you check "set_iQAX" and "set_start_stop_dates" ')
disp('make sure you check "set_iQAX" and "set_start_stop_dates" ')
disp('make sure you check "set_iQAX" and "set_start_stop_dates" ')

%% Strows stuff (run from his dir)
fdirpre      = '/home/strow/Work/Airs/Tiles/Data/Quantv1';        %% symbolic link to /home/strow/Work/Airs/Tiles/Data/Quantv1 -> /asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_CORRECT_LatLon
fdirpre_out  = '/home/strow/Work/Airs/Tiles/Data/Quantv1_fits';

%% Sergio stuff (run from my dir)
fdirpre      = '../DATAObsStats_StartSept2002_CORRECT_LatLon/';   %% symbolic link to ./DATAObsStats_StartSept2002_CORRECT_LatLon -> /asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_CORRECT_LatLon
fdirpre_out  = '../DATAObsStats_StartSept2002_CORRECT_LatLon/';

set_start_stop_dates  %%% <<<< CHECK THIS
set_iQAX              %%% <<<< CHECK THIS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
se = load('../Code_For_HowardObs_TimeSeries/timestepsStartEnd_2002_09_to_2024_09.mat');

%startdate = [2002 09 01]; stopdate = [2023 08 31];
%startdate = [2002 09 01]; stopdate = [2022 08 31];

booS = find(se.thedateS(:,1) == startdate(1) & se.thedateS(:,2) == startdate(2) & se.thedateS(:,3) >= startdate(3),1);
booE = find(se.thedateE(:,1) == stopdate(1)  & se.thedateE(:,2) == stopdate(2)  & se.thedateE(:,3) <= stopdate(3));    booE = max(booE);   % booE = max(booE)+1;

ia16daysSteps = booS:booE;
disp('first three and last three timesteps : ')
fprintf(1,' %3i : %4i %2i %2i to %4i %2i %2i \n',[ia16daysSteps(1:3)'       se.thedateS(ia16daysSteps(1:3),:)        se.thedateE(ia16daysSteps(1:3),:)      ]')
fprintf(1,' %3i : %4i %2i %2i to %4i %2i %2i \n',[ia16daysSteps(end-2:end)' se.thedateS(ia16daysSteps(end-2:end),:)  se.thedateE(ia16daysSteps(end-2:end),:)]')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AorD = 'D';
AorD = 'A';
iLatbin = 0;
for JOB = 1 : 4608
  lati = floor((JOB-1)/72)+1;  loni = JOB-(lati-1)*72;  %fprintf(1,'JOB,lati,loni : %4i %3i %3i \n',JOB,lati,loni)
  %% see tile_fits_quantiles(loni,lati,fdirpre,fnout,ia16daysSteps,iQAX,stopdate,startdate,ia16daysStepsX,iAllorSeason); %% can technically put [yy mm dd]_stop date   and [yy mm dd]_start date as two extra arguments
  [timeseries1231(JOB,:,:) timeseriesSKT(JOB,:,:) thetime(JOB,:)] = get_1231_timeseries_JOB(loni,lati,iQAX,stopdate,startdate,ia16daysSteps,fdirpre,AorD);

  if mod(JOB,72) == 0
    iLatbin = iLatbin + 1;
    fprintf(1,'+ latbin %2i of 64 \n',iLatbin)
  else
    fprintf(1,'.');
  end
  
end

tt = nanmean(thetime,1);
for ii = 1 : length(tt)
  savedate(ii,1) = se.thedateS(tt(ii),1);
  savedate(ii,2) = se.thedateS(tt(ii),2);
  savedate(ii,3) = se.thedateS(tt(ii),3);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
clf
for xx = 2003 : 2023
  boo = find(savedate(:,1) == xx);
  if xx <= 2007
    plot(savedate(boo,2),rad2bt(1231,squeeze(mean(timeseries1231(:,3,boo)))),'x');
  elseif xx <= 2012
    plot(savedate(boo,2),rad2bt(1231,squeeze(mean(timeseries1231(:,3,boo)))),'.');
  elseif xx <= 2017
    plot(savedate(boo,2),rad2bt(1231,squeeze(mean(timeseries1231(:,3,boo)))),'s');
  elseif xx <= 2030
    plot(savedate(boo,2),rad2bt(1231,squeeze(mean(timeseries1231(:,3,boo)))),'p');
  end
  hold on
end
xx = 2003:2023;
hl = legend(num2str(xx'),'fontsize',8);
hold off
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
comment = 'see driver_bt1231_timeseries_YY0MM0DD0_YYEMMEDDE_0001_4608.m';
str = [num2str(startdate(1)) '_' num2str(startdate(2),'%02d') '_' num2str(startdate(3),'%02d') '_to_' num2str(stopdate(1)) '_' num2str(stopdate(2),'%02d') '_' num2str(stopdate(3),'%02d') '_' AorD];
saver = ['save bt1231_timeseries' str '.mat comment timeseries1231 timeseriesSKT thetime startdate stopdate savedate'];
eval(saver)
%}

show_bt1231_timeseries_YY0MM0DD0_YYEMMEDDE_0001_4608
