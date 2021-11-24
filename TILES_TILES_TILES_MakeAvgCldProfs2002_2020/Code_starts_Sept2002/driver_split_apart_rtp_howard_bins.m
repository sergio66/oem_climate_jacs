%{

strow 11:58 AM I’ve copied all the tile files to
/asl/stats/airs/gridded/gridded/global_by_time.  I pulled all the data
into one file (which I don’t plan to use) into map_all.mat.  Right now
I am writing out these data in ../grid_by_time/lat*/all lon files.  So
there will be 64 latitude directories, and inside each one there will
be 72 files for each longitude grid point, with the gavg, gvar, etc
variables now just for the grid cell but all times.  Renamed to r_avg,
r_var, etc.  mtime (datetime vector) for the times is saved in each
file along with the two lat and two lon grid boundaries (if I did it
right).  Should finish in ~1 hour, seems to be taking 1
minute/latitude to save.

%}

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

load latB64.mat
rlon = -180 : 5 : +180; rlat = latB2;
for ind = 1 : 64
  str = ['p' num2str(ind,'%02i') ' = struct;'];
  eval(str);
end

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

iFoundFile = 0;
iCnt0 = 0;
iCnt0 = 252;  % so start at 253 = Jan 01, 2013
iCntF = 365;  % so end   at 365 = Dec 31, 2018
iCntF = 390;  % so end   at 388 = Dec 31, 2019

yy0 = yyS; mm0 = mmS; dd0 = ddS; N = 16;
daysX = change2days(yy0,mm0,dd0,2002);

iCnt = 0;
while daysX < days_since_2002_E
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

  %% mat file with 7 chan calcs
  fout = ['DATA/pall_16daytimestep_' num2str(JOB,'%03i') '_' num2str(yy0,'%04i') '_' num2str(mm0,'%02i') '_' num2str(dd0,'%02i') '_to_' num2str(yy1,'%04i') '_' num2str(mm1,'%02i') '_' num2str(dd1,'%02i') '_' num2str(JOB,'%2i') '.mat'];

  %% make up the rtp file with 2645 clear,cloud calcs and obs
  favgOP  = ['DATA/pall_16daytimestep_' num2str(JOB,'%03i') '_' num2str(yy0,'%04i') '_' num2str(mm0,'%02i') '_' num2str(dd0,'%02i') '_to_' num2str(yy1,'%04i') '_' num2str(mm1,'%02i') '_' num2str(dd1,'%02i') '_' num2str(JOB,'%2i') '.op.rtp'];
  favgRP  = ['DATA/pall_16daytimestep_' num2str(JOB,'%03i') '_' num2str(yy0,'%04i') '_' num2str(mm0,'%02i') '_' num2str(dd0,'%02i') '_to_' num2str(yy1,'%04i') '_' num2str(mm1,'%02i') '_' num2str(dd1,'%02i') '_' num2str(JOB,'%2i') '.rp.rtp'];

  fStrow  = ['/asl/s1/strow/obs_stats/tile_means/airs_map_all_y' num2str(yy0,'%04i') 's' num2str(JOB,'%02i') '.mat'];
  fHoward = ['/home/motteler/shome/obs_stats/map_16day_airs_all/airs_map_all_y' num2str(yy0,'%04i') 's' num2str(JOB,'%02i') '.mat'];
  fHoward = ['/asl/stats/airs/global_by_time/airs_map_all_y' num2str(yy0,'%04i') 's' num2str(JOB,'%02i') '.mat'];

  if exist(favgRP) 
    ee = 1;
    iFoundFile = iFoundFile + 1;
    fprintf(1,'%3i %s  +1 \n',iCnt,fout)

    [h,ha,p,pa] = rtpread(favgRP);
    p.yy = yy0 * ones(size(p.stemp));
    p.mm = mm0 * ones(size(p.stemp));
    p.dd = dd0 * ones(size(p.stemp));
    for ind = 1 : 64
      daind = 1 : 64 : length(p.stemp);
      daind = daind + (ind-1);
      [hsubset,psubset] = subset_rtp_allcloudfields(h,p,[],[],daind);
      if iFoundFile == 1
        hsubset = h;
        str = ['p' num2str(ind,'%02i') ' = psubset;'];
      else
        str = ['[hsubset,p' num2str(ind,'%02i') '] = cat_rtp(hsubset,p' num2str(ind,'%02i'),',h,psubset);'];
      end
      fprintf(1,'%3i %3i %4i/%2i/%2i %s \n',iFoundFile,ind,yy0,mm0,dd0,str);
      eval(str);
    end
  else 
    ee = 0;
    fprintf(1,'iCnt %3i : exist(fout)=%s exist(fHoward)=%s .. exist(favgRP)=%s %3i %3i %3i \n',iCnt,fout,fHoward,favgRP,exist(fout),exist(fHoward),exist(favgRP))
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

call_save_split_apart_rtp_howard_bins
