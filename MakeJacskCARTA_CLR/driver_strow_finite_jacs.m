addpath /asl/matlib/h4tools
addpath /asl/matlib/aslutil
addpath /asl/matlib/rtptools
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS
addpath /home/sergio/MATLABCODE/
addpath /home/sergio/KCARTA/MATLAB

%% note the jacs are CO2 N2O CO CH4 CFC11  so save 1 2 4 5

iTimeStep0 = 1;

for iTimeStep = 1 : 365

  fprintf(1,'timestep = %3i of 365 \n',iTimeStep);
  jacall = [];

  for iLatbin = 1 : 40

    if iTimeStep == 1
      file0 = ['/asl/s1/sergio/USEFUL_LARGE_MATFILES/CLRSKY_ANOMALY_COLJACS/' num2str(iTimeStep,'%03d') '/radc.dat' num2str(iLatbin)];
      fileX = ['/asl/s1/sergio/USEFUL_LARGE_MATFILES/CLRSKY_ANOMALY_COLJACS/' num2str(iTimeStep,'%03d') '/jacc.dat' num2str(iLatbin) '_COL'];
      rad0 = readkcstd(file0);
      jac0 = readkcBasic(fileX);
    else
      %file0 = ['/asl/s1/sergio/USEFUL_LARGE_MATFILES/CLRSKY_ANOMALY_COLJACS/' num2str(iTimeStep0,'%03d') '/radc.dat' num2str(iLatbin)];
      %fileX = ['/asl/s1/sergio/USEFUL_LARGE_MATFILES/CLRSKY_ANOMALY_COLJACS/' num2str(iTimeStep,'%03d') '/radc.dat' num2str(iLatbin)];
      %rad0 = readkcstd(file0);
      %jac0 = readkcstd(fileX);

      %% so basically same as above
      file0 = ['/asl/s1/sergio/USEFUL_LARGE_MATFILES/CLRSKY_ANOMALY_COLJACS/' num2str(iTimeStep0,'%03d') '/radc.dat' num2str(iLatbin)];
      fileX = ['/asl/s1/sergio/USEFUL_LARGE_MATFILES/CLRSKY_ANOMALY_COLJACS/' num2str(iTimeStep,'%03d') '/jacc.dat' num2str(iLatbin) '_COL'];
      rad0 = readkcstd(file0);
      jac0 = readkcBasic(fileX);

    end

    rad0 = rad0*ones(1,4);
    jac0 = jac0(:,[1 2 4 5]);
    dBT = rad2bt(w,jac0)-rad2bt(w,rad0);

    addpath /home/sergio/MATLABCODE/REGR_PROFILES_SARTA/RUN_KCARTA/
    airs_convolve_file_numchans
    [fc,qc] = convolve_airs(w,dBT,clist,sfile);

    jacall(iLatbin,:,:) = qc;
    figure(1); plot(fc,qc(:,1)); 
    figure(2); plot(fc,qc(:,2)); 
    figure(3); plot(fc,qc(:,3)); 
    figure(4); plot(fc,qc(:,4)); 
    pause(0.1)
  end
  comment = 'see /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/MakeJacskCARTA_CLR/driver_strow_finite_jacs.m';
  saver = ['save /asl/s1/sergio/USEFUL_LARGE_MATFILES/CLRSKY_ANOMALY_COLJACS/jacall' num2str(iTimeStep,'%03d') '.mat fc jacall comment'];
  eval(saver);
end
