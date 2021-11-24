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

iaCH4 = [1700 : 25 : 2000]/1000;

%%% NOTE WE CHANGED coljac PERT in kCARTA from 0.1 to 0.001, after June 25, 2019
dQkc = 0.1;
dQkc = 0.001;

for ll = JOB
%for ll = 1:40
  clear d dpert w fc qc
  for ii = 1 : length(iaCH4)
    fprintf(1,'latbin %2i ijac %2i \n',ll,ii)
    kcrad = ['CH4_1700_2000/junkCH4_latbin_' num2str(ll) '_ch4pert_' num2str(ii) '.dat'];
    kcjac = ['CH4_1700_2000/junkCH4_latbin_' num2str(ll) '_ch4pert_' num2str(ii) '.jac_COL'];

    [d(ii,:),w] = readkcstd(kcrad);
    [junk,w]    = readkcBasic(kcjac);
    dpert(ii,:) = junk(:,1);
  end

  tnew = rad2bt(w,dpert');
  t0 = rad2bt(w,d');

  addpath /home/sergio/MATLABCODE/REGR_PROFILES_SARTA/RUN_KCARTA/
  airs_convolve_file_numchans
  [fc,qc] = convolve_airs(w,tnew-t0,clist,sfile);

%% above is jac for 10% change (which starting from eg 1800 ppb is 180 ppmb change ... so what is it for 5 ppmb change??)
  qcx = qc * (5./(1860 * dQkc));
  plot(fc,qcx)
  figure(1); plot(fc,qcx./(qcx(:,1)*ones(1,length(iaCH4)))); axis([640 2780 0.9 1.25])

  %% this is better way
  iaDelta = ones(length(qcx),1) * 5.0./((iaCH4*1000) * dQkc);
  qcx = qc .* iaDelta;
  figure(1); plot(fc,qcx); axis([1200 1400 -1e-1 +1e-1]);                      hl = legend(num2str(iaCH4'));title('Abs numbers for 5 ppb change'); ylabel('dBT(K)');
  figure(2); plot(fc,qcx - qcx(:,1)*ones(1,length(iaCH4))); axis([1200 1400 -1e-2 +1e-2]); hl = legend(num2str(iaCH4'));title('Relative Jac(X)-Jac(1.7)');
  figure(3); plot(fc,qcx./(qcx(:,1)*ones(1,length(iaCH4)))); axis([1200 1400 0.75 1.25]);  hl = legend(num2str(iaCH4'));title('Ratio Jac(X)/Jac(1.7)');
  figure(4); plot(fc,100*(1-qcx./(qcx(:,1)*ones(1,length(iaCH4))))); axis([1200 1400 -25 +25]);  hl = legend(num2str(iaCH4'));title('Percent change in jac(X) to jac(1.7)');

  comment = ['use qcx which is normlaized to deal with 5 ppb for varying (1700:25:2000) ppb'];
  saver = ['save CH4_1700_2000/ch4_jac_2834_latbin' num2str(ll) '.mat fc qc qcx iaCH4 comment'];
  eval(saver);

  for ii = 1 : 4; figure(ii); plotaxis2; end; pause(0.1)

end
