addpath /home/sergio/MATLABCODE/MODIS_CLOUD/

%% there are 264 months so far (22 years since 2002/08 :  22 x 12 = 264)
JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
if length(JOB) == 0
  % JOB = 1;
  JOB = 20;
end

%% see /home/sergio/MATLABCODE_Git/MODIS_CLOUD/modis_l3_fieldnames.mat which is symbolically linked here
fname =  '/asl/s1/sergio/MODIS_MONTHLY_L3/AEROSOL/DATA/2024/MYD08_M3.A2024153.061.2024187025207.hdf';

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
    dir0 = ['/asl/s1/sergio/MODIS_MONTHLY_L3/AEROSOL/DATA/' num2str(yy) '/'];
    fname = ['MYD08_M3.A' num2str(yy) num2str(days(mm),'%03d')];
    ee(yy-2002+1,mm) = length(dir([dir0 fname '*.hdf']));    
    if ee(yy-2002+1,mm) == 0
      fprintf(1,'%4i/%2i %s DNE \n',yy,mm,[dir0 fname '*.hdf'])
    else
      junk = dir([dir0 fname '*.hdf']);
      thefile = [dir0 junk.name];
      dd = days(mm);

      if JOB == iCnt
        summary = driver_read_modis_aerosol_monthly_L3(thefile);
        savematname = ['/asl/s1/sergio/MODIS_MONTHLY_L3/AEROSOL/SUMMARY_MAT/modisL3aerosol_' num2str(yy) '_' num2str(mm,'%02d') '.mat'];
        if ~exist(savematname)
          fprintf(1,'saving %s \n',savematname)
          saver = ['save ' savematname ' summary yy mm dd'];
          eval(saver)
        else
          fprintf(1,'not saving %s as it already exists\n',savematname)
        end    %%% exist(savematname)
      disp('exiting')
      return
      end         %%% if JOB == iCnt

    end           %%% exist file
  end             %%% mm loop
end               %%% nn loop
