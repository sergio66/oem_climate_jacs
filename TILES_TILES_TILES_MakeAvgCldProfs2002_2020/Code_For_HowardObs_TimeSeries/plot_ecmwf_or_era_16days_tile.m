iTimeStep = 230;

addpath /home/sergio/KCARTA/MATLAB
addpath /home/sergio/MATLABCODE


disp('reading in 64 latbins : + at 10, . = 1')
dbt = 200 : 1 : 320;

quants = [0.00 0.03 0.50 0.80 0.90 0.95 0.97 1.00];

iaFound = zeros(72,64);
for JOB = 1 : 64
  if mod(JOB,10) == 0
    fprintf(1,'+');
  else
    fprintf(1,'.');
  end
  for ii = 1 : 72
    fdirsave = ['/asl/s1/sergio/JUNK2/16dayTimeStep/' num2str(iTimeStep,'%03d') '/'];
    fsave = [fdirsave '/test_clust_make_ecmwf_or_era_16days_tile_timestep_' num2str(iTimeStep,'%03d') '_latbin_' num2str(JOB,'%02d') '_lonbin_' num2str(ii,'%02d') '.mat'];
    if exist(fsave)
      a = load(fsave);
      tobs = rad2bt(1231,a.p2.robs1);
      tcal = rad2bt(1231,a.p2.rcalc);
      stemp = a.p2.stemp;

      iaFound(ii,JOB) = +1;

      max_bt1231obs(ii,JOB) = max(tobs);
      max_bt1231cal(ii,JOB) = max(tcal);
      max_stemp(ii,JOB)     = max(stemp);
      min_bt1231obs(ii,JOB) = min(tobs);
      min_bt1231cal(ii,JOB) = min(tcal);
      min_stemp(ii,JOB)     = min(stemp);

      quants_bt1231obs(ii,JOB,:) = quantile(tobs,quants);
      quants_bt1231cal(ii,JOB,:) = quantile(tcal,quants);
      quants_stemp(ii,JOB,:)     = quantile(stemp,quants);

      hist_stemp(ii,JOB,:) = histcounts(stemp,dbt)/length(a.p2.stemp);
      hist_bt1231obs(ii,JOB,:) = histcounts(tobs,dbt)/length(a.p2.stemp);
      hist_bt1231cal(ii,JOB,:) = histcounts(tcal,dbt)/length(a.p2.stemp);
    else
      iaFound(ii,JOB) = 0;

      max_bt1231obs(ii,JOB) = NaN;
      max_bt1231cal(ii,JOB) = NaN;
      max_stemp(ii,JOB)     = NaN;
      min_bt1231obs(ii,JOB) = NaN;
      min_bt1231cal(ii,JOB) = NaN;
      min_stemp(ii,JOB)     = NaN;

      quants_bt1231obs(ii,JOB,:) = NaN;
      quants_bt1231cal(ii,JOB,:) = NaN;
      quants_stemp(ii,JOB,:) = NaN;

      hist_stemp(ii,JOB,:) = nan;
      hist_bt1231obs(ii,JOB,:) = nan;
      hist_bt1231cal(ii,JOB,:) = nan;
    end
  end
end
fprintf(1,'\n')
fprintf(1,'found %4i of 4608 \n',sum(iaFound(:)));

load latB64.mat
latt = meanvaluebin(latB2);

dbtt = dbt;
dbtt = meanvaluebin(dbt);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
do_the_plots_ecmwf_or_era_16days_tile
