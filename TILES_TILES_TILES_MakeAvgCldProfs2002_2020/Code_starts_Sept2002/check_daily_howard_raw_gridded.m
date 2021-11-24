addpath /home/motteler/shome/chirp_test
addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/PLOTTER

%{
ls -lt /asl/isilon/airs/tile_test7/2002_s008/                        | wc -l      64 subdirs
ls -lt /asl/isilon/airs/tile_test7/2002_s008/N00p00/tile_2002_s008_* | wc -l      72 files in each subdir
%}

fn = '/asl/isilon/airs/tile_test7/2002_s008/N00p00/tile_2002_s008_N00p00_E000p00.nc';
[s, a] = read_netcdf_h5(fn);

ianpts = 1:s.total_obs;
scatter(s.lon(ianpts),s.lat(ianpts),1,s.asc_flag(ianpts)); colorbar
plot(double(s.sol_zen(ianpts)),s.asc_flag(ianpts))

[yy,mm,dd,hh] = tai2utcSergio(s.tai93(ianpts)+offset1958_to_1993);
plot(hh,double(s.sol_zen(ianpts)),'o'); xlabel('hh'); ylabel('Solzen')

pause(1)
iCnt = 0;
thedir0 = dir('/asl/isilon/airs/tile_test7/2002_s008/');
for iii = 3 : length(thedir0)
  dirdirname = ['/asl/isilon/airs/tile_test7/2002_s008/' thedir0(iii).name];
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
    thesave.lat(iCnt)  = nanmean(s.lat(asc));
    thesave.lon(iCnt)  = nanmean(s.lon(asc));
    thesave.meansolzen_asc(iCnt) = nanmean(s.sol_zen(asc));
    thesave.stdsolzen_asc(iCnt)  = nanstd(s.sol_zen(asc));
    thesave.meanhour_asc(iCnt) = nanmean(hh(asc));
    thesave.stdhour_asc(iCnt)  = nanstd(hh(asc));

    desc = find(s.asc_flag(ianpts) == 68);  
    thesave.desc(iCnt) = length(desc);
    thesave.lat(iCnt)  = nanmean(s.lat(desc));
    thesave.lon(iCnt)  = nanmean(s.lon(desc));
    thesave.meansolzen_desc(iCnt) = nanmean(s.sol_zen(desc));
    thesave.stdsolzen_desc(iCnt)  = nanstd(s.sol_zen(desc));
    thesave.meanhour_desc(iCnt) = nanmean(hh(desc));
    thesave.stdhour_desc(iCnt)  = nanstd(hh(desc));

  end
  if mod(iCnt,72) == 0
    figure(1); scatter_coast(thesave.lon,thesave.lat,50,thesave.meansolzen_asc); colormap jet; title('asc solzen')
    figure(2); scatter_coast(thesave.lon,thesave.lat,50,thesave.meansolzen_desc); colormap jet; title('desc solzen')
    figure(3); scatter_coast(thesave.lon,thesave.lat,50,thesave.meanhour_asc); colormap jet; title('asc hh UTC')
    figure(4); scatter_coast(thesave.lon,thesave.lat,50,thesave.meanhour_desc); colormap jet; title('desc hh UTC')
    figure(5); scatter_coast(thesave.lon,thesave.lat,50,thesave.stdhour_asc); colormap jet; title('std asc hh UTC')
    figure(6); scatter_coast(thesave.lon,thesave.lat,50,thesave.stdhour_desc); colormap jet; title('std desc hh UTC')
    pause(0.1);
  end
end

save stats_daily_howard_raw_gridded.mat thesave
