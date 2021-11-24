for ii = 1 : 365
  if exist(['SARTA_AIRSL1c_Anomaly365_16_CLD//RESULTS//sarta_' num2str(ii,'%03d') '_fixCFC_M_TS_jac_all_5_6_97_97_97_2645_cld.mat'])
    iaFound(ii) = +1;
  else
    iaFound(ii) = 0;
  end
end
sum(iaFound)
plot(iaFound,'+-');

notdone = find(iaFound == 0);
%notdone
if length(notdone) > 0
  fprintf(1,'still need to put together %3i of 365 \n',length(notdone))
  fid = fopen('notdone_finalRES.sc','w');
  str = ['/bin/rm slurm*; sbatch --exclude=cnode[204,225,267] --array='];
  fprintf(fid,'%s',str);
  iX = nice_output(fid,notdone);   %% now put in continuous strips
  fprintf(1,'length(notdone) = %4i Num Continuous Strips = %4i \n',length(notdone),iX)
  str = ['%30 sergio_matlab_jobB.sbatch 5'];
  fprintf(fid,'%s \n',str);
  fclose(fid);
end
