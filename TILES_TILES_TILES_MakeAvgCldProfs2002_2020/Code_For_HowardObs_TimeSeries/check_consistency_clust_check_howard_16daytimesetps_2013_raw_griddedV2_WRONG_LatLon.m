%% check clust_check_howard_16daytimesetps_2013_raw_griddedV2_WRONG_LatLon.m

hugedir = dir('/asl/isilon/airs/tile_test7/');
%%for JOBB = 1 : length(hugedir)
% JOB =  103 date_stamp = 2007_s101
% JOB =  104 date_stamp = 2007_s101.bak

for JOBB = 1 : 102
  
  %JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
  %JOB = 100
  
  %% 2013_s237 to 2013_s259
  %% 2015_s283
  date_stamp = ['2015_s283'];
  
  JOB = JOBB + 2;  %% because first two are '.' and '..'
  
  date_stamp = hugedir(JOB).name;
  fprintf(1,'JOB = %4i date_stamp = %s \n',JOB,date_stamp);
  thedir0 = dir(['/asl/isilon/airs/tile_test7/' date_stamp '/']);

  for iii = 3 : length(thedir0)
    dirdirname = ['/asl/isilon/airs/tile_test7/' date_stamp '/' thedir0(iii).name];
    dirx = dir([dirdirname '/*.nc']);
    for jjj = 1 : length(dirx)
      fname = [dirdirname '/' dirx(jjj).name];
      checkname.dirname0(JOBB,iii-2,jjj,:)   = date_stamp;
      checkname.dirnameSub(JOBB,iii-2,jjj,:) = thedir0(iii).name;
      checkname.fname(JOBB,iii-2,jjj,:) = dirx(jjj).name;
    end
  end
end

clear zcomp
for JOB = 2:99
  for ii = 1 : 64
    for jj = 1 : 72
      wah0 = squeeze(checkname.fname(1,ii,jj,1:32))';
      wahx = squeeze(checkname.fname(JOB,ii,jj,1:32))';
      zcomp(JOB,ii,jj) = strcmp(wah0(16:end-3),wahx(16:end-3));
    end
  end
end
sum(zcomp(:))-(64*72*98)    %% if 0, and it is, looks GREAT!!!!

