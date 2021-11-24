addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/COLORMAP

%iCnt = 0;
for jj = 1 : 64
  if mod(jj,10) == 0
    fprintf(1,'+');
  else
    fprintf(1,'.');
  end
  for ii = 1 : 72
    fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon_v3/Extreme/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/extreme_fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_TimeSteps429.mat'];
      exampleObject = matfile(fname);
      varlist = who(exampleObject);
      varname = varlist{10}; % dbt_asc
       junk = load(fname,varname);
       boostr = ['munk = junk.' varname '(1520);'];
       eval(boostr);
       bt1231_trend_extreme_asc(ii,jj) = munk;
      varname = varlist{11}; % dbt_desc
       junk = load(fname,varname);
       boostr = ['munk = junk.' varname '(1520);'];
       eval(boostr);
       bt1231_trend_extreme_desc(ii,jj) = munk;

    fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/fits_LonBin' num2str(ii,'%02d') '_LatBin' num2str(jj,'%02d') '_V1_TimeSteps429.mat'];
      exampleObject = matfile(fname);
      varlist = who(exampleObject);
      varname = varlist{13}; % dbt_asc
       junk = load(fname,varname);
       boostr = ['munk = junk.' varname '(1520,16);'];
       eval(boostr);
       bt1231_trend_Q16_asc(ii,jj) = munk;
      varname = varlist{16}; % dbt_desc
       junk = load(fname,varname);
       boostr = ['munk = junk.' varname '(1520,16);'];
       eval(boostr);
       bt1231_trend_Q16_desc(ii,jj) = munk;
  end
end
fprintf(1,'\n');
figure(1); simplemap(smoothn(bt1231_trend_extreme_desc',1)); colorbar; colormap(usa2); title('d/dt BT1231 extreme desc'); caxis([-0.15 +0.15])
figure(2); simplemap(smoothn(bt1231_trend_Q16_desc',1));     colorbar; colormap(usa2); title('d/dt BT1231 Q16 desc'); caxis([-0.15 +0.15])
figure(3); simplemap(smoothn(bt1231_trend_extreme_desc'-bt1231_trend_Q16_desc',1)); colorbar; colormap(usa2); title('d/dt BT1231 (extreme-Q16) desc'); caxis([-0.05 +0.05])

figure(1); simplemap(smoothn(bt1231_trend_extreme_asc',1)); colorbar; colormap(usa2); title('d/dt BT1231 extreme asc'); caxis([-0.15 +0.15])
figure(2); simplemap(smoothn(bt1231_trend_Q16_asc',1));     colorbar; colormap(usa2); title('d/dt BT1231 Q16 asc'); caxis([-0.15 +0.15])
figure(3); simplemap(smoothn(bt1231_trend_extreme_asc'-bt1231_trend_Q16_asc',1)); colorbar; colormap(usa2); title('d/dt BT1231 (extreme-Q16) asc'); caxis([-0.05 +0.05])
