% addpath /home/motteler/shome/chirp_test
% addpath /home/sergio/MATLABCODE/TIME
% addpath /home/sergio/MATLABCODE/PLOTTER
% addpath /asl/matlib/aslutil

addpath /home/sergio/git/matlabcode/TIME
addpath /home/sergio/git/matlabcode/PLOTTER
addpath /home/sergio/git/matlabcode/matlibSergio/matlib2025/aslutil
addpath /home/sergio/git/matlabcode/chirp_test

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%{
ls -lt /asl/isilon/airs/tile_test7/2002_s008/                        | wc -l      64 subdirs
ls -lt /asl/isilon/airs/tile_test7/2002_s008/N00p00/tile_2002_s008_* | wc -l      72 files in each subdir
%}

%% 2013_s237 to 2013_s259
%clust_check_howard_16daytimesetps_2013_raw_griddedV2.m:63:isilonX = '/asl/isilon/airs/tile_test7/';          %% on taki, before Apr 2025
%clust_check_howard_16daytimesetps_2013_raw_griddedV2.m:64:isilonX = '/umbc/rs/strow/asl/airs/tile_test7/';   %% on chip, after  Apr 2025
%clust_check_howard_16daytimesetps_2013_raw_griddedV2.m:65:isilonX = '/umbc/rs/strow/asl/airs/tile_test7/';   %% on chip, after  Mar 2026

isilonX = '/asl/isilon/airs/tile_test7/';          %% on taki, before Apr 2025
isilonX = '/umbc/rs/strow/asl/airs/tile_test7/';   %% on chip, after  Apr 2025
isilonX = '/umbc/rs/strow/asl/airs/tile_test7/';   %% on chip, after  Mar 2026
fn = [isilonX '/2013_s237/N00p00/tile_2013_s237_N00p00_E000p00.nc'];
[s, a] = read_netcdf_h5(fn);

ianpts = 1:s.total_obs;
scatter(s.lon(ianpts),s.lat(ianpts),1,s.asc_flag(ianpts)); colorbar
plot(double(s.sol_zen(ianpts)),s.asc_flag(ianpts))

[yy,mm,dd,hh] = tai2utcSergio(s.tai93(ianpts)+offset1958_to_1993);
plot(hh,double(s.sol_zen(ianpts)),'o'); xlabel('hh'); ylabel('Solzen')

pause(1)
dbt = 180 : 1 : 340;
iCnt = 0;
%thedir0 = dir('/asl/isilon/airs/tile_test7/2013_s237/');
thedir0 = dir([isilonX '/2013_s237/'])


for iii = 3 : length(thedir0)
  %dirdirname = ['/asl/isilon/airs/tile_test7/2013_s237/' thedir0(iii).name];
  dirdirname = [isilonX '/2013_s237/' thedir0(iii).name];  
  dirx = dir([dirdirname '/*.nc']);
  for jjj = 1 : length(dirx)
    fname = [dirdirname '/' dirx(jjj).name];
    iCnt = iCnt + 1;
    fprintf(1,'%4i %4i %4i %s \n',iii-2,jjj,iCnt,fname);
 
    [s, a] = read_netcdf_h5(fname);
    ianpts = 1:s.total_obs;
    %scatter(s.lon(ianpts),s.lat(ianpts),1,s.asc_flag(ianpts)); colorbar
    %plot(double(s.sol_zen(ianpts)),s.asc_flag(ianpts))

    thesave.iii(iCnt) = iii-2;
    thesave.jjj(iCnt) = jjj;
    thesave.fname{iCnt} = fname;

    [yy,mm,dd,hh] = tai2utcSergio(s.tai93(ianpts)+offset1958_to_1993);

    asc = find(s.asc_flag(ianpts) == 65);  
    thesave.asc(iCnt) = length(asc);
    thesave.lat_asc(iCnt)  = nanmean(s.lat(asc));
    thesave.lon_asc(iCnt)  = nanmean(s.lon(asc));
    thesave.meansolzen_asc(iCnt) = nanmean(s.sol_zen(asc));
    thesave.stdsolzen_asc(iCnt)  = nanstd(s.sol_zen(asc));
    thesave.meanhour_asc(iCnt) = nanmean(hh(asc));
    thesave.stdhour_asc(iCnt)  = nanstd(hh(asc));
    thesave.mean_rad_asc(iCnt,:) = nanmean(s.rad(:,asc),2);
    thesave.std_rad_asc(iCnt,:)  = nanstd(s.rad(:,asc),0,2);    
    X = rad2bt(1231,s.rad(1520,asc)); Y = quantile(X,0.95);
      Z = find(X >= Y);
      thesave.quantile1231_asc(iCnt) = Y;
      thesave.hot1231_number_asc(iCnt) = length(Z);
      thesave.max1231_asc(iCnt) = max(X);
      thesave.hot_rad_asc(iCnt,:) = nanmean(s.rad(:,asc(Z)),2);   
      thesave.hot_hist_asc(iCnt,:) = histc(X,dbt)/length(X);
   
    desc = find(s.asc_flag(ianpts) == 68);  
    thesave.desc(iCnt) = length(desc);
    thesave.lat_desc(iCnt)  = nanmean(s.lat(desc));
    thesave.lon_desc(iCnt)  = nanmean(s.lon(desc));
    thesave.meansolzen_desc(iCnt) = nanmean(s.sol_zen(desc));
    thesave.stdsolzen_desc(iCnt)  = nanstd(s.sol_zen(desc));
    thesave.meanhour_desc(iCnt) = nanmean(hh(desc));
    thesave.stdhour_desc(iCnt)  = nanstd(hh(desc));
    thesave.mean_rad_desc(iCnt,:) = nanmean(s.rad(:,desc),2);
    thesave.std_rad_desc(iCnt,:)  = nanstd(s.rad(:,desc),0,2);
    X = rad2bt(1231,s.rad(1520,desc)); Y = quantile(X,0.95);
      Z = find(X >= Y);
      thesave.max1231_desc(iCnt) = max(X);
      thesave.quantile1231_desc(iCnt) = Y;
      thesave.hot1231_number_desc(iCnt) = length(Z);
      thesave.hot_rad_desc(iCnt,:) = nanmean(s.rad(:,desc(Z)),2);   
      thesave.hot_hist_desc(iCnt,:) = histc(X,dbt)/length(X);
  end

  if mod(iCnt,72) == 0
    figure(1); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meansolzen_desc); colormap jet; title('desc solzen')
    figure(2); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meansolzen_desc); colormap jet; title('desc solzen')
    figure(3); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meanhour_desc); colormap jet; title('desc hh UTC')
    figure(4); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meanhour_desc); colormap jet; title('desc hh UTC')
%    figure(5); scatter_coast(thesave.lon,thesave.lat_asc,50,thesave.stdhour_asc); colormap jet; title('std asc hh UTC')
%    figure(6); scatter_coast(thesave.lon,thesave.lat_asc,50,thesave.stdhour_desc); colormap jet; title('std desc hh UTC')
    pause(0.1);
  end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('stats_howard_16daytimesetps_2013_raw_gridded.mat')
  disp('saving stats_howard_16daytimesetps_2013_raw_gridded.mat')
  save stats_howard_16daytimesetps_2013_raw_gridded.mat thesave dbt
end

if ~exist('howard_lat_lon_fname.mat')
  %% see driver_convert_WRONG_latlon_individual_2_CORRECT_LatLon.m
  savedirname.iii = thesave.iii;
  savedirname.jjj = thesave.jjj;
  savedirname.lat = thesave.lat_asc;
  savedirname.lon = thesave.lon_asc;
  savedirname.fname = thesave.fname;
  for ii = 1 : 4608;
    fprintf(1,'%s %3i %3i %8.4f %8.4f\n',thesave.fname{ii},thesave.iii(ii),thesave.jjj(ii),thesave.lat_asc(ii),thesave.lon_asc(ii));
  end
  save howard_lat_lon_fname.mat savedirname
end  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meansolzen_desc); colormap jet; title('desc solzen')
figure(2); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meansolzen_desc); colormap jet; title('desc solzen')
figure(3); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meanhour_desc); colormap jet; title('desc hh UTC')
figure(4); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meanhour_desc); colormap jet; title('desc hh UTC')
%figure(5); scatter_coast(thesave.lon,thesave.lat_desc,50,thesave.stdhour_desc); colormap jet; title('std desc hh UTC')
%figure(6); scatter_coast(thesave.lon,thesave.lat_desc,50,thesave.stdhour_desc); colormap jet; title('std desc hh UTC')

figure(5); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.max1231_desc); colormap jet; title('max 1231')
figure(6); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,rad2bt(1231,thesave.mean_rad_desc(:,1520))); colormap jet; title('mean 1231')
figure(7); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.max1231_desc'-rad2bt(1231,thesave.mean_rad_desc(:,1520))); colormap jet; title('max-mean')
figure(8); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,rad2bt(1231,thesave.hot_rad_desc(:,1520))); colormap jet; title('95 percetile 1231')

figure(9); oo = find(thesave.lon_desc <= -175); plot(dbt,thesave.hot_hist_desc(oo,:))
figure(9); oo = find(thesave.lon_desc <= -175); [Y,I] = sort(thesave.lat_desc(oo)); pcolor(thesave.lat_desc(oo(I)),dbt,log10(thesave.hot_hist_desc(oo(I),:)'));
  colormap jet; colorbar; shading interp

%plot(thesave.lon_desc(oo))
%pcolor(thesave.lon_desc,thesave.lat_desc,10,thesave.desc)
