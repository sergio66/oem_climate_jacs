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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

read_in_16days_clear

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
