addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS
addpath /home/sergio/MATLABCODE/
addpath /asl/matlib/rtptools
addpath /asl/matlib/h4tools
addpath /asl/matlib/aslutil

set_dirIN_dirOUT    %% set the input/output directory here

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
stopYY  = 2017; stopMM  = 08;
%stopYY  = 2015; stopMM  = 08;
rtimeStart = utc2taiSergio(startYY,startMM,01,eps);
rtimeStop  = utc2taiSergio(stopYY, stopMM, 30,24-eps);

xstartYY = 2010; xstartMM = 01;
xstopYY  = 2010; xstopMM  = 12;
xrtimeStart = utc2taiSergio(xstartYY,xstartMM,01,eps);
xrtimeStop  = utc2taiSergio(xstopYY, xstopMM, 30,24-eps);

%{
%% this is sanity test to make sure things work
for ii = 1 : 40
  fname = ['/home/strow/Data/Work/Airs/Random/Data/Desc/statlat' num2str(ii) '.mat'];      %% done in May  2018;
  fname = ['/home/strow/Work/Airs/Random/Data/' statsType '/statlat' num2str(ii) '.mat'];  %% done in July 2018;  

  load(fname)
  mean_spres(ii) = nanmean(spres_mean);
  mean_nlevs(ii) = nanmean(nlevs_mean);
  plot(spres_mean); num2str(ii); pause(1)
end
yyaxis left;  plot(1:40,mean_spres); xlabel('latitude index'); ylabel('spres mean');
yyaxis right; plot(1:40,mean_nlevs); xlabel('latitude index'); ylabel('nlevs mean'); 
%}

for ii = 1 : 40

  fprintf(1,'latbin %2i of 40 \n',ii)
  
  fname = ['/home/strow/Work/Airs/Stability/Data/Desc/statlat' num2str(ii) '.mat'];         %% done in 2017, does look like cloudss  
  fname = ['/home/strow/Data/Work/Airs/Random/Data/Desc_ocean/statlat' num2str(ii) '.mat']; %% done in May 2018
  fname = ['/home/strow/Data/Work/Airs/Random/Data/Desc//statlat' num2str(ii) '.mat'];      %% done in May 2018
  fname = ['/home/strow/Work/Airs/Random/Data/Desc//statlat' num2str(ii) '.mat'];           %% done in July 2018;
  
  fname = ['/home/strow/Work/Airs/Random/Data/' statsType '/statlat' num2str(ii) '.mat'];   %% done in August 2018;
  
  fname = [dirIN '/statlat' num2str(ii) '.mat'];   %% done in August 2018;    
  
  fprintf(1,'%s \n',fname)
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
  
  a.rcldy = a.rcldy';
  a.rclr = a.rclr';
  a.robs = a.robs';
  a.rcldybias_std = a.rcldybias_std';  
  a.rclrbias_std = a.rclrbias_std';  
  
  px.robs1 = -9999*ones(2378,length(a.stemp_mean)); px.robs1(i2378,:) = a.robs(iDude,:);
  px.rclr = -9999*ones(2378,length(a.stemp_mean));  px.rclr(i2378,:) = a.rclr(iDude,:);
  px.rcld = -9999*ones(2378,length(a.stemp_mean));  px.rcld(i2378,:) = a.rcldy(iDude,:);

  a.gas1_mean = a.gas1_mean';
  a.gas3_mean = a.gas3_mean';
  a.ptemp_mean = a.ptemp_mean';  
  [yy,mm,dd,hh] = tai2utcSergio(a.rtime_mean);

  %%%%%%%%%%%%%%%%%%%%%%%%%
  %% first do MEAN over one year

  clear xh xp
  count = nanmean(a.count')';  xgood = find(count >= countmin & a.rtime_mean >= xrtimeStart & a.rtime_mean <= xrtimeStop);
  fprintf(1,'  for ONE year need a fraction of %9.6f of the remaining data \n',length(xgood)/length(a.rtime_mean)*100);

  if ~isfield(a,'plevs_mean')
    junk = load('/home/sergio/MATLABCODE/airslevels.dat');
    junk = flipud(junk);
    a.plevs_mean = junk * ones(1,length(a.rtime_mean));
  end

  xp.rtime = nanmean(a.rtime_mean(xgood));
  xp.plevs = nanmean(a.plevs_mean(:,xgood),2);
  xp.gas_1 = nanmean(a.gas1_mean(:,xgood),2);
  xp.gas_3 = nanmean(a.gas3_mean(:,xgood),2);  
  xp.ptemp = nanmean(a.ptemp_mean(:,xgood),2);
  xp.stemp = nanmean(a.stemp_mean(xgood));
  xp.spres = nanmean(a.spres_mean(xgood));
  xp.rlat = nanmean(a.lat_mean(xgood));
  xp.rlon = nanmean(a.lon_mean(xgood));  
  xp.satzen = nanmean(a.satzen_mean(xgood));
  xp.solzen = nanmean(a.solzen_mean(xgood));  
  xp.nlevs  = floor(nanmean(a.nlevs_mean(xgood)));
    %xp.spres = max(xp.spres,990);
    %xp.nlevs = max(xp.nlevs,97);  
    xp.spres = max(xp.spres,1013);     	
    xp.nlevs = max(xp.nlevs,98);

  xp.cfrac = nanmean(a.cfrac_mean(xgood));
  xp.ctype = nanmean(a.ctype_mean(xgood));
  xp.cprtop = nanmean(a.cprtop_mean(xgood));
  xp.cprbot = nanmean(a.cprbot_mean(xgood));
  xp.cpsize = nanmean(a.cpsize_mean(xgood));
  xp.cngwat = nanmean(a.cngwat_mean(xgood));

  xp.cfrac2 = nanmean(a.cfrac2_mean(xgood));
  xp.ctype2 = nanmean(a.ctype2_mean(xgood));
  xp.cprtop2 = nanmean(a.cprtop2_mean(xgood));
  xp.cprbot2 = nanmean(a.cprbot2_mean(xgood));
  xp.cpsize2 = nanmean(a.cpsize2_mean(xgood));
  xp.cngwat2 = nanmean(a.cngwat2_mean(xgood));

  xp.cfrac12 = nanmean(a.cfrac12_mean(xgood));  

  xp.satheight = 705000;
  xp.upwell = +1;
  xp.zobs = 705000;
  xp.scanang  = saconv(xp.satzen,xp.zobs);

  %% see normer_cld.m : normalize CO2 to 370 ppm, CH4 to 1800 ppb, N2O to 320 ppb
  %% https://www.esrl.noaa.gov/gmd/ccgg/trends/full.html  co2 ppm : 370 (in 2002) to 410 (in 2018)  
  %% https://www.esrl.noaa.gov/gmd/ccgg/trends_ch4/       ch4 ppb : 1780 (in 2002) to 1850 (in 2018)
  %% https://www.esrl.noaa.gov/gmd/hats/combined/N2O.html n2o ppb : 315 (in 2002) to 330 (in 2018)
  xp.gas_2 = p49.gas_2(:,49);
  xp.gas_4 = p49.gas_4(:,49);
  xp.gas_5 = p49.gas_5(:,49);
  xp.gas_6 = p49.gas_6(:,49);
  xp.gas_9 = p49.gas_9(:,49);        
  xp.gas_12 = p49.gas_12(:,49);

  xp.robs1 = nanmean(px.robs1(:,xgood),2);
  xp.rclr   = nanmean(px.rclr(:,xgood),2);
  xp.rcalc  = nanmean(px.rcld(:,xgood),2);    

  xh.ngas = 8;
  xh.gunit = [1 1 1 1 1 1 1 1 ]';
  xh.glist = [1 2 3 4 5 6 9 12]';

  xpa = {{'profiles','rtime','seconds since 1958'}};
  xha = {{'header','hdf file',fTXT}};

        xh.vcmin = 605;
        xh.vcmax = 2830;
	xh.nchan = 2378;
	xh.ichan = (1:2378)';
        xh.ptype = 1;    %% layers
        xh.pfields = 1;  %% profile only
        xh.pfields = 5;  %% profile + obs

        xh.pmin = min(xp.plevs);
        xh.pmax = max(xp.plevs);

        xp.nemis = 2;
        xp.efreq = [500  3000]';
        xp.emis  = [0.98 0.98]';
        xp.rho   = (1-xp.emis)/pi;

  xp.palts = zeros(101,1);
  for ii370 = 1 : xp.nlevs
    xp.palts(ii370) = p2h(xp.plevs(ii370));
  end

clf
semilogx(xp.plevs(1:19,1),diff(xp.palts(1:20,1)),'o-'); hold on
dp = xp.plevs(1:19,1);
dh = abs(diff(xp.palts(1:20,1)));
dh(1:3) = interp1(log(dp(4:19)),dh(4:19),log(dp(1:3)),[],'extrap');
xp.palts(3) = xp.palts(4) + abs(dh(3));
xp.palts(2) = xp.palts(3) + abs(dh(2));
xp.palts(1) = xp.palts(2) + abs(dh(1));
xp.palts(1:4,1)
semilogx(xp.plevs(1:19,1),diff(xp.palts(1:20,1)),'o-'); hold off

  [ppmvLAY2,ppmvAVG2,ppmvMAX2,pavgLAY,tavgLAY,~,~] = layers2ppmv(xh,xp,1,2);
  [ppmvLAY4,ppmvAVG4,ppmvMAX4,pavgLAY,tavgLAY,~,~] = layers2ppmv(xh,xp,1,4);
  [ppmvLAY6,ppmvAVG6,ppmvMAX6,pavgLAY,tavgLAY,~,~] = layers2ppmv(xh,xp,1,6);    
  for ii370 = 1 : xp.nlevs-1
    xp.gas_2(ii370) = xp.gas_2(ii370)*370/ppmvLAY2(ii370);
    xp.gas_4(ii370) = xp.gas_4(ii370)*320/ppmvLAY4(ii370)/1000;
    xp.gas_6(ii370) = xp.gas_6(ii370)*1800/ppmvLAY6(ii370)/1000;      
  end

  [ppmvLAY2,ppmvAVG2,ppmvMAX2,pavgLAY,tavgLAY,~,~] = layers2ppmv(xh,xp,1,2);
  [ppmvLAY4,ppmvAVG4,ppmvMAX4,pavgLAY,tavgLAY,~,~] = layers2ppmv(xh,xp,1,4);
  [ppmvLAY6,ppmvAVG6,ppmvMAX6,pavgLAY,tavgLAY,~,~] = layers2ppmv(xh,xp,1,6);    

  outdir = dirOUT; 
  rtpwrite([outdir '/xlatbin_oneyear_' num2str(ii) '.op.rtp'],xh,xha,xp,xpa);

  %%%%%%%%%%%%%%%%%%%%%%%%%
  %% then do MEAN over ALL years

  disp('now doing mean over ALL years')
  clear h p
  count = nanmean(a.count')';  good = find(count >= countmin);

  if ~isfield(a,'plevs_mean')
    junk = load('/home/sergio/MATLABCODE/airslevels.dat');
    junk = flipud(junk);
    a.plevs_mean = junk * ones(1,length(a.rtime_mean));
  end

  p.rtime = nanmean(a.rtime_mean(good));
  p.plevs = nanmean(a.plevs_mean(:,good),2);
  p.gas_1 = nanmean(a.gas1_mean(:,good),2);
  p.gas_3 = nanmean(a.gas3_mean(:,good),2);  
  p.ptemp = nanmean(a.ptemp_mean(:,good),2);
  p.stemp = nanmean(a.stemp_mean(good));
  p.spres = nanmean(a.spres_mean(good));
  p.rlat = nanmean(a.lat_mean(good));
  p.rlon = nanmean(a.lon_mean(good));  
  p.satzen = nanmean(a.satzen_mean(good));
  p.solzen = nanmean(a.solzen_mean(good));  
  p.nlevs  = floor(nanmean(a.nlevs_mean(good)));
    %p.spres = max(p.spres,990);
    %p.nlevs = max(p.nlevs,97);  
    p.spres = max(p.spres,1013);     	
    p.nlevs = max(p.nlevs,98);

  p.cfrac = nanmean(a.cfrac_mean(good));
  p.ctype = nanmean(a.ctype_mean(good));
  p.cprtop = nanmean(a.cprtop_mean(good));
  p.cprbot = nanmean(a.cprbot_mean(good));
  p.cpsize = nanmean(a.cpsize_mean(good));
  p.cngwat = nanmean(a.cngwat_mean(good));

  p.cfrac2 = nanmean(a.cfrac2_mean(good));
  p.ctype2 = nanmean(a.ctype2_mean(good));
  p.cprtop2 = nanmean(a.cprtop2_mean(good));
  p.cprbot2 = nanmean(a.cprbot2_mean(good));
  p.cpsize2 = nanmean(a.cpsize2_mean(good));
  p.cngwat2 = nanmean(a.cngwat2_mean(good));

  p.cfrac12 = nanmean(a.cfrac12_mean(good));  

  p.satheight = 705000;
  p.upwell = +1;
  p.zobs = 705000;
  p.scanang  = saconv(p.satzen,p.zobs);

  %% see normer_cld.m : normalize CO2 to 370 ppm, CH4 to 1800 ppb, N2O to 320 ppb
  %% https://www.esrl.noaa.gov/gmd/ccgg/trends/full.html  co2 ppm : 370 (in 2002) to 410 (in 2018)  
  %% https://www.esrl.noaa.gov/gmd/ccgg/trends_ch4/       ch4 ppb : 1780 (in 2002) to 1850 (in 2018)
  %% https://www.esrl.noaa.gov/gmd/hats/combined/N2O.html n2o ppb : 315 (in 2002) to 330 (in 2018)
  p.gas_2 = p49.gas_2(:,49);
  p.gas_4 = p49.gas_4(:,49);
  p.gas_5 = p49.gas_5(:,49);
  p.gas_6 = p49.gas_6(:,49);
  p.gas_9 = p49.gas_9(:,49);        
  p.gas_12 = p49.gas_12(:,49);

  p.robs1 = nanmean(px.robs1(:,good),2);
  p.rclr   = nanmean(px.rclr(:,good),2);
  p.rcalc  = nanmean(px.rcld(:,good),2);    

  h.ngas = 8;
  h.gunit = [1 1 1 1 1 1 1 1 ]';
  h.glist = [1 2 3 4 5 6 9 12]';

  pa = {{'profiles','rtime','seconds since 1958'}};
  ha = {{'header','hdf file',fTXT}};

        h.vcmin = 605;
        h.vcmax = 2830;
	h.nchan = 2378;
	h.ichan = (1:2378)';
        h.ptype = 1;    %% layers
        h.pfields = 1;  %% profile only
        h.pfields = 5;  %% profile + obs

        h.pmin = min(p.plevs);
        h.pmax = max(p.plevs);

        p.nemis = 2;
        p.efreq = [500  3000]';
        p.emis  = [0.98 0.98]';
        p.rho   = (1-p.emis)/pi;

  p.palts = zeros(101,1);
  for ii370 = 1 : p.nlevs
    p.palts(ii370) = p2h(p.plevs(ii370));
  end

clf
semilogx(p.plevs(1:19,1),diff(p.palts(1:20,1)),'o-'); hold on
dp = p.plevs(1:19,1);
dh = abs(diff(p.palts(1:20,1)));
dh(1:3) = interp1(log(dp(4:19)),dh(4:19),log(dp(1:3)),[],'extrap');
p.palts(3) = p.palts(4) + abs(dh(3));
p.palts(2) = p.palts(3) + abs(dh(2));
p.palts(1) = p.palts(2) + abs(dh(1));
p.palts(1:4,1)
semilogx(p.plevs(1:19,1),diff(p.palts(1:20,1)),'o-'); hold off

  [ppmvLAY2,ppmvAVG2,ppmvMAX2,pavgLAY,tavgLAY,~,~] = layers2ppmv(h,p,1,2);
  [ppmvLAY4,ppmvAVG4,ppmvMAX4,pavgLAY,tavgLAY,~,~] = layers2ppmv(h,p,1,4);
  [ppmvLAY6,ppmvAVG6,ppmvMAX6,pavgLAY,tavgLAY,~,~] = layers2ppmv(h,p,1,6);    
  for ii370 = 1 : p.nlevs-1
    p.gas_2(ii370) = p.gas_2(ii370)*370/ppmvLAY2(ii370);
    p.gas_4(ii370) = p.gas_4(ii370)*320/ppmvLAY4(ii370)/1000;
    p.gas_6(ii370) = p.gas_6(ii370)*1800/ppmvLAY6(ii370)/1000;      
  end
  [ppmvLAY2,ppmvAVG2,ppmvMAX2,pavgLAY,tavgLAY,~,~] = layers2ppmv(h,p,1,2);
  [ppmvLAY4,ppmvAVG4,ppmvMAX4,pavgLAY,tavgLAY,~,~] = layers2ppmv(h,p,1,4);
  [ppmvLAY6,ppmvAVG6,ppmvMAX6,pavgLAY,tavgLAY,~,~] = layers2ppmv(h,p,1,6);    

  outdir = dirOUT;
  rtpwrite([outdir '/latbin' num2str(ii) '.op.rtp'],h,ha,p,pa);

  %%%%%%%%%%%%%%%%%%%%%%%%%

  disp('now doing monthly averages')
  %% then do monthly avg
  clear hall pall

  for mmx = 1 : 12
    
    oo = find(mm == mmx & count >= countmin);
    
    clear h p
  
    p.rtime = nanmean(a.rtime_mean(oo));
    p.plevs = nanmean(a.plevs_mean(:,oo),2);
    p.gas_1 = nanmean(a.gas1_mean(:,oo),2);
    p.gas_3 = nanmean(a.gas3_mean(:,oo),2);  
    p.ptemp = nanmean(a.ptemp_mean(:,oo),2);
    p.stemp = nanmean(a.stemp_mean(oo));
    p.spres = nanmean(a.spres_mean(oo));
    p.rlat = nanmean(a.lat_mean(oo));
    p.rlon = nanmean(a.lon_mean(oo));      
    p.satzen = nanmean(a.satzen_mean(oo));
    p.solzen = nanmean(a.solzen_mean(oo));  
    p.nlevs  = nanmean(a.nlevs_mean(oo));
          p.spres = max(p.spres,990);     	
          p.nlevs = max(p.nlevs,97);

    p.cfrac = nanmean(a.cfrac_mean(oo));
    p.ctype = nanmean(a.ctype_mean(oo));
    p.cprtop = nanmean(a.cprtop_mean(oo));
    p.cprbot = nanmean(a.cprbot_mean(oo));
    p.cpsize = nanmean(a.cpsize_mean(oo));
    p.cngwat = nanmean(a.cngwat_mean(oo));

    p.cfrac2 = nanmean(a.cfrac2_mean(oo));
    p.ctype2 = nanmean(a.ctype2_mean(oo));
    p.cprtop2 = nanmean(a.cprtop2_mean(oo));
    p.cprbot2 = nanmean(a.cprbot2_mean(oo));
    p.cpsize2 = nanmean(a.cpsize2_mean(oo));
    p.cngwat2 = nanmean(a.cngwat2_mean(oo));

    p.cfrac12 = nanmean(a.cfrac12_mean(oo));  

    p.satheight = 705000;
    p.upwell = +1;
    p.zobs = 705000;
    p.scanang  = saconv(p.satzen,p.zobs);

    p.gas_2 = p49.gas_2(:,49);
    p.gas_4 = p49.gas_4(:,49);
    p.gas_5 = p49.gas_5(:,49);
    p.gas_6 = p49.gas_6(:,49);
    p.gas_9 = p49.gas_9(:,49);        
    p.gas_12 = p49.gas_12(:,49);

    p.robs1 = nanmean(px.robs1(:,oo),2);
    p.rclr  = nanmean(px.rclr(:,oo),2);
    p.rcalc = nanmean(px.rcld(:,oo),2);    

    h.ngas = 8;
    h.gunit = [1 1 1 1 1 1 1 1 ]';
    h.glist = [1 2 3 4 5 6 9 12]';

        h.vcmin = 605;
        h.vcmax = 2830;
	h.nchan = 2378;
	h.ichan = (1:2378)';
        h.ptype = 1;    %% layers
        h.pfields = 1;  %% profile only
        h.pfields = 5;  %% profile + obs
	h.pfields = 7;  %% profile + obs + cal	
        h.pmin = min(p.plevs);
        h.pmax = max(p.plevs);

        p.nemis = 2;
        p.efreq = [500  3000]';
        p.emis  = [0.98 0.98]';
        p.rho   = (1-p.emis)/pi;


    pa = {{'profiles','rtime','seconds since 1958'}};
    ha = {{'header','hdf file',fTXT}};

    p.palts = zeros(101,1);
    for ii370 = 1 : p.nlevs
      p.palts(ii370) = p2h(p.plevs(ii370));
    end

clf
semilogx(p.plevs(1:19,1),diff(p.palts(1:20,1)),'o-'); hold on
dp = p.plevs(1:19,1);
dh = abs(diff(p.palts(1:20,1)));
dh(1:3) = interp1(log(dp(4:19)),dh(4:19),log(dp(1:3)),[],'extrap');
p.palts(3) = p.palts(4) + abs(dh(3));
p.palts(2) = p.palts(3) + abs(dh(2));
p.palts(1) = p.palts(2) + abs(dh(1));
p.palts(1:4,1)
semilogx(p.plevs(1:19,1),diff(p.palts(1:20,1)),'o-'); hold off

    [ppmvLAY2,ppmvAVG2,ppmvMAX2,pavgLAY,tavgLAY,~,~] = layers2ppmv(h,p,1,2);
    [ppmvLAY4,ppmvAVG4,ppmvMAX4,pavgLAY,tavgLAY,~,~] = layers2ppmv(h,p,1,4);
    [ppmvLAY6,ppmvAVG6,ppmvMAX6,pavgLAY,tavgLAY,~,~] = layers2ppmv(h,p,1,6);    
    for ii370 = 1 : p.nlevs-1
      p.gas_2(ii370) = p.gas_2(ii370)*370/ppmvLAY2(ii370);
      p.gas_4(ii370) = p.gas_4(ii370)*320/ppmvLAY4(ii370)/1000;
      p.gas_6(ii370) = p.gas_6(ii370)*1800/ppmvLAY6(ii370)/1000;      
    end
    [ppmvLAY2,ppmvAVG2,ppmvMAX2,pavgLAY,tavgLAY,~,~] = layers2ppmv(h,p,1,2);
    [ppmvLAY4,ppmvAVG4,ppmvMAX4,pavgLAY,tavgLAY,~,~] = layers2ppmv(h,p,1,4);
    [ppmvLAY6,ppmvAVG6,ppmvMAX6,pavgLAY,tavgLAY,~,~] = layers2ppmv(h,p,1,6);    

    if mmx == 1
      hall = h;
      pall = p;
    else
      [hall,pall] = cat_rtp(hall,pall,h,p);
    end

  end
  rtpwrite([outdir '/latbin' num2str(ii) '_monthly_avg.op.rtp'],hall,ha,pall,pa);
  figure(1);
  plot(pall.stemp); title(['Monthly Avg stemp latbin = ' num2str(ii)]); pause(0.1);

  %%%%%%%%%%%%%%%%%%%%%%%%%
  disp('doing each year/month')
  %% finally do each month
  clear hall pall
  iCnt = 0;
  for yyx = min(yy) : max(yy)
    for mmx = 1 : 12
    
      oo = find(mm == mmx & yy == yyx & count >= countmin);
 
      if length(oo) > 0
        iCnt = iCnt + 1;
        clear h p
  
        p.rtime = nanmean(a.rtime_mean(oo));
        p.plevs = nanmean(a.plevs_mean(:,oo),2);
        p.gas_1 = nanmean(a.gas1_mean(:,oo),2);
        p.gas_3 = nanmean(a.gas3_mean(:,oo),2);  
        p.ptemp = nanmean(a.ptemp_mean(:,oo),2);
        p.stemp = nanmean(a.stemp_mean(oo));
        p.rlat = nanmean(a.lat_mean(oo));
        p.rlon = nanmean(a.lon_mean(oo));      	
        p.spres = nanmean(a.spres_mean(oo));
        p.satzen = nanmean(a.satzen_mean(oo));
        p.solzen = nanmean(a.solzen_mean(oo));  
        p.nlevs  = nanmean(a.nlevs_mean(oo));
          p.spres = max(p.spres,990);     	
          p.nlevs = max(p.nlevs,97);
	  
        p.satheight = 705000;
        p.upwell = +1;
        p.zobs = 705000;
        p.scanang  = saconv(p.satzen,p.zobs);

        p.cfrac = nanmean(a.cfrac_mean(oo));
        p.ctype = nanmean(a.ctype_mean(oo));
        p.cprtop = nanmean(a.cprtop_mean(oo));
        p.cprbot = nanmean(a.cprbot_mean(oo));
        p.cpsize = nanmean(a.cpsize_mean(oo));
        p.cngwat = nanmean(a.cngwat_mean(oo));

        p.cfrac2 = nanmean(a.cfrac2_mean(oo));
        p.ctype2 = nanmean(a.ctype2_mean(oo));
        p.cprtop2 = nanmean(a.cprtop2_mean(oo));
        p.cprbot2 = nanmean(a.cprbot2_mean(oo));
        p.cpsize2 = nanmean(a.cpsize2_mean(oo));
        p.cngwat2 = nanmean(a.cngwat2_mean(oo));

        p.cfrac12 = nanmean(a.cfrac12_mean(oo));  

        p.gas_2 = p49.gas_2(:,49);
        p.gas_4 = p49.gas_4(:,49);
        p.gas_5 = p49.gas_5(:,49);
        p.gas_6 = p49.gas_6(:,49);
        p.gas_9 = p49.gas_9(:,49);        
        p.gas_12 = p49.gas_12(:,49);

        p.robs1 = nanmean(px.robs1(:,oo),2);
        p.rclr  = nanmean(px.rclr(:,oo),2);
        p.rcalc = nanmean(px.rcld(:,oo),2);    

        h.ngas = 8;
        h.gunit = [1 1 1 1 1 1 1 1 ]';
        h.glist = [1 2 3 4 5 6 9 12]';

        h.vcmin = 605;
        h.vcmax = 2830;
	h.nchan = 2378;
	h.ichan = (1:2378)';	
        h.ptype = 1;    %% layers
        h.pfields = 1;  %% profile only
        h.pfields = 5;  %% profile + obs
	h.pfields = 7;  %% profile + obs + cal	
        h.pmin = min(p.plevs);
        h.pmax = max(p.plevs);

        p.nemis = 2;
        p.efreq = [500  3000]';
        p.emis  = [0.98 0.98]';
        p.rho   = (1-p.emis)/pi;

        pa = {{'profiles','rtime','seconds since 1958'}};
        ha = {{'header','hdf file',fTXT}};

        if iCnt == 1
          hall = h;
          pall = p;
        else
          [hall,pall] = cat_rtp(hall,pall,h,p);
        end
	
      end     %% if length(oo) > 0
    end       %% loop over month    
  end         %% loop over year
  rtpwrite([outdir '/latbin' num2str(ii) '_eachmonth.op.rtp'],hall,ha,pall,pa);
  figure(2)
  plot(pall.stemp); title(['Each Month Avg stemp latbin = ' num2str(ii)]); pause(0.1);

disp(' ')
end  %% for ii = 1 : 40

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hall = [];
pall = [];
for ii = 1 : 40
  [h,ha,p,pa] = rtpread([outdir '/latbin' num2str(ii) '.op.rtp']);
  h.nchan = 2378;
  h.ichan = (1:2378)';  
  if ii == 1
    hall = h;
    pall = p;
  else
    [hall,pall] = cat_rtp(hall,pall,h,p);
  end
end
hall.nchan = 2378;
hall.ichan = (1:2378)';
pall.plat = pall.rlat;
pall.plon = pall.rlon;
rtpwrite([outdir '/latbin1_40.op.rtp'],hall,ha,pall,pa);

%klayers = '/asl/packages/klayersV205/BinV201/klayers_airs';
%klayerser = ['!' klayers ' fin=LATS40_avg/Desc/latbin1_40.ip.rtp fout=LATS40_avg/Desc/latbin1_40.op.rtp'];
%eval(klayerser)

fopx = [outdir '/latbin1_40.op.rtp'];
frpx = [outdir '/latbin1_40.rp.rtp'];
sarta = '/home/sergio/SARTA_CLOUDY/BinV201/sarta_apr08_m140x_iceGHMbaum_waterdrop_desertdust_slabcloud_hg3';
sartaer = ['!' sarta ' fin=' fopx ' fout=' frpx];
eval(sartaer)

figure(1);
fairs = instr_chans;
[hfinal,hax,pfinal,pax] = rtpread(frpx);
pfinal.rclr0  = pall.rclr;  %% this is one big fat average (after running sarta thousands of profies per day, then averaged over 365 days
pfinal.rcalc0 = pall.rcalc; %% this is one big fat average (after running sarta thousands of profies per day, then averaged over 365 days
rtpwrite(frpx,hfinal,hax,pfinal,pax);
plot(fairs,rad2bt(fairs,pfinal.rcalc));

tobs1231 = rad2bt(1231,pfinal.robs1(1291,:));
tclr1231 = rad2bt(1231,pfinal.rclr0(1291,:));
tcld1231 = rad2bt(1231,pfinal.rcalc0(1291,:));
tcf1231 = rad2bt(1231,pfinal.rcalc(1291,:));
plot(pfinal.stemp,tcf1231)
plot(pfinal.rlat,pfinal.stemp,'k',pfinal.rlat,tobs1231,'r',pfinal.rlat,tcld1231,'b',pfinal.rlat,tclr1231,'c',pfinal.rlat,tcf1231,'g','linewidth',2)
hl = legend('stemp','robs1','rcld','rclr','rsergio <avg prof>','location','south'); set(hl,'fontsize',10);
xlabel('rlat'); ylabel('BT1231');
axis([-100 +100 220 320]); grid

plot(pfinal.rlat,tobs1231,'r',pfinal.rlat,tcld1231,'c',pfinal.rlat,tclr1231,'bd-',pfinal.rlat,tcf1231,'g',pfinal.rlat,pfinal.stemp,'k','linewidth',2)
hl = legend('AIRS Obs','SARTA CLD','SARTA CLR','SARTA sergio','STEMP','location','south'); set(hl,'fontsize',10);
xlabel('rlat'); ylabel('BT1231');
axis([-100 +100 220 320]); grid

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hall = [];
pall = [];
for ii = 1 : 40
  [h,ha,p,pa] = rtpread([outdir '/xlatbin_oneyear_' num2str(ii) '.op.rtp']);
  h.nchan = 2378;
  h.ichan = (1:2378)';  
  if ii == 1
    hall = h;
    pall = p;
  else
    [hall,pall] = cat_rtp(hall,pall,h,p);
  end
end
hall.nchan = 2378;
hall.ichan = (1:2378)';
pall.plat = pall.rlat;
pall.plon = pall.rlon;
bwah = find(pall.cfrac12 > pall.cfrac);  pall.cfrac12(bwah) = pall.cfrac(bwah)/2;
bwah = find(pall.cfrac12 > pall.cfrac2); pall.cfrac12(bwah) = pall.cfrac2(bwah)/2;
rtpwrite([outdir '/xlatbin_oneyear_1_40.op.rtp'],hall,ha,pall,pa);

%klayers = '/asl/packages/klayersV205/BinV201/klayers_airs';
%klayerser = ['!' klayers ' fin=LATS40_avg/Desc/latbin1_40.ip.rtp fout=LATS40_avg/Desc/latbin1_40.op.rtp'];
%eval(klayerser)

fopx = [outdir '/xlatbin_oneyear_1_40.op.rtp'];
frpx = [outdir '/xlatbin_oneyear_1_40.rp.rtp'];
sarta = '/home/sergio/SARTA_CLOUDY/BinV201/sarta_apr08_m140x_iceGHMbaum_waterdrop_desertdust_slabcloud_hg3';
sartaer = ['!' sarta ' fin=' fopx ' fout=' frpx];
eval(sartaer)

figure(2)
fairs = instr_chans;
[hfinal,hax,pfinal,pax] = rtpread(frpx);
pfinal.rclr = pall.rclr;
pfinal.rcalc = pall.rcalc;
rtpwrite(frpx,hfinal,hax,pfinal,pax);
plot(fairs,rad2bt(fairs,pfinal.rcalc));

tobs1231 = rad2bt(1231,pfinal.robs1(1291,:));
tclr1231 = rad2bt(1231,pfinal.rclr(1291,:));
tcld1231 = rad2bt(1231,pfinal.rcalc(1291,:));
tcf1231 = rad2bt(1231,pfinal.rcalc(1291,:));
plot(pfinal.stemp,tcf1231)
plot(pfinal.rlat,pfinal.stemp,'k',pfinal.rlat,tobs1231,'r',pfinal.rlat,tcld1231,'b',pfinal.rlat,tclr1231,'c',pfinal.rlat,tcf1231,'g','linewidth',2)
hl = legend('stemp','robs1','rcld','rclr','rsergio','location','south'); set(hl,'fontsize',10);
xlabel('rlat'); ylabel('BT1231');
axis([-100 +100 220 320]); grid

plot(pfinal.rlat,tobs1231,'r',pfinal.rlat,tcld1231,'c',pfinal.rlat,tclr1231,'bd-',pfinal.rlat,tcf1231,'g',pfinal.rlat,pfinal.stemp,'k','linewidth',2)
hl = legend('AIRS Obs','SARTA CLD','SARTA CLR','SARTA sergio','STEMP','location','south'); set(hl,'fontsize',10);
xlabel('rlat'); ylabel('BT1231');
axis([-100 +100 220 320]); grid

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
frpx1 = [outdir '/latbin1_40.rp.rtp'];
frpx2 = [outdir '/xlatbin_oneyear_1_40.rp.rtp'];
favg1 = [outdir '/globalavg_latbin1_40.rp.rtp'];
favg2 = [outdir '/globalavg_xlatbin_oneyear_1_40.rp.rtp'];
[hall1,hajunk,pall1,pajunk] = rtpread(frpx1);
[hall2,hajunk,pall2,pajunk] = rtpread(frpx2);
figure(3);
  plot(pall1.stemp-pall2.stemp)
  plot(pall1.ptemp-pall2.ptemp,1:101); set(gca,'ydir','reverse')
  plot(pall1.gas_1./pall2.gas_1,1:101); set(gca,'ydir','reverse')
  plot(pall1.gas_3./pall2.gas_3,1:101); set(gca,'ydir','reverse')
  plot(1:40,pall1.cfrac,'b',1:40,pall2.cfrac,'b--',1:40,pall1.cfrac2,'r',1:40,pall2.cfrac2,'r--',1:40,pall1.cfrac12,'g',1:40,pall2.cfrac12,'g--')
  plot(1:40,pall1.cprtop,'b',1:40,pall2.cprtop,'b--',1:40,pall1.cprtop2,'r',1:40,pall2.cprtop2,'r--')
  plot(1:40,pall1.cprbot,'b',1:40,pall2.cprbot,'b--',1:40,pall1.cprbot2,'r',1:40,pall2.cprbot2,'r--')
  plot(1:40,pall1.cngwat,'b',1:40,pall2.cngwat,'b--',1:40,pall1.cngwat2,'r',1:40,pall2.cngwat2,'r--')
  plot(1:40,pall1.cpsize,'b',1:40,pall2.cpsize,'b--',1:40,pall1.cpsize2,'r',1:40,pall2.cpsize2,'r--')

[ppmvLAY2,ppmvAVG2,ppmvMAX2,pavgLAY,tavgLAY]    = layers2ppmv(hall1,pall1,1:length(pall1.stemp),2);
[ppmvLAY4,ppmvAVG4,ppmvMAX4,pavgLAY,tavgLAY]    = layers2ppmv(hall1,pall1,1:length(pall1.stemp),4);
[ppmvLAY6,ppmvAVG6,ppmvMAX6,pavgLAY,tavgLAY]    = layers2ppmv(hall1,pall1,1:length(pall1.stemp),6);
plot(ppmvLAY2,pavgLAY);
plot(ppmvLAY4,pavgLAY);
plot(ppmvLAY6,pavgLAY); 

[ppmvLAY2,ppmvAVG2,ppmvMAX2,pavgLAY,tavgLAY]    = layers2ppmv(hall2,pall2,1:length(pall2.stemp),2);
[ppmvLAY4,ppmvAVG4,ppmvMAX4,pavgLAY,tavgLAY]    = layers2ppmv(hall2,pall2,1:length(pall2.stemp),4);
[ppmvLAY6,ppmvAVG6,ppmvMAX6,pavgLAY,tavgLAY]    = layers2ppmv(hall2,pall2,1:length(pall2.stemp),6);
plot(ppmvLAY2,pavgLAY);
plot(ppmvLAY4,pavgLAY);
plot(ppmvLAY6,pavgLAY); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% now do the global average
newavg1 = find_global_average_40latbins(pall1); rtpwrite(favg1,hall1,hajunk,newavg1,pajunk);
newavg2 = find_global_average_40latbins(pall2); rtpwrite(favg2,hall1,hajunk,newavg2,pajunk);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% fix_heights   %%% NOT NEEDED since things should be ok

