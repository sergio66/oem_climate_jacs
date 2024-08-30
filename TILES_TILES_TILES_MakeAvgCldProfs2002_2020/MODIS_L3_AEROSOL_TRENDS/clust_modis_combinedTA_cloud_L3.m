addpath /home/sergio/MATLABCODE/MODIS_CLOUD/

%% there are 264 months so far (22 years since 2002/08 :  22 x 12 = 264)
JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
if length(JOB) == 0
  % JOB = 1;
  JOB = 20;
end

%% see /home/sergio/MATLABCODE_Git/MODIS_CLOUD/modis_l3_fieldnames.mat which is symbolically linked here
fname = '/asl/s1/sergio/MODIS_MONTHLY_L3/CombinedTerraAqua/DATA/2002/MCD06COSP_M3_MODIS.A2002213.062.2022168173309.nc';

%{
%% iaFound = check_all_jobs_done('/asl/s1/sergio/MODIS_MONTHLY_L3/AEROSOL/SUMMARY_MAT/modisL3_combinedTA_cloud_',270);  
iaFound = check_all_jobs_done_yymmS_yymmE('/asl/s1/sergio/MODIS_MONTHLY_L3/AEROSOL/SUMMARY_MAT/','modisL3_combinedTA_cloud_',[2002 09],[2024 06]);
%}

% [sergio@taki-usr2 MODIS_L3_AEROSOL_TRENDS]$ ls -lt /asl/s1/sergio/MODIS_MONTHLY_L3/CombinedTerraAqua/DATA/2011/
% total 841948
%- rw-rw-r-- 1 sergio pi_strow 67724603 Dec  9  2022 MCD06COSP_M3_MODIS.A2011335.062.2022168173609.nc
% -rw-rw-r-- 1 sergio pi_strow 70707276 Dec  9  2022 MCD06COSP_M3_MODIS.A2011305.062.2022168173608.nc
% -rw-rw-r-- 1 sergio pi_strow 75496819 Dec  9  2022 MCD06COSP_M3_MODIS.A2011274.062.2022168173606.nc
% -rw-rw-r-- 1 sergio pi_strow 76391549 Dec  9  2022 MCD06COSP_M3_MODIS.A2011244.062.2022168173557.nc
% -rw-rw-r-- 1 sergio pi_strow 72351394 Dec  9  2022 MCD06COSP_M3_MODIS.A2011213.062.2022168173550.nc
% -rw-rw-r-- 1 sergio pi_strow 68185650 Dec  9  2022 MCD06COSP_M3_MODIS.A2011182.062.2022168173550.nc
% -rw-rw-r-- 1 sergio pi_strow 67150791 Dec  9  2022 MCD06COSP_M3_MODIS.A2011152.062.2022168173549.nc
% -rw-rw-r-- 1 sergio pi_strow 70566516 Dec  9  2022 MCD06COSP_M3_MODIS.A2011121.062.2022168173559.nc
% -rw-rw-r-- 1 sergio pi_strow 74519382 Dec  9  2022 MCD06COSP_M3_MODIS.A2011091.062.2022168173546.nc
% -rw-rw-r-- 1 sergio pi_strow 76893906 Dec  9  2022 MCD06COSP_M3_MODIS.A2011060.062.2022168173547.nc
% -rw-rw-r-- 1 sergio pi_strow 72674740 Dec  9  2022 MCD06COSP_M3_MODIS.A2011032.062.2022168173541.nc
% -rw-rw-r-- 1 sergio pi_strow 69469879 Dec  9  2022 MCD06COSP_M3_MODIS.A2011001.062.2022168173550.nc

iCnt = 0;
for yy = 2002 : 2024
  days = [001 032 060 091 121 152 182 213 244 274 305 335];
  if mod(yy,4) == 0
    days(3:end) =  days(3:end) + 1;
  end
  mmS = 01; mmE = 12;
  if yy == 2002
    mmS = 09;
  elseif yy == 2024
    mmE = 06;
  end
  for mm = mmS : mmE
    iCnt = iCnt + 1;
    fprintf(1,'%3i %4i/%2i \n',iCnt,yy,mm)
    dir0 = ['/asl/s1/sergio/MODIS_MONTHLY_L3/CombinedTerraAqua/DATA/' num2str(yy) '/'];
    fname = ['MCD06COSP_M3_MODIS.A' num2str(yy) num2str(days(mm),'%03d')];
    ee(yy-2002+1,mm) = length(dir([dir0 fname '*.nc']));    
    if ee(yy-2002+1,mm) == 0
      fprintf(1,'%4i/%2i %s DNE \n',yy,mm,[dir0 fname '*.nc'])
    else
      junk = dir([dir0 fname '*.nc']);
      thefile = [dir0 junk.name];
      dd = days(mm);

      if JOB == iCnt
        summary = driver_read_modis_combinedTA_cloud_monthly_L3(thefile);
        savematname = ['/asl/s1/sergio/MODIS_MONTHLY_L3/AEROSOL/SUMMARY_MAT/modisL3_combinedTA_cloud_' num2str(yy) '_' num2str(mm,'%02d') '.mat'];
        if ~exist(savematname)
          fprintf(1,'saving %s \n',savematname)
          saver = ['save ' savematname ' summary yy mm dd'];
          eval(saver)
        else
          fprintf(1,'not saving %s as it already exists\n',savematname)
        end       %%% exist(savematname)
      disp('exiting')
      return
      end         %%% if JOB == iCnt

    end           %%% exist file
  end             %%% mm loop
end               %%% nn loop
