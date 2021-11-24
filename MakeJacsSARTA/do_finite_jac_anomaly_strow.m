function [co2jac,deltaco2] = do_co2_finite_jac_anlomaly_strow(h,ptime,p0,params,sartaer,gid);

[ppmvLAY ] = layers2ppmv(h,ptime, 1:length(ptime.stemp),gid);
[ppmvLAY0] = layers2ppmv(h,p0,1:length(p0.stemp),gid);
ppmvLAY0(98:101,:) = eps; ppmvLAY(98:101,:) = eps;

plot(ppmvLAY0,1:101,'b',ppmvLAY,1:101,'r'); whos ppmvLAY

%% want to adjust CO2 so the ppmv is same as ppmvLAY0
pxtime0 = ptime;
if gid == 2
  pxtime0.gas_2 = pxtime0.gas_2 .* ppmvLAY0./ppmvLAY;
elseif gid == 4
  pxtime0.gas_4 = pxtime0.gas_4 .* ppmvLAY0./ppmvLAY;
elseif gid == 6
  pxtime0.gas_6 = pxtime0.gas_6 .* ppmvLAY0./ppmvLAY;
end

hnew = h;
hnew.ichan = (1:2834)';
hnew.nchan = 2834;

pxtime0.rcalc = zeros(2834,length(pxtime0.stemp));
pxtime0.robs1 = zeros(2834,length(pxtime0.stemp));
[ppmvLAYx0] = layers2ppmv(h,pxtime0,1:length(p0.stemp),gid);
plot(ppmvLAYx0,1:97,'b',ppmvLAY(1:97,:),1:97,'r'); whos ppmvLAY

ptime1 = ptime;
ptime1.rcalc = zeros(2834,length(ptime.stemp));
ptime1.robs1 = zeros(2834,length(ptime.stemp));
rtpwrite(params.fop,hnew,[],ptime1,[]);
eval(sartaer);
[hjunk,ha,pcalc_time,pa] = rtpread(params.frp); tcalc_time = rad2bt(hjunk.vchan,pcalc_time.rcalc);

rtpwrite(params.fop,hnew,[],pxtime0,[]);
eval(sartaer);
[hjunk,ha,pxcalc_time0,pa] = rtpread(params.frp); txcalc_time0 = rad2bt(hjunk.vchan,pxcalc_time0.rcalc);

rmer = ['!/bin/rm ' params.fop ' ' params.frp];
eval(rmer);

%plot(tcalc_time-txcalc_time0)

plevs = pxcalc_time0.plevs(:,20);
i800 = find(plevs >= 800,1);
co2_t  = ppmvLAY(i800,:);
co2_t0 = ppmvLAYx0(i800,:);
deltaCO2 = co2_t - co2_t0; deltaco2 = deltaCO2;
deltaCO2 = ones(hnew.nchan,1)*deltaCO2;

co2jac = (tcalc_time-txcalc_time0) ./ deltaCO2;
plot(co2jac);
