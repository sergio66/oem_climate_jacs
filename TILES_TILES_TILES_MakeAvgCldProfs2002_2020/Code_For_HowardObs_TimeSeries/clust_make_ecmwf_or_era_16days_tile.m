%% DATAObsStats_StartSept2002/LatBin32/LonBin36/stats_data_2009_s158.mat

%% see eg clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m
%% see eg cluster_loop_make_correct_timeseriesV2.m

addpath /asl/matlib/aslutil/
addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/RTPMAKE/CLUST_RTPMAKE/CLUSTMAKE_ERA

%%%%%%%%%%%%%%%%%%%%%%%%%

addpath /asl/matlab2012/airs/readers
addpath /asl/matlib/aslutil
addpath /asl/matlib/science
addpath /asl/matlib/rtptools
addpath /asl/matlib/h4tools/
addpath /asl/matlib/rtptools/
addpath /asl/matlib/gribtools/
addpath /home/sergio/MATLABCODE/matlib/clouds/sarta
addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/COLORMAP

%addpath /home/strow/cress/Work/Rtp
%addpath /home/strow/Matlab/Grib

%addpath /home/sergio/MATLABCODE/CRIS_HiRes             %% for sergio_fill_ecmwf
%addpath /home/strow/Git/rtp_prod2/grib                  %% for fill_ecm
%addpath /asl/rtp_prod2/grib/                           %% for fill_ecmwf

%addpath  /asl/packages/rtp_prod2/grib
%addpath  /home/sbuczko1/git/rtp_prod2/grib

%addpath /home/strow/git/rtp_prod2/grib
addpath /home/sergio/MATLABCODE/RTPMAKE/CLUST_RTPMAKE/GRIB
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS/Strow_humidity/convert_humidity/

%%%%%%%%%%%%%%%%%%%%%%%%%
iAllChan = +1;  %% 2645 chans
iAllChan = -1;  %% only one chan, 1231

iDorA = -1; %% asc
iDorA =  0; %% all
iDorA = +1; %% desc

%% JOB = 1 .. 64
JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));  %% this is the latbin, and inside here we loop over the 72 lonbins
if length(JOB) == 0
  JOB = 32;
  JOB = 28;
  JOB = 10;
end

%% indonesia = 0.78S, 113E   so latbin32,lonbin 113/180*36 + 36 = 59
jj = 32; ii = 59;  

%% greenland = 71 N, 42 W  so latbinB64 = 59, lonbin72 = (180-42)/5 = 27
jj = 59; ii = 27; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hugedir = dir('/asl/isilon/airs/tile_test7/');  %% 480 timesteps till Sep 2023

iaFound = zeros(1,600);
for ii = 3 : length(hugedir)
  junk = hugedir(ii).name;
  junk = str2num(junk(end-2:end));
  iaFound(junk) = 1;
end
junk = find(iaFound == 1); junk = max(junk); maxN = junk; 

disp('these timesteps are not found : '); junk = find(iaFound(1:junk) == 0)
  iTimeStepNotFound = 0;
  iTimeStepNotFound = length(junk);
fprintf(1,'so should only find %3i Sergio processed files \n',maxN - iTimeStepNotFound);
disp(' ' )

iTimeStep = 001;
iTimeStep = 460; %% 23 timesteps/year * 20 years
iTimeStep = 230; %% 10 years
if iTimeStep > maxN
  iTimeStep = maxN;
end

date_stamp = hugedir(iTimeStep).name;
fprintf(1,'iTimeStep = %4i date_stamp = %s \n',iTimeStep,date_stamp);

thedir0 = dir(['/asl/isilon/airs/tile_test7/' date_stamp '/']);
%%%%%%%%%%%%%%%%%%%%%%%%%

all_72lonbins = struct;
iiMin = 01; iiMax = 72;

% iiMin = 45; iiMax = 45; %% JOB = 28
% iiMin = 72; iiMax = 72; %% JOB = 29
% iiMin = 36; iiMax = 36;

for ii = iiMin : iiMax
  jj = JOB;   %% latbin
  JOBB = (JOB-1)*72 + ii;
  fdirsave = ['/asl/s1/sergio/JUNK2/16dayTimeStep/' num2str(iTimeStep,'%03d') '/'];
  if ~exist(fdirsave)
    fprintf(1,'making %s \n',fdirsave)
    mker = ['!/bin/mkdir -p ' fdirsave];
    eval(mker)
  end
  fsave = [fdirsave '/test_clust_make_ecmwf_or_era_16days_tile_timestep_' num2str(iTimeStep,'%03d') '_latbin_' num2str(JOB,'%02d') '_lonbin_' num2str(ii,'%02d') '.mat'];

  if exist(fsave)
    fprintf(1,'JOB = latbin = %2i ii = lonbin = %2i fsave = %s already exists SKIPPING \n',JOB,ii,fsave)
  else
    %% remember fnameoutIIJJ is just for your timesteps       eg 2004/09 to 2012/08
    %% remember fnameoutII   is all           timesteps found eg 2002/09 to 2022/08
  
    x = translator_wrong2correct(JOBB);
    %% fdirIN  = ['../DATAObsStats_StartSept2002/LatBin' num2str(x.wrong2correct_I_J_lon_lat(2),'%02i') '/LonBin' num2str(x.wrong2correct_I_J_lon_lat(1),'%02i') '/'];
    fprintf(1,'JOB (what we want correct latbin) = %2i    ii (what we want correct lonbin) = %2i  \n',JOB,ii);
  
    daname = replace(x.correctname,'2002_s001',date_stamp);
    fprintf(1,'  reading in %s \n',daname);
    a = read_netcdf_lls(daname);
    figure(1); clf; plot(a.lon,a.lat,'b.'); hold on; plot(x.correct_I_J_lon_lat(3),x.correct_I_J_lon_lat(4),'ro','linewidth',4,'markersize',10); hold off; pause(1);
  
    if iDorA == 0
      iaUse = 1:a.total_obs;
    elseif iDorA == -1
      iaUse = find(a.asc_flag(1:a.total_obs) == 65);
    elseif iDorA == +1
      iaUse = find(a.asc_flag(1:a.total_obs) == 68);
    end

    pin.rtime    = a.tai93(iaUse)' + offset1958_to_1993;
    pin.rlon     = a.lon(iaUse)';
    pin.rlat     = a.lat(iaUse)';
    pin.landfrac = a.land_frac(iaUse)';
    pin.solzen   = a.sol_zen(iaUse)';
    pin.satzen   = a.sat_zen(iaUse)';
    pin.robs1    = a.rad(:,iaUse);
    
    [salti, landfrac] = usgs_deg10_dem(pin.rlat, pin.rlon);
    pin.landfrac = landfrac;
    pin.salti    = salti;
    
    pin.pobs = zeros(size(pin.solzen));
    pin.upwell = ones(size(pin.solzen));
    
    pain = {{'profiles','rtime','seconds since 1993'}};
    hain= {{'header','hdf file',x.correctname}};

    moo = load('/home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/h2645structure.mat');
    
    hin.pfields=5; % (1=prof + 4=IRobs);
    if iAllChan > 0
      hin.nchan = 2645;
      hin.ichan = moo.h.ichan;
      hin.vchan = moo.h.vchan;
    else
      hin.nchan = 1;
      hin.ichan = moo.h.ichan(1520);
      hin.vchan = moo.h.vchan(1520);
    end

    [yy,mm,dd,hh] = tai2utcSergio(pin.rtime);
    daysSince2002 = change2days(yy,mm,dd,2002);
    uniquedaysSince2002 = unique(daysSince2002);
    for ddloop = 1 : length(uniquedaysSince2002)
      junk = find(daysSince2002 == uniquedaysSince2002(ddloop));
      fprintf(1,'ddloop = %3i of %3i   numfound = %5i of %5i \n',ddloop,length(uniquedaysSince2002),length(junk),length(pin.rtime));
      pinjunk = struct;
      pinjunk.rtime = pin.rtime(junk);
      pinjunk.rlon = pin.rlon(junk);
      pinjunk.rlat = pin.rlat(junk);
      pinjunk.landfrac = pin.landfrac(junk);
      pinjunk.solzen = pin.solzen(junk);
      pinjunk.satzen = pin.satzen(junk);
      pinjunk.pobs = pin.pobs(junk);
      pinjunk.upwell = pin.upwell(junk);
      pinjunk.salti = pin.salti(junk);
      pinjunk.robs1 = pin.robs1(:,junk);
      [h,ha,p,pa] = make_generic_interp_ERA_rtp(hin,hain,pinjunk,pain);
      if ddloop == 1
        hout = h;
        pout = p;
      else
        [hout,pout] = cat_rtp(hout,pout,h,p);
      end
    end
    
    figure(1); scatter_coast(pout.rlon,pout.rlat,10,pout.stemp); colormap jet; title('ERA stemp')
    if iAllChan > 0
      figure(2); scatter_coast(pout.rlon,pout.rlat,10,rad2bt(1231,pout.robs1(1520,:))); colormap jet; title('BT1231 obs')
      figure(3); plot(pout.stemp,pout.stemp,pout.stemp,rad2bt(1231,pout.robs1(1520,:)),'.'); hl = legend('stemp','BT1231 obs','location','best'); xlabel('stemp')
    else
      pout.robs1 = pout.robs1(1520,:);
      figure(2); scatter_coast(pout.rlon,pout.rlat,10,rad2bt(1231,pout.robs1)); colormap jet; title('BT1231 obs')
      figure(3); plot(pout.stemp,pout.stemp,pout.stemp,rad2bt(1231,pout.robs1),'.'); hl = legend('stemp','BT1231 obs','location','best'); xlabel('stemp')
    end

    klayers  = '/asl/packages/klayersV205/BinV201/klayers_airs';
    sartaClr = '/asl/packages/sartaV108_PGEv6/Bin/sarta_airs_PGEv6_postNov2003';
    sartaCld = '/home/sergio/SARTA_CLOUDY_RTP_KLAYERS_NLEVELS/JACvers/bin/jac_airs_l1c_2834_cloudy_may19_prod';
    
    run_sarta.clear = +1;
    run_sarta.cloud = +1;
    run_sarta.cumsum = 9999;
    
    codeX = 0; %% use default with A. Baran params
    codeX = 1; %% use new     with B. Baum, P. Yang params
    
    code0 = '/asl/packages/sartaV108/BinV201/sarta_apr08_m140_iceaggr_waterdrop_desertdust_slabcloud_hg3_wcon_nte';
    code1 = '/home/sergio/SARTA_CLOUDY/BinV201/sarta_apr08_m140x_iceGHMbaum_waterdrop_desertdust_slabcloud_hg3';
    code1 = sartaCld;
    
    [p2] = driver_sarta_cloud_rtp(hout,ha,pout,pa);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    comment = 'see /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries/clust_make_ecmwf_or_era_16days_tile.m';
    saver = ['save ' fsave ' hout p2 comment']
    eval(saver)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    if iAllChan > 0
      figure(3); plot(pout.stemp,pout.stemp,pout.stemp,rad2bt(1231,pout.robs1(1520,:)),'.',pout.stemp,rad2bt(1231,p2.rcalc(1520,:)),'.')
      hl = legend('stemp','BT1231 obs','BT1231 calc','location','best'); xlabel('stemp')
    
      figure(4); dbt = 200 : 1 : 320;
      semilogy(dbt,histc(rad2bt(1231,pout.robs1(1520,:)),dbt),'b',dbt,histc(rad2bt(1231,p2.rcalc(1520,:)),dbt),'r')
      hl = legend('BT1231 obs','BT1231 calc','location','best'); ylabel('histogram')
    else
      figure(3); plot(pout.stemp,pout.stemp,pout.stemp,rad2bt(1231,pout.robs1),'.',pout.stemp,rad2bt(1231,p2.rcalc),'.')
      hl = legend('stemp','BT1231 obs','BT1231 calc','location','best'); xlabel('stemp')
    
      figure(4); dbt = 200 : 1 : 320;
      semilogy(dbt,histc(rad2bt(1231,pout.robs1),dbt),'b',dbt,histc(rad2bt(1231,p2.rcalc),dbt),'r')
      hl = legend('BT1231 obs','BT1231 calc','location','best'); ylabel('histogram')
    end

  end  %% ~exist(fsave)
end

disp('now look at plot_ecmwf_or_era_16days_tile')
