echo "Counting junk files : slurm, rad, jac, ind_mat, nml, status"
ls -lt slurm*.out | wc -l
ls -lt Anomaly365_16/*/rad*.dat* | wc -l
ls -lt Anomaly365_16/*/jac*.dat* | wc -l
ls -lt Anomaly365_16/*/ind*.mat* | wc -l
ls -lt Anomaly365_16/*/*nml* | wc -l
ls -lt Anomaly365_16/*/*status* | wc -l

echo "Removing them ..."
/bin/rm slurm*.out
/bin/rm Anomaly365_16/*/rad*.dat*
/bin/rm Anomaly365_16/*/jac*.dat*
/bin/rm Anomaly365_16/*/ind*.mat*
/bin/rm Anomaly365_16/*/*nml*
/bin/rm Anomaly365_16/*/*status*
