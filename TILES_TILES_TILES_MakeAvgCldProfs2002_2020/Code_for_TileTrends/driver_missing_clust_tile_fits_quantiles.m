iaFound = ones(1,4608) * -1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% see clust_tile_fits_quantiles.m

%% Strows stuff (run from his dir)
fdirpre      = '/home/strow/Work/Airs/Tiles/Data/Quantv1';        %% symbolic link to /home/strow/Work/Airs/Tiles/Data/Quantv1 -> /asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_CORRECT_LatLon
fdirpre_out  = '/home/strow/Work/Airs/Tiles/Data/Quantv1_fits';
i16daysSteps = 412;   %% 2002/09 to 2020/08

%% Sergio stuff (run from my dir)
fdirpre      = '../DATAObsStats_StartSept2002_CORRECT_LatLon/';   %% symbolic link to ./DATAObsStats_StartSept2002_CORRECT_LatLon -> /asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_CORRECT_LatLon
fdirpre_out  = '../DATAObsStats_StartSept2002_CORRECT_LatLon/';

startdate = [2002 09 01]; stopdate = [2020 08 31]; i16daysSteps = 412;                       %% 2002/09 to 2020/08, testing that I get same results as Larrabee
startdate = [2002 09 01]; stopdate = [2021 06 31]; i16daysSteps = 429;                       %% 2002/09 to 2021/06
startdate = [2002 09 01]; stopdate = [2021 07 31]; i16daysSteps = 431;                       %% 2002/09 to 2021/07
startdate = [2002 09 01]; stopdate = [2021 08 31]; i16daysSteps = 433;                       %% 2002/09 to 2021/08  **********
startdate = [2002 09 01]; stopdate = [2014 08 31]; i16daysSteps = 273; i16daysSteps = 433;   %% 2002/09 to 2014/09, but use this extended period

startdate = [2002 09 01]; stopdate = [2021 08 31]; 
startdate = [2005 01 01]; stopdate = [2014 12 31];  % Joao wants 10 years
startdate = [2003 01 01]; stopdate = [2012 12 31];  % Joao wants 10 years
startdate = [2002 09 01]; stopdate = [2014 08 31];  % overlap with CMIP6/AMIP6

i16daysStepsX = floor((change2days(stopdate(1),stopdate(2),stopdate(3),2002) - change2days(startdate(1),startdate(2),startdate(3),2002))/16);

for JOB=1:4608
  lati = floor((JOB-1)/72)+1;  loni = JOB-(lati-1)*72;  fprintf(1,'JOB,lati,loni : %4i %3i %3i \n',JOB,lati,loni)
  if sum(startdate - [2002 09 01]) == 0 & i16daysSteps == i16daysStepsX
    fnout = sprintf('LatBin%1$02d/LonBin%2$02d/fits_LonBin%2$02d_LatBin%1$02d_V1_TimeSteps%3$03d.mat',lati,loni,i16daysSteps);
  else
    fnout = ['LatBin' num2str(lati,'%02d') '/LonBin' num2str(loni,'%02d') '/fits_LonBin' num2str(loni,'%02d') '_LatBin' num2str(lati,'%02d') '_V1_'  num2str(startdate,'%04d') '_' num2str(stopdate,'%04d')  '_TimeStepsX' num2str(i16daysStepsX,'%03d')];
  end
  fnout = fullfile(fdirpre_out,fnout);
  fnout = [fnout '.mat'];
  if ~exist(fnout)
    iaFound(JOB) = -1;
  else  
    iaFound(JOB) = +1;
  end
end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

baddy = find(iaFound <= 0);
if length(baddy) > 0
  excludelist = 'cnode013,cnode018,cnode019';
  excludelist = ' ';

  fid = fopen('missing_tile_fits_quantiles.sc','w');

  %for ii = 1 : length(baddy)
  %  str = ['sbatch -p high_mem  --exclude=' excludelist ' --array=' num2str(baddy(ii)) ' sergio_matlab_jobB.sbatch 10'];
  %  fprintf(fid,'%s \n',str);
  %end

  fprintf(1,'found that %5i of 4608 did not finish : see missing_tile_fits_quantiles.sc \n',length(baddy))
  str = ['sbatch -p high_mem --exclude=' excludelist ' --array='];
  fprintf(fid,'%s',str);
  iX = nice_output(fid,baddy);   %% now put in continuous strips
  fprintf(1,'length(badanom) = %4i Num Continuous Strips = %4i \n',length(baddy),iX)
  str = [' sergio_matlab_jobB.sbatch 1'];
  fprintf(fid,'%s \n',str);

  fclose(fid);
  disp('look at missing_tile_fits_quantiles.sc : if too many processes you can edit it and split it between eg cpu2021 and high_mem');
else
  disp('all 4608 files found')
end
