fid = fopen('launch_many_singleton_jobs.sc','w');

iMax = 400;
iStep = 16;
str = ['sbatch -p high_mem --array=001-' num2str(iStep,'%03d') ' sergio_matlab_jobB.sbatch 10']; fprintf(fid,'%s \n',str);

for ii = 2 : ceil(iMax/iStep)
  str = ['sbatch -p high_mem --array=' num2str((iStep-1)*ii+1,'%03d') '-'  num2str((iStep)*ii,'%03d') ' -d singleton sergio_matlab_jobB.sbatch 10']; fprintf(fid,'%s \n',str);
end

fclose(fid);
