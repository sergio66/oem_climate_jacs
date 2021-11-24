addpath /asl/matlib/h4tools
addpath /home/sergio/KCARTA/MATLAB
addpath /home/sergio/MATLABCODE/PLOTTER

[h,ha,p,pa] = rtpread('/asl/rtp/rtp_airicrad_v6/clear/2012/era_airicrad_day127_clear.rtp');

iaLat = equal_area_spherical_bands(20);

oo = find(p.rlat >= iaLat(2) & p.rlat < iaLat(3));
[h2,p2] = subset_rtp(h,p,[],[],oo);

klayers = '/asl/packages/klayersV205/BinV201/klayers_airs';
sarta   = '/asl/packages/sartaV108/Bin/sarta_apr08_m140';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% run klayers and do the average profile
fip = 'all_levs.ip.rtp';
fop = 'all_lays.op.rtp';
frp = 'all_lays.rp.rtp';

klayerser = ['!' klayers ' fin=' fip ' fout=' fop];
sartaer = ['!' sarta ' fin=' fop ' fout=' frp];

rtpwrite(fip,h2,ha,p2,pa);
eval(klayerser);
eval(sartaer);
[h2f,haf,p2f,pa] = rtpread(frp);

thefields = fieldnames(p2f);
for ii = 1 : length(thefields)
  str = ['junk = p2f.' thefields{ii} ';'];
  eval(str);
  [mm,nn] = size(junk);
  if mm == 1
    avg = nanmean(junk);
    str = ['p2favglay.' thefields{ii} ' = avg;'];
    eval(str);
  else
    avg = nanmean(junk,2);
    str = ['p2favglay.' thefields{ii} ' = avg;'];
    eval(str);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% do the average levels profile and run through klayers
thefields = fieldnames(p2);
for ii = 1 : length(thefields)
  str = ['junk = p2.' thefields{ii} ';'];
  eval(str);
  [mm,nn] = size(junk);
  if mm == 1
    avg = nanmean(junk);
    str = ['p2avglev.' thefields{ii} ' = avg;'];
    eval(str);
  else
    avg = nanmean(junk,2);
    str = ['p2avglev.' thefields{ii} ' = avg;'];
    eval(str);
  end
end

fip = 'all_levsx.ip.rtp';
fop = 'all_laysx.op.rtp';
frp = 'all_laysx.rp.rtp';

klayerser = ['!' klayers ' fin=' fip ' fout=' fop];
sartaer = ['!' sarta ' fin=' fop ' fout=' frp];

rtpwrite(fip,h2,ha,p2avglev,pa);
eval(klayerser);
eval(sartaer);
[h2favglev,haf,p2favglev,pa] = rtpread(frp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[p2favglay.solzen p2favglev.solzen]
[p2favglay.satzen p2favglev.satzen]
[p2favglay.spres p2favglev.spres]
[p2favglay.stemp p2favglev.stemp]
[p2favglay.nlevs p2favglev.nlevs]

figure(1); clf
plot(p2favglay.ptemp,1:101,p2favglev.ptemp,1:101); set(gca,'ydir','reverse');
plot(p2favglay.ptemp - p2favglev.ptemp,1:101); set(gca,'ydir','reverse'); axis([-0.2 +0.2 1 98]); grid
xlabel('T1 - T2');

figure(2); clf
semilogx(p2favglay.gas_1,1:101,p2favglev.gas_1,1:101); set(gca,'ydir','reverse');
plot(p2favglay.gas_1 ./ p2favglev.gas_1,1:101); set(gca,'ydir','reverse'); axis([0.975 1.025 1 98]); grid
xlabel('WV1 / WV2');

figure(3); clf
semilogx(p2favglay.gas_3,1:101,p2favglev.gas_3,1:101); set(gca,'ydir','reverse');
plot(p2favglay.gas_3 ./ p2favglev.gas_3,1:101); set(gca,'ydir','reverse'); axis([0.975 1.025 1 98]); grid
xlabel('OZ1 / OZ2');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(4); clf
%% comes straight from 50 profile average
tobs0 = rad2bt(h2favglev.vchan,p2avglev.robs1);
%tcal0 = rad2bt(h2favglev.vchan,p2avglev.rcalc);

%% run 50 levels profiles through klayers and sarta, then average
tobs1 = rad2bt(h2favglev.vchan,p2favglay.robs1);
tcal1 = rad2bt(h2favglev.vchan,p2favglay.rcalc);

%% average 50 levs profiles, then run through klayers and sarta
tobs2 = rad2bt(h2favglev.vchan,p2favglev.robs1);
tcal2 = rad2bt(h2favglev.vchan,p2favglev.rcalc);

figure(4)
[sum(sum(tobs0-tobs1)) sum(sum(tobs1-tobs2))]
[sum(sum(tcal1-tcal2))]
plot(h2favglev.vchan,tobs0-tcal1,h2favglev.vchan,tobs0-tcal2)
plot(h2favglev.vchan,tcal1-tcal2); title('BT1-BT2');

