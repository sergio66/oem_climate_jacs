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

disp('note : this is for 16 day averages so cannot make extremes')

load latB64.mat
rlon = -180 : 5 : +180; rlat = latB2;
for ind = 1 : 64
  str = ['p' num2str(ind,'%02i') ' = struct;'];
  eval(str);
end

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

iCnt = 0;
while iCnt <= iCntF
  iCnt = iCnt + 1;

  JOB = iCnt;

  %fout = ['DATA/pall_16daytimestep_' num2str(JOB,'%03i') '_' num2str(yy0,'%04i') '_' num2str(mm0,'%02i') '_' num2str(dd0,'%02i') '_to_' num2str(yy1,'%04i') '_' num2str(mm1,'%02i') '_' num2str(dd1,'%02i') '_' num2str(JOB,'%2i') '.mat'];
  %% make up the rtp file with 2645 clear,cloud calcs and obs
  %favgOP  = ['DATA/pall_16daytimestep_' num2str(JOB,'%03i') '_' num2str(yy0,'%04i') '_' num2str(mm0,'%02i') '_' num2str(dd0,'%02i') '_to_' num2str(yy1,'%04i') '_' num2str(mm1,'%02i') '_' num2str(dd1,'%02i') '_' num2str(JOB,'%2i') '.op.rtp'];
  %favgRP  = ['DATA/pall_16daytimestep_' num2str(JOB,'%03i') '_' num2str(yy0,'%04i') '_' num2str(mm0,'%02i') '_' num2str(dd0,'%02i') '_to_' num2str(yy1,'%04i') '_' num2str(mm1,'%02i') '_' num2str(dd1,'%02i') '_' num2str(JOB,'%2i') '.rp.rtp'];

  %% mat file with 7 chan calcs
  fout = ['DATA_StartSept2002/pall_16daytimestep_' num2str(JOB,'%03i') '_*.mat'];
  thedir = dir(fout);

  favgRP = 'DNE';

  if length(thedir) == 0
    thedir.bytes = 0;
  end

  if thedir.bytes > 0
    timestamp = thedir.name(20:end-4);
    timestampJUNK = timestamp(1:3);
    if ~strcmp(timestampJUNK,num2str(JOB,'%03i'))
      error('something wierd')
    end

    fout = ['DATA_StartSept2002/pall_16daytimestep_' timestamp '.mat'];

    %% make up the rtp file with 2645 clear,cloud calcs and obs
    favgOP  = ['DATA_StartSept2002/pall_16daytimestep_' timestamp '.op.rtp']
    favgRP  = ['DATA_StartSept2002/pall_16daytimestep_' timestamp '.rp.rtp']

    yy0 = str2num(timestamp(05:08)); mm0 = str2num(timestamp(10:11)); dd0 = str2num(timestamp(13:14)); [yy0 mm0 dd0]
    yy1 = str2num(timestamp(19:22)); mm1 = str2num(timestamp(24:25)); dd1 = str2num(timestamp(27:28)); [yy1 mm1 dd1]
  end


%  fStrow  = ['/asl/s1/strow/obs_stats/tile_means/airs_map_all_y' num2str(yy0,'%04i') 's' num2str(JOB,'%02i') '.mat'];
%  fHoward = ['/home/motteler/shome/obs_stats/map_16day_airs_all/airs_map_all_y' num2str(yy0,'%04i') 's' num2str(JOB,'%02i') '.mat'];
%  fHoward = ['/asl/stats/airs/global_by_time/airs_map_all_y' num2str(yy0,'%04i') 's' num2str(JOB,'%02i') '.mat'];

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
end

call_save_split_apart_rtp_howard_bins_startSept2002
