if ~exist('iQAX')
  disp('setting iQAX from set_iQAX')
  set_iQAX
end

numdone = nan(72,64);

%% should be looking for 
%%  ../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin33/LonBin72//iQAX_4_summarystats_LatBin33_LonBin72_timesetps_001_502_V1.mat already exists
%%  ../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin33//iQAX_4_summarystats_LatBin33_LonBin_1_72_timesetps_001_499_V1.mat already exists

disp('looping over 64 latbins (inner loop = 72 lonbins)');
for jj = 1 : 64      %% latitude
  if mod(jj,10) == 0
    fprintf(1,'+');
  else
    fprintf(1,'.');
  end
  for ii = 1 : 72    %% longitude
    JOB = (jj-1)*72 + ii;
    x = translator_wrong2correct(JOB);

    if iQAX == 1
      %% orig wrong
      %% fdirIN  = ['../DATAObsStats_StartSept2002/LatBin' num2str(x.wrong2correct_I_J_lon_lat(2),'%02i') '/LonBin' num2str(x.wrong2correct_I_J_lon_lat(1),'%02i') '/'];
      %% fdirOUT = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(ii,'%02i') '/LonBin' num2str(jj,'%02i') '/'];

      %% new, since "translator_wrong2correct" shows x/y=lon/lat, so lat=index(2) while lon=index(1)
      fdirIN  = ['../DATAObsStats_StartSept2002/LatBin' num2str(x.wrong2correct_I_J_lon_lat(2),'%02i') '/LonBin' num2str(x.wrong2correct_I_J_lon_lat(1),'%02i') '/'];
      fdirOUT = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];

    elseif iQAX == 3
      %% new, since "translator_wrong2correct" shows x/y=lon/lat, so lat=index(2) while lon=index(1)
      fdirIN  = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(x.wrong2correct_I_J_lon_lat(2),'%02i') '/LonBin' num2str(x.wrong2correct_I_J_lon_lat(1),'%02i') '/'];
      fdirOUT = ['../DATAObsStats_StartSept2002_CORRECT_LatLon_v3/Extreme/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];

      %% new, since "translator_wrong2correct" shows x/y=lon/lat, so lat=index(2) while lon=index(1)
      fdirIN  = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(x.wrong2correct_I_J_lon_lat(2),'%02i') '/LonBin' num2str(x.wrong2correct_I_J_lon_lat(1),'%02i') '/'];
      fdirOUT = ['../DATAObsStats_StartSept2002_CORRECT_LatLon_v3/Mean/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];

    elseif iQAX == 4
      %% new, since "translator_wrong2correct" shows x/y=lon/lat, so lat=index(2) while lon=index(1)
      fdirIN  = ['../DATAObsStats_StartSept2002_v4/LatBin' num2str(x.wrong2correct_I_J_lon_lat(2),'%02i') '/LonBin' num2str(x.wrong2correct_I_J_lon_lat(1),'%02i') '/'];
      fdirOUT = ['../DATAObsStats_StartSept2002_CORRECT_LatLon_v4/Mean/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];
      fdirOUT = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/iQAX_' num2str(iQAX) '_summarystats_LatBin' num2str(jj,'%02i') '_LonBin' num2str(ii,'%02i') '_timesetps_'];
    end

    thedir = dir([fdirIN '/*.mat']);
    thedir = dir([fdirOUT '*.mat']);
    numdone(ii,jj) = length(thedir);
  end        
  figure(1); clf; imagesc(numdone'); colormap jet; colorbar; pause(0.1);
end
fprintf(1,'\n');
figure(1); clf; imagesc(numdone'); colormap jet; colorbar
fprintf(1,'looked for files of the form %s \n',[fdirIN '/*.mat'])
fprintf(1,'looked for files of the form %s \n',[fdirOUT '/*.mat'])
fprintf(1,'of 4608 files that should have been translated, %4i have been done \n',sum(numdone(:)))
printarray([1:64; sum(numdone,1)],'this is summing over 72 lonbins to find how many done per latbin');
