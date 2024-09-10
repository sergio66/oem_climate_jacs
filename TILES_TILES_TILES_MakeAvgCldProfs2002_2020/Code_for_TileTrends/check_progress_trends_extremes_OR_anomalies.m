disp('Enter (1) for Q1-16 TRENDS   2002/09 to 202X/08 == orig, re-done by Sergio');
disp('      (3)  for extremes      2002/09 to 202X/08 == new    ')
disp('      (13) for first 8 years 2002/09 to 2010/08 == new    183 steps')
disp('      (14) for last  4 years 2018/09 to 2022/08 == new    091 steps')
disp('      (15) for mid  14 years 2008/01 to 2022/12 == new    342 steps')
disp('      (-1,-2,-3,-4) : seasonal DJF/MAM/JJA/SON for 2002/09 to 2022/08')
disp('    ')
disp('      (10) for anomalies     2002/09 to 202X/08 ')
iType = input('enter choice : ');

iQuantileSubset = input('Enter style of Quantiles (1,3,4), 3 = default  where eg 3 = [0.5 0.8 0.9 0.95 0.97 1.0] and 4 = [0 0.03 0.5 0.97 1] : ');
if length(iQuantileSubset) == 0
  iQuantileSubset = 3;
end


iNumTmeSteps = input('Enter number timesteps eg 412, 429, 457, [default] 502 : ');
if length(iNumTmeSteps) == 0
  iNumTmeSteps = 502;
end
tstr = num2str(iNumTmeSteps);

addpath /home/sergio/MATLABCODE

figure(1); clf; colormap(jet);

found_tile_trends_quantiles_extremes = zeros(64,72);
clear job_notdone
iCnt = 0;
disp(' + for 10, . for one :: all the way to 64 latbins ... this loops though 72 lonbins as well ')
for jj = 1 : 64
  if mod(jj,10) == 0
    fprintf(1,'+');
  else
    fprintf(1,'.');
  end

  for ii = 1 : 72

    if iType == 3
      fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon_v3/Extreme/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/extreme_fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_TimeSteps' tstr '.mat'];
    elseif iType == 1
      fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d')        '/fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_TimeSteps' tstr '.mat'];
      fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/iQAX_' num2str(iQuantileSubset) '_fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_TimeSteps' tstr '.mat'];

    elseif iType == -1
      %% ls -lt ../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin*/LonBin*/iQAX_' num2str(iQuantileSubset) '_fits_LonBin*DJF* | wc -l    
      fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/iQAX_' num2str(iQuantileSubset) '_fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_TimeSteps' tstr '_DJF.mat'];
    elseif iType == -2
      %% ls -lt ../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin*/LonBin*/iQAX_' num2str(iQuantileSubset) '_fits_LonBin*MAM* | wc -l    
      fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/iQAX_' num2str(iQuantileSubset) '_fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_TimeSteps' tstr '_MAM.mat'];
    elseif iType == -3
      %% ls -lt ../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin*/LonBin*/iQAX_' num2str(iQuantileSubset) '_fits_LonBin*JJA* | wc -l    
      fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/iQAX_' num2str(iQuantileSubset) '_fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_TimeSteps' tstr '_JJA.mat'];
    elseif iType == -4
      %% ls -lt ../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin*/LonBin*/iQAX_' num2str(iQuantileSubset) '_fits_LonBin*SON* | wc -l    
      fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/iQAX_' num2str(iQuantileSubset) '_fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_TimeSteps' tstr '_SON.mat'];

    elseif iType == 10
       %% ls -lt ../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin04/LonBin54/iQAX_' num2str(iQuantileSubset) '_fits_LonBin54_LatBin04_V1_200200090001_202200080031_Anomaly_TimeStepsX457.mat
       %% ls -lt ../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin*/LonBin*/iQAX_' num2str(iQuantileSubset) '_fits_LonBin*_LatBin*_V1_200200090001_202200080031_Anomaly_TimeStepsX457.mat
      fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d')];
      if iNumTmeSteps == 457
        % 2002/09 to 2022/08
        fname = [fname '/iQAX_' num2str(iQuantileSubset) '_fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_200200090001_202200080031_Anomaly_TimeStepsX' tstr '.mat'];
      elseif iNumTmeSteps == 498
        % 2002/09 to 2024/06
        %fname = [fname '/iQAX_' num2str(iQuantileSubset) '_fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_200200090001_202400060031_Anomaly_TimeStepsX' tstr '.mat'];
        fname = [fname '/iQAX_' num2str(iQuantileSubset) '_fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_Anomaly_TimeSteps' tstr '.mat'];
      elseif iNumTmeSteps == 502
        % 2002/09 to 2024/08
        %fname = [fname '/iQAX_' num2str(iQuantileSubset) '_fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_200200090001_202400060031_Anomaly_TimeStepsX' tstr '.mat'];
        fname = [fname '/iQAX_' num2str(iQuantileSubset) '_fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_Anomaly_TimeSteps' tstr '.mat'];
      end

    elseif iType == 13
      fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d')];
      fname = [fname '/iQAX_4_fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_200200090001_201000080031_TimeStepsX' tstr '.mat'];
    elseif iType == 14
      fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d')];
      fname = [fname '/iQAX_' num2str(iQuantileSubset) '_fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_201800090001_202200080031_TimeSteps_366_457_X091.mat'];
    elseif iType == 15
      fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d')];
      fname = [fname '/iQAX_' num2str(iQuantileSubset) '_fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_200800010001_202200120031_TimeSteps_122_464_X342.mat'];
    end

    if exist(fname)
      kachunk = dir(fname);
      found_tile_trends_quantiles_size(jj,ii) = kachunk.bytes;
      if kachunk.bytes > 0
        found_tile_trends_quantiles_extremes(jj,ii) = +1;
      else
        iCnt = iCnt + 1;
        job_notdone(iCnt,:) = [ii jj    ii+(jj-1)*72];
        fprintf(1,'%s size 0 bytes \n',fname);
      end
    else
      iCnt = iCnt + 1;
      job_notdone(iCnt,:) = [ii jj    ii+(jj-1)*72];
    end
  end
  figure(1); clf; imagesc(found_tile_trends_quantiles_extremes); colorbar; pause(0.1); xlabel('LonBin'); ylabel('LatBin')
end
fprintf(1,'\n');
fprintf(1,'looked for files ~ %s \n',fname);
sum(found_tile_trends_quantiles_extremes(:))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if iCnt > 0
%   disp('some tiles not processed .. see notdone.txt')
%   fid = fopen('notdone.txt','w');
%
%   %fprintf(fid,'ii=LonBin   jj=LatBin    JOB=ii+(jj-1)*72');
%   %fprintf(fid,'%4i %4i %4i\n',job_notdone);
%
%   fprintf(fid,'%4i\n',job_notdone(:,3));
%   fclose(fid);
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if iCnt > 0
  baddy = job_notdone(:,3);

  fid = fopen('notdone_filelist.sc','w');
  fprintf(1,'found that %4i of %4i timesteps did not finish : see notdone_filelist.sc \n',length(baddy),72*64)
  str = ['sbatch --account=pi_strow  --exclude=cnode[204,225,267] --array='];
  str = ['sbatch --account=pi_strow   -p cpu2021 --array='];
  str = ['sbatch --account=pi_strow   -p high_mem --array='];
  fprintf(fid,'%s',str);
  iX = nice_output(fid,baddy);   %% now put in continuous strips
  fprintf(1,'length(badanom) = %4i Num Continuous Strips = %4i \n',length(baddy),iX)
  str = [' sergio_matlab_jobB.sbatchX Y'];
  %% going to call individual processors to do individual profiles
  fprintf(fid,'%s \n',str);
  fclose(fid);
  disp(' ')
  disp('now check notdone_filelist.sc and change "sergio_matlab_jobB.sbatchX Y" to eg "sergio_matlab_jobB.sbatch 10"  ')
end
