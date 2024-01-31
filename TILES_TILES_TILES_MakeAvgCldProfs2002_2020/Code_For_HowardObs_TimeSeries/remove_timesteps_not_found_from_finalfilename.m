if ~exist('iQuiet')
  iQuiet = -1;
end

if iQuiet < 0
  disp(' ')
  disp(' >>>> entering remove_timesteps_not_found_from_finalfilename.m')
end

hugedir = dir('/asl/isilon/airs/tile_test7/');  %% about 460 timesteps till Nov 2023

iaFound = zeros(1,600);
for ii = 3 : length(hugedir)
  junk = hugedir(ii).name;
  junk = str2num(junk(end-2:end));
  iaFound(junk) = 1;
end
junk = find(iaFound == 1); 
junk = max(junk); 
maxN = junk; 
if iQuiet < 0
  fprintf(1,'max(iaFound) = %3i so can potentially save "summarystats_LatBin32_LonBin36_timesetps_001_%3i_V1.mat" \n',junk,junk);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

r16daysStepsX =      ((change2days(stopdate(1),stopdate(2),stopdate(3),2002) - change2days(startdate(1),startdate(2),startdate(3),2002))/16);
i16daysStepsX = floor((change2days(stopdate(1),stopdate(2),stopdate(3),2002) - change2days(startdate(1),startdate(2),startdate(3),2002))/16);
i16daysStepsX = round((change2days(stopdate(1),stopdate(2),stopdate(3),2002) - change2days(startdate(1),startdate(2),startdate(3),2002))/16);

ddd0 = change2days(2002,09,01,2002); %%%% == 244;
if change2days(startdate(1),startdate(2),startdate(3),2002) == ddd0
  if iQuiet < 0  
    fprintf(1,'  after using Start/Stop dates max(iaFound) = %3i and i16daysStepsX = %3i so will save "summarystats_LatBin32_LonBin36_timesetps_001_%03i_V1.mat" \n',maxN,i16daysStepsX,i16daysStepsX);
  end
  fsaveout_From_remove_timesteps_not_found_from_finalfilename = ['summarystats_LatBin32_LonBin36_timesetps_001_' num2str(i16daysStepsX,'%03i') '_V1.mat'];
  offset = 0;
else
  offset = floor((change2days(startdate(1),startdate(2),startdate(3),2002) - 244)/16);
  if iQuiet < 0  
    fprintf(1,'  after using Start/Stop dates max(iaFound) = %3i but need i16daysStepsX = %3i within that; so will save "summarystats_LatBin32_LonBin36_timesetps_%03i_%03i_V1.mat" \n',maxN,i16daysStepsX,1+offset,1+offset+i16daysStepsX);
  end
  fsaveout_From_remove_timesteps_not_found_from_finalfilename = ['summarystats_LatBin32_LonBin36_timesetps_' num2str(1+offset,'%03i') '_' num2str(1+offset+i16daysStepsX,'%03i') '_V1.mat'];  
end

maxN = i16daysStepsX;
fsaveout_From_remove_timesteps_not_found_from_finalfilename = ['summarystats_LatBin32_LonBin36_timesetps_' num2str(1+offset,'%03i') '_' num2str(1+offset+maxN,'%03i') '_V1.mat'];  

if iQuiet < 0  
  disp(' ')
  disp('need to check timespan from set_start_stop_dates');
  disp('these timesteps are not found TOTAL : '); 
  junk = find(iaFound(1:junk) == 0); printVariableLengthArray(junk);
else
  junk = find(iaFound(1:junk) == 0);
end

iTimeStepNotFound = 0;
  aha = find(junk <= i16daysStepsX);
  junk = junk(aha);
  if length(junk) > 0 & iQuiet < 0
    disp('did not find these timesteps within Start/Stop dates: '); 
    printVariableLengthArray(junk)
  end

if iQuiet < 0
  iTimeStepNotFound = length(junk);
  if iTimeStepNotFound == 0 
    fprintf(1,'timespan you want does NOT CONTAIN the missing timesteps so find %3i Sergio processed files \n',maxN - iTimeStepNotFound);
  else
    fprintf(1,'timespan you want DOES contain the %3i missing timesteps, so should only find %3i Sergio processed files \n',iTimeStepNotFound,maxN - iTimeStepNotFound);
  end

  disp(' >>>> leaving remove_timesteps_not_found_from_finalfilename.m')
  disp(' ')
else
  iTimeStepNotFound = length(junk);
end

