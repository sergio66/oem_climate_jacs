saveall.vchan = h.vchan;
saveall.ichan = h.ichan;

figure(4); scatter_coast(saveall.lon_asc(:,tt-2),saveall.lat_asc(:,tt-2),500,squeeze(saveall.quantile1231_asc(:,tt-2,3))); colorbar; colormap jet
 rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
 title(['Q03 Asc node timesetp = ' num2str(tt-2)]); cxMax = caxis;
figure(5); scatter_coast(saveall.lon_desc(:,tt-2),saveall.lat_desc(:,tt-2),500,squeeze(saveall.quantile1231_desc(:,tt-2,3))); colorbar; colormap jet
 rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
 title(['Q03 Desc node timesetp = ' num2str(tt-2)]); cxMin = caxis;
figure(6); scatter_coast(saveall.lon_desc(:,tt-2),saveall.lat_desc(:,tt-2),500,saveall.landfrac_asc(:,tt-2)); colorbar; colormap jet
 rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
 title(['Q03 Asc Landfrac timesetp = ' num2str(tt-2)])

vertices2 = [vertices(1)-3 vertices(2)+3 vertices(3)-3 vertices(4)+3];
figure(4); axis(vertices2); rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','r','linewidth',2);
figure(5); axis(vertices2); rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','r','linewidth',2);
figure(6); axis(vertices2); rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','r','linewidth',2);
cx = [min(cxMax(1),cxMin(1))  max(cxMax(2),cxMin(1))];
figure(4); caxis(cx);  figure(5); caxis(cx); 

datime = saveall.year_asc(3,1:tt-2) + (saveall.month_asc(3,1:tt-2)-1)/12 + (saveall.day_asc(3,1:tt-2)-1)/12/30;
figure(7); plot(datime,saveall.quantile1231_desc(:,1:tt-2,3)','b',datime,saveall.quantile1231_asc(:,1:tt-2,3)','r'); title('TimeSeries for (b) desc (r) asc')
xlim([min(datime) max(datime)])

[yy,mm,dd,hh] = tai2utcSergio(saveall.tai_asc(1,1:tt-2) + offset1958_to_1993);
datime = change2days(yy,mm,dd,2002);
figure(7); plot(datime,saveall.quantile1231_desc(:,1:tt-2,3)','b',datime,saveall.quantile1231_asc(:,1:tt-2,3)','r'); title('TimeSeries for (b) desc (r) asc')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ii = 1 : 6
  for jj = 1 : length(quants)-1
    junk = squeeze(saveall.quantile1231_asc(ii,1:tt-2,jj));
    [B,err] = Math_tsfit_lin_robust(datime,junk,4);
    trend.meanBT1231_asc(ii,jj) = B(2);
    trend.meanBT1231_asc_err(ii,jj) = err.se(2);

    %junk = rad2bt(1231,squeeze(saveall.rad_desc(ii,1:tt-2,jj,1520)));
    junk = squeeze(saveall.quantile1231_desc(ii,1:tt-2,jj));
    [B,err] = Math_tsfit_lin_robust(datime,junk,4);
    trend.meanBT1231_desc(ii,jj) = B(2);
    trend.meanBT1231_desc_err(ii,jj) = err.se(2);
  end
end

figure(8); scatter_coast(saveall.lon_asc(:,tt-2),saveall.lat_asc(:,tt-2),500,mean(trend.meanBT1231_asc,2)); colorbar; colormap jet
 rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
 title(['Q03 Asc node trend K/yr']); caxis([-1 +1]*0.3); colormap(usa2)
figure(9); scatter_coast(saveall.lon_desc(:,tt-2),saveall.lat_desc(:,tt-2),500,mean(trend.meanBT1231_desc,2)); colorbar; colormap jet
 rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
 title(['Q03 Desc node trend K/yr']); caxis([-1 +1]*0.3); colormap(usa2)
vertices2 = [vertices(1)-3 vertices(2)+3 vertices(3)-3 vertices(4)+3];
figure(8); axis(vertices2); rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','r','linewidth',2);
figure(9); axis(vertices2); rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','r','linewidth',2);
pause(0.1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iDoSpectralTrends = +1;
if iDoSpectralTrends > 0
  disp('doing 2645 chans : "+" = 1000, "." = 100')
  for ic = 1 : 2645
    if mod(ic,1000) == 0
      fprintf(1,'+')
    elseif mod(ic,100) == 0
      fprintf(1,'.')
    end
  
    for ii = 1 : 6
      for jj = 1 : length(quants)-1
        junk = rad2bt(h.vchan(ic),squeeze(saveall.rad_asc(ii,1:tt-2,jj,ic)));
        good = find(isfinite(junk) & isfinite(datime));
        if length(good) > 20
          [B,err] = Math_tsfit_lin_robust(datime(good),junk(good),4);
          trend.meanBT_asc(ii,jj,ic) = B(2);
          trend.meanBT_asc_err(ii,jj,ic) = err.se(2);
        else
          trend.meanBT_asc(ii,jj,ic) = nan;
          trend.meanBT_asc_err(ii,jj,ic) = nan;
        end

        junk = rad2bt(h.vchan(ic),squeeze(saveall.rad_desc(ii,1:tt-2,jj,ic)));
        good = find(isfinite(junk) & isfinite(datime));
        if length(good) > 20
          [B,err] = Math_tsfit_lin_robust(datime(good),junk(good),4);
          trend.meanBT_desc(ii,jj,ic) = B(2);
          trend.meanBT_desc_err(ii,jj,ic) = err.se(2);
        else
          trend.meanBT_desc(ii,jj,ic) = nan;
          trend.meanBT_desc_err(ii,jj,ic) = nan;
        end
      end
    end
  end
  fprintf(1,'\n');

  figure(10); scatter_coast(saveall.lon_asc(:,tt-2),saveall.lat_asc(:,tt-2),500,mean(squeeze(trend.meanBT_asc(:,:,1520)),2)); colorbar; colormap jet
   rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
   title(['Q03 Asc node BT1231 trend K/yr']); caxis([-1 +1]*0.3); colormap(usa2)
  figure(11); scatter_coast(saveall.lon_desc(:,tt-2),saveall.lat_desc(:,tt-2),500,mean(squeeze(trend.meanBT_desc(:,:,1520)),2)); colorbar; colormap jet
   rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','k','linewidth',2);    
   title(['Q03 Desc node BT1231 trend K/yr']); caxis([-1 +1]*0.3); colormap(usa2)
  vertices2 = [vertices(1)-3 vertices(2)+3 vertices(3)-3 vertices(4)+3];
  figure(10); axis(vertices2); rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','r','linewidth',2);
  figure(11); axis(vertices2); rectangle('position',[vertices(1) vertices(3) vertices(2)-vertices(1) vertices(4)-vertices(3)],'EdgeColor','r','linewidth',2);

  %wahD = reshape(trend.meanBT_desc,30,2645);
  %wahA = reshape(trend.meanBT_asc,30,2645);

  figure(2); clf 
  wahD = squeeze(trend.meanBT_desc(:,3,:));
  wahA = squeeze(trend.meanBT_asc(:,3,:));
  plot(h.vchan,nanmean(wahD,1),'b',h.vchan,nanmean(wahA,1),'r'); plotaxis2; title('nanmean(BT trends) over 6 tiles for Q03'); 
    xlim([640 1640]); hl = legend('desc','asc','location','best');

  figure(3); clf
  wahD = squeeze(trend.meanBT_desc(1,:,:));
  wahA = squeeze(trend.meanBT_asc(1,:,:));
    plot(h.vchan,nanmean(wahD,1),'b',h.vchan,nanmean(wahA,1),'r'); hold on;
  wahD = squeeze(trend.meanBT_desc(3,:,:));
  wahA = squeeze(trend.meanBT_asc(3,:,:));
    plot(h.vchan,nanmean(wahD,1),'c',h.vchan,nanmean(wahA,1),'m'); hold on
  wahD = squeeze(trend.meanBT_desc(5,:,:));
  wahA = squeeze(trend.meanBT_asc(5,:,:));
    plot(h.vchan,nanmean(wahD,1),'k',h.vchan,nanmean(wahA,1),'g'); hold on

  hold off; plotaxis2; title('nanmean(BT trends) over 5 quantiles'); ylabel('subgrid 01,03,05'); 
    xlim([640 1640]); hl = legend('desc01','asc01','desc03','asc03','desc05','asc05','location','best','fontsize',8);

  printarray([(1:6)' nanmean(saveall.lon_desc,2) nanmean(saveall.lat_desc,2)],[],'lat/lon of 6 grid points')
end
