addpath /home/sergio/MATLABCODE/CRODGERS_FAST_CLOUD
addpath /home/sergio/MATLABCODE/COLORMAP
addpath /asl/matlib/h4tools
addpath /asl/matlib/aslutil

klayers = '/asl/packages/klayersV205/BinV201/klayers_airs';

sarta2008 = '/home/sergio/SARTA_CLOUDY/BinV201/sarta_apr08_m140x_iceGHMbaum_waterdrop_desertdust_slabcloud_hg3';         %% HITRAN 2008 spectroscopy
sarta2016 = '/home/chepplew/gitLib/sarta/bin/airs_l1c_2834_cloudy_may19';                                                %% HITRAN 2016 spectroscopy

tempfile1 = 'xxxjunk1';
tempfile2 = 'xxxjunk2';
tempfile3 = 'xxxjunk3';
tempfile4 = 'xxxjunk4';
tempx.tempfile1 = tempfile1;
tempx.tempfile2 = tempfile2;
tempx.tempfile3 = tempfile3;
tempx.tempfile4 = tempfile4;
tempx.klayers = klayers;

tempx2008 = tempx; tempx2008.sarta   = sarta2008;
tempx2016 = tempx; tempx2016.sarta   = sarta2016;

fname = 'AnomSym_no_seasonal/timestep_180_16day_avg.rp.rtp';
%{
cp  ../MakeJacskCARTA_CLD/templatejac_WTO.nml .
edit to use above file
time /home/sergio/KCARTA/BIN/kcarta.x_f90_121_400ppmv_H16 templatejac_WTO.nml timestep_180_16day_avg.dat timestep_180_16day_avg.jac, 54 seconds

addpath /home/sergio/KCARTA/MATLAB
addpath /home/sergio/MATLABCODE
more   ~sergio/KCARTA/WORK/RUN_TARA/GENERIC_RADSnJACS_MANYPROFILES/airs_convolve_file_numchans.m
clist = 1 : 2834;
sfile = '/home/chepplew/projects/airs/L1C/airs_l1c_srf_tables_lls_new.hdf';  %% these are one and the same, 2834 chans
sfile = '/home/sergio/MATLABCODE/airs_l1c_srf_tables_lls_20181205.hdf';      %% these are one and the same, 2834 chans

[rad,w] = readkcstd('timestep_180_16day_avg.dat');
[fc,qc] = convolve_airs(w,rad,1:2378,sfile);

[kjac,w] = readkcjac('timestep_180_16day_avg.jac');
ind = (1:97); water = kjac(:,ind+0*97) + kjac(:,ind+2*97) + kjac(:,ind+3*97) + kjac(:,ind+4*97); [fc,jcwater] = convolve_airs(w,water,1:2378,sfile);
ind = (1:97); ozone = kjac(:,ind+1*97); [fc,jcozone] = convolve_airs(w,ozone,1:2378,sfile);
ind = (1:97); tempr = kjac(:,ind+5*97); [fc,jctempr] = convolve_airs(w,tempr,1:2378,sfile);

%}

[hoem,ha,poem,pa] = rtpread(fname);
if ~isfield(poem,'robs1')
  poem.robs1 = poem.rcalc + randn(size(poem.rcalc));
end

if ~exist('jacCld108','var') & ~exist('sartaOLD_vs_sartaNEW_jacs.mat')
  [tObs08,tCalc008,jacST08,jacO308,jacWV08,jacT08,coljacCO208,coljacO308,coljacCH408,jacCld108,jacCld208,tropi08,jacCO2T08,jacCO2S08,tempx08] = jac5(hoem,ha,poem,pa,tempx2008);
  [tObs16,tCalc016,jacST16,jacO316,jacWV16,jacT16,coljacCO216,coljacO316,coljacCH416,jacCld116,jacCld216,tropi16,jacCO2T16,jacCO2S16,tempx16] = jac5(hoem,ha,poem,pa,tempx2016);
  save -v7.3 sartaOLD_vs_sartaNEW_jacs.mat tObs* tCalc* jac* tempx*  fc qc jc*
elseif ~exist('jacCld108','var') & exist('sartaOLD_vs_sartaNEW_jacs.mat')
  load sartaOLD_vs_sartaNEW_jacs.mat
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% compare kCARTA with SARTA
figure(1)
plot(hoem.vchan,tCalc008(:,20)-tCalc016(:,20),'k.-',hoem.vchan,tCalc008(:,20)-rad2bt(fc,qc),'b',hoem.vchan,tCalc016(:,20)-rad2bt(fc,qc),'r')
hl = legend('SARTA08-SARTA16','KCARTA-SARTA98','KCARTA-SARTA16','location','best'); ylabel('\delta BT (K)')

disp('jac5 uses d(BT)/log10(1+dQ) = d(BT)/ln(1+dQ)/ln(10) = 1/2.3026 d(BT)/d(lnQ) = 1/2.3026 kcarta jac')
jcwv = fliplr(jcwater); jcwv = jcwv';
jc16 = squeeze(jacWV16(1:97,:,20))/log(10);  jc08 = squeeze(jacWV08(1:97,:,20))/log(10); 
usa22 = usa2; usa22(1,:) = 1; usa22(120,:) = 1;

figure(2);
plot(hoem.vchan,sum(jcwv),'k',hoem.vchan,sum(jc16),'r',hoem.vchan,sum(jc08),'b'); hl = legend('kcarya','SARTA16','SARTA08');
plot(hoem.vchan,(sum(jc16)+eps)./(sum(jcwv)+eps),'r',hoem.vchan,(sum(jc08)+eps)./(sum(jcwv)+eps),'b'); hl = legend('SARTA16/KCARTA','SARTA08/KCARTA'); axis([640 1640 0.0 2.5]); grid
title('WV column jac ratio')

figure(3);
  pcolor(hoem.vchan,1:97,100*(jcwv-jc16+eps)./(jcwv+eps)); colorbar; shading flat
  cx = caxis; cx = [-100 +100]; caxis(cx); colormap(usa22); set(gca,'ydir','reverse'); 
  title('KCARTA2016 - SARTA2016 WV percent jac diff')
  axis([640 1640 0 100])

%%%% 
figure(1);
  pcolor(hoem.vchan,1:97,100*(jcwv-jc08+eps)./(jcwv+eps)); colorbar; shading flat
  cx = caxis; cx = [-100 +100]; caxis(cx); colormap(usa22); set(gca,'ydir','reverse'); 
  title('KCARTA2016 - SARTA2008 WV percent jac diff')
  axis([640 1640 0 100])

figure(2);
  pcolor(hoem.vchan,1:97,100*(jcwv-jc16+eps)./(jcwv+eps)); colorbar; shading flat
  cx = caxis; cx = [-100 +100]; caxis(cx); colormap(usa22); set(gca,'ydir','reverse'); 
  title('KCARTA2016 - SARTA2016 WV percent jac diff')
  axis([640 1640 0 100])

figure(3);
  pcolor(hoem.vchan,1:97,100*(jc08-jc16+eps)./(jc08+eps)); colorbar; shading flat
  cx = caxis; cx = [-100 +100]; caxis(cx); colormap(usa22); set(gca,'ydir','reverse'); 
  title('SARTA2008 - SARTA2016 WV percent jac diff')
  axis([640 1640 0 100])

for ii=1:3; figure(ii); caxis([-25 +25]); colorbar; end

boo08 = abs((jcwv-jc08+eps)./(jcwv+eps));
boo16 = abs((jcwv-jc16+eps)./(jcwv+eps));
boo08_vs_16 = ones(size(boo08));

i6p7 = find(hoem.vchan >= 1340 & hoem.vchan <= 1640);
ii = find(boo08 < boo16); boo08_vs_16(ii) = -1;
ii = find(boo08 == boo16); boo08_vs_16(ii) = 0;
figure(4);
  pcolor(hoem.vchan,1:97,boo08_vs_16); colorbar; shading flat
  cx = caxis; cx = [-1 +1]; caxis(cx); colormap(usa22); set(gca,'ydir','reverse'); 
  axis([640 1640 0 100])
colormap(usa2); title('(-1) 08 better (+1) 16 better (0) equal')
[length(find(boo08_vs_16 == -1)) length( find(boo08_vs_16 == 0)) length( find(boo08_vs_16 == +1)) ]

i6p7 = find(hoem.vchan >= 1340 & hoem.vchan <= 1640);
[length(find(boo08_vs_16(:,i6p7) == -1)) length( find(boo08_vs_16(:,i6p7) == 0)) length( find(boo08_vs_16(:,i6p7) == +1)) ]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1);
  pcolor(hoem.vchan,1:100,squeeze(jacWV08(:,:,20))-squeeze(jacWV16(:,:,20))); colorbar; shading flat
  cx = caxis; cx = [-max(abs(cx)) +max(abs(cx))]; caxis(cx); colormap(usa2); set(gca,'ydir','reverse'); 
  title('SARTA2008 - SARTA2016 WV jac diff')
  axis([640 1640 0 100])

figure(2);
  pcolor(hoem.vchan,1:100,100*(squeeze(jacWV08(:,:,20))-squeeze(jacWV16(:,:,20)))./squeeze(jacWV08(:,:,20))); colorbar; shading flat
  cx = caxis; cx = [-max(abs(cx)) +max(abs(cx))]; caxis(cx); colormap(usa2); set(gca,'ydir','reverse'); 
  title('SARTA2008 - SARTA2016 WV percent jac diff')
  axis([640 1640 0 100])

disp('jac5 uses d(BT)/log10(1+dQ) = d(BT)/ln(1+dQ)/ln(10) = 1/2.3026 d(BT)/d(lnQ) = 1/2.3026 kcarta jac')
jcwv = fliplr(jcwater); jcwv = jcwv';
jc16 = squeeze(jacWV16(1:97,:,20))/log(10);  jc08 = squeeze(jacWV08(1:97,:,20))/log(10); 

figure(1);
plot(hoem.vchan,sum(jcwv),'k',hoem.vchan,sum(jc16),'r',hoem.vchan,sum(jc08),'b'); hl = legend('kcarya','SARTA16','SARTA08');
plot(hoem.vchan,(sum(jc16)+eps)./(sum(jcwv)+eps),'r',hoem.vchan,(sum(jc08)+eps)./(sum(jcwv)+eps),'b'); hl = legend('SARTA16/KCARTA','SARTA08/KCARTA'); axis([640 1640 0.0 2.5]); grid
title('WV column jac ratio')

figure(2);
  pcolor(hoem.vchan,1:97,100*(jcwv-jc16)./jcwv); colorbar; shading flat
  cx = caxis; cx = [-max(abs(cx)) +max(abs(cx))]; caxis(cx); colormap(usa2); set(gca,'ydir','reverse'); 
  title('KCARTA2016 - SARTA2016 WV percent jac diff')
  axis([640 1640 0 100])

figure(1); shading interp
figure(2); shading interp
figure(3); plot(hoem.vchan,sum(squeeze(jacT08(:,:,20))),'b',hoem.vchan,sum(squeeze(jacT16(:,:,20))),'r')
figure(3); plot(hoem.vchan,sum(squeeze(jacT08(:,:,20))) - sum(squeeze(jacT16(:,:,20))),'b')
figure(3); plot(hoem.vchan,100*(sum(squeeze(jacT08(:,:,20))) - sum(squeeze(jacT16(:,:,20)))) ./ sum(squeeze(jacT08(:,:,20))),'b'); title('percent diff column WV jac 2008-2016')

figure(2);
  pcolor(hoem.vchan,1:100,squeeze(jacT08(:,:,20))-squeeze(jacT16(:,:,20))); colorbar; shading flat
  cx = caxis; cx = [-max(abs(cx)) +max(abs(cx))]; caxis(cx); colormap(usa2); set(gca,'ydir','reverse'); 
  title('SARTA2008 - SARTA2016 T jac diff')
  axis([640 1640 0 100])


figure(3); plot(hoem.vchan,jacST08,'b',hoem.vchan,jacST08(:,20),'r'); title('stemp jac 2008'); axis([640 1640 -0.02 +1])
figure(3); plot(hoem.vchan,jacST08-jacST16); title('stemp jac 2008-2016'); axis([640 1640 -0.02 +0.02])
