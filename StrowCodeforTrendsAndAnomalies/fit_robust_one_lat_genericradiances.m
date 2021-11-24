function [] = fit_robust_one_lat_genericradiances(fout,foutsm,latid,fit_type,rtime_mean,robs,rcalc,count,inst,saveopt);

%% copied from /home/strow/Matlab/Stats/

addpath /home/strow/Matlab/Math
addpath /home/strow/Matlab/Utility/
addpath /asl/matlib/aslutil

latid_out = latid;

dmtime = datenum(1958,1,1,0,0,rtime_mean);
%dmtime = nanmean(dmtime,2);
%ndi = find( dmtime >= start_time & dmtime <= stop_time);
ndi = 1 : length(rtime_mean);
nd = length(ndi);
%--------------------------------------------------------------------------------
if inst == 'cris'
   nf = 1305;
   load_fcris
   f = fcris;
   load /asl/matlib/cris/ch_std_from1317  % get ch_std_i
   count = count(ndi,1);
   dmtime = dmtime(ndi);
   robs = squeeze(nanmean(robs(ndi,ch_std_i,:),3));
   rcldy = squeeze(nanmean(rcldcal(ndi,ch_std_i,:),3));
   btobs = real(rad2bt(f,robs'));
   btcal = real(rad2bt(f,rcldy'));
   bias = btobs-btcal;
   bias = bias';
else
   % add robs, rcldy, etc. for AIRS and IASI here.
   dmtime = dmtime(ndi);
   count = count(ndi,:);
end
%--------------------------------------------------------------------------------
if inst == 'iasi'
   rtime_mean = rtime;
   nf = 8461;
   load_fiasi;
   f = fiasi;
   robs = robs(ndi,:);
%   rcldy = rcldy(ndi,:);
   rcldy = rcal(ndi,:);
   btobs = real(rad2bt(f,robs'));
   btcal = real(rad2bt(f,rcldy'));
   bias = btobs-btcal;
   bias = bias';
end
%--------------------------------------------------------------------------------   
if inst == 'airs'
   nf = 2378;
   load_fairs;
   robs = robs(ndi,:);
   rcldy = rcldy(ndi,:);
   btobs = real(rad2bt(f,robs'));
   btcal = real(rad2bt(f,rcldy'));
   bias = btobs-btcal;
   bias = bias';
end
%--------------------------------------------------------------------------------
if inst == 'al1c'
   nf = 2645
   load_fairs;
%   load /home/sbuczko1/git/rtp_prod2/airs/util/sarta_chans_for_l1c.mat
   f = fairs;
   robs = robs(ndi,:);
%   rcldy = rcldy(ndi,:);
%   rclr = rclr(ndi,:);
   rcalc = rcalc(ndi,:);
   btobs = real(rad2bt(f,robs'));
%   btcal = real(rad2bt(f,rcldy'));
%   btcal = real(rad2bt(f,rclr'));
   btcal = real(rad2bt(f,rcalc'));
   bias = btobs-btcal;
   bias = bias';
end
%--------------------------------------------------------------------------------
if inst == 'a2cx'
   a2c_fin = strrep(fin,'statlat','a2c_statlat');
   a2c_fin = [a2c_fin int2str(latid)];
   load(a2c_fin,'a2crad');
   nf = 1178
   load_fairs;
   f = cfrq;
   robs = a2crad';
   robs = robs(ndi,:);
   btobs = real(rad2bt(f,robs'));
end
%--------------------------------------------------------------------------------
if inst == 'a2cc'   % Mixed a2c and cris; this is a real kludge

   % First subset a2crad to dmtime
   dxmtime = datenum(1958,1,1,0,0,rtime_mean);
   ndx = find( dxmtime >= start_time & dxmtime <= stop_time);
   
   a2c_fin = strrep(fin,'statlat','a2c_statlat');
   a2c_fin = [a2c_fin int2str(latid)];
   load(a2c_fin,'a2crad');
   a2crad = a2crad(:,ndx);  % now matching dmtime
   load_fairs;
%   load /home/sbuczko1/git/rtp_prod2/airs/util/sarta_chans_for_l1c.mat
   f = cfrq;
   % a2c times
   ndi_a2c = find( dmtime >= start_time & dmtime <= (start_time + 365*5));
   nd = length(ndi_a2c);
   robs_a2c = a2crad;
   btobs_a2c = real(rad2bt(f,robs_a2c(:,ndi_a2c)));
   dmtime = dmtime(ndi_a2c);   

   % Now load in CrIS
   c = load(['../../Cris/Random/Data/Desc/statlat' int2str(latid)]);
   c.dmtime = datenum(1958,1,1,0,0,c.rtime_mean);
   c.dmtime = nanmean(c.dmtime,2);
   ndi_c = find( c.dmtime >= (start_time +365*5) & c.dmtime <= stop_time);
   load_fcris
   load /asl/matlib/cris/ch_std_from1317
   c.robs = c.robs(:,ch_std_i);
   
   [cc iaa ibb]=intersect(fcris,cfrq);
   robs_c = c.robs(ndi_c,iaa)';
   c.dmtime = c.dmtime(ndi_c);
   
   load cris_airs_overlap_stats_v2
   robs_c = robs_c(ig.all,:);

% Now add in offset to a2c (make sure include secant adjustment)
    f = cfrq(ig.all);
   btobs_c = real(rad2bt(f,robs_c));
%   m = repmat(a_m_c(latid,:),1785,1)';
   m = repmat(nanmean(a_m_c(5:36,:)),1785,1)';
   btobs_a2c = btobs_a2c(ig.all,:) - 0.*m;
   btobs = [btobs_a2c btobs_c];
   dmtime = [dmtime; c.dmtime];
    robs = bt2rad(f,btobs)';
   nf = length(ig.all);
end
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
   if mod(i,500) == 0 | (i == 1)
     fprintf(1,'  latbin %2i channel %5i of %5i \n',latid,i,length(ig));
   end

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

scale = 1E3;
scale = 1E0;
% HMM Why is there 1E3 here????
% HMM Why is there 1E3 here????
% HMM Why is there 1E3 here????
% HMM Why is there 1E3 here????
% Get dr into dbt units
switch fit_type
  case {'robs', 'rcld', 'rclr'}
    deriv   = drdbt(f,rad2bt(f,all_b(:,1)));
    dbt     = all_b(:,2)./(deriv*scale);
    dbt_err = all_berr(:,2)./(deriv*scale);
  case 'bias'
    dbt     = all_b(:,2);
    dbt_err = all_berr(:,2);
    deriv = NaN;
end

% Convert resid to BT units
switch fit_type
  case {'robs', 'rcld', 'rclr'}
    for i=1:nd
       all_bt_resid(i,:) = all_resid(i,:)./(deriv'*scale);
       all_bt_anom(i,:) = all_anom(i,:)./(deriv'*scale);
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
       save([fout int2str(latid_out)],'dbt','dbt_err','lag','deriv', 'all_b', 'all_berr', 'all_bt_anom', 'all_bt_resid', 'all_times', 'all_bcorr' );
       save([foutsm int2str(latid_out)],'dbt','dbt_err','all_b','all_berr','all_bcorr','all_rms','lag');
case 'savesmall'
       save([foutsm int2str(latid_out)],'dbt','dbt_err','all_b','all_berr','all_bcorr','all_rms','lag');
case 'savebig'
       save([fout int2str(latid_out)],'dbt','dbt_err','lag','deriv', 'all_b', 'all_berr', 'all_bt_anom', 'all_bt_resid', 'all_times', 'all_bcorr' );
end



