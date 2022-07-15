iQuant = 16;

for ii = 1 : 64
  fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(ii,'%02d') '/trends_zonalavg_fits_quantiles_LatBin' num2str(ii,'%02d') '_timesetps_001_429_V1.mat'];
  a = load(fname);
  rad_trend_desc(:,ii) = squeeze(a.trends.b_desc(:,iQuant,2));
  bt_trend_desc(:,ii)  = a.trends.dbt_desc(:,iQuant);
  rad_trend_asc(:,ii)  = squeeze(a.trends.b_asc(:,iQuant,2));
  bt_trend_asc(:,ii)   = a.trends.dbt_asc(:,iQuant);
end
freq = a.trends.wnum;

figure(1); plot(freq,nanmean(rad_trend_desc,2),freq,nanmean(rad_trend_asc,2)); title('d/dt rad')
figure(2); plot(freq,nanmean(bt_trend_desc,2),freq,nanmean(bt_trend_asc,2)); title('d/dt BT')
