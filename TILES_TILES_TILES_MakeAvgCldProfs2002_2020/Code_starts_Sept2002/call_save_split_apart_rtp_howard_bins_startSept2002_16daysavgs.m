%% based on call_save_split_apart_rtp_howard_bins_startSept2002.m
%% based on call_save_split_apart_rtp_howard_bins_startSept2002.m
%% based on call_save_split_apart_rtp_howard_bins_startSept2002.m

addpath /asl/matlib/h4tools
addpath /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_starts_Sept2002/
addpath /home/sergio/MATLABCODE/TIME
addpath /asl/matlib/rtptools
addpath /home/sergio/MATLABCODE

homedir = pwd;
cd ../         %% go up one, since that has the symbolic link for DATA_StartSept2002 --> /asl/s1/sergio/MakeAvgProfs2002_2020_startSept2002
cd /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('making dirs if needed')
for ii = 1 : 64
  dirii = ['DATA_StartSept2002/16dayAvgLatBin' num2str(ii,'%02i') '/'];
  if ~exist(dirii)
    mker = ['!mkdir -p ' dirii];
    eval(mker);
  end
end  

for ii = 1 : 64
  dirii = ['DATA_StartSept2002/LatBin' num2str(ii,'%02i') '/'];
  fprintf(1,'latbin %2i of 64 : %s \n',ii,dirii);
  for jj = 1 : 72
    foutiijj = [dirii '/summary_latbin_' num2str(ii,'%02i') '_lonbin_' num2str(jj,'%02i') '.rtp'];
    [h,ha,p,pa] = rtpread(foutiijj);
    [yy,mm,dd,hh] = tai2utcSergio(p.rtime);

    iDo = -1;
    if iDo > 0
      [yavg] = stats_average(h,p,1:1:13,-1);
      fout = ['DATA_StartSept2002/16dayAvgLatBin' num2str(ii,'%02i') '/monthavg_latbin_' num2str(ii,'%02i') '_lonbin_' num2str(jj,'%02i') '.rtp'];
      for mmm = 1 : 12
        boo = find(mmm == mm);
        woo(boo) = yavg.stemp(mmm);
      end
      figure(1); plot(1:length(p.stemp),p.stemp,1:length(p.stemp),woo);    title(['lat = '  num2str(ii,'%02i') ' lon = ' num2str(jj,'%02i')]);
      figure(2); plot(1:length(p.stemp),p.stemp-woo);                      title(['lat = '  num2str(ii,'%02i') ' lon = ' num2str(jj,'%02i')]);
      figure(3); plot(yavg.stemp);                                         title(['lat = '  num2str(ii,'%02i') ' lon = ' num2str(jj,'%02i')]);
      pause(0.1)
      rtpwrite(fout,h,ha,yavg,pa);
    end

    iDo = -1;
    if iDo > 0
      [yavg] = stats_average_T_WV_grid_uniquemonths(h,p,1:1:13,-1);  %% goes through and finds min/mean/max/std a month at a time
      fout = ['DATA_StartSept2002/16dayAvgLatBin' num2str(ii,'%02i') '/monthavg_T_WV_grid_latbin_' num2str(ii,'%02i') '_lonbin_' num2str(jj,'%02i') '.rtp'];
      for mmm = 1 : 12
        boo = find(mmm == mm);
        woo(boo) = yavg.stemp(mmm);
      end
      figure(1); plot(1:length(p.stemp),p.stemp,1:length(p.stemp),woo);    title(['lat = '  num2str(ii,'%02i') ' lon = ' num2str(jj,'%02i')]);
      figure(2); plot(1:length(p.stemp),p.stemp-woo);                      title(['lat = '  num2str(ii,'%02i') ' lon = ' num2str(jj,'%02i')]);
      figure(3); plot(yavg.stemp);                                         title(['lat = '  num2str(ii,'%02i') ' lon = ' num2str(jj,'%02i')]);
      pause(0.1)
    end

    [yavg] = stats_average_T_WV_grid_allmonths(h,p,1:1:2,-1);     %% finds min/mean/max/std for all 388 timesteps
    fout = ['DATA_StartSept2002/16dayAvgLatBin' num2str(ii,'%02i') '/all12monthavg_T_WV_grid_latbin_' num2str(ii,'%02i') '_lonbin_' num2str(jj,'%02i') '.rtp'];
    rtpwrite(fout,h,ha,yavg,pa);

  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cder = ['cd ' homedir]; eval(cder)  %% come back home to /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_starts_Sept2002/

for ii = 1 : 64
  for jj = 1 : 72
    fout = ['DATA_StartSept2002/16dayAvgLatBin' num2str(ii,'%02i') '/all12monthavg_T_WV_grid_latbin_' num2str(ii,'%02i') '_lonbin_' num2str(jj,'%02i') '.rtp'];
    [h,ha,p,pa] = rtpread(fout);
    st.xmin(ii,jj)   = p.stemp(1);
    st.xminus(ii,jj) = p.stemp(2);
    st.xavg(ii,jj)   = p.stemp(3);
    st.xplus(ii,jj)  = p.stemp(4);
    st.xmax(ii,jj)   = p.stemp(5);
    st.rlon(ii,jj)   = p.rlon(1);
    st.rlat(ii,jj)   = p.rlat(1);
  end
end

figure(1); scatter_coast(st.rlon(:),st.rlat(:),40,st.xmin(:));   colormap jet; title('ST min')
figure(2); scatter_coast(st.rlon(:),st.rlat(:),40,st.xminus(:)); colormap jet; title('ST avg-std')
figure(3); scatter_coast(st.rlon(:),st.rlat(:),40,st.xavg(:));   colormap jet; title('ST avg')
figure(4); scatter_coast(st.rlon(:),st.rlat(:),40,st.xplus(:));  colormap jet; title('ST avg+std')
figure(5); scatter_coast(st.rlon(:),st.rlat(:),40,st.xmax(:));   colormap jet; title('ST max')
for ii = 1 : 5; figure(ii); caxis([200 320]); colorbar; end
