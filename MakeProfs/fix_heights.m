%run_sarta.cumsum = 9999;
%run_sarta.clear = -1;
%run_sarta.ForceNewSlabs = +1;
%addpath /home/sergio/MATLABCODE/matlib/clouds/sarta
%[pnew,oldslabs] = driver_sarta_cloud_rtp(hfinal,hax,pfinal,pax,run_sarta);

%% I want to make all calcs about 5 K colder
pnew = pfinal;
h0 = 1000;
h0 = 2500;
h0 = 1750;  %% works well for Desc/ocean, and quite ok for Desc/all
watercldfac = 2;
watercldfac = 1.5;

cprtop = p2h(pnew.cprtop) + h0*(1-0.35*sin(pnew.rlat*pi/180)); pnew.cprtop = h2p(cprtop);
cprbot = p2h(pnew.cprbot) + h0*(1-0.35*sin(pnew.rlat*pi/180)); pnew.cprbot = h2p(cprbot);
cprtop2 = p2h(pnew.cprtop2) + h0/watercldfac*(1-0.35*sin(pnew.rlat*pi/180)); pnew.cprtop2 = h2p(cprtop2);
cprbot2 = p2h(pnew.cprbot2) + h0/watercldfac*(1-0.35*sin(pnew.rlat*pi/180)); pnew.cprbot2 = h2p(cprbot2);

rtpwrite('LATS40_avg/latbin1_40_tweak.op.rtp',hfinal,hax,pnew,pax);
sarta = '/home/sergio/SARTA_CLOUDY/BinV201/sarta_apr08_m140x_iceGHMbaum_waterdrop_desertdust_slabcloud_hg3';
sartaer = ['!' sarta ' fin=LATS40_avg/latbin1_40_tweak.op.rtp fout=LATS40_avg/latbin1_40_tweak.rp.rtp'];
eval(sartaer)
[hfinal,hax,pnew2,pax] = rtpread('LATS40_avg/latbin1_40_tweak.rp.rtp');

tnew1231 = rad2bt(1231,pnew2.rcalc(1291,:));
plot(pfinal.rlat,pfinal.stemp,'k',pfinal.rlat,tobs1231,'r',pfinal.rlat,tcld1231,'b',pfinal.rlat,tclr1231,'c',pfinal.rlat,tnew1231,'g','linewidth',2)
hl = legend('stemp','robs1','rcld','rclr','rnewsergio','location','south'); set(hl,'fontsize',10);
xlabel('rlat'); ylabel('BT1231');
axis([-100 +100 220 320]); grid

plot(pfinal.rlat,tobs1231,'r',pfinal.rlat,tcld1231,'c',pfinal.rlat,tclr1231,'bd-',pfinal.rlat,tnew1231,'g',pfinal.rlat,pfinal.stemp,'k','linewidth',2)
hl = legend('AIRS Obs','SARTA CLD','SARTA CLR','SARTA NEW sergio','STEMP','location','south'); set(hl,'fontsize',10);
xlabel('rlat'); ylabel('BT1231');
axis([-100 +100 250 310]); grid

factor = ones(size(pnew.rlat));
pnew = pnew2;
tnew1231_0 = tnew1231;
for jj = 1 : 1
  %% number of tweaks
  cprtop = p2h(pnew.cprtop) + h0*factor; pnew.cprtop = h2p(cprtop);
  cprbot = p2h(pnew.cprbot) + h0*factor; pnew.cprbot = h2p(cprbot);
  cprtop2 = p2h(pnew.cprtop2) + h0/watercldfac*factor; pnew.cprtop2 = h2p(cprtop2);
  cprbot2 = p2h(pnew.cprbot2) + h0/watercldfac*factor; pnew.cprbot2 = h2p(cprbot2);

  rtpwrite('LATS40_avg/xlatbin1_40_tweak.op.rtp',hfinal,hax,pnew,pax);
  sarta = '/home/sergio/SARTA_CLOUDY/BinV201/sarta_apr08_m140x_iceGHMbaum_waterdrop_desertdust_slabcloud_hg3';
  sartaer = ['!' sarta ' fin=LATS40_avg/xlatbin1_40_tweak.op.rtp fout=LATS40_avg/xlatbin1_40_tweak.rp.rtp'];
  eval(sartaer)
  [hfinal,hax,xpnew2,pax] = rtpread('LATS40_avg/xlatbin1_40_tweak.rp.rtp');
  xtnew1231 = rad2bt(1231,xpnew2.rcalc(1291,:));

  plot(pfinal.rlat,tobs1231,'r',pfinal.rlat,tcld1231,'c',pfinal.rlat,tclr1231,'bd-',pfinal.rlat,xtnew1231,'g',pfinal.rlat,pfinal.stemp,'k','linewidth',2)
  hl = legend('AIRS Obs','SARTA CLD','SARTA CLR','SARTA NEW sergio','STEMP','location','south'); set(hl,'fontsize',10);
  xlabel('rlat'); ylabel('BT1231');
  axis([-100 +100 250 310]); grid

  bias0 = tobs1231 - tnew1231_0;
  biasN = tobs1231 - xtnew1231;

  plot(pfinal.rlat,bias0,pfinal.rlat,biasN); grid
  slope = (biasN-bias0)/1000;
  xpert = -bias0 ./ slope

  %%%%%%%%%%%%%%%%%%%%%%%%%
  pnew = pnew2;
  cprtop = p2h(pnew.cprtop) + xpert; pnew.cprtop = h2p(cprtop);
  cprbot = p2h(pnew.cprbot) + xpert; pnew.cprbot = h2p(cprbot);
  cprtop2 = p2h(pnew.cprtop2) + xpert/watercldfac; pnew.cprtop2 = h2p(cprtop2);
  cprbot2 = p2h(pnew.cprbot2) + xpert/watercldfac; pnew.cprbot2 = h2p(cprbot2);

  rtpwrite('LATS40_avg/xlatbin1_40_tweak.op.rtp',hfinal,hax,pnew,pax);
  sarta = '/home/sergio/SARTA_CLOUDY/BinV201/sarta_apr08_m140x_iceGHMbaum_waterdrop_desertdust_slabcloud_hg3';
  sartaer = ['!' sarta ' fin=LATS40_avg/xlatbin1_40_tweak.op.rtp fout=LATS40_avg/xlatbin1_40_tweak.rp.rtp'];
  eval(sartaer)
  [hfinal,hax,xpnew2,pax] = rtpread('LATS40_avg/xlatbin1_40_tweak.rp.rtp');
  xtnew1231 = rad2bt(1231,xpnew2.rcalc(1291,:));

  tropi = tropopause_rtp(hfinal,xpnew2);
  tropi_hgt = xpnew2.plevs(:,21);
  tropi_press = tropi_hgt(tropi);
  tropi_hgt = p2h(tropi_press)/1000;

  figure(1)
  plot(pfinal.rlat,tobs1231,'rx-',pfinal.rlat,tcld1231,'c',pfinal.rlat,tclr1231,'bd-',pfinal.rlat,xtnew1231,'g',pfinal.rlat,pfinal.stemp,'k','linewidth',2)
  hl = legend('AIRS Obs','SARTA CLD','SARTA CLR','SARTA NEW sergio','STEMP','location','south'); set(hl,'fontsize',10);
  xlabel('rlat'); ylabel('BT1231');
  axis([-100 +100 250 310]); grid

  figure(2); plot(pnew.rlat,pfinal.cprtop,'c',pnew.rlat,pfinal.cprtop2,'m',pnew.rlat,xpnew2.cprtop,'b',pnew.rlat,xpnew2.cprtop2,'r','linewidth',2)
  set(gca,'ydir','reverse')
  

  figure(2); plot(pnew.rlat,p2h(pfinal.cprtop)/1000,'c',pnew.rlat,p2h(pfinal.cprtop2)/1000,'m',...
                  pnew.rlat,p2h(xpnew2.cprtop)/1000,'b',pnew.rlat,p2h(xpnew2.cprtop2)/1000,'r',pnew.rlat,tropi_hgt,'k','linewidth',2)

  figure(3);
    pcolor(pnew.rlat,xpnew2.plevs(:,21),xpnew2.ptemp); colorbar; colormap jet; shading interp
    hold on
    plot(pnew.rlat,pfinal.cprtop,'c',pnew.rlat,pfinal.cprtop2,'m',pnew.rlat,xpnew2.cprtop,'b',pnew.rlat,xpnew2.cprtop2,'r',...
         pnew.rlat,tropi_press,'k','linewidth',4)
    hold off
  set(gca,'ydir','reverse')
  
end
