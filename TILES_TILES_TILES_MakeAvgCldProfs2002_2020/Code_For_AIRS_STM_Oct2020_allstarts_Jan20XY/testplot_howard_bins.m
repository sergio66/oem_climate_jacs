addpath /home/motteler/shome/obs_stats/source
addpath /asl/matlib/h4tools

rlon1 = -180:5:+180;
rlat1 =  -90:3:+90;

load latB64.mat; rlat1 = latB2;

[h,ha,p,pa] = rtpread('DATA/pall_16daytimestep_001_2014_01_01_to_2014_01_16_1.rp.rtp');
tcalc = rad2bt(h.vchan,p.rcalc);

load DATA/pall_16daytimestep_001_2014_01_01_to_2014_01_16_1.mat
load DATA/demall_howard.mat

i2014 = find(demall.startdate(:,1) == 2014,1)
fh1 = equal_area_map(1, rlat1, rlon1, reshape(rad2bt(1231,demall.rcloud(i2014,:)),64,72), 'ERA', [200 320]); colormap jet

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load latB64.mat

rlon2 = rlon1;
rlat2 = latB2;
howard = load('/home/motteler/shome/obs_stats/map_16day_airs_all/airs_map_all_y2014s01.mat');
% sum(howard.wnum - h.vchan)
tobs = rad2bt(h.vchan,reshape(howard.gavg,2645,64*72));

plot(1:64*72,tobs(1520,:)-tcalc(1520,:))

fh2 = equal_area_map(2, rlat2, rlon2, squeeze(rad2bt(1231,howard.gavg(1520,:,:))), 'AIRS', [200 320]); colormap jet

[Lon1,Lat1] = meshgrid(0.5*(rlon1(1:end-1)+rlon1(2:end)),0.5*(rlat1(1:end-1)+rlat1(2:end)));
t1    = reshape(rad2bt(1231,demall.rcloud(i2014,:)),64,72);
t1clr = reshape(rad2bt(1231,demall.rclear(i2014,:)),64,72);

[Lon2,Lat2] = meshgrid(0.5*(rlon2(1:end-1)+rlon2(2:end)),0.5*(rlat2(1:end-1)+rlat2(2:end)));
t2 = squeeze(rad2bt(1231,howard.gavg(1520,:,:)));

t11    = interp2(Lon1,Lat1,t1,Lon2,Lat2);
t11clr = interp2(Lon1,Lat1,t1clr,Lon2,Lat2);
fh3 = equal_area_map(3, rlat2, rlon2, t2 - t11,    'AIRS-ERAcld', [-10 +10]); colormap jet
fh4 = equal_area_map(4, rlat2, rlon2, t11clr - t2, 'ERAclr-AIRS', [-30 +30]); colormap jet

fh3 = equal_area_map(3, rlat2, rlon2, t2 - t11,    'AIRS-ERAcld',[-20 +20]); colormap jet
fh4 = equal_area_map(4, rlat2, rlon2, t11clr - t2, 'ERAclr-AIRS'); colormap jet
fh5 = equal_area_map(5, rlat2, rlon2, t11clr - t11,'ERAclr-ERAcld'); colormap jet

fh4 = equal_area_map(4, rlat2, rlon2, t11clr - t2, 'ERAclr-AIRS',  [-10 40]); colormap jet
fh5 = equal_area_map(5, rlat2, rlon2, t11clr - t11,'ERAclr-ERAcld',[-10 40]); colormap jet

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

plot(h.vchan,nanmean(tobs'-tcalc'),'b',h.vchan,nanstd(tobs'-tcalc'),'c')
