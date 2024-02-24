function saveall = make_Nsubgrids_X_iNumTimeStep_X_quants(nsubgrids,iNumTimeSteps,quants,dbt);

saveall.landfrac_asc            = nan(nsubgrids,iNumTimeSteps);
saveall.cntDCCBT1231_asc        = nan(nsubgrids,iNumTimeSteps);
saveall.count_asc               = nan(nsubgrids,iNumTimeSteps);
saveall.lat_asc                 = nan(nsubgrids,iNumTimeSteps);
saveall.lon_asc                 = nan(nsubgrids,iNumTimeSteps);
saveall.tai_asc                 = nan(nsubgrids,iNumTimeSteps);
saveall.day_asc                 = nan(nsubgrids,iNumTimeSteps);
saveall.hour_asc                = nan(nsubgrids,iNumTimeSteps);
saveall.month_asc               = nan(nsubgrids,iNumTimeSteps);
saveall.year_asc                = nan(nsubgrids,iNumTimeSteps);
saveall.solzen_asc              = nan(nsubgrids,iNumTimeSteps);
saveall.satzen_asc              = nan(nsubgrids,iNumTimeSteps);
saveall.maxBT1231_asc           = nan(nsubgrids,iNumTimeSteps);
saveall.minBT1231_asc           = nan(nsubgrids,iNumTimeSteps);
saveall.meanBT1231_asc          = nan(nsubgrids,iNumTimeSteps);
saveall.meanBT_asc              = nan(nsubgrids,iNumTimeSteps,2645);
saveall.quantile1231_asc        = nan(nsubgrids,iNumTimeSteps,length(quants)-1);
saveall.satzen_quantile1231_asc = nan(nsubgrids,iNumTimeSteps,length(quants)-1);
saveall.solzen_quantile1231_asc = nan(nsubgrids,iNumTimeSteps,length(quants)-1);
%saveall.rad_quantile_asc        = nan(nsubgrids,iNumTimeSteps,2645,length(quants)-1);
saveall.count_quantile1231_asc  = nan(nsubgrids,iNumTimeSteps,length(quants)-1);
saveall.hist1231_asc            = nan(nsubgrids,iNumTimeSteps,length(dbt));

saveall.landfrac_desc            = nan(nsubgrids,iNumTimeSteps);
saveall.cntDCCBT1231_desc        = nan(nsubgrids,iNumTimeSteps);
saveall.count_desc               = nan(nsubgrids,iNumTimeSteps);
saveall.lat_desc                 = nan(nsubgrids,iNumTimeSteps);
saveall.lon_desc                 = nan(nsubgrids,iNumTimeSteps);
saveall.tai_desc                 = nan(nsubgrids,iNumTimeSteps);
saveall.day_desc                 = nan(nsubgrids,iNumTimeSteps);
saveall.hour_desc                = nan(nsubgrids,iNumTimeSteps);
saveall.month_desc               = nan(nsubgrids,iNumTimeSteps);
saveall.year_desc                = nan(nsubgrids,iNumTimeSteps);
saveall.solzen_desc              = nan(nsubgrids,iNumTimeSteps);
saveall.satzen_desc              = nan(nsubgrids,iNumTimeSteps);
saveall.maxBT1231_desc           = nan(nsubgrids,iNumTimeSteps);
saveall.minBT1231_desc           = nan(nsubgrids,iNumTimeSteps);
saveall.meanBT1231_desc          = nan(nsubgrids,iNumTimeSteps);
saveall.meanBT_desc              = nan(nsubgrids,iNumTimeSteps,2645);
saveall.quantile1231_desc        = nan(nsubgrids,iNumTimeSteps,length(quants)-1);
saveall.satzen_quantile1231_desc = nan(nsubgrids,iNumTimeSteps,length(quants)-1);
saveall.solzen_quantile1231_desc = nan(nsubgrids,iNumTimeSteps,length(quants)-1);
%saveall.rad_quantile_desc        = nan(nsubgrids,iNumTimeSteps,2645,length(quants)-1);
saveall.count_quantile1231_desc  = nan(nsubgrids,iNumTimeSteps,length(quants)-1);
saveall.hist1231_desc            = nan(nsubgrids,iNumTimeSteps,length(dbt));
