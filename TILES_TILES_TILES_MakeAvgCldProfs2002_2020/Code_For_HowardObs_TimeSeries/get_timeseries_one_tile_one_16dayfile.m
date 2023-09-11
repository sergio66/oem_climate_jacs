function out = get_timeseries_one_tile_one_16dayfile(fname);

%{
can run this after running eg get_timeseries_one_tile.m

https://www.nature.com/articles/s41598-021-02335-7#Ack1 : fires in N. America on 2017/8/18-21
x = get_timeseries_one_tile(47,-45,1);
moo = find(x.yy == 2017 & x.mm >= 8,1);
x.name{moo} =  '/asl/isilon/airs/tile_test7/2005_s074/N49p50/tile_2005_s074_N49p50_W045p00.nc';
out = get_timeseries_one_tile_one_16dayfile(x.name{moo})  

%%%%%%%%%%%%%%%%%%%%%%%%%

https://www.nature.com/articles/s41598-021-02335-7#Ack1 : fires in Australia 2020/1/1-7
xa = get_timeseries_one_tile(-45,-175,1); %%Fig 3a
xb = get_timeseries_one_tile(-55,-120,1); %%Fig 3b
xc = get_timeseries_one_tile(-65,-85,1);  %%Fig 3c

moob = find(xb.yy == 2019 & xb.mm >= 12,2); 
  moob = moob(2); xb.name{moob} =  '/asl/isilon/airs/tile_test7/2019_s396/S55p00/tile_2019_s396_S55p00_W120p00.nc';
out = get_timeseries_one_tile_one_16dayfile(xb.name{moob})  
%}

addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/COLORMAP
addpath /home/sergio/KCARTA/MATLAB

a = read_netcdf_lls(fname);

N = a.total_obs;
ianpts = 1 : N;

asc  = find(a.asc_flag(ianpts) == 65);
desc = find(a.asc_flag(ianpts) == 68);

[yy,mm,dd] = tai2utcSergio(a.tai93(1:N) + offset1958_to_1993);
doy = change2days(yy,mm,dd,2002);

boxx = [floor(min(a.lon(ianpts))) ceil(max(a.lon(ianpts)))];
boxy = [floor(min(a.lat(ianpts))) ceil(max(a.lat(ianpts)))];

iCnt = 0;
for tt = min(doy) : max(doy)
  iCnt = iCnt + 1;
  boo = find(doy == tt);
  out.yy(iCnt) = mean(yy(boo));
  out.mm(iCnt) = mean(mm(boo));
  out.dd(iCnt) = mean(dd(boo));
  out.doy(iCnt) = mean(doy(boo));

  out.lat(iCnt) = mean(a.lat(boo));
  out.lon(iCnt) = mean(a.lon(boo));

  out.mean_rad(:,iCnt) = nanmean(a.rad(:,boo),2);
  out.max_rad(:,iCnt)  = nanmax(a.rad(:,boo),[],2);
  out.min_rad(:,iCnt)  = nanmin(a.rad(:,boo),[],2);

  out.mean_rad_1231(iCnt) = nanmean(a.rad(1520,boo));
  out.max_rad_1231(iCnt)  = nanmax(a.rad(1520,boo));
  out.min_rad_1231(iCnt)  = nanmin(a.rad(1520,boo));

  iiCnt = 0;
  for ii = boxx(1):0.25:boxx(2)
    iiCnt = iiCnt + 1;
    jjCnt = 0;
    for jj = boxy(1):0.25:boxy(2)
      jjCnt = jjCnt + 1;
      out.boxlon(iCnt,iiCnt,jjCnt) = ii;
      out.boxlat(iCnt,iiCnt,jjCnt) = jj;
      boo = find(doy == tt & a.lon(1:N) >= ii & a.lon(1:N) < ii+1 & a.lat(1:N) >= jj & a.lat(1:N) < jj+1);
      if length(boo) > 2
        out.boxrad(iCnt,iiCnt,jjCnt,:) = nanmean(a.rad(:,boo),2);
      else
        out.boxrad(iCnt,iiCnt,jjCnt,:) = nan(1,2645);
      end
    end
  end
end

out.freq             = a.wnum;
load h2645structure.mat
out.freq             = h.vchan;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ttt = 2002 + out.doy/365;
figure(1); plot(ttt,rad2bt(1231,out.min_rad_1231),'b',ttt,rad2bt(1231,out.mean_rad_1231),'g',ttt,rad2bt(1231,out.max_rad_1231),'r'); 
title('BT 1231')

figure(2); plot(out.freq,rad2bt(out.freq,out.mean_rad))
pcolor(out.freq,1:16,rad2bt(out.freq,out.mean_rad)')
  shading interp; xlim([640 1640]); colormap jet; ylabel('16 day count')
  colorbar
title('Time series of BT(v)')

figure(3); 
tobs = rad2bt(out.freq,out.mean_rad);
pcolor(out.freq,1:16,(tobs - nanmean(tobs,2))');
  shading interp; xlim([640 1640]); colormap jet; ylabel('16 day count')
  colorbar; colormap(usa2); caxis([-1 +1]*10)
title('Time series of BT(v)-<BT(v)>')

figure(4); 
scatter(out.lon,out.lat,50,out.dd(1) + (0:15),'filled'); colorbar; colormap jet
 xlabel('Lon'); ylabel('lat'); 
 str =  ['Colorbar = day of month from ' num2str(yy(1)) '/' num2str(mm(1),'%02d') '/' num2str(dd(1),'%02d')];
 title(str)

figure(5); colormap jet
f0 = 667.5;
moo = find(out.freq >= f0,1);
wahx = squeeze(out.boxlon(1,:,:));
wahy = squeeze(out.boxlat(1,:,:));
for tt = 1 : 16; 
  data = squeeze(out.boxrad(tt,:,:,moo));
  data = rad2bt(f0,data);
  %pcolor(wahx,wahy,data); title(num2str(tt)); colorbar; pause(0.1)
  %imagesc(wahx(:),wahy(:),data(:)); title(num2str(tt)); colorbar; pause(0.1)
  figure(5); scatter(wahx(:),wahy(:),100,data(:),'filled'); 
  title(['BT timeseries for v=' num2str(f0) ' ' num2str(tt)]); 
  colorbar; pause(0.1)
end

data = squeeze(out.boxrad(:,:,:,moo));
data = rad2bt(f0,data);
data = squeeze(nanmean(data,2));
wahy = squeeze(out.boxlat(1,:,:));
wahy = wahy(1,:);
figure(6);
data = data - nanmean(data,1);
pcolor((0:15)+out.dd(1),wahy,data'); colormap(usa2); shading interp; 
title(['Anomaly BT timeseries for v=' num2str(f0)])
colorbar; caxis([-1 +1]*5); xlabel(['day of '  num2str(yy(1)) '/' num2str(mm(1),'%02d')]); ylabel('Latitude');
