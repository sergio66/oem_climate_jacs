%% DATAObsStats_StartSept2002/LatBin32/LonBin36/stats_data_2009_s158.mat

addpath /asl/matlib/aslutil/
addpath /home/sergio/MATLABCODE/TIME

thedataS_E = load('timestepsStartEnd_2002_09_to_2020_09.mat');
thedataS_E = load('timestepsStartEnd_2002_09_to_2024_09.mat');

%% JOB = 1 .. 64
JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));  %% this is the latbin, and inside here we loop over the 72 lonbins
%JOB = 32

%% indonesia = 0.78S, 113E   so latbin32,lonbin 113/180*36 + 36 = 59
jj = 32; ii = 59;  

%% greenland = 71 N, 42 W  so latbinB64 = 59, lonbin72 = (180-42)/5 = 27
jj = 59; ii = 27; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
%% %% run this by hand first, so as to make the DIRS to save things to
%% 
%% cd .. 
%% mkdir /asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_CORRECT_LatLon_v3
%% [sergio@taki-usr2 TILES_TILES_TILES_MakeAvgCldProfs2002_2020]$ ln -s /asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_CORRECT_LatLon_v3 DATAObsStats_StartSept2002_CORRECT_LatLon_v3
%% 
%% %% see do_the_save_howard_16daytimesetps_2013_raw_griddedV3
%% %    junkLat = iiix; junkLon = jjjx;
%% %    if iQAX == 1
%% %      foutXY = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(junkLat,'%02d') '/LonBin' num2str(junkLon,'%02d') '/stats_data_v3_quantile_' date_stamp '.mat'];
%% %    elseif iQAX == 0
%% %      foutXY = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(junkLat,'%02d') '/LonBin' num2str(junkLon,'%02d') '/stats_data_v3_quantile_n_extreme_' date_stamp '.mat'];
%% %    elseif iQAX == -1
%% %      foutXY = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(junkLat,'%02d') '/LonBin' num2str(junkLon,'%02d') '/stats_data_v3_extreme_' date_stamp '.mat'];
%% %    end
%% 
%% startdate = [2002 09 01]; stopdate = [2021 08 31]; 
%% startdate = [2005 01 01]; stopdate = [2014 12 31];  % Joao wants 10 years
%% i16daysSteps = floor((change2days(stopdate(1),stopdate(2),stopdate(3),2002) - change2days(startdate(1),startdate(2),startdate(3),2002))/16)
%%
%% iQAX =  0; %% quantile and extreme
%% iQAX = -1; %% extreme
%% iQAX = +2; %% mean
%% iQAX = +1; %% quantile
%% 
%% iQAX = -1;
%% for jj = 1 : 64
%%   for ii = 1 : 72
%%     if iQAX == -1
%%       fdirOUT = ['../DATAObsStats_StartSept2002_CORRECT_LatLon_v3/Extreme/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];
%%     else
%%       error('unknown iQAX')
%%     end
%%     if ~exist(fdirOUT)
%%       mker = ['!mkdir -p ' fdirOUT];
%%       eval(mker)
%%     end
%%   end
%% end
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%startdate = [2002 09 01]; stopdate = [2021 08 31]; 
%startdate = [2005 01 01]; stopdate = [2014 12 31];  % Joao wants 10 years
%i16daysSteps = floor((change2days(stopdate(1),stopdate(2),stopdate(3),2002) - change2days(startdate(1),startdate(2),startdate(3),2002))/16)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hugedir = dir('/asl/isilon/airs/tile_test7/');  %% 417 timesteps till Nov 2020
hugedir = dir('/asl/isilon/airs/tile_test7/');  %% 433 timesteps till Nov 2021
hugedir = dir('/asl/isilon/airs/tile_test7/');  %% 457 timesteps till Nov 2020

iaFound = zeros(1,600);
for ii = 3 : length(hugedir)
  junk = hugedir(ii).name;
  junk = str2num(junk(end-2:end));
  iaFound(junk) = 1;
end
junk = find(iaFound == 1); junk = max(junk); maxN = junk; 
  fprintf(1,'max(iaFound) = %3i so will save "EXTREMEorMEAN/summarystats_LatBin32_LonBin36_timesetps_001_%3i_V1.mat" \n',junk,junk);

disp('these timesteps are not found : '); junk = find(iaFound(1:junk) == 0)
  iTimeStepNotFound = 0;
  iTimeStepNotFound = length(junk);
fprintf(1,'so should only find %3i Sergio processed files \n',maxN - iTimeStepNotFound);
disp(' ' )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

all_72lonbins = struct;
iiMin = 59; iiMax = 59;
iiMin = 01; iiMax = 72;

%% iQAX =  0; %% quantile and extreme
%% iQAX = -1; %% extreme
%% iQAX = +2; %% mean
%% iQAX = +1; %% quantile
set_iQAX

for ii = iiMin : iiMax
  %if mod(ii,10) == 0
  %  fprintf(1,'+')
  %else
  %  fprintf(1,'.')
  %end
  %tile = [];

  jj = JOB;   %% latbin
  JOBB = (JOB-1)*72 + ii;

  x = translator_wrong2correct(JOBB);
  if iQAX == -1
    fdirIN  = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(x.wrong2correct_I_J_lon_lat(2),'%02i') '/LonBin' num2str(x.wrong2correct_I_J_lon_lat(1),'%02i') '/'];
    thedir = dir([fdirIN '/*extreme*.mat']);
    fprintf(1,'  there are %3i files inside %s \n',length(thedir),fdirIN);

    fdirOUT = ['../DATAObsStats_StartSept2002_CORRECT_LatLon_v3/Extreme/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];
  elseif iQAX == 2
    fdirIN  = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(x.wrong2correct_I_J_lon_lat(2),'%02i') '/LonBin' num2str(x.wrong2correct_I_J_lon_lat(1),'%02i') '/'];
    thedir = dir([fdirIN '/*mean*.mat']);
    fprintf(1,'  there are %3i files inside %s \n',length(thedir),fdirIN);

    fdirOUT = ['../DATAObsStats_StartSept2002_CORRECT_LatLon_v3/Mean/LatBin' num2str(jj,'%02i') '/LonBin' num2str(ii,'%02i') '/'];
  else
    error('unknown iQAX')
  end

  fnameoutIIJJ = [fdirOUT '/summarystats_LatBin' num2str(jj,'%02i') '_LonBin' num2str(ii,'%02i') '_timesetps_001_' num2str(length(thedir),'%03i') '_V1.mat'];
  fnameoutIIJJ = [fdirOUT '/summarystats_LatBin' num2str(jj,'%02i') '_LonBin' num2str(ii,'%02i') '_timesetps_001_' num2str(maxN,'%03i') '_V1.mat'];
  lonbin_time = struct;  
  for tt = 1 : length(thedir)
    fx = [fdirIN '/' thedir(tt).name];
    a = load(fx);
    lonbin_time = cat_lonbin_time(lonbin_time,tt,a,iQAX);
    all_72lonbins.rlon(ii,tt) = a.lon_asc;
    all_72lonbins.rlat(ii,tt) = a.lat_asc;
    all_72lonbins.yy(ii,tt) = a.meanyear_asc;
    all_72lonbins.mm(ii,tt) = a.meanmonth_asc;
    all_72lonbins.dd(ii,tt) = a.meanday_asc;
    %%all_72lonbins.meanBT1231(ii,tt) = rad2bt(1520,a.mean_rad_asc(1520));  %% ORIG WRONG CODE run on Dec 8, 2020
    all_72lonbins.meanBT1231(ii,tt) = rad2bt(1231,a.mean_rad_asc(1520));  %% THIS IS CORRECT corrected Dec 16, 2020
    all_72lonbins.maxBT1231(ii,tt) = a.max1231_asc;
    all_72lonbins.minBT1231(ii,tt) = a.min1231_asc;
    all_72lonbins.dccBT1231(ii,tt) = a.DCC1231_asc;
    %radquantile(tt,:,:) = a.rad_quantile_desc;
    %thetimestep(JOBB,tt) = str2num(thedir(tt).name(18:end-4));
  end
  plot(all_72lonbins.meanBT1231(:)); pause(0.1);
  save(fnameoutIIJJ,'-struct','lonbin_time');
  fprintf(1,'saved %s \n',fnameoutIIJJ);
end
%all_72lonbins.meanBT1231 = rad2bt(1231,all_72lonbins.meanBT1231);

if iQAX == -1
  fdirOUTII = ['../DATAObsStats_StartSept2002_CORRECT_LatLon_v3/Extreme/LatBin' num2str(jj,'%02i') '/'];
  fnameoutII = [fdirOUTII '/summarystats_extreme_LatBin' num2str(jj,'%02i') '_LonBin_1_72_timesetps_001_' num2str(length(thedir),'%03i') '_V1.mat'];
else
  error('unknown iQAX')
end
save(fnameoutII,'-struct','all_72lonbins');
fprintf(1,'\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
yymmdd = yy + (mm-1)/12 + (dd-1)/12/30;
plot(yymmdd(1:end-1),diff(yymmdd))

figure(1); plot(yymmdd,meanBT1231,'.-',yymmdd,minBT1231,'.-',yymmdd,maxBT1231,'.-','linewidth',2); hl = legend('mean','min','max','location','best','fontsize',8);
xlim([min(yymmdd) max(yymmdd)])

figure(2); plot(yymmdd,dccBT1231,'.-','linewidth',2); title('DCC count')
xlim([min(yymmdd) max(yymmdd)])

figure(3);
  moo = squeeze(radquantile(:,:,1));
  moo = rad2bt(a.wnum,moo');
  pcolor(a.wnum,yymmdd,real(moo')); shading flat; colorbar
  title('Coldest quantile');

figure(4);
  moo = squeeze(radquantile(:,:,16));
  moo = rad2bt(a.wnum,moo');
  pcolor(a.wnum,yymmdd,real(moo')); shading flat; colorbar
  title('Hottest quantile');
%}
