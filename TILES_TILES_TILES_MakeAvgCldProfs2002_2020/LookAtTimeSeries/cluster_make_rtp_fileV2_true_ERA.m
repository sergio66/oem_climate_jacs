addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/COLORMAP
addpath /home/sergio/MATLABCODE/CRODGERS_FAST_CLOUD
addpath /asl/matlib/aslutil
addpath /asl/matlib/rtptools
addpath /asl/matlib/h4tools
addpath /home/sergio/MATLABCODE/TIME

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

tic

disp('running cluster_make_rtp_fileV2_true_ERA')

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));  %% JOB = 1 : 64 = latbin
% JOB = 32

JOB0 = JOB;

homedir = pwd; %% cd /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/MakeAvgCldProfs2002_2020/LookAtTimeSeries/

set(0,'DefaultLegendAutoUpdate','off')

%%% cd /umbc/xfs2/strow/asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_CORRECT_LatLon/

disp('from eg look_latbin32Lonbin54.m')
disp('  ClearBin    : indX lon = 54  87.5009     indY lat = 24 -23.3750')
disp('  CloudBin    : indX lon = 67 152.5007     indY lat = 35   6.8743')
disp('  SeasonalBin : indX lon = 27 -47.4736     indY lat = 47  39.8756')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% iChooseLatLonBin = input('Enter Lonbin/Latbin to look at (Lonbin 54 Latbin 32 -- is a good one, over Indonesia)  0 to stop: ');

JOB0

tempfile1 = mktempS('xxxjunk1');
tempfile2 = mktempS('xxxjunk2');
tempfile3 = mktempS('xxxjunk3');
tempfile4 = mktempS('xxxjunk4');
tempx.tempfile1 = tempfile1;
tempx.tempfile2 = tempfile2;

tempx.tempfile4 = tempfile4;
klayers = '/asl/packages/klayersV205/BinV201/klayers_airs';
sarta = '/home/chepplew/gitLib/sarta/bin/airs_l1c_2834_cloudy_may19_prod_v3';
tempx.klayers = klayers;
tempx.sarta   = sarta;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

run_sarta.clear = +1;
run_sarta.cloud = +1;
run_sarta.cumsum = -1;    %% this is "closer" to MRO but since cliuds are at centroid, does not do too well with DCC
run_sarta.cumsum = 9999;  %% larrabee likes this, puts clouds high so does well for DCC
run_sarta.sartacloud_code = '/home/chepplew/gitLib/sarta/bin/airs_l1c_2834_cloudy_may19_prod_v3';
run_sarta.sartaclear_code = '/home/chepplew/gitLib/sarta/bin/airs_l1c_2834_may19_prod_v2';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

tEnd = utc2taiSergio(2019,08,31,23);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%for iXX = 72 : -1 : 1
for iXX = 1 : 72
  %% iaChooseLatLonBin = input('Enter X/Y Lonbin/Latbin to look at (Lonbin 54 Latbin 32 -- is a good one, over Indonesia)  0 to stop: ');
  iChooseLatLonBin(1) = iXX;  %% scan lon
  iChooseLatLonBin(2) = JOB0; %% fixed lat

  indX = iChooseLatLonBin(1); indY = iChooseLatLonBin(2); 
  JOB = (indY-1)*72 + indX;
  %fnameclr = ['RTP_PROFSV2/Clr/timestep_lonbin_' num2str(indX,'%02d') '_latbin_' num2str(indY,'%02d') '_JOB_' num2str(JOB,'%04d') '_clr.rtp'];
  fnamecldIN = ['RTP_PROFSV2/Cld/timestep_lonbin_' num2str(indX,'%02d') '_latbin_' num2str(indY,'%02d') '_JOB_' num2str(JOB,'%04d') '_cld.rtp'];
  %fnameavg = ['RTP_PROFSV2/Avg/timestep_lonbin_' num2str(indX,'%02d') '_latbin_' num2str(indY,'%02d') '_JOB_' num2str(JOB,'%04d') '_avg.rtp'];
  %fnamecold = ['RTP_PROFSV2/Cold/timestep_lonbin_' num2str(indX,'%02d') '_latbin_' num2str(indY,'%02d') '_JOB_' num2str(JOB,'%04d') '_cold.rtp'];
  fnamecldOUT = ['RTP_PROFSV2/TrueERA/trueERA_timestep_lonbin_' num2str(indX,'%02d') '_latbin_' num2str(indY,'%02d') '_JOB_' num2str(JOB,'%04d') '_cld.rtp'];

  if ~exist(fnamecldIN)
    fprintf(1,'OOPS %s DNE \n',fnamecldIN)
  elseif exist(fnamecldIN) & exist(fnamecldOUT)
    fprintf(1,'OOPS %s and %s already exist \n',fnamecldIN,fnamecldOUT)
  elseif exist(fnamecldIN) & ~exist(fnamecldOUT)
    fprintf(1,'  .... doing lon/lat %2i %2i \n',iXX,JOB0)
    [hIN,ha,pIN,pa] = rtpread(fnamecldIN);

    boo = find(pIN.rtime <= tEnd);
    [hIN,pIN] = subset_rtp(hIN,pIN,[],[],boo);

pa = {{'profiles','rtime','seconds since 1958'}};
ha = {{'header','hdf file','sergio haha'}};

    p = struct;
    %h = hIN;
    p.rlon  = pIN.rlon;
    p.rlat  = pIN.rlat;
    p.rtime = pIN.rtime;
    p.satzen = pIN.satzen;
    p.scanang = pIN.scanang;
    p.solzen = pIN.solzen;
    p.landfrac = pIN.landfrac;
    p.salti = pIN.salti;
    p.zobs = pIN.zobs;
    p.wspeed = pIN.wspeed;
    p.upwell = pIN.upwell;

    rmpath /umbc/xfs2/strow/asl/matlib/science/
    %[salti, landfrac] = usgs_deg10_dem(p.rlat, p.rlon);
    %p.landfrac = landfrac;
    %p.salti    = salti;
    %p.zobs     = 705000 * ones(size(p.salti));
    %p.scanang  = rand(1,length(p.rtime))*48;  boo = rand(1,length(p.rtime)); p.scanang(boo < 0.5) = -p.scanang(boo < 0.5);
    %p.satzen   = vaconv(p.scanang, p.zobs, zeros(size(p.zobs)));
    %p.wspeed   = rand(size(p.salti)) * 10;
    %p.solzen   = ones(size(p.salti)) * 150;
    %p.upwell   = ones(size(p.salti));
  
    clrfields = {'SP','SKT','10U','10V','TCC','CI','T','Q','O3'};
    cldfields = {'SP','SKT','10U','10V','TCC','CI','T','Q','O3',...
                 'CC','CIWC','CLWC'};
  
    %[h,ha,p,pa] = rtpadd_era_data(h,ha,p,pa,cldfields); %%% add on era
    %[p2,h2] = fill_era_interp(p,h);
    [p2,h2,pa] = fill_era(p,h,pa);
  
    [xyy,xmm,xdd,xhh] = tai2utcSergio(p2.rtime);        %%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< for SdSM old time
    time_so_far = (xyy-2000) + ((xmm-1)+1)/12;
    co2ppm = 368 + 2.077*time_so_far;  %% 395.6933
    p2.co2ppm = co2ppm;
  
    [p2,pa] = rtp_add_emis(p2,pa);
  
    p2f = driver_sarta_cloud_rtp(h2,ha,p2,pa,run_sarta);
%    p2f = convert_rtp_to_cloudOD(h2,p2f);

    rtpwrite(fnamecldOUT,h2,ha,p2f,pa);   %% or do we want klayers output??????
toc

  end  
  %% iChooseLatLonBin = input('Enter Lonbin/Latbin to look at (Lonbin 54 Latbin 32 -- is a good one, over Indonesia)  0 to stop: ');
end

%rmer = ['!/bin/rm ' tempx.tempfile1 ' ' tempx.tempfile2 ' ' tempx.tempfile3 ' ' tempx.tempfile4];
%eval(rmer)
