iQuant = 16;

i10or20 = 10; %% 2005/01 to 2014/12
i10or20 = 19; %% 2002/09 to 2021/08

i10or20

for ii = 1 : 64
  if mod(ii,10) == 0
    fprintf(1,'+')
  else
    fprintf(1,'.')
  end
  for jj = 1 : 72
    if i10or20 == 19
      fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(ii,'%02d') '/LonBin' num2str(jj,'%02d') '/fits_LonBin' num2str(jj,'%02d') '_LatBin' num2str(ii,'%02d') '_V1_TimeSteps433.mat'];
    elseif i10or20 == 10
      %% fits_LonBin*_LatBin01_V1_200500010001_201400120031_TimeStepsX228.mat
      fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(ii,'%02d') '/LonBin' num2str(jj,'%02d') '/fits_LonBin' num2str(jj,'%02d') '_LatBin' num2str(ii,'%02d') '_V1_200500010001_201400120031_TimeStepsX228.mat'];
    end
    a = load(fname);
    rad_desc(:,ii,jj) = squeeze(a.b_desc(:,iQuant,1));
    rad_asc(:,ii,jj) = squeeze(a.b_asc(:,iQuant,1));

    rad_trend_desc(:,ii,jj) = squeeze(a.b_desc(:,iQuant,2));
    bt_trend_desc(:,ii,jj)  = a.dbt_desc(:,iQuant);
    rad_trend_asc(:,ii,jj)  = squeeze(a.b_asc(:,iQuant,2));
    bt_trend_asc(:,ii,jj)   = a.dbt_asc(:,iQuant);
  end
end
freq = a.fairs;
fprintf(1,'\n')
fname

figure(1); plot(freq,nanmean(squeeze(nanmean(rad_trend_desc,2)),2),freq,nanmean(squeeze(nanmean(rad_trend_asc,2)),2)); title('d/dt RAD')
figure(2); plot(freq,nanmean(squeeze(nanmean(bt_trend_desc,2)),2),freq,nanmean(squeeze(nanmean(bt_trend_asc,2)),2)); title('d/dt BT')
if i10or20 == 19
  save ../DATAObsStats_StartSept2002_CORRECT_LatLon/globaltrends20years.mat freq rad_trend_desc rad_trend_asc bt_trend_desc bt_trend_asc rad_desc rad_asc
elseif i10or20 == 10
  save ../DATAObsStats_StartSept2002_CORRECT_LatLon/globaltrends10years.mat freq rad_trend_desc rad_trend_asc bt_trend_desc bt_trend_asc rad_desc rad_asc
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
do_make_text_files
%}
