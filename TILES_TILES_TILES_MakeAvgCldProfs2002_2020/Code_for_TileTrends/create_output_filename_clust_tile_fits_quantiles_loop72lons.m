% Create outputfile name and save
if iQAX == 1
  if sum(startdate - [2002 09 01]) == 0 & i16daysSteps == i16daysStepsX
    fnout = sprintf('LatBin%1$02d/LonBin%2$02d/fits_LonBin%2$02d_LatBin%1$02d_V1_TimeSteps%3$03d.mat',lati,loni,i16daysSteps);
  else
    fnout = ['LatBin' num2str(lati,'%02d') '/LonBin' num2str(loni,'%02d') '/fits_LonBin' num2str(loni,'%02d') '_LatBin' num2str(lati,'%02d') '_V1_'];
    %fnout = [fnout    num2str(startdate,'%04d') '_' num2str(stopdate,'%04d')  '_TimeStepsX' num2str(i16daysStepsX,'%03d')];
    fnout = [fnout    num2str(startdate,'%04d') '_' num2str(stopdate,'%04d')  '_TimeSteps_' num2str(1+offset,'%03i') '_' num2str(1+offset+i16daysStepsX,'%03i') '_X' num2str(i16daysStepsX,'%03d')];
  end
elseif iQAX == 3
  if sum(startdate - [2002 09 01]) == 0 & i16daysSteps == i16daysStepsX
    fnout = sprintf('LatBin%1$02d/LonBin%2$02d/iQAX_3_fits_LonBin%2$02d_LatBin%1$02d_V1_TimeSteps%3$03d.mat',lati,loni,i16daysSteps);
  else
    fnout = ['LatBin' num2str(lati,'%02d') '/LonBin' num2str(loni,'%02d') '/iQAX_3_fits_LonBin' num2str(loni,'%02d') '_LatBin' num2str(lati,'%02d') '_V1_'];
    %fnout = [fnout    num2str(startdate,'%04d') '_' num2str(stopdate,'%04d')  '_TimeStepsX' num2str(i16daysStepsX,'%03d')];
    fnout = [fnout    num2str(startdate,'%04d') '_' num2str(stopdate,'%04d')  '_TimeSteps_' num2str(1+offset,'%03i') '_' num2str(1+offset+i16daysStepsX,'%03i') '_X' num2str(i16daysStepsX,'%03d')];
  end
elseif iQAX == 4
  if sum(startdate - [2002 09 01]) == 0 & i16daysSteps == i16daysStepsX
    fnout = sprintf('LatBin%1$02d/LonBin%2$02d/iQAX_4_fits_LonBin%2$02d_LatBin%1$02d_V1_TimeSteps%3$03d.mat',lati,loni,i16daysSteps);
  else
    fnout = ['LatBin' num2str(lati,'%02d') '/LonBin' num2str(loni,'%02d') '/iQAX_4_fits_LonBin' num2str(loni,'%02d') '_LatBin' num2str(lati,'%02d') '_V1_'];
    %fnout = [fnout    num2str(startdate,'%04d') '_' num2str(stopdate,'%04d')  '_TimeStepsX' num2str(i16daysStepsX,'%03d')];
    fnout = [fnout    num2str(startdate,'%04d') '_' num2str(stopdate,'%04d')  '_TimeSteps_' num2str(1+offset,'%03i') '_' num2str(1+offset+i16daysStepsX,'%03i') '_X' num2str(i16daysStepsX,'%03d')];
  end
else
  error('unknown iQAX')
end
