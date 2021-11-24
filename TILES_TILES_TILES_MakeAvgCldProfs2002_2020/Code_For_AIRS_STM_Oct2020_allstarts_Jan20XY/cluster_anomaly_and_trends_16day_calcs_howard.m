addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/DUSTFLAG
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS
addpath /home/sergio/MATLABCODE/CRODGERS_FAST_CLOUD
addpath /home/sergio/MATLABCODE/
addpath /asl/matlib/rtptools
addpath /asl/matlib/h4tools
addpath /asl/matlib/aslutil

addpath /asl/matlab2012/airs/readers
addpath /asl/matlib/aslutil
%addpath /asl/matlib/science
addpath /home/sergio/MATLABCODE/matlib/science/
addpath /asl/matlib/rtptools
addpath /asl/matlib/h4tools/
addpath /asl/matlib/rtptools/
addpath /asl/matlib/gribtools/
addpath /asl/matlib/time
addpath /home/sergio/MATLABCODE/matlib/clouds/sarta
addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/matlib/rtp_prod2/emis
addpath /home/sergio/MATLABCODE/matlib/rtp_prod2/grib
addpath /home/sergio/MATLABCODE/matlib/rtp_prod2/util
addpath /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/StrowCodeforTrendsAndAnomalies

tStart = tic; 

%% see ~/MATLABCODE/RTPMAKE/CLUST_RTPMAKE/CLUSTMAKE_ERA/cloud_set_defaults_run_maker.m
system_slurm_stats

JOB  = str2num(getenv('SLURM_ARRAY_TASK_ID'));  %% this is the chanID
%notdone = load('notfound.txt');
%JOB = notdone(JOB)
JOB0 = JOB;

JOB
load DATA/savercalc.mat

disp('loaded in  DATA/savercalc.mat  ... now proceceeding ... ')

spantime2002 = [];
for ii = 2002 : 2017
  startYY = ii; startMM = 01; startDD = 01;
  stopYY  = ii; stopMM  = 12; stopDD  = 31; 
  if ii == 2002
    startYY = 2002; startMM = 08; startDD = 29;
  elseif ii == 2017
    stopYY  = 2017; stopMM  = 11; stopDD  = 01; 
  end
  starttime2002 = change2days(startYY,startMM,startDD,2002);
  stoptime2002  = change2days(stopYY,stopMM,stopDD,2002);
  junkspan      = starttime2002 : 16 : stoptime2002;
  spantime2002  = [spantime2002 junkspan];
end

[hjunk,~,pjunk,~] = rtpread('DATA/pall_16daytimestep_016_2002_08_29_to_2002_09_13_16.rp.rtp');
yy = savercalc.yymmdd(:,1);
mm = savercalc.yymmdd(:,2);
dd = savercalc.yymmdd(:,3);
savedtime2002 = change2days(yy,mm,dd,2002);
rlat = savercalc.rlat;
rlon = savercalc.rlon;

[YYtime,iA,iB] = intersect(spantime2002,savedtime2002);
fprintf(1,'spantime2002  = dates we need              from 2002/08/20 to 2017/11/01 : numdays = %3i \n',length(spantime2002));
fprintf(1,'savedtime2002 = dates we have ERA runs for from 2002/08/20 to 2017/11/01 : numdays = %3i \n',length(savedtime2002));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% see /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/MakeProfs/clust_make_lats40_16dayavg_noseasonal_16daybdry.m
%% see /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/MakeProfs/do16dayavg.m

rcalc = squeeze(savercalc.rcalc(:,JOB,:));
warning off
for ii = 1 : 72*64
  if mod(ii,1000) == 0
    fprintf(1,'+')
  elseif mod(ii,100) == 0
    fprintf(1,'.')
  end

  x = savedtime2002;
  y = rcalc(:,ii);
  moo = find(isfinite(y));
  y = rad2bt(hjunk.vchan(JOB),y(moo));
  x = x(moo);

  Y = polyfit(x,y,1)*365;
  simpletrendpolyfit(ii) = Y(1);

  [b stats] = Math_tsfit_lin_robust(x,y,4);  %% b = array of size(1x10, and the linear daily trend is b(2)
  all_b = b;
  all_rms = stats.s;
  all_berr = stats.se;
  all_bcorr = stats.coeffcorr;
  all_resid = stats.resid;
  % Put linear back in for anomaly
  dr = (x/365).*all_b(2);
  theanom(ii,:) = all_resid + dr; %%% --->

  lineartrend(ii) = b(2);

end
warning on

fprintf(1,'\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

saver = ['save DATA/ANOM/channel' num2str(JOB,'%04d') '.mat rlat rlon theanom lineartrend savedtime2002 yy mm dd'];
eval(saver)

figure(1); scatter_coast(rlon,rlat,50,lineartrend); title('MathTsfit'); cx = caxis;
figure(2); scatter_coast(rlon,rlat,50,simpletrendpolyfit); title('Polyfit'); caxis(cx);
%figure(2); scatter_coast(rlon,rlat,50,lineartrend-simpletrendpolyfit);

disp('done!!')

monitor_memory_whos
