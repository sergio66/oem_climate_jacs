%% see ../MakeJacsSARTA/normer_clr.m
%{
function normer = normer_clr(params)

normer.dQ = 0.01;
normer.dT = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% *********** these are the normalizations we started with ************

normer.normCO2 = 2.2/370;   %% ppm/yr out of 370
normer.normO3  = 0.01;      %% frac/yr
normer.normN2O = 1.0/300;   %% ppb/yr outof 300
normer.normCH4 = 5/1860;    %% ppb/yr out of 1800
normer.normCFC = 1/1300;    %% ppt/yr out of 1300
normer.normST  = 0.1;       %% K/yr

normer.normCNG = 0.001; %% frac/yr = 0.1 g/m2 per year, avg = 100 g/m2
normer.normCSZ = 0.001; %% frac/yr = 0.1 um   per year, avg = 100 um
normer.normCPR = 0.001; %% mb/yr   = 1.0 mb   per year, avg = 500 mb

normer.normWV  = 0.01;  %% frac/yr
normer.normT   = 0.01;  %% K/yr
%}

%mapp = load('map2645to2378.mat');
%domap = mapp.closest2645to2378_ind;
%domap = 1:2378;

load sarta_chans_for_l1c.mat
domap = ichan;

sarta = load('../MakeJacsSARTA/SARTA_AIRSL1c_Oct2018/sarta_fixCFC_M_TS_jac_all_5_6_97_97_97_cld.mat')

lstrow = load('sarta_chans_for_l1c.mat');

snorm = zeros(2645,11);
snorm(:,1) = 2.2/370;
snorm(:,2) = 1.0/300;
snorm(:,3) = 5.0/1860;
snorm(:,4) = 1.0/1300;
snorm(:,5) = 0.1;

%% snorm(:,6:11) = 0.001;  %% in reality
%% snorm(:,6:11) = 1.000;  %% but we are going to just read in the jacs from SARTA which already have the norm

fairs = instr_chans;

for ii = 1 : 40
  thename = ['JUNK/jac_results_' num2str(ii) '.mat'];
  a = load(thename);
  %plot(a.fKc,a.stemp); title('kcarta stemp'); disp('ret'); pause 

  a.tracegas = a.tracegas(domap,:);
  a.stemp    = a.stemp(domap);
  a.water    = a.water(domap,:);
  a.tempr    = a.tempr(domap,:);
  a.ozone    = a.ozone(domap,:);

  a.tracegas(:,5)    = a.stemp;
  a.tracegas(:,6:11) = squeeze(sarta.M_TS_jac_all(ii,:,6:11));
  clear boo
   
  boo(:,1:11) = a.tracegas  .* snorm;
  boo(:,12:108)  = fliplr(a.water) * 0.01;
  boo(:,109:205) = fliplr(a.tempr) * 0.01;
  boo(:,206:302) = fliplr(a.ozone) * 0.01;

  %boo = boo(lstrow.ichan,:);
  
  alljac(ii,:,:) = boo;
end

fKc = a.fKc(domap);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1); clf
for ii = 1 : 5
  figure(1); plot(fKc,squeeze(alljac(20,:,ii)),'b.',sarta.f,squeeze(sarta.M_TS_jac_all(20,:,ii)),'r');
  legend('kcarta','sarta','location','best')
  title(num2str(ii))
  disp('ret'); pause
end
ii = 012:108; plot(fKc,sum(squeeze(alljac(20,:,ii))'),'b.',sarta.f,sum(squeeze(sarta.M_TS_jac_all(20,:,ii))'),'r'); title('sum W')
  disp('ret'); pause
ii = 109:205; plot(fKc,sum(squeeze(alljac(20,:,ii))'),'b.',sarta.f,sum(squeeze(sarta.M_TS_jac_all(20,:,ii))'),'r'); title('sum T')
  disp('ret'); pause
ii = 206:302; plot(fKc,sum(squeeze(alljac(20,:,ii))'),'b.',sarta.f,sum(squeeze(sarta.M_TS_jac_all(20,:,ii))'),'r'); title('sum O')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
kcjac.f = fKc;
kcjac.M_TS_jac_all = alljac;
kcjac.qrenorm = sarta.qrenorm;
kcjac.str1 = sarta.str1;
kcjac.str2 = sarta.str2;
save('JUNK/kcarta_M_TS_jac_all_5_6_97_97_97_2645_cld.mat','-struct','kcjac');
