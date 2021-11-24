for iTime = 1 : 140
  for iLat = 1 : 38
     %% first stage, done Jan 13, 2020 pm
     f1 = [num2str(iTime,'%03d') '/strowfinitejac_convolved_kcarta_airs_' num2str(iLat) '_jac5.mat'];
     f2 = [num2str(iTime,'%03d') '/strowfinitejac_convolved_kcarta_airs_' num2str(iLat) '_jac4.mat'];

     %% second stage, done Jan 14, 2020 am   
     f1 = [num2str(iTime,'%03d') '/strowfinitejac_convolved_kcarta_airs_' num2str(iLat) '_jac4.mat'];
     f2 = [num2str(iTime,'%03d') '/strowfinitejac_convolved_kcarta_cris_' num2str(iLat) '_jac4.mat'];
     
     mver = ['!/bin/mv ' f1 ' ' f2];
     fprintf(1,'iTime,iLat = %3i %3i mver = %s \n',iTime,iLat,mver)

     eval(mver)
  end
end
