addpath /asl/matlib/h4tools
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/COLORMAP
addpath /home/sergio/MATLABCODE/COLORMAP/LLS
addpath /asl/matlib/plotutils

rlat = load('/home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/latB64.mat'); rlat65 = rlat.latB2; rlat = 0.5*(rlat.latB2(1:end-1)+rlat.latB2(2:end));
rlon73 = (1:73); rlon73 = -180 + (rlon73-1)*5;  rlon = (1:72); rlon = -177.5 + (rlon-1)*5;
[Y,X] = meshgrid(rlat,rlon); X = X(:); Y = Y(:);

load llsmap5

[h,ha,p,pa] = rtpread('/home/sergio/KCARTA/WORK/RUN_TARA/GENERIC_RADSnJACS_MANYPROFILES/RTP/summary_17years_all_lat_all_lon_2002_2019_palts_startSept2002_CLEAR.rtp');

figure(1); boo = squeeze(bt_trend_asc(1520,:,:)); boo = boo'; boo = boo(:);
scatter_coast(p.rlon,p.rlat,50,boo); colormap jet; caxis([-1 +1]*0.15); colormap(llsmap5); title('asc dBT1231/dt')
aslmap(1,rlat65,rlon73,smoothn(reshape(boo,72,64)',1), [-90 +90],[-180 +180]); colormap(llsmap5); title('asc dBT1231/dt'); caxis([-1 +1]*0.15);

figure(2); boo = squeeze(bt_trend_desc(1520,:,:)); boo = boo'; boo = boo(:);
scatter_coast(p.rlon,p.rlat,50,boo); colormap jet; caxis([-1 +1]*0.15); colormap(llsmap5); title('desc dBT1231/dt')
aslmap(2,rlat65,rlon73,smoothn(reshape(boo,72,64)',1), [-90 +90],[-180 +180]); colormap(llsmap5); title('desc dBT1231/dt'); caxis([-1 +1]*0.15);

figure(3)
bt1231 =  squeeze(bt_trend_asc(1520,:,:));
cosine = reshape(cos(p.rlat*pi/180),72,64); cosine = cosine'; whos cosine bt1231
boo = cosine; boo = boo'; boo = boo(:);
scatter_coast(p.rlon,p.rlat,30,boo); colormap jet; title('desc dBT1231/dt')

cosine3d = repmat(cosine,1,1,2645); cosine3d = permute(cosine3d,[3 1 2]);
boo = squeeze(cosine3d(1,:,:)); sum(boo(:)-cosine(:))

weight = sum(sum(cosine));
weight_bt_trend_asc = cosine3d.*bt_trend_asc;
weight_bt_trend_desc = cosine3d.*bt_trend_desc;
weight_rad_trend_asc = cosine3d.*rad_trend_asc;
weight_rad_trend_desc = cosine3d.*rad_trend_desc;
weight_rad_asc = cosine3d.*rad_asc;
weight_rad_desc = cosine3d.*rad_desc;

aw_bt_trend_asc = nansum(squeeze(nansum(weight_bt_trend_asc,2)),2)/weight;
aw_bt_trend_desc = nansum(squeeze(nansum(weight_bt_trend_desc,2)),2)/weight;
aw_rad_trend_asc = nansum(squeeze(nansum(weight_rad_trend_asc,2)),2)/weight;
aw_rad_trend_desc = nansum(squeeze(nansum(weight_rad_trend_desc,2)),2)/weight;
aw_rad_std_asc  = reshape(weight_rad_trend_asc,2645,64*72);  aw_rad_std_asc = (std(aw_rad_std_asc'))'/sqrt(64*72);
aw_rad_std_desc = reshape(weight_rad_trend_desc,2645,64*72); aw_rad_std_desc = (std(aw_rad_std_desc'))'/sqrt(64*72);
aw_rad_asc = nansum(squeeze(nansum(weight_rad_asc,2)),2)/weight;
aw_rad_desc = nansum(squeeze(nansum(weight_rad_desc,2)),2)/weight;

figure(4); plot(freq,nanmean(squeeze(nanmean(rad_trend_desc,2)),2),freq,nansum(squeeze(nansum(weight_rad_trend_desc,2)),2)); title('d/dt RAD')
figure(4); plot(freq,nanmean(squeeze(nanmean(bt_trend_desc,2)),2),freq,nansum(squeeze(nansum(weight_bt_trend_desc,2)),2)/weight); title('d/dt BT')
figure(4); plot(freq,nanmean(squeeze(nanmean(bt_trend_desc,2)),2),freq,aw_bt_trend_desc); title('d/dt BT')

figure(4); plot(freq,nanmean(squeeze(nanmean(rad_trend_desc,2)),2),freq,aw_rad_trend_desc); title('d/dt RAD')

figure(3); plot(freq,aw_rad_trend_asc,freq,aw_rad_trend_desc); title('d/dt RAD'); hl = legend('asc','desc','location','best','fontsize',10);
figure(4); plot(freq,aw_bt_trend_asc,freq,aw_bt_trend_desc); title('d/dt BT'); hl = legend('asc','desc','location','best','fontsize',10);

if i10or20 == 19
  fid = fopen('areaweight_19years.txt','w');
elseif i10or20 == 10
  fid = fopen('areaweight_10years.txt','w');
elseif i10or20 == 10.1
  fid = fopen('areaweight_10years_200301_201212.txt','w');
end
array = [freq aw_bt_trend_asc aw_bt_trend_desc aw_rad_trend_asc aw_rad_trend_desc aw_rad_std_asc aw_rad_std_desc aw_rad_asc aw_rad_desc];
fprintf(fid,'%%   FREQ                BTtrend/yr                      rad trend/yr                  std rad trend/yr                    mean rad \n');
fprintf(fid,'%%   cm-1                K/yr                         mW/m2/sr-1/cm-1/yr              mW/m2/sr-1/cm-1/yr               mW/m2/sr-1/cm-1 \n');
fprintf(fid,'%%                 asc              desc             asc            desc             asc            desc              asc            desc \n');  
fprintf(fid,'%%------------------------------------------------------------------------------------------------------------------------------------------\n');
fprintf(fid,'%8.3f  %14.6e   %14.6e   %14.6e   %14.6e    %14.6e   %14.6e    %14.6e   %14.6e \n',array');
fclose(fid);
