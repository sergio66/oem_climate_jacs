figure(1); clf
figure(2); clf

clear all

nyears = 20;
nyears = 40;
t0 = 1:23*nyears; t0 = t0-1; t0 = t0/23;

%% five simulated distributions of maxima in time
dist0 = ones(1,23*nyears) * 300;   %% const in time
dist1 = dist0 + 0.05*t0;       %% increase in time
dist2 = dist1 + 0.005*t0.*t0;  %% increase in time and speedup
dist3 = dist0 - 0.05*t0;       %% decrease in time
dist4 = dist3 - 0.005*t0.*t0;  %% decrease in time and slowdown
figure(1); plot(t0,[dist0; dist1; dist2; dist3; dist4]);

dn = 299:0.001:301; 
dn = 290 : 0.5 : 310; 
figure(2); plot(dn,histc(dist0,dn),'k',dn,histc(dist1,dn),'r',dn,histc(dist2,dn),'m',dn,histc(dist3,dn),'b',dn,histc(dist4,dn),'c')
  set(gca,'yscale','log'); hl = legend('const','hot linear','hot quad','cold linear','cold quad','location','best');

disp('ret to continue'); pause

%%%%%%%%%%%%%%%%%%%%%%%%%

%% five simulated distributions of maxima in time
dist0 = 300 + 5 * sin(t0*2*pi);  %% sin in time
dist1 = dist0 + 0.05*t0;         %% increase in time
dist2 = dist1 + 0.005*t0.*t0;    %% increase in time and speedup
dist3 = dist0 - 0.05*t0;         %% decrease in time
dist4 = dist3 - 0.005*t0.*t0;    %% decrease in time and slowdown
figure(1); plot(t0,[dist0; dist1; dist2; dist3; dist4]);

dn = 294:1:306; 
dn = 290 : 0.5 : 310; 
figure(2); plot(dn,histc(dist0,dn),'k',dn,histc(dist1,dn),'r',dn,histc(dist2,dn),'m',dn,histc(dist3,dn),'b',dn,histc(dist4,dn),'c','linewidth',2)
  set(gca,'yscale','log'); hl = legend('const','hot linear','hot quad','cold linear','cold quad','location','best');

disp('ret to continue'); pause
%%%%%%%%%%%%%%%%%%%%%%%%%

%% five simulated distributions of maxima in time
dist0 = 300 + 5 * sin(t0*2*pi);  %% sin in time
dist1 = dist0 + 0.05*t0 + randn(size(t0))*0.2;         %% increase in time
dist2 = dist1 + 0.005*t0.*t0 + randn(size(t0))*0.2;    %% increase in time and speedup
dist3 = dist0 - 0.05*t0 + randn(size(t0))*0.2;         %% decrease in time
dist4 = dist3 - 0.005*t0.*t0 + randn(size(t0))*0.2;    %% decrease in time and slowdown
figure(1); plot(t0,[dist0; dist1; dist2; dist3; dist4]);

dn = 294:1:306; 
dn = 290 : 0.5 : 310; 
figure(2); plot(dn,histc(dist0,dn),'k',dn,histc(dist1,dn),'r',dn,histc(dist2,dn),'m',dn,histc(dist3,dn),'b',dn,histc(dist4,dn),'c','linewidth',2)
  set(gca,'yscale','log'); hl = legend('const','hot linear','hot quad','cold linear','cold quad','location','best');

disp('ret to continue'); pause

%%%%%%%%%%%%%%%%%%%%%%%%%

%% five simulated distributions of maxima in time
dist0 = 300 + 5 * sin(t0*2*pi);  %% sin in time
boo = find(dist0 > 304.5);  plot(t0,dist0,t0(boo),dist0(boo),'r.')
fcn = ones(size(dist0)); fcn(boo) = fcn(boo) + sin(t0(boo)*2*pi).*t0(boo)/5000; plot(t0,fcn,t0(boo),fcn(boo),'r.')

dist1 = dist0.*fcn + 0.05*t0 + randn(size(t0))*0.2;         %% increase in time
dist2 = dist1      + 0.005*t0.*t0 + randn(size(t0))*0.2;    %% increase in time and speedup
dist3 = dist0.*fcn - 0.05*t0 + randn(size(t0))*0.2;         %% decrease in time
dist4 = dist3 - 0.005*t0.*t0 + randn(size(t0))*0.2;    %% decrease in time and slowdown

dist1 = dist0.*fcn;
dist2 = dist0.*fcn.*fcn;
figure(1); plot(t0,[dist0; dist1; dist2; dist3; dist4]);

dn = 294:1:306; 
dn = 290 : 0.5 : 310; 
figure(2); plot(dn,histc(dist0,dn),'k',dn,histc(dist1,dn),'r',dn,histc(dist2,dn),'m',dn,histc(dist3,dn),'b',dn,histc(dist4,dn),'c','linewidth',2)
  set(gca,'yscale','log'); hl = legend('const','hot linear','hot quad','cold linear','cold quad','location','best');

figure(1); plot(t0,[dist0; dist1; dist2]);

dn = 294:1:306; 
dn = 290 : 1 : 310; 
figure(2); plot(dn,histc(dist0,dn),'k',dn,histc(dist1,dn),'r',dn,histc(dist2,dn),'m','linewidth',2)
  set(gca,'yscale','log'); hl = legend('const','hot linear','hot quad','location','best');

disp('ret to continue'); pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ixy = input('Enter [latbin lonbin] : ');

indY = 8 + (0:20)*23;  %% first year 2002/09 to 2002/12 takes 9 timesteps
                       %% each additional year takes 23 more timesteps
YY = (0:20)+ 2002;     %% the years
%[indY YY]

accum = [];
ii = 0;
thetime = [];
thetimecenter = [];
thestatcenter = [];

ttmax = 420;
iaFound = zeros(1,ttmax);

for tt = 1 : ttmax
  ii = ii + 1;
  too = find(tt <= indY,1);
  yoo = YY(too);
%  [tt too yoo]
%{
  if tt <= 8+23*0
    fname = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(ixy(1),'%02d') '/LonBin' num2str(ixy(1),'%02d') '/stats_data_v3_extreme_2002_s' num2str(tt,'%03d') '.mat'];
  elseif tt <= 8+23*1
    fname = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(ixy(1),'%02d') '/LonBin' num2str(ixy(1),'%02d') '/stats_data_v3_extreme_2003_s' num2str(tt,'%03d') '.mat'];
  elseif tt <= 8+23*2
    fname = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(ixy(1),'%02d') '/LonBin' num2str(ixy(1),'%02d') '/stats_data_v3_extreme_2004_s' num2str(tt,'%03d') '.mat'];
  etc etc
  end
%}
  fname  = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(ixy(1),'%02d') '/LonBin' num2str(ixy(1),'%02d') '/stats_data_v3_extreme_' num2str(yoo,'%04d') '_s' num2str(tt,'%03d') '.mat'];
  fnameM = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(ixy(1),'%02d') '/LonBin' num2str(ixy(1),'%02d') '/stats_data_v3_extreme_' num2str(yoo-1,'%04d') '_s' num2str(tt,'%03d') '.mat'];
  fnameP = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(ixy(1),'%02d') '/LonBin' num2str(ixy(1),'%02d') '/stats_data_v3_extreme_' num2str(yoo+1,'%04d') '_s' num2str(tt,'%03d') '.mat'];

  if ~exist(fname) & exist(fnameM)
    fprintf(1,'oh swapped years for timestep %3i yy0 = %4i --> yy0-1\n',tt,yoo)
    fname = fnameM;
  elseif ~exist(fname) & exist(fnameP)
    fprintf(1,'oh swapped years for timestep %3i yy0 = %4i --> yy0+1\n',tt,yoo)
    fname = fnameP;
  end

  if exist(fname)
    iaFound(tt) = +1;
    loader = ['a = load(''' fname ''');'];
    eval(loader)
    [mmm,nnn] = size(a.rad_max_asc);
    if mmm > 16
      fprintf(1,'WARNING timestep %3i size(rad_max_asc) = %4i %4i for %s \n',tt,mmm,nnn,fname);
    end
    blah = [a.min1231_asc rad2bt(1231,a.mean_rad_asc(1520)) a.max1231_asc];
    theday = (1:16)+ii*16;
    theyy = 2002.75 + theday/365.25;
    thetime = [thetime theyy];
    thetimecenter = [thetimecenter mean(theyy)];
    thestatcenter = [thestatcenter; blah];
    figure(1); plot(theyy,rad2bt(1231,a.rad_max_asc(1:16,1520)))
    accum = [accum (rad2bt(1231,a.rad_max_asc(1:16,1520)))'];
  else
    fprintf(1,'%3i %s DNE \n',tt,fname);
  end

  if tt == 1
    hold on
  end
end

fprintf(1,'found %3i out of %3i files \n',sum(iaFound),ttmax);

%% throw away things that are obviously too cold (clouds!!!!!)
figure(3);  plot(thetimecenter,thestatcenter);

finiteobs = accum(isfinite(accum));
damean    = mean(finiteobs);
dastd     = std(finiteobs);
hot       = find(finiteobs >= damean-dastd);
  fprintf(1,'lat/lon = %8.5f %8.5f has 85pc raw/cold filtered quantile as %8.5f, %8.5f K\n',a.lat_asc,a.lon_asc,quantile(finiteobs,0.85),quantile(finiteobs(hot),0.85))

figure(1); 
  hold on; plot(thetimecenter,thestatcenter,'linewidth',2); hold off;  %% times are gonna be slight;y off since I cheated and use center time, rather than looking for actual day max happened
  xlim([min(thetime) max(thetime)])
  xlabel('Time'); ylabel('BT1231'); title(['lat/lon = ' num2str(a.lat_asc) ' ' num2str(a.lon_asc)])

if ttmax < 150
  emax = 25;
else
  emax = 50;
end
figure(2); [N,edges] = histcounts(finiteobs,emax); semilogy(0.5*(edges(1:end-1)+edges(2:end)),N,'.-')
  ylabel('hist'); xlabel('BT1231'); title(['lat/lon = ' num2str(a.lat_asc) ' ' num2str(a.lon_asc)])

notdone = find(iaFound == 0);
if length(notdone) > 0
  slurmer = ['kleenslurm; sbatch -p high_mem --array=283-307%16 sergio_matlab_jobB.sbatch 12'];
  slurmer = ['kleenslurm; sbatch -p high_mem --array='];
  for ii = 1 : length(notdone)
    slurmer = [slurmer num2str(notdone(ii)) ','];
  end
  slurmer = slurmer(1:end-1);
  slurmer = [slurmer '%16 sergio_matlab_jobB.sbatch 12'];
  disp('you may want to check eg ../DATAObsStats_StartSept2002_v3/LatBin11/LonBin11/stats_data_v3_extreme_2006_s100.mat -- > ../DATAObsStats_StartSept2002_v3/LatBin11/LonBin11/stats_data_v3_extreme_2007_s100.mat')
  fprintf(1,'slurmer = %s \n',slurmer);
end
