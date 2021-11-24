function compute_sarta_clr_jacobians_twodelta(hx,ha,px,pa,params,cfc11jac)

%% called by make_sarta_test_jacobians.m

normer = normer_clr(params);

fip = params.fip;
fop = params.fop;
frp = params.frp;
sarta = params.sarta;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iRTP = 1;
%% T(z),WV(z),O3(z),stemp,colCO2,colN20,colCH4,orig
numtimes = real(3*(px.nlevs(1)-1)+1+1+1+1+1);  

disp('checking "NO" pert ...'); [length(px.stemp)]
  rtpwrite(fop,hx,ha,px,pa)
  sartaer   = ['!time ' sarta   ' fin=' fop ' fout=' frp];  eval(sartaer)  
  [hx,hax,pxNOPERT,pax] = rtpread(frp);
txNOPERT = rad2bt(hx.vchan,pxNOPERT.rcalc);
txNOPERT = txNOPERT * ones(1,296);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

boo1 = px.plevs(1:100,:);  boo2 = px.plevs(2:101,:);
boo = (boo1-boo2) ./ log(boo1./boo2);
boo(101,:) = boo(100,:);
px.plays = boo;

trop_ind = tropopause_rtp(hx,px);
strat_ind = stratopause_rtp(hx,px);

plot(px.ptemp(1:px.nlevs-1),(1:px.nlevs-1))
axis([180 320 0 px.nlevs]); grid
line([180 320],[trop_ind  trop_ind],'color','k');
line([180 320],[strat_ind strat_ind],'color','r');
set(gca,'ydir','reverse')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% do the + perturbation
[hx,pxn] = replicate_rtp_headprof(hx,px,iRTP,numtimes);
jj=0;
for ii = 1 : px.nlevs-1
  jj = jj+1;
  pxn.ptemp(ii,ii) = pxn.ptemp(ii,ii) + normer.dT;
end
jj=jj+1; jST = jj; pxn.stemp(jj) = pxn.stemp(jj) + normer.dT;      
for ii = 1 : px.nlevs-1
  jj = jj+1;
  pxn.gas_1(ii,jj) = pxn.gas_1(ii,jj)*(1+normer.dQ);
end
for ii = 1 : px.nlevs-1
  jj = jj+1;
  pxn.gas_3(ii,jj) = pxn.gas_3(ii,jj)*(1+normer.dQ);
end
jj=jj+1; j2  = jj; pxn.gas_2(:,jj) = pxn.gas_2(:,jj) *(1+normer.dQ);
jj=jj+1; j4  = jj; pxn.gas_4(:,jj) = pxn.gas_4(:,jj) *(1+normer.dQ);
jj=jj+1; j6  = jj; pxn.gas_6(:,jj) = pxn.gas_6(:,jj) *(1+normer.dQ);
jj=jj+1;     %% no pert

disp('checking sizes for "+" pert ...'); [length(pxn.stemp) jj]
  rtpwrite(fop,hx,ha,pxn,pa)
  sartaer   = ['!time ' sarta   ' fin=' fop ' fout=' frp];  eval(sartaer)  
  [hx,hax,px2p,pax] = rtpread(frp);
tx2p = rad2bt(hx.vchan,px2p.rcalc);

%%%%%%%%%%%%%%%%%%%%%%%%%

%% do the - perturbation
[hx,pxn] = replicate_rtp_headprof(hx,px,iRTP,numtimes);
jj=0;
for ii = 1 : px.nlevs-1
  jj = jj+1;
  pxn.ptemp(ii,ii) =   pxn.ptemp(ii,ii) - normer.dT;
end
jj=jj+1; jST = jj; pxn.stemp(jj) = pxn.stemp(jj) - normer.dT;      
for ii = 1 : px.nlevs-1
  jj = jj+1;
  pxn.gas_1(ii,jj) = pxn.gas_1(ii,jj)*(1-normer.dQ);
end
for ii = 1 : px.nlevs-1
  jj = jj+1;
  pxn.gas_3(ii,jj) = pxn.gas_3(ii,jj)*(1-normer.dQ);
end
jj=jj+1; j2  = jj; pxn.gas_2(:,jj) = pxn.gas_2(:,jj) *(1-normer.dQ);
jj=jj+1; j4  = jj; pxn.gas_4(:,jj) = pxn.gas_4(:,jj) *(1-normer.dQ);
jj=jj+1; j6  = jj; pxn.gas_6(:,jj) = pxn.gas_6(:,jj) *(1-normer.dQ);
jj=jj+1;     %% no pert

disp('checking sizes for "-" pert ...'); [length(pxn.stemp) jj]
  rtpwrite(fop,hx,ha,pxn,pa)
  sartaer   = ['!time ' sarta   ' fin=' fop ' fout=' frp];  eval(sartaer)  
  [hx,hax,px2m,pax] = rtpread(frp);
tx2m = rad2bt(hx.vchan,px2m.rcalc);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t0 = tx2m(:,length(px2p.stemp));   %% unpert

ij = 1:pxn.nlevs(1)-1; 
  jacT  = (tx2p(:,ij) - tx2m(:,ij)); jj = pxn.nlevs(1)-1;
  jacPlusSideT = tx2p(:,ij)-txNOPERT(:,ij);
  jacMinusSideT = txNOPERT(:,ij)-tx2m(:,ij);

jj = jj+1; jacST = (tx2p(:,jj) - tx2m(:,jj));

ij = 1:pxn.nlevs(1)-1;
ij = ij + (1+(pxn.nlevs(1)-1)); %% offset by ST + T(z) jacs 
  jacWV  = (tx2p(:,ij) - tx2m(:,ij));  
  jacPlusSideWV = tx2p(:,ij)-txNOPERT(:,ij);
  jacMinusSideWV = txNOPERT(:,ij)-tx2m(:,ij);

ij = 1:pxn.nlevs(1)-1;
ij = ij + (1+(pxn.nlevs(1)-1)); %% offset by ST + T(z) jacs 
ij = ij +    (pxn.nlevs(1)-1);  %% offset by WV(z)     jacs 
  jacO3  = (tx2p(:,ij) - tx2m(:,ij));  
  jacPlusSideO3 = tx2p(:,ij)-txNOPERT(:,ij);
  jacMinusSideO3 = txNOPERT(:,ij)-tx2m(:,ij);

jj = pxn.nlevs(1)-1 + 1 + pxn.nlevs(1)-1 + pxn.nlevs(1)-1;
jj = jj+1; jacCO2   = (tx2p(:,jj) - tx2m(:,jj));   % this is for 0.1 frac change
jj = jj+1; jacN2O   = (tx2p(:,jj) - tx2m(:,jj));   % this is for 0.1 frac change
jj = jj+1; jacCH4   = (tx2p(:,jj) - tx2m(:,jj));   % this is for 0.1 frac change

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

normer

[dqWV,WVjacindex,jjwv] = do_hand_N_wv_jacs_one_or_two_delta(params,normer,px,jacWV,2);
[dqT,Tjacindex,jjT]    = do_hand_N_T_jacs_one_or_two_delta(params,normer,px,jacT,2);
[dqO3,O3jacindex,jjO3] = do_hand_N_o3_jacs_one_or_two_delta(params,normer,px,jacO3,2);

rmer = ['!/bin/rm ' fip ' ' fop ' ' frp]; eval(rmer);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dq_CO2_nominal = (tx2p(:,j2) - tx2m(:,j2))*(2.2/370) /(2*normer.dQ);  %% for 2.2/370 frac change
dq_N2O_nominal = (tx2p(:,j4) - tx2m(:,j4))*(1/300) /(2*normer.dQ);    %% for 1/300   frac change
dq_CH4_nominal = (tx2p(:,j6) - tx2m(:,j6))*(5/1860) /(2*normer.dQ);   %% for 5/1860  frac change
dq_CFC_nominal = cfc11jac*(1/1300);                            %% for 1/1300  frac change

[mmmm,nnnn] = size(dq_CFC_nominal);
if mmmm == 1
  dq_CFC_nominal = dq_CFC_nominal';
end

dST_nominal = jacST*0.1/(2*normer.dT);

aM_TS_jac = [];

%% trace gases and stemp
aM_TS_jac = [dq_CO2_nominal dq_N2O_nominal dq_CH4_nominal dq_CFC_nominal dST_nominal];

%% wv
for ij = 1 : jjwv
  str = ['dada = dqWV.dq_WV_' num2str(ij) '_nominal;']; eval(str);
  aM_TS_jac = [aM_TS_jac dada'];
end

%% t
for ij = 1 : jjT
  str = ['dada = dqT.dq_T_' num2str(ij) '_nominal;']; eval(str);
  aM_TS_jac = [aM_TS_jac dada'];
end

%% ozone
jjo3 = jjT;
for ij = 1 : jjo3
  str = ['dada = dqO3.dq_O3_' num2str(ij) '_nominal;']; eval(str);
  aM_TS_jac = [aM_TS_jac dada'];
end

iPlot = +1;
if iPlot > 0
  g = 1:2378;
  g = 1:2834;
  f = hx.vchan;
  g = 1 : length(hx.vchan);
  f = hx.vchan;

  figure(1); clf
  plot(f(g),dq_CO2_nominal(g),(g),dq_N2O_nominal(g),...
       f(g),dq_CH4_nominal(g),f(g),dq_CFC_nominal(g),f(g),jacST(g)*0.1/(2*normer.dT),'.-')
  hl = legend('CO2','N2O','CH4','CFC','ST','location','northeast');
  set(hl,'Fontsize',10); grid

  figure(1); clf
  plot(f(g),dq_CO2_nominal(g),f(g),dq_N2O_nominal(g),...
       f(g),dq_CH4_nominal(g),f(g),dq_CFC_nominal(g))
  hl = legend('CO2','N2O','CH4','CFC','location','northeast');
  set(hl,'Fontsize',10); grid

  hold on
  plot(f(g),dqO3.dq_O3_1_nominal(g)+dqO3.dq_O3_2_nominal(g)+dqO3.dq_O3_3_nominal(g)+dqO3.dq_O3_4_nominal(g),'k');
end

outname = [params.savedir '/xprofile' num2str(params.iiBin) '.mat'];
eval(['load ' outname]);  %% already saved in make_sarta_test_jacobians.m
eval(['save ' outname  ' params aM_TS_jac t0 hx px normer sarta']);   %% normer and sarta are new to be saved, Aug 12 2019
fprintf(1,'saved aM_TS_jac for latbin %3i to %s \n',params.iiBin,outname);
