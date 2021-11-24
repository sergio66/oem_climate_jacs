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

tStart = tic; 

%% see ~/MATLABCODE/RTPMAKE/CLUST_RTPMAKE/CLUSTMAKE_ERA/cloud_set_defaults_run_maker.m
system_slurm_stats

yyS = 2002; mmS = 09; ddS = 01;
yyS = 2002; mmS = 01; ddS = 01;

yyE = 2002; mmE = 12; ddE = 31;
yyE = 2018; mmE = 08; ddE = 31;

days_since_2002_S = change2days(yyS,mmS,ddS,2002);
days_since_2002_E = change2days(yyE,mmE,ddE,2002);

doy0 = day_in_year(yyS,mmS,ddS);

sarta = '/home/sergio/SARTA_CLOUDY/BinV201/xsarta_apr08_m140_iceGHMbaum_waterdrop_desertdust_slabcloud_hg3';
sarta = '/home/chepplew/gitLib/sarta/bin/airs_l1c_2834_cloudy_may19_prod_v3';
ichan = load('sarta_chans_for_l1c.mat');
palts = load('/home/sergio/MATLABCODE/airsheights.dat');
palts = flipud(palts);

clear demall
demall.mmw     = [];
demall.stemp   = [];
demall.spres   = [];
demall.rclear  = [];
demall.rcloud  = [];
demall.iceOD   = [];
demall.icetop  = [];
demall.icefrac = [];
demall.waterOD   = [];
demall.watertop  = [];
demall.waterfrac = [];

iFoundFile = 0;
iCnt0 = 0;
iCnt0 = 252;  % so start at 253 = Jan 01, 2013
iCntF = 365;  % so end   at 365 = Dec 31, 2018

yy0 = yyS; mm0 = mmS; dd0 = ddS; N = 16;
daysX = change2days(yy0,mm0,dd0,2002);

iCnt = 0;
iFound = -1;
while daysX < days_since_2002_E & iFound < 0
  iCnt = iCnt + 1;
  iEndOfYear = -1;
  [yy1,mm1,dd1] = addNdays(yy0,mm0,dd0,N-1);
  if yy1 > yy0
    yy1 = yy0;
    mm1 = 12;
    dd1 = 31;
    iEndOfYear = +1;
  end
  [yy2,mm2,dd2] = addNdays(yy0,mm0,dd0,N  );

  u0 = utc2taiSergio(yy0,mm0,dd0,0.000000000000);
  u1 = utc2taiSergio(yy1,mm1,dd1,23.99999999999);
  u2 = utc2taiSergio(yy2,mm2,dd2,0.000000000000);
  deltadays = (u1-u0)/24/60/60; 
  daysX = change2days(yy1,mm1,dd1,2002);

  JOB0 = iCnt;
  JOB = JOB0;
  yy0 = floor((JOB-1)/23) + 2002;
  JOB = JOB-(yy0-2002)*23;
  fout = ['DATA/pall_16daytimestep_' num2str(JOB,'%03i') '_' num2str(yy0,'%04i') '_' num2str(mm0,'%02i') '_' num2str(dd0,'%02i') '_to_' num2str(yy1,'%04i') '_' num2str(mm1,'%02i') '_' num2str(dd1,'%02i') '_' num2str(JOB,'%2i') '.mat'];

    favgOP = ['DATA/pall_16daytimestep_' num2str(JOB,'%03i') '_' num2str(yy0,'%04i') '_' num2str(mm0,'%02i') '_' num2str(dd0,'%02i') '_to_' num2str(yy1,'%04i') '_' num2str(mm1,'%02i') '_' num2str(dd1,'%02i') '_' num2str(JOB,'%2i') '.op.rtp'];
    favgRP = ['DATA/pall_16daytimestep_' num2str(JOB,'%03i') '_' num2str(yy0,'%04i') '_' num2str(mm0,'%02i') '_' num2str(dd0,'%02i') '_to_' num2str(yy1,'%04i') '_' num2str(mm1,'%02i') '_' num2str(dd1,'%02i') '_' num2str(JOB,'%2i') '.rp.rtp'];

  if exist(fout)
    ee = 1;
    iFoundFile = iFoundFile + 1;
    fprintf(1,'%3i %s  +1 \n',iCnt,fout)

    clear x
    x = load(fout);
    px = gather_pall(x.h2x,x.pall);

    %% gather cloud stats
    demall.mmw   = [demall.mmw; px.mmw];
    demall.stemp = [demall.stemp; px.stemp];
    demall.spres = [demall.spres; px.spres];
    demall.rclear = [demall.rclear; px.sarta_rclearcalc(5,:)];
    demall.rcloud = [demall.rcloud; px.rcalc(5,:)];
    demall.iceOD = [demall.iceOD; px.iceOD];
    demall.icetop = [demall.icetop; px.icetop];
    demall.icefrac = [demall.icefrac; px.icefrac];
    demall.waterOD = [demall.waterOD; px.waterOD];
    demall.watertop = [demall.watertop; px.watertop];
    demall.waterfrac = [demall.waterfrac; px.waterfrac];
    demall.startdate(iFoundFile,:) = [yy0 mm0 dd0];
    demall.stopdate(iFoundFile,:)  = [yy1 mm1 dd1];

    %% run sarta cloudy
    hx = x.h2x;
    hx.ichan = (1:2645)';
    hx.ichan = ichan.ichan;
    hx.nchan = 2645;
    hx = rmfield(hx,'vchan');
    px = rmfield(px,'rcalc');
    px = rmfield(px,'sarta_rclearcalc');
    px = rmfield(px,'mean_clear_calc');
    px = rmfield(px,'mean_cloud_calc');
    px.nemis = floor(px.nemis);
    if ~isfield(px,'palts')
      px.palts = palts * ones(1,length(px.stemp));
    end
    px.upwell = ones(size(px.stemp));
    px.scanang = ones(size(px.stemp)) * 22;
    px.satzen = ones(size(px.stemp)) * 24;
    px.zobs   = ones(size(px.stemp)) * 705000;
    rtpwrite(favgOP,hx,[],px,[])
    sartaer = ['!time ' sarta ' fin=' favgOP ' fout=' favgRP ' > ugh'];
    eval(sartaer);
    rmer = ['!/bin/rm ' favgOP]; eval(rmer);

    %{
    [hjunk,hajunk,pjunk,pajunk] = rtpread(favgRP);
    scatter_coast(pjunk.rlon,pjunk.rlat,50,rad2bt(1231,pjunk.rcalc(1520,:))); 
    pause(0.1)
    %}
  
  else
    ee = 0;
    fprintf(1,'%3i %s DNE \n',iCnt,fout)
  end

  yy0 = yy2; mm0 = mm2; dd0 = dd2;
  if iEndOfYear == +1
    %yy0 = yy0 + 1; 
    mm0 = 01; dd0 = 01;
    [yy1,mm1,dd1] = addNdays(yy0,mm0,dd0,N-1);
    [yy0 mm0 dd0 yy1 mm1 dd1]
    %disp('ret to continue'); pause
    disp(' ')
  end    
end

demall.rlat = px.rlat;
demall.rlon = px.rlon;
demall.salti = px.salti;
demall.landfrac = px.landfrac;
demall.comment = 'see loop_gather_pall_howard.m';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
save DATA/demall_howard.mat demall
for iCnt = 1 : length(demall.startdate)
  simplemap(demall.rlat,demall.rlon,demall.mmw(iCnt,:),5); caxis([0 60]); title(num2str(iCnt)); pause(0.25);
end

do_the_trends
%}

