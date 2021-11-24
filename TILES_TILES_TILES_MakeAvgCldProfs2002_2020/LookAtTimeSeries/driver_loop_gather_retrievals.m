addpath /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/StrowCodeforTrendsAndAnomalies
addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/COLORMAP
addpath /home/sergio/KCARTA/MATLAB
addpath /asl/matlib/rtptools
addpath /asl/matlib/aslutil
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS/

iVers = 1;
iVers = 2;
iVers = 3;

%% Susskind AIRS Jan 2003-Dec 2017  Recent global warming as confirmed by AIRS : Environ. Res. Lett.14(2019)044030  Environ. Res. Lett.14(2019)044030https://doi.org/10.1088/1748-9326/aafd4e
%% D.Zhou   IASI Sep 2007-Nov 2020  Surface Skin Temperature and Its Trend Obser-vationsfrom IASI on Board MetOp Satellites, JSTARS DOI 10.1109/JSTARS.2020.3046421

t1_AIRS = utc2taiSergio(2002,01,01,0.000);  t2_AIRS = utc2taiSergio(2020,08,31,23.999); 
t1_Suss = utc2taiSergio(2003,01,01,0.000);  t2_Suss = utc2taiSergio(2017,12,31,23.999); 
t1_Zhou = utc2taiSergio(2007,09,01,0.000);  t2_Zhou = utc2taiSergio(2020,08,31,23.999); 

warning off
for jj = 1 : 64
  for ii = 1 : 72
    clear boo*
    JOB = (jj-1)*72 + ii;
    if iVers == 1
      fname = ['RTP_PROFS/Cld/CRODGERS_FAST_CLOUD_Retrievals/V1/retrieval_cld_timestep_lonbin_' num2str(ii,'%02d')];
      fname = [fname '_latbin_' num2str(jj,'%02d') '_JOB_' num2str(JOB,'%04d') '16_iDET_4_iStemp_ColWV_5_iCenterFov_-1_iCO2_Yes_No_Switch_-1.mat'];
    elseif iVers == 2
      fname = ['RTP_PROFSV2/Cld/CRODGERS_FAST_CLOUD_Retrievals/V2/retrievalV2_cld_timestep_lonbin_' num2str(ii,'%02d')];
      fname = [fname '_latbin_' num2str(jj,'%02d') '_JOB_' num2str(JOB,'%04d') '16_iDET_4_iStemp_ColWV_5_iCenterFov_-1_iCO2_Yes_No_Switch_-1.mat'];
    elseif iVers == 3
      fname = ['RTP_PROFSV2/Cld/CRODGERS_FAST_CLOUD_Retrievals/V3/retrievalV3_cld_timestep_lonbin_' num2str(ii,'%02d')];
      fname = [fname '_latbin_' num2str(jj,'%02d') '_JOB_' num2str(JOB,'%04d') '_iCO2_Yes_No_Switch_-1.mat'];
    end
    if exist(fname)
      x = load(fname);
      iaaFound(ii,jj) = 1;
      results.rlon(ii,jj) = mean(x.poemNew.rlon);
      results.rlat(ii,jj) = mean(x.poemNew.rlat);
      time = (1:length(x.poemNew.stemp))*16;     

      x.poemNew = convert_rtp_to_cloudOD(x.hoemNew,x.poemNew);

      %% ALL 
      booAIRS = find(x.poemNew.rtime >= t1_AIRS & x.poemNew.rtime <= t2_AIRS);
        data = x.poemNew.stemp(booAIRS);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booAIRS),data,4);
        results.AIRS_stemp(ii,jj) = nanmean(data);
        results.AIRS_stemp_trend(ii,jj) = B(2);
    
        data = x.poemNew.iceOD(booAIRS);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booAIRS),data,4);
        results.AIRS_iceOD(ii,jj) = nanmean(data);
        results.AIRS_iceOD_trend(ii,jj) = B(2);

        data = x.poemNew.icetop(booAIRS);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booAIRS),data,4);
        results.AIRS_icetop(ii,jj) = nanmean(data);
        results.AIRS_icetop_trend(ii,jj) = B(2);

        data = x.poemNew.icesze(booAIRS);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booAIRS),data,4);
        results.AIRS_icesze(ii,jj) = nanmean(data);
        results.AIRS_icesze_trend(ii,jj) = B(2);

        data = x.poemNew.icefrac(booAIRS);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booAIRS),data,4);
        results.AIRS_icefrac(ii,jj) = nanmean(data);
        results.AIRS_icefrac_trend(ii,jj) = B(2);

        data = x.poemNew.waterOD(booAIRS);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booAIRS),data,4);
        results.AIRS_waterOD(ii,jj) = nanmean(data);
        results.AIRS_waterOD_trend(ii,jj) = B(2);

        data = x.poemNew.watertop(booAIRS);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booAIRS),data,4);
        results.AIRS_watertop(ii,jj) = nanmean(data);
        results.AIRS_watertop_trend(ii,jj) = B(2);

        data = x.poemNew.watersze(booAIRS);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booAIRS),data,4);
        results.AIRS_watersze(ii,jj) = nanmean(data);
        results.AIRS_watersze_trend(ii,jj) = B(2);

        data = x.poemNew.waterfrac(booAIRS);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booAIRS),data,4);
        results.AIRS_waterfrac(ii,jj) = nanmean(data);
        results.AIRS_waterfrac_trend(ii,jj) = B(2);
    
        data = rad2bt(1231,x.poemNew.robs1(1520,booAIRS));
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booAIRS),data,4);
        results.AIRS_BT1231_obs(ii,jj) = nanmean(data);
        results.AIRS_BT1231_obs_trend(ii,jj) = B(2);
    
        data = rad2bt(1231,x.poemNew.rcalc(1520,booAIRS));
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booAIRS),data,4);
        results.AIRS_BT1231_cal(ii,jj) = nanmean(data);
        results.AIRS_BT1231_cal_trend(ii,jj) = B(2);
    
        mmw = mmwater_rtp(x.hoemNew,x.poemNew);
        data = mmw(booAIRS);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booAIRS),data,4);
        results.AIRS_mmw(ii,jj) = nanmean(data);
        results.AIRS_mmw_trend(ii,jj) = B(2);

        [~,co2] = layers2ppmv(x.hoemNew,x.poemNew,1:length(x.poemNew.stemp),2);
        data = co2(booAIRS);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booAIRS),data,4);
        results.AIRS_co2(ii,jj) = nanmean(data);
        results.AIRS_co2_trend(ii,jj) = B(2);
  
        data = x.poemNew.stemp_prof0(booAIRS);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booAIRS),data,4);
        results.AIRS_stemp_ERA(ii,jj) = nanmean(data);
        results.AIRS_stemp_ERA_trend(ii,jj) = B(2);
  
      %% Suss
      booSUSS = find(x.poemNew.rtime >= t1_Suss & x.poemNew.rtime <= t2_Suss);
        data = x.poemNew.stemp(booSUSS);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booSUSS),data,4);
        results.SUSS_stemp(ii,jj) = nanmean(data);
        results.SUSS_stemp_trend(ii,jj) = B(2);

        data = x.poemNew.iceOD(booSUSS);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booSUSS),data,4);
        results.SUSS_iceOD(ii,jj) = nanmean(data);
        results.SUSS_iceOD_trend(ii,jj) = B(2);

        data = x.poemNew.icetop(booSUSS);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booSUSS),data,4);
        results.SUSS_icetop(ii,jj) = nanmean(data);
        results.SUSS_icetop_trend(ii,jj) = B(2);

        data = x.poemNew.icesze(booSUSS);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booSUSS),data,4);
        results.SUSS_icesze(ii,jj) = nanmean(data);
        results.SUSS_icesze_trend(ii,jj) = B(2);

        data = x.poemNew.icefrac(booSUSS);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booSUSS),data,4);
        results.SUSS_icefrac(ii,jj) = nanmean(data);
        results.SUSS_icefrac_trend(ii,jj) = B(2);

        data = x.poemNew.waterOD(booSUSS);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booSUSS),data,4);
        results.SUSS_waterOD(ii,jj) = nanmean(data);
        results.SUSS_waterOD_trend(ii,jj) = B(2);

        data = x.poemNew.watertop(booSUSS);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booSUSS),data,4);
        results.SUSS_watertop(ii,jj) = nanmean(data);
        results.SUSS_watertop_trend(ii,jj) = B(2);

        data = x.poemNew.watersze(booSUSS);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booSUSS),data,4);
        results.SUSS_watersze(ii,jj) = nanmean(data);
        results.SUSS_watersze_trend(ii,jj) = B(2);

        data = x.poemNew.waterfrac(booSUSS);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booSUSS),data,4);
        results.SUSS_waterfrac(ii,jj) = nanmean(data);
        results.SUSS_waterfrac_trend(ii,jj) = B(2);
    
        data = rad2bt(1231,x.poemNew.robs1(1520,booSUSS));
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booSUSS),data,4);
        results.SUSS_BT1231_obs(ii,jj) = nanmean(data);
        results.SUSS_BT1231_obs_trend(ii,jj) = B(2);
    
        data = rad2bt(1231,x.poemNew.rcalc(1520,booSUSS));
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booSUSS),data,4);
        results.SUSS_BT1231_cal(ii,jj) = nanmean(data);
        results.SUSS_BT1231_cal_trend(ii,jj) = B(2);
    
        mmw = mmwater_rtp(x.hoemNew,x.poemNew);
        data = mmw(booSUSS);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booSUSS),data,4);
        results.SUSS_mmw(ii,jj) = nanmean(data);
        results.SUSS_mmw_trend(ii,jj) = B(2);

        [~,co2] = layers2ppmv(x.hoemNew,x.poemNew,1:length(x.poemNew.stemp),2);
        data = co2(booSUSS);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booSUSS),data,4);
        results.SUSS_co2(ii,jj) = nanmean(data);
        results.SUSS_co2_trend(ii,jj) = B(2);
  
        data = x.poemNew.stemp_prof0(booSUSS);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booSUSS),data,4);
        results.SUSS_stemp_ERA(ii,jj) = nanmean(data);
        results.SUSS_stemp_ERA_trend(ii,jj) = B(2);

      %% Zhou
      booZHOU = find(x.poemNew.rtime >= t1_Zhou & x.poemNew.rtime <= t2_Zhou);
        data = x.poemNew.stemp(booZHOU);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booZHOU),data,4);
        results.ZHOU_stemp(ii,jj) = nanmean(data);
        results.ZHOU_stemp_trend(ii,jj) = B(2);
    
        data = x.poemNew.iceOD(booZHOU);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booZHOU),data,4);
        results.ZHOU_iceOD(ii,jj) = nanmean(data);
        results.ZHOU_iceOD_trend(ii,jj) = B(2);

        data = x.poemNew.icetop(booZHOU);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booZHOU),data,4);
        results.ZHOU_icetop(ii,jj) = nanmean(data);
        results.ZHOU_icetop_trend(ii,jj) = B(2);

        data = x.poemNew.icesze(booZHOU);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booZHOU),data,4);
        results.ZHOU_icesze(ii,jj) = nanmean(data);
        results.ZHOU_icesze_trend(ii,jj) = B(2);

        data = x.poemNew.icefrac(booZHOU);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booZHOU),data,4);
        results.ZHOU_icefrac(ii,jj) = nanmean(data);
        results.ZHOU_icefrac_trend(ii,jj) = B(2);

        data = x.poemNew.waterOD(booZHOU);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booZHOU),data,4);
        results.ZHOU_waterOD(ii,jj) = nanmean(data);
        results.ZHOU_waterOD_trend(ii,jj) = B(2);

        data = x.poemNew.watertop(booZHOU);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booZHOU),data,4);
        results.ZHOU_watertop(ii,jj) = nanmean(data);
        results.ZHOU_watertop_trend(ii,jj) = B(2);

        data = x.poemNew.watersze(booZHOU);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booZHOU),data,4);
        results.ZHOU_watersze(ii,jj) = nanmean(data);
        results.ZHOU_watersze_trend(ii,jj) = B(2);

        data = x.poemNew.waterfrac(booZHOU);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booZHOU),data,4);
        results.ZHOU_waterfrac(ii,jj) = nanmean(data);
        results.ZHOU_waterfrac_trend(ii,jj) = B(2);

        data = rad2bt(1231,x.poemNew.robs1(1520,booZHOU));
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booZHOU),data,4);
        results.ZHOU_BT1231_obs(ii,jj) = nanmean(data);
        results.ZHOU_BT1231_obs_trend(ii,jj) = B(2);
    
        data = rad2bt(1231,x.poemNew.rcalc(1520,booZHOU));
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booZHOU),data,4);
        results.ZHOU_BT1231_cal(ii,jj) = nanmean(data);
        results.ZHOU_BT1231_cal_trend(ii,jj) = B(2);
    
        mmw = mmwater_rtp(x.hoemNew,x.poemNew);
        data = mmw(booZHOU);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booZHOU),data,4);
        results.ZHOU_mmw(ii,jj) = nanmean(data);
        results.ZHOU_mmw_trend(ii,jj) = B(2);

        [~,co2] = layers2ppmv(x.hoemNew,x.poemNew,1:length(x.poemNew.stemp),2);
        data = co2(booZHOU);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booZHOU),data,4);
        results.ZHOU_co2(ii,jj) = nanmean(data);
        results.ZHOU_co2_trend(ii,jj) = B(2);
  
        data = x.poemNew.stemp_prof0(booZHOU);
        [B, stats] = Math_tsfit_lin_robust_finitewrapper(time(booZHOU),data,4);
        results.ZHOU_stemp_ERA(ii,jj) = nanmean(data);
        results.ZHOU_stemp_ERA_trend(ii,jj) = B(2);
  
      %whos boo*
    else
      iaaFound(ii,jj) = 0;
      results.rlon(ii,jj) = NaN;
      results.rlat(ii,jj) = NaN;
      results.AIRS_stemp(ii,jj) = NaN;
      results.AIRS_stemp_trend(ii,jj) = NaN;
      results.AIRS_iceOD(ii,jj) = NaN;
      results.AIRS_iceOD_trend(ii,jj) = NaN;
      results.AIRS_icetop(ii,jj) = NaN;
      results.AIRS_icetop_trend(ii,jj) = NaN;
      results.AIRS_icesze(ii,jj) = NaN;
      results.AIRS_icesze_trend(ii,jj) = NaN;
      results.AIRS_icefrac(ii,jj) = NaN;
      results.AIRS_icefrac_trend(ii,jj) = NaN;
      results.AIRS_waterOD(ii,jj) = NaN;
      results.AIRS_waterOD_trend(ii,jj) = NaN;
      results.AIRS_watertop(ii,jj) = NaN;
      results.AIRS_watertop_trend(ii,jj) = NaN;
      results.AIRS_watersze(ii,jj) = NaN;
      results.AIRS_watersze_trend(ii,jj) = NaN;
      results.AIRS_waterfrac(ii,jj) = NaN;
      results.AIRS_waterfrac_trend(ii,jj) = NaN;
      results.AIRS_BT1231_obs(ii,jj) = NaN;
      results.AIRS_BT1231_obs_trend(ii,jj) = NaN;
      results.AIRS_BT1231_cal(ii,jj) = NaN;
      results.AIRS_BT1231_cal_trend(ii,jj) = NaN;
      results.AIRS_mmw(ii,jj) = NaN;
      results.AIRS_mmw_trend(ii,jj) = NaN;      
      results.AIRS_co2(ii,jj) = NaN;
      results.AIRS_co2_trend(ii,jj) = NaN;      
      results.AIRS_stemp_ERA(ii,jj) = NaN;
      results.AIRS_stemp_ERA_trend(ii,jj) = NaN;      

      results.SUSS_stemp(ii,jj) = NaN;
      results.SUSS_stemp_trend(ii,jj) = NaN;
      results.SUSS_iceOD(ii,jj) = NaN;
      results.SUSS_iceOD_trend(ii,jj) = NaN;
      results.SUSS_icetop(ii,jj) = NaN;
      results.SUSS_icetop_trend(ii,jj) = NaN;
      results.SUSS_icesze(ii,jj) = NaN;
      results.SUSS_icesze_trend(ii,jj) = NaN;
      results.SUSS_icefrac(ii,jj) = NaN;
      results.SUSS_icefrac_trend(ii,jj) = NaN;
      results.SUSS_waterOD(ii,jj) = NaN;
      results.SUSS_waterOD_trend(ii,jj) = NaN;
      results.SUSS_watertop(ii,jj) = NaN;
      results.SUSS_watertop_trend(ii,jj) = NaN;
      results.SUSS_watersze(ii,jj) = NaN;
      results.SUSS_watersze_trend(ii,jj) = NaN;
      results.SUSS_waterfrac(ii,jj) = NaN;
      results.SUSS_waterfrac_trend(ii,jj) = NaN;
      results.SUSS_BT1231_obs(ii,jj) = NaN;
      results.SUSS_BT1231_obs_trend(ii,jj) = NaN;
      results.SUSS_BT1231_cal(ii,jj) = NaN;
      results.SUSS_BT1231_cal_trend(ii,jj) = NaN;
      results.SUSS_mmw(ii,jj) = NaN;
      results.SUSS_mmw_trend(ii,jj) = NaN;      
      results.SUSS_co2(ii,jj) = NaN;
      results.SUSS_co2_trend(ii,jj) = NaN;      
      results.SUSS_stemp_ERA(ii,jj) = NaN;
      results.SUSS_stemp_ERA_trend(ii,jj) = NaN;      

      results.ZHOU_stemp(ii,jj) = NaN;
      results.ZHOU_stemp_trend(ii,jj) = NaN;
      results.ZHOU_iceOD(ii,jj) = NaN;
      results.ZHOU_iceOD_trend(ii,jj) = NaN;
      results.ZHOU_icetop(ii,jj) = NaN;
      results.ZHOU_icetop_trend(ii,jj) = NaN;
      results.ZHOU_icesze(ii,jj) = NaN;
      results.ZHOU_icesze_trend(ii,jj) = NaN;
      results.ZHOU_icefrac(ii,jj) = NaN;
      results.ZHOU_icefrac_trend(ii,jj) = NaN;
      results.ZHOU_waterOD(ii,jj) = NaN;
      results.ZHOU_waterOD_trend(ii,jj) = NaN;
      results.ZHOU_watertop(ii,jj) = NaN;
      results.ZHOU_watertop_trend(ii,jj) = NaN;
      results.ZHOU_watersze(ii,jj) = NaN;
      results.ZHOU_watersze_trend(ii,jj) = NaN;
      results.ZHOU_waterfrac(ii,jj) = NaN;
      results.ZHOU_waterfrac_trend(ii,jj) = NaN;
      results.ZHOU_BT1231_obs(ii,jj) = NaN;
      results.ZHOU_BT1231_obs_trend(ii,jj) = NaN;
      results.ZHOU_BT1231_cal(ii,jj) = NaN;
      results.ZHOU_BT1231_cal_trend(ii,jj) = NaN;
      results.ZHOU_mmw(ii,jj) = NaN;
      results.ZHOU_mmw_trend(ii,jj) = NaN;      
      results.ZHOU_co2(ii,jj) = NaN;
      results.ZHOU_co2_trend(ii,jj) = NaN;      
      results.ZHOU_stemp_ERA(ii,jj) = NaN;
      results.ZHOU_stemp_ERA_trend(ii,jj) = NaN;      
    end  
  end
  if mod(jj,10) == 0
    fprintf(1,'+')
  else
    fprintf(1,'.')
  end
  %scatter_coast(results.rlon(:),results.rlat(:),10,results.AIRS_stemp_trend(:)); pause(0.1);
end
warning on
fprintf(1,'\n');

comment = 'see driver_loop_gather_retrievals_cld.m --- AIRS = 2002/09-2020/08, Zhou = IASI = 2007/09 to 2020/08; Suss = 2003/01 to 2017/12';
%{
if iVers == 1
  results.comment = comment; save('retrieval_results.mat','-struct','results');
elseif iVers == 2
  results.comment = comment; save('retrieval_resultsV2.mat','-struct','results');
elseif iVers == 3
  results.comment = comment; save('retrieval_resultsV3.mat','-struct','results');
end
%}

whos boo*
results.rlat0 = results.rlat; results.rlon0 = results.rlon;  %% just in case there are NaNs
loop_gather_retrievals_plots
