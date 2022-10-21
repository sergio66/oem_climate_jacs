function [r1231d, r1231a] = get_clear_time_series(lati,loni)


addpath /asl/matlib/aslutil
addpath /asl/matlib/time
addpath ~/Matlab/Math
load_fairs

fdirpre = 'Data/Quantv1';
fdirpre_out = 'Data/Quantv1_fits';

% loni = 40;
% lati = 1;

% % AIRS channel ID
% ch = 1520;

p = [-0.17 -0.15 -1.66  1.06];

fn = sprintf('LatBin%1$02d/LonBin%2$02d/summarystats_LatBin%1$02d_LonBin%2$02d_timesetps_001_412_V1.mat',lati,loni);
fn = fullfile(fdirpre,fn);

d = load(fn);

mtime = tai2dtime(airs2tai(d.tai93_desc));
dtime = datenum(mtime);

k_desc = d.count_desc./median(d.count_desc) > 0.90 & (mtime <= datetime(2020,8,28));
k_asc = d.count_asc./median(d.count_asc) > 0.90 & (mtime <= datetime(2020,8,28));


% Run off tsurf using bt1231/bt1228 regression for qi = 16;  
qi=12:16;
   r1231d = nanmean(squeeze(d.rad_quantile_desc(:,1520,qi)),2);
   
   
   r1231a = nanmean(squeeze(d.rad_quantile_asc(:,1520,qi)),2);

