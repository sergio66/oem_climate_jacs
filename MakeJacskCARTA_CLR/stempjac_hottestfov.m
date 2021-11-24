%% Larrabee gave me scan angles for 40 latest profs
%% see ../MakeProfs/driver_make_lats40_avg_and_monthly_profs.m

for ii = 1 : 40
  x0 = load(['/home/sergio/KCARTA/WORK/RUN_TARA/GENERIC_RADSnJACS_MANYPROFILES/JUNK/individual_prof_convolved_kcarta_crisHI_' num2str(ii) '.mat']);
  x  = load(['/home/sergio/KCARTA/WORK/RUN_TARA/GENERIC_RADSnJACS_MANYPROFILES/JUNK/individual_prof_convolved_kcarta_AIRS_crisHI_'  num2str(ii) '_coljac.mat']);
  plot(x.fKc,(rad2bt(x.fKc,x.rKc(:,3))-rad2bt(x.fKc,x0.rKc))/0.01); 
  stemp_jac(ii,:) = (rad2bt(x.fKc,x.rKc(:,3))-rad2bt(x.fKc,x0.rKc))/0.01;  %% I used 1 = co2, 2 = col T, 3 = surf temp
end

plot(stemp_jac(:,1291))
save Anomaly365_16_12p8/StempJacHottestFov/stempjac.mat stemp_jac

%% [h,ha,pall,pa] = rtpread('../MakeProfs/LATS40_avg_made_Aug20_2019_Clr/Desc/ChangeSatZen2HottestSatZen/latbin1_40.op.rtp');
plot(pall.satzen,stemp_jac(:,1291),'.')
