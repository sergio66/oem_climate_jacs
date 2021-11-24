addpath /asl/matlib/h4tools
addpath /asl/matlib/aslutil
addpath /asl/matlib/rtptools
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS
addpath /home/sergio/MATLABCODE/
addpath /home/sergio/KCARTA/MATLAB

disp('same as clust_make_co2_coljac_370_385_400_415.m BUT we make big delta perts here .... always relative to 370 ppm')
disp('same as clust_make_co2_coljac_370_385_400_415.m BUT we make big delta perts here .... always relative to 370 ppm')
disp('same as clust_make_co2_coljac_370_385_400_415.m BUT we make big delta perts here .... always relative to 370 ppm')

%% see put_together_kcarta_jacs.m
normer.normCO2 = 2.2/370;   %% ppm/yr out of 370
normer.normO3  = 0.01;      %% frac/yr
normer.normN2O = 1.0/300;   %% ppb/yr outof 300
normer.normCH4 = 5/1860;    %% ppb/yr out of 1800
normer.normCFC = 1/1300;    %% ppt/yr out of 1300
normer.normST  = 0.1;       %% K/yr

iaCO2 = [370 385 400 415];
iaCO2 = [370 : 5 : 415];

%JOB = str2num(getenv('SLURM_ARRAY_TASK_ID')); %%% this already comes on from the previous call(s)
%JOB = 21

%%% NOTE WE CHANGED coljac PERT in kCARTA from 0.1 to 0.001, after June 25, 2019
dQkc = 0.1;
dQkc = 0.001;

%for latbin = JOB  %%% WHEN RUNNING AS part of batch
for latbin = 1:40  %%% WHEN RUNNING BY HAND
  clear d dpert w fc qc
  iipert0 = 1;
  for iipert = 1 : length(iaCO2)
    fprintf(1,'latbin %2i ijac %2i \n',latbin,iipert)
    if iipert == 1
      kcrad = ['CO2_370_385_400_415/junkCO2_latbin_' num2str(latbin) '_co2pert_' num2str(iipert) '.dat'];      %% this is BT0, at 370 ppm
      kcjac = ['CO2_370_385_400_415/junkCO2_latbin_' num2str(latbin) '_co2pert_' num2str(iipert) '.jac_COL'];  %% this is BTpert, at 370*(1.1) ppm
    else
      kcrad = ['CO2_370_385_400_415/junkCO2_latbin_' num2str(latbin) '_co2pert_' num2str(iipert0) '.dat'];     %% always use CO2 = 370 ppm as your "start"
      kcjac = ['CO2_370_385_400_415/junkCO2_latbin_' num2str(latbin) '_co2pert_' num2str(iipert) '.dat'];      %% this is BT, at X ppm
    end

    if iipert == 1
      [d(iipert,:),w] = readkcstd(kcrad);
      [junk,w]    = readkcBasic(kcjac);
      dpert(iipert,:) = junk(:,1);
    else
      [d(iipert,:),w] = readkcstd(kcrad);
      [junk,w]    = readkcstd(kcjac);
      dpert(iipert,:) = junk;
    end
  end

  tnew = rad2bt(w,dpert');
  t0 = rad2bt(w,d');

  addpath /home/sergio/MATLABCODE/REGR_PROFILES_SARTA/RUN_KCARTA/
  airs_convolve_file_numchans
  [fc,qc] = convolve_airs(w,(tnew-t0),clist,sfile);   %% note this is for [0.37 5 10 15 20 25 30 35 40 45] delta ppm NOTE first one is 370*1.001-370 = 37

  %% above is jac for 10% change (which starting from eg 370 is 0.37 ppmv change ... so what is it for 2.2 ppmv change??)
  qcx = qc * (2.2./(370 * dQkc));
  plot(fc,qcx)
  plot(fc,qcx./(qcx(:,1)*ones(1,length(iaCO2)))); axis([640 2780 0.9 1.25])

  %% this is better way
  deltaCO2 = [370*dQkc 5 10 15 20 25 30 35 40 45]; %% delta ppm
  iaDelta = ones(length(qcx),1) * 2.2./(deltaCO2);
  qcx = qc .* iaDelta;
  figure(1); plot(fc,qcx); axis([640 840 -1e-1 +1e-1]);                      hl = legend(num2str(iaCO2'));title('Abs numbers for 2.2 ppmv change'); ylabel('dBT(K)');
  figure(2); plot(fc,qcx - qcx(:,1)*ones(1,length(iaCO2))); axis([640 840 -1e-2 +1e-2]); hl = legend(num2str(iaCO2'));title('Relative Jac(X)-Jac(370)');
  figure(3); plot(fc,qcx./(qcx(:,1)*ones(1,length(iaCO2)))); axis([640 840 0.75 1.25]);  hl = legend(num2str(iaCO2'));title('Ratio Jac(X)/Jac(370)');
  figure(4); plot(fc,100*(1-qcx./(qcx(:,1)*ones(1,length(iaCO2))))); axis([640 840 -25 +25]);  hl = legend(num2str(iaCO2'));title('Percent change in jac(X) to jac(370)');

  comment = ['use qcx which is normalized to deal with 2.2 ppm for varying (370:415) ppm'];
  saver = ['save CO2_370_385_400_415/co2_jac_2834_latbin' num2str(latbin) 'v2.mat fc qc qcx iaCO2 comment'];
  eval(saver);

  for ii = 1 : 4; figure(ii); plotaxis2; end; pause(0.1)

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('now run compare_jacobians_12p4_12p8_finite_diff')
