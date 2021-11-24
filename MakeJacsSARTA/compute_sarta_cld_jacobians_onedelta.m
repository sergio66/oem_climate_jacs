function compute_sarta_cld_jacobians_onedelta(hx,ha,px,pa,params,cfc11jac)

%% called by make_sarta_test_jacobians.m

normer = normer_cld(params);

fip = params.fip;
fop = params.fop;
frp = params.frp;
sarta = params.sarta;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iRTP = 1;   
%% [T(z),WV(z),O3(z)],[colCO2,colN20,colCH4,stemp],2*[csize camnt cprtop],orig    %% add in CFC at the end
numtimes = 3*(px.nlevs(1)-1)+(1+1+1+1)+6+1;  

%%%%%%%%%%%%%%%%%%%%%%%%%

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

addpath /home/sergio/MATLABCODE
trop = tropopause_rtp(hx,pxn);
trop = trop(1);

%jj=jj+1; j2T  = jj; pxn.gas_2(trop:101,jj) = pxn.gas_2(trop:101,jj) *(1+normer.dQ);
%jj=jj+1; j2S  = jj; pxn.gas_2(1:trop-1,jj) = pxn.gas_2(1:trop-1,jj) *(1+normer.dQ);
jj=jj+1; j2  = jj; pxn.gas_2(:,jj) = pxn.gas_2(:,jj) *(1+normer.dQ);
jj=jj+1; j4  = jj; pxn.gas_4(:,jj) = pxn.gas_4(:,jj) *(1+normer.dQ);
jj=jj+1; j6  = jj; pxn.gas_6(:,jj) = pxn.gas_6(:,jj) *(1+normer.dQ);

jj=jj+1; jCNG1 =jj; pxn.cngwat(jj)  = pxn.cngwat(jj)  *(1+normer.dQ); 
jj=jj+1; jCNG2 =jj; pxn.cngwat2(jj) = pxn.cngwat2(jj) *(1+normer.dQ); 
jj=jj+1; jCSZ1 =jj; pxn.cpsize(jj)  = pxn.cpsize(jj)  *(1+normer.dQ); 
jj=jj+1; jCSZ2 =jj; pxn.cpsize2(jj) = pxn.cpsize2(jj) *(1+normer.dQ); 
jj=jj+1; jCPR1 =jj; pxn.cprtop(jj)  = pxn.cprtop(jj)  *(1+normer.dQ); 
jj=jj+1; jCPR2 =jj; pxn.cprtop2(jj) = pxn.cprtop2(jj) *(1+normer.dQ); 

jj=jj+1;    %% no pert

disp('checking sizes for "+" pert ...'); [length(pxn.stemp) jj]
  pxn = fix_clouds_as_needed(pxn);
  rtpwrite(fop,hx,ha,pxn,pa)
  sartaer   = ['!time ' sarta   ' fin=' fop ' fout=' frp];  eval(sartaer)  
  [hx,hax,px2p,pax] = rtpread(frp);
tx2p = rad2bt(hx.vchan,px2p.rcalc);

t0 = tx2p(:,length(px2p.stemp));   %% unpert

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ij = 1:pxn.nlevs(1)-1; 
  jacT  = (tx2p(:,ij) - t0); jj = pxn.nlevs(1)-1;
jj = jj+1; jacST = (tx2p(:,jj) - t0);

ij = (1:pxn.nlevs(1)-1)+1+(pxn.nlevs(1)-1); %% offset by ST + T(z) jacs 
  jacWV  = (tx2p(:,ij) - t0);  

ij = 1:pxn.nlevs(1)-1;
ij = ij + (1+(pxn.nlevs(1)-1)); %% offset by ST + T(z) jacs 
ij = ij +    (pxn.nlevs(1)-1);  %% offset by WV(z)     jacs 
  jacO3  = (tx2p(:,ij) - t0);  

jj = pxn.nlevs(1)-1 + 1 + pxn.nlevs(1)-1 + pxn.nlevs(1)-1;
%jj = jj+1; jacCO2T   = (tx2p(:,jj) - t0);
%jj = jj+1; jacCO2S   = (tx2p(:,jj) - t0);
jj = jj+1; jacCO2   = (tx2p(:,jj) - t0);
jj = jj+1; jacN2O   = (tx2p(:,jj) - t0);
jj = jj+1; jacCH4   = (tx2p(:,jj) - t0);

jj = jj+1; jacCNG1  = (tx2p(:,jj) - t0);
jj = jj+1; jacCNG2  = (tx2p(:,jj) - t0);
jj = jj+1; jacCSZ1  = (tx2p(:,jj) - t0);
jj = jj+1; jacCSZ2  = (tx2p(:,jj) - t0);
jj = jj+1; jacCPR1  = (tx2p(:,jj) - t0);
jj = jj+1; jacCPR2  = (tx2p(:,jj) - t0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

normer

[dqWV,WVjacindex,jjwv] = do_hand_N_wv_jacs_one_or_two_delta(params,normer,px,jacWV,1);
[dqT,Tjacindex,jjT]    = do_hand_N_T_jacs_one_or_two_delta(params,normer,px,jacT,1);
[dqO3,O3jacindex,jjO3] = do_hand_N_o3_jacs_one_or_two_delta(params,normer,px,jacO3,1);

rmer = ['!/bin/rm ' fip ' ' fop ' ' frp]; eval(rmer);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%dq_CO2T_nominal = (tx2p(:,j2T) - tx2m(:,j2T))*(2.2/370) /(log(1+normer.dQ));  %% for 2.2/370 frac change
%dq_CO2S_nominal = (tx2p(:,j2S) - tx2m(:,j2S))*(2.2/370) /(log(1+normer.dQ));  %% for 2.2/370 frac change
dq_CO2_nominal = (tx2p(:,j2) - t0)*(2.2/370) /(log(1+normer.dQ));  %% for 2.2/370 frac change
dq_N2O_nominal = (tx2p(:,j4) - t0)*(1/300) /(log(1+normer.dQ));    %% for 1/300   frac change
dq_CH4_nominal = (tx2p(:,j6) - t0)*(5/1860) /(log(1+normer.dQ));   %% for 5/1860  frac change
dq_CFC_nominal = cfc11jac*(1/1300);                            %% for 1/1300  frac change   %% from initialize_hand_jacs.m

%dq_CO2T_nominal = (tx2p(:,j2T) - tx2m(:,j2T))*normer.normCO2 /(log(1+normer.dQ));
%dq_CO2S_nominal = (tx2p(:,j2S) - tx2m(:,j2S))*normer.normCO2 /(log(1+normer.dQ));
dq_CO2_nominal = (tx2p(:,j2) - t0)*normer.normCO2 /(log(1+normer.dQ));
dq_N2O_nominal = (tx2p(:,j4) - t0)*normer.normN2O /(log(1+normer.dQ));
dq_CH4_nominal = (tx2p(:,j6) - t0)*normer.normCH4 /(log(1+normer.dQ));
dq_CFC_nominal = cfc11jac*normer.normCFC /1300;                           

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% >>>>>>> note [B(Q(1+d))-B(Q)]/[Q(1+d)-Q] = [B(Q(1+d))-B(Q)]/[Qd]
%% >>>>>>> note [B(Q(1+d))-B(Q)]/[ln(Q(1+d))-ln(Q)] = [B(Q(1+d))-B(Q)]/[ln((1+d)] 
%% so everywhere I had 2normer.dQ in jac denominator, I have replaced with ln(1+d) including WV and O3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dq_CNG1_nominal  = (tx2p(:,jCNG1) - t0)*0.001/(log(1+normer.dQ));     %% for 0.01    frac change
dq_CNG2_nominal  = (tx2p(:,jCNG2) - t0)*0.001/(log(1+normer.dQ));     %% for 0.01    frac change
dq_CSZ1_nominal  = (tx2p(:,jCSZ1) - t0)*0.001/(log(1+normer.dQ));     %% for 0.01    frac change
dq_CSZ2_nominal  = (tx2p(:,jCSZ2) - t0)*0.001/(log(1+normer.dQ));     %% for 0.01    frac change
dq_CPR1_nominal  = (tx2p(:,jCPR1) - t0)*0.001/(log(1+normer.dQ));     %% for 0.01    frac change
dq_CPR2_nominal  = (tx2p(:,jCPR2) - t0)*0.001/(log(1+normer.dQ));     %% for 0.01    frac change

dq_CNG1_nominal  = (tx2p(:,jCNG1) - t0)*normer.normCNG/(log(1+normer.dQ));
dq_CNG2_nominal  = (tx2p(:,jCNG2) - t0)*normer.normCNG/(log(1+normer.dQ));
dq_CSZ1_nominal  = (tx2p(:,jCSZ1) - t0)*normer.normCSZ/(log(1+normer.dQ));
dq_CSZ2_nominal  = (tx2p(:,jCSZ2) - t0)*normer.normCSZ/(log(1+normer.dQ));
dq_CPR1_nominal  = (tx2p(:,jCPR1) - t0)*normer.normCPR/(log(1+normer.dQ));
dq_CPR2_nominal  = (tx2p(:,jCPR2) - t0)*normer.normCPR/(log(1+normer.dQ));

aM_TS_jac = [];

%% trace gases and stemp
%aM_TS_jac = [dq_CO2T_nominal dq_CO2S_nominal dq_N2O_nominal dq_CH4_nominal dq_CFC_nominal];
aM_TS_jac = [dq_CO2_nominal dq_N2O_nominal dq_CH4_nominal dq_CFC_nominal dq_CFC_nominal];   %%% this is pretty silly, repeat CFC11 and CFC12 for the heck of it
aM_TS_jac = [aM_TS_jac jacST*normer.normST/(1*normer.dT)];
aM_TS_jac = [aM_TS_jac dq_CNG1_nominal dq_CNG2_nominal dq_CSZ1_nominal dq_CSZ2_nominal dq_CPR1_nominal dq_CPR2_nominal];

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
for ij = 1 : jjO3
  str = ['dada = dqO3.dq_O3_' num2str(ij) '_nominal;']; eval(str);
  aM_TS_jac = [aM_TS_jac dada'];
end

iPlot = +1;
if iPlot > 0
  g = 1:2378;
  g = 1:2834;
  g = hx.ichan;
  g = 1 : length(hx.vchan);
  f = hx.vchan;

  figure(1); clf
  %plot(f(g),dq_CO2T_nominal(g),f(g),dq_CO2S_nominal(g),f(g),dq_N2O_nominal(g),...
  %     f(g),dq_CH4_nominal(g),f(g),dq_CFC_nominal(g),f(g),jacST(g)*0.1/(1*normer.dT),'.-')
  %hl = legend('CO2T','CO2S','N2O','CH4','CFC','ST','location','northeast');
  %set(hl,'Fontsize',10); grid

  figure(1); clf
  plot(f(g),dq_CO2_nominal(g),f(g),dq_N2O_nominal(g),...
       f(g),dq_CH4_nominal(g),f(g),dq_CFC_nominal(g))
  hl = legend('CO2','N2O','CH4','CFC','location','northeast');
  set(hl,'Fontsize',10); grid

  figure(2); clf
  plot(f(g),dq_CNG1_nominal(g),f(g),dq_CNG2_nominal(g),f(g),dq_CSZ1_nominal(g),f(g),dq_CSZ2_nominal(g),f(g),dq_CPR1_nominal(g),f(g),dq_CPR2_nominal(g))
  hl = legend('CNG1','CNG2','CSZ1','CSZ2','CPR1','CPR2','location','northeast');
  set(hl,'Fontsize',10); grid
end

%fprintf(1,'ctype = %3i  ctype2 = %3i \n',px.ctype,px.ctype2);
%figure(4);
%plot(f(g),t0(g));

outname = [params.savedir '/xprofile' num2str(params.iiBin) '.mat'];
eval(['load ' outname]);  %% already saved in make_sarta_test_jacobians.m
eval(['save ' outname  ' params aM_TS_jac t0 hx px']);
fprintf(1,'saved aM_TS_jac for latbin %3i to %s \n',params.iiBin,outname);
