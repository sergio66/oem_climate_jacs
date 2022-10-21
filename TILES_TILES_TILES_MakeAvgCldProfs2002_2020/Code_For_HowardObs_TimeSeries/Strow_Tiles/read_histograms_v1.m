addpath /asl/matlib/aslutil
addpath /asl/matlib/time
addpath ~/Matlab/Math
load_fairs
fdirpre = 'Data/Quantv1';
fdirpre_out = 'Data/Quantv1_fits';

hist1231_asc = NaN(64,72,412,161);
hist1231_desc = NaN(64,72,412,161);

bt_asc = NaN(64,72,412);
bt_desc = NaN(64,72,412);

for ilat = 1:64
ilat
   for ilon = 1:72

%function [] = read_histograms_v1(loni,lati)




% loni = 40;
% lati = 1;

% % AIRS channel ID
% ch = 1520;


fn = sprintf('LatBin%1$02d/LonBin%2$02d/summarystats_LatBin%1$02d_LonBin%2$02d_timesetps_001_412_V1.mat',ilat,ilon);
fn = fullfile(fdirpre,fn);

d = load(fn,'hist1231_asc','hist1231_desc','rad_quantile_desc','rad_quantile_asc');

r_asc = squeeze(d.rad_quantile_asc(:,1520,12:16));
r_asc = nanmean(r_asc,2);
bt_asc(ilat,ilon,:) = rad2bt(fairs(1520),r_asc);

r_desc = squeeze(d.rad_quantile_desc(:,1520,12:16));
r_desc = nanmean(r_desc,2);
bt_desc(ilat,ilon,:) = rad2bt(fairs(1520),r_desc);


hist1231_asc(ilat,ilon,:,:) = d.hist1231_asc;
hist1231_desc(ilat,ilon,:,:) = d.hist1231_desc;

   end
end


% % Create output dir if needed
% fnout_dir = sprintf('LatBin%1$02d/LonBin%2$02d',lati,loni);
% fnout_dir = fullfile(fdirpre_out,fnout_dir)
% if exist(fnout_dir) == 0
%    mkdir(fnout_dir)
% end
% 
% % Create outputfile name and save
% 
% fnout = sprintf('LatBin%1$02d/LonBin%2$02d/tsurf_fits_LonBin%2$02d_LatBin%1$02d_V1.mat',lati,loni);
% fnout = fullfile(fdirpre_out,fnout);
% 
% save(fnout,'lag_desc_tsurf','lag_asc_tsurf');


%   count_asc                        1x412                     3296  double                
%   count_desc                       1x412                     3296  double                
% 
%   lat_asc                          1x412                     3296  double                
%   lat_desc                         1x412                     3296  double                
%   
%   lon_asc                          1x412                     3296  double                
%   lon_desc                         1x412                     3296  double                
%   
%   meanBT_asc                     412x2645                 4358960  single                
%   meanBT_desc                    412x2645                 4358960  single                
%   
%   quantile1231_asc               412x16                     52736  double                
%   quantile1231_desc              412x16                     52736  double                
%   quants                           1x17                       136  double                
%   
%   rad_quantile_asc               412x2645x16            139486720  double                
%   rad_quantile_desc              412x2645x16            139486720  double                
%   
%   satzen_asc                       1x412                     3296  double                
%   satzen_desc                      1x412                     3296  double                
%   
%   satzen_quantile1231_asc        412x16                     52736  double                
%   satzen_quantile1231_desc       412x16                     52736  double                
%   
%   solzen_asc                       1x412                     3296  double                
%   solzen_desc                      1x412                     3296  double                
%   
%   solzen_quantile1231_asc        412x16                     52736  double                
%   solzen_quantile1231_desc       412x16                     52736  double                
% 
%   tai93_asc                        1x412                     3296  double                
%   tai93_desc                       1x412                     3296  double                

