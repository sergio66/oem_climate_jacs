for jj = 1 : 64
  for ii = 1 : 72
    fx = ['RTP_PROFSV2/Cld/timestep_lonbin_' num2str(ii,'%02d') '_latbin_' num2str(jj,'%02d') '_JOB*.rtp'];
    thedir = dir(fx);
    if length(thedir) == 1
      iaaFound(ii,jj) = 1;
    else
      iaaFound(ii,jj) = 0;
    end
  end
end

figure(1); pcolor(iaaFound); colorbar;
figure(2); plot(sum(iaaFound));
