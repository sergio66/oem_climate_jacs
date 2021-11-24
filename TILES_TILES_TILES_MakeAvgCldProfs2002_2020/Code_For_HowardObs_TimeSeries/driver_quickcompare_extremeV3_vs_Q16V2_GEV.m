addpath /asl/matlib/aslutil
addpath /home/sergio/MATLABCODE/TIME

iDo = input('SLOW v2 check all files made BEFORE CORRECTING THE lat/lon (-1/+1) : should be 430+ files in each lat/lon subdir');
if iDo > 0
  for jj = 1 : 64
    if mod(jj,10) == 0
      fprintf(1,'+')
    else
      fprintf(1,'.')
    end
    for ii = 1 : 72
      dir0 = ['../DATAObsStats_StartSept2002/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/'];
      thedir = dir([dir0 '/*.mat']);
      numfilesE(ii,jj) = length(thedir);
    end
  end
  fprintf(1,'\n');
  imagesc(numfilesE); colorbar; colormap(jet);
end

%%%%%%%%%%%%%%%%%%%%%%%%%

iDo = input('SLOW v3 check all files made BEFORE CORRECTING THE lat/lon (-1/+1) : should be 430+ files in each lat/lon subdir');
if iDo > 0
  for jj = 1 : 64
    if mod(jj,10) == 0
      fprintf(1,'+')
    else
      fprintf(1,'.')
    end
    for ii = 1 : 72
      dir0 = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/'];
      thedir = dir([dir0 '/*.mat']);
      numfilesE(ii,jj) = length(thedir);
    end
  end
  fprintf(1,'\n');
  imagesc(numfilesE); colorbar; colormap(jet);
end

iDo = input('SLOW v3 check all files made AFTER CORRECTING THE lat/lon (-1/+1) : should be 1 file in each Lat/lon subdir');
if iDo > 0
  for jj = 1 : 64
    if mod(jj,10) == 0
      fprintf(1,'+')
    else
      fprintf(1,'.')
    end
    for ii = 1 : 72
%      dir0 = ['../DATAObsStats_StartSept2002_CORRECT_LatLon_v3/Extreme_July29_2021/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/'];
      dir0 = ['../DATAObsStats_StartSept2002_CORRECT_LatLon_v3/Extreme/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/'];
      thedir = dir([dir0 '/*.mat']);
      numfilesE(ii,jj) = length(thedir);
    end
  end
  fprintf(1,'\n');
  imagesc(numfilesE); colorbar; colormap(jet);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
thedataS_E = load('timestepsStartEnd_2002_09_to_2020_09.mat');
thedataS_E = load('timestepsStartEnd_2002_09_to_2024_09.mat');
iDo = input('FAST check timestamps BEFORE CORRECTION   == DATAObsStats_StartSept2002_v3  [lat/lon (30,32) really should be (35/72) from translator_wrong2correct]   (-1/+1) : ');
if iDo > 0
  for yy = 2002 : 2021
     boo = find(thedataS_E.thedateS == yy);
     lenSE(yy-2002+1) = length(boo);
  
     dir0 = dir(['../DATAObsStats_StartSept2002_v3/LatBin30/LonBin32/*' num2str(yy) '*.mat']);
     dir0 = dir(['../DATAObsStats_StartSept2002_v3/LatBin35/LonBin72/*' num2str(yy) '*.mat']);
     numfilesYY(yy-2002+1) = length(dir0);
     len = [];
     for ii = 1 : length(dir0)
       len(ii) = dir0(ii).bytes;
    end
    mean_lenYY(yy-2002+1) = sum(len)/length(dir0);
  end
  figure(1); plot(2002:2021,numfilesYY,'o-',2002:2021,lenSE,'x-'); xlim([2002 2021]); title('number of files')
  figure(2); plot(2002:2021,mean_lenYY,'o-'); xlim([2002 2021]); title('mean file size in bytes')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
thedataS_E = load('timestepsStartEnd_2002_09_to_2020_09.mat');
thedataS_E = load('timestepsStartEnd_2002_09_to_2024_09.mat');
iDo = input('SLOW check load files timestamps BEFORE CORRECTION   == DATAObsStats_StartSept2002_v3  [lat/lon (30,32) really should be (35/72) from translator_wrong2correct]   (-1/+1) : ');
if iDo > 0
  fname = '../DATAObsStats_StartSept2002_v3/LatBin35/LonBin72/stats_data_v3_extreme_2003_s015.mat';
  fname_count = str2num(fname(80:82));
  fname_year  = str2num(fname(74:77));
  exampleObject = matfile(fname);
  varlist = who(exampleObject);
  yymmddhh = [32 24 20 22];
  clear x
  for index = 1 : length(yymmddhh)
    varname = varlist{yymmddhh(index)};
    junk = load(fname,varname);
    boostr = ['x(' num2str(index) ') = junk.' varname ';'];
    eval(boostr);
  end

  %% this is seeing how the files in the directory are ordered
  clear x fname_count fname_year fname_count_found fname_order_found
  dir0 = dir(['../DATAObsStats_StartSept2002_v3/LatBin30/LonBin32/*.mat']);
  dir0 = dir(['../DATAObsStats_StartSept2002_v3/LatBin35/LonBin72/*.mat']);
  for tt = 1 : length(dir0)
    fname = ['../DATAObsStats_StartSept2002_v3/LatBin35/LonBin72/' dir0(tt).name];
    fname_count = str2num(fname(80:82));
    fname_count_found(fname_count) = +1;
    fname_order_found(fname_count) = tt;
    fname_year(fname_count) = str2num(fname(74:77));
    exampleObject = matfile(fname);
    varlist = who(exampleObject);
    yymmddhh = [32 24 20 22];    
    for index = 1 : length(yymmddhh)
      varname = varlist{yymmddhh(index)};
      junk = load(fname,varname);
      boostr = ['x(' num2str(fname_count) ',' num2str(index) ') = junk.' varname ';'];
      eval(boostr);
    end
    varname = varlist{37}; % rad_blockmax_desc
      junk = load(fname,varname);
      boostr = ['blockmax(' num2str(fname_count) ') = junk.' varname '(1520);'];
      eval(boostr);
    varname = varlist{41}; % rad_max_desc
      junk = load(fname,varname);
      boostr = ['rad_max(' num2str(fname_count) ',:) = junk.' varname '(1:16,1520);'];
      eval(boostr);
  end  
  miaow = rad_max'; miaow = miaow(:);
  plot((1:length(blockmax))*16,blockmax,1:length(miaow),miaow)

  clear x fname_count fname_year fname_count_found fname_order_found
  for yy = 2002 : 2021  
    dir0 = dir(['../DATAObsStats_StartSept2002_v3/LatBin30/LonBin32/*' num2str(yy) '*.mat']);
    dir0 = dir(['../DATAObsStats_StartSept2002_v3/LatBin35/LonBin72/*' num2str(yy) '*.mat']);
    for tt = 1 : length(dir0)
      fname = ['../DATAObsStats_StartSept2002_v3/LatBin35/LonBin72/' dir0(tt).name];
      fname_count = str2num(fname(80:82));
      fname_count_found(fname_count) = +1;
      fname_order_found(fname_count) = tt;
      fname_year(fname_count) = str2num(fname(74:77));
      exampleObject = matfile(fname);
      varlist = who(exampleObject);
      yymmddhh = [32 24 20 22];
      for index = 1 : length(yymmddhh)
        varname = varlist{yymmddhh(index)};
        junk = load(fname,varname);
        boostr = ['x(' num2str(fname_count) ',' num2str(index) ') = junk.' varname ';'];
        eval(boostr);
      end
    end  
  end

  len = length(fname_count_found)
  figure(1); plot(fname_count_found,'o-'); title('files index found');
  figure(2); plot(thedataS_E.thedateS(1:len,1),x(:,1),'o-',thedataS_E.thedateE(1:len,1),x(:,1),'rx-'); xlabel('from code for 001\_504\_64x72'); ylabel('from data files found'); title('YY');
  figure(3); plot(thedataS_E.thedateS(1:len,2),x(:,2),'o-',thedataS_E.thedateE(1:len,2),x(:,2),'rx-'); xlabel('from code for 001\_504\_64x72'); ylabel('from data files found'); title('MM');
  figure(4); plot(thedataS_E.thedateS(1:len,3),x(:,3),'o-',thedataS_E.thedateE(1:len,3),x(:,3),'rx-'); xlabel('from code for 001\_504\_64x72'); ylabel('from data files found'); title('DD');

  figure(2); plot(thedataS_E.thedateS(1:len,1),thedataS_E.thedateS(1:len,1)-x(:,1),'rx-'); xlabel('from code for 001\_504\_64x72'); ylabel('from data files found'); title('YY');
  figure(3); plot(thedataS_E.thedateS(1:len,2),thedataS_E.thedateS(1:len,2)-x(:,2),'rx-'); xlabel('from code for 001\_504\_64x72'); ylabel('from data files found'); title('MM');
  figure(4); plot(thedataS_E.thedateS(1:len,3),thedataS_E.thedateS(1:len,3)-x(:,3),'rx-'); xlabel('from code for 001\_504\_64x72'); ylabel('from data files found'); title('DD');

  junk = [(1:len)' thedataS_E.thedateS(1:len,1:3) x(:,1:3) thedataS_E.thedateE(1:len,1:3) ];
  fprintf(1,'fileindex    from 001_504_64x72     from reading files n');
  fprintf(1,'%3i %4i/%2i/%2i  |  %4i/%2i/%2i |  %4i/%2i/%2i  \n',round(junk(1:10,:)'));
  rjunk = round(junk);

  good = find(fname_count_found == 1);
  tS = rjunk(good,02:04); rtS = utc2taiSergio(tS(:,1),tS(:,2),tS(:,3),12*ones(length(good),1));
  tF = rjunk(good,05:08); rtF = utc2taiSergio(tF(:,1),tF(:,2),tF(:,3),12*ones(length(good),1));
  tE = rjunk(good,08:10); rtE = utc2taiSergio(tE(:,1),tE(:,2),tE(:,3),12*ones(length(good),1));
  badS = find(rtF < rtS); 
  badE = find(rtF > rtE);
  badSE = find(rtF < rtS & rtF > rtE);  %% if 0 all are good!!!!!!!!!!!!!!!!!!!
  [length(badS) length(badE) length(badSE)]

  figure(1); plot(rtS,rtF,'b.-',rtE,rtF,'r.-');
  figure(1); plot(rtS-rtS(1),rtF-rtS(1),'b.-',rtE-rtE(1),rtF-rtE(1),'r.-');
  t2y = 86400*365;
  figure(1); plot((rtS-rtS(1))/t2y,(rtF-rtS(1))/t2y,'b.-',(rtE-rtE(1))/t2y,(rtF-rtE(1))/t2y,'r.-');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% see https://www.mathworks.com/help/stats/generalized-extreme-value-distribution.html

blocksize = 1000;
nblocks = 250;
rng default  % For reproducibility
t = trnd(5,blocksize,nblocks);
x = max(t); % 250 column maxima
paramEsts = gevfit(x)

histogram(x,2:20,'FaceColor',[.8 .8 1]);
xgrid = linspace(2,20,1000);
line(xgrid,nblocks*gevpdf(xgrid,paramEsts(1),paramEsts(2),paramEsts(3)));

x = linspace(-3,6,1000);
y1 = gevpdf(x,-.5,1,0); 
y2 = gevpdf(x,0,1,0); 
y3 = gevpdf(x,.5,1,0);
plot(x,y1,'-', x,y2,'--', x,y3,':')
legend({'K < 0, Type III' 'K = 0, Type I' 'K > 0, Type II'})

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%                                      ../DATAObsStats_StartSept2002_CORRECT_LatLon_v3/Extreme/LatBin30/LonBin32/summarystats_LatBin30_LonBin32_timesetps_001_413_V1.mat'
%%%  lser = ['!ls -lt ../DATAObsStats_StartSept2002_v3/LatBin30/LonBin32/*.mat | wc -l']; eval(lser)
extV3 = load('/asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_CORRECT_LatLon_v3/Extreme/LatBin30/LonBin32/summarystats_LatBin30_LonBin32_timesetps_001_413_V1.mat');

quant16_V2 = load('/asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_CORRECT_LatLon/LatBin30/LonBin32/summarystats_LatBin30_LonBin32_timesetps_001_412_V1.mat');

junk = extV3.rad_max_asc(:,:,1520); junk = junk(:); junktime = (1:length(junk))/365 + 2002.75; plot(junktime,junk); xlim([min(junktime) max(junktime)])
bah = load('../DATAObsStats_StartSept2002_v3/LatBin30/LonBin32/stats_data_v3_extreme_2007_s103.mat'); plot(bah.rad_max_desc(:,1520))

junkE1  = extV3.rad_max_desc(:,:,1520);    junkE1 = junkE1'; junkE1 = junkE1(:); junkE1 = rad2bt(1231,junkE1);   plot(junkE1);
junkE16 = extV3.rad_blockmax_desc(:,1520); junkE16 = junkE16;                    junkE16 = rad2bt(1231,junkE16); plot(junkE16);
junkQ = quant16_V2.rad_quantile_desc(:,1520,16); junkQ = squeeze(junkQ);         junkQ = rad2bt(1231,junkQ);   plot(junkQ);

plot(1:6608,junkE1,'b',(1:413)*16,junkE16,'k',(1:412)*16,junkQ,'r'); ylim([50 60])
plot(2002.75 + (0:6607)/365,junkE1,'b',2002.75 + (0:412)*16/365,junkE16,'k',2002.75 + (0:411)*16/365,junkQ,'r'); ylim([280 300])
  hl = legend('daily max','16 day max','warmest Q16','location','best');

plot(1:413,junkE16,1:412,junkQ)
plot(1:412,junkE16(1:412),1:412,junkQ)
plot(1:412,junkE16(1:412)-junkQ)

nblocks16 = 412;
paramEsts16 = gevfit(junkQ)
dgrid = 0.25;
figure(1); clf; histogram(junkQ,floor(min(junkQ)):dgrid:ceil(max(junkQ)),'FaceColor',[.8 .8 1]);
junkQgrid = linspace(floor(min(junkQ)),ceil(max(junkQ)),100);
line(junkQgrid,nblocks16*dgrid*gevpdf(junkQgrid,paramEsts16(1),paramEsts16(2),paramEsts16(3))); %% nblock*dgrid so things are properly normalized
  title('Q16 averaged')

nblocks16 = 413;
paramEsts16 = gevfit(junkE16)
dgrid = 0.25;
figure(2); clf; histogram(junkE16,floor(min(junkE16)):dgrid:ceil(max(junkE16)),'FaceColor',[.8 .8 1]);
junkE16grid = linspace(floor(min(junkE16)),ceil(max(junkE16)),100);
line(junkE16grid,nblocks16*dgrid*gevpdf(junkE16grid,paramEsts16(1),paramEsts16(2),paramEsts16(3))); %% nblock*dgrid so things are properly normalized
  title('block maxima')

good = find(isfinite(junkE1));
mu = mean(junkE1(good));
sig = std(junkE1(good));
goodx = find(junkE1(good) >= mu - 0.5*sig);
good = good(goodx); 
paramEsts1 = gevfit(junkE1(good))
nblocks1 = length(good);
dgrid = 0.25;
figure(3); clf; histogram(junkE1(good),floor(min(junkE1(good))):dgrid:ceil(max(junkE1(good))),'FaceColor',[.8 .8 1]);
junkE1grid = linspace(floor(min(junkE1(good))),ceil(max(junkE1(good))),100);
line(junkE1grid,nblocks1*dgrid*gevpdf(junkE1grid,paramEsts1(1),paramEsts1(2),paramEsts1(3))); %% nblock*dgrid so things are properly normalized
  title('daily maxima')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
