function [] = grid_create_bt_anom_sergio(ilat,start_time,stop_time);

addpath /asl/matlib/aslutil
addpath ~/Matlab/Math
load_fairs

load sergio_lls_common_times

% fdir1 = '/asl/stats/airs/L1c_v672/gridded/grid_by_time/';
% fdir2 = ['lat_' int2str(ilat)];
% 
% fdir = fullfile(fdir1,fdir2);
% a = dir(fullfile(fdir,'grid_lat_lon*.mat'));
% 
% nf = length(a);

fdir1 = 'Data/calcs_mat/';
%fdir2 = ['lat_' int2str(ilat)];

fdir = fullfile(fdir1);
a = dir(fullfile(fdir,['breakout_lat_' int2str(ilat) '_lon*']));

pwd
fdiro = ['Data/era_grid_by_time/']
fdiro2 = ['lat_',int2str(ilat)]
fdiro3 = fullfile(fdiro,fdiro2)
mkdir(fdiro3);
nf = length(a);

for nfi = 1:nf
nfi

   nfile = fullfile(fdir,a(nfi).name);
   load(nfile);

%    tx = mtime >= start_time & mtime <= stop_time;
%    num_time_pts = length(find( tx == 1));
% 
%    x = datenum(mtime(tx))-datenum(mtime(tx(1)));
% %   y = r_avg(tx,:);
%    y = r_var(tx,:);
%    r_tot = r_tot(tx);

%   y = rcld(isergio,:);
%   y = rclr(isergio,:);
   y = robs1(isergio,:);
   x = datenum(mtime(ills)-mtime(ills(1)));
   warning off
   for i=1:2645
      [b stats]=Math_tsfit_lin_robust(x,y(:,i),4);
      all_b(i,:) = b;
      all_berr(i,:) = stats.se;
      all_resid(i,:) = stats.resid;
      dr = (x/365).*all_b(i,2);
      all_anom(i,:) = all_resid(i,:) + dr';
      i;
   end
   warning on


disp('out of nu loop')
   
   deriv = drdbt(fairs,rad2bt(fairs,all_b(:,1)));

   dbt = all_b(:,2)./deriv;
   dbt_err = all_berr(:,2)./(deriv);

   all_bt_resid = all_resid./(deriv);
   all_bt_anom = all_anom./(deriv);

% Get lag-1, not worrying about missing time points
   for i=1:2645
      y = all_bt_resid(i,:);
      k = remove_nan(y);
      l = xcorr(y(k),1,'coeff');
      lag(i) = l(1);
   end
   
   bt_anom = NaN(2645,length(isergio));
   bt_resid = NaN(2645,length(isergio));

   bt_resid = all_bt_resid;
   bt_anom = all_bt_anom;

   b = all_b;
   berr = all_berr;

%    save(fullfile(fdir,['fit_' a(nfi).name]),'b', 'berr', 'bt_anom', 'bt_resid', 'dbt', 'dbt_err', 'mtime', 'k', 'r_tot', 'tx','lag');
%    save(fullfile(fdir,['short_fit_' a(nfi).name]),'b', 'berr',  'dbt', 'dbt_err', 'lag');



   fnout = fullfile(fdiro3,['robs_fit_grid_lat_lon_' int2str(ilat) '_' int2str(nfi)]);
   save(fnout,'b', 'berr', 'bt_anom', 'bt_resid', 'dbt', 'dbt_err', 'mtime', 'lag');
   fnout = fullfile(fdiro3,['short_robs_fit_grid_lat_lon_' int2str(ilat) '_' int2str(nfi)]);
   save(fnout,'b', 'berr',  'dbt', 'dbt_err', 'lag');

   clear all_* r_* deriv glatb glonb stats x y

end

