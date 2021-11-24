clear all
load CLO_Anomaly137_16_12p8/RESULTS/kcarta_094_M_TS_jac_all_5_97_97_97_2235.mat

boo = squeeze(M_TS_jac_all(20,:,:));
addpath /home/sergio/MATLABCODE/CRIS_Hi2Lo
[head,rout] = translate_hi2lo(f,boo);
whos

%{
  M_TS_jac_all        38x2235x297            201793680  double
  ans                  1x92                        184  char
  boo               2235x297                   5310360  double
  f                 2235x1                       17880  double
  head                 1x1                       21424  struct
  qrenorm              1x297                      2376  double
  rout              1317x297                   1564596  single
  str1                 1x9                        1084  cell
  str2                 1x75                        150  char
%}


plot(f,boo(:,1),'b.-',head.vchan,rout(:,1),'rx-')  %% CO2
plot(f,boo(:,3),'b.-',head.vchan,rout(:,3),'rx-')  %% CH4
