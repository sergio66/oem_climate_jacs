addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/COLORMAP
addpath /home/sergio/MATLABCODE/CRODGERS_FAST_CLOUD
addpath /asl/matlib/aslutil
addpath /asl/matlib/rtptools
addpath /asl/matlib/h4tools
addpath /home/sergio/MATLABCODE/TIME

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));  %% JOB = 1 : 64 = latbin
JOB0 = JOB;

homedir = pwd; %% cd /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/MakeAvgCldProfs2002_2020/LookAtTimeSeries/

set(0,'DefaultLegendAutoUpdate','off')

cd /umbc/xfs2/strow/asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_CORRECT_LatLon/

disp('from eg look_latbin32Lonbin54.m')
disp('  ClearBin    : indX lon = 54  87.5009     indY lat = 24 -23.3750')
disp('  CloudBin    : indX lon = 67 152.5007     indY lat = 35   6.8743')
disp('  SeasonalBin : indX lon = 27 -47.4736     indY lat = 47  39.8756')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% iChooseLatLonBin = input('Enter Lonbin/Latbin to look at (Lonbin 54 Latbin 32 -- is a good one, over Indonesia)  0 to stop: ');

JOB0

tempfile1 = mktempS('xxxjunk1');
tempfile2 = mktempS('xxxjunk2');
tempfile3 = mktempS('xxxjunk3');
tempfile4 = mktempS('xxxjunk4');
tempx.tempfile1 = tempfile1;
tempx.tempfile2 = tempfile2;
tempx.tempfile3 = tempfile3;
tempx.tempfile4 = tempfile4;
klayers = '/asl/packages/klayersV205/BinV201/klayers_airs';
sarta = '/home/chepplew/gitLib/sarta/bin/airs_l1c_2834_cloudy_may19_prod_v3';
tempx.klayers = klayers;
tempx.sarta   = sarta;

for iXX = 72 : -1 : 1
%for iXX = 1 : 72
  %% iaChooseLatLonBin = input('Enter X/Y Lonbin/Latbin to look at (Lonbin 54 Latbin 32 -- is a good one, over Indonesia)  0 to stop: ');
  iChooseLatLonBin(1) = iXX;  %% scan lon
  iChooseLatLonBin(2) = JOB0; %% fixed lat

  indX = iChooseLatLonBin(1); indY = iChooseLatLonBin(2); 
  JOB = (indY-1)*72 + indX;
  fnameclr = ['RTP_PROFS/Clr/timestep_lonbin_' num2str(indX,'%02d') '_latbin_' num2str(indY,'%02d') '_JOB_' num2str(JOB,'%04d') '_clr.rtp'];
  fnamecld = ['RTP_PROFS/Cld/timestep_lonbin_' num2str(indX,'%02d') '_latbin_' num2str(indY,'%02d') '_JOB_' num2str(JOB,'%04d') '_cld.rtp'];
  fnameavg = ['RTP_PROFS/Avg/timestep_lonbin_' num2str(indX,'%02d') '_latbin_' num2str(indY,'%02d') '_JOB_' num2str(JOB,'%04d') '_avg.rtp'];
  fnamecold = ['RTP_PROFS/Cold/timestep_lonbin_' num2str(indX,'%02d') '_latbin_' num2str(indY,'%02d') '_JOB_' num2str(JOB,'%04d') '_cold.rtp'];

  if ~exist(fnameclr) | ~exist(fnamecld) | ~exist(fnameavg) | ~ exist(fnamecold)
    fprintf(1,'  .... doing lon/lat %2i %2i \n',iXX,JOB0)
    cder = ['cd  /umbc/xfs2/strow/asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_CORRECT_LatLon/LatBin' num2str(iChooseLatLonBin(2),'%02d') '/'];
    eval(cder)
    themall = load(['summarystats_LatBin' num2str(iChooseLatLonBin(2),'%02d') '_LonBin_1_72_timesetps_001_412_V1.mat']);
    
    yy2002 = themall.yy(iChooseLatLonBin(1),:) + (themall.mm(iChooseLatLonBin(1),:)-1)/12 + (themall.dd(iChooseLatLonBin(1),:)-1)/12/30;
    figure(1)
    plot(yy2002,themall.maxBT1231(iChooseLatLonBin(1),:),'r',yy2002,themall.meanBT1231(iChooseLatLonBin(1),:),'k',yy2002,themall.minBT1231(iChooseLatLonBin(1),:),'b')                             %% ORIG
    plot(yy2002,themall.maxBT1231(iChooseLatLonBin(1),:),'r',yy2002,rad2bt(1231,ttorad(1520,themall.meanBT1231(iChooseLatLonBin(1),:))),'k',yy2002,themall.minBT1231(iChooseLatLonBin(1),:),'b')   %% FIXED
    hl = legend('max','mean','min');
    xlim([min(yy2002) max(yy2002)]); title(['From all lonbins, choose bin ' num2str(iChooseLatLonBin(1),'%03d')])
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
    %% THIS HAS THE INDIVIDUAL SPECTRA
    cder = ['cd  LonBin' num2str(iChooseLatLonBin(1),'%02d')]; eval(cder);
    ind54 = load(['summarystats_LatBin' num2str(iChooseLatLonBin(2),'%02d') '_LonBin' num2str(iChooseLatLonBin(1),'%02d') '_timesetps_001_412_V1.mat']);
    [mean(ind54.lon_asc) mean(ind54.lat_asc)]
    
    figure(2);
    plot(yy2002,ind54.maxBT1231_desc,'r',yy2002,ind54.meanBT1231_desc,'k',yy2002,ind54.minBT1231_desc,'b')
    hl = legend('max','mean','min');
    xlim([min(yy2002) max(yy2002)]); title(['From LonBin' num2str(iChooseLatLonBin(1),'%02d')])
    
    figure(3);
    %% ORIG
    plot(yy2002,themall.maxBT1231(iChooseLatLonBin(1),:),'r',yy2002,themall.meanBT1231(iChooseLatLonBin(1),:),'k',yy2002,themall.minBT1231(iChooseLatLonBin(1),:),'b',...
         yy2002,ind54.maxBT1231_desc,'m',yy2002,ind54.meanBT1231_desc,'g',yy2002,ind54.minBT1231_desc,'c')
    xlim([min(yy2002) max(yy2002)]); 
    disp('<<< SO themall.meanBT1231 is completely messed up. mebbe channel is not 1291 or 1520! >>> ')
    
    %% FIXED
    plot(yy2002,themall.maxBT1231(iChooseLatLonBin(1),:),'r',yy2002,rad2bt(1231,ttorad(1520,themall.meanBT1231(iChooseLatLonBin(1),:))),'k',yy2002,themall.minBT1231(iChooseLatLonBin(1),:),'b',...
         yy2002,ind54.maxBT1231_desc,'m',yy2002,ind54.meanBT1231_desc,'g',yy2002,ind54.minBT1231_desc,'c')
    xlim([min(yy2002) max(yy2002)]); 
    disp('<<< SO themall.meanBT1231 now fixed. mebbe channel is not 1291 or 1520! >>> ')
    
    pall.rlat = ind54.lat_desc;
    pall.rlon = ind54.lon_desc;
    pall.rtime = ind54.tai93_desc + offset1958_to_1993;
    pall.robs1     = nanmean(ind54.rad_quantile_desc(:,:,15:16),3);   %% take hottest
    pallcold.robs1 = nanmean(ind54.rad_quantile_desc(:,:,1:2),3);     %% take coldest
    pallavg.robs1  = ind54.rad_quantile_desc(:,:,9);                  %% take avg
    pall_day = ind54.day_desc;
    [yypall,mmpall,ddpall] = tai2utcSergio(pall.rtime);
    palldoy2013 = change2days(ones(size(yypall))*2013,mmpall,ddpall,2013);
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure(6); plot(ind54.wnum,rad2bt(ind54.wnum,squeeze(ind54.rad_quantile_desc(1,:,:))),...
                    ind54.wnum,ones(size(ind54.wnum))*ind54.meanBT1231_desc(1),'k',1231,ind54.meanBT1231_desc(1),'kx',...
                    ind54.wnum,ones(size(ind54.wnum))*ind54.maxBT1231_desc(1),'k',1231,ind54.maxBT1231_desc(1),'kx',...
                    ind54.wnum,ones(size(ind54.wnum))*ind54.minBT1231_desc(1),'k',1231,ind54.minBT1231_desc(1),'kx',1231*ones(1,3),[ind54.maxBT1231_desc(1) ind54.meanBT1231_desc(1) ind54.minBT1231_desc(1)])
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cder = ['cd ' homedir]; eval(cder);
    
    thedir = dir(['../DATA_OneYear/' num2str(JOB,'%04d') '/pall_gridbox_' num2str(JOB,'%04d') '_16daytimestep_*.mat']);
    
    choose_palldoy2013_erafile = zeros(size(palldoy2013));
    %% see /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/MakeAvgCldProfs2002_2020/Code_starts_Sept2002/check_files_ERA_made_one_year.m
  
    profNclr = struct;
    profNcld = struct;
    profNavg = struct;
    profNcold = struct;
  
    headN = struct;
    for tt = 1 : length(thedir)
      prof = load(['../DATA_OneYear/' num2str(JOB,'%04d') '/pall_gridbox_' num2str(JOB,'%04d') '_16daytimestep_001_2013_01_01_to_2013_01_16.mat']);
      prof = load(['../DATA_OneYear/' num2str(JOB,'%04d') '/' thedir(tt).name]);
      [yyy,mmm,ddd,hhh] = tai2utcSergio(mean(prof.p2x.rtime));
      booall_2013 = change2days(ones(size(yyy))*2013,mmm,ddd,2013);
      dadiffOK = find(abs(palldoy2013-booall_2013) <= 16);
      choose_palldoy2013_erafile(dadiffOK) = tt;
  
      figure(6); hold on; plot(prof.h2x.vchan,rad2bt(prof.h2x.vchan,prof.pavg.mean_cloud_calc),'ko','linewidth',3,'markersize',5); hold off
      %figure(7); clf; plot(prof.h2x.vchan,rad2bt(prof.h2x.vchan,prof.p2x.rcalc))
    
      %%I loaded in 2013, so from Sept 2002 to Jan 2013 is about (2012-2002)*23 + (4*30/23) = timestep 235
      %{
      figure(7); clf;  plot(ind54.quants(2:end),ind54.quantile1231_desc(235+tt-1,:),'o-',ind54.quants,quantile(rad2bt(prof.h2x.vchan(5),prof.p2x.rcalc(5,:)),ind54.quants),'rx-');
      hl = legend('Obs BT1231 quantiles','allsky ERA quantiles','location','best','fontsize',8); title(['2013 timestep ' num2str(tt) ' : ' num2str(mmm,'%02d') '/' num2str(ddd,'%02d') ]);
  
      figure(7); clf;  plot(ind54.quants(2:end),ind54.quantile1231_desc(235+tt-1,:),'o-',ind54.quants,quantile(rad2bt(prof.h2x.vchan(5),prof.p2x.sarta_rclearcalc(5,:)),ind54.quants),'rx-');
      hl = legend('Obs BT1231 quantiles','clear ERA quantiles','location','best','fontsize',8); title(['2013 timestep ' num2str(tt) ' : ' num2str(mmm,'%02d') '/' num2str(ddd,'%02d') ]);
      %}
  
      figure(7); clf;  plot(ind54.quants(2:end),ind54.quantile1231_desc(235+tt-1,:),'bo-',ind54.quants,quantile(rad2bt(prof.h2x.vchan(5),prof.p2x.rcalc(5,:)),ind54.quants),'gx-',...
                                                                                          ind54.quants,quantile(rad2bt(prof.h2x.vchan(5),prof.p2x.sarta_rclearcalc(5,:)),ind54.quants),'rs-');
      hl = legend('Obs BT1231 quantiles','allsky ERA quantiles','clear ERA quantiles','location','best','fontsize',8); title(['2013 timestep ' num2str(tt) ' : ' num2str(mmm,'%02d') '/' num2str(ddd,'%02d') ]);
  
      pause(0.1)
  
      %% this is just comparing one of them in 2013
      saveOBS(tt) = ind54.quantile1231_desc(235+tt-1,16);
      saveOBS_HOT(tt) = ind54.maxBT1231_desc(235+tt-1);
  
      wahClr = quantile(rad2bt(prof.h2x.vchan(5),prof.p2x.sarta_rclearcalc(5,:)),ind54.quants);
      savePROFILEclr(tt) = find(rad2bt(prof.h2x.vchan(5),prof.p2x.sarta_rclearcalc(5,:)) >= wahClr(end),1);  %% <<<< THIS IS THE MONEY MAN >>>>>
      [hsub,psub] = subset_rtp(prof.h2x,prof.p2x,[],[],savePROFILEclr(tt));
      psub = rmfield(psub,'pnote');
      psub = rmfield(psub,'iudef');
      [headN,profNclr] = construct_rtp(headN,profNclr,hsub,psub,dadiffOK);
      profNclr.robs1(:,dadiffOK) = pall.robs1(dadiffOK,:)';
  
      wahCld = quantile(rad2bt(prof.h2x.vchan(5),prof.p2x.rcalc(5,:)),ind54.quants);
      savePROFILEcld(tt) = find(rad2bt(prof.h2x.vchan(5),prof.p2x.rcalc(5,:)) >= wahCld(end),1);             %% <<<< THIS IS THE MONEY MAN >>>>>
      [hsub,psub] = subset_rtp(prof.h2x,prof.p2x,[],[],savePROFILEcld(tt));
      psub = rmfield(psub,'pnote');
      psub = rmfield(psub,'iudef');
      [headN,profNcld] = construct_rtp(headN,profNcld,hsub,psub,dadiffOK);
      profNcld.robs1(:,dadiffOK) = pall.robs1(dadiffOK,:)';
  
      wahAvg = quantile(rad2bt(prof.h2x.vchan(5),prof.p2x.rcalc(5,:)),ind54.quants);
      savePROFILEavg(tt) = find(rad2bt(prof.h2x.vchan(5),prof.p2x.rcalc(5,:)) >= wahAvg(9),1);    %% <<<< THIS IS THE MONEY MAN >>>>>   note here I am comparing ERA calc to ERA quantile
      junk = find(rad2bt(prof.h2x.vchan(5),prof.p2x.rcalc(5,:)) >= mean(ind54.quantile1231_desc(tt,9)),1);      %% <<<< THIS IS THE MONEY MAN >>>>>   note here I am comparing ERA calc to OBS quantile
      if length(junk) == 1
        savePROFILEavg(tt) = junk;
      else
        junk = rad2bt(prof.h2x.vchan(5),prof.p2x.rcalc(5,:)) - mean(ind54.quantile1231_desc(tt,9));
        junk = abs(junk);
        junk = find(junk == min(junk),1);
        savePROFILEavg(tt) = junk;
      end
      [hsub,psub] = subset_rtp(prof.h2x,prof.p2x,[],[],savePROFILEavg(tt));
      psub = rmfield(psub,'pnote');
      psub = rmfield(psub,'iudef');
      [headN,profNavg] = construct_rtp(headN,profNavg,hsub,psub,dadiffOK);
      profNavg.robs1(:,dadiffOK) = pallavg.robs1(dadiffOK,:)';
  
      wahCold = quantile(rad2bt(prof.h2x.vchan(5),prof.p2x.rcalc(5,:)),ind54.quants);
      savePROFILEcold(tt) = find(rad2bt(prof.h2x.vchan(5),prof.p2x.rcalc(5,:)) >= wahCold(1),1);             %% <<<< THIS IS THE MONEY MAN >>>>>
      [hsub,psub] = subset_rtp(prof.h2x,prof.p2x,[],[],savePROFILEcold(tt));
      psub = rmfield(psub,'pnote');
      psub = rmfield(psub,'iudef');
      [headN,profNcold] = construct_rtp(headN,profNcold,hsub,psub,dadiffOK);
      profNcold.robs1(:,dadiffOK) = pallcold.robs1(dadiffOK,:)';
  
      saveCALClr(tt) = wahClr(end);
      saveCALCld(tt) = wahCld(end);
      saveCALAvg(tt) = wahCld(9);
      saveCALCold(tt) = wahCold(1);
      saveTT(tt) = mmm + ddd/30;
  
      figure(8); plot(dadiffOK,ind54.quantile1231_desc(dadiffOK,16),'bo-',dadiffOK,ones(size(dadiffOK))*wahCld(end),'c--')
        hold on; plot(dadiffOK,ind54.quantile1231_desc(dadiffOK,16),'ro-',dadiffOK,ones(size(dadiffOK))*wahClr(end),'m--')
        hold on; plot(dadiffOK,ind54.quantile1231_desc(dadiffOK,9),'go-',dadiffOK,ones(size(dadiffOK))*wahAvg(end),'y--')
        hold on; plot(dadiffOK,ind54.quantile1231_desc(dadiffOK,1),'ko-',dadiffOK,ones(size(dadiffOK))*wahCold(1),'k--')
     hold off
      
    end
    [hjunk,hajunk,pjunk,pajunk] = rtpread('/asl/s1/sergio/rtp/rtp_airicrad_v6/2020/01/04/cloudy_airs_l1c_ecm_sarta_baum_ice.2020.01.04.151_cumsum_-1.rtp');
    headN.nchan = hjunk.nchan;
    headN.ichan = hjunk.ichan;
    headN.vchan = hjunk.vchan;
  
    profNclr = do_clearcalc(headN,profNclr,tempx,1);
    profNcld = do_clearcalc(headN,profNcld,tempx,1);
    profNavg = do_clearcalc(headN,profNavg,tempx,1);
    profNcold = do_clearcalc(headN,profNcold,tempx,1);
    headN.pfields = 7;
  
    figure(7); plot(saveTT,saveOBS,'b',saveTT,saveOBS_HOT,'c',saveTT,saveCALClr,'r',saveTT,saveCALCld,'m','linewidth',2); 
      hl = legend('obs','max obs','cal clr','cal cld','location','best','fontsize',10); xlim([min(saveTT) max(saveTT)]);
    figure(8); plot(profNclr.stemp,rad2bt(1231,profNclr.robs1(1520,:)),'b.',profNcld.stemp,rad2bt(1231,profNcld.robs1(1520,:)),'r.',profNclr.stemp,profNclr.stemp,'k'); xlabel('stemp'); ylabel('BT1231 obs')
    figure(9); plot(profNclr.stemp,profNclr.cngwat,'cx',profNclr.stemp,profNclr.cngwat2,'mx',profNcld.stemp,profNcld.cngwat,'bx',profNcld.stemp,profNcld.cngwat2,'rx'); xlabel('stemp'); ylabel('cngwat')
    figure(10); plot(profNclr.stemp,profNclr.cfrac,'cx',profNclr.stemp,profNclr.cfrac2,'mx',profNcld.stemp,profNcld.cfrac,'bx',profNcld.stemp,profNcld.cfrac2,'rx'); xlabel('stemp'); ylabel('cfrac')
  
    tobs = rad2bt(headN.vchan,profNcld.robs1);
    tclr = rad2bt(headN.vchan,profNclr.sarta_rclearcalc);
    tcld = rad2bt(headN.vchan,profNcld.rcalc);
  
    tobsavg = rad2bt(headN.vchan,profNavg.robs1);
    tavg = rad2bt(headN.vchan,profNavg.rcalc);
    tobscold = rad2bt(headN.vchan,profNcold.robs1);
    tcold = rad2bt(headN.vchan,profNcold.rcalc);
  
    figure(11); plot(headN.vchan,nanmean(tobs'-tclr'),'b',headN.vchan,nanmean(tobs'-tcld'),'r',headN.vchan,nanmean(tobsavg'-tavg'),'k',headN.vchan,nanmean(tobscold'-tcold'),'g',...
                     headN.vchan,nanstd(tobs'-tclr'),'c--',headN.vchan,nanstd(tobs'-tcld'),'m--',headN.vchan,nanstd(tobsavg'-tavg'),'k--',headN.vchan,nanstd(tobscold'-tcold'),'g--')
      xlim([min(headN.vchan) max(headN.vchan)]); hl=legend('bias best clr','bias best cld','best best avg','bias best cold','std best clr','std best cld','std best avg','std best cold','location','best'); grid on
      xlabel('Wavenumber cm-1'); ylabel('BT(K)')
    figure(12);
      plot(headN.vchan,nanmean(tobs'),'b',headN.vchan,nanmean(tobsavg'),'k',headN.vchan,nanmean(tobscold'),'g'); hl = legend('obs ht','obs avg','obs cold','location','best');
  
    %iSave = input('save the profs? (-1/+1) : ');
    iSave = +1;
    if iSave > 0
      rtpwrite(fnameclr,headN,[],profNclr,[]);
      rtpwrite(fnamecld,headN,[],profNcld,[]);
      rtpwrite(fnameavg,headN,[],profNavg,[]);
      rtpwrite(fnamecold,headN,[],profNcold,[]);
    end
  end
  
  %% iChooseLatLonBin = input('Enter Lonbin/Latbin to look at (Lonbin 54 Latbin 32 -- is a good one, over Indonesia)  0 to stop: ');
end

rmer = ['!/bin/rm ' tempx.tempfile1 ' ' tempx.tempfile2 ' ' tempx.tempfile3 ' ' tempx.tempfile4];
eval(rmer)
