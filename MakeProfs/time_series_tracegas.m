function p16new = time_series_tracegas(iGasID,p16,ppmvLAY,pavgLAY);

iPlot = +1;
iPlot = -1;

[head,prof] = read_glatm_adjust();
pglatm.plevs = prof.plevs(:,6);
pglatm.ptemp = prof.ptemp(:,6);
pglatm.nlevs = prof.nlevs(6);
str = ['pglatm.gas_X = prof.gas_' num2str(iGasID) '(:,6);'];
eval(str);

%% now interp onto pavgLAY
[mm,nn] = size(pavgLAY);
for ii = 1 : nn
  pglatm_LAY(:,ii) = interp1(log(pglatm.plevs),pglatm.gas_X,log(pavgLAY(:,ii)),[],'extrap');
end

p16new = p16;

fracyy = 2002 + p16.avg16_doy_since2002/365;
i800mb = find(pavgLAY(:,1) >= 800,1);
xppm   = ppmvLAY(i800mb,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% this is new July 2, 2019

i500mb = find(pavgLAY(:,1) >= 500,1);
xppm   = ppmvLAY(i500mb,:);

%% now smooth the entire profile so it looks like xppm
ppmvLAY_IN = ppmvLAY;
smoother = ones(size(ppmvLAY));
[mm,nn] = size(ppmvLAY);
for ii = 1 : nn
  %% method 1, use whatever junk came out of klayers
  thescale = ppmvLAY(:,ii);
  thescale = 1./thescale * xppm(ii);
  smoother(:,ii) = thescale;

  %% method2, use the GLATM profile
  thescale = xppm(ii)/pglatm_LAY(i500mb,ii);
  thescale = thescale * pglatm_LAY(:,ii) ./ppmvLAY(:,ii);
  smoother(:,ii) = thescale;
%  figure(1); plot(ppmvLAY(:,ii),1:mm,pglatm_LAY(:,ii),1:mm); set(gca,'ydir','reverse')
%  figure(2); plot(thescale,1:mm,'o-'); set(gca,'ydir','reverse')
%error('lka')
end

for ii = mm+1 : 101
  smoother(ii,:) = smoother(mm,:);
end

if iPlot > 0
  figure(2); pcolor(smoother); colorbar; caxis; shading interp; title('smoother');
  set(gca,'ydir','reverse')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iGasID == 2
  %% we know the nominal is 370 + (yy-2002)*2.2
  yyjunk = 2002:2030;
  co2junk = 370 + (yyjunk-2002)*2.2;
  new_timeCO2 = interp1(yyjunk,co2junk,fracyy);       %% these are the jac times
  if iPlot > 0
    figure(3); plot(yyjunk,co2junk,'b',fracyy,new_timeCO2,'ro-',fracyy,xppm,'k'); grid; title('Gas 2')
  end
  scaling = ones(101,1) * new_timeCO2./xppm;
 
elseif iGasID == 4
  n2o_esrl = load('/home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/MakeJacskCARTA_CLR/insitu_global_N2O.txt');
  ix = 25 : length(n2o_esrl)-12;
  t_esrl = n2o_esrl(ix,1) + (n2o_esrl(ix,2)-1)/12;
  y_esrl = n2o_esrl(ix,7) + 0.0001*randn(length(ix),1);
  y_esrl = y_esrl/1000;
  new_timeN2O = interp1(t_esrl,y_esrl,fracyy,[],'extrap');
  if iPlot > 0
    figure(3); plot(t_esrl,y_esrl,'b',fracyy,new_timeN2O,'ro-',fracyy,xppm,'k'); grid; title('Gas 4')
  end
  scaling = ones(101,1) * new_timeN2O./xppm;

elseif iGasID == 6
  ch4_esrl = load('/home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/MakeJacskCARTA_CLR/ch4_esrl.txt');
  new_timeCH4 = interp1(ch4_esrl(:,1),ch4_esrl(:,2)/1000,fracyy,[],'extrap');
  if iPlot > 0
    figure(3); plot(ch4_esrl(:,1),ch4_esrl(:,2)/1000,'b',fracyy,new_timeCH4,'ro-',fracyy,xppm,'k'); grid; title('Gas 6')
  end
  scaling = ones(101,1) * new_timeCH4./xppm;

elseif iGasID == 51
  cfc11_esrl = load('/home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/MakeJacskCARTA_CLR/insitu_global_F11.txt');
  ix = 25 : length(cfc11_esrl)-12;
  t_esrl = cfc11_esrl(ix,1) + (cfc11_esrl(ix,2)-1)/12;
  y_esrl = cfc11_esrl(ix,7);  %% units are ppt
  y_esrl = y_esrl/1000000;    %% convert to ppm
  new_timeCFC11 = interp1(t_esrl,y_esrl,fracyy,[],'extrap');
  if iPlot > 0
    figure(3); plot(t_esrl,y_esrl,fracyy,new_timeCFC11,'ro-',fracyy,xppm,'k'); grid; title('Gas 51')
  end
  scaling = ones(101,1) * new_timeCFC11./xppm;

elseif iGasID == 52
  cfc12_esrl = load('/home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/MakeJacskCARTA_CLR/HATS_global_F12.txt');
  ix = find(cfc12_esrl(:,1) >= 2002);
  t_esrl = cfc12_esrl(ix,1) + (cfc12_esrl(ix,2)-1)/12;
  y_esrl = cfc12_esrl(ix,3);   %% units are ppt
  y_esrl = y_esrl/1000000;     %% convert to ppm
  new_timeCFC12 = interp1(t_esrl,y_esrl,fracyy,[],'extrap');
  if iPlot > 0
    figure(3); plot(t_esrl,y_esrl,fracyy,new_timeCFC12,'ro-',fracyy,xppm,'k'); grid; title('Gas 52')
  end
  scaling = ones(101,1) * new_timeCFC12./xppm;
else
  iGasID
  error('huh need gid = 2,4,6,51,52')
end

%% scale so that things are ok
if iPlot > 0
  figure(1); 
  pcolor(fracyy,1:101,scaling); colorbar; shading flat; colormap jet; title('scaling');
  set(gca,'ydir','reverse')
  pause(1)
end

%whos scaling smoother
%smoother = ones(size(smoother));

if iGasID == 2
  p16new.gas_2 = p16new.gas_2 .* scaling .* smoother;
elseif iGasID == 4
  p16new.gas_4 = p16new.gas_4 .* scaling .* smoother;
elseif iGasID == 6
  p16new.gas_6 = p16new.gas_6 .* scaling .* smoother;
elseif iGasID == 51
  p16new.gas_51 = p16new.gas_51 .* scaling .* smoother;
elseif iGasID == 52
  p16new.gas_52 = p16new.gas_52 .* scaling .* smoother;
end
