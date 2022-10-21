cd /home/motteler/shome/obs_stats

cd source
addpath ../source
addpath /asl/packages/ccast/source
addpath /asl/packages/ccast/motmsc/time
addpath /home/motteler/shome/obs_stats/sst_source
addpath ../obs_16day_airs_c5
addpath /home/strow/Work/Airs/Tiles  % override Howard's oisst_match


cd ../obs_16day_airs_c5
%load airs_c04y2019s02.mat
%load airs_c04y2018s14.mat

addpath /asl/matlib/time
addpath /asl/matlib/aslutil
load_fairs

a = dir('airs_c05y*mat')

% load ../airs_tiling/latB64
% 
% lonB2 = -180:5:180;

% load ../airs_tiling/latB64
% 
% lonB2 = -180:5:180;

% lonB2 = -180:2:180;
% latB2 = -90:2:90;

load equal_area_latB.mat

% hottest = NaN(48,90,414,50);
% hottest_sst = NaN(48,90,414,50);

for ixx=1:length(a)
   a(ixx).name
   
   load(a(ixx).name);

   bt_lw = rad2bt(vlist(3),rad_list(3,:));
   bt_sw = rad2bt(vlist(3),rad_list(3,:));

   [n,xe,ye,binx,biny] = histcounts2(lon_list,lat_list,lonB,latB);
% 
% gi = biny == 35 & binx == 32;
% 
% bti = bt(gi);
% 
% [m,i]=sort(bti,'descend');
% 
% 
% m(1)-mean(m(1:50))
% 
% length(find(gi ==1))

% sst_list = oisst_match(tai_list(gi), lat_list(gi), lon_list(gi));
% sst_list = sst_list + 273.15;

nlat = length(ye)-1;
nlon = length(xe)-1;

for ilat = 1:nlat
   ilat
   for ilon = 1:nlon
      gi = (binx == ilon) & (biny == ilat);
      gi2 = asc_list == 1;
      gi = gi & gi2;
      gi3 = asc_list == 0;
      bti = bt(gi);
      bti3 = bt(gi3);
      [m,i]=sort(bti,'descend');
      [m3,i3]=sort(bti3,'descend');
      if length(m) > 60
         mn = trunc(mn/50);
         hottest1(ilat,ilon,ixx,:) = nanmean(m(1:mn));
         nobs(ilat,ilon) = mn;
         bti2 = rad2bt(vlist(6),rad_list(6,gi));
         hottest2(ilat,ilon,ixx,:) = nanmean(bti2(i));
      else
         hottest1(ilat,ilon,ixx,:) = NaN;
         hottest2(ilat,ilon,ixx,:) = NaN;
         nobs(ilat,ilon) = NaN;
      end
      if length(m3) > 60
         mn3 = trunc(mn3/50);
         hottest1x(ilat,ilon,ixx,:) = nanmean(m3(1:mn3));
         nobsx(ilat,ilon) = mn3;
         bti4 = rad2bt(vlist(6),rad_list(6,gi3));
         hottest2x(ilat,ilon,ixx,:) = nanmean(bti4(i3));
      else
         hottest1x(ilat,ilon,ixx,:) = NaN;
         hottest2x(ilat,ilon,ixx,:) = NaN;
         nobsx(ilat,ilon) = NaN;
      end
   end
end


end


% save /asl/s1/strow/airs_c04y2019s02_hot_info  hottest hottest100 hottest_sst hottest100_sst sst_mean
save /asl/s1/strow/hottest  hottest* nobs* 