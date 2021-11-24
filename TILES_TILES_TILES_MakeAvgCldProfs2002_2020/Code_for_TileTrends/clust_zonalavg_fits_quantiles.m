addpath /asl/matlib/rtptools/
addpath /asl/matlib/aslutil
addpath /asl/matlib/h4tools
addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/matlib/clouds/sarta
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));   %% 1 : 64 for the 64 latbins
%JOB = 32;
%JOB = 11

%% iAorOorL = 0 for all, -1 for land, +1 for ocean
if ~exist('iAorOorL')
  iAorOorL = 0;
end

%system_slurm_stats

alldata_asc   = nan(72,429,2645,16);
alldata_desc  = nan(72,429,2645,16);
allcount_asc  = nan(72,429,16);
allcount_desc = nan(72,429,16);

latstr = num2str(JOB,'%02d');

if iAorOorL == 0
  fout = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' latstr '/trends_zonalavg_fits_quantiles_LatBin' latstr '_timesetps_001_429_V1.mat'];
elseif iAorOorL == -1
  fout = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' latstr '/trends_zonalavg_fits_quantiles_LatBin' latstr '_timesetps_001_429_V1_land.mat'];
elseif iAorOorL == +1
  fout = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' latstr '/trends_zonalavg_fits_quantiles_LatBin' latstr '_timesetps_001_429_V1_ocean.mat'];
end

if exist(fout)
  fprintf(1,'%s exists, not running code \n',fout);
  error('file exists');
end

[h,ha,p,pa] = rtpread('/asl/s1/sergio/MakeAvgProfs2002_2020/summary_17years_all_lat_all_lon_2002_2019_palts.rtp');
ind = (1:72) + (JOB-1)*72;
landfrac = p.landfrac(ind);
if iAorOorL == 0
  usethese = 1:72;
elseif iAorOorL == -1
  usethese = find(landfrac > 0.0);
elseif iAorOorL == +1
  usethese = find(landfrac == 0);
end
fprintf(1,'JOB %2i iAorOorL = %2i so will use %2i of 72 lonbins \n',JOB,iAorOorL,length(usethese));

for ii = 1 : 72
  if mod(ii,10) == 0
    fprintf(1,'+')
  else
    fprintf(1,'.');
  end
  lonstr = num2str(ii,'%02d');
  fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' latstr '/LonBin' lonstr '/summarystats_LatBin' latstr '_LonBin' lonstr '_timesetps_001_429_V1.mat'];
  x = load(fname);
  alldata_asc(ii,:,:,:)  = x.rad_quantile_asc;
  alldata_desc(ii,:,:,:) = x.rad_quantile_desc;
  allcount_asc(ii,:,:)   = x.count_quantile1231_asc;
  allcount_desc(ii,:,:)  = x.count_quantile1231_desc;
end
fprintf(1,'\n');
wnum = x.wnum;

tstep = 1;
qtile = 16;
addpath /asl/matlib/aslutil

wonk = squeeze(alldata_desc(usethese,tstep,:,qtile))';
if length(usethese) > 1
  plot(wnum,wonk,'c',wnum,nanmean(wonk,2),'b')
  plot(wnum,rad2bt(wnum,wonk),'c',wnum,rad2bt(wnum,nanmean(wonk,2)))
elseif length(usethese) == 1
  plot(wnum,wonk,'c',wnum,wonk,'b')
  plot(wnum,rad2bt(wnum,wonk),'c',wnum,rad2bt(wnum,wonk))
end

if length(usethese) > 1
  for tstep = 1 : 429
    for qtile = 1 : 16
      wonk = squeeze(alldata_desc(usethese,tstep,:,qtile))';
      rad_avg_desc(tstep,qtile,:) = nanmean(wonk,2);
  
      wonk = squeeze(alldata_asc(usethese,tstep,:,qtile))';
      rad_avg_asc(tstep,qtile,:) = nanmean(wonk,2);
    end
  end
  count_asc = squeeze(nanmean(allcount_asc(usethese,:,:),1));
  count_desc = squeeze(nanmean(allcount_desc(usethese,:,:),1));
  rad_avg_asc = permute(rad_avg_asc,[1 3 2]);
  rad_avg_desc = permute(rad_avg_desc,[1 3 2]);
elseif length(usethese) == 1
  for tstep = 1 : 429
    for qtile = 1 : 16
      wonk = squeeze(alldata_desc(usethese,tstep,:,qtile))';
      rad_avg_desc(tstep,qtile,:) = wonk;
  
      wonk = squeeze(alldata_asc(usethese,tstep,:,qtile))';
      rad_avg_asc(tstep,qtile,:) = wonk;
    end
  end
  count_asc = squeeze(allcount_asc(usethese,:,:));
  count_desc = squeeze(allcount_desc(usethese,:,:));
  rad_avg_asc = permute(rad_avg_asc,[1 3 2]);
  rad_avg_desc = permute(rad_avg_desc,[1 3 2]);
end

plot(1:429,squeeze(rad_avg_desc(:,1520,:)))
plot(1:429,squeeze(rad_avg_asc(:,1520,:))-squeeze(rad_avg_desc(:,1520,:)))

plot(1:429,smooth(squeeze(rad_avg_asc(:,1520,01))-squeeze(rad_avg_desc(:,1520,01)),23),...
     1:429,smooth(squeeze(rad_avg_asc(:,1520,16))-squeeze(rad_avg_desc(:,1520,16)),23))

trends = tile_fits_zonalavg_quantiles(rad_avg_asc,x.tai93_asc,count_asc,rad_avg_desc,x.tai93_desc,count_desc,429); %% ,[2021 08 31],[2002 09 01]);
trends.quants =  x.quants;
trends.wnum = wnum;
if iAorOorL ~= 0
  trends.usethese = usethese;
end

comment = 'see /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_for_TileTrends/clust_zonalavg_fits_quantiles.m';
saver = ['save ' fout ' trends comment'];
if ~exist(fout)
  fprintf(1,'saving to %s\n',fout);  
  eval(saver)
else
  fprintf(1,'%s exists, not saving \n',fout);
end

figure(1); 
  subplot(211); plot(wnum,trends.dbt_desc(:,[1 16]));     hl = legend('Q1','Q16'); ylabel('trend'); title('desc');
  subplot(212); plot(wnum,trends.dbt_err_desc(:,[1 16])); hl = legend('Q1','Q16'); ylabel('unc');;
figure(2); 
  subplot(211); plot(wnum,trends.dbt_asc(:,[1 16]));     hl = legend('Q1','Q16'); ylabel('trend'); title('asc');
  subplot(212); plot(wnum,trends.dbt_err_asc(:,[1 16])); hl = legend('Q1','Q16'); ylabel('unc');;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
ind_lons = load('/home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/iType_2_convert_sergio_clearskygrid_obsonly_Q16.mat');
do_dah_zonal_comparisons
%}
