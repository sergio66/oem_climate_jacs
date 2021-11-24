addpath /home/sergio/MATLABCODE/TIME
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
addpath /home/sergio/MATLABCODE/matlib/rtp_prod2_sbuczkowski/grib/

addpath /home/sergio/MATLABCODE/RTPMAKE/CLUST_RTPMAKE/GRIB/

tStart = tic; 

%% see ~/MATLABCODE/RTPMAKE/CLUST_RTPMAKE/CLUSTMAKE_ERA/cloud_set_defaults_run_maker.m
system_slurm_stats

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% so this happens if iFound > 0 ie success

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

h.ichan = cind1';
h.vchan = ff';

h.nchan = 7;
h.ptype = 0;
h.pfields = 1;

%load /home/motteler/shome/obs_stats/airs_tiling/latB64.mat
load latB64.mat
rlon = -180 : +180;          rlat = -90 : +90;
drlon = 5;                   drlat = 3;
rlon = -180 : drlon : +180;  rlat = -90 : drlat : +90;
rlon = rlon;                 rlat = latB2;

x = 0.5*(rlon(1:end-1)+rlon(2:end));  y = 0.5*(rlat(1:end-1)+rlat(2:end)); 

[Y,X] = meshgrid(x,y);
Y = Y(:);
X = X(:);

%% rember in RTP/summary_17years_all_lat_all_lon_2002_2019_palts_startSept2002.rtp
%% we essentially have       for jj = 1 : 64
%%                             for ii = 1 : 72
%%

JOB  = str2num(getenv('SLURM_ARRAY_TASK_ID'));  %% this is the gridbox
%JOB = 254     %% 2013/01/01 in clust_make_profs_data_howard_bins.m, but here GRIDBOX, A.Antaric, around -180 W, -82 S
%JOB = 2291    %% TWP over Indonesia

theX = mod(JOB,72); 
if theX == 0
  theX = 72;
end
theY = floor((JOB-0.1)/72) + 1;
testJOB = (theY-1)*72 + theX;

%{
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% testing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load latB64.mat
rlon = -180 : +180;          rlat = -90 : +90;
drlon = 5;                   drlat = 3;
rlon = -180 : drlon : +180;  rlat = -90 : drlat : +90;
rlon = rlon;                 rlat = latB2;

x = 0.5*(rlon(1:end-1)+rlon(2:end));  y = 0.5*(rlat(1:end-1)+rlat(2:end)); 

[Y,X] = meshgrid(x,y);
Y = Y(:);
X = X(:);

JOB = 1 : 72*64;
theX = mod(JOB,72); 
  %if theX == 0
  %  theX = 72;
  %end
ii = find(theX == 0);
  theX(ii) = 72;
theY = floor((JOB-0.1)/72) + 1;
testJOB = (theY-1)*72 + theX;
[sum(testJOB-JOB) sum(abs(testJOB-JOB))]

x1 = rlon(theX); x2 = rlon(theX+1); dx = x2-x1;
y1 = rlat(theY); y2 = rlat(theY+1); dy = y2-y1;

howard_16day_stats = load('stats_daily_howard_raw_gridded.mat');
for ii = 1 : length(x1)
  hid(ii) = find(howard_16day_stats.thesave.lon >= x1(ii) & howard_16day_stats.thesave.lat >= y1(ii) & ...
                 howard_16day_stats.thesave.lon <= x2(ii) & howard_16day_stats.thesave.lat <= y2(ii)); 
end
hidu = unique(hid); whos hid*

plot(hid,howard_16day_stats.thesave.meanhour_desc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% testing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%}

x1 = rlon(theX); x2 = rlon(theX+1); dx = x2-x1;
y1 = rlat(theY); y2 = rlat(theY+1); dy = y2-y1;
[x1 x2 y1 y2]

howard_16day_stats = load('stats_daily_howard_raw_gridded.mat');
hid = find(howard_16day_stats.thesave.lon >= x1 & howard_16day_stats.thesave.lat >= y1 & ...
           howard_16day_stats.thesave.lon <= x2 & howard_16day_stats.thesave.lat <= y2); 
if length(hid) == 0
  error('oh no could not find a matching id to howard stats')
end
hh_howard = howard_16day_stats.thesave.meanhour_desc(hid);

%% rtp can handle about 60000 pts
%% loop over lonbin so if 50 gridpts/box/day x 16 days * 60 box lat centers = 48000 points
Npts = 3000;   %% so about 48000 points per 16 day interval
%% hmm, there are 12150x240 points per day, so 12150x240*16 points per 16 days, divided into 64*72 gridboxes
%% so 10125 or about a granules worth of data points per grid box per 16 days
%% or about 632 per 24 hour period (and these would be asc and desc)
Npts = 300;
%% LLS made the valid point that ERA interim is really 1 deg res, so 3x5 is about 4x6 = 24 points!!!!!
Npts = 24;

run_sarta.clear = +1;
run_sarta.cloud = +1;
run_sarta.cumsum = 9999;  %% larrabee likes this, puts clouds high so does well for DCC
run_sarta.cumsum = -1;    %% this is "closer" to MRO but since cliuds are at centroid, does not do too well with DCC
run_sarta.sartacloud_code = '/home/chepplew/gitLib/sarta/bin/airs_l1c_2834_cloudy_may19_prod_v3';
run_sarta.sartaclear_code = '/home/chepplew/gitLib/sarta/bin/airs_l1c_2834_may19_prod_v2';

pa = {{'profiles','rtime','seconds since 1958'}};
ha = {{'header','hdf file','sergio haha'}};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iTempDir = -1;
if iTempDir > 0
  junkip = mktempS('junk.ip.rtp');
  junkop = mktempS('junk.op.rtp');
  junkrp = mktempS('junk.rp.rtp');
  junkyp = mktempS('junk.yp');
elseif iTempDir < 0
  junkip = ['/asl/s1/sergio/JUNK/MakeAvgProfs2002_2020/junk.ip.rtp_' num2str(JOB)];
  junkop = ['/asl/s1/sergio/JUNK/MakeAvgProfs2002_2020/junk.op.rtp_' num2str(JOB)];
  junkrp = ['/asl/s1/sergio/JUNK/MakeAvgProfs2002_2020/junk.rp.rtp_' num2str(JOB)];
  junkyp = ['/asl/s1/sergio/JUNK/MakeAvgProfs2002_2020/junk.yp.txt_' num2str(JOB)];
end

yy0 = 2013;
yyS = yy0; mmS = 01; ddS = 01;
yyE = yy0; mmE = 12; ddE = 31;

days_since_2002_S = change2days(yyS,mmS,ddS,2002);
days_since_2002_E = change2days(yyE,mmE,ddE,2002);
  days_since_2002_E = change2days(yyE+1,01,06,2002);  %% so we can skip over and have a full year

doy0 = day_in_year(yyS,mmS,ddS);

yy0 = yyS; mm0 = mmS; dd0 = ddS; N = 16;
daysX = change2days(yy0,mm0,dd0,2002);

gridstr = num2str(JOB,'%04i');
thedir = ['DATA_OneYear/DESC/' gridstr];
if ~exist(thedir)
  mker = ['!mkdir -p ' thedir];
  eval(mker);
end

for iCnt = 1 : 23
  [yy1,mm1,dd1] = addNdays(yy0,mm0,dd0,N-1);
  [yy2,mm2,dd2] = addNdays(yy0,mm0,dd0,N  );

  u0 = utc2taiSergio(yy0,mm0,dd0,0.000000000000);
  u1 = utc2taiSergio(yy1,mm1,dd1,23.99999999999);
  u2 = utc2taiSergio(yy2,mm2,dd2,0.000000000000);
  deltadays = (u1-u0)/24/60/60; 

  the16doy = (0:15) + day_in_year(yy0,mm0,dd0);
  [yyjunk,mmjunk,ddjunk] = addNdays(yy0,mm0,dd0,0:N-1);
  usertime0 = utc2taiSergio(yyjunk,mmjunk,ddjunk,1.30);  %% pretend we are getting the 1.30 am night overpass ...

  days_since_2002_S = change2days(yy0,mm0,dd0,2002);
  days_since_2002_E = change2days(yy1,mm1,dd1,2002);

  fout = [thedir '/pall_gridbox_' gridstr '_16daytimestep_' num2str(iCnt,'%03i') '_' num2str(yy0,'%04i') '_' num2str(mm0,'%02i') '_' num2str(dd0,'%02i') '_to_' num2str(yy1,'%04i') '_' num2str(mm1,'%02i') '_' num2str(dd1,'%02i') '.mat'];

  yy0 = yy2; mm0 = mm2; dd0 = dd2;

  if exist(fout)
    fout
    disp('fout already exists')
  else
    fprintf(1,'----->>>>>  %4i : %4i/%2i/%2i (00:01) to %4i/%2i/%2i (23:59) : num days = %8.5f \n',iCnt,yy0,mm0,dd0,yy1,mm1,dd1,deltadays);

    clear p p2 p2x
    p = struct;
    p.rlon = [];
    p.rlat = [];
    p.rtime = [];
   
    usertime = [];
    userlon = [];
    userlat = [];

    iMethod = -1;    %% default, old, random time, random lat/lon
    iMethod =  0;    %%          new, random time, lat/lon along border
    iMethod =  1;    %%          new, Howard time, lat/lon along border

    if iMethod == -1
      %% old, random time, random lat/lon
      for tt = 1 : length(yyjunk)
        clear randhour*
        randhourx = rand(1,Npts); 
        randhour = zeros(size(randhourx));
        randhour(randhourx < 0.25) = 0.0;
        randhour(randhourx > 0.25 & randhourx < 0.50) = 6.0;
        randhour(randhourx > 0.50 & randhourx < 0.75) = 12.0;
        randhour(randhourx > 0.75) = 18.0;

        usertime = [usertime sort(usertime0(tt) + randhour * 60 * 60)];
        userlon  = [userlon (rand(1,Npts)-0.5)*dx + x1];
        userlat  = [userlat (rand(1,Npts)-0.5)*dy + y1];
      end

    elseif iMethod == 0
      %% new, random time, lat lon at 1 deg grid points
      for tt = 1 : length(yyjunk)
        junklon = linspace(x1,x2,6);
        junklat = linspace(y1,y2,4);
        [JunkLat,JunkLon] = meshgrid(junklat,junklon);
        JunkLat = JunkLat(:);
        JunkLon = JunkLon(:);
        userlon  = [userlon JunkLon(:)'];
        userlat  = [userlat JunkLat(:)'];

        clear randhour*
        randhourx = rand(1,length(JunkLon)); 
        randhour = zeros(size(randhourx));
        randhour(randhourx < 0.25) = 0.0;
        randhour(randhourx > 0.25 & randhourx < 0.50) = 6.0;
        randhour(randhourx > 0.50 & randhourx < 0.75) = 12.0;
        randhour(randhourx > 0.75) = 18.0;
          
        usertime = [usertime sort(usertime0(tt) + randhour * 60 * 60)];
      end

    elseif iMethod == 1
      %% new, Howard time, lat lon at 1 deg grid points
      for tt = 1 : length(yyjunk)
        junklon = linspace(x1,x2,6);
        junklat = linspace(y1,y2,4);
        [JunkLat,JunkLon] = meshgrid(junklat,junklon);
        JunkLat = JunkLat(:);
        JunkLon = JunkLon(:);
        userlon  = [userlon JunkLon(:)'];
        userlat  = [userlat JunkLat(:)'];

        clear randhour*
        randhourx = rand(1,length(JunkLon)); 
        randhour = zeros(size(randhourx));
        randhour(randhourx < 0.25) = 0.0;
        randhour(randhourx > 0.25 & randhourx < 0.50) = 6.0;
        randhour(randhourx > 0.50 & randhourx < 0.75) = 12.0;
        randhour(randhourx > 0.75) = 18.0;
        randhour = ones(size(randhour)) * hh_howard;
          
        usertime = [usertime sort(usertime0(tt) + randhour * 60 * 60)];
      end
    end

    userlat(userlat >= +089.75) = +089.75;
    userlat(userlat <= -089.75) = -089.75;
    userlon(userlon >= +179.75) = +179.75;
    userlon(userlon <= -179.75) = -179.75;
  
    p.rlon  = userlon;
    p.rlat  = userlat;
    p.rtime = usertime;
  
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
    [p,h,pClosest] = fill_era_interp(p,h);
  
    [xyy,xmm,xdd,xhh] = tai2utcSergio(p.rtime);        %%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< for SdSM old time
    time_so_far = (xyy-2000) + ((xmm-1)+1)/12;
    co2ppm = 368 + 2.077*time_so_far;  %% 395.6933
    p.co2ppm = co2ppm;
    
    [p,pa] = rtp_add_emis(p,pa);
  
    [p2] = driver_sarta_cloud_rtp(h,ha,p,pa,run_sarta);
    p2 = convert_rtp_to_cloudOD(h,p2);
    tEnd(iCnt) = toc(tStart)
  
    rtpwrite(junkip,h,ha,p2,pa);
    klayers_code = '/asl/packages/klayersV205/BinV201/klayers_airs';
    klayerser = ['!' klayers_code ' fin=' junkip ' fout=' junkop ' > ugh'];
    eval(klayerser);
    [h2x,ha2x,p2x,pa2x] = rtpread(junkop);
    p2x.mmw = mmwater_rtp(h2x,p2x);
    p2x.rcalc = p2.rcalc;
    p2x.sarta_rclearcalc = p2.sarta_rclearcalc;
    rmer = ['!/bin/rm ' junkip ' ' junkop];
    eval(rmer);
  
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
    for iip = 1 : 4
      figure(iip); axis([x1 x2 y1 y2]);
    end
    pause(1)
  
    %% now do the 16 day averages
    p2x.satzen = abs(p2x.satzen);
    pavg = stats_average(h2x,p2x,[y1-eps y2+eps]);
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
    pavg  =  pavgx
  
    fprintf(1,' ---------->>> JOB = %4i len(p2x)=%5i len(pavg)=%5i \n',JOB,length(p2x.stemp),length(pavg.stemp))
    pavgx = do_clearcalc(h2x,pavgx,tempx,1);
  
    pavg.rcalc = pavgx.rcalc;
    pavg.sarta_rclearcalc = pavgx.sarta_rclearcalc;
    pavg.mean_clear_calc = mean_clear_calc;
    pavg.mean_cloud_calc = mean_cloud_calc;
  
    figure(5); scatter(pavg.rlat,pavg.rlon,10,rad2bt(h.vchan(5),pavg.rcalc(5,:))); title('BT1231 cloud calc');
    figure(6); scatter(pavg.rlat,pavg.rlon,10,rad2bt(h.vchan(5),pavg.sarta_rclearcalc(5,:))-rad2bt(h.vchan(5),pavg.rcalc(5,:))); title('BT1231 clear-cloud calc');
    figure(7); scatter(pavg.rlat,pavg.rlon,10,pavg.stemp-rad2bt(h.vchan(5),pavg.sarta_rclearcalc(5,:))); title('Stemp - BT1231 clear = WV and/or emissivity forcing');
    figure(8); scatter(pavg.rlat,pavg.rlon,10,pavg.mmw); title('mmw')
  
    figure(9); clf
      plot(-10:1:+100,hist(p2x.stemp-rad2bt(1231,p2x.rcalc(5,:)),-10:1:+100)); hold on
      plot(-10:1:+100,hist(p2x.stemp-rad2bt(1231,p2x.sarta_rclearcalc(5,:)),-10:1:+100)); hold off
      hl = legend('Stemp-CldCal','Stemp-ClrCal','location','best');
    figure(10); clf
      plot(200:320,histc(p2x.stemp,200:320),'k',200:320,histc(rad2bt(1231,p2x.rcalc(5,:)),200:320),'b',200:320,histc(rad2bt(1231,p2x.sarta_rclearcalc(5,:)),200:320),'r')
      hl = legend('Stemp','CldCal','ClrCal','location','best');
  
    rmer = ['!/bin/rm ' junkip ' ' junkop ' ' junkrp ' ' junkyp];
    eval(rmer);
    themem(iCnt) = monitor_memory_whos;
  
    comment = 'see clust_make_profs_data_howard_bins_OneYearStartJan1.m';
    saver = ['save ' fout ' pavg p2x h2x'];
    eval(saver);
  end  
end

tFinal = toc(tStart)

monitor_memory_whos;
