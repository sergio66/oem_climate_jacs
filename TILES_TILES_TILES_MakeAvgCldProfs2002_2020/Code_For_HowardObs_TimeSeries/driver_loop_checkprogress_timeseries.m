set_iQAX
if iQAX == 1
  disp('iQAX == 1 so looking for regular quantiles   quants = [0 0.01 0.02 0.03 0.04 0.05 0.10 0.25 0.50 0.75 0.9 0.95 0.96 0.97 0.98 0.99 1.00]')
elseif iQAX == 3
  disp('iQAX == 3 so looking for newer   quantiles   quants = [0.50 0.80 0.90 0.95 0.97 1.00]')
elseif iQAX == 0
  disp('iQAX == 0 so looking for quantiles and extreme')
elseif iQAX == -1
  disp('iQAX == -1 so looking for extreme')
elseif iQAX == 2
  disp('iQAX == 2 so looking for mean')
else
  error('iQAX')
end

%iCheckDone1 = input('Check whats been done (-1/+1) v1 makes up txt file for clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m with missing timesteps : ');
%iCheckDone1 = input('Check whats been done (-1/+1) v1 makes up txt file for clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m with missing timesteps : ');
%iCheckDone1 = input('Check whats been done (-1/+1) v1 makes up txt file for clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m with missing timesteps : ');

iCheckDone1 = input('Check whats been done (-1/+1 default) v1 makes up txt file for clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m with missing timesteps : ');
if length(iCheckDone1) == 0
  iCheckDone1 = +1;
end
if iCheckDone1 > 0
  fid1 = fopen('notdone.txt','w');
  fid2 = fopen('notdoneINFO.txt','w');
  hugedir = dir('/asl/isilon/airs/tile_test7/');
  if ~exist('numALLdone')
    numALLdone = zeros(length(hugedir)-2,72,64);
  end
  for tt = 1 : length(hugedir)-2
%%  for tt = 1 : 460
    wahoo = squeeze(numALLdone(tt,:,:));
    wahoo = sum(wahoo(:));
    if wahoo < 4608

      numdone = zeros(72,64);    
      date_stamp = hugedir(tt+2).name;
      for jj = 1 : 64      %% latitude
        fprintf(1,'.');
        for ii = 1 : 72    %% longitude
  
          %% JOB = (jj-1)*72 + ii;
          %% x = translator_wrong2correct(JOB);  don't need this since we are not translating
  
          if iQAX == 1
            fdirIN = ['../DATAObsStats_StartSept2002/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];     %% older, used for 16 quantiles
            fileIN = [fdirIN '/stats_data_' date_stamp '.mat'];
             
          elseif iQAX == 3
            fdirIN = ['../DATAObsStats_StartSept2002/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];     %% older, used for 16 quantiles
            fileIN = [fdirIN '/iQAX_3_stats_data_' date_stamp '.mat'];
  
          elseif iQAX == -1
            fdirIN = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];  %% newer .. extremes and means
            fileIN = [fdirIN '/stats_data_v3_extreme_' date_stamp '.mat'];
  
          elseif iQAX == 2
            fdirIN = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];  %% newer .. extremes and means
            fileIN = [fdirIN '/stats_data_v3_mean_' date_stamp '.mat'];
  
          end
          thedir = [];
  
          if exist(fileIN)
            thedir  = dir(fileIN);
            if length(thedir) == 1
              if thedir.bytes > 0           
                numALLdone(tt,ii,jj) = 1;    
                numdone(ii,jj) = 1;           
              end
            end
          end  %% if exist(fileIN)
        end    %% lon
      end      %% lat
      if sum(numdone(:)) < 72*64
        fprintf(fid1,'%4i \n',tt+2);
        fprintf(fid2,'%4i %s \n',tt+2,date_stamp);
      end
      fprintf(1,'JOB %4i datestamp %s done %4i \n',tt+2,date_stamp,sum(numdone(:)));
    end
  end        %% if wahoo < 4608

  fclose(fid1);
  fclose(fid2);
end

figure(6); clf
pcolor(squeeze(sum(numALLdone,1))); colorbar; title(['numALLdone should be ' num2str(length(hugedir)-2)])
iPlot = squeeze(sum(numALLdone,1)); iPlot = sum(iPlot(:))/64/72;
fprintf(1,' found %3i of %3i \n',iPlot,length(hugedir)-2)
%%%%%%%%%%%%%%%%%%%%%%%%%

iPlot = input('make plots for last done timestep (-1/+1) : ');
if length(iPlot) == 0
  iPlot = +1;
end
if iPlot > 0
  miaow = sum(squeeze(sum(numALLdone,2)),2); plot(miaow);
  kmiaow = find(miaow == 4608); kmiaow = max(kmiaow);
  tt = kmiaow;
  date_stamp = hugedir(tt+2).name;
  for jj = 1 : 64      %% latitude
    fprintf(1,'.');
    for ii = 1 : 72    %% longitude
      %% JOB = (jj-1)*72 + ii;
      %% x = translator_wrong2correct(JOB);  don't need this since we are not translating
  
      if iQAX == 1
        fdirIN  = ['../DATAObsStats_StartSept2002/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];     %% older, used for 16 quantiles
        thedir = dir([fdirIN '/stats_data_' date_stamp '.mat']);
  
      elseif iQAX == 3
        fdirIN  = ['../DATAObsStats_StartSept2002/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];     %% older, used for 16 quantiles
        thedir = dir([fdirIN '/iQAX_3_stats_data_' date_stamp '.mat']);
  
      elseif iQAX == -1
        fdirIN  = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];  %% newer .. extremes and means
        thedir = dir([fdirIN '/stats_data_v3_extreme_' date_stamp '.mat']);
  
      elseif iQAX == 2
        fdirIN  = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];  %% newer .. extremes and means
        thedir = dir([fdirIN '/stats_data_v3_mean_' date_stamp '.mat']);
  
      end
  
    moo = load([thedir.folder '/' thedir.name]);
    %plot(moo.quantile1231_desc);
    zlat(ii,jj) = moo.lat_desc;
    zlon(ii,jj) = moo.lon_desc;
    zbt1231(:,ii,jj) = moo.quantile1231_desc;
    end    %% lon
  end      %% lat
  %figure(1); pcolor_coast(zlon,zlat,squeeze(zbt1231(1,:,:))); colorbar
  %figure(2); pcolor_coast(zlon,zlat,squeeze(zbt1231(2,:,:))); colorbar
  %figure(3); pcolor_coast(zlon,zlat,squeeze(zbt1231(3,:,:))); colorbar
  %figure(4); pcolor_coast(zlon,zlat,squeeze(zbt1231(4,:,:))); colorbar
  %figure(5); pcolor_coast(zlon,zlat,squeeze(zbt1231(5,:,:))); colorbar

  fprintf(1,'\n plotting quantiles for timestep %3i = %s = %4i/%2i/%2i finished at %s\n',tt,date_stamp,moo.meanyear_desc,round(moo.meanmonth_desc),round(moo.meanday_desc),thedir.date)

  figure(1); simplemap(zlat,zlon,squeeze(zbt1231(1,:,:)),5); colorbar; caxis([220 300]); title('Quantile 50')
  figure(2); simplemap(zlat,zlon,squeeze(zbt1231(2,:,:)),5); colorbar; caxis([220 300]); title('Quantile 80')
  figure(3); simplemap(zlat,zlon,squeeze(zbt1231(3,:,:)),5); colorbar; caxis([220 300]); title('Quantile 90')
  figure(4); simplemap(zlat,zlon,squeeze(zbt1231(4,:,:)),5); colorbar; caxis([220 300]); title('Quantile 95')
  figure(5); simplemap(zlat,zlon,squeeze(zbt1231(5,:,:)),5); colorbar; caxis([220 300]); title('Quantile 97')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%iCheckDone2 = input('Check whats been translated wrong2correct (-1/+1) v2 : ');

iCheckDone2 = -1;
iCheckDone2 = -1;
iCheckDone2 = -1;
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
