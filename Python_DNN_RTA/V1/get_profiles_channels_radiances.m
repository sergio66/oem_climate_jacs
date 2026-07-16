addpath /umbc/rs/pi_sergio/WorkDirDec2025/matlabcode/
addpath /umbc/rs/pi_sergio/WorkDirDec2025/matlabcode/matlibSergio/matlib/rtp_prod2_Aug11_2020/h4tools
addpath /umbc/rs/pi_sergio/WorkDirDec2025/matlabcode/matlibSergio/matlib/rtp_prod2_Aug11_2020/util/

%% see Improve_SARTA_vs_KCARTA_Jacs/clust_put_together_sarta_kcartajacs.m

fop = '../Improve_SARTA_vs_KCARTA_Jacs/combined_rp_raw_with_emiss_random_CO2_scanang.rtp';
[h,ha,p,pa] = rtpread(fop);

surfTemp = p.stemp';
surfPressure = p.spres';
viewAngleSecant = p.scanang';
  viewAngleSecant = 1./cos(viewAngleSecant*pi/180);

disp('putting emissivity on common vchan grid')
freq = instr_chans2645';
for ii = 1 : length(p.stemp)
  if mod(ii,1000) == 0
    fprintf(1,'+')
  elseif mod(ii,100) == 0
    fprintf(1,'.')
  end
  nemis = p.nemis(ii);
  efreq = p.efreq(1:nemis,ii);
  emis  = p.emis(1:nemis,ii);  
  boo = interp1(efreq,emis,freq,'nearest','extrap');
  boo(boo > 1) = 1;
  boo(boo < 0) = 0;
  emissivityRaw(ii,:) = boo;
end  
fprintf(1,'\n')

ocean = find(p.landfrac == 0); whos ocean
land = find(p.landfrac == 1); whos land
plot(nanmean(p.efreq(:,ocean),2),nanmean(p.emis(:,ocean),2),nanmean(p.efreq(:,land),2),nanmean(p.emis(:,land),2)); title('Whoa what wrong with ocen???')
boo = nanmean(p.efreq(:,ocean),2); booO = find(boo >= 1230,1);
boo = nanmean(p.efreq(:,land),2);  booL = find(boo >= 1230,1);
plot(ocean,p.emis(booO,ocean),land,p.emis(booL,land))

p.plays = plevs2plays(p.plevs);
boo = find(p.spres == 1100);
sigma0 = p.plays(1:100,boo)/1100; plot(nanstd(sigma0,[],2),1:100,'+-'); set(gca,'ydir','reverse'); ylim([1 100])
sigma0 = p.plays(1:100,boo)/1100; plot(nanmean(sigma0,2),1:100,'+-'); set(gca,'ydir','reverse'); ylim([1 100]);   
sigma0 = nanmean(sigma0,2); %% want to interpolate all profiles,plays to this sigma value

% xT   = p.ptemp;
% xQ   = p.gas_1;
% xCO2 = p.gas_2;
% xO3  = p.gas_3;
% xN2O = p.gas_4;
% xCO  = p.gas_5;
% xCH4 = p.gas_6;

disp('putting T,Q1,Q2,Q3,Q4,Q5,Q6  on common sigma grid')
for ii = 1 : length(p.stemp)
  if mod(ii,1000) == 0
    fprintf(1,'+')
  elseif mod(ii,100) == 0
    fprintf(1,'.')
  end

  nlays = p.nlevs(ii)-1;
  plays = p.plays(1:nlays,ii);
  plevs = p.plevs(1:nlays+1,ii);  

  xfrac(ii)  = (plevs(nlays) - p.spres(ii))/(plevs(nlays)-plevs(nlays+1));
  xplays(ii) = (plevs(nlays)-p.spres(ii))/log(plevs(nlays)/p.spres(ii));
  plays(end) = xplays(ii);
  
  y = p.ptemp(1:nlays,ii);
  y(end) = interp1(log(plays),y,xplays(ii),[],'extrap');
  T(ii,1:100) = interp1(plays/p.spres(ii),y,sigma0,'nearest','extrap');

  y = p.gas_1(1:nlays,ii);
  y(end) = y(end) * xfrac(ii);
  Q(ii,1:100) = interp1(plays/p.spres(ii),y,sigma0,'nearest','extrap');
  
  y = p.gas_2(1:nlays,ii);
  y(end) = y(end) * xfrac(ii);
  CO2(ii,1:100) = interp1(plays/p.spres(ii),y,sigma0,'nearest','extrap');
  
  y = p.gas_3(1:nlays,ii);
  y(end) = y(end) * xfrac(ii);
  O3(ii,1:100) = interp1(plays/p.spres(ii),y,sigma0,'nearest','extrap');

  y = p.gas_4(1:nlays,ii);
  y(end) = y(end) * xfrac(ii);
  N2O(ii,1:100) = interp1(plays/p.spres(ii),y,sigma0,'nearest','extrap');

  y = p.gas_5(1:nlays,ii);
  y(end) = y(end) * xfrac(ii);
  CO(ii,1:100) = interp1(plays/p.spres(ii),y,sigma0,'nearest','extrap');
  
  y = p.gas_6(1:nlays,ii);
  y(end) = y(end) * xfrac(ii);
  CH4(ii,1:100) = interp1(plays/p.spres(ii),y,sigma0,'nearest','extrap');

end
fprintf(1,'\n')

plot(xfrac,p.spres,'.')
plot(xplays,p.spres,'.',p.spres,p.spres)
plot(xplays - p.spres,'.')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('reading in radiances')
radianceRaw = zeros(length(p.stemp),nChannels);
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
  fileIN = ['../Improve_SARTA_vs_KCARTA_Jacs/DATA/40000profiles/KC_SA/both_coljac_' num2str(JOB) '.mat'];
  x = load(fileIN);
  if ii == 1
    fchan = x.fchan;
    ichan = x.ichan;
  end
  radianceRaw(ind,:) = x.kcRAD;
end

fprintf(1,'\n');
