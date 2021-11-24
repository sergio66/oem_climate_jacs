%% same as clust_make_lats40_16dayavg_noseasonal.m except we dump out bdry info
%% same as clust_make_lats40_16dayavg_noseasonal.m except we dump out bdry info
%% same as clust_make_lats40_16dayavg_noseasonal.m except we dump out bdry info

addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS
addpath /home/sergio/MATLABCODE/
addpath /asl/matlib/rtptools
addpath /asl/matlib/h4tools
addpath /asl/matlib/aslutil

system_slurm_stats

for JOB = 31 : 40

  set_dirIN_dirOUT    %% set the input/output directory here
    dirOUT = [dirOUT '/16DayAvgNoS/Anomaly/'];
  
  [h80,ha80,p80,pa80] = rtpread('/asl/s1/sergio/RTP_pin_feb2002/pin_feb2002_sea_airsnadir_g80_op.so2.rtp');
  [ppmvLAY51,ppmvAVG51,ppmvMAX51,pavgLAY51,tavgLAY51] = layers2ppmv(h80,p80,1:length(p80.stemp),51);
  [ppmvLAY52,ppmvAVG52,ppmvMAX52,pavgLAY52,tavgLAY52] = layers2ppmv(h80,p80,1:length(p80.stemp),52);
  
  [h49,ha49,p49,pa49] = rtpread('/home/sergio/MATLABCODE/REGR_PROFILES_SARTA/RUN_KCARTA/REGR49_400ppm_H2016_Mar2018_NH3/stdNH3_1100mb_op_400ppm.rtp');
  [ppmvLAY2,ppmvAVG2,ppmvMAX2,pavgLAY,tavgLAY]    = layers2ppmv(h49,p49,1:length(p49.stemp),2);
  [ppmvLAY4,ppmvAVG4,ppmvMAX4,pavgLAY,tavgLAY]    = layers2ppmv(h49,p49,1:length(p49.stemp),4);
  [ppmvLAY5,ppmvAVG5,ppmvMAX5,pavgLAY,tavgLAY]    = layers2ppmv(h49,p49,1:length(p49.stemp),5);
  [ppmvLAY6,ppmvAVG6,ppmvMAX6,pavgLAY,tavgLAY]    = layers2ppmv(h49,p49,1:length(p49.stemp),6);
  [ppmvLAY9,ppmvAVG9,ppmvMAX9,pavgLAY,tavgLAY]    = layers2ppmv(h49,p49,1:length(p49.stemp),9);
  [ppmvLAY12,ppmvAVG12,ppmvMAX12,pavgLAY,tavgLAY] = layers2ppmv(h49,p49,1:length(p49.stemp),12);
  
  countmin = 200; %% land/ocean
  countmin = 30;  %% ocean
  
  mapper = load('/home/sergio/MATLABCODE/CRODGERS_FAST_CLOUD/map2645to2378.mat');
  i2378 = 1:2378;
  iDude = mapper.closest2645to2378_ind;
  
  startYY = 2002; startMM = 09;
  %stopYY  = 2015; stopMM  = 08;
  
  stopYY  = 2017; stopMM  = 08;
  stopYY  = 2018; stopMM  = 08;

  if strfind(dirIN,'Airs')
    startYY = 2002; startMM = 09;
    %stopYY  = 2015; stopMM  = 08;

    stopYY  = 2017; stopMM  = 08;
    stopYY  = 2018; stopMM  = 08;

    iStartYear = 2002;
  elseif strfind(dirIN,'Cris')
    error('this is for AIRS')
    startYY = 2012; startMM = 05;
    stopYY  = 2018; stopMM  = 04;
    stopYY  = 2019; stopMM  = 04;  %% did I mess up .. Larrabee says they really do go to 2019 ... oh well

    iStartYear = 2012;
  end  
  
  rtimeStart = utc2taiSergio(startYY,startMM,01,eps);
  rtimeStop  = utc2taiSergio(stopYY, stopMM, 30,24-eps);
  
  %xstartYY = 2010; xstartMM = 01;
  %xstopYY  = 2010; xstopMM  = 12;
  %xrtimeStart = utc2taiSergio(xstartYY,xstartMM,01,eps);
  %xrtimeStop  = utc2taiSergio(xstopYY, xstopMM, 30,24-eps);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  for ii = JOB
    %fname = ['/home/strow/Work/Airs/Random/Data/' statsType '/statlat' num2str(ii) '.mat'];   %% done in August 2018;  
    fname = [dirIN '/statlat' num2str(ii) '.mat'];                                            %% done in March 2019
  
    fprintf(1,'latbin %2i of 40  fname = %s \n',ii,fname)
  
    fTXT = fname;
    loader = ['a = load(''' fname ''');'];
    eval(loader);
  
    if isfield(a,'latbinedges');
      a = rmfield(a,'latbinedges');
    end    
    yes = find(a.rtime_mean >= rtimeStart & a.rtime_mean <= rtimeStop);
    fprintf(1,'  need a fraction of %9.6f of the data \n',length(yes)/length(a.rtime_mean)*100);
    
    xnames = fieldnames(a);
    for jj = 1 : length(xnames)
      str = ['junk = a.' xnames{jj} ';'];
      eval(str);
      [mmjunk,nnjunk] = size(junk);
      if nnjunk == 1
        junk = junk(yes);
      else
        junk = junk(yes,:);
      end
      str = ['a.' xnames{jj} ' = junk;'];
      eval(str);
    end
  
    if isfield(a,'rcldy')  
      a.rcldy = a.rcldy';
      a.rcldybias_std = a.rcldybias_std';  
    end
    a.rclr = a.rclr';
    a.robs = a.robs';
    a.rclrbias_std = a.rclrbias_std';  
    
%    px.robs1 = -9999*ones(2378,length(a.stemp_mean)); px.robs1(i2378,:) = a.robs(iDude,:);
%    px.rclr = -9999*ones(2378,length(a.stemp_mean));  px.rclr(i2378,:) = a.rclr(iDude,:);
%    if isfield(a,'rcldy')  
%      px.rcld = -9999*ones(2378,length(a.stemp_mean));  px.rcld(i2378,:) = a.rcldy(iDude,:);
%    end
    if strfind(dirIN,'Airs')
      px.robs1 = -9999*ones(length(iaChanList),length(a.stemp_mean)); px.robs1(iaChanList,:) = a.robs(iDude,:);
      px.rclr = -9999*ones(length(iaChanList),length(a.stemp_mean));  px.rclr(iaChanList,:) = a.rclr(iDude,:);
      if isfield(a,'rcldy')  
        px.rcld = -9999*ones(length(iaChanList),length(a.stemp_mean));  px.rcld(iaChanList,:) = a.rcldy(iDude,:);
      end
    elseif strfind(dirIN,'Cris')
      px.robs1 = a.robs;
      px.rclr  = a.rclr;
      if isfield(a,'rcldy')  
        px.rcld = a.rcldy;
      end
    end
  
    a.gas1_mean = a.gas1_mean';
    a.gas3_mean = a.gas3_mean';
    a.ptemp_mean = a.ptemp_mean';  
  
    a0 = a;
    %a = rmfield(a,'count');
    if isfield(a,'count')
      a.count_mean = floor(a.count);
    end
    if isfield(a,'iudef4_mean')
      a = rmfield(a,'iudef4_mean');
    end
    a = rmfield(a,'rclrbias_std');
    if isfield(a,'rcldybias_std')
      a = rmfield(a,'rcldybias_std');
    end
    [yy,mm,dd,hh] = tai2utcSergio(a.rtime_mean);
    rtime = a.rtime_mean;
  
    %% /home/sergio/MATLABCODE/oem_pkg_run/AIRS_new_clear_scan_April2019/clust_convert_strowrates2oemrates_anomaly.m
    [mmlen,nnlen] = size(a.rtime_mean);
    one2mmlen = 1:mmlen;
    [rowi,coli] = find(isinf(a.rtime_mean));
    [rown,coln] = find(isnan(a.rtime_mean));
    badrow = union(rowi,rown);
    goodtimes = setdiff(1:mmlen,badrow);
  
    %% figure out full time data
    days_since_2002 = change2days(yy,mm,dd,iStartYear);
    [C,IA,IC] = unique(days_since_2002);
    if length(C) < length(days_since_2002)
      disp('whoops : some days are not unique, fixing!')
      days_since_2002 = days_since_2002(IA);
      rtime     = rtime(IA);
      goodtimes = goodtimes(IA);
      yy = yy(IA);
      mm = mm(IA);
      dd = dd(IA);
      hh = hh(IA);
  
      disp('a before getting rid of repeat days'); a
      danames = fieldnames(a);
      for nn = 1 : length(danames)
        str = ['junk = a.' danames{nn} ';'];
        eval(str);
        [mmjunk,nnjunk] = size(junk);
        if mmjunk == 1 | nnjunk == 1
          junk = junk(IA);
          str = ['a.' danames{nn} ' = junk;'];
          eval(str);
        elseif mmjunk < nnjunk      
          junk = junk(:,IA);
          str = ['a.' danames{nn} ' = junk;'];
          eval(str);
        elseif mmjunk >= nnjunk      
          junk = junk(IA,:)';
          str = ['a.' danames{nn} ' = junk;'];
          eval(str);
        end
      end
      disp('a after getting rid of repeat days'); a
    end
  
    %%%%%%%%%%%%%%%%%%%%%%%%%
    %% check things are OK
    [yy,mm,dd,hh] = tai2utcSergio(a.rtime_mean);
    rtime = a.rtime_mean;
  
    %% /home/sergio/MATLABCODE/oem_pkg_run/AIRS_new_clear_scan_April2019/clust_convert_strowrates2oemrates_anomaly.m
    [mmlen,nnlen] = size(a.rtime_mean);
    one2mmlen = 1:mmlen;
    [rowi,coli] = find(isinf(a.rtime_mean));
    [rown,coln] = find(isnan(a.rtime_mean));
    badrow = union(rowi,rown);
    goodtimes = setdiff(1:mmlen,badrow);
  
    %% figure out full time data
    days_since_2002 = change2days(yy,mm,dd,iStartYear);
    [C,IA,IC] = unique(days_since_2002);
    if length(C) < length(days_since_2002)
      error('huh??? should have been fixed!!!')
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%
    iStart = find(yy == 2002 & mm == 9 & dd == 01);
    iEnd   = find(yy == 2018 & mm == 8 & dd == 30);

    iStart = find(yy == startYY & mm == startMM & dd == 01);
    iEnd   = find(yy == stopYY  & mm == stopMM  & dd == 30);

    %% this is for iLatbin 1,2
    if length(iStart) == 0
      iStart = 1;
    end
    if length(iEnd) == 0
      iEnd = length(yy);
    end
  
    dStart = days_since_2002(iStart);
    dEnd   = days_since_2002(iEnd);
  
    %% figure out "existing days" (iA) and "missing days" (iB)
    iaAllDays = dStart : dEnd;
    rtimeAllDays  = interp1(days_since_2002,rtime,iaAllDays);
    [Y,iA,founddays]   = intersect(iaAllDays,days_since_2002);
  
    missingdays = setdiff(iaAllDays,days_since_2002);
    [Y,iB,notfounddays]   = intersect(iaAllDays,missingdays);
  
    %%% now filll in missing days and smooth
    a1 = a;
  
    iRemoveSeasonal = +1;
    iAvgNumDays = 180; %% smooth over these days
    iAvgNumDays = 000; %% smooth over these days
  
    [p16.stemp,p16.rtime,p16.avg16_doy_since2002,bdry16,anomaly16] = do16dayavg(a.stemp_mean,...
                hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'stemp',iRemoveSeasonal);
    [p16.count,p16.rtime,p16.avg16_doy_since2002,bdry16,anomaly16] = do16dayavg(a.count_mean,...
                hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'stemp',iRemoveSeasonal);
    p16.count = p16.count*16; %% since this is mean over 16 days, and we want COUNT over 16 days

    %saver = ['save BDRY16INFO_CLR/bdry16info_' num2str(JOB) '.mat bdry16 anomaly16'];
    outfile = ['BDRY16INFO_CLR/bdry16info_' num2str(JOB) '.mat'];
    if exist(outfile)    
      fprintf(1,'%s already exists \n',outfile)
    else
      saver = ['save ' outfile ' bdry16 anomaly16'];
      eval(saver)
    end
  
    %saver = ['save BDRY16INFO_CLR/bdry16info_' num2str(JOB) '.mat bdry16 anomaly16'];
    saver = ['save BDRY16INFO_CLD/bdry16info_' num2str(JOB) '.mat bdry16 anomaly16'];
    eval(saver)

  end  %% for ii = JOB
end  
