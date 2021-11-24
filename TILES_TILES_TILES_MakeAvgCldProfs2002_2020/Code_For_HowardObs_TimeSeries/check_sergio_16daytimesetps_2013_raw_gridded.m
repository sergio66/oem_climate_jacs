addpath /home/motteler/shome/chirp_test
addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /asl/matlib/aslutil

%{
ls -lt DATA_OneYear/                        | wc -l      4608 + 2 subdirs
ls -lt ls -lt DATA_OneYear/1111             | wc -l      24files in each subdir
%}

dbt = 180 : 1 : 340;
iCnt = 0;
thedir0 = dir('DATA_OneYear/');
for iii = 3 : length(thedir0)-1
  dirdirname = ['DATA_OneYear/' thedir0(iii).name];
  dirx = dir([dirdirname '/*.mat']);
  %for jjj = 1 : length(dirx)
  for jjj = 1 : 1
    fname = [dirdirname '/' dirx(jjj).name];
    iCnt = iCnt + 1;
    fprintf(1,'%4i %4i %4i %s \n',iii-2,jjj,iCnt,fname);
 
    loader = ['s = load(''' fname ''');']; eval(loader)
    ianpts = 1:length(s.p2x.stemp);
    %scatter(s.p2x.rlon(ianpts),s.p2x.rlat(ianpts),50,s.p2x.stemp(ianpts)); colorbar
    %plot(double(s.p2x.sol_zen(ianpts)),s.p2x.asc_flag(ianpts))

    thesave.iii(iCnt) = iii-2;
    thesave.jjj(iCnt) = jjj;
    thesave.fname{iCnt} = fname;

    [yy,mm,dd,hh] = tai2utcSergio(s.p2x.rtime(ianpts));

    asc = find(s.p2x.solzen(ianpts) < 90);  
    if length(asc) > 0
      thesave.asc(iCnt) = length(asc);
      thesave.lat_asc(iCnt)  = nanmean(s.p2x.rlat(asc));
      thesave.lon_asc(iCnt)  = nanmean(s.p2x.rlon(asc));
      thesave.meansolzen_asc(iCnt) = nanmean(s.p2x.solzen(asc));
      thesave.stdsolzen_asc(iCnt)  = nanstd(s.p2x.solzen(asc));
      thesave.meanhour_asc(iCnt) = nanmean(hh(asc));
      thesave.stdhour_asc(iCnt)  = nanstd(hh(asc));
      thesave.mean_rad_asc(iCnt,:) = nanmean(s.p2x.rcalc(:,asc),2);
      thesave.std_rad_asc(iCnt,:)  = nanstd(s.p2x.rcalc(:,asc),0,2);    
      thesave.mean_rclr_asc(iCnt,:) = nanmean(s.p2x.sarta_rclearcalc(:,asc),2);
      thesave.std_rclr_asc(iCnt,:)  = nanstd(s.p2x.sarta_rclearcalc(:,asc),0,2);    
      X = rad2bt(1231,s.p2x.rcalc(5,asc)); Y = quantile(X,0.95);
      Xclr = rad2bt(1231,s.p2x.sarta_rclearcalc(5,asc));
        Z = find(X >= Y);
        thesave.quantile1231_asc(iCnt) = Y;
        thesave.hot1231_number_asc(iCnt) = length(Z);
        thesave.max1231_asc(iCnt) = max(X);
        thesave.hot_rad_asc(iCnt,:) = nanmean(s.p2x.rcalc(:,asc(Z)),2);   
        thesave.hot_hist_asc(iCnt,:) = histc(X,dbt)/length(X);
        thesave.max1231clr_asc(iCnt) = max(Xclr);
        thesave.hot_radclr_asc(iCnt,:) = nanmean(s.p2x.sarta_rclearcalc(:,asc(Z)),2);   
    end
   
    desc = find(s.p2x.solzen(ianpts) > 90);  
    thesave.desc(iCnt) = length(desc);
    thesave.lat_desc(iCnt)  = nanmean(s.p2x.rlat(desc));
    thesave.lon_desc(iCnt)  = nanmean(s.p2x.rlon(desc));
    thesave.meansolzen_desc(iCnt) = nanmean(s.p2x.solzen(desc));
    thesave.stdsolzen_desc(iCnt)  = nanstd(s.p2x.solzen(desc));
    thesave.meanhour_desc(iCnt) = nanmean(hh(desc));
    thesave.stdhour_desc(iCnt)  = nanstd(hh(desc));
    thesave.mean_rad_desc(iCnt,:) = nanmean(s.p2x.rcalc(:,desc),2);
    thesave.std_rad_desc(iCnt,:)  = nanstd(s.p2x.rcalc(:,desc),0,2);
    thesave.mean_rclr_desc(iCnt,:) = nanmean(s.p2x.sarta_rclearcalc(:,desc),2);
    thesave.std_rclr_desc(iCnt,:)  = nanstd(s.p2x.sarta_rclearcalc(:,desc),0,2);    
    X = rad2bt(1231,s.p2x.rcalc(5,desc)); Y = quantile(X,0.95);
    Xclr = rad2bt(1231,s.p2x.sarta_rclearcalc(5,desc));
      Z = find(X >= Y);
      thesave.quantile1231_desc(iCnt) = Y;
      thesave.hot1231_number_desc(iCnt) = length(Z);
      thesave.max1231_desc(iCnt) = max(X);
      thesave.hot_rad_desc(iCnt,:) = nanmean(s.p2x.rcalc(:,desc(Z)),2);   
      thesave.hot_hist_desc(iCnt,:) = histc(X,dbt)/length(X);
      thesave.max1231clr_desc(iCnt) = max(Xclr);
      thesave.hot_radclr_desc(iCnt,:) = nanmean(s.p2x.sarta_rclearcalc(:,desc(Z)),2);   
  end
  if mod(iCnt,72) == 0
    figure(1); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meansolzen_desc); colormap jet; title('desc solzen')
    figure(2); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meansolzen_desc); colormap jet; title('desc solzen')
    figure(3); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meanhour_desc); colormap jet; title('desc hh UTC')
    figure(4); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meanhour_desc); colormap jet; title('desc hh UTC')
%    figure(5); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.stdhour_desc); colormap jet; title('std desc hh UTC')
%    figure(6); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.stdhour_desc); colormap jet; title('std desc hh UTC')
    pause(0.1);
  end
end

%{
save stats_sergio_16daytimesetps_2013_raw_gridded.mat thesave dbt
%}

figure(1); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meansolzen_desc); colormap jet; title('desc solzen')
figure(2); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meansolzen_desc); colormap jet; title('desc solzen')
figure(3); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meanhour_desc); colormap jet; title('desc hh UTC')
figure(4); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.meanhour_desc); colormap jet; title('desc hh UTC')
%figure(5); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.stdhour_desc); colormap jet; title('std desc hh UTC')
%figure(6); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.stdhour_desc); colormap jet; title('std desc hh UTC')
figure(5); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.max1231_desc); colormap jet; title('max 1231')
figure(6); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,rad2bt(1231,thesave.mean_rad_desc(:,5))); colormap jet; title('mean 1231')
figure(7); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,thesave.max1231_desc'-rad2bt(1231,thesave.mean_rad_desc(:,5))); colormap jet; title('max-mean')
figure(8); scatter_coast(thesave.lon_desc,thesave.lat_desc,50,rad2bt(1231,thesave.hot_rad_desc(:,5))); colormap jet; title('95 percetile 1231')

figure(9); oo = find(thesave.lon_desc <= -175); plot(dbt,thesave.hot_hist_desc(oo,:))
figure(9); oo = find(thesave.lon_desc <= -175); pcolor(thesave.lat_desc(oo),dbt,log10(thesave.hot_hist_desc(oo,:)'));
  colormap jet; colorbar; shading interp
