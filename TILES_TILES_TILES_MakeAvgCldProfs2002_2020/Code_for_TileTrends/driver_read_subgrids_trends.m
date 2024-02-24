addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/PLOTTER/BORDERS/borders
addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/COLORMAP
addpath /asl/matlib/aslutil
addpath /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/StrowCodeforTrendsAndAnomalies
addpath ../../StrowCodeforTrendsAndAnomalies/

%% see Code_For_HowardObs_TimeSeries/clust_tile_3x5_TO_1x1.m
%% see Code_For_HowardObs_TimeSeries/clust_tile_3x5_TO_1x1.m
%% see Code_For_HowardObs_TimeSeries/clust_tile_3x5_TO_1x1.m

%% see /umbc/xfs2/strow/asl/s1/sergio/home/MATLABCODE_Git/PLOTTER/plot_72x64_tiles.m
india = [[2571:2573] [2643:2645] [2715:2717] [2787:2789] [2859:2862] [2931:2934] [3004 3076]];

indiax = (0:7)*72 + 2570; printarray(indiax); plot_72x64_tiles(indiax);
india = [];
for junk = 1 : length(indiax)
  india = [india indiax(junk) + [0:3]];
end
plot_72x64_tiles(india);

iNumTimeSteps = 457;
figure(2);
iQuantile = 3;
iQuantile = 5; %% hottest/clearest
fprintf(1,'iQuantile = %2i \n\n',iQuantile)

region = india;
for ii = 1 : length(region)
  ind = (1:6) + (ii-1)*6;
  fprintf(1,'reading in file %2i of %2i \n',ii,length(region));
  iTile = region(ii);
  indY = floor(iTile/72);
  indX = iTile - indY*72;
  indY = indY + 1;
  figure(2); vertices = plot_72x64_tiles(iTile);
  fin = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(indY,'%02i') '/LonBin' num2str(indX,'%02i') ];
  fin = [fin '/iQAX_3_subgrids_LatBin' num2str(indY,'%02i') '_LonBin' num2str(indX,'%02i') '_timesetps_001_' num2str(iNumTimeSteps,'%03d') '_V1.mat'];
  a = load(fin);
  printarray([(1:6)' nanmean(a.saveall.lon_desc,2) nanmean(a.saveall.lat_desc,2)],[],'lat/lon of 6 grid points')
  disp(' ')

  subgrids_lon(ind) = nanmean(a.saveall.lon_desc,2);
  subgrids_lat(ind) = nanmean(a.saveall.lat_desc,2);

  ascdata = a.trend.meanBT1231_asc(:,iQuantile);
  descdata = a.trend.meanBT1231_desc(:,iQuantile);
  Xdatatemp = nanmean(a.saveall.lon_desc,2);
  Ydatatemp = nanmean(a.saveall.lat_desc,2);

  dx = vertices(2)-vertices(1); dx = dx/4; subgrids_x = linspace(vertices(1),vertices(2),4);  msubgrids_x = meanvaluebin(subgrids_x);
  dy = vertices(4)-vertices(3); dy = dy/3; subgrids_y = linspace(vertices(3),vertices(4),3);  msubgrids_y = meanvaluebin(subgrids_y);
  Xtruetemp = [msubgrids_x(1) msubgrids_x(1) msubgrids_x(2) msubgrids_x(2) msubgrids_x(3) msubgrids_x(3)]';
  Ytruetemp = [msubgrids_y; msubgrids_y; msubgrids_y]; Ytruetemp = Ytruetemp'; Ytruetemp = Ytruetemp(:);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %{
  sungrids saved in following 1 2 3 4 5 6 order        2    4    6 
                                                       1    3    3
  so each time you read a tile displace the top ones by [-dx 0 +dx] and bottom ones by [-dx +dx], so can evenutally (hopefully) sort

                      
                                                                                             ^
                                                                                             |
               o         o          o                             o->         o->          o->
                                                                    |         
                                             ------------>          v                                

               o         o          o                           <-o         <-o          <-o
                                                                |                        |
                                                                V                        v
  %}
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  %% [Xdatatemp Ydatatemp Xtruetemp Ytruetemp Xdatatemp-Xtruetemp Ydatatemp-Ytruetemp]
  Xtemp = Xtruetemp;
  Ytemp = Ytruetemp;

  dx = 1; dx = 0.1; dx = 0.05;
  Xtemp([1 2])   = nanmean(Xtemp([1 2]))   + [-dx +dx];     Xtemp([3 4])   = nanmean(Xtemp([3 4])) + [-dx +dx];       Xtemp([5 6]) = nanmean(Xtemp([5 6])) + [-dx +dx];
  Ytemp([1 3 5]) = nanmean(Ytemp([1 3 5])) + [-dx 0 +dx];   Ytemp([2 4 6]) = nanmean(Ytemp([2 4 6])) + [-dx 0 +dx]; 
  theorder = [1 3 5 2 4 6];
  theorder = [1 2 3 4 5 6]; %% keep this way, then in do_the_plots_subgrids_trends we can sort it
  
  subgrids_lon(ind) = Xtemp(theorder);
  subgrids_lat(ind) = Ytemp(theorder);
  subgrids_asc(ind)  = ascdata(theorder);
  subgrids_desc(ind) = descdata(theorder);

  
  dd = a.saveall.day_desc;
  mm = a.saveall.month_desc;
  yy = a.saveall.year_desc;
  boo = find(yy(1,:) >= 2003 & yy(1,:) <= 2017);
  days2002 = change2days(yy,mm,dd,2002);
  warning on
  for kk = 1 : 6
    data = squeeze(a.saveall.quantile1231_desc(kk,boo,iQuantile));
    B = Math_tsfit_lin_robust(days2002(kk,boo),data,4);
    temptrendD(kk) = B(2);

    data = squeeze(a.saveall.quantile1231_asc(kk,boo,iQuantile));
    B = Math_tsfit_lin_robust(days2002(kk,boo),data,4);
    temptrendA(kk) = B(2);
  end
  warning off
  subgrids_asc2(ind) = temptrendA(theorder);
  subgrids_desc2(ind) = temptrendD(theorder);

end

%% see set_iQAX.m : quants = [0.50 0.80 0.90 0.95 0.97 1.00];
figure(5); 
  imagesc(squeeze(nanmean(a.saveall.count_quantile1231_desc,2))'); colormap jet; colorbar; xlabel('Tile subgrid 1-6'); ylabel('Quantile'); 
    title('Mean Count  Q01=50-80,Q02=80-90 \newline Q03=90-95,Q04=95-97,Q05-97-100')

figure(1); clf; 
vertices = [min(subgrids_lon) max(subgrids_lon) min(subgrids_lat) max(subgrids_lat)];
vertices = plot_72x64_tiles(india);
do_the_plots_subgrids_trends
