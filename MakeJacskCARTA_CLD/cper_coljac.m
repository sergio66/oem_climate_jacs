function cper_coljac(iTimeStep,iiBin)

xsavecopydir = ['/asl/s1/sergio/USEFUL_LARGE_MATFILES/CLRSKY_ANOMALY_COLJACS/' num2str(iTimeStep,'%03d') '/'];
if ~exist(xsavecopydir)
  mker = ['!mkdir ' xsavecopydir];
  eval(mker);
end

find_file_names

if iTimeStep < 0
  cper = ['!/bin/cp JUNK/radc.dat'     num2str(iiBin) ' ' xsavecopydir '/. ']; eval(cper);
  cper = ['!/bin/cp JUNK/jacc.dat_COL' num2str(iiBin) ' ' xsavecopydir '/. ']; eval(cper);
else
  %% 365 timesteps x 40 latbins, harder
  cper = ['!/bin/cp ' outdirtemp '/radc.dat' num2str(iiBin) '     ' xsavecopydir '/. ']; eval(cper); cper
  cper = ['!/bin/cp ' outdirtemp '/jacc.dat' num2str(iiBin) '_COL ' xsavecopydir '/. ']; eval(cper); cper
end
