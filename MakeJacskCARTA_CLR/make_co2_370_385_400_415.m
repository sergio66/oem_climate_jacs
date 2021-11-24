addpath /asl/matlib/h4tools
addpath /asl/matlib/aslutil
addpath /asl/matlib/rtptools
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS
addpath /home/sergio/MATLABCODE/

fin = 'latbin1_40.clr.rp.rtp';

[h,ha,pall,pa] = rtpread(fin);
[h,p21] = subset_rtp(h,pall,[],[],21);
[ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p21,1,2);
semilogy(ppmvLAY,pavgLAY); set(gca,'ydir','reverse');
meanCO2 = mean(ppmvLAY(10:30));

iaCO2 = [370 385 400 415];
for ii = 1 : length(iaCO2)
  if ii == 1
    pnew = p21;
    pnew.gas_2 = pnew.gas_2 * iaCO2(ii)/meanCO2;
  else
    px = p21;
    px.gas_2 = px.gas_2 * iaCO2(ii)/meanCO2;
    [h,pnew] = cat_rtp(h,pnew,h,px);
  end
end
[appmvLAY,appmvAVG,appmvMAX,apavgLAY,atavgLAY,appmv500,appmv75] = layers2ppmv_dryair(h,pnew,1:length(iaCO2),2);
semilogy(appmvLAY,apavgLAY); set(gca,'ydir','reverse');
plot(iaCO2,appmvLAY(50,:),'o-')
    
rtpwrite('make_co2_370_385_400_415.op.rtp',h,ha,pnew,pa);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
kcarta = '/home/sergio/KCARTA/BIN/kcarta.x_f90_121_400ppmv_H16';
for ii = 1 : 4
  ii
  sedder = ['!sed -e "s/MMM/' num2str(ii) '/g" templatejacCO2_370_385_400_415_col.nml > junk.nml' ];
  eval(sedder)
  kcartaer = ['!' kcarta ' junk.nml junkCO2_' num2str(ii) '.dat junkCO2_' num2str(ii) '.jac'];
  eval(kcartaer)
end

addpath /home/sergio/KCARTA/MATLAB
for ii = 1 : 4
  [d(ii,:),w] = readkcstd(['junkCO2_' num2str(ii) '.dat']);
  [junk,w]    = readkcBasic(['junkCO2_' num2str(ii) '.jac_COL']);
  dpert(ii,:) = junk(:,1);
end

tnew = rad2bt(w,dpert');
t0 = rad2bt(w,d');
jac = (tnew-t0);
[fc,qc] = quickconvolve(w,jac,0.5,0.5);
[fc,qc] = convolve_airs(w,jac,1:2378);

%% above is jac for 10% change
qcx = qc * (2.2./370)/0.1;
plot(fc,qcx)
plot(fc,qcx./(qcx(:,1)*ones(1,4))); axis([640 2780 0.9 1.25])

%% this is better way
iaDelta = ones(length(qcx),1) * 2.2./iaCO2;
qcx = qc .* iaDelta * 0.1;
figure(1); plot(fc,qcx); axis([640 840 -1e-3 +1e-3]);                      hl = legend('370','385','400','415');title('Abs numbers for 2.2 ppmv change'); ylabel('dBT(K)');
figure(2); plot(fc,qcx - qcx(:,1)*ones(1,4)); axis([640 840 -1e-4 +1e-4]); hl = legend('370','385','400','415');title('Relative Jac(X)-Jac(370)');
figure(3); plot(fc,qcx./(qcx(:,1)*ones(1,4))); axis([640 840 0.75 1.25]);  hl = legend('370','385','400','415');title('Ratio Jac(X)/Jac(370)');
figure(4); plot(fc,100*(1-qcx./(qcx(:,1)*ones(1,4)))); axis([640 840 -25 +25]);  hl = legend('370','385','400','415');title('Percent change in jac(X) to jac(370)');
