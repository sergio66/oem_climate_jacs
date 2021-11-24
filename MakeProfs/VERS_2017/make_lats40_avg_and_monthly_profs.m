addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/
addpath /asl/matlib/rtptools
addpath /asl/matlib/h4tools
addpath /asl/matlib/aslutil

set_dirIN_dirOUT

for ii = 1 : 40
  
  fname = [dirIN '/statlat' num2str(ii) '.mat'];
  fprintf(1,'%s \n',fname)
  fTXT = fname;
  loader = ['a = load(''' fname ''');'];
  eval(loader);

  if iName_has_mean < 0
    [yy,mm,dd,hh] = tai2utcSergio(a.rtime);
  else
    [yy,mm,dd,hh] = tai2utcSergio(a.rtime_mean);
  end
  
  %%%%%%%%%%%%%%%%%%%%%%%%%
  %% first do MEAN

  clear h p

  if iName_has_mean < 0
    p.rtime = nanmean(a.rtime);
    p.plevs = nanmean(a.plevs,1)';
    p.gas_1 = nanmean(a.gas1,1)';
    p.gas_3 = nanmean(a.gas3,1)';  
    p.ptemp = nanmean(a.ptemp,1)';
    p.stemp = nanmean(a.stemp);
    p.spres = nanmean(a.spres);
    p.rlat = nanmean(a.lat);
    p.rlon = nanmean(a.lon);  
    p.satzen = nanmean(a.satzen);
    p.solzen = nanmean(a.solzen);  
    p.nlevs  = nanmean(a.nlevs);
  else  
    p.rtime = nanmean(a.rtime_mean);
    p.plevs = nanmean(a.plevs_mean,1)';
    p.gas_1 = nanmean(a.gas1_mean,1)';
    p.gas_3 = nanmean(a.gas3_mean,1)';  
    p.ptemp = nanmean(a.ptemp_mean,1)';
    p.stemp = nanmean(a.stemp_mean);
    p.spres = nanmean(a.spres_mean);
    p.rlat = nanmean(a.lat_mean);
    p.rlon = nanmean(a.lon_mean);  
    p.satzen = nanmean(a.satzen_mean);
    p.solzen = nanmean(a.solzen_mean);  
    p.nlevs  = nanmean(a.nlevs_mean);
  end
  
  p.satheight = 705000;
  p.upwell = +1;
  p.zobs = 705000;
  p.scanang  = saconv(p.satzen,p.zobs);
  
  h.ngas = 2;
  h.gunit = [21 21]';
  h.glist = [1 3]';

  pa = {{'profiles','rtime','seconds since 1958'}};
  ha = {{'header','hdf file',fTXT}};

        h.vcmin = 605;
        h.vcmax = 2830;
        h.ptype = 0;    %% levels
        h.pfields = 1;  %% profile only
        h.pmin = min(p.plevs);
        h.pmax = max(p.plevs);

        p.nemis = 2;
        p.efreq = [500  3000]';
        p.emis  = [0.98 0.98]';
        p.rho   = (1-p.emis)/pi;


  rtpwrite([dirOUT '/latbin' num2str(ii) '.ip.rtp'],h,ha,p,pa);

  %%%%%%%%%%%%%%%%%%%%%%%%%
  %% then do monthly avg
  clear hall pall

  for mmx = 1 : 12
    
    oo = find(mm == mmx);
    
    clear h p

    if iName_has_mean < 0
      p.rtime = nanmean(a.rtime(oo));
      p.plevs = nanmean(a.plevs(oo,:),1)';
      p.gas_1 = nanmean(a.gas1(oo,:),1)';
      p.gas_3 = nanmean(a.gas3(oo,:),1)';  
      p.ptemp = nanmean(a.ptemp(oo,:),1)';
      p.stemp = nanmean(a.stemp(oo));
      p.spres = nanmean(a.spres(oo));
      p.rlat = nanmean(a.lat(oo));
      p.rlon = nanmean(a.lon(oo));      
      p.satzen = nanmean(a.satzen(oo));
      p.solzen = nanmean(a.solzen(oo));  
      p.nlevs  = nanmean(a.nlevs(oo));
    else
      p.rtime = nanmean(a.rtime_mean(oo));
      p.plevs = nanmean(a.plevs_mean(oo,:),1)';
      p.gas_1 = nanmean(a.gas1_mean(oo,:),1)';
      p.gas_3 = nanmean(a.gas3_mean(oo,:),1)';  
      p.ptemp = nanmean(a.ptemp_mean(oo,:),1)';
      p.stemp = nanmean(a.stemp_mean(oo));
      p.spres = nanmean(a.spres_mean(oo));
      p.rlat = nanmean(a.lat_mean(oo));
      p.rlon = nanmean(a.lon_mean(oo));      
      p.satzen = nanmean(a.satzen_mean(oo));
      p.solzen = nanmean(a.solzen_mean(oo));  
      p.nlevs  = nanmean(a.nlevs_mean(oo));
    end
    
    p.satheight = 705000;
    p.upwell = +1;
    p.zobs = 705000;
    p.scanang  = saconv(p.satzen,p.zobs);

    h.ngas = 2;
    h.gunit = [21 21]';
    h.glist = [1 3]';

        h.vcmin = 605;
        h.vcmax = 2830;
        h.ptype = 0;    %% levels
        h.pfields = 1;  %% profile only
        h.pmin = min(p.plevs);
        h.pmax = max(p.plevs);

        p.nemis = 2;
        p.efreq = [500  3000]';
        p.emis  = [0.98 0.98]';
        p.rho   = (1-p.emis)/pi;


    pa = {{'profiles','rtime','seconds since 1958'}};
    ha = {{'header','hdf file',fTXT}};

    if mmx == 1
      hall = h;
      pall = p;
    else
      [hall,pall] = cat_rtp(hall,pall,h,p);
    end
  end
  rtpwrite([dirOUT '/latbin' num2str(ii) '_monthly_avg.ip.rtp'],hall,ha,pall,pa);
  figure(1);
  plot(pall.stemp); title(['Monthly Avg stemp latbin = ' num2str(ii)]); pause(0.1);

  %%%%%%%%%%%%%%%%%%%%%%%%%
  %% finally do each month
  clear hall pall
  iCnt = 0;
  for yyx = 2002 : 2016
    for mmx = 1 : 12
    
      oo = find(mm == mmx & yy == yyx);
 
      if length(oo) > 0
        iCnt = iCnt + 1;
        clear h p

        if iName_has_mean < 0       
          p.rtime = nanmean(a.rtime(oo));
          p.plevs = nanmean(a.plevs(oo,:),1)';
          p.gas_1 = nanmean(a.gas1(oo,:),1)';
          p.gas_3 = nanmean(a.gas3(oo,:),1)';  
          p.ptemp = nanmean(a.ptemp(oo,:),1)';
          p.stemp = nanmean(a.stemp(oo));
          p.rlat = nanmean(a.lat(oo));
          p.rlon = nanmean(a.lon(oo));      	
          p.spres = nanmean(a.spres(oo));
          p.satzen = nanmean(a.satzen(oo));
          p.solzen = nanmean(a.solzen(oo));  
          p.nlevs  = nanmean(a.nlevs(oo));
        else
          p.rtime = nanmean(a.rtime_mean(oo));
          p.plevs = nanmean(a.plevs_mean(oo,:),1)';
          p.gas_1 = nanmean(a.gas1_mean(oo,:),1)';
          p.gas_3 = nanmean(a.gas3_mean(oo,:),1)';  
          p.ptemp = nanmean(a.ptemp_mean(oo,:),1)';
          p.stemp = nanmean(a.stemp_mean(oo));
          p.rlat = nanmean(a.lat_mean(oo));
          p.rlon = nanmean(a.lon_mean(oo));      	
          p.spres = nanmean(a.spres_mean(oo));
          p.satzen = nanmean(a.satzen_mean(oo));
          p.solzen = nanmean(a.solzen_mean(oo));  
          p.nlevs  = nanmean(a.nlevs_mean(oo));
        end
        p.satheight = 705000;
        p.upwell = +1;
        p.zobs = 705000;
        p.scanang  = saconv(p.satzen,p.zobs);
  
        h.ngas = 2;
        h.gunit = [21 21]';
        h.glist = [1 3]';

        h.vcmin = 605;
        h.vcmax = 2830;
        h.ptype = 0;    %% levels
        h.pfields = 1;  %% profile only
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
  rtpwrite([dirOUT '/latbin' num2str(ii) '_eachmonth.ip.rtp'],hall,ha,pall,pa);
  figure(2)
  plot(pall.stemp); title(['Each Month Avg stemp latbin = ' num2str(ii)]); pause(0.1);

end  %% for ii = 1 : 40

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hall = [];
pall = [];
for ii = 1 : 40
  [h,ha,p,pa] = rtpread(['LATS40_avg/latbin' num2str(ii) '.ip.rtp']);
  if ii == 1
    hall = h;
    pall = p;
  else
    [hall,pall] = cat_rtp(hall,pall,h,p);  
  end
end
pall.plat = pall.rlat;
pall.plon = pall.rlon;
rtpwrite([dirOUT '/latbin1_40.ip.rtp'],hall,ha,pall,pa);
klayers = '/asl/packages/klayersV205/BinV201/klayers_airs';
klayerser = ['!' klayers ' fin=' dirOUT '/latbin1_40.ip.rtp fout=' dirOUT '/latbin1_40.op.rtp'];
eval(klayerser)