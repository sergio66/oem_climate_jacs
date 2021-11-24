JOB  = str2num(getenv('SLURM_ARRAY_TASK_ID'));
%JOB = 2222

addpath /asl/matlib/h4tools
addpath /asl/matlib/aslutil
addpath /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/StrowCodeforTrendsAndAnomalies

%% convert this to Latbin x Lon

latbin = floor((JOB-1)/72)+1;
lonbin = JOB - 72*(latbin-1);

%for JOBB = 1 : 72*64
%  latbin = floor((JOBB-1)/72)+1;
%  lonbin = JOBB - 72*(latbin-1);
%  fprintf(1,'%4i %2i %2i \n',JOBB,latbin,lonbin)
%end

fin = ['DATA/LatBin' num2str(latbin,'%02i') '/summary_latbin_' num2str(latbin,'%02i') '_lonbin_' num2str(lonbin,'%02i') '.rtp'];
fprintf(1,'%s \n',fin);
if ~exist(fin)
  error('file DNE')
end

[h,ha,p,pa] = rtpread(fin);

warning off
for ii = 1 : 101
  if mod(ii,10) == 0
    fprintf(1,'+');
  else
    fprintf(1,'.');
  end
  y = p.ptemp(ii,:);
  x = (1:386)*16;
  oo = find(isfinite(y) & y > 0);
  if length(oo) > 20
    x = x(oo);
    y = y(oo);
    [B, stats]=Math_tsfit_lin_robust(x,y,4);
    trend.ptemp(ii) = B(2);
    trend.ptemp_err(ii) = stats.se(2);
  else
    trend.ptemp(ii) = NaN;
    trend.ptemp_err(ii) = NaN;
  end

  y = p.gas_1(ii,:);
  x = (1:386)*16;
  oo = find(isfinite(y) & y > 0);
  if length(oo) > 20
    x = x(oo);
    y = y(oo)/mean(y(oo));
    [B, stats]=Math_tsfit_lin_robust(x,y,4);
    trend.gas_1(ii) = B(2);
    trend.gas_1_err(ii) = stats.se(2);
  else
    trend.gas_1(ii) = NaN;
    trend.gas_1_err(ii) = NaN;
  end

  y = p.gas_3(ii,:);
  x = (1:386)*16;
  oo = find(isfinite(y) & y > 0);
  if length(oo) > 20
    x = x(oo);
    y = y(oo)/mean(y(oo));
    [B, stats]=Math_tsfit_lin_robust(x,y,4);
    trend.gas_3(ii) = B(2);
    trend.gas_3_err(ii) = stats.se(2);
  else
    trend.gas_3(ii) = NaN;
    trend.gas_3_err(ii) = NaN;
  end
end
fprintf(1,'\n');

%%%%%%%%%%%%%%%%%%%%%%%%%

tobs = rad2bt(h.vchan,p.robs1);
tcld = rad2bt(h.vchan,p.rcalc);
tclr = rad2bt(h.vchan,p.sarta_rclearcalc);
thefields = {'tobs','tcld','tclr'};

disp('tobs')
txyz = tobs;
for jj = 1 : 2645
  x = (1:386)*16; 
  y = txyz(jj,:);
  oo = find(isfinite(y) & y > 0);
  if length(oo) > 20
    x = x(oo);
    y = y(oo);
    [B, stats]=Math_tsfit_lin_robust(x,y,4);
    trend.btobs(jj) = B(2);
    trend.btobs_err(jj) = stats.se(2);
  else
    trend.btobs(jj) = NaN;
    trend.btobs_err(jj) = NaN;
  end
end

disp('tcld')
txyz = tcld;
for jj = 1 : 2645
  x = (1:386)*16; 
  y = txyz(jj,:);
  oo = find(isfinite(y) & y > 0);
  if length(oo) > 20
    x = x(oo);
    y = y(oo);
    [B, stats]=Math_tsfit_lin_robust(x,y,4);
    trend.btcld(jj) = B(2);
    trend.btcld_err(jj) = stats.se(2);
  else
    trend.btcld(jj) = NaN;
    trend.btcld_err(jj) = NaN;
  end
end

disp('tclr')
txyz = tclr;
for jj = 1 : 2645
  x = (1:386)*16; 
  y = txyz(jj,:);
  oo = find(isfinite(y) & y > 0);
  if length(oo) > 20
    x = x(oo);
    y = y(oo);
    [B, stats]=Math_tsfit_lin_robust(x,y,4);
    trend.btclr(jj) = B(2);
    trend.btclr_err(jj) = stats.se(2);
  else
    trend.btclr(jj) = NaN;
    trend.btclr_err(jj) = NaN;
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%

thefields = {'stemp','icecngwat','iceOD','icetop','icebot','icesze','watercngwat','waterOD','watertop','waterbot','watersze'};
for ii = 1 : length(thefields)
  str = thefields{ii};
  x = (1:386)*16; 
  ystr = ['y = p.' str ';']; eval(ystr);
  oo = find(isfinite(y) & y > 0);
  if length(oo) > 20
    x = x(oo);
    y = y(oo);
    [B, stats]=Math_tsfit_lin_robust(x,y,4);
    tstr = ['trend.' str '      = B(2);'];        eval(tstr);
    tstr = ['trend.' str '_err  = stats.se(2);']; eval(tstr);
    tstr = ['trend.' str '_mean = mean(y);'];     eval(tstr);
  else
    tstr = ['trend.' str ' = NaN;'];      eval(tstr);
    tstr = ['trend.' str '_err = NaN;'];  eval(tstr);
    tstr = ['trend.' str '_mean = NaN;']; eval(tstr);
  end
end
warning on

fout = ['DATA/LatBin' num2str(latbin,'%02i') '/summary_trends_latbin_' num2str(latbin,'%02i') '_lonbin_' num2str(lonbin,'%02i') '.mat'];
fprintf(1,'done saving to %s \n',fout)
save(fout,'-struct','trend');
