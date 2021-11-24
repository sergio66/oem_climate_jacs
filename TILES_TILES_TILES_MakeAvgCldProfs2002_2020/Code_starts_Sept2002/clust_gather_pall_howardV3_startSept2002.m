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


yy0 = 2005;
JOB = 1;
fHoward = ['/home/motteler/shome/obs_stats/map_16day_airs_all/airs_map_all_y' num2str(yy0,'%04i') 's' num2str(JOB,'%02i') '.mat'];
howard = load(fHoward);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));  %% this is the 16 day span
%JOB = 15

tStart = tic; 

%% see ~/MATLABCODE/RTPMAKE/CLUST_RTPMAKE/CLUSTMAKE_ERA/cloud_set_defaults_run_maker.m
system_slurm_stats

yyS = 2002; mmS = 09; ddS = 01;
yyS = 2002; mmS = 01; ddS = 01;

yyE = 2002; mmE = 12; ddE = 31;
yyE = 2018; mmE = 08; ddE = 31;
yyE = 2019; mmE = 08; ddE = 31;

days_since_2002_S = change2days(yyS,mmS,ddS,2002);
days_since_2002_E = change2days(yyE,mmE,ddE,2002);

doy0 = day_in_year(yyS,mmS,ddS);

sarta = '/home/sergio/SARTA_CLOUDY/BinV201/xsarta_apr08_m140_iceGHMbaum_waterdrop_desertdust_slabcloud_hg3';
sarta = '/home/chepplew/gitLib/sarta/bin/airs_l1c_2834_cloudy_may19_prod_v3';
ichan = load('sarta_chans_for_l1c.mat');
palts = load('/home/sergio/MATLABCODE/airsheights.dat');
palts = flipud(palts);

clear xdemall
xdemall.mmw     = [];
xdemall.stemp   = [];
xdemall.spres   = [];
xdemall.rclear  = [];
xdemall.rcloud  = [];
xdemall.iceOD   = [];
xdemall.icetop  = [];
xdemall.icefrac = [];
xdemall.waterOD   = [];
xdemall.watertop  = [];
xdemall.waterfrac = [];

iFoundFile = 0;
iCnt0 = 0;
iCnt0 = 252;  % so start at 253 = Jan 01, 2013
iCntF = 365;  % so end   at 365 = Dec 31, 2018
iCntF = 390;  % so end   at 388 = Dec 31, 2019

yy0 = yyS; mm0 = mmS; dd0 = ddS; N = 16;
daysX = change2days(yy0,mm0,dd0,2002);

iCnt = 0;
iFound = -1;

%% mat file with 7 chan calcs
clear thedir
fout = ['DATA_StartSept2002/pall_16daytimestep_' num2str(JOB,'%03i') '_*.mat'];
eex = exist(fout);
if eex > 0
  thedir = dir(fout);
else
  thedir.bytes = 0;
end

if thedir.bytes > 0
  iFound = +1;
  timestamp = thedir.name(20:end-4);
  timestampJUNK = timestamp(1:3);
  if ~strcmp(timestampJUNK,num2str(JOB,'%03i'))
    error('something wierd')
  end

  fout = ['DATA_StartSept2002/pall_16daytimestep_' timestamp '.mat'];

  %% make up the rtp file with 2645 clear,cloud calcs and obs
  favgOP  = ['DATA_StartSept2002/pall_16daytimestep_' timestamp '.op.rtp']
  favgRP  = ['DATA_StartSept2002/pall_16daytimestep_' timestamp '.rp.rtp']

  fStrow  = ['/asl/s1/strow/obs_stats/tile_means/airs_map_all_y' num2str(yy0,'%04i') 's' num2str(JOB,'%02i') '.mat'];
  fHoward = ['/home/motteler/shome/obs_stats/map_16day_airs_all/airs_map_all_y' num2str(yy0,'%04i') 's' num2str(JOB,'%02i') '.mat'];
  fHoward = ['/asl/stats/airs/global_by_time/airs_map_all_y' num2str(yy0,'%04i') 's' num2str(JOB,'%02i') '.mat'];

  iHorS = 0;  
  if exist(fHoward);
    iHorS = +1;
  elseif exist(fStrow);
    iHorS = -1;
  else
    iHorS = 0;  
  end

  %if exist(fout) & (exist(fHoward) | exist(fStrow)) & ~exist(favgRP) 
  if exist(fout) & ~exist(favgRP) 
    ee = 1;
    iFoundFile = iFoundFile + 1;
    fprintf(1,'%3i %s  +1 \n',iCnt,fout)

    clear x
    x = load(fout);
    px = gather_pall(x.h2x,x.pall);

    %% gather cloud stats
    xdemall.mmw   = [xdemall.mmw; px.mmw];
    xdemall.stemp = [xdemall.stemp; px.stemp];
    xdemall.spres = [xdemall.spres; px.spres];
    xdemall.rclear = [xdemall.rclear; px.sarta_rclearcalc(5,:)];
    xdemall.rcloud = [xdemall.rcloud; px.rcalc(5,:)];
    xdemall.iceOD = [xdemall.iceOD; px.iceOD];
    xdemall.icetop = [xdemall.icetop; px.icetop];
    xdemall.icefrac = [xdemall.icefrac; px.icefrac];
    xdemall.waterOD = [xdemall.waterOD; px.waterOD];
    xdemall.watertop = [xdemall.watertop; px.watertop];
    xdemall.waterfrac = [xdemall.waterfrac; px.waterfrac];
  
    yy0 = str2num(timestamp(05:08)); mm0 = str2num(timestamp(10:11)); dd0 = str2num(timestamp(13:14)); [yy0 mm0 dd0]
    yy1 = str2num(timestamp(19:22)); mm1 = str2num(timestamp(24:25)); dd1 = str2num(timestamp(27:28)); [yy1 mm1 dd1]

    xdemall.startdate(iFoundFile,:) = [yy0 mm0 dd0];
    xdemall.stopdate(iFoundFile,:)  = [yy1 mm1 dd1];

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

    px2 = fix_clouds_as_needed(px);

    hx.vchan = howard.wnum;
    hx.pfields = 5; %% obs + profile

%{
    clear howard
    if iHorS == +1
      howard = load(fHoward);
    elseif iHorS == -1
      howard = load(fStrow);
    end
    px2.robs1 = reshape(howard.gavg,2645,64*72);
%}

    tempx.sarta = sarta;
    tempx.tempfile2 = favgOP;
    tempx.tempfile3 = favgRP;
    tempx.tempfile4 = 'ugh';
    px2 = do_clearcalc(hx,px2,tempx,+1);
    hx.pfields = 7; %% obs + calc + profile
    hx.pfields = 3; %%       calc + profile
    rtpwrite(favgRP,hx,[],px2,[]);

lser = ['!ls -lt ' favgOP ' ' favgRP ' ugh'];
eval(lser)
%disp('ret to continue'); pause
pause(1)

    rmer = ['!/bin/rm ' favgOP]; eval(rmer);

    %{
    [hjunk,hajunk,pjunk,pajunk] = rtpread(favgRP);
    scatter_coast(pjunk.rlon,pjunk.rlat,50,rad2bt(1231,pjunk.rcalc(1520,:))); 
    pause(0.1)
    %}
  end
end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xdemall.rlat = px.rlat;
xdemall.rlon = px.rlon;
xdemall.salti = px.salti;
xdemall.landfrac = px.landfrac;
xdemall.comment = 'see loop_gather_pall_howard.m';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
save DATA_StartSept2002/xdemall_howard.mat xdemall
for iCnt = 1 : length(xdemall.startdate)
  simplemap(xdemall.rlat,xdemall.rlon,xdemall.mmw(iCnt,:),5); caxis([0 60]); title(num2str(iCnt)); pause(0.25);
end

do_the_trends
%}

