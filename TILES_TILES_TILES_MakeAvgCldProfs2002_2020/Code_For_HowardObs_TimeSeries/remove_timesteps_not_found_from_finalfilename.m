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
  fprintf(1,'max(iaFound) = %3i so can potentially save "summarystats_LatBin32_LonBin36_timesetps_001_%3i_V1.mat" \n',junk,junk);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

r16daysStepsX =      ((change2days(stopdate(1),stopdate(2),stopdate(3),2002) - change2days(startdate(1),startdate(2),startdate(3),2002))/16);
i16daysStepsX = floor((change2days(stopdate(1),stopdate(2),stopdate(3),2002) - change2days(startdate(1),startdate(2),startdate(3),2002))/16);
i16daysStepsX = round((change2days(stopdate(1),stopdate(2),stopdate(3),2002) - change2days(startdate(1),startdate(2),startdate(3),2002))/16);
fprintf(1,'  after using Start/Stop dates max(iaFound) = %3i and i16daysStepsX = %3i so will save "summarystats_LatBin32_LonBin36_timesetps_001_%3i_V1.mat" \n',maxN,i16daysStepsX,i16daysStepsX);
maxN = i16daysStepsX;

disp(' ')
disp('need to check timespan from set_start_stop_dates');
disp('these timesteps are not found TOTAL : '); junk = find(iaFound(1:junk) == 0)
iTimeStepNotFound = 0;
  aha = find(junk <= i16daysStepsX);
  junk = junk(aha);
  disp('did not find these timesteps within Start/Stop dates: '); junk
iTimeStepNotFound = length(junk);
fprintf(1,'so should only find %3i Sergio processed files \n',maxN - iTimeStepNotFound);
