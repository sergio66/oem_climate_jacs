addpath /asl/matlib/aslutil

set_iQAX
if iQAX == 1
  disp('iQAX == 1 so looking for regular quantiles   quants = [0 0.01 0.02 0.03 0.04 0.05 0.10 0.25 0.50 0.75 0.9 0.95 0.96 0.97 0.98 0.99 1.00]')
elseif iQAX == 3
  disp('iQAX == 3 so looking for newer   quantiles   quants = [0.50 0.80 0.90 0.95 0.97 1.00]')
elseif iQAX == 4
  disp('iQAX == 4 so looking for newer   quantiles   quants = [0 0.03 0.97 1.0]')
elseif iQAX == 0
  disp('iQAX == 0 so looking for quantiles and extreme')
elseif iQAX == -1
  disp('iQAX == -1 so looking for extreme')
elseif iQAX == 2
  disp('iQAX == 2 so looking for mean')
else
  error('iQAX')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iExpectNumYears = -1; %% all so far
iExpectNumYears = 08; %% 2002/09 - 2010/08
iExpectNumYears = 20; %% 2002/09 - 2022/08
iExpectNumYears = 22; %% 2002/09 - 2024/08

iCheckDone1 = input('Check whats been done (-1/+1 default) makes up txt file for clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m with missing timesteps : ');
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

  %% default is to do                        (all years)  for tt = 1 : length(hugedir)-2
  %% but if you only want to do eg till 2022 (20 years)   for tt = 1 : 460
  %% but if you only want to do eg till 2010 (08 years)   for tt = 1 : 184
  
  if iExpectNumYears == -1
    iExpectNumTiles = length(hugedir);
  else
    iExpectNumTiles = iExpectNumYears*23 + 2;
  end

  iExpectNumTiles = min(length(hugedir),iExpectNumTiles);  %% there cannot be more than length(hugedir) files

  for tt = 1 : iExpectNumTiles - 2
    wahoo = squeeze(numALLdone(tt,:,:));
    wahoo = sum(wahoo(:));
    if wahoo < 4608
      are_4608_files_alreadymade_by_clust_check_howard_16daytimesetps

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
pcolor(squeeze(sum(numALLdone,1))'); colorbar; title(['numALLdone should be ' num2str(iExpectNumTiles-2)]); colormap jet
iPlot = squeeze(sum(numALLdone,1)); iPlot = sum(iPlot(:))/64/72;
fprintf(1,' found %5i of %5i \n',floor(iPlot),iExpectNumTiles-2)
%%%%%%%%%%%%%%%%%%%%%%%%%

iPlot = input('make plots for last done timestep (-1/+1 [default]) : ');
if length(iPlot) == 0
  iPlot = +1;
end
if iPlot > 0
  miaow = sum(squeeze(sum(numALLdone,2)),2); 
  figure(7); plot(miaow); title('Plots for last timestep done');

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
        fdirIN  = ['../DATAObsStats_StartSept2002/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];     %% newer, used for 5 quantiles
        thedir = dir([fdirIN '/iQAX_3_stats_data_' date_stamp '.mat']);

      elseif iQAX == 4
        fdirIN = ['../DATAObsStats_StartSept2002/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];     %% newer, used for 3 quantiles
        thedir = dir([fdirIN '/iQAX_4_stats_data_' date_stamp '.mat']);
    
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

  if iQAX == 3
    figure(1); simplemap(zlat,zlon,squeeze(zbt1231(1,:,:)),5); colorbar; colormap jet; caxis([220 300]); title('Quantile 50')
    figure(2); simplemap(zlat,zlon,squeeze(zbt1231(2,:,:)),5); colorbar; colormap jet; caxis([220 300]); title('Quantile 80')
    figure(3); simplemap(zlat,zlon,squeeze(zbt1231(3,:,:)),5); colorbar; colormap jet; caxis([220 300]); title('Quantile 90')
    figure(4); simplemap(zlat,zlon,squeeze(zbt1231(4,:,:)),5); colorbar; colormap jet; caxis([220 300]); title('Quantile 95')
    figure(5); simplemap(zlat,zlon,squeeze(zbt1231(5,:,:)),5); colorbar; colormap jet; caxis([220 300]); title('Quantile 97')
  elseif iQAX == 3
    figure(1); simplemap(zlat,zlon,squeeze(zbt1231(1,:,:)),5); colorbar; colormap jet; caxis([220 300]); title('Quantile ALL')
    figure(2); simplemap(zlat,zlon,squeeze(zbt1231(2,:,:)),5); colorbar; colormap jet; caxis([220 300]); title('Quantile 03')
    figure(3); simplemap(zlat,zlon,squeeze(zbt1231(3,:,:)),5); colorbar; colormap jet; caxis([220 300]); title('Quantile 97')
  end
  fairs = load('h2645structure.mat');
  figure(8); clf; plot(fairs.h.vchan,rad2bt(fairs.h.vchan,moo.rad_quantile_desc)); title('moo.rad_quantile_desc for last complete file')
    hl = legend(num2str((1:length(moo.quantile1231_desc))'));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
iCheckDone2 = -1;
iCheckDone2 = -1;
iCheckDone2 = -1;
iCheckDone2 = -1;

iCheckDone2 = input('Check whats been translated wrong2correct (-1/+1) v2 : ');

if iCheckDone2 > 0
  check_files_translated_wrong2correct
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
