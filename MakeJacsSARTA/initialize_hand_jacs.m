function [hx,ha,px,pa,cfc11jac] = initialize_hand_jacs(fINPUT_rtp,iiBin,sarta,klayers,fip,fop,frp,iInstr)

fprintf(1,'latbin %3i \n',iiBin);
[h,ha,p,pa] = rtpread(fINPUT_rtp);
[h,p] = subset_rtp(h,p,[],[],iiBin);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% do checks of profiles at nlevs
airslevs = flipud(load('/home/sergio/MATLABCODE/airslevels.dat'));
nlevs = p.nlevs;
for ii = 1  : h.ngas
  str = ['boo = p.gas_' num2str(h.glist(ii)) ';'];
  eval(str);
  if isnan(boo(nlevs)) | isinf(boo(nlevs))
    fprintf(1,'oopsy gas %2i has nan or inf at nlevs = %2i ... resetting \n',ii,nlevs);
    boo(nlevs) = boo(nlevs-1);
    str = ['p.gas_' num2str(h.glist(ii)) ' = boo;'];
    eval(str);
  end
end
boo = p.ptemp;
if isnan(boo(nlevs)) | isinf(boo(nlevs))
  fprintf(1,'oopsy ptemp has nan or inf at nlevs = %2i ... resetting \n',nlevs);
  boo(nlevs) = boo(nlevs-1);
  p.ptemp = boo;
end
boo = p.plevs;
if isnan(boo(nlevs)) | isinf(boo(nlevs))
  fprintf(1,'oopsy plevs has nan or inf at nlevs = %2i ... resetting \n',nlevs);
  boo(nlevs) = airslevs(nlevs);
  p.plevs = boo;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% do checks of profiles at nlevs-1
airslevs = flipud(load('/home/sergio/MATLABCODE/airslevels.dat'));
nlevs = p.nlevs;
for ii = 1  : h.ngas
  str = ['boo = p.gas_' num2str(h.glist(ii)) ';'];
  eval(str);
  if isnan(boo(nlevs-1)) | isinf(boo(nlevs-1))
    fprintf(1,'oopsy gas %2i has nan or inf at nlevs-1 = %2i ... resetting \n',ii,nlevs-1);
    boo(nlevs-1) = 0.5*(boo(nlevs)+boo(nlevs-2));
    str = ['p.gas_' num2str(h.glist(ii)) ' = boo;'];
    eval(str);
  end
end
boo = p.ptemp;
if isnan(boo(nlevs-1)) | isinf(boo(nlevs-1))
  fprintf(1,'oopsy ptemp has nan or inf at nlevs = %2i ... resetting \n',nlevs-1);
  boo(nlevs-1) = 0.5*(boo(nlevs)+boo(nlevs-2));
  p.ptemp = boo;
end
%boo = p.plevs;
%if isnan(boo(nlevs)) | isinf(boo(nlevs))
%  fprintf(1,'oopsy plevs has nan or inf at nlevs = %2i ... resetting \n',nlevs);
%  boo(nlevs) = airslevs(nlevs);
%  p.plevs = boo;
%end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iInstr == -1 | iInstr == +1
  h.nchan = 2378;
  h.ichan = (1:2378)';

  h.nchan = 2834;
  h.ichan = (1:2834)';

  if isfield(h,'vchan')
    h = rmfield(h,'vchan');
  end
  if isfield(p,'rcalc')
    p = rmfield(p,'rcalc');
  end
elseif iInstr == +2
  h.nchan = 1329;
  h.ichan = (1:1329)';
  
  h.nchan = 1305;
  h.ichan = (1:1305)';

  %% steve sarta clear
  h.nchan = 1317;
  h.ichan = (1:1317)';

  if isfield(h,'vchan')
    h = rmfield(h,'vchan');
  end
  if isfield(p,'rcalc')
    p = rmfield(p,'rcalc');
  end
elseif abs(iInstr) == 3
  if iInstr == -3
    iRTP = 1;
  elseif iInstr == +3
    iRTP = 2;
  end
  if iRTP == 1
    disp('--> ::: IASI rtp1')
    %% RTP1
    h.nchan = 4231;
    h.ichan = (1:4231)';
  elseif iRTP == 2
    disp('---> ::: IASI rtp2')    
    %% RTP2
    h.nchan = 4230;
    h.ichan = (4232:8461)';
  end
  if isfield(h,'vchan')
    h = rmfield(h,'vchan');
  end
  if isfield(p,'rcalc')
    p = rmfield(p,'rcalc');
  end
else
  error('oopsy ::: ???')
end

if h.ptype == 0
  rtpwrite(fip,h,ha,p,pa)
  klayerser = ['!' klayers ' fin=' fip ' fout=' fop]
  eval(klayerser)
  [hx,ha,px,pa] = rtpread(fop);
elseif h.ptype == 1
  hx = h;
  px = p;
end

clear h p

nn = px.nlevs;
px.plays = zeros(size(px.plevs));
px.plays(1:nn-1) = px.plevs(1:nn-1)-px.plevs(2:nn);
donk = log(px.plevs(1:nn-1)./px.plevs(2:nn)); px.plays(1:nn-1) = px.plays(1:nn-1)./donk;
[index_strat] = stratopause_rtp(hx,px);
[index_trop]  = tropopause_rtp(hx,px);

rtpwrite(fop,hx,ha,px,pa)
sartaer   = ['!' sarta   ' fin=' fop ' fout=' frp];  eval(sartaer)  
[hx,hax,px,pax] = rtpread(frp);
plot(hx.vchan,rad2bt(hx.vchan,px.rcalc)); title('BT0')
pause(0.1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('/home/sergio/MATLABCODE/RATES/KCARTA_COLJACS/cfc11jac_afgl.mat')
  disp('loading /home/sergio/MATLABCODE/RATES/KCARTA_COLJACS/cfc11jac_afgl.mat')
  load /home/sergio/MATLABCODE/RATES/KCARTA_COLJACS/cfc11jac_afgl.mat
  aaffggll = 6; %% default to US Std 
  cfc11jac = cfc11jac(:,aaffggll)/0.1;   %% fixed 1/21/10
else
  disp('ooops no column jac CFC set available ... umm improvising')
  cfcx = load('/asl/s1/sergio/AIRSPRODUCTS_JACOBIANS/STD/g51_jac.mat');
  cfc11jac = sum(cfcx.jout');
  plot(cfcx.fout,cfc11jac);
end

cfc11jac0 = cfc11jac;
cfc11jac = interp1(cfcx.fout,cfc11jac0,hx.vchan);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
