function [] = grid_create_bt_var_anom(ilat,start_time,stop_time);

addpath /asl/matlib/aslutil
addpath ~/Matlab/Math
load_fairs

fdir1 = '/asl/stats/airs/L1c_v672/gridded/grid_by_time/';
fdir2 = ['lat_' int2str(ilat)];

fdir = fullfile(fdir1,fdir2);
a = dir(fullfile(fdir,'grid_lat_lon*.mat'));

nf = length(a);

for nfi = 1:nf
   nfile = fullfile(fdir,a(nfi).name);
   load(nfile);

   nfi
   
   tx = mtime >= start_time & mtime <= stop_time;
   num_time_pts = length(find( tx == 1));

   x = datenum(mtime(tx))-datenum(mtime(tx(1)));
%   y = r_avg(tx,:);
   y= sqrt(r_var);
   for j=1:407
      deriv = drdbt(fairs,rad2bt(fairs,r_avg(j,:))');
      ynew(j,:) = y(j,:)./deriv';
   end
   y = ynew(tx,:);
   
   r_tot = r_tot(tx);
   k = r_tot > median(r_tot)*0.95;
   warning off
   for i=1:2645
      [b stats]=Math_tsfit_lin_robust(x(k),y(k,i),4);
      all_b(i,:) = b;
      all_berr(i,:) = stats.se;
      all_bt_resid(i,:) = stats.resid;
      dr = (x(k)/365).*all_b(i,2);
      all_bt_anom(i,:) = all_bt_resid(i,:) + dr';
      i;
   end
   warning on

   dbt = all_b(:,2);
   dbt_err = all_berr(:,2);

% Get lag-1, not worrying about missing time points
   for i=1:2645
      y = all_bt_resid(i,:);
      k = remove_nan(y);
      l = xcorr(y(k),1,'coeff');
      lag(i) = l(1);
   end
   
   bt_anom = NaN(2645,length(mtime));
   bt_resid = NaN(2645,length(mtime));

   bt_resid(:,k) = all_bt_resid;
   bt_anom(:,k) = all_bt_anom;

   b = all_b;
   berr = all_berr;

%    save(fullfile(fdir,['fit_' a(nfi).name]),'b', 'berr', 'bt_anom', 'bt_resid', 'dbt', 'dbt_err', 'mtime', 'k', 'r_tot', 'tx','lag');
%    save(fullfile(fdir,['short_fit_' a(nfi).name]),'b', 'berr',  'dbt', 'dbt_err', 'lag');

% if fitting var

   save(fullfile(fdir,['fit_var_' a(nfi).name]),'b', 'berr', 'bt_anom', 'bt_resid', 'mtime', 'k', 'r_tot', 'tx','lag');
   save(fullfile(fdir,['short_fit_var_' a(nfi).name]),'b', 'berr',  'lag');

   clear all_* r_* deriv glatb glonb stats x y bt_*

end

