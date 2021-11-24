figure(1);
fairs = instr_chans;
[hfinal,hax,pfinal,pax] = rtpread(frpx);
if isfield(a,'rcldy')  
  pfinal.rclr0  = pall.rclr;  %% this is one big fat average (after running sarta thousands of profies per day, then averaged over 365 days
  pfinal.rcalc0 = pall.rcalc; %% this is one big fat average (after running sarta thousands of profies per day, then averaged over 365 days
else
  pfinal.rclr0  = pall.rcalc; %% this is one big fat average (after running sarta thousands of profies per day, then averaged over 365 days
  pfinal.rcalc0 = pall.rcalc; %% this is one big fat average (after running sarta thousands of profies per day, then averaged over 365 days
end
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
if isfield(a,'rcldy')  
  bwah = find(pall.cfrac12 > pall.cfrac);  pall.cfrac12(bwah) = pall.cfrac(bwah)/2;
  bwah = find(pall.cfrac12 > pall.cfrac2); pall.cfrac12(bwah) = pall.cfrac2(bwah)/2;
end
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
if isfield(a,'rcldy')  
  pfinal.rclr = pall.rclr;
  pfinal.rcalc = pall.rcalc;
else
  pfinal.rclr = pall.rcalc;
  pfinal.rcalc = pall.rcalc;
end
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
frpx1 = [outdir '/latbin1_40.rp.rtp'];           %% 40 profiles, each latbin averaged over entire 16 years
frpx2 = [outdir '/xlatbin_oneyear_1_40.rp.rtp']; %% 40 profiles, each latbin averaged over 1         year

favg1 = [outdir '/globalavg_latbin1_40.rp.rtp'];           %% average over all 40 latbins to get one global average over all 16 years
favg2 = [outdir '/globalavg_xlatbin_oneyear_1_40.rp.rtp']; %% average over all 40 latbins to get one global average over    one year

[hall1,hajunk,pall1,pajunk] = rtpread(frpx1);
[hall2,hajunk,pall2,pajunk] = rtpread(frpx2);
figure(3);
  plot(pall1.stemp-pall2.stemp)
  plot(pall1.ptemp-pall2.ptemp,1:101); set(gca,'ydir','reverse')
  plot(pall1.gas_1./pall2.gas_1,1:101); set(gca,'ydir','reverse')
  plot(pall1.gas_3./pall2.gas_3,1:101); set(gca,'ydir','reverse')
  if isfield(a,'rcldy')  
    plot(1:40,pall1.cfrac,'b',1:40,pall2.cfrac,'b--',1:40,pall1.cfrac2,'r',1:40,pall2.cfrac2,'r--',1:40,pall1.cfrac12,'g',1:40,pall2.cfrac12,'g--')
    plot(1:40,pall1.cprtop,'b',1:40,pall2.cprtop,'b--',1:40,pall1.cprtop2,'r',1:40,pall2.cprtop2,'r--')
    plot(1:40,pall1.cprbot,'b',1:40,pall2.cprbot,'b--',1:40,pall1.cprbot2,'r',1:40,pall2.cprbot2,'r--')
    plot(1:40,pall1.cngwat,'b',1:40,pall2.cngwat,'b--',1:40,pall1.cngwat2,'r',1:40,pall2.cngwat2,'r--')
    plot(1:40,pall1.cpsize,'b',1:40,pall2.cpsize,'b--',1:40,pall1.cpsize2,'r',1:40,pall2.cpsize2,'r--')
  end

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
%% copied from  ../../oem_pkg_run_sergio_AuxJacs_before2019/Aux_jacs_AIRS_August2018_2002_2017/
newavg1 = find_global_average_40latbins(pall1); rtpwrite(favg1,hall1,hajunk,newavg1,pajunk);
newavg2 = find_global_average_40latbins(pall2); rtpwrite(favg2,hall1,hajunk,newavg2,pajunk);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% copied from  ../../oem_pkg_run_sergio_AuxJacs_before2019/Aux_jacs_AIRS_August2018_2002_2017/
%% fix_heights   %%% NOT NEEDED since things should be ok

