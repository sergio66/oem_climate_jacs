function y = tile_fits_zonalavg_quantiles_anomalies(nquants,rad_quantile_asc,tai93_asc,count_asc,rad_quantile_desc,tai93_desc,count_desc,i16daysSteps,stopdate,startdate);

%% this does anomlies (and trends as by product)
%% based on tile_fits_quantiles_anomalies.m

if nargin < 8
  error('need 8 arguments nquants,rada,rtimea,counta,radd,rtimed,countd,i16daysSteps,[stopD],[startD]')
end
if nargin == 8
  startdate = [2002 09 01];
  stopdate  = [2025 08 81];
end
if nargin == 9
  startdate = [2002 09 01];
end

%addpath /asl/matlib/aslutil
%addpath /asl/matlib/time
%addpath /home/strow/Matlab/Math

load_fairs

% % AIRS channel ID
% ch = 1520;

p = [-0.17 -0.15 -1.66  1.06];

mtime = tai2dtime(airs2tai(tai93_desc));
dtime = datenum(mtime);

%nquants
%stopdate
%startdate
%nargin

if nargin == 8
  fprintf(1,'  fitting entire data set \n')
  k_desc = count_desc./(ones(i16daysSteps,1)*median(count_desc)) > 0.98; % all data
  k_asc = count_asc./(ones(i16daysSteps,1)*median(count_asc)) > 0.98;    % all data
elseif nargin == 9
  fprintf(1,'  fitting till and including %4i/%2i/%2i \n',stopdate)
  k_desc1 = count_desc./(ones(i16daysSteps,1)*median(count_desc)) > 0.98;
    k_desc1(isnan(k_desc1) | isinf(k_desc1)) = false;
    k_desc1 = prod(k_desc1,2);	  
    k_desc = k_desc1' & (mtime <= datetime(stopdate(1),stopdate(2),stopdate(3)));
    
  k_asc1 = count_asc./(ones(i16daysSteps,1)*median(count_asc)) > 0.98;
    k_asc1(isnan(k_asc1) | isinf(k_asc1)) = false;
    k_asc1 = prod(k_asc1,2);	  	      
    k_asc = k_asc1' & (mtime <= datetime(stopdate(1),stopdate(2),stopdate(3)));

  for ix = 1 : nquants
    k_desc(ix,:) = count_desc(:,ix)'./nanmedian(count_desc(:,ix)) > 0.98 & (mtime <= datetime(stopdate(1),stopdate(2),stopdate(3)));
    k_asc(ix,:) = count_asc(:,ix)'./nanmedian(count_asc(:,ix)) > 0.98 & (mtime <= datetime(stopdate(1),stopdate(2),stopdate(3)));
  end
  k_desc = k_desc';
  k_asc  = k_asc';  
  
elseif nargin == 10
  fprintf(1,'  fitting between %4i/%2i/%2i and %4i/%2i/%2i \n',startdate,stopdate)
  k_desc = count_desc./(ones(i16daysSteps,1)*median(count_desc)) > 0.98 & (mtime >= datetime(startdate(1),startdate(2),startdate(3)) & mtime <= datetime(stopdate(1),stopdate(2),stopdate(3)));
  k_asc = count_asc./(ones(i16daysSteps,1)*median(count_asc)) > 0.98 & (mtime >= datetime(startdate(1),startdate(2),startdate(3)) & mtime <= datetime(stopdate(1),stopdate(2),stopdate(3)));
end

% y.b_asc = NaN(2645,nquants,10);
% y.b_desc = NaN(2645,nquants,10);
% y.berr_asc = NaN(2645,nquants,10);
% y.berr_desc = NaN(2645,nquants,10);
% 
% y.dbt_asc = NaN(2645,nquants);
% y.dbt_desc = NaN(2645,nquants);
% y.dbt_err_asc = NaN(2645,nquants);
% y.dbt_err_desc = NaN(2645,nquants);
% 
% y.resid_desc_std = NaN(2645,nquants);
% y.resid_asc_std = NaN(2645,nquants);

numQuant = nquants;
y.bt_anom_desc  = nan(numQuant,2645,length(k_desc));
y.rad_anom_desc = nan(numQuant,2645,length(k_desc));
y.bt_anom_asc   = nan(numQuant,2645,length(k_asc));
y.rad_anom_asc  = nan(numQuant,2645,length(k_asc));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run off tsurf using bt1231/bt1228 regression for qi = 16;  

iAllorSeason = +1;

iNumSineCosCycles = 4;
if iAllorSeason < 0
  %% only DJF, MAM, JJA, SON
  iNumSineCosCycles = 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iRightOrWrong = -1; %% orig, since 2018
iRightOrWrong = +1; %% new, since 2024

warning off   
for qi = 1:numQuant
  fprintf(1,'qi = %2i of %2i \n',qi,numQuant);
  disp('  doing 2645 chans : + = 1000, . = 100')
  for ch = 1:2645
    if mod(ch,1000) == 0
      fprintf(1,'+')
    elseif mod(ch,100) == 0
      fprintf(1,'.')
    end
    % Desc
    r = squeeze(rad_quantile_desc(:,ch,qi));
    y.bt_desc(ch,qi) = nanmean(rad2bt(fairs(ch),squeeze(rad_quantile_desc(:,ch,qi))));
    if iRightOrWrong < 0
      [y.b_desc(ch,qi,:)     stats] = Math_tsfit_lin_robust(dtime(k_desc(:,qi))-dtime(k_desc(1,qi)),r(k_desc),iNumSineCosCycles);
      y.berr_desc(ch,qi,:)  = stats.se;
      %% [bt_anom r_anom] = compute_anomaly(k,dtime,B,f,radiance,iConvertToBT);
      [y.bt_anom_desc(qi,ch,:) y.rad_anom_desc(qi,ch,:)] = compute_anomaly0(k_desc(:,qi),dtime,squeeze(b_desc(ch,qi,:)),fairs(ch),r);      
    else
      %% [B,stats,btanomaly,radanomaly] = compute_anomaly_wrapper(k,x0,y0,N,f,iRad_or_OD,iDebug)
      [junkB junkstats junkbtanom junkradanom] = compute_anomaly_wrapper(k_desc(:,qi),dtime,r,iNumSineCosCycles,fairs(ch),+1,-1);
      %b_desc(ch,qi,:)        = junkB;
      %berr_desc(ch,qi,:)     = junkstats.se;
      y.b_desc(ch,qi,:)        = junkB.inputunits;;
      y.berr_desc(ch,qi,:)     = junkstats.inputunits.se;      
      y.bt_anom_desc(qi,ch,:)  = junkbtanom';
      y.rad_anom_desc(qi,ch,:) = junkradanom';
    end

    % Asc
    r = squeeze(rad_quantile_asc(:,ch,qi));
    y.bt_asc(ch,qi) = nanmean(rad2bt(fairs(ch),squeeze(rad_quantile_asc(:,ch,qi))));
    if iRightOrWrong < 0
      [y.b_asc(ch,qi,:) stats] = Math_tsfit_lin_robust(dtime(k_asc(:,qi))-dtime(k_asc(1,qi)),r(k_asc),iNumSineCosCycles);
      y.berr_asc(ch,qi,:)   = stats.se;
      %% [bt_anom r_anom] = compute_anomaly(k,dtime,B,f,radiance,iConvertToBT);
      [y.bt_anom_asc(qi,ch,:) y.rad_anom_asc(qi,ch,:)] = compute_anomaly0(k_asc(:,qi),dtime,squeeze(b_asc(ch,qi,:)),fairs(ch),r);      
    else
      %% [B,stats,btanomaly,radanomaly] = compute_anomaly_wrapper(k,x0,y0,N,f,iRad_or_OD,iDebug)
      [junkB junkstats junkbtanom junkradanom] = compute_anomaly_wrapper(k_asc(:,qi),dtime,r,iNumSineCosCycles,fairs(ch),+1,-1);
      %b_asc(ch,qi,:)         = junkB;
      %berr_asc(ch,qi,:)      = junkstats.se;
      y.b_asc(ch,qi,:)         = junkB.inputunits;;      
      y.berr_asc(ch,qi,:)      = junkstats.inputunits.se;
      y.bt_anom_asc(qi,ch,:)   = junkbtanom';
      y.rad_anom_asc(qi,ch,:)  = junkradanom';
    end
  end
  fprintf(1,'\n');

  % Convert b_trends and uncertainties to BT units
  % <<< *** /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/driver_put_together_QuantileChoose_trends.m uses these *** >>>
  %      b_asc(iLon,iLat,:) = x.dbt_asc(:,iQuantile);
  %      b_desc(iLon,iLat,:) = x.dbt_desc(:,iQuantile);
  % <<< *** /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/driver_put_together_QuantileChoose_trends.m uses these *** >>>

  deriv = drdbt(fairs,rad2bt(fairs,squeeze(y.b_desc(:,qi,1))));
  y.dbt_desc(:,qi)     = y.b_desc(:,qi,2)./deriv;
  y.dbt_err_desc(:,qi) = y.berr_desc(:,qi,2)./deriv;
  
  deriv = drdbt(fairs,rad2bt(fairs,squeeze(y.b_asc(:,qi,1))));
  y.dbt_asc(:,qi)     = y.b_asc(:,qi,2)./deriv;
  y.dbt_err_asc(:,qi) = y.berr_asc(:,qi,2)./deriv;
  % <<< *** /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/driver_put_together_QuantileChoose_trends.m uses these *** >>>

end
warning on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Get rid of variables I don't want to save
y.quants = nquants; % want to save these

clear d r deriv f lagc qi stats ans ch l 

% Create output dir if needed
%fout_dir = sprintf('LatBin%1$02d/LonBin%2$02d',lati,loni);
%fout_dir = fullfile(fdirpre_out,fout_dir)
%if exist(fout_dir) == 0
%   mkdir(fout_dir)
%end

rtime = mattime2rtime(dtime);
[yy mm dd hh] = tai2utcSergio(rtime);

y.rtime_asc  = rtime(k_asc(:,1));
y.rtime_desc = rtime(k_desc(:,1));
[y.yy_desc y.mm_desc y.dd_desc y.hh_desc] = tai2utcSergio(rtime(k_desc(:,1)));
[y.yy_asc  y.mm_asc  y.dd_asc  y.hh_asc]  = tai2utcSergio(rtime(k_asc(:,1)));

