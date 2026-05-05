numdone = zeros(72,64);
for jj = jj0 : jjE      %% latitude  01 : 64 unless test
  if mod(jj,10) == 0
    fprintf(1,'+')
  else
    fprintf(1,'.');
  end

  for ii = ii0 : iiE    %% longitude   01 : 72 unless test
    xJOBx = (jj-1)*72 + ii;

    %% x = translator_wrong2correct(xJOBx);  don't need this since we are not translating
    fdirIN  = ['../DATAObsStats_StartSept2002/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];

    %%%%%%%%%%%%%%%%%%%%%%%%%
    iDebug = -1;
    if iDebug > 0
      thedirjunk = dir([fdirIN '/*.mat']);
      iaFound2 = zeros(1,600);
      for ii2 = 1 : length(thedirjunk)
        junk = thedirjunk(ii2).name;
        junk = junk(1:end-4);
        junk = str2num(junk(end-2:end));
        iaFound2(junk) = 1;
      end
      junk = find(iaFound2 == 1); junk = max(junk); maxN2 = junk; 
      disp('these timesteps are not found : '); junk = find(iaFound2(1:junk) == 0)
        iTimeStepNotFound2 = 0;
        iTimeStepNotFound2 = length(junk);

      X = maxN - iTimeStepNotFound;
      Y = length(thedirjunk);
      str = ['LatBin ' num2str(jj,'%02i') ' LonBin ' num2str(ii,'%02i') ' expects ' num2str(X,'%03i') ' files and found ' num2str(Y,'%03i') ' files'];
      fprintf(1,'%s \n',str);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%

    if iQAX == 1
      QAXdir = ['/stats_data_' date_stamp '.mat'];
      QAXdir = ['/iQAX_1_stats_data_' date_stamp '.mat'];
    elseif iQAX == 3
      QAXdir = ['/iQAX_3_stats_data_' date_stamp '.mat'];
    elseif iQAX == 4
      QAXdir = ['/iQAX_4_stats_data_' date_stamp '.mat'];
    end

    thedir = dir([fdirIN QAXdir]);
    if length(thedir) == 1
      if thedir.bytes > 0           
        numdone(ii,jj) = 1;    
      end
    end
  end        
end
fprintf(1,'\n');
