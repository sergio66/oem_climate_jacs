addpath /umbc/rs/pi_sergio/WorkDirDec2025/matlabcode/
addpath /umbc/rs/pi_sergio/WorkDirDec2025/matlabcode/matlibSergio/matlib/rtp_prod2_Aug11_2020/util/
%% addpath /umbc/rs/pi_sergio/WorkDirDec2025/matlabcode/matlibSergio/matlib/rtp_prod2_Aug11_2020/h4tools

%% see Improve_SARTA_vs_KCARTA_Jacs/clust_put_together_sarta_kcartajacs.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

freq0 = instr_chans2645;
T_00     = zeros(nSamples, nLevels);
Q_00     = zeros(nSamples, nLevels);
O3_00    = zeros(nSamples, nLevels);
CO2_00   = zeros(nSamples, nLevels);
CH4_00   = zeros(nSamples, nLevels);
N2O_00   = zeros(nSamples, nLevels);

surfTemp_00        = zeros(nSamples,1);
surfPressure_00    = zeros(nSamples,1);   % hPa; varies with terrain
viewAngleSecant_00 = zeros(nSamples,1);

wavenumbers      = linspace(650, 1200, nChannels0);
radianceRaw_00   = zeros(nSamples, nChannels0);
emissivityRaw_00 = zeros(nSamples, nChannels0);
%btRaw_00        = planckBT(radianceRaw, wavenumbers);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fop = '../../Improve_SARTA_vs_KCARTA_Jacs/combined_rp_raw_with_emiss_random_CO2_scanang.rtp';
[h,ha,p,pa] = rtpread(fop);
%% fip = '/umbc/rs/pi_sergio/WorkDirDec2025/matlabcode/REGR_PROFILES_SARTA/REGR49_PROFILES_for_kCARTA_breakouts_for_SARTA/Combine_ECM100000_TIGR_SeeBor_ECM83_Regr49/OLD_BadEmiss/combined_ip_raw_with_emiss_random_CO2_scanang.rtp';
fip = '/umbc/rs/pi_sergio/WorkDirDec2025/matlabcode/REGR_PROFILES_SARTA/REGR49_PROFILES_for_kCARTA_breakouts_for_SARTA/Combine_ECM100000_TIGR_SeeBor_ECM83_Regr49/combined_ip_raw_with_emiss_random_CO2_scanang.rtp';
[hx,hax,px,pax] = rtpread(fip);

wspeed_00             = p.wspeed';
surfTemp_00           = p.stemp';
surfPressure_00       = p.spres';
viewAngleSecant_00    = abs(p.scanang');
  viewAngleSecant_00  = 1./cos(viewAngleSecant_00*pi/180);
localAngleSecant_00   = abs(p.satzen');
  localAngleSecant_00 = 1./cos(localAngleSecant_00*pi/180);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('putting emissivity on common vchan grid')
freq = instr_chans2645';
emissivityRaw_00 = zeros(length(px.stemp),2645);
for ii = 1 : length(px.stemp)
  if mod(ii,10000) == 0
    fprintf(1,'X')
  elseif mod(ii,1000) == 0
    fprintf(1,'M')
  elseif mod(ii,100) == 0
    fprintf(1,'.')
  end
  nemis = px.nemis(ii);
  efreq = px.efreq(1:nemis,ii);
  emis  = px.emis(1:nemis,ii);  
  boo = interp1(efreq,emis,freq,'linear','extrap');
  boo(boo > 1) = 1;
  boo(boo < 0) = 0;
  emissivityRaw_00(ii,:) = boo;
end  
fprintf(1,'\n')

figure(1); clf; scatter(p.stemp,p.wspeed,10,emissivityRaw_00(:,1520),'filled'); colorbar; colormap jet
  xlabel('SKT'); ylabel('WSPD'); title('1231 emis');

ocean = find(px.landfrac == 0); whos ocean
land = find(px.landfrac == 1); whos land
figure(2);
plot(nanmean(px.efreq(:,ocean),2),nanmean(px.emis(:,ocean),2),nanmean(px.efreq(:,land),2),nanmean(px.emis(:,land),2)); title('Whoa what wrong with ocean??? yay fixed!!')
  xlabel('Wavenumber cm-1'); ylabel('Emiss')
boo = nanmean(px.efreq(:,ocean),2); booO = find(boo >= 1230,1);
boo = nanmean(px.efreq(:,land),2);  booL = find(boo >= 1230,1);
figure(3);
  plot(ocean,px.emis(booO,ocean),land,px.emis(booL,land))
  title('RTP Emiss at 1231 cm-1 (b) Ocean (r) land')
  xlabel('Wavenumber cm-1'); ylabel('Emiss')  
figure(4); plot(freq0,nanmean(emissivityRaw_00(ocean,:),1),'b',freq0,nanmean(emissivityRaw_00(land,:),1),'r')
  title('RTP (b) Ocean (r) land')
  xlabel('Wavenumber cm-1'); ylabel('Emiss')
pause(0.1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

p.plays = plevs2plays(p.plevs);
boo = find(p.spres == 1100);

% xT   = p.ptemp;
% xQ   = p.gas_1;
% xCO2 = p.gas_2;
% xO3  = p.gas_3;
% xN2O = p.gas_4;
% xCO  = p.gas_5;
% xCH4 = p.gas_6;

usstd_rad = load('us_std_rad_sarta.mat');
usstd_pf  = usstd_rad.pf;
usstd_rad = usstd_rad.pf.rcalc;

plot(usstd_pf.ptemp - p.ptemp(:,length(p.stemp)),1:101); set(gca,'ydir','reverse');
plot(usstd_pf.gas_1 ./ p.gas_1(:,length(p.stemp)),1:101); set(gca,'ydir','reverse');
plot(usstd_pf.gas_2 ./ p.gas_2(:,length(p.stemp)),1:101); set(gca,'ydir','reverse');
plot(usstd_pf.gas_3 ./ p.gas_3(:,length(p.stemp)),1:101); set(gca,'ydir','reverse');

disp('putting T,Q1,Q2,Q3,Q4,Q5,Q6  onto 100 layer grids with zeros below nlays')
for ii = 1 : length(p.stemp)
  if mod(ii,10000) == 0
    fprintf(1,'X')
  elseif mod(ii,1000) == 0
    fprintf(1,'M')
  elseif mod(ii,100) == 0
    fprintf(1,'.')
  end

  nlays = p.nlevs(ii)-1;
  plays = p.plays(1:nlays,ii);
  plevs = p.plevs(1:nlays+1,ii);  

  xfrac(ii)  = (plevs(nlays) - p.spres(ii))/(plevs(nlays)-plevs(nlays+1));
  xplays(ii) = (plevs(nlays)-p.spres(ii))/log(plevs(nlays)/p.spres(ii));
  plays(end) = xplays(ii);

  p_end = p.spres(ii);
  p_end = plays(end);
  p_end = max(plays);  

  y = p.ptemp(1:nlays,ii);
  yf = usstd_pf.ptemp(1:nlays);  
  y(end) = interp1(log(plays),y,log(xplays(ii)),[],'extrap');
  T_00(ii,1:nlays) = y;
  dT = y - yf;
  dt1_00(ii,1:nlays) = viewAngleSecant_00(ii) * dT;
  dt2_00(ii,1:nlays) = (viewAngleSecant_00(ii))^2 * dT;  
  dt3_00(ii,1:nlays) = viewAngleSecant_00(ii) * dT .* dT;
  dt4_00(ii,1:nlays) = (viewAngleSecant_00(ii))^2 * dT.*dT;  
  dt5_00(ii,1:nlays) = dT;
  dt6_00(ii,1:nlays) = dT .* dT;    
  
  y = p.gas_1(1:nlays,ii);
  y(end) = y(end) * xfrac(ii);
  yf = usstd_pf.gas_1(1:nlays);
  yf(end) = yf(end) * xfrac(ii);
  Q_00(ii,1:nlays)  = y;
  wr = y./yf;
  Wr1_00(ii,1:nlays) = viewAngleSecant_00(ii) * wr;
  Wr2_00(ii,1:nlays) = viewAngleSecant_00(ii) * sqrt(wr);
  Wr3_00(ii,1:nlays) = viewAngleSecant_00(ii) * wr .* dT;
  Wr4_00(ii,1:nlays) = (viewAngleSecant_00(ii) * wr).^2;
  Wr5_00(ii,1:nlays) = viewAngleSecant_00(ii) * sqrt(wr) .* dT;
  Wr6_00(ii,1:nlays) = viewAngleSecant_00(ii) * (sqrt(wr) .* dT).^2;
  Wr7_00(ii,1:nlays) = (viewAngleSecant_00(ii))^2 * wr;

  y = p.gas_2(1:nlays,ii);  
  y(end) = y(end) * xfrac(ii);
  yf = usstd_pf.gas_2(1:nlays);
  yf(end) = yf(end) * xfrac(ii);  
  CO2_00(ii,1:nlays) = y;
  CO2r_00(ii,1:nlays) = y./yf;

  y = p.gas_3(1:nlays,ii);
  y(end) = y(end) * xfrac(ii);
  yf = usstd_pf.gas_3(1:nlays);
  yf(end) = yf(end) * xfrac(ii);    
  O3_00(ii,1:nlays) = y;
  or = y./yf;
  Or1_00(ii,1:nlays) = viewAngleSecant_00(ii) * or;
  Or2_00(ii,1:nlays) = viewAngleSecant_00(ii) * sqrt(or);
  Or3_00(ii,1:nlays) = viewAngleSecant_00(ii) * or .* dT;
  Or4_00(ii,1:nlays) = (viewAngleSecant_00(ii) * or).^2;  
  Or5_00(ii,1:nlays) = viewAngleSecant_00(ii) * sqrt(or) .* dT;
  Or6_00(ii,1:nlays) = viewAngleSecant_00(ii) * (sqrt(or) .* dT).^2;
  Or7_00(ii,1:nlays) = (viewAngleSecant_00(ii))^2 * or;
  
  y = p.gas_4(1:nlays,ii);
  y(end) = y(end) * xfrac(ii);
  yf = usstd_pf.gas_4(1:nlays);
  yf(end) = yf(end) * xfrac(ii);    
  N2O_00(ii,1:nlays) = y;
  xr = y./yf;
  N2Or1_00(ii,1:nlays) = viewAngleSecant_00(ii) * or;

  y = p.gas_5(1:nlays,ii);
  y(end) = y(end) * xfrac(ii);
  yf = usstd_pf.gas_5(1:nlays);
  yf(end) = yf(end) * xfrac(ii);    
  CO_00(ii,1:nlays) = y;
  xr = y./yf;
  COr1_00(ii,1:nlays) = viewAngleSecant_00(ii) * or;
  
  y = p.gas_6(1:nlays,ii);
  y(end) = y(end) * xfrac(ii);
  yf = usstd_pf.gas_6(1:nlays);
  yf(end) = yf(end) * xfrac(ii);    
  CH4_00(ii,1:nlays) = y;
  xr = y./yf;
  CH4r1_00(ii,1:nlays) = viewAngleSecant_00(ii) * or;

end
fprintf(1,'\n')

plot(xfrac,p.spres,'.')
plot(xplays,p.spres,'.',p.spres,p.spres)
plot(xplays - p.spres,'.')

co2_500mb_00 = px.co2_500mb_after;
n2o_500mb_00 = px.n2o_500mb_after;
ch4_500mb_00 = px.ch4_500mb_after;

pause(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% you can keep redoing this part as needed, to change what is being fitted %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% you can keep redoing this part as needed, to change what is being fitted %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% you can keep redoing this part as needed, to change what is being fitted %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iJac < 0
  disp('reading in radiances')
else
  disp('reading in jacs')
end

radianceRaw_00 = zeros(length(p.stemp),nChannels0);
for JOB = 1 : 191
  if mod(JOB,100) == 0
    fprintf(1,'+')
  elseif mod(JOB,10) == 0
    fprintf(1,'.')
  end
  numperjob = 200;
  ind = 1:numperjob;
  ind = ind + (JOB-1)*numperjob;
  boo = find(ind <= length(p.stemp));
  ind = ind(boo);
  fileIN = ['../../Improve_SARTA_vs_KCARTA_Jacs/DATA/40000profiles/KC_SA/both_coljac_' num2str(JOB) '.mat'];
  x = load(fileIN);
  if JOB == 1
    fchan = x.fchan;
    ichan = x.ichan;
  end
  if iJac < 0
    radianceRaw_00(ind,:) = x.kcRAD;
    %radianceRaw_00(ind,:) = x.kcRAD - usstd_rad';    
  elseif iJac == 100
    radianceRaw_00(ind,:) = x.kcJT - x.saJT;    
  elseif iJac == 101
    radianceRaw_00(ind,:) = x.kcSKT - x.saSKT;  
  elseif iJac == 2
    radianceRaw_00(ind,:) = x.kcJ2 - x.saJ2;  
  elseif iJac == 4
    radianceRaw_00(ind,:) = x.kcJ4 - x.saJ4;  
  elseif iJac == 5
    radianceRaw_00(ind,:) = x.kcJ6 - x.saJ6;
  end
end
freq = instr_chans2645';
fprintf(1,'\n');

figure(4); clf; plot(freq,nanmean(radianceRaw_00,1))
  xlabel('Wavenumber cm-1'); ylabel('Signal to fit')
pause(0.1);

btRaw_00         = planckBT(radianceRaw_00, wavenumbers);

error('lksjlskgjslj')
