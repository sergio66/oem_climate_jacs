clear lenFeatures

if iFitChan == -1
  ind_freq = 1: 2645;                                                             %% all
  ind_freq = find(freq0 <= 3000); %% all chans
  matchesT = who('dt*');   lenT = length(matchesT);
  matches1 = who('Wr*');   len1 = length(matches1);
  matches2 = who('CO2r*'); len2 = length(matches2);  
  matches3 = who('Or*');   len3 = length(matches3);
  lenFeatures = 1 + lenT + len1 + len2 + len3;
  
elseif iFitChan == -2
  ind_freq = find(freq0 <= 1640);                                                 %% all TZ,CO2, WV, O3
  matchesT = who('dt*');   lenT = length(matchesT);
  matches1 = who('Wr*');   len1 = length(matches1);
  matches2 = who('CO2r*'); len2 = length(matches2);  
  matches3 = who('Or*');   len3 = length(matches3);
  lenFeatures = 1 + lenT + len1 + len2 + len3;

elseif iFitChan == +1
  ind_freq = find(freq0 >= 1250 & freq0 <= 1700);                                 %% WV MW
  ind_freq = find(freq0 >= 1350 & freq0 <= 1700);                                 %% WV MW
  matchesT = who('dt*');   lenT = length(matchesT);
  matches1 = who('Wr*');   len1 = length(matches1);
  lenFeatures = 1 + lenT + len1;
  
elseif iFitChan == +3
  ind_freq = find(freq0 >= 0980 & freq0 <= 1100);                                 %% O3
  matchesT = who('dt*');   lenT = length(matchesT);
  matches3 = who('Or*');   len3 = length(matches3);
  lenFeatures = 1 + lenT + len3;
  
elseif iFitChan == 800
  ind_freq = find(freq0 >= 0820 & freq0 <= 0980 | freq0 > 1100 & freq0 <= 1250);  %% window
  matchesT = who('dt*');   lenT = length(matchesT);
  matches1 = who('Wr*');   len1 = length(matches1);
  lenFeatures = 1 + lenT + len1 + len2 + len3;
  
elseif iFitChan == -3
  ind_freq = find(freq0 >= 0700 & freq0 <= 1640);                                 %% low alt TZ,CO2, WV, O3
  matchesT = who('dt*');   lenT = length(matchesT);
  matches1 = who('Wr*');   len1 = length(matches1);
  matches2 = who('CO2r*'); len2 = length(matches2);  
  matches3 = who('Or*');   len3 = length(matches3);
  lenFeatures = 1 + lenT + len1 + len2 + len3;
  
elseif iFitChan == 2
  ind_freq = find(freq0 >= 0600 & freq0 <= 0820);                                 %% LW TZ,CO2
elseif iFitChan == 21
  ind_freq = find(freq0 >= 2150 & freq0 <= 2450);                                 %% SW TZ,CO2
elseif iFitChan == 6
  ind_freq = find(freq0 >= 1150 & freq0 <= 1450);                                 %% CH4
end

nLayerFeatures = 10 + 1;      % 10 SARTA predictors + 1 layer-position encoding
nLayerFeatures = lenFeatures;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

freq          = freq0;
nChannels     = 2645;
emissivityRaw = emissivityRaw_00;
btRaw         = btRaw_00;
btTrueVal     = btRaw;

freq          = freq0(ind_freq);
emissivityRaw = emissivityRaw_00(:,ind_freq);
btRaw         = btRaw_00(:,ind_freq);;
btTrueVal     = btTrueVal(:,ind_freq);;;

wavenumbers = freq;
nChannels = length(ind_freq);

