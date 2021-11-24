homedir = pwd;
cd ../         %% go up one, since that has the symbolic link for DATA_StartSept2002 --> /asl/s1/sergio/MakeAvgProfs2002_2020_startSept2002

cd /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('making dirs if needed')
for ii = 1 : 64
  dirii = ['DATA_StartSept2002/LatBin' num2str(ii,'%02i') '/'];
  if ~exist(dirii)
    mker = ['!mkdir -p ' dirii];
    eval(mker);
  end
end  

%%%%%%%%%%%%%%%%%%%%%%%%%
disp(' ')
disp('making the 64 summary rtp files')
%for ii = 1 : 64
%  dirii = ['DATA_StartSept2002/LatBin' num2str(ii,'%02i') '/'];
%  foutii1 = [dirii '/summary_all_lonbins' num2str(ii,'%02i') '.rtp'];
%  foutii2 = [dirii '/latbin_' num2str(ii,'%02i') '_all_lonbins.rtp'];
%  mver = ['!mv ' foutii1 ' ' foutii2];
%  eval(mver);
%end

for ii = 1 : 64
  dirii = ['DATA_StartSept2002/LatBin' num2str(ii,'%02i') '/'];
  %foutii = [dirii '/summary_all_lonbins' num2str(ii,'%02i') '.rtp'];
  foutii = [dirii '/latbin_' num2str(ii,'%02i') '_all_lonbins.rtp'];
  if ~exist(foutii)
    str = ['psavejunk = p' num2str(ii,'%02i') ';'];
    eval(str);
    fprintf(1,'%2i %s \n',ii,foutii);
    rtpwrite(foutii,h,[],psavejunk,[]);
  end
end  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(' ')
disp('making the 64x72 summary rtp files')

for ii = 1 : 64
  dirii = ['DATA_StartSept2002/LatBin' num2str(ii,'%02i') '/'];
  for jj = 1 : 72
    foutiijj = [dirii '/summary_latbin_' num2str(ii,'%02i') '_lonbin_' num2str(jj,'%02i') '.rtp'];
    str = ['psavejunk = p' num2str(ii,'%02i') ';'];
    eval(str);
    if ~exist(foutiijj)
      ind = find(psavejunk.rlon >= rlon(jj) & psavejunk.rlon < rlon(jj+1));
      [hh,ppsub] = subset_rtp_allcloudfields(h,psavejunk,[],[],ind);
      fprintf(1,'%2i %2i %s has %4i elements \n',ii,jj,foutiijj,length(ppsub.stemp));
      rtpwrite(foutiijj,h,[],ppsub,[]);
    end
  end
end

%% larrabee wants the gridded stemp time series
disp(' ')
disp('making the 64x72 summary file of ERA stemp')

[~,~,iMaxTime] = size(era_stemp);
ftimeseries = ['DATA_StartSept2002/era_stemp_timeseries.mat'];
if ~exist(ftimeseries)
  %era_stemp = struct;
  for ii = 1 : 64
    dirii = ['DATA_StartSept2002/LatBin' num2str(ii,'%02i') '/'];
    for jj = 1 : 72
      %foutiijj = [dirii '/summary_latbin_' num2str(ii,'%02i') '_lonbin_' num2str(jj,'%02i') '.rtp'];
      str = ['psavejunk = p' num2str(ii,'%02i') ';'];
      eval(str);
      ind = find(psavejunk.rlon >= rlon(jj) & psavejunk.rlon < rlon(jj+1));
      [hh,ppsub] = subset_rtp_allcloudfields(h,psavejunk,[],[],ind);
      fprintf(1,'%2i %2i has %4i elements \n',ii,jj,length(ppsub.stemp));
      if ii == 1 & jj == 1
        era_stemp_rtime = ppsub.rtime;
      end
      %str = ['era_stemp.lat_' num2str(ii,'%02i') '_lon_' num2str(jj,'%02i') ' = ppsub.stemp;'];
      %eval(str)
      era_stemp(ii,jj,:) = ppsub.stemp;
    end
  end

  %saver = ['save ' ftimeseries ' era_stemp era_stemp_rtime'];
  %eval(saver)

  %plot(1:iMaxTime,era_stemp.lat_01_lon_36,1:iMaxTime,era_stemp.lat_16_lon_36,1:iMaxTime,era_stemp.lat_32_lon_36,...
  %     1:iMaxTime,era_stemp.lat_48_lon_36,1:iMaxTime,era_stemp.lat_64_lon_36)
  plot(1:iMaxTime,squeeze(era_stemp([1 16 32 48 64],36,:)))
    hl = legend(num2str([1 16 32 48 64]'));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(' ')
disp('%% now make the average file so we can make jacobians for trends!')

%% this makes a rtp structure with 4608 profiles .... the average profile for each tile

%% note the fields hNyearaverage and pNyearaverage were probably called eg h16yearaverage and p16yearaverage
foutNyearaverage = ['DATA_StartSept2002/summary_16years_all_lat_all_lon_2002_2018.rtp'];
foutNyearaverage = ['DATA_StartSept2002/summary_17years_all_lat_all_lon_2002_2019.rtp'];
if ~exist(foutNyearaverage)
  pNyearaverage = [];
  iCnt = 0;
  for ii = 1 : 64
    fprintf(1,'%2i ',ii);
    dirii = ['DATA_StartSept2002/LatBin' num2str(ii,'%02i') '/'];
    str = ['psavejunk = p' num2str(ii,'%02i') ';'];
    eval(str);
    for jj = 1 : 72
      fprintf(1,'.');
      iCnt = iCnt + 1;
      ind = find(psavejunk.rlon >= rlon(jj) & psavejunk.rlon < rlon(jj+1));
      [hh,ppsub] = subset_rtp_allcloudfields(h,psavejunk,[],[],ind);
      %fprintf(1,'%2i %s has %4i elements \n',ii,foutiijj,length(ppsub.stemp));
      [yavg] = stats_average(hh,ppsub,[min(ppsub.rlat)-0.1 max(ppsub.rlat)+0.1]);
      if iCnt == 1
        hNyearaverage = hh;      
        pNyearaverage = yavg;
      else
        [hNyearaverage,pNyearaverage] = cat_rtp(hNyearaverage,pNyearaverage,hh,yavg);
      end    %% iCnt
    end     %% jj loop
    fprintf(1,'\n');
  end
  rtpwrite(foutNyearaverage,hNyearaverage,[],pNyearaverage,[]);

  addpath /home/sergio/MATLABCODE
  pNyearaverage.palts = p2h(pNyearaverage.plevs);
  pNyearaverage.zobs = ones(size(pNyearaverage.stemp)) * 705000;
  junk2_3 = pNyearaverage.palts(2,:)-pNyearaverage.palts(3,:);
  junk3_4 = pNyearaverage.palts(3,:)-pNyearaverage.palts(4,:);
  junk4_5 = pNyearaverage.palts(4,:)-pNyearaverage.palts(5,:);   
  junk1_2 = junk2_3 + 0.5 * (pNyearaverage.palts(3,:)-pNyearaverage.palts(4,:));
  for kkkk = 1 : length(junk4_5)
    junk1_2(kkkk) = interp1(1:3,[junk4_5(kkkk) junk3_4(kkkk) junk2_3(kkkk)],4,[],'extrap');
  end
  pNyearaverage.palts(1,:) = pNyearaverage.palts(2,:) + junk1_2;
  rtpwrite(foutNyearaverage,hNyearaverage,[],pNyearaverage,[]);
  
  figure(1); scatter_coast(pNyearaverage.rlon,pNyearaverage.rlat,50,pNyearaverage.stemp); title('Avg Stemp');
  figure(2); scatter_coast(pNyearaverage.rlon,pNyearaverage.rlat,50,rad2bt(1231,pNyearaverage.robs1(1520,:))); title('Avg BT1231 obs')
  figure(3); scatter_coast(pNyearaverage.rlon,pNyearaverage.rlat,50,rad2bt(1231,pNyearaverage.rcalc(1520,:))); title('Avg BT1231 cld cal')
  figure(4); scatter_coast(pNyearaverage.rlon,pNyearaverage.rlat,50,rad2bt(1231,pNyearaverage.sarta_rclearcalc(1520,:))); title('Avg BT1231 clr cal')
  for ii=1:4; figure(ii); colormap jet; caxis([220 310]);  end

  figure(1); scatter_coast(pNyearaverage.rlon,pNyearaverage.rlat,50,pNyearaverage.iceOD);   title('Ice OD');
  figure(2); scatter_coast(pNyearaverage.rlon,pNyearaverage.rlat,50,pNyearaverage.icetopT); title('Ice TopT');
  figure(3); scatter_coast(pNyearaverage.rlon,pNyearaverage.rlat,50,pNyearaverage.waterOD);   title('Water OD');
  figure(4); scatter_coast(pNyearaverage.rlon,pNyearaverage.rlat,50,pNyearaverage.watertopT); title('Water TopT'); caxis([220 300])

  figure(1); scatter_coast(pNyearaverage.rlon,pNyearaverage.rlat,50,pNyearaverage.icefrac);   title('Ice frac'); caxis([0 1])
  figure(2); scatter_coast(pNyearaverage.rlon,pNyearaverage.rlat,50,pNyearaverage.icesze); title('Ice sze');
  figure(3); scatter_coast(pNyearaverage.rlon,pNyearaverage.rlat,50,pNyearaverage.waterfrac);   title('Water frac'); caxis([0 1])
  figure(4); scatter_coast(pNyearaverage.rlon,pNyearaverage.rlat,50,pNyearaverage.watersze); title('Water sze'); caxis([18 22])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cder = ['cd ' homedir]; eval(cder)  %% come back home to /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_starts_Sept2002/
