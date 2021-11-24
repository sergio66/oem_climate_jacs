%iCheckDone1 = input('Check whats been done (-1/+1) v1 makes up txt file for clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m with missing timesteps : ');
%iCheckDone1 = input('Check whats been done (-1/+1) v1 makes up txt file for clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m with missing timesteps : ');
%iCheckDone1 = input('Check whats been done (-1/+1) v1 makes up txt file for clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m with missing timesteps : ');

iCheckDone1 = input('Check whats been done (-1/+1) v1 makes up txt file for clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m with missing timesteps : ');
%iCheckDone1 = -1;
if iCheckDone1 > 0
  fid1 = fopen('notdone.txt','w');
  fid2 = fopen('notdoneINFO.txt','w');
  hugedir = dir('/asl/isilon/airs/tile_test7/');
  numALLdone = zeros(length(hugedir)-2,72,64);
  for tt = 1 : length(hugedir)-2
    numdone = zeros(72,64);    
    date_stamp = hugedir(tt+2).name;
    for jj = 1 : 64      %% latitude
      fprintf(1,'.');
      for ii = 1 : 72    %% longitude
        %% JOB = (jj-1)*72 + ii;
        %% x = translator_wrong2correct(JOB);  don't need this since we are not translating

        fdirIN  = ['../DATAObsStats_StartSept2002/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];     %% older, used for 16 quantiles
        thedir = dir([fdirIN '/stats_data_' date_stamp '.mat']);

        fdirIN  = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];  %% newer .. extremes and means
        %thedir = dir([fdirIN '/stats_data_v3_extreme_' date_stamp '.mat']);
        thedir = dir([fdirIN '/stats_data_v3_mean_' date_stamp '.mat']);

        if length(thedir) == 1
          if thedir.bytes > 0           
            numALLdone(tt,ii,jj) = 1;    
            numdone(ii,jj) = 1;           
          end
        end  %% if loop
      end    %% lon
    end      %% lat
    if sum(numdone(:)) < 72*64
      fprintf(fid1,'%4i \n',tt+2);
      fprintf(fid2,'%4i %s \n',tt+2,date_stamp);
    end
    fprintf(1,'JOB %4i datestamp %s done %4i \n',tt+2,date_stamp,sum(numdone(:)));
  end
  fclose(fid1);
  fclose(fid2);
end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%iCheckDone2 = input('Check whats been done (-1/+1) v2 : ');
iCheckDone2 = -1;
if iCheckDone2 > 0
  numdone = nan(72,64);
  for jj = 1 : 64      %% latitude
    fprintf(1,'.');
    for ii = 1 : 72    %% longitude
      JOB = (jj-1)*72 + ii;
      x = translator_wrong2correct(JOB);

%% orig wrong
%% fdirIN  = ['../DATAObsStats_StartSept2002/LatBin' num2str(x.wrong2correct_I_J_lon_lat(2),'%02i') '/LonBin' num2str(x.wrong2correct_I_J_lon_lat(1),'%02i') '/'];
%% fdirOUT = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(ii,'%02i') '/LonBin' num2str(jj,'%02i') '/'];

      %% new, since "translator_wrong2correct" shows x/y=lon/lat, so lat=index(2) while lon=index(1)
      fdirIN  = ['../DATAObsStats_StartSept2002/LatBin' num2str(x.wrong2correct_I_J_lon_lat(2),'%02i') '/LonBin' num2str(x.wrong2correct_I_J_lon_lat(1),'%02i') '/'];
      fdirOUT = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];

      %% new, since "translator_wrong2correct" shows x/y=lon/lat, so lat=index(2) while lon=index(1)
      fdirIN  = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(x.wrong2correct_I_J_lon_lat(2),'%02i') '/LonBin' num2str(x.wrong2correct_I_J_lon_lat(1),'%02i') '/'];
      fdirOUT = ['../DATAObsStats_StartSept2002_CORRECT_LatLon_v3/Extreme/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];

      %% new, since "translator_wrong2correct" shows x/y=lon/lat, so lat=index(2) while lon=index(1)
      fdirIN  = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(x.wrong2correct_I_J_lon_lat(2),'%02i') '/LonBin' num2str(x.wrong2correct_I_J_lon_lat(1),'%02i') '/'];
      fdirOUT = ['../DATAObsStats_StartSept2002_CORRECT_LatLon_v3/Mean/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];

      thedir = dir([fdirIN '/*.mat']);
      numdone(ii,jj) = length(thedir);    
    end        
    imagesc(numdone'); colormap jet; colorbar; pause(0.1);
  end
  fprintf(1,'\n');
  imagesc(numdone'); colormap jet; colorbar
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
