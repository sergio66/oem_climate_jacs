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
yyE = 2002; mmE = 12; ddE = 31;
yyE = 2018; mmE = 08; ddE = 31;

days_since_2002_S = change2days(yyS,mmS,ddS,2002);
days_since_2002_E = change2days(yyE,mmE,ddE,2002);

doy0 = day_in_year(yyS,mmS,ddS);

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

iCnt = 0;
yy0 = yyS; mm0 = mmS; dd0 = ddS; N = 16;
daysX = change2days(yy0,mm0,dd0,2002);

while daysX < days_since_2002_E & iCnt <= 364
  iCnt = iCnt + 1;
  if mod(iCnt,100) == 0
    fprintf(1,'+')
  elseif mod(iCnt,50)
    fprintf(1,'-')
  else
    fprintf(1,'.')
  end

  [yy1,mm1,dd1] = addNdays(yy0,mm0,dd0,N);

  u0 = utc2taiSergio(yy0,mm0,dd0,12.0);
  u1 = utc2taiSergio(yy1,mm1,dd1,12.0);
  deltadays = (u1-u0)/24/60/60; 
  daysX = change2days(yy1,mm1,dd1,2002);  

  JOB0 = iCnt;
  JOB = JOB0;
  fout = ['DATA/Try1/pall_16daytimestep_' num2str(JOB,'%03i') '_' num2str(yy0,'%04i') '_' num2str(mm0,'%02i') '_' num2str(dd0,'%02i') '_to_' num2str(yy1,'%04i') '_' num2str(mm1,'%02i') '_' num2str(dd1,'%02i') '.mat'];

  clear x
  x = load(fout);
  px = gather_pall(x.h2x,x.pall);
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
  demall.startdate(iCnt,:) = [yy0 mm0 dd0];
  demall.stopdate(iCnt,:)  = [yy1 mm1 dd1];

  yy0 = yy1; mm0 = mm1; dd0 = dd1;
end
fprintf(1,'\n');

demall.rlat = px.rlat;
demall.rlon = px.rlon;
demall.salti = px.salti;
demall.landfrac = px.landfrac;
demall.comment = 'see loop_gather_pall.m';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
save DATA/Try1/demall.mat demall
for iCnt = 1 : 365
  simplemap(demall.rlat,demall.rlon,demall.mmw(iCnt,:),5); caxis([0 60]); title(num2str(iCnt)); pause(0.25);
end

do_the_trends
%}

