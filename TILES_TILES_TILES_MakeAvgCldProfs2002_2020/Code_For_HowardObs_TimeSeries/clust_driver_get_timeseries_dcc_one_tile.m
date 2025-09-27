%{
JOB = 1 : 4608;
lat = 1 + floor((JOB-1)/72);
lon = (JOB-1) - (lat-1)*72 + 1;
JOBB = (lat-1)*72 + lon;
plot(JOB-JOBB)
%}

addpath /home/sergio/MATLABCODE

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));  %% 1 - 4608
if length(JOB) == 0
  JOB = 2304;
end

latbin = 1 + floor((JOB-1)/72);
lonbin = (JOB-1) - (latbin-1)*72 + 1;

load latB64.mat
meanlat = meanvaluebin(latB2);

iNumYear = 23;
iDorA    = -1;   %% A == day
iLorOorA = 0;    %% all (land + ocean);

if iDorA == -1 & iLorOorA == 0
  fout = ['DCC_CNT/dcc_day_all_t' num2str(iNumYear,'%02i') '_' num2str(lonbin,'%02i') '_' num2str(latbin,'%02i') '.mat'];
else
  error('not coded');
end

maxlat = 30;
maxlat = 10;
maxlat = 20;
iDo = -1;
if abs(meanlat(latbin)) <= maxlat
  iDo = +1;
else
  fprintf(1,'meanlat(latbin) = %8.5f \n',meanlat(latbin))
  error('not tropical')
end

if ~exist(fout) & iDo > 0
  x = driver_get_timeseries_dcc_one_tile(latbin,lonbin,iNumYear,iDorA,iLorOorA);
  saver = ['save ' fout '  x maxlat iNumYear iLorOorA iDorA'];
  eval(saver)
  fprintf(1,'DONE %s \n',saver);
end
