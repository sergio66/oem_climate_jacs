for ii = 1 : 6; figure(ii); colormap(jet); end

monitor_memory_whos
%% memory in use = 16027.944054 MB

savercalc.rlat = pjunk.rlat;
savercalc.rlon = pjunk.rlon;
comment = 'see /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/MakeAvgProfs2002_2020/driver_gather16day_calcs_howard.m';

iDo = -1;
if iDo > 0
  disp('saving BIIIIIIIIIIIIIIIIIIIIIIIIIIIG FAT SLOOOOOOOW FILE');
  save -v7.3 DATA/ObsNCalcs/savercalc2002_2019.mat savercalc comment
end

%% pretty slow but useful check
iDo = -1;
if iDo > 0  
  ind0 = (1:64:4608);
  for ii = 1 : 64
    ind = ind0 + (ii-1);
    figure(4); plot(pjunk.rlon(ind),pjunk.stemp(ind),'.');
    figure(5); plot(pjunk.rlon(ind),pjunk.rlat(ind),'.'); 
    figure(6); scatter_coast(pjunk.rlon,pjunk.rlat,50,pjunk.stemp); hold; plot(pjunk.rlon(ind),pjunk.rlat(ind),'k','linewidth',2); hold off 
    pause(0.1);
  end
end

obs1231  = rad2bt(1231,squeeze(savercalc.robs1(:,1520,:)));
rcld1231 = rad2bt(1231,squeeze(savercalc.rcld(:,1520,:)));
rclr1231 = rad2bt(1231,squeeze(savercalc.rclr(:,1520,:)));
figure(1); scatter_coast(pjunk.rlon,pjunk.rlat,50,mean(savercalc.stemp,1)); title('stemp');
figure(2); scatter_coast(pjunk.rlon,pjunk.rlat,50,mean(obs1231,1));         title('obs1231');
figure(3); scatter_coast(pjunk.rlon,pjunk.rlat,50,mean(rcld1231,1));        title('cld1231');
figure(4); scatter_coast(pjunk.rlon,pjunk.rlat,50,mean(rclr1231,1));        title('clr1231');
meansavercalc.robs1  = squeeze(nanmean(savercalc.robs1,1));
meansavercalc.rcld   = squeeze(nanmean(savercalc.rcld,1));
meansavercalc.rclr   = squeeze(nanmean(savercalc.rclr,1));
meansavercalc.stemp  = nanmean(savercalc.stemp,1);
meansavercalc.rtime  = nanmean(savercalc.rtime,1);
meansavercalc.mmw    = nanmean(savercalc.mmw,1);
meansavercalc.yymmdd = savercalc.yymmdd;
meansavercalc.i16day = savercalc.i16day;
meansavercalc.rlon   = savercalc.rlon;
meansavercalc.rlat   = savercalc.rlat;
save('DATA/ObsNCalcs/mean_savercalc2002_2019.mat','-struct','meansavercalc')

iPlot = -1;
disp('saving to individual files')
for ii = 1 : 64
  for jj = 1 : 72
    clear xsave
    ind = ii + (jj-1)*64;
    fiijj = ['DATA/ObsNCalcs/breakout_lat_' num2str(ii) '_lon_' num2str(jj) '.mat'];
    xsave.robs1 = savercalc.robs1(:,:,ind);
    xsave.rcld  = savercalc.rcld(:,:,ind);
    xsave.rclr  = savercalc.rclr(:,:,ind);
    xsave.stemp = savercalc.stemp(:,ind);
    xsave.rtime = savercalc.rtime(:,ind);
    xsave.mmw   = savercalc.mmw(:,ind);
    xsave.yymmdd = savercalc.yymmdd;
    xsave.i16day = savercalc.i16day;
    xsave.comment = comment;
    fprintf(1,'%2i %2i %s \n',ii,jj,fiijj);
    %  saver = ['save ' fiijj ' xsave comment'];    eval(saver);
    save(fiijj,'-struct','xsave')
    if iPlot > 0
      figure(5); plot(1:386,xsave.stemp);
      figure(6); plot(pjunk.rlon,pjunk.rlat,'.',pjunk.rlon(ind),pjunk.rlat(ind),'ro'); pause(0.1);
    end
  end
end

