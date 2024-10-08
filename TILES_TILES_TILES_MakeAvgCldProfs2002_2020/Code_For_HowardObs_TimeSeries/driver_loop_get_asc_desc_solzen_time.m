addpath /asl/matlib/aslutil
addpath /home/sergio/MATLABCODE
addpath /home/sergio/MATLABCODE/TIME
addpath /asl/matlib/rtptools/

iNumTimeSteps = 412;
iNumTimeSteps = 457;
iNumTimeSteps = 498;

fsave = ['asc_desc_solzen_time_' num2str(iNumTimeSteps) '_64x72.mat'];
if ~exist(fsave)
  %%%% saver = ['save ' fsave ]; eval(saver)
  fprintf(1,'%s DNE, gathering the data to make it \n ',fsave)
else
  fprintf(1,'%s aready exists, not saving \n ',fsave)
end

for ii = 1 : 72
  fprintf(1,'longitude %2i of 72 ',ii);
  for jj = 1 : 64
    fprintf(1,'.');
    fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/summarystats_LatBin' num2str(jj,'%02d') '_LonBin' num2str(ii,'%02d') '_timesetps_001_412_V1.mat'];
    fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/summarystats_LatBin' num2str(jj,'%02d') '_LonBin' num2str(ii,'%02d') '_timesetps_001_457_V1.mat'];
    fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/summarystats_LatBin' num2str(jj,'%02d') '_LonBin' num2str(ii,'%02d') '_timesetps_001_' num2str(iNumTimeSteps) '_V1.mat'];
    fname = ['../DATAObsStats_StartSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/iQAX_3_summarystats_LatBin' num2str(jj,'%02d') '_LonBin' num2str(ii,'%02d') '_timesetps_001_' num2str(iNumTimeSteps) '_V1.mat'];
    a = load(fname);
    thedata.rlon_asc(ii,jj,:)     = a.lon_asc;
    thedata.rlat_asc(ii,jj,:)     = a.lat_asc;
    thedata.solzen_asc(ii,jj,:)   = a.solzen_asc;
    thedata.satzen_asc(ii,jj,:)   = a.satzen_asc;
    thedata.hour_asc(ii,jj,:)     = a.hour_asc;
    thedata.rtime_asc(ii,jj,:)    = a.tai93_asc + offset1958_to_1993;
    thedata.bt1231_asc(ii,jj,:,:) = [a.minBT1231_asc; a.meanBT1231_asc; a.maxBT1231_asc]';
    thedata.bt1231_quant_asc(ii,jj,:,:) = [squeeze(rad2bt(1231,a.rad_quantile_asc(:,1520,:)))];

    thedata.rlon_desc(ii,jj,:)     = a.lon_desc;
    thedata.rlat_desc(ii,jj,:)     = a.lat_desc;
    thedata.solzen_desc(ii,jj,:)   = a.solzen_desc;
    thedata.satzen_desc(ii,jj,:)   = a.satzen_desc;
    thedata.hour_desc(ii,jj,:)     = a.hour_desc;
    thedata.rtime_desc(ii,jj,:)    = a.tai93_desc + offset1958_to_1993;
    thedata.bt1231_desc(ii,jj,:,:) = [a.minBT1231_desc; a.meanBT1231_desc; a.maxBT1231_desc]';
    thedata.bt1231_quant_desc(ii,jj,:,:) = [squeeze(rad2bt(1231,a.rad_quantile_desc(:,1520,:)))];
  end
  fprintf(1,'\n');
end

clear a fname ii jj saver
comment = 'see /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries/driver_loop_get_asc_desc_solzen_time.m';
%save asc_desc_solzen_time_412_64x72.mat comment thedata
if ~exist(fsave)
  saver = ['save ' fsave ]; eval(saver)
else
  fprintf(1,'%s aready exists, not saving \n ',fsave)
end

utchh = squeeze(nanmean(thedata.hour_desc,3))'; rlon = squeeze(nanmean(thedata.rlon_desc,3))'; lshD = utchour2localtime(utchh,rlon); lshD = mod(lshD,24); pcolor(lshD); colorbar; title('Desc local hour')
utchh = squeeze(nanmean(thedata.hour_asc,3))';  rlon = squeeze(nanmean(thedata.rlon_asc,3))';  lshA = utchour2localtime(utchh,rlon); lshA = mod(lshA,24); pcolor(lshA); colorbar; title('Asc local hour')
hhx = -1:0.25:+25; plot(hhx,histc(lshD(:),hhx),hhx,histc(lshA(:),hhx),'linewidth',2); hl = legend('Desc','Asc','location','best'); grid; xlim([-1 25])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
for ii = 1 : 50 : 400
  rlon   = thedata.rlon_asc(:,:,ii);     rlon = rlon(:);
  rlat   = thedata.rlat_asc(:,:,ii);     rlat = rlat(:);
  solzen = thedata.solzen_asc(:,:,ii);   solzen = solzen(:);
  satzen = thedata.satzen_asc(:,:,ii);   satzen = satzen(:);
  hour   = thedata.hour_asc(:,:,ii);     hour = hour(:);
  bt1231 = thedata.bt1231_asc(:,:,ii,2); bt1231 = bt1231(:);
  figure(1); scatter_coast(rlon(:),rlat(:),50,solzen(:)); colormap jet
  figure(2); scatter_coast(rlon(:),rlat(:),50,satzen(:)); colormap jet
  figure(3); scatter_coast(rlon(:),rlat(:),50,hour(:)); colormap jet
  figure(4); scatter_coast(rlon(:),rlat(:),50,bt1231(:)); colormap jet
  pause(0.1)
end

for ii = 1 : 50 : 400
  rlon   = thedata.rlon_desc(:,:,ii);     rlon = rlon(:);
  rlat   = thedata.rlat_desc(:,:,ii);     rlat = rlat(:);
  solzen = thedata.solzen_desc(:,:,ii);   solzen = solzen(:);
  satzen = thedata.satzen_desc(:,:,ii);   satzen = satzen(:);
  hour   = thedata.hour_desc(:,:,ii);     hour = hour(:);
  bt1231 = thedata.bt1231_desc(:,:,ii,2); bt1231 = bt1231(:);
  figure(1); scatter_coast(rlon(:),rlat(:),50,solzen(:)); colormap jet
  figure(2); scatter_coast(rlon(:),rlat(:),50,satzen(:)); colormap jet
  figure(3); scatter_coast(rlon(:),rlat(:),50,hour(:)); colormap jet
  figure(4); scatter_coast(rlon(:),rlat(:),50,bt1231(:)); colormap jet
  pause(0.1)
end
%}
