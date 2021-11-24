[badcol,badrow] = find(isnan(co2) | isinf(co2));
if length(badcol) > 0
  fprintf(1,'oops about %4i bad ones in CO2 at lay %3i \n',length(badcol),iLay)
  for ttt = 1 : length(badcol)
    tt = badcol(ttt);
    pp = badrow(ttt);
    fout = [dirOUT '/timestep_' num2str(tt,'%03d') '_16day_avg.rp.rtp'];    
    [hall,ha,pall,pa] = rtpread(fout);
    fprintf(1,'%s nlevs/spres %3i %8.6f \n',fout,pall.nlevs(pp),pall.spres(pp));

    figure(2); 
      subplot(131); plot(pall.ptemp(:,pp),1:101,'o-'); set(gca,'ydir','reverse'); grid
      ax = axis; ax(3) = 1; ax(4) = 101; axis(ax); line([ax(1) ax(2)],[98 98],'color','r','linewidth',2); 
      subplot(132); semilogx(pall.gas_1(:,pp),1:101,'o-'); set(gca,'ydir','reverse'); grid
        ax = axis; ax(3) = 1; ax(4) = 101; axis(ax); line([ax(1) ax(2)],[98 98],'color','r','linewidth',2); 
      subplot(133); semilogx(pall.gas_3(:,pp),1:101,'o-'); set(gca,'ydir','reverse'); grid
        ax = axis; ax(3) = 1; ax(4) = 101; axis(ax); line([ax(1) ax(2)],[98 98],'color','r','linewidth',2); 
    disp('ret'); pause
  end
else
  fprintf(1,'yay nothing bad in CO2 at lay %3i \n',iLay)
end
