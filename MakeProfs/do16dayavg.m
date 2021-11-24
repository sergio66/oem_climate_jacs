function   [avg16_stemp,avg16_rtime,avg16_doy_since2002,bdry16,anomaly16] = do16dayavg(stemp_mean,...
    hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,titlestr,iRemoveSeasonal,iRawOrFracAnom);

%% addpath /home/sergio/MATLABCODE/FIND_TRENDS/
%% using Math_tsfit_lin_robust from /home/setrow/Matlab/Math which I have copied here

if nargin < 12
  iRemoveSeasonal = -1;  %% smooth raw data as is
  iRawOrFracAnom = +1;   %% do raw anomaly
end
if nargin < 13
  iRawOrFracAnom = +1;   %% do raw anomaly
end

clear data ysmooth
if strfind(hostname,'taki')
  iPlot = 1;
else
   iPlot = -1;
end

data = ones(size(iaAllDays)) * -9999;
whos data goodtimes iaAllDays
data(iA) = stemp_mean(goodtimes);
data(iB) = interp1(days_since_2002,data(iA),missingdays,[],'extrap');

data(data <= -9999) = nan; %% new on 08/19/2019

dataIN = data;
if iRemoveSeasonal > 0
  good = find(isfinite(data));
  if length(good) > 20
    [B, stats] = Math_tsfit_lin_robust(iaAllDays(good),data(good),4);  
    Bzero = B;
      Bzero(1) = 0;
      Bzero(2) = 0;
    [yzero g]=Math_timeseries_2(iaAllDays,Bzero);
    data = dataIN - yzero;
  else
    disp('oops most data was NaN ir INF, cannot fit with Math_tsfit_lin_robust')
    data = dataIN;
    yzero = zeros(size(data));
  end
  if iPlot > 0
    plot(iaAllDays,dataIN,iaAllDays,yzero)
    plot(iaAllDays,dataIN,'b',iaAllDays,data,'r'); 
      hl = legend('raw dtata','after removing seasonal','location','best'); set(hl,'fontsize',10)
    if nargin >= 11; title(titlestr); end; 
    %disp('ret 1'); pause
    pause(0.1)
  end
end

%addpath /home/sergio/MATLABCODE
%keyboard_nowindow
%% this is Larrabee's anomaly
  %% more  /home/strow/Matlab/Math/Math_tsfit_lin_robust.m
  %% see fit_robust_one_lat.m
  %x = fittime - fittime(1);
  %y = squeeze(fity);
  x = iaAllDays(good);
  y = data(good);

  x = iaAllDays;
  if iRawOrFracAnom > 0
    y = data;
  else
    y = data/nanmean(data);
  end

  [b stats] = Math_tsfit_lin_robust(x,y,4);  %% b = array of size(1x10, and the linear daily trend is b(2)
  all_b = b;
  all_rms = stats.s;
  all_berr = stats.se;
  all_bcorr = stats.coeffcorr;
  all_resid = stats.resid;
  % Put linear back in for anomaly
  dr = (x/365).*all_b(2);
  all_anom = all_resid' + dr; %%% --->

  plot(x,y,'b',x,all_anom,'r',iaAllDays,dataIN,'k')
  %plot(x,y,'b',x,all_anom,'r',iaAllDays,dataIN,'k')
  plot(x,all_anom+b(1)-data,'k');       hl = legend('anomaly - data = seasonal','location','best'); set(hl,'fontsize',10)
  if nargin >= 11; title(titlestr); end; 
  %disp('ret 2'); pause
  pause(0.1)

%% smooth the data
if iAvgNumDays > 0
  ysmooth = smooth(data,iAvgNumDays);
  ysmoothanom = smooth(all_anom,iAvgNumDays);
else
  ysmooth = data;
  ysmoothanom = all_anom;
end

if iPlot > 0
  figure(1); clf
  plot(iaAllDays,data)
  plot(iaAllDays,data,days_since_2002,stemp_mean(goodtimes),'r.');
  plot(iaAllDays,dataIN,'b',iaAllDays,data,'r',iaAllDays,ysmooth,'k'); 
      hl = legend('raw dtata','after removing seasonal','location','best'); set(hl,'fontsize',10)
  if nargin >= 11; title(titlestr); end; 
  %disp('ret 3'); pause
  pause(0.1);
end

%% then average over 16 day units
ia16 = 1 : 16 : length(ysmooth);
for iDay16 = 1 : length(ia16)-1
  ind = ia16(iDay16):ia16(iDay16+1);    %% till Aug 8, 2019
  ind = ia16(iDay16):ia16(iDay16+1)-1;  %% after Aug 8, 2019

  bdry16.start(iDay16) = ind(1);
  bdry16.stop(iDay16)  = ind(end);
  bdry16.len(iDay16)   = length(ind);

  bdry16.start_rtime(iDay16) = rtimeAllDays(ind(1));
  bdry16.stop_rtime(iDay16) = rtimeAllDays(ind(end));

  avg16_rtime(iDay16)         = nanmean(rtimeAllDays(ind));
  avg16_doy_since2002(iDay16) = nanmean(iaAllDays(ind));
  avg16_stemp(iDay16)         = nanmean(ysmooth(ind));
  anomaly16(iDay16)           = nanmean(ysmoothanom(ind));

end     %% loop over 16 days

if iPlot > 0
  doy2002      = 2002 + iaAllDays/365;
  avg16doy2002 = 2002 + avg16_doy_since2002/365;
  figure(1); clf
  plot(iaAllDays,data,'b',iaAllDays,ysmooth,'g',avg16_doy_since2002,avg16_stemp,'r',iaAllDays(iA),stemp_mean,'k.'); 
      %hl = legend('after removing seasonal','smoothed','raw data','location','best'); set(hl,'fontsize',10)
  if nargin >= 11; title(titlestr); end; 
  %disp('ret 4'); pause

  if iRemoveSeasonal > 0 & iPlot > 0
    plot(doy2002,dataIN,'c',doy2002,data,'b',doy2002,ysmooth,'k.-',avg16doy2002,avg16_stemp,'r',doy2002(iA),stemp_mean,'go')
    ax = axis; ax(1) = doy2002(1); ax(2) = doy2002(end); axis(ax);
    hl = legend('actual AIRS data, all days','actual AIRS data, all days, seasonal removed','filled in data','avg16 data','actual AIRS data, input days','location','best');
    set(hl,'fontsize',10);
    if nargin == 11
      title(titlestr)
    end
  elseif iRemoveSeasonal <= 0 & iPlot > 0
    %% dataIN == data
    plot(doy2002,dataIN,'c',doy2002,data,'b',doy2002,ysmooth,'k.-',avg16doy2002,avg16_stemp,'r',doy2002(iA),stemp_mean,'go')
    ax = axis; ax(1) = doy2002(1); ax(2) = doy2002(end); axis(ax);
    hl = legend('actual AIRS data, all days','actual AIRS data, all days, no seasonal removed','filled in data','avg16 data','actual AIRS data, input days','location','best');
    set(hl,'fontsize',10);
    if nargin == 11
      title(titlestr)
    end
  end
  pause(0.1)
end
pause(0.1)
