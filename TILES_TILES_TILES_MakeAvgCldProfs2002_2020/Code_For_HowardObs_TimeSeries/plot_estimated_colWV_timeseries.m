%% ~/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/figs_put_together_QuantileChoose_trends.m
%% see Line 150 ~/MATLABCODE/oem_pkg_run/FIND_NWP_MODEL_TRENDS/driver_compare_Day_vs_Night_spectral_trends.m : i1226 = find(fchanx >= 1226,1); i1226 = 1511;
%%  moo = b_desc(:,:,i1231) - b_desc(:,:,i1227); aslmap(6,rlat65,rlon73,smoothn(moo',1), [-90 +90],[-180 +180]); title(['d colWV/dt Quantile ' num2str(iQuantile,'%02d')]);
figure(9);
f = h.vchan;
i1419 = find(f >= 1419,1);
i1231 = find(f >= 1231,1);
i1227 = find(f >= 1227,1);
i1226 = find(f >= 1226.5,1); i1226 = 1511;
i0900 = find(f >= 0900,1);

%% from ~sergio/MATLABCODE/btdiff_1231_1227_to_mmw.m      ColWV = 4(BT1231-BT1226)     ColWV = 8(BT1231-BT1227)
iChooseChanColWV = i1227; fChooseChanColWV = 1227; xChooseChanColWV = 8;
iChooseChanColWV = i1226; fChooseChanColWV = 1226; xChooseChanColWV = 4;
fprintf(1,'Plotting estimated ColumnWV ..iChan = %4i  fChan = %6.1f  mmW = %6.2f (BT1231-BT122X) \n',iChooseChanColWV,fChooseChanColWV,xChooseChanColWV);

  wah = rad2bt(1231,s.rad(1520,thesave.asc_Z{iQ})) - rad2bt(fChooseChanColWV,s.rad(iChooseChanColWV,thesave.asc_Z{iQ}));
  figure(9); clf; scatter(s.lon(thesave.asc_Z{iQ}),s.lat(thesave.asc_Z{iQ}),25,wah,'filled'); 
  title(['BT1231-BT' num2str(fChooseChanColWV) ' [colW] ASC Q03']); colormap jet; colorbar
  rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);
  hold on; plot(moo.long,moo.lat,'k','linewidth',2); hold off
  axis([vertices(1)-10 vertices(2)+10 vertices(3)-10 vertices(4)+10])
  axis([vertices(1)-4 vertices(2)+4 vertices(3)-4 vertices(4)+4])

  wah = rad2bt(1231,s.rad(1520,thesave.desc_Z{iQ})) - rad2bt(fChooseChanColWV,s.rad(iChooseChanColWV,thesave.desc_Z{iQ}));
  figure(10); clf; scatter(s.lon(thesave.desc_Z{iQ}),s.lat(thesave.desc_Z{iQ}),25,wah,'filled'); 
  title(['BT1231-BT' num2str(fChooseChanColWV) ' [colW] DESC Q03']); colormap jet; colorbar
  rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);
  hold on; plot(moo.long,moo.lat,'k','linewidth',2); hold off
  axis([vertices(1)-10 vertices(2)+10 vertices(3)-10 vertices(4)+10])
  axis([vertices(1)-4 vertices(2)+4 vertices(3)-4 vertices(4)+4])

  % see ../Code_for_TileTrends/clust_tile_fits_quantiles.m, tile_fits_quantiles.m
  lati = indY;
  loni = indX;
  i16daysSteps = 457;

  %% symbolic link to ./DATAObsStats_StartSept2002_CORRECT_LatLon -> /asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_CORRECT_LatLon
  fdirpre      = '../DATAObsStats_StartSept2002_CORRECT_LatLon/';   
  fn_summary = sprintf('LatBin%1$02d/LonBin%2$02d/iQAX_3_summarystats_LatBin%1$02d_LonBin%2$02d_timesetps_001_%3$03d_V1.mat',lati,loni,i16daysSteps);
  timeseries = load([fdirpre fn_summary],'rad_quantile_asc','rad_quantile_desc');
  figure(11);
  % /home/sergio/MATLABCODE/btdiff_1231_1226_to_mmw.m  says mmw ~ d (BT1231-BT' num2str(fChooseChanColWV) ') if the deltaBT < 6.5 K
  ts1231A = rad2bt(1231,squeeze(timeseries.rad_quantile_asc(:,i1231,iQ)));
  ts122XA = rad2bt(fChooseChanColWV,squeeze(timeseries.rad_quantile_asc(:,iChooseChanColWV,iQ)));
  ts1231D = rad2bt(1231,squeeze(timeseries.rad_quantile_desc(:,i1231,iQ)));
  ts122XD = rad2bt(fChooseChanColWV,squeeze(timeseries.rad_quantile_desc(:,iChooseChanColWV,iQ)));
  plot(yearsfrom2002,smooth(ts1231A-ts122XA,23*iNumYearSm),'r.-',yearsfrom2002,smooth(ts1231D-ts122XD,23*iNumYearSm),'b.-')
    hl = legend('Asc','Desc','location','best'); title(['ColW ~ BT1231-BT' num2str(fChooseChanColWV) '']); ylabel(['BT1231-BT' num2str(fChooseChanColWV) ''])
  
  plot(yearsfrom2002,4*smooth(ts1231A-ts122XA,23*iNumYearSm),'r.-',yearsfrom2002,4*smooth(ts1231D-ts122XD,23*iNumYearSm),'b.-')
    hl = legend('Asc','Desc','location','best'); title(['ColW ~ BT1231-BT' num2str(fChooseChanColWV) '']);  
    ylabel(['ColWV = ' num2str(xChooseChanColWV) ' (BT1231-BT' num2str(fChooseChanColWV) ')'])
  xlim([floor(min(yearsfrom2002)) ceil(max(yearsfrom2002))]); grid
