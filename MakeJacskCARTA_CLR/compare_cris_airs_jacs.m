[h,ha,pcris,pa] = rtpread('../MakeProfs/CLO_LAT40_avg_made_Dec2019_Clr/Desc/16DayAvgNoS/timestep_067_16day_avg.rp.rtp');
[h,ha,pairs,pa] = rtpread('../MakeProfs/LATS40_avg_made_Aug20_2019_Clr/Desc/16DayAvgNoS/timestep_067_16day_avg.rp.rtp');
plot(pairs.rlat,pairs.stemp,'b',pcris.rlat,pcris.stemp,'r'); title('(b) AIRS (r) CRIS : stemp'); pause(0.5)
plot(pairs.ptemp(:,20),1:101,'b',pcris.ptemp(:,20),1:101,'r'); set(gca,'ydir','reverse'); title('(b) AIRS (r) CRIS : Tz'); pause(0.5)
semilogx(pairs.gas_1(:,20),1:101,'b',pcris.gas_1(:,20),1:101,'r'); set(gca,'ydir','reverse'); title('(b) AIRS (r) CRIS : Wz'); pause(0.5)
semilogx(pairs.gas_3(:,20),1:101,'b',pcris.gas_3(:,20),1:101,'r'); set(gca,'ydir','reverse'); title('(b) AIRS (r) CRIS : O3'); pause(0.5)
disp('ret to continue'); pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[h,ha,pcris,pa] = rtpread('../MakeProfs/CLO_LAT40_avg_made_Dec2019_Clr/Desc/16DayAvgNoS/latbin20_16day_avg.rp.rtp');
[h,ha,pairs,pa] = rtpread('../MakeProfs/LATS40_avg_made_Aug20_2019_Clr/Desc/16DayAvgNoS/latbin20_16day_avg.rp.rtp');
%% (2012 + 5/12) - (2002 + 8/12) = 9.75 years = blah*365/16 = 222 timesteps
plot(1:length(pairs.rlat),pairs.stemp,'b',221+(1:length(pcris.rlat)),pcris.stemp,'r'); title('(b) AIRS (r) CRIS : stemp'); pause(0.5)
plot(pairs.ptemp(:,221),1:101,'b',pcris.ptemp(:,1),1:101,'r'); set(gca,'ydir','reverse'); title('(b) AIRS (r) CRIS : Tz'); pause(0.5)
semilogx(pairs.gas_1(:,221),1:101,'b',pcris.gas_1(:,1),1:101,'r'); set(gca,'ydir','reverse'); title('(b) AIRS (r) CRIS : Wz'); pause(0.5)
semilogx(pairs.gas_3(:,221),1:101,'b',pcris.gas_3(:,1),1:101,'r'); set(gca,'ydir','reverse'); title('(b) AIRS (r) CRIS : O3'); pause(0.5)
disp('ret to continue'); pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

crisX = load('CLO_Anomaly137_16_12p8/043/jac_results_20.mat');
cris = load('CLO_Anomaly137_16_12p8/RESULTS/kcarta_043_M_TS_jac_all_5_97_97_97_2235.mat');
airs = load('Anomaly365_16_12p8/RESULTS/kcarta_043_M_TS_jac_all_5_97_97_97_2645.mat');

fC = cris.f; wahC = squeeze(cris.M_TS_jac_all(20,:,:));
fA = airs.f; wahA = squeeze(airs.M_TS_jac_all(20,:,:));
fCX = crisX.fKc;

for ii = 1 : 6
  if ii <= 4
    %plot(fA,wahA(:,ii),'b',fC,wahC(:,ii),'r',fCX,crisX.tracegas(:,ii)*0.01,'g'); title(['(b) AIRS (r) CRIS (g) raw CRIS : ' num2str(ii)]); disp('ret'); pause
    plot(fA,wahA(:,ii),'b',fC,wahC(:,ii),'r'); title(['(b) AIRS (r) CRIS : ' num2str(ii)]); disp('ret'); pause
  elseif ii == 6
    %plot(fA,wahA(:,ii),'b',fC,wahC(:,ii),'r',fCX,crisX.tracegas(:,ii-1)*0.01,'g'); title(['(b) AIRS (r) CRIS (g) raw CRIS : ' num2str(ii)]); disp('ret'); pause
    plot(fA,wahA(:,ii),'b',fC,wahC(:,ii),'r'); title(['(b) AIRS (r) CRIS : ' num2str(ii)]); disp('ret'); pause
  end
end

%ind = (7:7+97-1) + 97*0; plot(fA,sum(wahA(:,ind)'),'b',fC,sum(wahC(:,ind)'),'r.',fC,sum(crisX.water')*0.01,'g'); title('(b) AIRS (r) CRIS : WV'); disp('ret'); pause
%ind = (7:7+97-1) + 97*1; plot(fA,sum(wahA(:,ind)'),'b',fC,sum(wahC(:,ind)'),'r.',fC,sum(crisX.tempr')*0.01,'g'); title('(b) AIRS (r) CRIS : Tz'); disp('ret'); pause
%ind = (7:7+97-1) + 97*2; plot(fA,sum(wahA(:,ind)'),'b',fC,sum(wahC(:,ind)'),'r.',fC,sum(crisX.ozone')*0.01,'g'); title('(b) AIRS (r) CRIS : O3'); disp('ret'); pause

ind = (7:7+97-1) + 97*0; plot(fA,sum(wahA(:,ind)'),'b',fC,sum(wahC(:,ind)'),'r.'); title('(b) AIRS (r) CRIS : WV'); disp('ret'); pause
ind = (7:7+97-1) + 97*1; plot(fA,sum(wahA(:,ind)'),'b',fC,sum(wahC(:,ind)'),'r.'); title('(b) AIRS (r) CRIS : Tz'); disp('ret'); pause
ind = (7:7+97-1) + 97*2; plot(fA,sum(wahA(:,ind)'),'b',fC,sum(wahC(:,ind)'),'r.'); title('(b) AIRS (r) CRIS : O3'); disp('ret'); pause
