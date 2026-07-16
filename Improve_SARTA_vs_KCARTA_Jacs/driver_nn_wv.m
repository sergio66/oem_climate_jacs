driver_nn_master

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1); clf
yyaxis left;  plot(f,nanmean(kcarta,1),f,nanstd(kcarta,[],1))
yyaxis right; plot(f,nanmean(kcarta-sarta,1),f,nanstd(kcarta-sarta,[],1))
  legend('kcarta mean dBT/dST','kcarta std dBT/dST','mean diff','std diff','location','best')

figure(2);
iChan = 1291; %% f(1291) = 1231 cm-1
plot(pnew.scanang,kcarta(:,1291)-sarta(:,1291),'.')
plot(pnew.stemp,kcarta(:,1291)-sarta(:,1291),'.')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Assume your data:
% P : [numParams x N]     ← 10 to 50 rows
% X : [1 x N]             ← initial scalar values
% Y : [1 x N]             ← target scalar values

iChan = find(f >= 1291,1);

kcartaY = kcarta(:,iChan)';
sartaX  = sarta(:,iChan)';
paramsP(1,:) = pnew_nan.stemp;
paramsP(2,:) = pnew_nan.spres;
paramsP(3,:) = pnew_nan.mmw;
paramsP(4,:) = pnew_nan.o3du;
paramsP(5,:) = pnew_nan.co2ppmvGND;
paramsP(6,:) = pnew_nan.ch4ppmvGND;
paramsP(7,:) = pnew_nan.scanang;
%%%
for ii = 1 : length(pnew_nan.stemp)
  nn = pnew_nan.nlevs(ii)-1;
  paramsP(08,ii) = pnew_nan.ptemp(nn-0,ii);
  paramsP(09,ii) = pnew_nan.ptemp(nn-1,ii);
  paramsP(10,ii) = pnew_nan.ptemp(nn-2,ii);  
  paramsP(11,ii) = pnew_nan.gas_1(nn-0,ii)/1e21;
  paramsP(12,ii) = pnew_nan.gas_1(nn-1,ii)/1e21;
  paramsP(13,ii) = pnew_nan.gas_1(nn-2,ii)/1e21;  
end

error('got this far')
yG = do_nn_grok3(paramsP,sartaX,kcartaY,0.95);
yC = do_nn_claude1(paramsP',sartaX',kcartaY',0.95);
