addpath /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/MakeProfs

%% look at eg /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/MakeProfs/nucal_run_fit_lat.m

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
%JOB = 20;

latid = JOB;
iLatbin = JOB;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iObsOrCld = 1;  %% Cld
iObsOrCld = 0;  %% Obs
%iObsOrCld = -1; %% Clr

iOceanOrAll = -1; %% land/ocean, desc
iOceanOrAll = +1; %% ocean only, desc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath /home/sergio/MATLABCODE/TIME
start_time = utc2taiSergio(2012,05,01,00.0000);
stop_time  = utc2taiSergio(2018,04,31,23.99999);

start_time = datenum(2012,05,01);
stop_time = datenum(2019,04,30);

inst = 'airs';
inst = 'al1c';
inst='CrisNSR';
saveopt = 'savebig';

load /home/sergio/MATLABCODE/QUICKTASKS_TELECON/AIRS2CRIS_and_IASI2CRIS/sergio_airs2cris_decon/hstructure_lores.mat

fincal = []; %%
foutsm = [];

if iOceanOrAll == 1
  fin = ['/asl/data/stats/cris/clear/'];
  if iObsOrCld == 0
    fit_type = 'robs';
    fout = ['/home/sergio/MATLABCODE/QUICKTASKS_TELECON/AIRS2CRIS_and_IASI2CRIS/sergio_airs2cris_decon/SergioRates/Desc_ocean_fits/fit_robs_lat'];
  elseif iObsOrCld == 0
    fit_type = 'rclr';
    fout = ['/home/sergio/MATLABCODE/QUICKTASKS_TELECON/AIRS2CRIS_and_IASI2CRIS/sergio_airs2cris_decon/SergioRates/Desc_ocean_fits/fit_rclr_lat'];
  end
end

%% based on /home/sergio/MATLABCODE/QUICKTASKS_TELECON/AIRS2CRIS_and_IASI2CRIS/sergio_airs2cris_decon/load_cris_stats.m

rtime  = [];
robs   = [];
robsAV = [];
rclr   = [];
rclrAV = [];
for yy = 2012 : 2019
  fprintf(1,'yy = %4i \n',yy)
  fname = ['/asl/data/stats/cris/clear/rtp_cris_lowres_rad_' num2str(yy) '_clear_desc_ocean.mat'];
  loader = ['a = load(''' fname ''');'];
  eval(loader);
  rtime   = [rtime; squeeze(a.rtime_mean(:,iLatbin,5))];
  robs    = [robs; squeeze(a.robs(:,iLatbin,5,:))];
  robsAV  = [robsAV; squeeze(nanmean(squeeze(a.robs(:,iLatbin,:,:)),2))];
  rclr    = [rclr; squeeze(a.rclr(:,iLatbin,5,:))];
  rclrAV  = [rclrAV; squeeze(nanmean(squeeze(a.rclr(:,iLatbin,:,:)),2))];
  plot(rtime,robs(:,227)-robs(:,230),rtime,robsAV(:,227)-robsAV(:,230),'r'); pause(0.1)
end

%save junk.mat rtime robsAV rclrAV
count = ones(size(rtime)) * 1000;
fit_robust_one_lat_cris(fout,foutsm,latid,fit_type,start_time,stop_time,rtime,robsAV,rclrAV,count,saveopt);

return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% testing latbin = 20

%% 225 = 790 cm-1 window
%% 228 = 792 cm-1   co2
miaow = load('/home/sergio/MATLABCODE/QUICKTASKS_TELECON/AIRS2CRIS_and_IASI2CRIS/sergio_airs2cris_decon/SergioRates/Desc_ocean_fits/fit_robs_lat20');

[miaow.f([225 228]) hh.vchan([227 230])]

plot(1:2422,robsAV(:,227)-robsAV(:,230)-20.5,'b',1:2419,(miaow.all_bt_anom(:,225)-miaow.all_bt_anom(:,228)),'r')
hl = legend('raw obs','anomaly','location','best');

plot(1:2422,robsAV(:,230)-103,'b',1:2419,miaow.all_bt_anom(:,228),'r'); grid
plot(1:2422,robsAV(:,227)-123,'b',1:2419,miaow.all_bt_anom(:,225),'r'); grid

plot(miaow.f,rad2bt(miaow.f,miaow.all_b(:,1)),'b.-',hh.vchan,nanmean(rad2bt(hh.vchan,robsAV')'),'r.-')
