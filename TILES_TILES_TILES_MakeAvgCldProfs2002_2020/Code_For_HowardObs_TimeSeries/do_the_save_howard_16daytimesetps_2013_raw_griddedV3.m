function do_the_save_howard_16daytimesetps_2013_raw_griddedV3(date_stamp,thesave,dbt,quants,wnum,iQAX);

%{
NB : right at the end I set 
    junkLat = iiix; junkLon = jjjx;
    foutXY = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(junkLat,'%02d') '/LonBin' num2str(junkLon,'%02d') '/stats_data_v3_' date_stamp '.mat'];
%}

iCntx = 0;
disp('saving ...... ');
for iiix = 1 : 64              %% latitude
  for jjjx = 1 : 72            %% longitude
    iCntx = iCntx + 1;

    junkLat = iiix; junkLon = jjjx;   
    if iQAX == 1
      foutXY = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(junkLat,'%02d') '/LonBin' num2str(junkLon,'%02d') '/stats_data_v3_quantile_' date_stamp '.mat'];
    elseif iQAX == 0
      foutXY = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(junkLat,'%02d') '/LonBin' num2str(junkLon,'%02d') '/stats_data_v3_quantile_n_extreme_' date_stamp '.mat'];
    elseif iQAX == -1
      foutXY = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(junkLat,'%02d') '/LonBin' num2str(junkLon,'%02d') '/stats_data_v3_extreme_' date_stamp '.mat'];
    elseif iQAX == +2
      foutXY = ['../DATAObsStats_StartSept2002_v3/LatBin' num2str(junkLat,'%02d') '/LonBin' num2str(junkLon,'%02d') '/stats_data_v3_mean_' date_stamp '.mat'];
    end

    clear quicksave
    quicksave.comment = 'see /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/MakeAvgCldProfs2002_2020/clust_check_howard_16daytimesetps_2013_raw_griddedV3.m';
    quicksave.dbt    = dbt;
    quicksave.quants = quants;
    quicksave.wnum   = wnum';

    quicksave.iii = thesave.iii(iCntx);
    quicksave.jjj = thesave.jjj(iCntx);
    if iiix ~= quicksave.iii | jjjx ~= quicksave.jjj
      error('if iiix ~= quicksave.iii | jjjx ~= quicksave.jjj')
    end
    quicksave.count_asc     = thesave.count_asc(iCntx);
    quicksave.lat_asc = thesave.lat_asc(iCntx);
    quicksave.lon_asc = thesave.lon_asc(iCntx);
    quicksave.meansolzen_asc = thesave.meansolzen_asc(iCntx);
    quicksave.stdsolzen_asc  = thesave.stdsolzen_asc(iCntx);
    quicksave.meansatzen_asc = thesave.meansatzen_asc(iCntx);
    quicksave.stdsatzen_asc  = thesave.stdsatzen_asc(iCntx);
    quicksave.meanyear_asc   = thesave.meanyear_asc(iCntx);
    quicksave.stdyear_asc    = thesave.stdyear_asc(iCntx);
    quicksave.meanmonth_asc  = thesave.meanmonth_asc(iCntx);
    quicksave.stdmonth_asc   = thesave.stdmonth_asc(iCntx);
    quicksave.meanday_asc    = thesave.meanday_asc(iCntx);
    quicksave.stdday_asc     = thesave.stdday_asc(iCntx);
    quicksave.meanhour_asc   = thesave.meanhour_asc(iCntx);
    quicksave.stdhour_asc    = thesave.stdhour_asc(iCntx);
    quicksave.meantai93_asc  = thesave.meantai93_asc(iCntx);
    quicksave.stdtai93_asc   = thesave.stdtai93_asc(iCntx);
    quicksave.mean_rad_asc   = thesave.mean_rad_asc(iCntx,:);
    quicksave.std_rad_asc    = thesave.std_rad_asc(iCntx,:);
    quicksave.max1231_asc    = thesave.max1231_asc(iCntx);
    quicksave.min1231_asc    = thesave.min1231_asc(iCntx);
    quicksave.DCC1231_asc    = thesave.DCC1231_asc(iCntx);
    quicksave.hist_asc       = thesave.hist_asc(iCntx,:);
    if iQAX >= 0
      quicksave.quantile1231_asc       = thesave.quantile1231_asc(iCntx,:);
      quicksave.rad_quantile_asc       = squeeze(thesave.rad_asc(iCntx,:,:))';
      quicksave.count_quantile1231_asc = thesave.count_quantile1231_asc(iCntx,:);
      quicksave.satzen_quantile1231_asc = thesave.satzen_quantile1231_asc(iCntx,:);
      quicksave.solzen_quantile1231_asc = thesave.solzen_quantile1231_asc(iCntx,:);
    end
    if iQAX <= 0
      quicksave.rad_max_asc       = squeeze(thesave.rad_max_asc(iCntx,:,:))';
      quicksave.rad_min_asc       = squeeze(thesave.rad_min_asc(iCntx,:,:))';
      quicksave.rad_blockmax_asc  = squeeze(thesave.rad_blockmax_asc(iCntx,:))';
      quicksave.rad_blockmin_asc  = squeeze(thesave.rad_blockmin_asc(iCntx,:))';
    end

    quicksave.count_desc     = thesave.count_desc(iCntx);
    quicksave.lat_desc = thesave.lat_desc(iCntx);
    quicksave.lon_desc = thesave.lon_desc(iCntx);
    quicksave.meansolzen_desc = thesave.meansolzen_desc(iCntx);
    quicksave.stdsolzen_desc  = thesave.stdsolzen_desc(iCntx);
    quicksave.meansatzen_desc = thesave.meansatzen_desc(iCntx);
    quicksave.stdsatzen_desc  = thesave.stdsatzen_desc(iCntx);
    quicksave.meanyear_desc   = thesave.meanyear_desc(iCntx);
    quicksave.stdyear_desc    = thesave.stdyear_desc(iCntx);
    quicksave.meanmonth_desc  = thesave.meanmonth_desc(iCntx);
    quicksave.stdmonth_desc   = thesave.stdmonth_desc(iCntx);
    quicksave.meanday_desc    = thesave.meanday_desc(iCntx);
    quicksave.stdday_desc     = thesave.stdday_desc(iCntx);
    quicksave.meanhour_desc   = thesave.meanhour_desc(iCntx);
    quicksave.stdhour_desc    = thesave.stdhour_desc(iCntx);
    quicksave.meantai93_desc  = thesave.meantai93_desc(iCntx);
    quicksave.stdtai93_desc   = thesave.stdtai93_desc(iCntx);
    quicksave.mean_rad_desc   = thesave.mean_rad_desc(iCntx,:);
    quicksave.std_rad_desc    = thesave.std_rad_desc(iCntx,:);
    quicksave.max1231_desc    = thesave.max1231_desc(iCntx);
    quicksave.min1231_desc    = thesave.min1231_desc(iCntx);
    quicksave.DCC1231_desc    = thesave.DCC1231_desc(iCntx);
    quicksave.hist_desc       = thesave.hist_desc(iCntx,:);
    if iQAX >= 0
      quicksave.quantile1231_desc       = thesave.quantile1231_desc(iCntx,:);
      quicksave.rad_quantile_desc       = squeeze(thesave.rad_desc(iCntx,:,:))';
      quicksave.count_quantile1231_desc = thesave.count_quantile1231_desc(iCntx,:);
      quicksave.satzen_quantile1231_desc = thesave.satzen_quantile1231_desc(iCntx,:);
      quicksave.solzen_quantile1231_desc = thesave.solzen_quantile1231_desc(iCntx,:);
    end
    if iQAX <= 0
      quicksave.rad_max_desc       = squeeze(thesave.rad_max_desc(iCntx,:,:))';
      quicksave.rad_min_desc       = squeeze(thesave.rad_min_desc(iCntx,:,:))';
      quicksave.rad_blockmax_desc  = squeeze(thesave.rad_blockmax_desc(iCntx,:))';
      quicksave.rad_blockmin_desc  = squeeze(thesave.rad_blockmin_desc(iCntx,:))';
    end

    if exist(foutXY)
      fprintf(1,'well wot a waste %s already exists \n',foutXY)
    else
      fprintf(1,'saving %s \n',foutXY);
      save(foutXY,'-struct','quicksave');
    end
  end
end
