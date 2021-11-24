addpath /home/sergio/MATLABCODE/FIND_TRENDS
addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/
addpath /asl/matlib/rtptools
addpath /asl/matlib/h4tools
addpath /asl/matlib/aslutil

set_dirIN_dirOUT

fip  = [dirOUT '/latbin' num2str(iiBin) '_alldata.ip.rtp'];
fop  = [dirOUT '/latbin' num2str(iiBin) '_alldata.op.rtp'];
frp  = [dirOUT '/latbin' num2str(iiBin) '_alldata.rp.rtp'];
fout = [dirOUT '/latbin' num2str(iiBin) '_rates.mat'];

for ii = iiBin : iiBin
  
  fname = [dirIN '/statlat' num2str(ii) '.mat'];
  fprintf(1,'%s \n',fname)
  fTXT = fname;
  loader = ['a = load(''' fname ''');'];
  eval(loader);

  [yy,mm,dd,hh] = tai2utcSergio(a.rtime);

  clear h p

  woo = find(isfinite(a.nlevs));
  if length(woo) < length(a.rtime)
    [length(woo) length(a.rtime)]
  end
  
  p.rtime = a.rtime(woo)';
  p.plevs = a.plevs(woo,:)';
  p.gas_1 = a.gas1(woo,:)';
  p.gas_3 = a.gas3(woo,:)';  
  p.ptemp = a.ptemp(woo,:)';
  p.stemp = a.stemp(woo)';
  p.spres = a.spres(woo)';
  p.rlat = a.lat(woo)';
  p.rlon = a.lon(woo)';  
  p.plat = a.lat(woo)';
  p.plon = a.lon(woo)';  
  p.satzen = a.satzen(woo)';
  p.solzen = a.solzen(woo)';  
  p.nlevs  = a.nlevs(woo)';

  p.spres(p.spres < 1013) = 1013;
  
  p.satheight = 705000 * ones(size(p.rlat));
  p.upwell = +1 * ones(size(p.rlat));;
  p.zobs = 705000 * ones(size(p.rlat));
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
  h.pmin = min(p.plevs(:));
  h.pmax = max(p.plevs(:));

  p.nemis = 2 * ones(size(p.rlat));;
  p.efreq = [500  3000]' * ones(size(p.rlat));
  p.emis  = [0.98 0.98]' * ones(size(p.rlat));
  p.rho   = (1-p.emis)/pi;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hall = h;
pall = p;

pall.plat = pall.rlat;
pall.plon = pall.rlon;

rtpwrite(fip,hall,ha,pall,pa);
klayers = '/asl/packages/klayersV205/BinV201/klayers_airs';
klayerser = ['!' klayers ' fin=' fip ' fout=' fop];
eval(klayerser)

[hfinal,hajunk,pfinal,pajunk] = rtpread(fop);
[yy,mm,dd,hh] = tai2utcSergio(pfinal.rtime);
t = change2days(yy,mm,dd,2002);

mmw = mmwater_rtp(hfinal,pfinal);

%% now fit the rates
%% see /home/sergio/MATLABCODE/FIND_TRENDS/StrowFit/fit_robust_one_lat.m

[b,stats] = Math_tsfit_lin_robust(t,pfinal.stemp,4);
rate.stemp     = b(2);
rate.stemp_err = stats(2);
[b,stats] = Math_tsfit_lin_robust(t,mmw,4);
rate.mmw     = b(2);
rate.mmw_err = stats(2);

warning off
for ll = 1 : 97
  fprintf(1,'%2i of 97 \n',ll)
  [b,stats] = Math_tsfit_lin_robust(t,pfinal.ptemp(ll,:),4);
  rate.ptemp(ll)     = b(2);
  rate.ptemp_err(ll) = stats(2);
  [b,stats] = Math_tsfit_lin_robust(t,pfinal.gas_1(ll,:),4);
  rate.gas_1(ll)     = b(2);
  rate.gas_1_err(ll) = stats(2);
  [b,stats] = Math_tsfit_lin_robust(t,pfinal.gas_3(ll,:),4);
  rate.gas_3(ll)     = b(2);
  rate.gas_3_err(ll) = stats(2);

  [b,stats] = Math_tsfit_lin_robust(t,pfinal.gas_1(ll,:)/nanmean(pfinal.gas_1(ll,:)),4);
  rate.frac_gas_1(ll)     = b(2);
  rate.frac_gas_1_err(ll) = stats(2);
  [b,stats] = Math_tsfit_lin_robust(t,pfinal.gas_3(ll,:)/nanmean(pfinal.gas_3(ll,:)),4);  
  rate.frac_gas_3(ll)     = b(2);
  rate.frac_gas_3_err(ll) = stats(2);
end
warning on

comment = 'rates_profiles40.m from clust_make_geophysical_rates40.m';
saver = ['save ' fout ' comment rate'];
eval(saver);

