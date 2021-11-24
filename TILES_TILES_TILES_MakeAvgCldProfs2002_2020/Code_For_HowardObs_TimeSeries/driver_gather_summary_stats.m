for jj = 1 : 64
  fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/summarystats_LatBin' num2str(jj,'%02d') '_LonBin_1_72_timesetps_001_412_V1.mat'];
  a = load(fname);
  rlat(jj,:,:) = a.rlat;
  rlon(jj,:,:) = a.rlon;
  meanBT1231(jj,:,:) = a.meanBT1231;
  maxBT1231(jj,:,:) = a.maxBT1231;
  minBT1231(jj,:,:) = a.minBT1231;
  dccBT1231(jj,:,:) = a.dccBT1231;
end

wahlat = squeeze(rlat(:,:,1));
wahlon = squeeze(rlon(:,:,1));
wahmean = squeeze(meanBT1231(:,:,1));
wahmin = squeeze(minBT1231(:,:,1));
wahmax = squeeze(maxBT1231(:,:,1));
wahdcc = squeeze(dccBT1231(:,:,1));

figure(1); scatter_coast(wahlon(:)+2.5,wahlat(:),100,wahmax(:)); title('max')
figure(2); scatter_coast(wahlon(:)+2.5,wahlat(:),100,wahmean(:)); title('mean')
figure(3); scatter_coast(wahlon(:)+2.5,wahlat(:),100,wahmin(:)); title('min')
figure(4); scatter_coast(wahlon(:)+2.5,wahlat(:),100,wahdcc(:)); title('DCC count BT1231 < 220'); caxis([0 500]); jett = jet; jett(1,:) = 1; colormap(jett);

addpath /home/sergio/MATLABCODE/SHOWSTATS
addpath /home/sergio/MATLABCODE/FIND_TRENDS
warning off
for jj = 1 : 64
  if mod(jj,10) == 0
    fprintf(1,'+')
  else
    fprintf(1,'.')
  end
  for ii = 1 : 72
    len = length(squeeze(maxBT1231(jj,ii,:)));
    [fitc err stats] = Math_tsfit_robust_filter(((1:len)-1)*16,squeeze(maxBT1231(jj,ii,:)),4);  trend_maxBT1231(jj,ii) = fitc(2);
    [fitc err stats] = Math_tsfit_robust_filter(((1:len)-1)*16,squeeze(minBT1231(jj,ii,:)),4);  trend_minBT1231(jj,ii) = fitc(2);
    [fitc err stats] = Math_tsfit_robust_filter(((1:len)-1)*16,squeeze(meanBT1231(jj,ii,:)),4); trend_meanBT1231(jj,ii) = fitc(2);
    [fitc err stats] = Math_tsfit_robust_filter(((1:len)-1)*16,squeeze(dccBT1231(jj,ii,:)),4);  trend_dccBT1231(jj,ii) = fitc(2);
  end
end
warning on
fprintf(1,'\n');
figure(1); scatter_coast(wahlon(:)+2.5,wahlat(:),100,trend_maxBT1231(:)); title('max'); caxis([-0.2 +0.2]); colormap(usa2)
figure(2); scatter_coast(wahlon(:)+2.5,wahlat(:),100,trend_meanBT1231(:)); title('mean');  caxis([-0.2 +0.2]);colormap(usa2)
figure(3); scatter_coast(wahlon(:)+2.5,wahlat(:),100,trend_minBT1231(:)); title('min');  caxis([-0.2 +0.2]); colormap(usa2)
figure(4); scatter_coast(wahlon(:)+2.5,wahlat(:),100,trend_dccBT1231(:)); title('DCC count BT1231 < 220'); caxis([-2 2]); ; colormap(usa2)
