function savestuff = tile_loop1A;

%
% tile_loop1 -- airs tiling read tests
%

% set up source paths
addpath /home/motteler/shome/chirp_test
addpath /home/motteler/cris/ccast/motmsc/utils
addpath /home/motteler/cris/ccast/motmsc/time
addpath /home/motteler/cris/ccast/source

% get latitude bands
% dLat = 3;
% latB = -90 : dLat : 90;    
d1 = load('latB64');
latB = d1.latB2;  
nlat = length(latB) - 1;

% get longitude bands
dLon = 5;
lonB = -180 : dLon : 180;
nlon = length(lonB) - 1;

% buffered tests
thome = '/asl/isilon/airs/tile_test7';
tpre = 'tile';

% tabulate max obs/tile
max_obs = zeros(nlat, nlon); 

[Y2,X2] = meshgrid(0.5*(latB(1:end-1)+latB(2:end)),0.5*(lonB(1:end-1)+lonB(2:end)));
Y2 = Y2(:);
X2 = X2(:);

% outer loop on tiles
iCnt = 0;
for ilat = 1 : nlat
  for ilon = 1 : nlon
   
    % inner loop on sets
    for iset = 1 : 1

      [tname, tpath] = tile_file(ilat, ilon, latB, lonB, iset, tpre);
      tfull = fullfile(thome, tpath, tname);
      iCnt = iCnt + 1;
      savestuff.name{iCnt} = tfull;
      savestuff.ilat(iCnt) = ilat;
      savestuff.ilon(iCnt) = ilon;
      savestuff.rlat(iCnt) = Y2(iCnt);
      savestuff.rlon(iCnt) = X2(iCnt);

      %d1 = read_netcdf_h5(tfull);

%      if ~issorted(d1.tai93)
%        fprintf(1, 'tile %d %d time not sorted\n', ilat, ilon)
%      end
%      if ~unique(d1.tai93)
%        fprintf(1, 'tile %d %d time not unique\n', ilat, ilon)
%      end

%      % find max obs for this tile
%      if max_obs(ilat, ilon) < d1.total_obs
%        max_obs(ilat, ilon) = d1.total_obs;
%      end

    end % loop on sets
  end % loop on lon
  fprintf(1, '.')
end % loop on lat
fprintf(1, '\n')

save howard_tile_loop1A.mat  savestuff
disp('saved into howard_tile_loop1A.mat')

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% save the max counts
save max_obs max_obs

fprintf(1, 'max tile obs %d\n', max(max_obs(:)))
% plot max obs by latitude
xx = (latB(1:end-1) + latB(2:end)) ./ 2;
plot(xx, max_obs, 'o')
xlim([-95, 95])
title('tile max obs count by latitude')
xlabel('latitude')
grid on

