clear all

set_rtp

[h,ha,p,pa] = rtpread(use_this_rtp);
for iLoop = 1 : length(p.stemp)
  disp('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>')
  fprintf(1,'iLoop = %3i of %3i \n',iLoop,length(p.stemp))
  clust_do_kcarta_driver
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear rads
for iLoop = 1 : length(p.stemp)
  fout = ['JUNK/individual_prof_convolved_kcarta_crisHI_' num2str(iLoop) '.mat'];
  a = load(fout);
  rads(:,iLoop) = a.rKc;
end

f = a.fKc;
i1231 = find(f >= 1231,1);

plot(p.stemp,rad2bt(1231,rads(i1231,:)),'o-',p.stemp,p.stemp)
plot(p.rlat,rad2bt(1231,rads(i1231,:)),'o-',p.rlat,p.stemp)

