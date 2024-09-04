numdone = zeros(72,64);    
date_stamp = hugedir(tt+2).name;
for jj = 1 : 64      %% latitude
  if mod(jj,10) == 0
    fprintf(1,'+');
  else
    fprintf(1,'.');
  end

  for ii = 1 : 72    %% longitude

    %% JOB = (jj-1)*72 + ii;
    %% x = translator_wrong2correct(JOB);  don't need this since we are not translating

    if iQAX == 1
      fdirIN = ['../DATAObsStats_StartSept2002/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];     %% older, used for 16 quantiles
      fileIN = [fdirIN '/stats_data_' date_stamp '.mat'];
       
    elseif iQAX == 3
      fdirIN = ['../DATAObsStats_StartSept2002/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];     %% older, used for 16 quantiles
      fileIN = [fdirIN '/iQAX_3_stats_data_' date_stamp '.mat'];

    elseif iQAX == 4
      fdirIN = ['../DATAObsStats_StartSept2002/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];     %% older, used for 16 quantiles
      fileIN = [fdirIN '/iQAX_4_stats_data_' date_stamp '.mat'];

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
fprintf(1,'\n')

fprintf(1,'timestep %03i found %4i of 4608 files of the form %s \n',tt,sum(numdone(:)),fileIN)
