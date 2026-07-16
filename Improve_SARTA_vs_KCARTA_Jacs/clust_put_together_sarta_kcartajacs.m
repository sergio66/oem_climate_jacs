%% sbatch --array=1-200%512 --output='/dev/null/' sergio_matlab_chip.sbatch 2      since 40000/200 = 200

addpath /umbc/rs/pi_sergio/WorkDirDec2025/matlabcode/matlibSergio/matlib/rtp_prod2_Aug11_2020/util
addpath /umbc/rs/pi_sergio/WorkDirDec2025/matlabcode/CONVERT_GAS_UNITS/
addpath /umbc/rs/pi_sergio/WorkDirDec2025/matlabcode/

clear all

fop = 'combined_rp_raw_with_emiss_random_CO2_scanang.rtp';
[h,ha,p,pa] = rtpread(fop);
mmw = mmwater_rtp(h,p);

%% so that we can handloop through using "loop_clust_do_kcarta_driver.m" when cluster is dead; see sergio_matlab_chip.sbatch
if ~exist('JOBB')
  JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
else
  JOB = JOBB;
end
if length(JOB) == 0
  JOB = 1;
  JOB = 11;  
  JOB = 80;
  JOB = 100;  
  JOB = 102;

  JOB = 101; %%% SO BAD!!!!
  JOB = 191;
end

numperjob = 200;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ind = 1:numperjob;
ind = ind + (JOB-1)*numperjob;
boo = find(ind <= length(p.stemp));
ind = ind(boo);
whos ind

if length(ind) < 1
  JOB
  error('cannot find indices')
end

for jj = 1 : length(ind)
  xjob = ind(jj);
  fprintf(1,'xjob = %5i stemp = %.2f  mmw = %.2f \n',xjob,p.stemp(xjob),mmw(xjob));
  if xjob <= 20000
    kcjacdir = '/umbc/xfs3/strow/sergio_test/git/kcarta_gen/WORK/RUN_TARA/GENERIC_RADSnJACS_MANYPROFILES/JUNK/CombinedRTP_ColJac_00001_20000/';
    sajacdir = 'DATA/40000profiles/SartaColJac_00001_20000';
  elseif xjob <= 40000
    kcjacdir = '/umbc/xfs3/strow/sergio_test/git/kcarta_gen/WORK/RUN_TARA/GENERIC_RADSnJACS_MANYPROFILES/JUNK/CombinedRTP_ColJac_20001_40000/';
    sajacdir = 'DATA/40000profiles/SartaColJac_20001_40000';
  else
    xjob
    error('only about 38500 profiles')
  end

  fkcrad = [kcjacdir '/individual_prof_convolved_kcarta_airs_' num2str(xjob) '.mat'];
  fkcjac = [kcjacdir '/individual_prof_convolved_kcarta_airs_' num2str(xjob) '_coljac.mat'];
  fsajac = [sajacdir '/prof_' num2str(xjob) 'coljac.mat'];

  loader = ['kcrad = load(''' fkcrad ''');']; eval(loader);
  loader = ['kcjac = load(''' fkcjac ''');']; eval(loader);
  loader = ['sajac = load(''' fsajac ''');']; eval(loader);  

  kcjacX = rad2bt(kcjac.fKc,kcjac.rKc) - rad2bt(kcrad.fKc,kcrad.rKc);
  kcjacX = kcjac.rKc;  
  moo = kcjac.fKc(sajac.hx.ichan);
  plot(moo,moo-sajac.hx.vchan)
  kcjacX = kcjacX(sajac.hx.ichan,:);

  %/umbc/xfs3/strow/sergio_test/git/kcarta_gen/WORK/RUN_TARA/GENERIC_RADSnJACS_MANYPROFILES/set_gasOD_cumOD_rad_jac_flux_cloud_lblrtm.m
  %iKCKD =  43; iHITRAN = 2024; iDoLBLRTM = 2; iDoRad = 3;  iDoCloud = -1; iDoJac = +100; gg = 2456;  %% clrsky, use LBLRTM ODs  COL CLR JACS G2,G4,G5,G6,G51,G52,T(z),ST
  %kcJ1(jj,:)  = zeros(1.2645);
  kcJ2(jj,:)  = kcjacX(:,1)';
  %kcJ3(jj,:)  = zeros(1,2645);
  kcJ4(jj,:)  = kcjacX(:,2)';
  kcJ5(jj,:)  = kcjacX(:,3)';
  kcJ6(jj,:)  = kcjacX(:,4)';  
  kcJT(jj,:)  = kcjacX(:,7)';
  kcSKT(jj,:) = kcjacX(:,8)';
  kcRAD(jj,:) = kcrad.rKc(sajac.hx.ichan)';
  
  saJ2(jj,:) = sajac.colJ2;
  saJ4(jj,:) = sajac.colJ4;
  saJ5(jj,:) = sajac.colJ5;
  saJ6(jj,:) = sajac.colJ6;
  saJT(jj,:) = sajac.colJT;
  saSKT(jj,:) = sajac.colSKT;  
  saRAD(jj,:) = sajac.rad;
  
  iaNumLay(jj) = sajac.iaNumLay;
  
  fchan = sajac.hx.vchan;
  ichan = sajac.hx.ichan;

  plot(fchan,saRAD(jj,:),'b.-',fchan,kcRAD(jj,:),'r');   xlim([645 1645]);  
  plot(fchan,saJ2(jj,:),'b.-',fchan,kcJ2(jj,:),'r');   xlim([645 1645]);
  plot(fchan,saJ4(jj,:),'b.-',fchan,kcJ4(jj,:),'r');   xlim([645 1645]);
  plot(fchan,saJ5(jj,:),'b.-',fchan,kcJ5(jj,:),'r');   xlim([645 1645]);
  plot(fchan,saJ6(jj,:),'b.-',fchan,kcJ6(jj,:),'r');   xlim([645 1645]);
  plot(fchan,saJT(jj,:),'b.-',fchan,kcJT(jj,:),'r');   xlim([645 1645]);
  plot(fchan,saSKT(jj,:),'b.-',fchan,kcSKT(jj,:),'r'); xlim([645 1645]);    

  title(num2str(jj))

  pause(1);
end

figure(1); QAJ2  = find(fchan >= 720,1);    plot(1:jj,saJ2(:,QAJ2),'b.-',1:jj,kcJ2(:,QAJ2)); title('CO2 (b) sarta (r) kc')
figure(2); QAJ4  = find(fchan >= 1280,1);   plot(1:jj,saJ4(:,QAJ4),'b.-',1:jj,kcJ4(:,QAJ4)); title('N2O (b) sarta (r) kc')
figure(3); QAJ5  = find(fchan >= 2186.9,1); plot(1:jj,saJ5(:,QAJ5),'b.-',1:jj,kcJ5(:,QAJ5)); title('CO  (b) sarta (r) kc')
figure(4); QAJ6  = find(fchan >= 1292.8,1); plot(1:jj,saJ6(:,QAJ6),'b.-',1:jj,kcJ6(:,QAJ6)); title('CH4 (b) sarta (r) kc')
figure(5); QAJT  = find(fchan >= 1231.0,1); plot(1:jj,saJT(:,QAJT),'b.-',1:jj,kcJT(:,QAJT)); title('TZ (b) sarta (r) kc')
figure(6); QASKT = find(fchan >= 1231.0,1); plot(1:jj,saSKT(:,QASKT),'b.-',1:jj,kcSKT(:,QASKT)); title('SKT (b) sarta (r) kc')

figure(1); clf; colormap jet
figure(2); clf; colormap jet
figure(3); clf; colormap jet
figure(4); clf; colormap jet
figure(5); clf; colormap jet
figure(6); clf; colormap jet
figure(1); yyaxis left;  plot(fchan,nanmean(kcJ2-saJ2,1),fchan,nanstd(kcJ2-saJ2,[],1)); title('CO2'); xlim([645 845]);  plotaxis2;
           yyaxis right; plot(fchan,nanmean(kcJ2,1)); xlim([645 845]); plotaxis2;
figure(2); yyaxis left; plot(fchan,nanmean(kcJ4-saJ4,1),fchan,nanstd(kcJ4-saJ4,[],1)); title('N2O'); xlim([1200 1400]); plotaxis2;
           yyaxis right; plot(fchan,nanmean(kcJ4,1)); xlim([1200 1400]); plotaxis2;
figure(3); yyaxis left; plot(fchan,nanmean(kcJ5-saJ5,1),fchan,nanstd(kcJ5-saJ5,[],1)); title('CO '); xlim([2150 2250]); plotaxis2;
           yyaxis right; plot(fchan,nanmean(kcJ5,1)); xlim([2150 2250]); plotaxis2;
figure(4); yyaxis left; plot(fchan,nanmean(kcJ6-saJ6,1),fchan,nanstd(kcJ6-saJ6,[],1)); title('CH4'); xlim([1200 1400]); plotaxis2;
           yyaxis right; plot(fchan,nanmean(kcJ6,1)); xlim([1200 1400]); plotaxis2;
figure(5); yyaxis left; plot(fchan,nanmean(kcJT-saJT,1),fchan,nanstd(kcJT-saJT,[],1)); title('TZ '); xlim([645 1645]); plotaxis2;
           yyaxis right; plot(fchan,nanmean(kcJT,1)); xlim([645 1645]); plotaxis2;
figure(6); yyaxis left; plot(fchan,nanmean(kcSKT-saSKT,1),fchan,nanstd(kcSKT-saSKT,[],1)); title('SKT'); xlim([645 1645]); plotaxis2;
           yyaxis right; plot(fchan,nanmean(kcSKT,1)); xlim([645 1645]); plotaxis2;

saver = ['save DATA/40000profiles/KC_SA/both_coljac_' num2str(JOB) '.mat ind ichan fchan saJ2 saJ4 saJ5 saJ6 saJT saSKT saRAD  kcJ2 kcJ4 kcJ5 kcJ6 kcJT kcSKT kcRAD'];
eval(saver)
fprintf(1,'saver = %s \n',saver);
disp('finished')
