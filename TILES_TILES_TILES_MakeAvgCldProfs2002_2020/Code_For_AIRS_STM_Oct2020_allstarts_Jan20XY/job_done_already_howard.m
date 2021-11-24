%{
-rw-rw-r-- 1 sergio pi_strow 19661538 Sep 12 22:40 DATA/pall_16daytimestep_001_2013_01_01_to_2013_01_16_1.mat
-rw-rw-r-- 1 sergio pi_strow 19738766 Sep 12 22:40 DATA/pall_16daytimestep_002_2013_01_17_to_2013_02_01_2.mat
-rw-rw-r-- 1 sergio pi_strow 19569330 Sep 14 14:32 DATA/pall_16daytimestep_003_2013_02_02_to_2013_02_17_3.mat
-rw-rw-r-- 1 sergio pi_strow 19636047 Sep 14 07:05 DATA/pall_16daytimestep_004_2013_02_18_to_2013_03_05_4.mat
-rw-rw-r-- 1 sergio pi_strow 19686680 Sep 14 07:06 DATA/pall_16daytimestep_005_2013_03_06_to_2013_03_21_5.mat
-rw-rw-r-- 1 sergio pi_strow 19658039 Sep 14 07:05 DATA/pall_16daytimestep_006_2013_03_22_to_2013_04_06_6.mat
-rw-rw-r-- 1 sergio pi_strow 19601712 Sep 14 07:06 DATA/pall_16daytimestep_007_2013_04_07_to_2013_04_22_7.mat
-rw-rw-r-- 1 sergio pi_strow 19582907 Sep 14 07:18 DATA/pall_16daytimestep_008_2013_04_23_to_2013_05_08_8.mat
-rw-rw-r-- 1 sergio pi_strow 19564841 Sep 14 07:20 DATA/pall_16daytimestep_009_2013_05_09_to_2013_05_24_9.mat
-rw-rw-r-- 1 sergio pi_strow 19559394 Sep 14 07:11 DATA/pall_16daytimestep_010_2013_05_25_to_2013_06_09_10.mat
-rw-rw-r-- 1 sergio pi_strow 19619670 Sep 12 22:07 DATA/pall_16daytimestep_011_2013_06_10_to_2013_06_25_11.mat
-rw-rw-r-- 1 sergio pi_strow 19571432 Sep 14 07:16 DATA/pall_16daytimestep_012_2013_06_26_to_2013_07_11_12.mat
-rw-rw-r-- 1 sergio pi_strow 19581815 Sep 14 07:20 DATA/pall_16daytimestep_013_2013_07_12_to_2013_07_27_13.mat
-rw-rw-r-- 1 sergio pi_strow 19577181 Sep 14 07:08 DATA/pall_16daytimestep_014_2013_07_28_to_2013_08_12_14.mat
-rw-rw-r-- 1 sergio pi_strow 19602076 Sep 13 17:57 DATA/pall_16daytimestep_015_2013_08_13_to_2013_08_28_15.mat
-rw-rw-r-- 1 sergio pi_strow 19565873 Sep 14 07:09 DATA/pall_16daytimestep_016_2013_08_29_to_2013_09_13_16.mat
-rw-rw-r-- 1 sergio pi_strow 19568025 Sep 14 07:14 DATA/pall_16daytimestep_017_2013_09_14_to_2013_09_29_17.mat
-rw-rw-r-- 1 sergio pi_strow 19573192 Sep 14 07:23 DATA/pall_16daytimestep_018_2013_09_30_to_2013_10_15_18.mat
-rw-rw-r-- 1 sergio pi_strow 19551909 Sep 14 07:19 DATA/pall_16daytimestep_019_2013_10_16_to_2013_10_31_19.mat
-rw-rw-r-- 1 sergio pi_strow 19572197 Sep 14 07:19 DATA/pall_16daytimestep_020_2013_11_01_to_2013_11_16_20.mat
-rw-rw-r-- 1 sergio pi_strow 19557521 Sep 14 07:24 DATA/pall_16daytimestep_021_2013_11_17_to_2013_12_02_21.mat
-rw-rw-r-- 1 sergio pi_strow 19639273 Sep 12 22:09 DATA/pall_16daytimestep_022_2013_12_03_to_2013_12_18_22.mat
-rw-rw-r-- 1 sergio pi_strow 19640664 Sep 12 22:08 DATA/pall_16daytimestep_023_2013_12_19_to_2013_12_31_23.mat
%}

iNotFound = 0;
iMax = 365; %% Sept 2018
iMax = 414; %% Sept 2020
for ii = 16 : iMax
  JOB0 = ii;
  JOB  = ii;
  yy0 = floor((JOB-1)/23) + 2002;
  JOB = JOB-(yy0-2002)*23;

  fname = ['DATA/pall_16daytimestep_' num2str(JOB,'%03i') '_' num2str(yy0,'%4i') '_*.mat'];
  oo = dir(fname);
  if length(oo) > 0
    havefound(ii) = 1;
  else
    iNotFound = iNotFound + 1;
    havefound(ii) = 0;
    missing(iNotFound) = ii;
  end
end

havefound = havefound(16:end); %% the first 15 are automatically gonna be 0 since they are 2002/02/01 to 2002/08/25
fprintf(1,'found %3i of %3i files \n',sum(havefound),iMax-15+1);

if iNotFound > 0
  fprintf(1,'have not done %3i files \n',iNotFound)
  miaow = missing;
  fid = fopen('notfound.txt','w');
  for jj = 1 : length(miaow)
    fprintf(fid,'%3i \n',miaow(jj));
  end
  fclose(fid);
end
