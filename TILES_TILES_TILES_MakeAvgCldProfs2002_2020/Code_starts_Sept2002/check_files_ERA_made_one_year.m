%% see Code_starts_Sept2002/clust_make_profs_data_howard_bins_OneYearStartJan1.m
clear lendir lenXYdir bad
for indYY = 1 : 64
  for indXX = 1 : 72
    JOBB = (indYY-1)*72 + indXX;
    thedir = dir(['../DATA_OneYear/' num2str(JOBB,'%04d') '/pall_gridbox_' num2str(JOBB,'%04d') '_16daytimestep_*.mat']);
    lendir(JOBB) = length(thedir);
    lenXYdir(indXX,indYY) = length(thedir);
  end
end

figure(1); imagesc(lenXYdir'); colorbar; set(gca,'ydir','normal')
figure(2); plot(lendir);

iPrintNotDone = -1;
bad = find(lendir < 23);
whos bad

if iPrintNotDone > 0 & length(bad) > 0
  fid = fopen('../Code_starts_Sept2002/not_finshed23_for_clust_make_profs_data_howard_bins_OneYearStartJan1.txt','w')
  fprintf(fid,'%5i \n',bad);
  fclose(fid);
end
