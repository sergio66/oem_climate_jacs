disp('binning the quantiles of the 72 latbins : + is 10, . is 1')
for ii = 1 : 72
  if mod(ii,10) == 0
    fprintf(1,'+')
  else
    fprintf(1,'.')
  end
  if iaFound(ii) == 1
    junk = squeeze(tobs(ii,1520,1:iaNct(ii)));
    xjunk = squeeze(tobs(ii,:,1:iaNct(ii)));
    xquants(ii,:) = quantile(junk,quants);  
    for xx = 1 : length(quants)-1
      ind = find(junk >= xquants(ii,xx) & junk <= max(junk));
      len(ii,xx) = length(ind);
      mean_btallchans(ii,xx,:) = nanmean(xjunk(:,ind),2);
      std_btallchans(ii,xx,:) = nanstd(xjunk(:,ind),[],2);
    end
  else
    for xx = 1 : length(quants)-1
      len(ii,xx) = 0;
      mean_btallchans(ii,xx,:) = nan;
      std_btallchans(ii,xx,:)  = nan;
    end
  end
end

figure(1); clf; pcolor(len'); colorbar; shading interp; title('Number found'); xlabel('LonBin'); ylabel('Quantile');

fprintf(1,'\n');
figure(2); clf; plot(a.hout.vchan,real(squeeze(nanmean(mean_btallchans,1)))); title('Mean Spectra');     xlim([640 1640]); hl = legend(num2str(quants(1:end-1)'),'location','best','fontsize',10);
figure(3); clf; plot(a.hout.vchan,real(squeeze(nanmean(std_btallchans,1))));  title('Std Dev Spectra');  xlim([640 1640]); hl = legend(num2str(quants(1:end-1)'),'location','best','fontsize',10);

wah = real(squeeze(nanmean(mean_btallchans,1)));
figure(4); clf; plot(a.hout.vchan,ones(7,1)*wah(5,:)-wah); xlim([640 1640]); hl = legend(num2str(quants(1:end-1)'),'location','best','fontsize',10);
title('Q90 - rest of QX')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('pclear_Aug2012.mat')
  [yy,mm,dd,hh] = tai2utcSergio(a.p2.rtime);
  %% Aug 27, 2012- Sep 11, 2012
  days_so_far = convert2daysinyear(a.p2.rtime);
  
  for ii = min(days_so_far) : max(days_so_far)
    frtp = ['/asl/rtp/airs/airs_l1c_v672/clear/2012/era_airicrad_day' num2str(ii,'%03d') '_clear.rtp'];
    [h,ha,p,pa] = rtpread(frtp);
    boo = find(p.solzen < 90);
    [h,p] = subset_rtp(h,p,[],[],boo);
    if ii == min(days_so_far)
      pclear.rlat  = p.rlat;
      pclear.rlon  = p.rlon;
      pclear.rtime = p.rtime;
      pclear.r1231 = p.robs1(1520,:);
    else
      pclear.rlat  = [pclear.rlat  p.rlat];
      pclear.rlon  = [pclear.rlon  p.rlon];
      pclear.rtime = [pclear.rtime p.rtime];
      pclear.r1231 = [pclear.r1231 p.robs1(1520,:)];
    end
  end
  commentX = 'see do_the_plots_ecmwf_or_era_16days_tile_onelatbin.m';
  save pclear_Aug2012.mat pclear commentX
else
  load pclear_Aug2012.mat
end
figure(5); clf; simplemap(pclear.rlat,pclear.rlon,rad2bt(1231,pclear.r1231))

disp('doing the "clear Q90 --> Q100')
clr_rlat = [];
clr_rlon = [];
clr_rtime = [];
clr_r1231 = [];
moo = find(quants == 0.97);
moo = find(quants == 0.90);
for ii = 1 : 72
  if mod(ii,10) == 0
    fprintf(1,'+')
  else
    fprintf(1,'.')
  end
  if iaFound(ii) == 1
    junk = squeeze(tobs(ii,1520,1:iaNct(ii)));
    xjunk = squeeze(tobs(ii,:,1:iaNct(ii)));
    xquants(ii,:) = quantile(junk,quants);  
    for xx = moo
      ind = find(junk >= xquants(ii,xx) & junk <= max(junk) & (landfrac(ii,1:iaNct(ii))') == 0);
      clr_rlat  = [clr_rlat rlat(ii,ind)];
      clr_rlon  = [clr_rlon rlon(ii,ind)];
      clr_rtime = [clr_rtime rtime(ii,ind)];
      clr_r1231 = [clr_r1231 junk(ind)'];
    end
  end
end
figure(6); clf; simplemap(clr_rlat,clr_rlon,clr_r1231);
figure(5); cx = caxis;
figure(6); caxis(cx);

lonbins = -180 : 5: +180
for ii = 1 : length(lonbins)-1
  boo = find(clr_rlon >= lonbins(ii) & clr_rlon < lonbins(ii+1));
  count_Q90(ii) = length(boo);
  boo = find(pclear.rlon >= lonbins(ii) & pclear.rlon < lonbins(ii+1) & pclear.rlat >= min(clr_rlat) & pclear.rlat < max(clr_rlat));
  count_clearflag(ii) = length(boo);
end
figure(7); clf; plot(meanvaluebin(lonbins),count_Q90,meanvaluebin(lonbins),count_clearflag,'linewidth',2)
  hl = legend('Q90','clear flag','location','best'); ylabel('"clear" count'); xlabel('longitude')
