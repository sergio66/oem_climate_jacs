function [] = fit_robust_one_lat(fout,foutsm,latid,fit_type,start_time,stop_time,rtime_mean,robs,rclr,count,saveopt);

%% copied from /home/strow/Matlab/Stats/

addpath /home/strow/Matlab/Math
addpath /home/strow/Matlab/Utility/
addpath /asl/matlib/aslutil

latid_out = latid;

dmtime = datenum(1958,1,1,0,0,rtime_mean);
%dmtime = nanmean(dmtime,2);
ndi = find( dmtime >= start_time & dmtime <= stop_time);
nd = length(ndi);
%--------------------------------------------------------------------------------
nf = 1305;
load_fcris
f = fcris;
load /asl/matlib/cris/ch_std_from1317  % get ch_std_i
count = count(ndi);
dmtime = dmtime(ndi);
robs = robs(ndi,:);
rclr = rclr(ndi,:);

%addpath /home/sergio/MATLABCODE
%keyboard_nowindow

%   robs = squeeze(nanmean(robs(ndi,ch_std_i,:),3));
%   rclr = squeeze(nanmean(rcldcal(ndi,ch_std_i,:),3));

   robs = robs(:,ch_std_i);
   rclr = rclr(:,ch_std_i);

   btobs = real(rad2bt(f,robs'));
   btcal = real(rad2bt(f,rclr'));
   bias = btobs-btcal;
   bias = bias';

%--------------------------------------------------------------------------------
%--------------------------------------------------------------------------------
% Start common code
%--------------------------------------------------------------------------------
% Build output arrays
all_b        = NaN(nf,10);
all_berr     = NaN(nf,10);
all_rms      = NaN(nf,10);
all_resid    = NaN(nd,nf);
all_anom     = NaN(nd,nf);
all_bt_anom  = NaN(nd,nf);
all_bt_resid = NaN(nd,nf);
all_times    = NaN(nd,nf);
all_bcorr    = NaN(nf,10,10);

% Number of channels (should be done earlier??)
if nf == 2378
   ig = goodchan_for_clear(count);
elseif nf == 8461
   ig = 1:8461;
elseif nf == 1305
   ig = 1:1305;
elseif nf == 2645
   ig = 1:2645;
elseif nf == 1178
   ig = 1:1178;
elseif nf == 980
   ig = 1:980;
end

% Get rid of gigantic outliers
for i=ig
   k = remove_6sigma(robs(:,i));
   j = remove_6sigma(robs(k,i));
   ind(i).k = k(j);
end

% Non-linear fit spits out too much info
warning('off','all');

% Channel loop
for i=ig
   fprintf(1,'chan i = %4i \n',i)
   % Subset on good times
   it = ind(i).k;

   fittime = dmtime(it);

   switch fit_type
     case 'robs'
       fity = squeeze(robs(it,i));
     case 'rcld'
       fity = squeeze(rcldy(it,i));
     case 'rclr'
       fity = squeeze(rclr(it,i));
     case 'bias'
       fity = squeeze(bias(it,i));       
   end
   x = fittime - fittime(1);
   y = squeeze(fity);
   [b stats] = Math_tsfit_lin_robust(x,y,4);
   all_b(i,:) = b;
   all_rms(i) = stats.s;
   all_berr(i,:) = stats.se;
   all_bcorr(i,:,:) = stats.coeffcorr;
   all_resid(it,i) = stats.resid;
   % Put linear back in for anomaly
   dr = (x/365).*all_b(i,2);
   all_anom(it,i) = all_resid(it,i) + dr;
   all_times(it,i) = fittime;
end
warning('on','all');

% HMM Why is there 1E3 here????
% HMM Why is there 1E3 here????
% HMM Why is there 1E3 here????
% HMM Why is there 1E3 here????
% Get dr into dbt units

figure(1); plot(1:length(f),rad2bt(f,all_b(:,1)),'b.-'); grid; title('avg bt')
figure(2); plot(f,rad2bt(f,all_b(:,1)),'b.-'); grid; title('avg bt')
switch fit_type
  case {'robs', 'rcld', 'rclr'}
    deriv   = drdbt(f,rad2bt(f,all_b(:,1)));
%    dbt     = all_b(:,2)./(deriv*1E3);
%    dbt_err = all_berr(:,2)./(deriv*1E3);
    dbt     = all_b(:,2)./(deriv);
    dbt_err = all_berr(:,2)./(deriv);
  case 'bias'
    dbt     = all_b(:,2);
    dbt_err = all_berr(:,2);
    deriv = NaN;
end

% Convert resid to BT units
switch fit_type
  case {'robs', 'rcld', 'rclr'}
    for i=1:nd
%       all_bt_resid(i,:) = all_resid(i,:)./(deriv'*1E3);
%       all_bt_anom(i,:) = all_anom(i,:)./(deriv'*1E3);
       all_bt_resid(i,:) = all_resid(i,:)./(deriv');
       all_bt_anom(i,:) = all_anom(i,:)./(deriv');
    end
  case 'bias'
    for i=1:nd
       all_bt_resid(i,:) = all_resid(i,:);
       all_bt_anom(i,:) = all_anom(i,:);
    end
end

% Get lag-1 correlation (ignoring that we don't have all days)
for i = 1:nf
   y = squeeze(all_bt_resid(:,i));
   k = remove_nan(y);
   if length(k) > 100
      l = xcorr(y(k),1,'coeff');
      lag(i) = l(1);
   else
      lat(i) = NaN;
   end
end

fprintf(1,'fout = %s \n',[fout int2str(latid_out)])

switch saveopt
case 'saveboth'
       save([fout int2str(latid_out)],'f','dbt','dbt_err','lag','deriv', 'all_b', 'all_berr', 'all_bt_anom', 'all_bt_resid', 'all_times', 'all_bcorr' );
       save([foutsm int2str(latid_out)],'f','dbt','dbt_err','all_b','all_berr','all_bcorr','all_rms','lag');
case 'savesmall'
       save([foutsm int2str(latid_out)],'f','dbt','dbt_err','all_b','all_berr','all_bcorr','all_rms','lag');
case 'savebig'
       save([fout int2str(latid_out)],'f','dbt','dbt_err','lag','deriv', 'all_b', 'all_berr', 'all_bt_anom', 'all_bt_resid', 'all_times', 'all_bcorr' );
end

% 
% 
% 
% if ~smallsave
%    switch fit_type
%      case {'robs', 'rcld', 'rclr'}
%        save([fout int2str(latid_out)],'dbt','dbt_err','lag','deriv', 'all_b', 'all_berr', 'all_bt_anom', 'all_bt_resid', 'all_times', 'all_bcorr' );
%        %% Use if fitting clear calcs for cloudy random data
% %    save([fout 'clrcldy_' int2str(latid_out)],'dbt','dbt_err','all*', 'lag','deriv');
%      case 'bias'
%        save([fout int2str(latid_out)],'dbt','dbt_err','lag','deriv', 'all_b', 'all_berr', 'all_bt_anom', 'all_bt_resid', 'all_times', 'all_bcorr' );
%    end
% else % smallsave option
% % less output
%    switch fit_type
%      case {'robs', 'rcld','rclr'}
%        save([fout int2str(latid_out)],'dbt','dbt_err','all_b','all_berr','all_bcorr','all_rms','lag');
%      case 'bias'
%        save([fout int2str(latid_out)],'dbt','dbt_err','all_b','all_berr','all_bcorr','all_rms','lag');
%    end
% end
% 
% OLD saves
%    save([fout 'clrcldy_' int2str(latid_out)],'dbt','dbt_err','all*', 'lag','deriv');


