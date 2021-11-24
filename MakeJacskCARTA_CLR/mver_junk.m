iaaFound = zeros(365,40);
for iTimeStep = 1 : 365
  for iLatbin = 1: 40
    fin = ['Anomaly365_16_12p8/010/strowfinitejac_convolved_kcarta_airs_1_jac3.mat'];
    fin  = ['Anomaly365_16_12p8/' num2str(iTimeStep,'%03d') '/strowfinitejac_convolved_kcarta_airs_' num2str(iLatbin) '_jac3.mat'];
    fout = ['Anomaly365_16_12p8/' num2str(iTimeStep,'%03d') '/strowfinitejac_convolved_kcarta_airs_' num2str(iLatbin) '_jac4.mat'];
    if exist(fin)
      mver = ['!/bin/mv ' fin ' ' fout];
      eval(mver)
      iaaFound(iTimeStep,iLatbin) = 1;
    end
  end
end

sum(sum(iaaFound))
pcolor(iaaFound); shading flat
