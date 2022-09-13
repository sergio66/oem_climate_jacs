addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS
addpath /home/sergio/MATLABCODE/CRODGERS_FAST_CLOUD
addpath /home/sergio/MATLABCODE/
addpath /asl/matlib/rtptools
addpath /asl/matlib/h4tools
addpath /asl/matlib/aslutil

system_slurm_stats

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));  %% latbins 1-40
%JOB = 21
%JOB = 12
%JOB = 34
%JOB = 9
%JOB = 1
JOB = 40

set_dirIN_dirOUT    %% set the input/output directory here
  dirOUT = [dirOUT '/16DayAvgNoS/'];  %% this has seasonal anomaly REMOVED
  %dirOUT = [dirOUT '/16DayAvgNoS_withanom/']; %% ??? this still has seasonal anomaly???
if ~exist(dirOUT)
  mker = ['!/bin/mkdir -p ' dirOUT];
  fprintf(1,'%s does not exist, making it \n',dirOUT);
  eval(mker)
end

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

if strfind(dirIN,'Airs')
  mapper = load('/home/sergio/MATLABCODE/CRODGERS_FAST_CLOUD/map2645to2378.mat');
  iaChanList = 1:2378;
  iDude = mapper.closest2645to2378_ind;
  sarta = '/home/sergio/SARTA_CLOUDY/BinV201/sarta_apr08_m140x_iceGHMbaum_waterdrop_desertdust_slabcloud_hg3';
  i1231 = 1291;
  zobs = 705000;
elseif strfind(dirIN,'Cris')
  %iaChanList = 1:1317;
  load h1317.mat; 
  iaChanList = h1317ichan;
  sarta = '/asl/bin/sarta_crisg4_nov09_wcon_nte';
  i1231 = 731;
  zobs = 824000;
end

if strfind(dirIN,'Airs')
  startYY = 2002; startMM = 09;
  %stopYY  = 2015; stopMM  = 08;

  stopYY  = 2017; stopMM  = 08;
  stopYY  = 2018; stopMM  = 08;

elseif strfind(dirIN,'Cris')
  startYY = 2012; startMM = 05;
  stopYY  = 2018; stopMM  = 04;
  stopYY  = 2019; stopMM  = 04;  %% did I mess up .. Larrabee says they really do go to 2019 ... oh well
end

rtimeStart = utc2taiSergio(startYY,startMM,01,eps);
rtimeStop  = utc2taiSergio(stopYY, stopMM, 30,24-eps);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ii = JOB
  %fname = ['/home/strow/Work/Airs/Random/Data/' statsType '/statlat' num2str(ii) '.mat'];   %% done in August 2018;  
  fname = [dirIN '/statlat' num2str(ii) '.mat'];                                            %% done in March 2019

  fprintf(1,'latbin %2i of 40  fname = %s \n',ii,fname)

  fTXT = fname;
  loader = ['a = load(''' fname ''');'];
  eval(loader);

  if strfind(dirIN,'Airs')
    iAIRSorCRIS = 1;   %% AIRS data
    iStartYear = 2002;
  elseif strfind(fname,'Cris')
    iAIRSorCRIS = 2;   %% CRIS data
    iStartYear = 2012;
    disp('need to get the centerfovs');
    a00 = a;
    xnames = fieldnames(a);
    iVers = 1; %% working with 2d profile matrices eg a.ptemp_mean = 2573x909,   take centerfov
    iVers = 2; %% working with 3d profile matrices eg a.ptemp_mean = 2573x9x101, take centerfov
    iVers = 3; %% working with 2d profile matrices eg a.ptemp_mean = 2573x9x101, take average over all golfball fovs
    if iVers == 1
      for jj = 1 : length(xnames)
        str = ['junk = a.' xnames{jj} ';'];
        eval(str);
        [mmjunk,nnjunk,oojunk] = size(junk);
        if nnjunk == 9
          junk = junk(:,5);
        elseif nnjunk == 909
          wow = (1:101) + 4*101;
          junk = junk(:,wow);
        elseif nnjunk == 11853
          wow = (1:1317) + 4*1317;
          junk = junk(:,wow);
        end
        str = ['a.' xnames{jj} ' = junk;'];
        eval(str);
      end
    elseif iVers == 2
      for jj = 1 : length(xnames)
        str = ['junk = a.' xnames{jj} ';'];
        eval(str);
        [mmjunk,nnjunk,oojunk] = size(junk);
        if nnjunk == 9 & oojunk == 1
          junk = junk(:,5);
        elseif nnjunk == 9 & oojunk == 101
          junk = squeeze(junk(:,5,:));
        elseif nnjunk == 9 & oojunk == 1317
          junk = squeeze(junk(:,5,:));
        end
        str = ['a.' xnames{jj} ' = junk;'];
        eval(str);
      end
    elseif iVers == 3
      for jj = 1 : length(xnames)
        str = ['junk = a.' xnames{jj} ';'];
        eval(str);
        [mmjunk,nnjunk,oojunk] = size(junk);
        if nnjunk == 9 & oojunk == 1
          junk = nanmean(junk,2);
        elseif nnjunk == 9 & oojunk == 101
          junk = squeeze(nanmean(junk,2));
        elseif nnjunk == 9 & oojunk == 1317
          junk = squeeze(nanmean(junk,2));
        end
        str = ['a.' xnames{jj} ' = junk;'];
        eval(str);
      end
    end
    a00
    a
    plot(a.stemp_mean)
    plot(nanmean(a.ptemp_mean),1:101); set(gca,'ydir','reverse')
    semilogx(nanmean(a.gas1_mean),1:101); set(gca,'ydir','reverse')
    semilogx(nanmean(a.gas3_mean),1:101); set(gca,'ydir','reverse')
    fprintf(1,'CRIS data : point 0 : num of elements in a00 = %5i in a = %5i \n',length(a00.stemp_mean),length(a.stemp_mean))
  end
 
  if isfield(a,'latbinedges');
    a = rmfield(a,'latbinedges');
  end    
  if isfield(a,'latbin_edges');
    a = rmfield(a,'latbin_edges');
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
  fprintf(1,'point 1 : num of elements in a = %5i \n',length(a.stemp_mean))

  if isfield(a,'rcldy')  
    a.rcldy = a.rcldy';
    a.rcldybias_std = a.rcldybias_std';  
  end
  a.rclr = a.rclr';
  a.robs = a.robs';
  a.rclrbias_std = a.rclrbias_std';  

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
  a = rmfield(a,'count');
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

  fprintf(1,'point 2 : num of elements in a = %5i \n',length(a.stemp_mean))

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
    disp('a after getting rid of repeat days');  
    a
  end

  fprintf(1,'point 3 : num of elements in a = %5i \n',length(a.stemp_mean))

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
  iStart = find(yy == startYY & mm == startMM  & dd == 01);
  iEnd   = find(yy == stopYY  & mm == stopMM   & dd == 30);
  fprintf(1,'Looking for data between %4i/%2i to %4i/%2i \n',startYY,startMM,stopYY,stopMM)

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

  iRawOrFrac = +1;

  fprintf(1,'point 4 : num of elements in a = %5i \n',length(a.stemp_mean))

  a.zobs_mean = ones(size(a.stemp_mean)) * zobs;
  
  [p16.zobs,p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.zobsanomaly] = do16dayavg(a.zobs_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'zobs',iRemoveSeasonal,iRawOrFrac);
  [p16.stemp,p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.stempanomaly] = do16dayavg(a.stemp_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'stemp',iRemoveSeasonal,iRawOrFrac);
  [p16.rlat,p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.rlatanomaly] = do16dayavg(a.lat_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'rlat',iRemoveSeasonal,iRawOrFrac);
  [p16.rlon,p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.rlonanomaly] = do16dayavg(a.lon_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'rlon',iRemoveSeasonal,iRawOrFrac);
  [p16.nlevs,p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.rtimeanomaly] = do16dayavg(a.nlevs_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'nlevs',iRemoveSeasonal,iRawOrFrac);
    p16.nlevs = floor(p16.nlevs);
  [p16.solzen,p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.solzenanomaly] = do16dayavg(a.solzen_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'solzen',iRemoveSeasonal,iRawOrFrac);
  [p16.satzen,p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.satzenanomaly] = do16dayavg(a.satzen_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'satzen',iRemoveSeasonal,iRawOrFrac);
  [p16.spres,p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.spresanomaly] = do16dayavg(a.spres_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'spres',iRemoveSeasonal,iRawOrFrac);
  [yy16,mm16,dd16,hh16] = tai2utcSergio(p16.rtime);

  for iLay = 1 : 98
    fprintf(1,'layer %3i of 98 \n',iLay)
    [p16.ptemp(iLay,:),p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.ptempanomaly(iLay,:)] = do16dayavg(a.ptemp_mean(iLay,:),...
      hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,['ptemp ' num2str(iLay)],iRemoveSeasonal,iRawOrFrac);
    [p16.gas_1(iLay,:),p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.gas_1anomalyfrac(iLay,:)] = do16dayavg(a.gas1_mean(iLay,:),...
      hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,['WV ' num2str(iLay)],iRemoveSeasonal,-1);
    [p16.gas_3(iLay,:),p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.gas_3anomalyfrac(iLay,:)] = do16dayavg(a.gas3_mean(iLay,:),...
      hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,['O3 ' num2str(iLay)],iRemoveSeasonal,-1);
  end

%{
  for iChan = 1 : length(iaChanList)
    fprintf(1,'chan %4i of %4i \n',iChan,length(iaChanList))
    [p16.robs1(iChan,:),p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.robs1anomaly(iChan,:)] = do16dayavg(a.robs(iChan,:),...
      hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,['WV ' num2str(iLay)],iRemoveSeasonal,-1);
    [p16.rclr(iChan,:),p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.rclranomaly(iChan,:)] = do16dayavg(a.rclr(iChan,:),...
      hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,['O3 ' num2str(iLay)],iRemoveSeasonal,-1);
  end
%}

  p16.gas_1(99:101,:) = zeros(3,length(p16.stemp));
  p16.gas_3(99:101,:) = zeros(3,length(p16.stemp));
  p16.ptemp(99:101,:) = zeros(3,length(p16.stemp));

  p16 = check_98levs(p16);
  p16.nlevs = min(98,p16.nlevs);
  p16.nlevs = ones(size(p16.nlevs)) * 98;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  p16.satheight = 705000 * ones(size(p16.stemp));
  p16.upwell    = +1 * ones(size(p16.stemp));
  p16.zobs      = zobs * ones(size(p16.stemp));;
  p16.scanang   = saconv(p16.satzen,p16.zobs);

  p16.gas_2 = p49.gas_2(:,49) * ones(1,length(p16.stemp));
  p16.gas_4 = p49.gas_4(:,49) * ones(1,length(p16.stemp));
  p16.gas_5 = p49.gas_5(:,49) * ones(1,length(p16.stemp));
  p16.gas_6 = p49.gas_6(:,49) * ones(1,length(p16.stemp));
  p16.gas_9 = p49.gas_9(:,49) * ones(1,length(p16.stemp));
  p16.gas_12 = p49.gas_12(:,49) * ones(1,length(p16.stemp));

  p16.gas_51 = p80.gas_51(:,49) * ones(1,length(p16.stemp));
  disp('ratio of gas 51 layers N-1/N')
  p16.gas_51(90:100,[1 2 3 4 5 49])./p16.gas_51(89:99,[1 2 3 4 5 49])
  p16.gas_51(98,:) = p16.gas_51(97,:) * 1.0141;

  p16.gas_52 = p80.gas_52(:,49) * ones(1,length(p16.stemp));
  disp('ratio of gas 52 layers N-1/N')
  p16.gas_52(90:100,[1 2 3 4 5 49])./p16.gas_52(89:99,[1 2 3 4 5 49])
  p16.gas_52(98,:) = p16.gas_52(97,:) * 1.0141;

  airslevels = load('/home/sergio/MATLABCODE/airslevels.dat');
  airslevels = flipud(airslevels);
  p16.plevs = airslevels * ones(1,length(p16.stemp));

  %%%%%%%%%%%%%%%%%%%%%%%%%

  if isfield(a,'rcldy')  
    [p16.cfrac,p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.cfracanomaly] = do16dayavg(a.cfrac_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'cfrac',iRemoveSeasonal,iRawOrFrac);
    %[p16.ctype,p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.ctypeanomaly] = do16dayavg(a.ctype_mean,...
    %          hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'ctype',iRemoveSeasonal,iRawOrFrac);
    p16.ctype = ones(size(p16.cfrac)) * 201;
    p16anomaly.ctype = ones(size(p16.cfrac)) * 201;
    [p16.cprtop,p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.cprtopanomaly] = do16dayavg(a.cprtop_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'cprtop',iRemoveSeasonal,iRawOrFrac);
    [p16.cprbot,p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.cprbotanomaly] = do16dayavg(a.cprbot_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'cprbot',iRemoveSeasonal,iRawOrFrac);
    [p16.cpsize,p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.cpsizeanomaly] = do16dayavg(a.cpsize_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'cpsize',iRemoveSeasonal,iRawOrFrac);
    [p16.cngwat,p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.cngwatanomaly] = do16dayavg(a.cngwat_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'cngwat',iRemoveSeasonal,iRawOrFrac);

    [p16.cfrac2,p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.cfrac2anomaly] = do16dayavg(a.cfrac2_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'cfrac2',iRemoveSeasonal,iRawOrFrac);
    %[p16.ctype2,p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.ctype2anomaly] = do16dayavg(a.ctype2_mean,...
    %          hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'ctype2',iRemoveSeasonal,iRawOrFrac);
    p16.ctype2 = ones(size(p16.cfrac)) * 101;
    p16anomaly.ctype2 = ones(size(p16.cfrac)) * 101;
    [p16.cprtop2,p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.cprtop2anomaly] = do16dayavg(a.cprtop2_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'cprtop2',iRemoveSeasonal,iRawOrFrac);
    [p16.cprbot2,p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.cprbot2anomaly] = do16dayavg(a.cprbot2_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'cprbot2',iRemoveSeasonal,iRawOrFrac);
    [p16.cpsize2,p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.cpsize2anomaly] = do16dayavg(a.cpsize2_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'cpsize2',iRemoveSeasonal,iRawOrFrac);
    [p16.cngwat2,p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.cngwat2anomaly] = do16dayavg(a.cngwat2_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'cngwat2',iRemoveSeasonal,iRawOrFrac);

    [p16.cfrac12,p16.rtime,p16.avg16_doy_since2002,bdry16,p16anomaly.cfrac12anomaly] = do16dayavg(a.cfrac12_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'cfrac12',iRemoveSeasonal,iRawOrFrac);

  %% 
    [junkk.cfrac,junkk.rtime,junkk.avg16_doy_since2002,bdry16,p16anomaly.cfracanomalyfrac] = do16dayavg(a.cfrac_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'cfrac',iRemoveSeasonal,-1);
    %[junkk.ctype,junkk.rtime,junkk.avg16_doy_since2002,bdry16,p16anomaly.ctypeanomalyfrac] = do16dayavg(a.ctype_mean,...
    %          hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'ctype',iRemoveSeasonal,-1);
    junkk.ctype = ones(size(junkk.cfrac)) * 201;
    junkk.ctype = ones(size(junkk.cfrac)) * 201;
    [junkk.cprtop,junkk.rtime,junkk.avg16_doy_since2002,bdry16,p16anomaly.cprtopanomalyfrac] = do16dayavg(a.cprtop_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'cprtop',iRemoveSeasonal,-1);
    [junkk.cprbot,junkk.rtime,junkk.avg16_doy_since2002,bdry16,p16anomaly.cprbotanomalyfrac] = do16dayavg(a.cprbot_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'cprbot',iRemoveSeasonal,-1);
    [junkk.cpsize,junkk.rtime,junkk.avg16_doy_since2002,bdry16,p16anomaly.cpsizeanomalyfrac] = do16dayavg(a.cpsize_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'cpsize',iRemoveSeasonal,-1);
    [junkk.cngwat,junkk.rtime,junkk.avg16_doy_since2002,bdry16,p16anomaly.cngwatanomalyfrac] = do16dayavg(a.cngwat_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'cngwat',iRemoveSeasonal,-1);

    [junkk.cfrac2,junkk.rtime,junkk.avg16_doy_since2002,bdry16,p16anomaly.cfrac2anomalyfrac] = do16dayavg(a.cfrac2_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'cfrac2',iRemoveSeasonal,-1);
    %[junkk.ctype2,junkk.rtime,junkk.avg16_doy_since2002,bdry16,p16anomaly.ctype2anomalyfrac] = do16dayavg(a.ctype2_mean,...
    %          hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'ctype2',iRemoveSeasonal,-1);
    junkk.ctype2 = ones(size(junkk.cfrac)) * 101;
    junkk.ctype2 = ones(size(junkk.cfrac)) * 101;
    [junkk.cprtop2,junkk.rtime,junkk.avg16_doy_since2002,bdry16,p16anomaly.cprtop2anomalyfrac] = do16dayavg(a.cprtop2_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'cprtop2',iRemoveSeasonal,-1);
    [junkk.cprbot2,junkk.rtime,junkk.avg16_doy_since2002,bdry16,p16anomaly.cprbot2anomalyfrac] = do16dayavg(a.cprbot2_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'cprbot2',iRemoveSeasonal,-1);
    [junkk.cpsize2,junkk.rtime,junkk.avg16_doy_since2002,bdry16,p16anomaly.cpsize2anomalyfrac] = do16dayavg(a.cpsize2_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'cpsize2',iRemoveSeasonal,-1);
    [junkk.cngwat2,junkk.rtime,junkk.avg16_doy_since2002,bdry16,p16anomaly.cngwat2anomalyfrac] = do16dayavg(a.cngwat2_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'cngwat2',iRemoveSeasonal,-1);

    [junkk.cfrac12,junkk.rtime,junkk.avg16_doy_since2002,bdry16,p16anomaly.cfrac12anomalyfrac] = do16dayavg(a.cfrac12_mean,...
              hostname,iA,iB,days_since_2002,iaAllDays,rtimeAllDays,goodtimes,missingdays,iAvgNumDays,'cfrac12',iRemoveSeasonal,-1);

  end

  h16.ngas = 10;
  h16.gunit = [1 1 1 1 1 1 1 1  1  1]';
  h16.glist = [1 2 3 4 5 6 9 12 51 52]';

      h16.vcmin = 605;
      h16.vcmax = 2830;
      h16.nchan = length(iaChanList);
      h16.nchan = 0;
      h16.ichan = (1:length(iaChanList))';
      h16.ptype = 1;    %% layers
      h16.pfields = 5;  %% profile + obs
      h16.pfields = 7;  %% profile + obs + cal	
      h16.pfields = 1;  %% profile only
      h16.pmin = min(min(p16.plevs));
      h16.pmax = max(max(p16.plevs));

  p16.nemis = 2;                    p16.nemis = p16.nemis * ones(1,length(p16.stemp));
  p16.efreq = [500  3000]';         p16.efreq = p16.efreq * ones(1,length(p16.stemp));
  p16.emis  = [0.98 0.98]';         p16.emis  = p16.emis * ones(1,length(p16.stemp));
  p16.rho   = (1-p16.emis)/pi;      

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% fix palts
  pa = {{'profiles','rtime','seconds since 1958'}};
  ha = {{'header','hdf file',fTXT}};

  p16.palts = zeros(101,length(p16.stemp));
  for ii370 = 1 : p16.nlevs+3
    p16.palts(ii370,:) = p2h(p16.plevs(ii370,1)) * ones(1,length(p16.stemp));
  end

  disp('before'); p16.palts(1:4,1)
  semilogx(p16.plevs(1:19,1),diff(p16.palts(1:20,1)),'o-'); hold on
  dp = p16.plevs(1:19,1);
  dh = abs(diff(p16.palts(1:20,1)));
  dh(1:3) = interp1(log(dp(4:19)),dh(4:19),log(dp(1:3)),[],'extrap');
  p16.palts(3,:) = p16.palts(4,:) + abs(dh(3));
  p16.palts(2,:) = p16.palts(3,:) + abs(dh(2));
  p16.palts(1,:) = p16.palts(2,:) + abs(dh(1));
  disp('after'); p16.palts(1:4,1)
  semilogx(p16.plevs(1:19,1),diff(p16.palts(1:20,1)),'o-'); hold off

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% fix time series of tracegases

  [ppmvLAY2,ppmvAVG2,ppmvMAX2,pavgLAY,tavgLAY] = layers2ppmv(h16,p16,1:length(p16.stemp),2);
  [ppmvLAY4,ppmvAVG4,ppmvMAX4,pavgLAY,tavgLAY] = layers2ppmv(h16,p16,1:length(p16.stemp),4);
  [ppmvLAY6,ppmvAVG6,ppmvMAX6,pavgLAY,tavgLAY] = layers2ppmv(h16,p16,1:length(p16.stemp),6);    
  [ppmvLAY51,ppmvAVG51,ppmvMAX51,pavgLAY,tavgLAY] = layers2ppmv(h16,p16,1:length(p16.stemp),51);    
  [ppmvLAY52,ppmvAVG52,ppmvMAX52,pavgLAY,tavgLAY] = layers2ppmv(h16,p16,1:length(p16.stemp),52);    

  if strfind(hostname,'taki')
    plot(ppmvLAY2,1:97); set(gca,'ydir','reverse')
    plot(ppmvLAY4,1:97); set(gca,'ydir','reverse')
    plot(ppmvLAY6,1:97); set(gca,'ydir','reverse')
    plot(ppmvLAY51,1:97); set(gca,'ydir','reverse')
    plot(ppmvLAY52,1:97); set(gca,'ydir','reverse')
  end

  p16_0 = p16;

  p16 = time_series_tracegas(2,p16,ppmvLAY2,pavgLAY);
  p16 = time_series_tracegas(4,p16,ppmvLAY4,pavgLAY);
  p16 = time_series_tracegas(6,p16,ppmvLAY6,pavgLAY);
  p16 = time_series_tracegas(51,p16,ppmvLAY51,pavgLAY);
  p16 = time_series_tracegas(52,p16,ppmvLAY52,pavgLAY);

  [timeppmvLAY2,timeppmvAVG2,timeppmvMAX2,pavgLAY,tavgLAY] = layers2ppmv(h16,p16,1:length(p16.stemp),2);
  [timeppmvLAY4,timeppmvAVG4,timeppmvMAX4,pavgLAY,tavgLAY] = layers2ppmv(h16,p16,1:length(p16.stemp),4);
  [timeppmvLAY6,timeppmvAVG6,timeppmvMAX6,pavgLAY,tavgLAY] = layers2ppmv(h16,p16,1:length(p16.stemp),6);    
  [timeppmvLAY51,timeppmvAVG51,timeppmvMAX51,pavgLAY,tavgLAY] = layers2ppmv(h16,p16,1:length(p16.stemp),51);    
  [timeppmvLAY52,timeppmvAVG52,timeppmvMAX52,pavgLAY,tavgLAY] = layers2ppmv(h16,p16,1:length(p16.stemp),52);    

  if strfind(hostname,'taki')
    num16steps = length(p16anomaly.stempanomaly);

    figure(1); plot(2002 + p16.avg16_doy_since2002/365,p16.stemp); 
    title(['16 day avg stemp latbin = ' num2str(ii)]); pause(0.1);

    figure(1);  
    subplot(121); plot(ppmvLAY2,1:97,'b',mean(ppmvLAY2'),1:97,'r'); 
      set(gca,'ydir','reverse'); title('CO2(time,z) profile')
      ax = axis; line([ax(1) ax(2)],[76 76],'color','k','linewidth',2);
      text(ax(1)*1.001,72,'500mb','fontsize',10)
    subplot(122); plot(timeppmvLAY2,1:97,'b',mean(timeppmvLAY2'),1:97,'r'); 
      set(gca,'ydir','reverse'); title('CO2(time,z) profile')
      ax = axis; line([ax(1) ax(2)],[76 76],'color','k','linewidth',2);
      text(ax(1)*1.001,72,'500mb','fontsize',10)
    figure(2);  plot(ppmvLAY2,1:97,'b',timeppmvLAY2,1:97,'r'); set(gca,'ydir','reverse'); title('CO2(time,z) profile')
      ax = axis; line([ax(1) ax(2)],[76 76],'color','k','linewidth',2);
      text(ax(1)*1.001,72,'500mb','fontsize',10)
    figure(3); plot(1:num16steps,ppmvLAY2(76,:),'b',1:num16steps,timeppmvLAY2(76,:),'r'); title('CO2 at 500 mb'); %% 500 mb

    figure(1);  
    subplot(121); plot(ppmvLAY4,1:97,'b',mean(ppmvLAY4'),1:97,'r'); 
      set(gca,'ydir','reverse'); title('N2O(time,z) profile')
      ax = axis; line([ax(1) ax(2)],[76 76],'color','k','linewidth',2);
      text(ax(1)*1.001,72,'500mb','fontsize',10)
    subplot(122); plot(timeppmvLAY4,1:97,'b',mean(timeppmvLAY4'),1:97,'r'); 
      set(gca,'ydir','reverse'); title('N2O(time,z) profile')
      ax = axis; line([ax(1) ax(2)],[76 76],'color','k','linewidth',2);
      text(ax(1)*1.001,72,'500mb','fontsize',10)
    figure(2);  plot(ppmvLAY4,1:97,'b',timeppmvLAY4,1:97,'r'); set(gca,'ydir','reverse'); title('N2O(time,z) profile')
      ax = axis; line([ax(1) ax(2)],[76 76],'color','k','linewidth',2);
      text(ax(1)*1.001,72,'500mb','fontsize',10)
    figure(3); plot(1:num16steps,ppmvLAY4(76,:),'b',1:num16steps,timeppmvLAY4(76,:),'r'); title('N2O at 500 mb'); %% 500 m

    figure(1);  
    subplot(121); plot(ppmvLAY6,1:97,'b',mean(ppmvLAY6'),1:97,'r'); 
      set(gca,'ydir','reverse'); title('CH4(time,z) profile')
      ax = axis; line([ax(1) ax(2)],[76 76],'color','k','linewidth',2);
      text(ax(1)*1.001,72,'500mb','fontsize',10)
    subplot(122); plot(timeppmvLAY6,1:97,'b',mean(timeppmvLAY6'),1:97,'r'); 
      set(gca,'ydir','reverse'); title('CH4(time,z) profile')
      ax = axis; line([ax(1) ax(2)],[76 76],'color','k','linewidth',2);
      text(ax(1)*1.001,72,'500mb','fontsize',10)
    figure(2);  plot(ppmvLAY6,1:97,'b',timeppmvLAY6,1:97,'r'); set(gca,'ydir','reverse'); title('CH4(time,z) profile')
      ax = axis; line([ax(1) ax(2)],[76 76],'color','k','linewidth',2);
      text(ax(1)*1.001,72,'500mb','fontsize',10)
    figure(3); plot(1:num16steps,ppmvLAY6(76,:),'b',1:num16steps,timeppmvLAY6(76,:),'r'); title('CH4 at 500 mb'); %% 500 mb

    figure(1);  
    subplot(121); plot(ppmvLAY51,1:97,'b',mean(ppmvLAY51'),1:97,'r'); 
      set(gca,'ydir','reverse'); title('CFC11(time,z) profile')
      ax = axis; line([ax(1) ax(2)],[76 76],'color','k','linewidth',2);
      text(ax(1)*1.001,72,'500mb','fontsize',10)
    subplot(122); plot(timeppmvLAY51,1:97,'b',mean(timeppmvLAY51'),1:97,'r'); 
      set(gca,'ydir','reverse'); title('CFC11(time,z) profile')
      ax = axis; line([ax(1) ax(2)],[76 76],'color','k','linewidth',2);
      text(ax(1)*1.001,72,'500mb','fontsize',10)
    figure(2);  plot(ppmvLAY51,1:97,'b',timeppmvLAY51,1:97,'r'); set(gca,'ydir','reverse'); title('CFC11(time,z) profile')
      ax = axis; line([ax(1) ax(2)],[76 76],'color','k','linewidth',2);
      text(ax(1)*1.001,72,'500mb','fontsize',10)
    figure(3); plot(1:num16steps,ppmvLAY51(76,:),'b',1:num16steps,timeppmvLAY51(76,:),'r'); title('CFC11 at 500 mb'); %% 500 mb

    figure(1);  
    subplot(121); plot(ppmvLAY52,1:97,'b',mean(ppmvLAY52'),1:97,'r'); 
      set(gca,'ydir','reverse'); title('CFC12(time,z) profile')
      ax = axis; line([ax(1) ax(2)],[76 76],'color','k','linewidth',2);
      text(ax(1)*1.001,72,'500mb','fontsize',10)
    subplot(122); plot(timeppmvLAY52,1:97,'b',mean(timeppmvLAY52'),1:97,'r'); 
      set(gca,'ydir','reverse'); title('CFC12(time,z) profile')
      ax = axis; line([ax(1) ax(2)],[76 76],'color','k','linewidth',2);
      text(ax(1)*1.001,72,'500mb','fontsize',10)
    figure(2);  plot(ppmvLAY52,1:97,'b',timeppmvLAY52,1:97,'r'); set(gca,'ydir','reverse'); title('CFC12(time,z) profile')
      ax = axis; line([ax(1) ax(2)],[76 76],'color','k','linewidth',2);
      text(ax(1)*1.001,72,'500mb','fontsize',10)
    figure(3); plot(1:num16steps,ppmvLAY52(76,:),'b',1:num16steps,timeppmvLAY52(76,:),'r'); title('CFC12 at 500 mb'); %% 500 mb
  end

  disp(' ')

  %klayers = '/asl/packages/klayersV205/BinV201/klayers_airs';
  %klayerser = ['!' klayers ' fin=LATS40_avg/Desc/latbin1_40.ip.rtp fout=LATS40_avg/Desc/latbin1_40.op.rtp'];
  %eval(klayerser)

  fopx  = [dirOUT '/latbin' num2str(ii) '_16day_avg.op.rtp'];
  frpx  = [dirOUT '/latbin' num2str(ii) '_16day_avg.rp.rtp'];
  fmatx = [dirOUT '/latbin' num2str(ii) '_16day_avg.rp.mat'];
  
  %% these two already set above
  %% h16.ngas = 10;
  h16.nchan = length(iaChanList);
  p16.plat = p16.rlat;
  p16.plon = p16.rlon;

  if isfield(a,'rcldy')  
    iFix = 0;
    iNotOK = 1;
    while iFix < 12 & iNotOK > 0
      iFix = iFix + 1;
      fprintf(1,' doing n = %2i try at checking clouds \n',iFix)
      [p16,iNotOK] = check_for_errors(p16,-1,iFix);  %% see possible pitfalls in clouds
    end
    if iFix >= 12 & iNotOK > 0
      %disp('oops, could not fix cprtop vs cprbot vs spres'); %keyboard
      error('oops, could not fix cprtop vs cprbot vs spres')
    end
  end
    
  rtpwrite(fopx,h16,ha,p16,pa);

  sartaer = ['!' sarta ' fin=' fopx ' fout=' frpx];
  eval(sartaer)

  if strfind(hostname,'taki')
    if isfield(h16,'vchan')
      plot(h16.vchan,mean(rad2bt(h16.vchan,p16.robs1)'))
      [h16x,~,p16x,~] = rtpread(frpx);
      plot(p16x.stemp,rad2bt(1231,p16x.rcalc(i1231,:)),'.',p16x.stemp,rad2bt(1231,p16.robs1(i1231,:)),'rx',p16x.stemp,p16x.stemp)
      plot(p16x.stemp,rad2bt(1231,p16x.rcalc(i1231,:)),'.',p16x.stemp,p16x.stemp)
    end
  end

  if exist('p16x')
    saver = ['save ' fmatx ' fopx frpx h16 ha p16 pa p16x p16anomaly'];
  else
    saver = ['save ' fmatx ' fopx frpx h16 ha p16 pa p16anomaly'];
  end
  if ~exist(fmatx)
    fprintf(1,'saving %s \n',fmatx)
    eval(saver)
  else
    fprintf(1,'whoa %s already exists, skip saving \n',fmatx)
  end

end  %% for ii = JOB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('now run  << completed_16day_avgprof_VS_lat.m >> to see which 16days/latbins were found')
disp(' edit as necessary to point to correct directory ...')

