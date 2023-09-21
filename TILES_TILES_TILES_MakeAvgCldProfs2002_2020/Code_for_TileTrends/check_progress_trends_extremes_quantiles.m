disp('Enter (1) for Q1-16 2002/09 to 2020/08 == orig, re-done by Sergio');
disp('      (3) for extremes 2002/09 to 2021/08 == new')
disp('      (-1,-2,-3,-4) : seasonal DJF/MAM/JJA/SON')
disp('      (10) for anomalies')
iType = input('enter choice : ');

iNumTmeSteps = input('Enter number timesteps eg 412, 429, [default] 457 : ');
if length(iNumTmeSteps) == 0
  iNumTmeSteps = 457;
end
tstr = num2str(iNumTmeSteps);

addpath /home/sergio/MATLABCODE

figure(1); clf; colormap(jet);

found_tile_trends_quantiles_extremes = zeros(64,72);
clear job_notdone
iCnt = 0;
disp(' + for 10, . for one :: all the way to 64 latbins')
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
      fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_TimeSteps' tstr '.mat'];
    elseif iType == -1
      %% ls -lt ../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin*/LonBin*/iQAX_3_fits_LonBin*DJF* | wc -l    
      fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/iQAX_3_fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_TimeSteps' tstr '_DJF.mat'];
    elseif iType == -2
      %% ls -lt ../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin*/LonBin*/iQAX_3_fits_LonBin*MAM* | wc -l    
      fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/iQAX_3_fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_TimeSteps' tstr '_MAM.mat'];
    elseif iType == -3
      %% ls -lt ../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin*/LonBin*/iQAX_3_fits_LonBin*JJA* | wc -l    
      fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/iQAX_3_fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_TimeSteps' tstr '_JJA.mat'];
    elseif iType == -4
      %% ls -lt ../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin*/LonBin*/iQAX_3_fits_LonBin*SON* | wc -l    
      fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/iQAX_3_fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_TimeSteps' tstr '_SON.mat'];
    elseif iType == 10
       %% ls -lt ../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin04/LonBin54/iQAX_3_fits_LonBin54_LatBin04_V1_200200090001_202200080031_Anomaly_TimeStepsX457.mat
       %% ls -lt ../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin*/LonBin*/iQAX_3_fits_LonBin*_LatBin*_V1_200200090001_202200080031_Anomaly_TimeStepsX457.mat
      fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d')];
      fname = [fname '/iQAX_3_fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_200200090001_202200080031_Anomaly_TimeStepsX' tstr '.mat'];
    end
    if exist(fname)
      found_tile_trends_quantiles_extremes(jj,ii) = +1;
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
  str = [' sergio_matlab_jobB.sbatch 1'];
  %% going to call individual processors to do individual profiles
  fprintf(fid,'%s \n',str);
  fclose(fid);
  disp(' ')
end
