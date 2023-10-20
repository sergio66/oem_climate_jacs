%% DATAObsStats_StartSept2002/LatBin32/LonBin36/stats_data_2009_s158.mat

addpath /asl/matlib/aslutil/
addpath /home/sergio/MATLABCODE/TIME

%% JOB = 1 .. 64
JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));  %% this is the latbin, and inside here we loop over the 72 lonbins
%JOB = 28
%JOB = 29

%% indonesia = 0.78S, 113E   so latbin32,lonbin 113/180*36 + 36 = 59
jj = 32; ii = 59;  

%% greenland = 71 N, 42 W  so latbinB64 = 59, lonbin72 = (180-42)/5 = 27
jj = 59; ii = 27; 

%{
%% run this by hand first, so as to make the DIRS to save things to
for jj = 1 : 64
  for ii = 1 : 72
    fdirOUT = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];
    if ~exist(fdirOUT)
      mker = ['!mkdir -p ' fdirOUT];
      eval(mker)
    end
  end
end
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set_iQAX              %%% <<<< CHECK THIS
set_start_stop_dates  %%% <<<< CHECK THIS

remove_timesteps_not_found_from_finalfilename

disp(' ' )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

all_72lonbins = struct;
iiMin = 01; iiMax = 72;

%  iiMin = 45; iiMax = 45; %% JOB = 28
%  iiMin = 72; iiMax = 72; %% JOB = 29
%  iiMin = 59; iiMax = 59;

all_72lonbins.rlon = nan(iiMax-iiMin+1,maxN);
all_72lonbins.rlat = nan(iiMax-iiMin+1,maxN);
all_72lonbins.yy = nan(iiMax-iiMin+1,maxN);
all_72lonbins.mm = nan(iiMax-iiMin+1,maxN);
all_72lonbins.dd = nan(iiMax-iiMin+1,maxN);
all_72lonbins.meanBT1231 = nan(iiMax-iiMin+1,maxN);
all_72lonbins.maxBT1231 = nan(iiMax-iiMin+1,maxN);
all_72lonbins.minBT1231 = nan(iiMax-iiMin+1,maxN);
all_72lonbins.dccBT1231 = nan(iiMax-iiMin+1,maxN);

for ii = iiMin : iiMax
  %if mod(ii,10) == 0
  %  fprintf(1,'+')
  %else
  %  fprintf(1,'.')
  %end
  %tile = [];
  jj = JOB;   %% latbin
  JOBB = (JOB-1)*72 + ii;

  x = translator_wrong2correct(JOBB);
  fdirIN  = ['../DATAObsStats_StartSept2002/LatBin' num2str(x.wrong2correct_I_J_lon_lat(2),'%02i') '/LonBin' num2str(x.wrong2correct_I_J_lon_lat(1),'%02i') '/'];

  %% remember fnameoutIIJJ is just for your timesteps       eg 2004/09 to 2012/08
  %% remember fnameoutII   is all           timesteps found eg 2002/09 to 2022/08

  if iQAX == 1
    thedir = dir([fdirIN '/*.mat']);
    fdirOUT = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];
    fnameoutIIJJ = [fdirOUT '/summarystats_LatBin' num2str(jj,'%02i') '_LonBin' num2str(ii,'%02i') '_timesetps_001_' num2str(length(thedir),'%03i') '_V1.mat'];
    fnameoutIIJJ = [fdirOUT '/summarystats_LatBin' num2str(jj,'%02i') '_LonBin' num2str(ii,'%02i') '_timesetps_001_' num2str(maxN,'%03i') '_V1.mat'];

    fdirOUTII = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02i') '/'];
    fnameoutII = [fdirOUTII '/summarystats_LatBin' num2str(jj,'%02i') '_LonBin_1_72_timesetps_001_' num2str(length(thedir),'%03i') '_V1.mat'];

  elseif iQAX == 3
    thedir = dir([fdirIN '/iQAX_3_*.mat']);
    fdirOUT = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];
    fnameoutIIJJ = [fdirOUT '/iQAX_3_summarystats_LatBin' num2str(jj,'%02i') '_LonBin' num2str(ii,'%02i') '_timesetps_001_' num2str(length(thedir),'%03i') '_V1.mat'];
    fnameoutIIJJ = [fdirOUT '/iQAX_3_summarystats_LatBin' num2str(jj,'%02i') '_LonBin' num2str(ii,'%02i') '_timesetps_001_' num2str(maxN,'%03i') '_V1.mat'];

    fdirOUTII = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02i') '/'];
    fnameoutII = [fdirOUTII '/iQAX_3_summarystats_LatBin' num2str(jj,'%02i') '_LonBin_1_72_timesetps_001_' num2str(length(thedir),'%03i') '_V1.mat'];

  elseif iQAX == 4
    thedir = dir([fdirIN '/iQAX_4_*.mat']);
    fdirOUT = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];
    fnameoutIIJJ = [fdirOUT '/iQAX_4_summarystats_LatBin' num2str(jj,'%02i') '_LonBin' num2str(ii,'%02i') '_timesetps_001_' num2str(length(thedir),'%03i') '_V1.mat'];
    fnameoutIIJJ = [fdirOUT '/iQAX_4_summarystats_LatBin' num2str(jj,'%02i') '_LonBin' num2str(ii,'%02i') '_timesetps_001_' num2str(maxN,'%03i') '_V1.mat'];

    fdirOUTII = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02i') '/'];
    fnameoutII = [fdirOUTII '/iQAX_4_summarystats_LatBin' num2str(jj,'%02i') '_LonBin_1_72_timesetps_001_' num2str(length(thedir),'%03i') '_V1.mat'];

  end

  lonbin_time = struct;  

  fprintf(1,'reading in %3i files for %s +=100, o=10, .=1 \n',length(thedir),fdirOUT)

  clear ttsave
  for ttt = 1 : length(thedir)
    if mod(ttt,100) == 0
      fprintf(1,'+\n');
    elseif mod(ttt,10) == 0
      fprintf(1,'o');
    else
      fprintf(1,'.');
    end

    fx = [fdirIN '/' thedir(ttt).name];
    a = load(fx);
    tt = thedir(ttt).name;
    tt = tt(1:end-4);
    tt = str2num(tt(end-2:end));
    %fprintf(1,'[ttt tt] = %3i %3i %3i \n',ttt,tt,ttt-tt)
    ttsave(tt) = tt;

    lonbin_time = cat_lonbin_time(lonbin_time,tt,a);
    all_72lonbins.rlon(ii,tt) = a.lon_asc;
    all_72lonbins.rlat(ii,tt) = a.lat_asc;
    all_72lonbins.yy(ii,tt) = a.meanyear_asc;
    all_72lonbins.mm(ii,tt) = a.meanmonth_asc;
    all_72lonbins.dd(ii,tt) = a.meanday_asc;
    all_72lonbins.meanBT1231(ii,tt) = rad2bt(1520,a.mean_rad_asc(1520));  %% ORIG WRONG CODE run on Dec 8, 2020
    all_72lonbins.meanBT1231(ii,tt) = rad2bt(1231,a.mean_rad_asc(1520));  %% THIS IS CORRECT corrected Dec 16, 2020
    all_72lonbins.maxBT1231(ii,tt) = a.max1231_asc;
    all_72lonbins.minBT1231(ii,tt) = a.min1231_asc;
    all_72lonbins.dccBT1231(ii,tt) = a.DCC1231_asc;
    %radquantile(tt,:,:) = a.rad_quantile_desc;
    %thetimestep(JOBB,tt) = str2num(thedir(tt).name(18:end-4));
  end
  fprintf(1,'\n');

  notfound = find(ttsave == 0);
  lonbin_time.timestep_notfound = notfound;
  lonbin_time = nan_lonbin_time_notfound(lonbin_time);

  plot(all_72lonbins.meanBT1231(ii,:)); pause(0.1);

  if ~exist(fnameoutIIJJ)
    save(fnameoutIIJJ,'-struct','lonbin_time');
    fprintf(1,'saved %s \n',fnameoutIIJJ);
  else
    fprintf(1,'%s already exists \n',fnameoutIIJJ);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%

if iiMin == 01 & iiMax == 72
  %all_72lonbins.meanBT1231 = rad2bt(1231,all_72lonbins.meanBT1231);
  if ~exist(fnameoutII)
    save(fnameoutII,'-struct','all_72lonbins');
    fprintf(1,'saved %s \n',fnameoutII);
  else
    fprintf(1,'%s already exists \n',fnameoutII);
  end
else
  fprintf(1,'iMin = %2i iMax = %2i and not 01/72 so cannot do this overall summary save \n',iiMin,iiMax)
end

fprintf(1,'\n');
fprintf(1,'DONE : finished all 72 lonbins for latbin %2i \n',JOB)
fprintf(1,'now do cd ../Code_for_TileTrends/ \n')
fprintf(1,'now do edit eg clust_tile_fits_quantiles.m so we are reading in the 433 timesteps \n')
fprintf(1,'now do   ensure start/stop are [2022 08 31],[2002 09 01] \n')
fprintf(1,'now do sbatch -p high_mem --array=1-4608 sergio_matlab_jobB.sbatch 1 \n')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
yymmdd = yy + (mm-1)/12 + (dd-1)/12/30;
plot(yymmdd(1:end-1),diff(yymmdd))

figure(1); plot(yymmdd,meanBT1231,'.-',yymmdd,minBT1231,'.-',yymmdd,maxBT1231,'.-','linewidth',2); hl = legend('mean','min','max','location','best','fontsize',8);
xlim([min(yymmdd) max(yymmdd)])

figure(2); plot(yymmdd,dccBT1231,'.-','linewidth',2); title('DCC count')
xlim([min(yymmdd) max(yymmdd)])

figure(3);
  moo = squeeze(radquantile(:,:,1));
  moo = rad2bt(a.wnum,moo');
  pcolor(a.wnum,yymmdd,real(moo')); shading flat; colorbar
  title('Coldest quantile');

figure(4);
  moo = squeeze(radquantile(:,:,16));
  moo = rad2bt(a.wnum,moo');
  pcolor(a.wnum,yymmdd,real(moo')); shading flat; colorbar
  title('Hottest quantile');
%}
