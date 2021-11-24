iType = input('Enter (-1) for Q1-16 2002/09 to 2020/08 == orig, re-done by Sergio (2) for Q1-16 2002/09 to 2021/08 == new  (3) for extremes 2002/09 to 2021/08 == new : ');

figure(1); clf; colormap(jet);

found_tile_trends_quantiles_extremes = zeros(64,72);
clear job_notdone
iCnt = 0;
for jj = 1 : 64
  fprintf(1,'.');
  for ii = 1 : 72

    if iType == 3
      fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon_v3/Extreme/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/extreme_fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_TimeSteps429.mat'];
    elseif iType == 2
      fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_TimeSteps429.mat'];
    elseif iType == -1
      fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_TimeSteps412.mat'];
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

if iCnt > 0
  disp('some tiles not processed .. see notdone.txt')
  fid = fopen('notdone.txt','w');
  fprintf(fid,'ii=LonBin   jj=LatBin    JOB=ii+(jj-1)*72');
  fprintf(fid,'%4i %4i %4i\n',job_notdone);
  fclose(fid);
end
