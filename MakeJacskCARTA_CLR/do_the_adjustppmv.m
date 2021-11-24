iPlot = +1;  %% for debug
iPlot = -1;  %% for debug

%% now adjust ppmv at latbin

xppmv0  = layers2ppmv_dryair(h,p0, 1:length(p00.stemp),iWhichGas);   %% this is HOPEFULLY correct input ppmv adjusted to time t0 = 2002/02, with correct T(z,t),W(z,t),O3(z,t)
ppmv00  = layers2ppmv_dryair(h,p00,1:length(p00.stemp),iWhichGas);   %% this is correct input ppmv at time t,            correct T(z,t),W(z,t),O3(z,t)
ppmv370 = layers2ppmv_dryair(h,p370,1,iWhichGas);                    %% this is correct input ppmv at time t0 = 2002/02  at t0   T(z,t0),W(z,t0),O3(z,t0)

theadjust(1:length(ppmv370)) = xppmv0(1:length(ppmv370),iiBin) ./ ppmv370;
if iWhichGas == 2
  p0.gas_2(1:length(ppmv370),iiBin) = p0.gas_2(1:length(ppmv370),iiBin) ./ theadjust';
elseif iWhichGas == 4
  p0.gas_4(1:length(ppmv370),iiBin) = p0.gas_4(1:length(ppmv370),iiBin) ./ theadjust';
elseif iWhichGas == 6
  p0.gas_6(1:length(ppmv370),iiBin) = p0.gas_6(1:length(ppmv370),iiBin) ./ theadjust';
elseif iWhichGas == 51
  p0.gas_51(1:length(ppmv370),iiBin) = p0.gas_51(1:length(ppmv370),iiBin) ./ theadjust';
elseif iWhichGas == 52
  p0.gas_52(1:length(ppmv370),iiBin) = p0.gas_52(1:length(ppmv370),iiBin) ./ theadjust';
end
ppmv0   = layers2ppmv_dryair(h,p0, 1:length(p00.stemp),iWhichGas);   %% this is HOPEFULLY correct input ppmv adjusted to time t0 = 2002/02, with correct T(z,t),W(z,t),O3(z,t)

if iWhichGas == 2 & iPlot > 0
  figure(4); plot(p00.gas_2./p0.gas_2,1:101,'b',p00.gas_2(:,iiBin)./p0.gas_2(:,iiBin),1:101,'rx-'); set(gca,'ydir','reverse'); title('GasX')
  figure(4); semilogx(p00.gas_2(:,iiBin),1:101,p0.gas_2(:,iiBin),1:101,'rx-'); set(gca,'ydir','reverse'); title('Gas2')
  figure(4); plot(ppmv00./ppmv0,1:97,'b',ppmv00(:,iiBin)./ppmv0(:,iiBin),1:97,'rx-'); set(gca,'ydir','reverse'); title('GasX ppmv')
  figure(4); plot(ppmv00(:,iiBin),1:97,'b',ppmv0(:,iiBin),1:97,'rx-',ppmv370,1:97,'g'); set(gca,'ydir','reverse'); title('GasX ppmv')
elseif iWhichGas == 4 & iPlot > 0
  figure(4); plot(p00.gas_4./p0.gas_4,1:101,'b',p00.gas_4(:,iiBin)./p0.gas_4(:,iiBin),1:101,'rx-'); set(gca,'ydir','reverse'); title('GasX')
  figure(4); semilogx(p00.gas_4(:,iiBin),1:101,p0.gas_4(:,iiBin),1:101,'rx-'); set(gca,'ydir','reverse'); title('Gas2')
  figure(4); plot(ppmv00./ppmv0,1:97,'b',ppmv00(:,iiBin)./ppmv0(:,iiBin),1:97,'rx-'); set(gca,'ydir','reverse'); title('GasX ppmv')
  figure(4); plot(ppmv00(:,iiBin),1:97,'b',ppmv0(:,iiBin),1:97,'rx-',ppmv370,1:97,'g'); set(gca,'ydir','reverse'); title('GasX ppmv')
elseif iWhichGas == 6 & iPlot > 0
  figure(4); plot(p00.gas_6./p0.gas_6,1:101,'b',p00.gas_6(:,iiBin)./p0.gas_6(:,iiBin),1:101,'rx-'); set(gca,'ydir','reverse'); title('GasX')
  figure(4); semilogx(p00.gas_6(:,iiBin),1:101,p0.gas_6(:,iiBin),1:101,'rx-'); set(gca,'ydir','reverse'); title('Gas2')
  figure(4); plot(ppmv00./ppmv0,1:97,'b',ppmv00(:,iiBin)./ppmv0(:,iiBin),1:97,'rx-'); set(gca,'ydir','reverse'); title('GasX ppmv')
  figure(4); plot(ppmv00(:,iiBin),1:97,'b',ppmv0(:,iiBin),1:97,'rx-',ppmv370,1:97,'g'); set(gca,'ydir','reverse'); title('GasX ppmv')
elseif iWhichGas == 51 & iPlot > 0
  figure(4); plot(p00.gas_51./p0.gas_51,1:101,'b',p00.gas_51(:,iiBin)./p0.gas_51(:,iiBin),1:101,'rx-'); set(gca,'ydir','reverse'); title('GasX')
  figure(4); semilogx(p00.gas_51(:,iiBin),1:101,p0.gas_51(:,iiBin),1:101,'rx-'); set(gca,'ydir','reverse'); title('Gas2')
  figure(4); plot(ppmv00./ppmv0,1:97,'b',ppmv00(:,iiBin)./ppmv0(:,iiBin),1:97,'rx-'); set(gca,'ydir','reverse'); title('GasX ppmv')
  figure(4); plot(ppmv00(:,iiBin),1:97,'b',ppmv0(:,iiBin),1:97,'rx-',ppmv370,1:97,'g'); set(gca,'ydir','reverse'); title('GasX ppmv')
elseif iWhichGas == 52 & iPlot > 0
  figure(4); plot(p00.gas_52./p0.gas_52,1:101,'b',p00.gas_52(:,iiBin)./p0.gas_52(:,iiBin),1:101,'rx-'); set(gca,'ydir','reverse'); title('GasX')
  figure(4); semilogx(p00.gas_52(:,iiBin),1:101,p0.gas_52(:,iiBin),1:101,'rx-'); set(gca,'ydir','reverse'); title('Gas2')
  figure(4); plot(ppmv00./ppmv0,1:97,'b',ppmv00(:,iiBin)./ppmv0(:,iiBin),1:97,'rx-'); set(gca,'ydir','reverse'); title('GasX ppmv')
  figure(4); plot(ppmv00(:,iiBin),1:97,'b',ppmv0(:,iiBin),1:97,'rx-',ppmv370,1:97,'g'); set(gca,'ydir','reverse'); title('GasX ppmv')
end

if iPlot > 0
  %% these are the 100 layer stuff, no col jacs
  figure(1); plot(p00.ptemp-p0.ptemp,1:101,'b',p00.ptemp(:,iiBin)-p0.ptemp(:,iiBin),1:101,'rx-'); set(gca,'ydir','reverse'); title('Ptemp')
  figure(2); plot(p00.gas_1./p0.gas_1,1:101,'b',p00.gas_1(:,iiBin)./p0.gas_1(:,iiBin),1:101,'rx-'); set(gca,'ydir','reverse'); title('Gas1')
  figure(3); plot(p00.gas_3./p0.gas_3,1:101,'b',p00.gas_3(:,iiBin)./p0.gas_3(:,iiBin),1:101,'rx-'); set(gca,'ydir','reverse'); title('Gas3')
end

if iPlot > 0
  pause(0.1)
end

