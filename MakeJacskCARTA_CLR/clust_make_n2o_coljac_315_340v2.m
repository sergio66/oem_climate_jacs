addpath /asl/matlib/h4tools
addpath /asl/matlib/aslutil
addpath /asl/matlib/rtptools
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS
addpath /home/sergio/MATLABCODE/
addpath /home/sergio/KCARTA/MATLAB

%% see put_together_kcarta_jacs.m
normer.normCO2 = 2.2/370;   %% ppm/yr out of 370
normer.normO3  = 0.01;      %% frac/yr
normer.normN2O = 1.0/300;   %% ppb/yr outof 300
normer.normCH4 = 5/1860;    %% ppb/yr out of 1800
normer.normCFC = 1/1300;    %% ppt/yr out of 1300
normer.normST  = 0.1;       %% K/yr

%JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
%JOB = 21

%%% NOTE WE CHANGED coljac PERT in kCARTA from 0.1 to 0.001, after June 25, 2019
dQkc = 0.1;
dQkc = 0.001;

iaN2O = [315 : 5 : 340]; %% ppb

for latbin = JOB
%for latbin = 1:40
  clear d dpert w fc qc
  iipert0 = 1;
  for iipert = 1 : length(iaN2O)
    fprintf(1,'latbin %2i ijac %2i \n',latbin,iipert)
    if iipert == 1
      kcrad = ['N2O_315_340/junkN2O_latbin_' num2str(latbin) '_n2opert_' num2str(iipert) '.dat'];     %% this is BT0 at 315 ppb
      kcjac = ['N2O_315_340/junkN2O_latbin_' num2str(latbin) '_n2opert_' num2str(iipert) '.jac_COL']; %% this is BTpert at 315*1.1 ppb
    else
      kcrad = ['N2O_315_340/junkN2O_latbin_' num2str(latbin) '_n2opert_' num2str(iipert0) '.dat'];     %% always use N2O = 315 ppb as your start
      kcjac = ['N2O_315_340/junkN2O_latbin_' num2str(latbin) '_n2opert_' num2str(iipert) '.dat'];     %% this is BTpert at X ppb
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
  [fc,qc] = convolve_airs(w,tnew-t0,clist,sfile);  %% note this is for [0.315 5 10 15 20 25]; delta ppb, note first one is 315*0.001 = 0.315

  %% above is jac for 10% change (which starting from eg 1800 ppb is 180 ppmb change ... so what is it for 5 ppmb change??)
  qcx = qc * (1./(315 * 0.1));
  plot(fc,qcx)
  figure(1); plot(fc,qcx./(qcx(:,1)*ones(1,length(iaN2O)))); axis([640 2780 0.9 1.25])

  %% this is better w
  deltaN2O = [315*dQkc 5 10 15 20 25]; %% delta ppmay
  iaDelta = ones(length(qcx),1) * 1.0./(deltaN2O);
  qcx = qc .* iaDelta;
  figure(1); plot(fc,qcx); axis([1000 2400 -1e-1 +1e-1]);                      hl = legend(num2str(iaN2O'));title('Abs numbers for 5 ppb change'); ylabel('dBT(K)');
  figure(2); plot(fc,qcx - qcx(:,1)*ones(1,length(iaN2O))); axis([1000 2400 -1e-2 +1e-2]); hl = legend(num2str(iaN2O'));title('Relative Jac(X)-Jac(1.7)');
  figure(3); plot(fc,qcx./(qcx(:,1)*ones(1,length(iaN2O)))); axis([1000 2400 0.75 1.25]);  hl = legend(num2str(iaN2O'));title('Ratio Jac(X)/Jac(1.7)');
  figure(4); plot(fc,100*(1-qcx./(qcx(:,1)*ones(1,length(iaN2O))))); axis([1000 2400 -25 +25]);  hl = legend(num2str(iaN2O'));title('Percent change in jac(X) to jac(1.7)');

  comment = ['use qcx which is normalized to deal with 1 ppb for varying (315:5:340) ppb'];
  saver = ['save N2O_315_340/n2o_jac_2834_latbin' num2str(latbin) 'v2.mat fc qc qcx iaN2O comment'];
  eval(saver);

  for ii = 1 : 4; figure(ii); plotaxis2; end; pause(0.1)

end
