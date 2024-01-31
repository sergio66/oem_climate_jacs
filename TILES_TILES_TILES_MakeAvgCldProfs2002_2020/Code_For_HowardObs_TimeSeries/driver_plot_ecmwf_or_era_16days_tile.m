iTimeStep = 230+0;  %% 10 years Aug 20, 2012 - Sep  11, 2012 (JJA 2012)
iTimeStep = 230-6;  %% 10 years May 20, 2012 - June 11, 2012 (MAM 2012)
iTimeStep = 230-12; %% 10 years Feb 20, 2012 - Mar 11,  2012 (DJF 2012)
iTimeStep = 230+6;  %% 10 years Nov 20, 2012 - Dec 11,  2012 (SON 2012)

addpath /home/sergio/KCARTA/MATLAB
addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/COLORMAP

iAllChan = -1;  %% only one chan, 1231  DEFAULT
iAllChan = +1;  %% 2645 chans
iAllChan = input('Enter (-1/default) for only one chan, 64 latins, 72 lonbins (+1) for 2645 chans, 1 latbin, 72 lonbins : ');
if length(iAllChan) == 0
  iAllChan = -1;
end

if iAllChan < 0
  fnameOUT = ['plot_ecmwf_or_era_16days_tile_timestep' num2str(iTimeStep,'%03d') '.mat'];
  iaFound = zeros(72,64);

  disp('reading in 64 latbins : + at 10, . = 1')
  dbt = 200 : 1 : 320;
  dbt = 180 : 1 : 340;  %% some stemp and BT1231 in Antratice are 195 K

  clr90_lf       = [];
  clr90_rlat     = [];
  clr90_rlon     = [];
  clr90_rtime    = [];
  clr90_r1231    = [];
  clr90_cld1231  = [];
  clr90_clr1231  = [];
  
  clr95_lf       = [];
  clr95_rlat     = [];
  clr95_rlon     = [];
  clr95_rtime    = [];
  clr95_r1231    = [];
  clr95_cld1231  = [];
  clr95_clr1231  = [];
  
  clr97_lf       = [];
  clr97_rlat     = [];
  clr97_rlon     = [];
  clr97_rtime    = [];
  clr97_r1231    = [];
  clr97_cld1231  = [];
  clr97_clr1231  = [];
  
  quants = [0.00 0.03 0.50 0.80 0.90 0.95 0.97 1.00];
  i90 = find(quants == 0.90);
  i95 = find(quants == 0.95);
  i97 = find(quants == 0.97);

  iRead = +1;
  if exist(fnameOUT)
    loader = ['load ' fnameOUT];
    eval(loader);
    iRead = -1;     
  end

  while iRead > 0 & sum(iaFound(:)) < 4608
    for JOB = 1 : 64
      if mod(JOB,10) == 0
        fprintf(1,'+');
      else
        fprintf(1,'.');
      end
      for ii = 1 : 72
        fdirsave = ['/asl/s1/sergio/JUNK2/16dayTimeStep/' num2str(iTimeStep,'%03d') '/'];
        fsave = [fdirsave '/test_clust_make_ecmwf_or_era_16days_tile_timestep_' num2str(iTimeStep,'%03d') '_latbin_' num2str(JOB,'%02d') '_lonbin_' num2str(ii,'%02d') '.mat'];
        i10sec = -1;
        if exist(fsave)
          moo = dir(fsave);
          %% datenum : A serial date number represents the whole and fractional number of days from a fixed, preset date (January 0, 0000) in the proleptic ISO calendar.
          moo = dir(fsave);
          rightnow = datenum(datetime('now'));
          if (rightnow-moo.datenum)*24*60*60 > 10
            i10sec = 1;
          end
        end
        if iaFound(ii,JOB) == 0 & exist(fsave) & i10sec > 0
          a = load(fsave);
          tobs = rad2bt(1231,a.p2.robs1);
          tcld = rad2bt(1231,a.p2.rcalc);
          tclr = rad2bt(1231,a.p2.sarta_rclearcalc);
          stemp = a.p2.stemp;
    
          iaFound(ii,JOB) = +1;
    
          max_bt1231obs(ii,JOB)  = max(tobs);
          max_bt1231cld(ii,JOB)  = max(tcld);
          max_bt1231clr(ii,JOB)  = max(tclr);
          max_stemp(ii,JOB)      = max(stemp);

          min_bt1231obs(ii,JOB)  = min(tobs);
          min_bt1231cld(ii,JOB)  = min(tcld);
          min_bt1231clr(ii,JOB)  = min(tclr);
          min_stemp(ii,JOB)      = min(stemp);

          mean_bt1231obs(ii,JOB) = mean(tobs);
          mean_bt1231cld(ii,JOB) = mean(tcld);
          mean_bt1231clr(ii,JOB) = mean(tclr);
          mean_stemp(ii,JOB)     = mean(stemp);

          medn_bt1231obs(ii,JOB) = median(tobs);
          medn_bt1231cld(ii,JOB) = median(tcld);
          medn_bt1231clr(ii,JOB) = median(tclr);
          medn_stemp(ii,JOB)     = median(stemp);
    
          quants_bt1231obs(ii,JOB,:) = quantile(tobs,quants);
          quants_bt1231cld(ii,JOB,:) = quantile(tcld,quants);
          quants_bt1231clr(ii,JOB,:) = quantile(tclr,quants);
          quants_stemp(ii,JOB,:)     = quantile(stemp,quants);
    
          hist_stemp(ii,JOB,:) = histcounts(stemp,dbt)/length(a.p2.stemp);
          hist_bt1231obs(ii,JOB,:) = histcounts(tobs,dbt)/length(a.p2.stemp);
          hist_bt1231cld(ii,JOB,:) = histcounts(tcld,dbt)/length(a.p2.stemp);
          hist_bt1231clr(ii,JOB,:) = histcounts(tclr,dbt)/length(a.p2.stemp);
    
          landfrac(ii,JOB) = nanmean(a.p2.landfrac);
          count(ii,JOB) = length(a.p2.stemp);
  
          ind = find(tobs >= quantile(tobs,quants(i90)));
          clr90_lf      = [clr90_rlat a.p2.landfrac(ind)];
          clr90_rlat    = [clr90_rlat a.p2.rlat(ind)];
          clr90_rlon    = [clr90_rlon a.p2.rlon(ind)];
          clr90_rtime   = [clr90_rtime a.p2.rtime(ind)];
          clr90_r1231   = [clr90_r1231 tobs(ind)];
          clr90_cld1231 = [clr90_cld1231 tcld(ind)];          
          clr90_clr1231 = [clr90_clr1231 tclr(ind)];

          ind = find(tobs >= quantile(tobs,quants(i95)));
          clr95_lf      = [clr95_rlat a.p2.landfrac(ind)];
          clr95_rlat    = [clr95_rlat a.p2.rlat(ind)];
          clr95_rlon    = [clr95_rlon a.p2.rlon(ind)];
          clr95_rtime   = [clr95_rtime a.p2.rtime(ind)];
          clr95_r1231   = [clr95_r1231 tobs(ind)];
          clr95_cld1231 = [clr95_cld1231 tcld(ind)];          
          clr95_clr1231 = [clr95_clr1231 tclr(ind)];

          ind = find(tobs >= quantile(tobs,quants(i97)));
          clr97_lf      = [clr97_rlat a.p2.landfrac(ind)];
          clr97_rlat    = [clr97_rlat a.p2.rlat(ind)];
          clr97_rlon    = [clr97_rlon a.p2.rlon(ind)];
          clr97_rtime   = [clr97_rtime a.p2.rtime(ind)];
          clr97_r1231   = [clr97_r1231 tobs(ind)];
          clr97_cld1231 = [clr97_cld1231 tcld(ind)];          
          clr97_clr1231 = [clr97_clr1231 tclr(ind)];

        elseif iaFound(ii,JOB) == 0 & (~exist(fsave) | i10sec < 0)
          iaFound(ii,JOB) = 0;
    
          max_bt1231obs(ii,JOB)  = NaN;
          max_bt1231cld(ii,JOB)  = NaN;
          max_bt1231clr(ii,JOB)  = NaN;
          max_stemp(ii,JOB)      = NaN;

          min_bt1231obs(ii,JOB)  = NaN;
          min_bt1231cld(ii,JOB)  = NaN;
          min_bt1231clr(ii,JOB)  = NaN;
          min_stemp(ii,JOB)      = NaN;

          mean_bt1231obs(ii,JOB) = NaN;
          mean_bt1231cld(ii,JOB) = NaN;
          mean_bt1231clr(ii,JOB) = NaN;
          mean_stemp(ii,JOB)     = NaN;

          medn_bt1231obs(ii,JOB) = NaN;
          medn_bt1231cld(ii,JOB) = NaN;
          medn_bt1231clr(ii,JOB) = NaN;
          medn_stemp(ii,JOB)     = NaN;
    
          quants_bt1231obs(ii,JOB,:) = NaN;
          quants_bt1231cld(ii,JOB,:) = NaN;
          quants_bt1231clr(ii,JOB,:) = NaN;
          quants_stemp(ii,JOB,:) = NaN;
    
          hist_stemp(ii,JOB,:) = nan;
          hist_bt1231obs(ii,JOB,:) = nan;
          hist_bt1231cld(ii,JOB,:) = nan;
          hist_bt1231clr(ii,JOB,:) = nan;
    
          landfrac(ii,JOB) = nan;
          count(ii,JOB) = 0;

        end  % if iaFound(ii,JOB) & exist(fsave)
      end    % for ii = 1 : 72
    end      % for JOB = 1 : 64
    fprintf(1,' sum(iaFound(:)) = %4i of 4608 \n',sum(iaFound(:)))
    if sum(iaFound(:)) < 4608
      do_the_plots_ecmwf_or_era_16days_tile_generic
      iRead = input('try reading in more?? (-1/+1 default) : ');
      if length(iRead) == 0
        iRead = +1;
      end
    end
  end

  fprintf(1,'\n')
  fprintf(1,'found %4i of 4608 \n',sum(iaFound(:)));
  
  load latB64.mat
  latt = meanvaluebin(latB2);
  
  dbtt = dbt;
  
  dbtt = meanvaluebin(dbt);
  
  if sum(iaFound(:)) == 4608
    clear stemp
    saver = ['save ' fnameOUT ' *bt1231* *stemp* count dbtt iaFound latt dbtt dbt quants clr*_*'];
    iSave = input('found all 4608 files .. save??? (-1/+1 [default]) : ');
    if length(iSave) == 0
      iSave = +1;
    end
    if iSave > 0
      eval(saver)     
    end
  end

  do_the_plots_ecmwf_or_era_16days_tile_generic
  disp('ret to continue to main plots'); pause
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %do_the_plots_ecmwf_or_era_16days_tile      %% good try
  do_the_plots_ecmwf_or_era_16days_tile_v2    %% awesome
  %do_the_plots_ecmwf_or_era_16days_tile_wgt  %% ugh not good

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

else

  disp('grabbing lots of memory first ...')
  robs1 = nan(72,2645,10000);
  rcalc = nan(72,2645,10000);
  tobs  = robs1;
  stemp = nan(72,10000);
  rlat = nan(72,10000);
  rlon = nan(72,10000);
  rtime = nan(72,10000);
  landfrac = nan(72,10000);

  disp('reading in latbin 32, 72 lonbins : + at 10, . = 1')
  dbt = 200 : 1 : 320;
  dbt = 180 : 1 : 340;  %% some stemp and BT1231 in Antratice are 195 K
  
  quants = [0.00 0.03 0.50 0.80 0.90 0.95 0.97 1.00];

  JOB = 32;  
  iaFound = zeros(72,1);
  for ii = 1 : 72
    if mod(ii,10) == 0
      fprintf(1,'+');
    else
      fprintf(1,'.');
    end

    fdirsave = ['/asl/s1/sergio/JUNK2/16dayTimeStep/' num2str(iTimeStep,'%03d') '/'];
    fsave = [fdirsave '/test_clust_make_ecmwf_or_era_16days_tile_timestep_allchans_' num2str(iTimeStep,'%03d') '_latbin_' num2str(JOB,'%02d') '_lonbin_' num2str(ii,'%02d') '.mat'];
    if exist(fsave)
      a = load(fsave);
      iaFound(ii)   = 1;
      iaNct(ii)     = length(a.p2.stemp);
      robs1(ii,:,1:iaNct(ii)) = a.p2.robs1;
      tobs(ii,:,1:iaNct(ii)) = rad2bt(a.hout.vchan,a.p2.robs1);
      rcalc(ii,:,1:iaNct(ii)) = a.p2.rcalc;
      stemp(ii,1:iaNct(ii))   = a.p2.stemp;      
      rlat(ii,1:iaNct(ii))    = a.p2.rlat;      
      rlon(ii,1:iaNct(ii))    = a.p2.rlon;      
      rtime(ii,1:iaNct(ii))   = a.p2.rtime;      
      landfrac(ii,1:iaNct(ii))   = a.p2.landfrac;      
    else
      iaFound(ii)   = 0;
      iaNct(ii)     = 0;
      robs1(ii,:,1:iaNct(ii)) = nan;
      tobs(ii,:,1:iaNct(ii)) = nan;
      rcalc(ii,:,1:iaNct(ii)) = nan;
      stemp(ii,1:iaNct(ii))   = nan;
      rlat(ii,1:iaNct(ii))    = nan;
      rlon(ii,1:iaNct(ii))    = nan;
      rtime(ii,1:iaNct(ii))   = nan;
      landfrac(ii,1:iaNct(ii))   = nan;
    end
  end
 
  fprintf(1,'\n')

  do_the_plots_ecmwf_or_era_16days_tile_onelatbin
  
end
