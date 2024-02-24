addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/COLORMAP
addpath /asl/matlib/aslutil
addpath /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/StrowCodeforTrendsAndAnomalies
addpath ../../StrowCodeforTrendsAndAnomalies/

%% see clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m
%% see clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m
%% see clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m

%% see /umbc/xfs2/strow/asl/s1/sergio/home/MATLABCODE_Git/PLOTTER/plot_72x64_tiles.m
india = [[2571:2573] [2643:2645] [2715:2717] [2787:2789] [2859:2862] [2931:2934] [3004 3076]];

indiax = (0:7)*72 + 2570; printarray(indiax); plot_72x64_tiles(indiax);
india = [];
for junk = 1 : length(indiax)
  india = [india indiax(junk) + [0:3]];
end
plot_72x64_tiles(india);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theregion = india;
JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
if length(JOB) == 0
  %JOB = 2788; %% central India, land only
  %JOB = 2787; %% ocean + central India (bombay??)
  JOB = 3;
end
JOB = theregion(JOB);

iNumTimeSteps = 457; 

iTile = JOB;
  indY = floor(iTile/72);
  indX = iTile - indY*72;
  indY = indY + 1;
figure(1); vertices = plot_72x64_tiles(iTile);
fout = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(indY,'%02i') '/LonBin' num2str(indX,'%02i') ];
fout = [fout '/iQAX_3_subgrids_LatBin' num2str(indY,'%02i') '_LonBin' num2str(indX,'%02i') '_timesetps_001_' num2str(iNumTimeSteps,'%03d') '_V1.mat'];
if exist(fout)
  fprintf(1,'file already made %s \n',fout);
  error('File exists')
else
  fprintf(1,'saving to %s \n',fout)
end

ypt(1) = vertices(3); ypt(2) = vertices(3) + (vertices(4)-vertices(3))/2;                                                          ypt(3) = vertices(4);
xpt(1) = vertices(1); xpt(2) = vertices(1) + 1*(vertices(2)-vertices(1))/3; xpt(3) = vertices(1) + 2*(vertices(2)-vertices(1))/3;  xpt(4) = vertices(2);  
strx = ['Vertices X coords ' num2str(vertices(1)) ' : ' num2str(vertices(1)) ' (5.00 deg) have been divided into 3 : ']; printarray(xpt,strx);
stry = ['Vertices Y coords ' num2str(vertices(3)) ' : ' num2str(vertices(4)) ' (2.75 deg) have been divided into 2 : ']; printarray(ypt,stry);

line([vertices(1) vertices(2)],[ypt(2) ypt(2)],'color','r','linewidth',1);
line([xpt(2) xpt(2)],[vertices(3) vertices(4)],'color','r','linewidth',1);
line([xpt(3) xpt(3)],[vertices(3) vertices(4)],'color','r','linewidth',1);

pause(0.1)

%% /home/sergio/MATLABCODE/btdiff_1231_1227_to_mmw
%  795.000000   900.308594
% 1511.000000  1226.676758
% 1512.000000  1227.190308
% 1520.000000  1231.327637
% 1861.000000  1419.150146

%% see driver_check_tile_land_or_ocean_hist.m
junk = translator_wrong2correct(iTile)
EW = junk.correctname(end-09:end-03);
NS = junk.correctname(end-16:end-11);

hugedir = dir('/asl/isilon/airs/tile_test7/');  

rKtoCoffset = 273.15;

do_XX_YY_from_X_Y

dbt = 180 : 1 : 340;
set_iQAX

%% see clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m
%% see clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m
%% see clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m

% hugedir(1).name = '.';
% hugedir(2).name = '..';

%% OUTER LOOP       4608 LATBINS   --> 1 FIXED LATBIN/LONBIN TILE == JOB
%%   MIDDLE LOOP    0450 TIMESTEPS
%%     INNER  LOOP  0006 SUBGRIDS

%{
%% and also load ../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin32/LonBin36/iQAX_3_summarystats_LatBin32_LonBin36_timesetps_001_457_V1.mat
%% this BIG ONE BIG LEWANDOWSKI
>> whos *asc
  Name                           Size                   Bytes  Class     Attributes

   cntDCCBT1231_asc               1x457                   3656  double
   count_asc                      1x457                   3656  double
   count_quantile1231_asc       457x5                    18280  double
   day_asc                        1x457                   3656  double
   hist1231_asc                 457x161                 588616  double
   hour_asc                       1x457                   3656  double
   lat_asc                        1x457                   3656  double
   lon_asc                        1x457                   3656  double
   maxBT1231_asc                  1x457                   3656  double
   meanBT1231_asc                 1x457                   1828  single
   meanBT_asc                   457x2645               4835060  single
   minBT1231_asc                  1x457                   3656  double
   month_asc                      1x457                   3656  double
   quantile1231_asc             457x5                    18280  double
   rad_quantile_asc             457x2645x5            48350600  double
   satzen_asc                     1x457                   3656  double
   satzen_quantile1231_asc      457x5                    18280  double
   solzen_asc                     1x457                   3656  double
   solzen_quantile1231_asc      457x5                    18280  double
   tai93_asc                      1x457                   3656  double
   year_asc                       1x457                   3656  double
%}

saveall = make_Nsubgrids_X_iNumTimeStep_X_quants(6,iNumTimeSteps,quants,dbt);

load h2645structure.mat

for tt = 3 : iNumTimeSteps+2                       %% LOOPS OVER TIMESTEPS FOR TIME
%for tt = 3 : 3 + 23*3                       %% LOOPS OVER TIMESTEPS FOR TIME
  date_stamp = ['2015_s283'];   %% example
  date_stamp = hugedir(tt).name;
  fname = ['/asl/isilon/airs/tile_test7/' date_stamp '/' NS '/tile_' date_stamp '_' NS '_' EW '.nc'];
  fprintf(1,' >>> reading Howard tile %s \n',fname);
  [s0, a0] = read_netcdf_h5(fname);
  ianpts0 = 1:s0.total_obs;  

  timestep = tt-2;

  iCnt = 0;                                        %% LOOP OVER 6 subgrids
  for subdivII = 1 : 3
    for subdivJJ = 1 : 2  
      iCnt = iCnt + 1;
      clear s
      booX = find(s0.lon(ianpts0) >= xpt(subdivII) & s0.lon(ianpts0) <= xpt(subdivII+1) & s0.lat(ianpts0) >= ypt(subdivJJ) & s0.lat(ianpts0) <= ypt(subdivJJ+1));
      s.tai93 = s0.tai93(booX);
      s.lon   = s0.lon(booX);
      s.lat   = s0.lat(booX);
      s.land_frac = s0.land_frac(booX);
      s.sol_zen   = s0.sol_zen(booX);
      s.sat_zen   = s0.sat_zen(booX);
      s.asc_flag  = s0.asc_flag(booX);
      s.rad       = s0.rad(:,booX);
      s.rad_qc    = s0.rad_qc(booX);
      s.total_obs = length(booX);

      booD = find(s0.lon(ianpts0) >= xpt(subdivII) & s0.lon(ianpts0) <= xpt(subdivII+1) & s0.lat(ianpts0) >= ypt(subdivJJ) & s0.lat(ianpts0) <= ypt(subdivJJ+1) & s0.asc_flag(ianpts0) == 68);
      booA = find(s0.lon(ianpts0) >= xpt(subdivII) & s0.lon(ianpts0) <= xpt(subdivII+1) & s0.lat(ianpts0) >= ypt(subdivJJ) & s0.lat(ianpts0) <= ypt(subdivJJ+1) & s0.asc_flag(ianpts0) == 65);

      dbt = 200:1:320;
      t1231booD = rad2bt(1231,s0.rad(1520,booD));
      t1231booA = rad2bt(1231,s0.rad(1520,booA));
      
      if (mod(tt-2,23) == 0)
        figure(2)
          plot(s0.lon(booA),s0.lat(booA),'r.',s0.lon(booD),s0.lat(booD),'b.')
          rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);
        figure(2); clf
          scatter(s0.lon(booA),s0.lat(booA),10,t1231booA,'filled'); hold on
          scatter(s0.lon(booD),s0.lat(booD),10,t1231booD,'filled'); hold off; colorbar
          rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);
        figure(3); plot(dbt,histc(t1231booD,dbt),'b',dbt,histc(t1231booA,dbt),'r')
        pause(0.25)
      end
  
      A = find(s.asc_flag == 65);
      D = find(s.asc_flag == 68);
      fprintf(1,'timestep %3i of %3i : II,JJ = %i %2i iCnt=%2i has %5i of %5i FOVS with %4i/%4i = A/D \n',tt-2,iNumTimeSteps,subdivII,subdivJJ,iCnt,length(s.tai93),length(s0.tai93),length(A),length(D))
      saveall = fill_tile_to_subgrids(h,s,iQAX,iCnt,tt-2,saveall,quants,dbt);      
    end
  end
  if (mod(tt-2,23) == 0)
    figure(4); scatter_coast(saveall.lon_asc(:,tt-2),saveall.lat_asc(:,tt-2),500,squeeze(saveall.quantile1231_asc(:,tt-2,3))); colorbar; colormap jet
     rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
     title(['Q03 Asc node timesetp = ' num2str(tt-2)]); cxMax = caxis;
    figure(5); scatter_coast(saveall.lon_desc(:,tt-2),saveall.lat_desc(:,tt-2),500,squeeze(saveall.quantile1231_desc(:,tt-2,3))); colorbar; colormap jet
     rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
     title(['Q03 Desc node timesetp = ' num2str(tt-2)]); cxMin = caxis;
    figure(6); scatter_coast(saveall.lon_desc(:,tt-2),saveall.lat_desc(:,tt-2),500,saveall.landfrac_asc(:,tt-2)); colorbar; colormap jet
     rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
     title(['Q03 Asc Landfrac timesetp = ' num2str(tt-2)])

    vertices2 = [vertices(1)-3 vertices(2)+3 vertices(3)-3 vertices(4)+3];
    figure(4); axis(vertices2); rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','r','linewidth',2);
    figure(5); axis(vertices2); rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','r','linewidth',2);
    figure(6); axis(vertices2); rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','r','linewidth',2);
    cx = [min(cxMax(1),cxMin(1))  max(cxMax(2),cxMin(1))];
    figure(4); caxis(cx);  figure(5); caxis(cx); 
    
    datime = saveall.year_asc(3,1:tt-2) + (saveall.month_asc(3,1:tt-2)-1)/12 + (saveall.day_asc(3,1:tt-2)-1)/12/30;
    figure(7); plot(datime,saveall.quantile1231_desc(:,1:tt-2,3)','b',datime,saveall.quantile1231_asc(:,1:tt-2,3)','r'); title('TimeSeries for (b) desc (r) asc')
    pause(0.1) 
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

make_plots_and_simpleBT12321_trends_3x5_TO_1x1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

comment = 'see ~/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries/clust_tile_3x5_TO_1x1.m';
saver = ['save -v7.3 ' fout ' saveall comment JOB xpt ypt trend'];
fprintf(1,'saving to %s then go to ../Code_for_TileTrends/driver_read_subgrids_trends.m \n',fout)
eval(saver)
