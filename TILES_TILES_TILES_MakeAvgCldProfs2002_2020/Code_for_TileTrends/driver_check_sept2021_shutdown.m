addpath /asl/matlib/aslutil
addpath /asl/matlib/maps
addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs//StrowCodeforTrendsAndAnomalies/
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/COLORMAP
addpath /home/sergio/MATLABCODE/COLORMAP/LLS
load llsmap5

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myCluster = parcluster('Processes');
if myCluster.NumWorkers < 5
  disp('setting number of processors to 5')
  myCluster.NumWorkers = 5;
  saveProfile(myCluster);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% -rw-rwxr-- 1 sergio pi_strow  85M Sep 15  2023 
% -rw-rwxr-- 1 sergio pi_strow  83M Sep 15  2023 ch0080_timeseries2002_09_01_to_2023_08_25_D.mat
% -rw-rwxr-- 1 sergio pi_strow  83M Sep 15  2023 ch0128_timeseries2002_09_01_to_2023_08_25_D.mat

fname = 'ch1520_timeseries2002_09_01_to_2023_08_25_A.mat';
fname = 'ch1520_timeseries2002_09_01_to_2023_08_25_D.mat';
fname = 'ch2084_timeseries2002_09_01_to_2023_08_25_D.mat';
fname = 'ch1145_timeseries2002_09_01_to_2023_08_25_D.mat';
fname = 'ch1862_timeseries2002_09_01_to_2023_08_25_D.mat';
fname = 'ch0075_timeseries2002_09_01_to_2023_08_25_D.mat';
fname = 'ch2351_timeseries2002_09_01_to_2023_08_25_D.mat';

figure(1); clf
figure(2); clf
figure(3); clf
figure(4); clf
pause(0.1); 

eval(['load ' fname]);
fprintf(1,'loaded %s \n',fname);

load /home/sergio/MATLABCODE/CRODGERS_FAST_CLOUD/h2645structure.mat

chID = str2num(fname(3:6));
fprintf(1,'ChID = %4i freq = %8.3f \n',chID,h.vchan(chID));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

doy = change2days(savedate(:,1),savedate(:,2),savedate(:,3),2002);

iParallel = -1;
iParallel = +1;

tic

if iParallel > 0
  disp('Parallel')
  parpool(5)
  parfor qq = 1 : 5
    fprintf(1,'qq = %2i of 5 \n',qq);
    for tile = 1 : 4608
      junk = squeeze(timeseries1231(tile,qq,:));
      k = find(isfinite(junk));
      [B,stats,btanomaly,radanomaly] = compute_anomaly_wrapper(k,doy,junk,4,h.vchan(chID),+1);
      trend(tile,qq) = B(2);
      bt_anomaly(tile,qq,:) = btanomaly;
    end
  end
  delete(gcp('nocreate'))
else
  disp('Serial')
  for qq = 1 : 5
    fprintf(1,'qq = %2i of 5 \n',qq);
    for tile = 1 : 4608
      junk = squeeze(timeseries1231(tile,qq,:));
      k = find(isfinite(junk));
      [B,stats,btanomaly,radanomaly] = compute_anomaly_wrapper(k,doy,junk,4,h.vchan(chID),+1);
      trend(tile,qq) = B(2);
      bt_anomaly(tile,qq,:) = btanomaly;
    end
  end
end

toc

timeseries1231 = timeseries1231;                         %% radiance timeseries
bttimeseries1231 = rad2bt(h.vchan(chID),timeseries1231); %% bt       timeseries

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot_results_sept2021_shutdown

