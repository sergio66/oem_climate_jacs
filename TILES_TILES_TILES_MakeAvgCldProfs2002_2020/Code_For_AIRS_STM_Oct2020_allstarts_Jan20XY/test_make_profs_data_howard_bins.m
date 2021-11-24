addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/DUSTFLAG
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS
addpath /home/sergio/MATLABCODE/CRODGERS_FAST_CLOUD
addpath /home/sergio/MATLABCODE/
addpath /asl/matlib/rtptools
addpath /asl/matlib/h4tools
addpath /asl/matlib/aslutil

addpath /home/sergio/MATLABCODE/CRODGERS_FAST_CLOUD/
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

%load /home/motteler/shome/obs_stats/airs_tiling/latB64.mat
load latB64.mat

tStart = tic; 

%% see ~/MATLABCODE/RTPMAKE/CLUST_RTPMAKE/CLUSTMAKE_ERA/cloud_set_defaults_run_maker.m
system_slurm_stats

%JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));  %% this is the 16 day span
%notdone = load('notfound.txt');
%JOB = notdone(JOB)
JOB = 16

% 15 : 2002/ 8/13 (00:01) to 2002/ 8/28 (23:59)
if JOB <= 15
  error('JOB 15 : 2002/ 8/13 (00:01) to 2002/ 8/28 (23:59) .. need JOB > 15')
end

yy0 = floor((JOB-1)/23) + 2002;
JOB = JOB-(yy0-2002)*23;

yyS = yy0; mmS = 01; ddS = 01;
yyE = yy0; mmE = 12; ddE = 31;

days_since_2002_S = change2days(yyS,mmS,ddS,2002);
days_since_2002_E = change2days(yyE,mmE,ddE,2002);
  days_since_2002_E = change2days(yyE+1,01,06,2002);  %% so we can skip over and have a full year

doy0 = day_in_year(yyS,mmS,ddS);

iCnt = 0;
yy0 = yyS; mm0 = mmS; dd0 = ddS; N = 16;
daysX = change2days(yy0,mm0,dd0,2002);

iFound = -1;
while daysX < days_since_2002_E & iFound < 0
  iCnt = iCnt + 1;
  [yy1,mm1,dd1] = addNdays(yy0,mm0,dd0,N-1);
  if yy1 > yy0
    yy1 = yy0;
    mm1 = 12;
    dd1 = 31;
  end
  [yy2,mm2,dd2] = addNdays(yy0,mm0,dd0,N  );

  u0 = utc2taiSergio(yy0,mm0,dd0,0.000000000000);
  u1 = utc2taiSergio(yy1,mm1,dd1,23.99999999999);
  u2 = utc2taiSergio(yy2,mm2,dd2,0.000000000000);
  deltadays = (u1-u0)/24/60/60; 
  daysX = change2days(yy1,mm1,dd1,2002);  
  
  if JOB == iCnt & daysX <= days_since_2002_E
    iFound = +1;
    fprintf(1,'%4i : %4i/%2i/%2i (00:01) to %4i/%2i/%2i (23:59) : num days = %8.5f \n',iCnt,yy0,mm0,dd0,yy1,mm1,dd1,deltadays);
  else
    yy0 = yy2; mm0 = mm2; dd0 = dd2;
  end
end

if iFound < 0
  %% failure : asked for too much time from 2002/09/01
  if JOB > iCnt
    [iCnt JOB]
    error('oops too many 16 day steps for JOB! a job too far');
  elseif JOB == iCnt & iFound == -1
    [iCnt JOB]
    fprintf(1,'%4i : YYE = %4i/%2i/%2i (noon) and current 16 day stops at %4i/%2i/%2i (noon) \n',iCnt,yyE,mmE,ddE,yy1,mm1,dd1);  
    error('oops just enough 16 day steps for JOB! but end date is past YYE/MME/DDE');
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% so this happens if iFound > 0 ie success

fout = ['DATA/pall_16daytimestep_' num2str(JOB,'%03i') '_' num2str(yy0,'%04i') '_' num2str(mm0,'%02i') '_' num2str(dd0,'%02i') '_to_' num2str(yy1,'%04i') '_' num2str(mm1,'%02i') '_' num2str(dd1,'%02i') '_' num2str(JOB,'%2i') '.mat'];

if exist(fout)
  fout
  error('fout already exists')
end

junkip = mktempS('junk.ip.rtp');
junkop = mktempS('junk.op.rtp');
junkrp = mktempS('junk.rp.rtp');
junkyp = mktempS('junk.yp');

%% this is from cloud_set_defaults_run_maker.m
hdffile = '/home/sergio/MATLABCODE/airs_l1c_srf_tables_lls_20181205.hdf';   % what he gave in Dec 2018
vchan2834 = hdfread(hdffile,'freq');
f = vchan2834;
load sarta_chans_for_l1c.mat
theinds2645 = ichan;
f2645 = f(ichan);
      h2645.nchan = length(theinds2645);
      h2645.ichan = theinds2645;
      h2645.vchan = f2645;

freqsNchans
airs2645to2378 = load('//home/sergio/MATLABCODE/CRODGERS_FAST_CLOUD/map2645to2378.mat');
h.ichan = airs2645to2378.closest2645to2378_ind(cind1)';
h.vchan = airs2645to2378.hvchan2645(h.ichan);
%{
for ii = 1 : length(cind1)
  boo = abs(ff(ii)-f2645);
  boo = find(boo == min(boo));
  bonk(ii) = boo;
end
bonk' - h.ichan
%}

h.ichan = cind1';
h.vchan = ff';

h.nchan = 7;
h.ptype = 0;
h.pfields = 1;

rlon = -180 : +180;          rlat = -90 : +90;
drlon = 5;                   drlat = 3;
rlon = -180 : drlon : +180;  rlat = -90 : drlat : +90;
rlon = rlon;                 rlat = latB2;

x = 0.5*(rlon(1:end-1)+rlon(2:end));  y = 0.5*(rlat(1:end-1)+rlat(2:end)); 

%% rtp can handle about 60000 pts
%% loop over lonbin so if 50 gridpts/box/day x 16 days * 60 box lat centers = 48000 points

Npts = 50; %% to give about 48 points per day per grid box so 768 per 16 days per grid box; and 60 lat grid boxes so 48000 point per rtp file
the16doy = (0:15) + day_in_year(yy0,mm0,dd0);
[yyjunk,mmjunk,ddjunk] = addNdays(yy0,mm0,dd0,0:N-1);
%usertime0 = utc2taiSergio(yyjunk,mmjunk,ddjunk,1.30);  %% pretend we are getting the 1.30 am night overpass ...
usertime0 = utc2taiSergio(yyjunk,mmjunk,ddjunk,0.00);   %% start from midnight that day

run_sarta.clear = +1;
run_sarta.cloud = +1;
run_sarta.cumsum = -1;    %% this is "closer" to MRO but since cliuds are at centroid, does not do too well with DCC
run_sarta.cumsum = 9999;  %% larrabee likes this, puts clouds high so does well for DCC
run_sarta.sartacloud_code = '/home/chepplew/gitLib/sarta/bin/airs_l1c_2834_cloudy_may19_prod_v3';
run_sarta.sartaclear_code = '/home/chepplew/gitLib/sarta/bin/airs_l1c_2834_may19_prod_v2';

pa = {{'profiles','rtime','seconds since 1958'}};
ha = {{'header','hdf file','sergio haha'}};

for ii = floor(length(x)/2) : length(x)   %% outermost loop : scan latitude
  fprintf(1,'longitude index %2i of %2i \n',ii,length(x));
  clear p p2 p2x
  p = struct;
  p.rlon = [];
  p.rlat = [];
  p.rtime = [];
 
  usertime = [];
  userlon = [];
  userlat = [];
  for tt = 1 : length(yyjunk)
    for jj = 1 : length(y)
      randhourx = rand(1,Npts); 
      randhour(randhourx < 0.25) = 0.0;
      randhour(randhourx > 0.25 & randhourx < 0.50) = 6.0;
      randhour(randhourx > 0.50 & randhourx < 0.75) = 12.0;
      randhour(randhourx > 0.75) = 18.0;
      
      usertime = [usertime sort(usertime0(tt) + randhour * 60 * 60)];
      userlon  = [userlon  (rand(1,Npts)-0.5)*drlon + x(ii)];
      userlat  = [userlat  (rand(1,Npts)-0.5)*drlat + y(jj)];
    end
  end
  userlat(userlat >= +89.75) = +89.75;
  userlat(userlat <= -89.75) = -89.75;

  p.rlon  = [p.rlon userlon];
  p.rlat  = [p.rlat userlat];
  p.rtime = [p.rtime usertime];

  rmpath /umbc/xfs2/strow/asl/matlib/science/
  [salti, landfrac] = usgs_deg10_dem(p.rlat, p.rlon);
  p.landfrac = landfrac;
  p.salti    = salti;
  p.zobs     = 705000 * ones(size(p.salti));
  p.scanang  = rand(1,length(p.rtime))*48;  boo = rand(1,length(p.rtime)); p.scanang(boo < 0.5) = -p.scanang(boo < 0.5);
  p.satzen   = vaconv(p.scanang, p.zobs, zeros(size(p.zobs)));
  p.wspeed   = rand(size(p.salti)) * 10;
  p.solzen   = ones(size(p.salti)) * 150;
  p.upwell   = ones(size(p.salti));
  
  clrfields = {'SP','SKT','10U','10V','TCC','CI','T','Q','O3'};
  cldfields = {'SP','SKT','10U','10V','TCC','CI','T','Q','O3',...
               'CC','CIWC','CLWC'};

  %[h,ha,p,pa] = rtpadd_era_data(h,ha,p,pa,cldfields); %%% add on era
  [p,h] = fill_era(p,h);

  [xyy,xmm,xdd,xhh] = tai2utcSergio(p.rtime);        %%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< for SdSM old time
  time_so_far = (xyy-2000) + ((xmm-1)+1)/12;
  co2ppm = 368 + 2.077*time_so_far;  %% 395.6933
  p.co2ppm = co2ppm;
  
  [p,pa] = rtp_add_emis(p,pa);

  [p2] = driver_sarta_cloud_rtp(h,ha,p,pa,run_sarta);
  p2 = convert_rtp_to_cloudOD(h,p2);
  tEnd(ii) = toc(tStart)

  rtpwrite(junkip,h,ha,p2,pa);
  klayers_code = '/asl/packages/klayersV205/BinV201/klayers_airs';
  klayerser = ['!' klayers_code ' fin=' junkip ' fout=' junkop ' > ugh'];
  eval(klayerser);
  [h2x,ha2x,p2x,pa2x] = rtpread(junkop);
  p2x.mmw = mmwater_rtp(h2x,p2x);
  p2x.rcalc = p2.rcalc;
  p2x.sarta_rclearcalc = p2.sarta_rclearcalc;

  p2x.icewaterfrac = p2.icewaterfrac;
  p2x.icectype = p2.icectype;
  p2x.icecngwat = p2.icecngwat;
  p2x.iceOD = p2.iceOD;
  p2x.icetopT = p2.icetopT;
  p2x.icetop = p2.icetop;
  p2x.icebot = p2.icebot;
  p2x.icesze = p2.icesze;
  p2x.icefrac = p2.icefrac;

  p2x.waterctype = p2.waterctype;
  p2x.watercngwat = p2.watercngwat;
  p2x.waterOD = p2.waterOD;
  p2x.watertopT = p2.watertopT;
  p2x.watertop = p2.watertop;
  p2x.waterbot = p2.waterbot;
  p2x.watersze = p2.watersze;
  p2x.waterfrac = p2.waterfrac;

  figure(1); simplemap(p.rlat,p.rlon,rad2bt(h.vchan(5),p2.rcalc(5,:))); title('BT1231 cloud calc');
  figure(2); simplemap(p.rlat,p.rlon,rad2bt(h.vchan(5),p2.sarta_rclearcalc(5,:))-rad2bt(h.vchan(5),p2.rcalc(5,:))); title('BT1231 clear-cloud calc');
  figure(3); simplemap(p.rlat,p.rlon,p.stemp-rad2bt(h.vchan(5),p2.sarta_rclearcalc(5,:))); title('Stemp - BT1231 clear = WV and/or emissivity forcing');
  figure(4); simplemap(p.rlat,p.rlon,p2x.mmw); title('mmw')
  pause(1)

  %% now do the 16 day averages
  p2x.satzen = abs(p2x.satzen);
  pavg = stats_average(h2x,p2x,rlat);
  mean_clear_calc = pavg.sarta_rclearcalc;
  mean_cloud_calc = pavg.rcalc;

  tempx.tempfile2 = junkop;
  tempx.tempfile3 = junkrp;
  tempx.tempfile4 = junkyp;
  tempx.sarta     = run_sarta.sartacloud_code;
  pavgx = pavg;
  pavgx = sanity_check_thermodynamic_gas_profiles(pavgx);
  pavgx = sanity_check(pavgx);
  pavgx = convert_rtp_to_cloudOD(h2x,pavgx);
  pavgx = do_clearcalc(h2x,pavgx,tempx,1);

  pavg.rcalc = pavgx.rcalc;
  pavg.sarta_rclearcalc = pavgx.sarta_rclearcalc;
  pavg.mean_clear_calc = mean_clear_calc;
  pavg.mean_cloud_calc = mean_cloud_calc;

  %{
  plot(h2x.vchan,nanmean(rad2bt(h2x.vchan,pavg.mean_clear_calc)'-rad2bt(h2x.vchan,pavg.sarta_rclearcalc)'),'b',...
       h2x.vchan,nanmean(rad2bt(h2x.vchan,pavg.mean_cloud_calc)'-rad2bt(h2x.vchan,pavg.rcalc)'),'r',...
       h2x.vchan,nanstd(rad2bt(h2x.vchan,pavg.mean_clear_calc)'-rad2bt(h2x.vchan,pavg.sarta_rclearcalc)'),'c--',...
       h2x.vchan,nanstd(rad2bt(h2x.vchan,pavg.mean_cloud_calc)'-rad2bt(h2x.vchan,pavg.rcalc)'),'m--',...
       h2x.vchan,nanmean(rad2bt(h2x.vchan,pavg.mean_clear_calc)'-rad2bt(h2x.vchan,pavg.mean_cloud_calc)'),'k',...
       h2x.vchan,nanstd(rad2bt(h2x.vchan,pavg.mean_clear_calc)'-rad2bt(h2x.vchan,pavg.mean_cloud_calc)'),'k--',...
       h2x.vchan,nanmean(rad2bt(h2x.vchan,pavg.sarta_rclearcalc)'-rad2bt(h2x.vchan,pavg.rcalc)'),'g',...
       h2x.vchan,nanstd(rad2bt(h2x.vchan,pavg.sarta_rclearcalc)'-rad2bt(h2x.vchan,pavg.rcalc)'),'g--'); grid
  %}

  pall.yymmddS   = [yy0 mm0 dd0];
  pall.yymmddE   = [yy1 mm1 dd1];
  pall.latbins   = rlat;
  pall.latavg    = y;
  pall.lonbins   = rlon;
  pall.lonavg    = x;
  pall.pavg(ii)  = pavg;
  tEnd2(ii) = toc(tStart)

  rmer = ['!/bin/rm ' junkip ' ' junkop ' ' junkrp ' ' junkyp];
  eval(rmer);
  themem(ii) = monitor_memory_whos;
error('sk;jgalkjggljkgslkj')

end

tFinal = toc(tStart)

saver = ['save ' fout ' pall h2x'];
eval(saver);
monitor_memory_whos;
