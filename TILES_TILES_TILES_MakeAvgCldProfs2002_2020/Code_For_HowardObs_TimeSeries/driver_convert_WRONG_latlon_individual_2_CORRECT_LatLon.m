%% Howard : The actual indexing is about as simple as it could be, tiles run S to N, from 1 to 64, and from W to E, from, 1 to 72.    tile_file gives you the filename from the indices, and tile_index finds indices from lat/lon values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(A)
load latB64.mat
rlon = -180 : +180;          rlat = -90 : +90;
drlon = 5;                   drlat = 3;
rlon = -180 : drlon : +180;  rlat = -90 : drlat : +90;
rlon = rlon;                 rlat = latB2;

x = 0.5*(rlon(1:end-1)+rlon(2:end));  y = 0.5*(rlat(1:end-1)+rlat(2:end));

[Y,X] = meshgrid(y,x);
Y = Y(:);
X = X(:);
plot(X(1:73), Y(1:73),'o')   %% yay so I loop     do outer 1 : 64; do inner 1 : 72;    ?????   ..... 

%%%%%%%%%%%%%%%%%%%%%%%%%
%(B)
%%  ..... and ....
%% cd /home/sergio/KCARTA/WORK/RUN_TARA/GENERIC_RADSnJACS_MANYPROFILES
use_this_rtp = 'RTP/summary_17years_all_lat_all_lon_2002_2019_palts_startSept2002.rtp';
use_this_rtp = '/asl/s1/sergio/MakeAvgProfs2002_2020_startSept2002/summary_17years_all_lat_all_lon_2002_2019.rtp';
addpath /asl/matlib/h4tools
[h,ha,p,pa] = rtpread(use_this_rtp);
plot(p.rlon(1:73),p.rlat(1:73),'x',X(1:73), Y(1:73),'o')

%%%%%%%%%%%%%%%%%%%%%%%%%
%(C)
%% ... THIS IS THE ODD ONE OUT .... makes sense since we do it by lonbin
woo = load('DATA_StartSept2002/pall_16daytimestep_123_2008_01_05_to_2008_01_21.mat'); %% see eg driver_split_apart_rtp_howard_bins_startSept2002.m
plot(woo.pall.pavg(1).rlon,woo.pall.pavg(1).rlat,'.')    %% there are 72 of them

plot(p.rlon(1:64),p.rlat(1:64),'bx',woo.pall.pavg(1).rlon,woo.pall.pavg(1).rlat,'r.')

%{
so look at ~/MATLABCODE/CRODGERS_FAST_CLOUD/clustbatch_redo_stemp_wv_cloud_filelist.m
filelist = '/asl/s1/sergio/MakeAvgProfs2002_2020/summary_latbin_files.txt';
which essentially also says look at /asl/s1/sergio/MakeAvgProfs2002_2020/summary_1[67]years_all_lat_all_lon.rtp
%}

%%%%%%%%%%%%%%%%%%%%%%%%%
%(D)
%{
%% /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_Oct2020_trendsonly
%% for each JOB (1:64) we loop over lonbin (1:72)
%% look at clust_run_retrieval_latbins_AIRS_iasitimespan_loop_anomaly.m
JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));   %% 1 : 64 for the 64 latbins
iDoAnomalyOrRates = -1;  %% do the trends/rates
iLon0A = 1; iLonEA = 72;
iOffset = (JOB-1)*72;
iLon0 = iLon0A + iOffset;  iLonE = iLonEA + iOffset;
%for iLon = iLonE : -1 : iLonE
for iLon = iLon0 : iLonE
  if iDoAnomalyOrRates == -1
    driver.i16daytimestep = -1;   %% for the rates, not anomalies, RUN BY HAND BY UN-COMMENTING THIS LINE and
                                  %% on top JOB = 1000, in change_important_topts_settings.m also set topts.set_tracegas = -1;
  end
  stuff
  if driver.i16daytimestep < 0
    driver.outfilename = ['Output/test' int2str(iLon) '.mat'];
  end
end
%}

%% then look at gather_gridded_retrieval_results.m
%load /home/motteler/shome/obs_stats/airs_tiling/latB64.mat
load latB64.mat
r1lon = -180 : 5 : +180;  r1lat = latB2;
r1lon = 0.5*(r1lon(1:end-1)+r1lon(2:end));
r1lat = 0.5*(r1lat(1:end-1)+r1lat(2:end));
[Y1,X1] = meshgrid(r1lat,r1lon);
X1 = X1; Y1 = Y1;

addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/matlib/rtp_prod2/util/
addpath /home/sergio/MATLABCODE/matlib/science/            %% for usgs_deg10_dem.m that has correct paths
[salti, landfrac] = usgs_deg10_dem(Y1(:),X1(:));
figure(1); scatter_coast(X1(:),Y1(:),50,landfrac); colorbar; title('landfrac');  caxis([0 1])

%figure(1); pcolor(X1,Y1,(reshape(results(:,1),72,64))); shading interp; colorbar; title('CO2');
figure(1); pcolor(X1,Y1,reshape(p.stemp,72,64)); shading interp; colorbar; title('Is this correct STEMP map YEAH BUDDY');
figure(2); scatter_coast(X1(:),Y1(:),50,p.stemp); shading interp; colorbar; title('Is this correct STEMP map YEAH BUDDY');

[Yind,Xind] = meshgrid(1:64,1:72);
Xstretch    = X1(:);    Ystretch = Y1(:);
Xindstretch = Xind(:); Yindstretch = Yind(:);

plot(p.rlon(1:73),p.rlat(1:73),'x',X(1:73), Y(1:73),'o',Xstretch(1:73),Ystretch(1:73),'+')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% see HOWARD_CODE/tile_loop1.m
addpath HOWARD_CODE
correctorder_howardfilenames = tile_loop1A;
plot(p.rlon(1:(72*2)+1),p.rlat(1:(72*2)+1),'bx',X(1:(72*2)+1), Y(1:(72*2)+1),'co',Xstretch(1:(72*2)+1),Ystretch(1:(72*2)+1),'r+',correctorder_howardfilenames.rlon(1:(72*2)+1),correctorder_howardfilenames.rlat(1:(72*2)+1),'gs')

%load stats_howard_16daytimesetps_2013_s237_raw_gridded.mat  %% from check_howard_16daytimesetps_2013_raw_gridded.m
%savedirname.iii = thesave.iii;
%savedirname.jjj = thesave.jjj;
%savedirname.lat = thesave.lat_asc;
%savedirname.lon = thesave.lon_asc;
%savedirname.fname = thesave.fname;
%for ii = 1 : 4608; fprintf(1,'%s %3i %3i %8.4f %8.4f\n',thesave.fname{ii},thesave.iii(ii),thesave.jjj(ii),thesave.lat_asc(ii),thesave.lon_asc(ii)); end
%save howard_lat_lon_fname.mat savedirname
wrongorder_howardfilenames_from_dirs = load('howard_lat_lon_fname.mat');
plot(p.rlon(1:73),p.rlat(1:73),'x',X(1:73), Y(1:73),'o',Xstretch(1:73),Ystretch(1:73),'+',wrongorder_howardfilenames_from_dirs.savedirname.lon(1:73),wrongorder_howardfilenames_from_dirs.savedirname.lat(1:73),'ks')

disp('oh blimey need to map what I did to our lat/lon bins .. sanity checks')
plot(Xindstretch-correctorder_howardfilenames.ilon')
plot(Yindstretch-correctorder_howardfilenames.ilat')
plot(p.rlon-correctorder_howardfilenames.rlon)
plot(p.rlat-correctorder_howardfilenames.rlat)

%% now need to map the incorrectly ordered names that I made (clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m) to the corectly ordered names from Howard
xwrongname   = wrongorder_howardfilenames_from_dirs.savedirname.fname;
xcorrectname = correctorder_howardfilenames.name;

for ii = 1 : 64*72
  wrongname(ii,:)   = xwrongname{ii}(end-16:end-3);
  correctname(ii,:) = xcorrectname{ii}(end-16:end-3);
end

themapWrong2Right = nan(1,64*72);
for ii = 1 : 64*72
  if mod(ii,72) == 0
    fprintf(1,'.');
  end
  right = correctname(ii,:);
  iFound = -1;
  iCnt = 0;
  while iFound < 0 & iCnt < 64*72+1
    iCnt = iCnt+1;
    caTry = wrongname(iCnt,:);
    if strcmp(right,caTry) == 1
      themapWrong2Right(ii) = iCnt;
      iFound = 1;     
    end
  end
end
fprintf(1,'\n');
for ii = 1 : 64*72
  wah(ii) = strcmp(correctname(ii,:),wrongname(themapWrong2Right(ii),:));
end
sum(wah)

plot(p.rlat-wrongorder_howardfilenames_from_dirs.savedirname.lat(themapWrong2Right))        %% so this can be fixed
plot(Xindstretch-wrongorder_howardfilenames_from_dirs.savedirname.iii(themapWrong2Right))   %% this shows iii and jjj are completely totally wrong
iii = wrongorder_howardfilenames_from_dirs.savedirname.iii;
jjj = wrongorder_howardfilenames_from_dirs.savedirname.jjj;
commentthemapWrong2Right = 'see covert_WRONG_latlon_individual_2_CORRECT_latlon_timeseries.m -- you will need to map iii and jjj to Xindstretch and Yindstretch';
save reorder_indexing.mat commentthemapWrong2Right themapWrong2Right correctname wrongname Xindstretch Yindstretch correctorder_howardfilenames wrongorder_howardfilenames_from_dirs

%% so correctorder_howardfilenames.ilat(1:72) = 1
%%    correctorder_howardfilenames.ilon(1:72) = 1:72
%% etc

%{
so 
  correctorder_howardfilenames.name{1} = '/asl/isilon/airs/tile_test7/2002_s001/S90p00/tile_2002_s001_S90p00_W180p00.nc'
    correctname(1,:)                   = 'S90p00_W180p00'
    correctorder_howardfilenames.ilat(1) = 1             correctorder_howardfilenames.ilon(1) = 1
    correctorder_howardfilenames.rlon(1) =  -177.5000    correctorder_howardfilenames.rlat(1) =  -85.8750
while  
  wrongorder_howardfilenames_from_dirs.savedirname.fname{1} = '/asl/isilon/airs/tile_test7/2013_s237/N00p00/tile_2013_s237_N00p00_E000p00.nc';
  wrongname(1,:)                                            =                                                             'N00p00_E000p00'
  wrongorder_howardfilenames_from_dirs.savedirname.lon(1) = 2.4996; wrongorder_howardfilenames_from_dirs.savedirname.lat(1) = 1.3768;
  themapWrong2Right(1)                                      = 4608;
  wrongname(themapWrong2Right(1),:)    = 'S90p00_W180p00'
  wrongorder_howardfilenames_from_dirs.savedirname.lon(themapWrong2Right(1)) =  -177.5214
  wrongorder_howardfilenames_from_dirs.savedirname.lat(themapWrong2Right(1)) =  -84.1662

iJunk = 1000;
correctorder_howardfilenames.name{iJunk}
wrongorder_howardfilenames_from_dirs.savedirname.fname{themapWrong2Right(iJunk)}

junk1 = [iJunk  correctorder_howardfilenames.ilon(iJunk) correctorder_howardfilenames.ilat(iJunk) correctorder_howardfilenames.rlon(iJunk) correctorder_howardfilenames.rlat(iJunk) ];
junk2 = [themapWrong2Right(iJunk)  wrongorder_howardfilenames_from_dirs.savedirname.jjj(themapWrong2Right(iJunk)) wrongorder_howardfilenames_from_dirs.savedirname.iii(themapWrong2Right(iJunk)) ...
                                   wrongorder_howardfilenames_from_dirs.savedirname.lon(themapWrong2Right(iJunk)) wrongorder_howardfilenames_from_dirs.savedirname.lat(themapWrong2Right(iJunk))];
fprintf(1,' CORRECT %4i     %s   %2i %2i %8.f4 %8.4f \n',iJunk,correctorder_howardfilenames.name{iJunk},                                        junk1);
fprintf(1,' WRONG   %4i     %s   %2i %2i %8.f4 %8.4f \n',iJunk,wrongorder_howardfilenames_from_dirs.savedirname.fname{themapWrong2Right(iJunk)},junk2);

%% see translator_wrong2correct.m
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% all this hinges on clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m  being consistent ... so run check_consistency_clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m
%% and need to checks that sum(zcomp(:))-(64*72*98)    %% if 0, and it is, looks GREAT!!!!
%% YAYAYAYAYAYAYA

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
