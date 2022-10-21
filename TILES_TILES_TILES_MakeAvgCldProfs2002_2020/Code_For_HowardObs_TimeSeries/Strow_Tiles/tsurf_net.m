load tsurf_minus_bt1231_net2.mat

addpath ~/Matlab
load_fairs

%[h,ha,p,pa] = rtpread('Data/ecmwf_airicrad_day087_random_stdemis.rtp');

fdir = '/asl/rtp/airs/airicrad_emistest/random_stdemis/2018/';
a = dir(fullfile(fdir,'*.rtp'));

for fni=1:length(a)

   [h,ha,p,pa] = rtpread(fullfile(fdir,a(fni).name));

% Either 19 pts (ocean) or 100 pts (land)

% Interpolation inputs
   landpts = [38:41];
   oceanpts = [10:13];

   ch_emis = NaN(2,length(p.rlat));

   freqs = [fairs(1513) fairs(1520)];
   afreqs = repmat(freqs,length(p.rlat),1);

   k = find(p.nemis == 19);
   for i=k
      ch_emis(:,i) = interp1(p.efreq(oceanpts,i),p.emis(oceanpts,i),freqs,'pchip');
   end

   k = find(p.nemis == 100);
   for i=k
      ch_emis(:,i) = interp1(p.efreq(landpts,i),p.emis(landpts,i),freqs,'pchip');
   end

   p.rclr_1228 = p.rclr(3,:);
   p.rclr_1231 = p.rclr(4,:);

   x1 = ch_emis(1,:);
   x2 = rad2bt(fairs(1520),p.rclr_1231)-rad2bt(fairs(1513),p.rclr_1228);
   x3 = rad2bt(fairs(1520),p.rclr_1231);
   x = double([x1; x2; x3]);

   y = double(p.stemp-rad2bt(fairs(1520),p.rclr_1231));
   yc = tsurf_minus_bt1231(x);

   fni
   tsurf_err_std(fni) = nanstd(y-yc);
   tsurf_err_mean(fni) = nanmean(y-yc);
end


% % ch_emis(1,:) is the 1228 cm-1 emissivity, ch_emis(2,:) is for 1231 cm-1
% 
% % Get which scenes fall into our tiling bins
% grid_ids = bin2d_asl(p.rlat,p.rlon,latB2,lonB2);
% 
% vars(1).name = 'robs1_1228';
% vars(2).name = 'robs1_1231';
% vars(3).name = 'rclr_1228';
% vars(4).name = 'rclr_1231';
% vars(5).name = 'satzen';
% vars(6).name = 'solzen';
% vars(7).name = 'landfrac';
% vars(8).name = 'stemp';
% vars(9).name = 'wspeed';
% vars(10).name = 'emis_1228';
% vars(11).name = 'emis_1231';
% 
% p.emis_1228 = ch_emis(1,:);
% p.emis_1231 = ch_emis(2,:);
% p.robs1_1228 = p.robs1(3,:);
% p.robs1_1231 = p.robs1(4,:);
% p.rclr_1228 = p.rclr(3,:);
% p.rclr_1231 = p.rclr(4,:);
% 
% % First time
% for i=1:64
%    for j = 1:72
%       for vi = 1:length(vars)
%          pg(i,j).(vars(vi).name) = p.(vars(vi).name)(grid_ids(i,j).k);
%       end
%    end
% end
% 
% % Remaining times
% for i=1:64
%    for j = 1:72
%       for vi = 1:length(vars)
%          pg(i,j).(vars(vi).name) = [pg(i,j).(vars(vi).name) p.(vars(vi).name)(grid_ids(i,j).k)];
%       end
%    end
% end


