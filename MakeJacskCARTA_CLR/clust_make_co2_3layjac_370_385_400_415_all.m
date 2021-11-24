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

iaCO2 = [370 385 400 415];
iaCO2 = [370 : 5 : 415];

addpath /home/sergio/MATLABCODE/UTILITY
addpath /home/sergio/MATLABCODE
fin = 'latbin1_40.clr.rp.rtp';
[h0,ha,p0,pa] = rtpread(fin);
p0.plevs = flipud(p0.plevs);
p0.ptemp = flipud(p0.ptemp);
p0.gas_1 = flipud(p0.gas_1);
p0.gas_3 = flipud(p0.gas_3);
tropi0  = 101 - tropopause_rtp(h0,p0) + 1;  %% so that 1 = GND, 101 = TOA
strati0 = 101 - stratopause_rtp(h0,p0) + 1; %% so that 1 = GND, 101 = TOA

[hi,ha,pi,pa] = rtpread(fin);
tropi  = 101 - tropopause_rtp(hi,pi) + 1;  %% so that 1 = GND, 101 = TOA
strati = 101 - stratopause_rtp(hi,pi) + 1; %% so that 1 = GND, 101 = TOA

for ii = 1 : 40
  plevs = p0.plevs(:,ii);
  ptropi0(ii) = plevs(tropi0(ii));
  pstrati0(ii) = plevs(strati0(ii));

  plevs = pi.plevs(:,ii);
  ptropi(ii) = plevs(tropi(ii));
  pstrati(ii) = plevs(strati(ii));
end

plot(1:40,tropi0,'bo-',1:40,tropi,'r')
  plot(1:40,ptropi0,'bo-',1:40,ptropi,'r'); set(gca,'ydir','reverse')


airslevs = load('/home/sergio/MATLABCODE/airslevels.dat');
p500 = find(airslevs < 500,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ll = JOB
%for ll = 1:40
  clear d dpert w fc qc
  for ii = 1 : length(iaCO2)
    fprintf(1,'latbin %2i ijac %2i \n',ll,ii)
    kcrad = ['CO2_370_385_400_415/junkCO2_latbin_' num2str(ll) '_3layco2pert_' num2str(ii) '.dat'];
    kcjac = ['CO2_370_385_400_415/junkCO2_latbin_' num2str(ll) '_3layco2pert_' num2str(ii) '.jac'];

    [d(ii,:),w] = readkcstd(kcrad);
    [j,w]       = readkcjac(kcjac);
    [mm,nn] = size(j); numlay = (nn-4)/3; layoffset = 100-numlay;

    j = j(:,1:numlay);
    jlower(:,ii) = sum(j(:,1:p500-layoffset)');
    jmid(:,ii)   = sum(j(:,p500-layoffset+1 : tropi(JOB)-layoffset)');
    jupper(:,ii) = sum(j(:,tropi(JOB)-layoffset + 1 : numlay)');

  end

  addpath /home/sergio/MATLABCODE/REGR_PROFILES_SARTA/RUN_KCARTA/
  airs_convolve_file_numchans
  [fc,qclower] = convolve_airs(w,jlower,clist,sfile);
  [fc,qcmid] = convolve_airs(w,jmid,clist,sfile);
  [fc,qcupper] = convolve_airs(w,jupper,clist,sfile);

%% above is jac for 100% change (which starting from eg 370 is 37 ppmv change ... so what is it for 2.2 ppmv change??)
  qclowerx = qclower * (2.2./(370 * 1.0));
  qcmidx = qcmid * (2.2./(370 * 1.0));
  qcupperx = qcupper * (2.2./(370 * 1.0));
  plot(fc,qclowerx)
  plot(fc,qclowerx./(qclowerx(:,1)*ones(1,length(iaCO2)))); axis([640 2780 0.9 1.25])

  %% this is better way
  iaDelta = ones(length(qclowerx),1) * 2.2./(iaCO2 * 1.0);
  qclowerx = qclower .* iaDelta;
  qcmidx = qcmid .* iaDelta;
  qcupperx = qcupper .* iaDelta;
  figure(1); plot(fc,qclowerx); axis([640 840 -1e-1 +1e-1]);                      hl = legend(num2str(iaCO2'));title('Abs numbers for 2.2 ppmv change'); ylabel('dBT(K)');
  figure(2); plot(fc,qclowerx - qclowerx(:,1)*ones(1,length(iaCO2))); axis([640 840 -1e-2 +1e-2]); hl = legend(num2str(iaCO2'));title('Relative Jac(X)-Jac(370)');
  figure(3); plot(fc,qclowerx./(qclowerx(:,1)*ones(1,length(iaCO2)))); axis([640 840 0.75 1.25]);  hl = legend(num2str(iaCO2'));title('Ratio Jac(X)/Jac(370)');
  figure(4); plot(fc,100*(1-qclowerx./(qclowerx(:,1)*ones(1,length(iaCO2))))); axis([640 840 -25 +25]);  hl = legend(num2str(iaCO2'));title('Percent change in jac(X) to jac(370)');

  plot(fc,qclowerx + qcmidx + qcupperx)

  comment = ['use qclowerx,qcmidx,qcupperx which is normalized to deal with 2.2 ppm for varying (370:415) ppm'];
  saver = ['save CO2_370_385_400_415/co2_3layjac_2834_latbin' num2str(ll) '.mat fc qclower qclowerx qcmid qcmidx qcupper qcupperx iaCO2 comment'];
  eval(saver);

  for ii = 1 : 4; figure(ii); plotaxis2; end; pause(0.1)

end
