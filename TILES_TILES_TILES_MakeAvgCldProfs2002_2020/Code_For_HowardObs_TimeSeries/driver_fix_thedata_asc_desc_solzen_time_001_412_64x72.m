%% script function to fix_thedata_asc_desc_solzen_time_412_64x72
%% function [thedata,thedata0,translateOld2New] = driver_fix_thedata_asc_desc_solzen_time_412_64x72(iDorA);

addpath /home/sergio/MATLABCODE/TIME

%% iNumSteps used to be called Nmax
iNumTimeSteps = 412;
iNumTimeSteps = 457; 

iDorA = -1; %% asc
iDorA = +1; %% desc

iDorA

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switchERAtoECM = utc2taiSergio(2019,09,01,12);  %% this is when ERA ends

%% unfortunately some 16 day dates are missing
%%   388 should be end of 2019/08/31, not 387  -- there is a step missing between 168 and 169
%%   411 should be end of 2020/09/01 

N = 16; N = 15; N1 = 1;
  firstORend = 0;
  iPrint = -1;

yy0 = 2002; mm0 = 09; dd0 = 01;
thedateS(1,:) = [yy0 mm0 dd0]; 
rtimeS(1) = utc2taiSergio(yy0,mm0,dd0,12);

[yy1,mm1,dd1] = addNdays(yy0,mm0,dd0,N,firstORend,iPrint);
thedateE(1,:) = [yy1 mm1 dd1]; 
rtimeE(1) = utc2taiSergio(yy1,mm1,dd1,12);

for ii = 2 : iNumTimeSteps
  
  yy0 = yy1; mm0 = mm1; dd0 = dd1;

  %% go forward by 1
  [yy1,mm1,dd1] = addNdays(yy0,mm0,dd0,N1,firstORend,iPrint);
  yy0 = yy1; mm0 = mm1; dd0 = dd1;
  thedateS(ii,:) = [yy0 mm0 dd0];  
  rtimeS(ii) = utc2taiSergio(yy0,mm0,dd0,12);

  [yy1,mm1,dd1] = addNdays(yy0,mm0,dd0,N,firstORend,iPrint);
  thedateE(ii,:) = [yy1 mm1 dd1];
  rtimeE(ii) = utc2taiSergio(yy1,mm1,dd1,12);

  if switchERAtoECM > rtimeE(ii) 
    fprintf(1,' ERA ii=%4i   Start %4i/%2i/%2i  End %4i/%2i/%2i rtimeS/E = %12.10e %12.10e\n',ii,thedateS(ii,:),thedateE(ii,:),rtimeS(ii),rtimeE(ii))
  elseif switchERAtoECM <= rtimeE(ii) 
    fprintf(1,' ECM ii=%4i   Start %4i/%2i/%2i  End %4i/%2i/%2i rtimeS/E = %12.10e %12.10e\n',ii,thedateS(ii,:),thedateE(ii,:),rtimeS(ii),rtimeE(ii))
  end
end  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

loadername = ['/home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries/asc_desc_solzen_time_412_64x72.mat'];
loadername = ['/home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries/asc_desc_solzen_time_' num2str(iNumTimeSteps) '_64x72.mat'];

load(loadername)
thedata0 = thedata;
if iDorA > 0
  meanrtime = nanmean(squeeze(nanmean(thedata.rtime_desc,1)),1);
else
  meanrtime = nanmean(squeeze(nanmean(thedata.rtime_asc,1)),1);
end

%% now check rtimeS < meanrtime < rtimeE
boo = rtimeE-rtimeS; boo = find(boo < 0);
if length(boo) > 0
  boo
  disp('oops found some rtimeE-rtimeS < 0');
end
boo = meanrtime(1:iNumTimeSteps)-rtimeS; boo = find(boo < 0);
if length(boo) > 0
  boo
  disp('oops found some meanrtime(1:iNumTimeSteps)-rtimeS < 0');
end
boo = rtimeE-meanrtime(1:iNumTimeSteps); boo = find(boo < 0);
if length(boo) > 0
  boo
  disp('oops found some rtimeE-meanrtime(1:iNumTimeSteps) < 0');
end

for ii = 1 : iNumTimeSteps
  if mod(ii,100) == 0
    fprintf(1,'+')
  elseif mod(ii,10) == 0
    fprintf(1,'.')
  end
  tt = ii; junk = thedata.rtime_desc(:,:,tt); junk=mean(junk(:)); [junkYY,junkMM,junkDD,junkHH] = tai2utcSergio(junk); 
  %fprintf(1,' %3i  tS tData tE  %4i/%2i/%2i     %4i/%2i/%2i     %4i/%2i/%2i     deltaRtime(Max-Junk) = %8.6f %3i\n',ii,thedateS(tt,:),junkYY,junkMM,junkDD,thedateE(tt,:),(rtimeE(tt)-junk)/86400,round((rtimeE(tt)-junk)/86400))
  deltatime(ii) = round((rtimeE(ii)-junk)/86400);
  rtime_thedata(ii) = junk;
end
fprintf(1,'\n');

%% find the bad breaks (which are a month long, instead of 16 days long)
thediff = nan(size(deltatime)); thediff(2:iNumTimeSteps) = diff(deltatime); 
%bad = find(abs(thediff) > 3)
%bad = find(rtime_thedata > rtimeE)
bad = find(abs(thediff) > 3 & rtime_thedata > rtimeE)

for ii = 1 : length(bad)
  tt = bad(ii)-1;
  junk = thedata.rtime_desc(:,:,tt); junk=mean(junk(:)); [junkYY,junkMM,junkDD,junkHH] = tai2utcSergio(junk);
  fprintf(1,' %3i  tS tData tE  %4i/%2i/%2i     %4i/%2i/%2i     %4i/%2i/%2i     deltaRtime(Max-Junk) = %8.6f %3i\n',tt,thedateS(tt,:),junkYY,junkMM,junkDD,thedateE(tt,:),(rtimeE(tt)-junk)/86400,round((rtimeE(tt)-junk)/86400))
  tt = bad(ii);
  junk = thedata.rtime_desc(:,:,tt); junk=mean(junk(:)); [junkYY,junkMM,junkDD,junkHH] = tai2utcSergio(junk);
  fprintf(1,' %3i  tS tData tE  %4i/%2i/%2i     %4i/%2i/%2i     %4i/%2i/%2i     deltaRtime(Max-Junk) = %8.6f %3i\n',tt,thedateS(tt,:),junkYY,junkMM,junkDD,thedateE(tt,:),(rtimeE(tt)-junk)/86400,round((rtimeE(tt)-junk)/86400))
  tt = bad(ii)+1;
  junk = thedata.rtime_desc(:,:,tt); junk=mean(junk(:)); [junkYY,junkMM,junkDD,junkHH] = tai2utcSergio(junk);
  fprintf(1,' %3i  tS tData tE  %4i/%2i/%2i     %4i/%2i/%2i     %4i/%2i/%2i     deltaRtime(Max-Junk) = %8.6f %3i\n',tt,thedateS(tt,:),junkYY,junkMM,junkDD,thedateE(tt,:),(rtimeE(tt)-junk)/86400,round((rtimeE(tt)-junk)/86400))
  disp(' ')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% fix the bad days
Nstep2002_09_to_2020_08 = 411; %% we will stop at 411
Nstep2002_09_to_2020_08 = 457; %% we will stop at 457

clear thedata
if iDorA > 0
  commentFix = ['see /home/sergio/MATLABCODE/RTPMAKE/CLUST_RTPMAKE/CLUSTMAKE_ERA/driver_fix_thedata_asc_desc_solzen_time_412_64x72.m ... bad indices = ' num2str(bad)];

  thedata.rlon_desc         = zeros(72,64,Nstep2002_09_to_2020_08);
  thedata.rlat_desc         = zeros(72,64,Nstep2002_09_to_2020_08);
  thedata.solzen_desc       = zeros(72,64,Nstep2002_09_to_2020_08);
  thedata.satzen_desc       = zeros(72,64,Nstep2002_09_to_2020_08);
  thedata.hour_desc         = zeros(72,64,Nstep2002_09_to_2020_08);
  thedata.rtime_desc        = zeros(72,64,Nstep2002_09_to_2020_08);
  thedata.bt1231_desc       = zeros(72,64,Nstep2002_09_to_2020_08,3);
  thedata.bt1231_quant_desc = zeros(72,64,Nstep2002_09_to_2020_08,16);

  for ii = 1 : length(bad)
    if ii == 1
      indold  = 1 : bad(ii)-1;
      indnew = indold;      
    else
      indold  = bad(ii-1) : bad(ii)-1;
      indnew = indold + ii-1;
    end

    fprintf(1,'index bad(index) = %2i %3i  swap [%3i %3i] into [%3i %3i] \n',ii,bad(ii),indold(1),indold(end),indnew(1),indnew(end));
    translateOld2New(indnew)            = indold; %% so what was previously "indold" is now "indnew"

    thedata.translateOld2New(indnew) = indold; %% so what was previously "indold" is now "indnew"

    thedata.rlon_desc(:,:,indnew)           = thedata0.rlon_desc(:,:,indold);
    thedata.rlat_desc(:,:,indnew)           = thedata0.rlat_desc(:,:,indold);
    thedata.solzen_desc(:,:,indnew)         = thedata0.solzen_desc(:,:,indold);
    thedata.satzen_desc(:,:,indnew)         = thedata0.satzen_desc(:,:,indold);
    thedata.hour_desc(:,:,indnew)           = thedata0.hour_desc(:,:,indold);
    thedata.rtime_desc(:,:,indnew)          = thedata0.rtime_desc(:,:,indold);
    thedata.bt1231_desc(:,:,indnew,:)       = thedata0.bt1231_desc(:,:,indold,:);
    thedata.bt1231_quant_desc(:,:,indnew,:) = thedata0.bt1231_quant_desc(:,:,indold,:);

    drtime = squeeze(thedata.rtime_desc(:,:,indnew)); drtime = nanmean(drtime,3); drtime = drtime-drtime(1);
    thedata.rlon_desc(:,:,bad(ii)+(ii-1))          = thedata0.rlon_desc(:,:,bad(ii));
    thedata.rlat_desc(:,:,bad(ii)+(ii-1))          = thedata0.rlat_desc(:,:,bad(ii));
    thedata.solzen_desc(:,:,bad(ii)+(ii-1))        = thedata0.solzen_desc(:,:,bad(ii));
    thedata.satzen_desc(:,:,bad(ii)+(ii-1))        = thedata0.satzen_desc(:,:,bad(ii));
    thedata.hour_desc(:,:,bad(ii)+(ii-1))          = thedata0.hour_desc(:,:,bad(ii));
    thedata.rtime_desc(:,:,bad(ii)+(ii-1))         = 0.5*(rtimeS(bad(ii)+(ii-1))+rtimeE(bad(ii)+(ii-1))) + drtime;

    [yyGood,mmGood,ddGood,hhGood] = tai2utcSergio(squeeze(thedata.rtime_desc(:,:,bad(ii)+(0-ii))));
    [yyBad,mmBad,ddBad,hhBad] = tai2utcSergio(squeeze(thedata.rtime_desc(:,:,bad(ii)+(ii-1))));
    figure(1); boo = squeeze(thedata.hour_desc(:,:,bad(ii)+(0-ii)));  imagesc((boo-boo(1))); colorbar; title('GOOD')
    figure(2); boo = squeeze(thedata.hour_desc(:,:,bad(ii)+(ii-1)));  imagesc((boo-boo(1))); colorbar; title('BAD')
    figure(1); boo = squeeze(thedata.rtime_desc(:,:,bad(ii)+(0-ii))); imagesc((boo-boo(1))/86400); colorbar; title('GOOD')
    figure(2); boo = squeeze(thedata.rtime_desc(:,:,bad(ii)+(ii-1))); imagesc((boo-boo(1))/86400); colorbar; title('BAD')
    figure(1); boo = yyGood; boo = mmGood; boo = ddGood; boo = hhGood; imagesc(boo); colorbar; title('GOOD')
    figure(2); boo = yyBad;  boo = mmBad;  boo = ddBad;  boo = hhBad;  imagesc(boo); colorbar; title('BAD')
    for ttt = 160:169
      [yyBad,mmBad,ddBad,hhBad] = tai2utcSergio(squeeze(thedata.rtime_desc(:,:,ttt))); boo = hhBad;  imagesc(boo); colorbar; title(num2str(ttt)); pause(0.1); %pause
    end
  end

  for ii = 1 : Nstep2002_09_to_2020_08
    tt = ii; junk = thedata.rtime_desc(:,:,tt); junk = mean(junk(:)); [junkYY,junkMM,junkDD,junkHH] = tai2utcSergio(junk); 
    fprintf(1,' %3i  tS tData tE  %4i/%2i/%2i     %4i/%2i/%2i     %4i/%2i/%2i     deltaRtime(Max-Junk) = %8.6f %3i\n',ii,thedateS(tt,:),junkYY,junkMM,junkDD,thedateE(tt,:),(rtimeE(tt)-junk)/86400,round((rtimeE(tt)-junk)/86400))
    deltatimeX(ii) = round((rtimeE(ii)-junk)/86400);
    rtime_thedataX(ii) = junk;
  end

  %save /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries/asc_desc_solzen_time_412_64x72_fix_desc.mat thedata translateOld2New commentFix
  %save /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries/timestepsStartEnd_2002_09_to_2020_09.mat  commentFix thedateS thedateE rtimeS rtimeE iNumTimeSteps switchERAtoECM bad
  xname1 = ['/home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries/asc_desc_solzen_time_' num2str(iNumTimeSteps) '_64x72_fix_desc.mat'];
  xname2 = ['/home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries/timestepsStartEnd_2002_09_to_2020_09_' num2str(iNumTimeSteps) '.mat'];
  saver = ['save ' xname1 ' thedata translateOld2New commentFix']; eval(saver)
  saver = ['save ' xname2 ' commentFix thedateS thedateE rtimeS rtimeE iNumTimeSteps switchERAtoECM bad'];

elseif iDorA < 0
  commentFix = ['see /home/sergio/MATLABCODE/RTPMAKE/CLUST_RTPMAKE/CLUSTMAKE_ERA/driver_fix_thedata_asc_desc_solzen_time_412_64x72.m ... bad indices = ' num2str(bad)];

  thedata.rlon_asc         = zeros(72,64,Nstep2002_09_to_2020_08);
  thedata.rlat_asc         = zeros(72,64,Nstep2002_09_to_2020_08);
  thedata.solzen_asc       = zeros(72,64,Nstep2002_09_to_2020_08);
  thedata.satzen_asc       = zeros(72,64,Nstep2002_09_to_2020_08);
  thedata.hour_asc         = zeros(72,64,Nstep2002_09_to_2020_08);
  thedata.rtime_asc        = zeros(72,64,Nstep2002_09_to_2020_08);
  thedata.bt1231_asc       = zeros(72,64,Nstep2002_09_to_2020_08,3);
  thedata.bt1231_quant_asc = zeros(72,64,Nstep2002_09_to_2020_08,16);

  for ii = 1 : length(bad)
    if ii == 1
      indold  = 1 : bad(ii)-1;
      indnew = indold;      
    else
      indold  = bad(ii-1) : bad(ii)-1;
      indnew = indold + ii-1;
    end

    fprintf(1,'index bad(index) = %2i %3i  swap [%3i %3i] into [%3i %3i] \n',ii,bad(ii),indold(1),indold(end),indnew(1),indnew(end));
    translateOld2New(indnew)            = indold; %% so what was previously "indold" is now "indnew"

    thedata.translateOld2New(indnew) = indold; %% so what was previously "indold" is now "indnew"

    thedata.rlon_asc(:,:,indnew)           = thedata0.rlon_asc(:,:,indold);
    thedata.rlat_asc(:,:,indnew)           = thedata0.rlat_asc(:,:,indold);
    thedata.solzen_asc(:,:,indnew)         = thedata0.solzen_asc(:,:,indold);
    thedata.satzen_asc(:,:,indnew)         = thedata0.satzen_asc(:,:,indold);
    thedata.hour_asc(:,:,indnew)           = thedata0.hour_asc(:,:,indold);
    thedata.rtime_asc(:,:,indnew)          = thedata0.rtime_asc(:,:,indold);
    thedata.bt1231_asc(:,:,indnew,:)       = thedata0.bt1231_asc(:,:,indold,:);
    thedata.bt1231_quant_asc(:,:,indnew,:) = thedata0.bt1231_quant_asc(:,:,indold,:);
    
    drtime = squeeze(thedata.rtime_asc(:,:,indnew)); drtime = nanmean(drtime,3); drtime = drtime-drtime(1);
    thedata.rlon_asc(:,:,bad(ii)+(ii-1))          = thedata0.rlon_asc(:,:,bad(ii));
    thedata.rlat_asc(:,:,bad(ii)+(ii-1))          = thedata0.rlat_asc(:,:,bad(ii));
    thedata.solzen_asc(:,:,bad(ii)+(ii-1))        = thedata0.solzen_asc(:,:,bad(ii));
    thedata.satzen_asc(:,:,bad(ii)+(ii-1))        = thedata0.satzen_asc(:,:,bad(ii));
    thedata.hour_asc(:,:,bad(ii)+(ii-1))          = thedata0.hour_asc(:,:,bad(ii));
    thedata.rtime_asc(:,:,bad(ii)+(ii-1))         = 0.5*(rtimeS(bad(ii)+(ii-1))+rtimeE(bad(ii)+(ii-1))) + drtime;
  end

  for ii = 1 : Nstep2002_09_to_2020_08
    tt = ii; junk = thedata.rtime_asc(:,:,tt); junk = mean(junk(:)); [junkYY,junkMM,junkDD,junkHH] = tai2utcSergio(junk); 
    fprintf(1,' %3i  tS tData tE  %4i/%2i/%2i     %4i/%2i/%2i     %4i/%2i/%2i     deltaRtime(Max-Junk) = %8.6f %3i\n',ii,thedateS(tt,:),junkYY,junkMM,junkDD,thedateE(tt,:),(rtimeE(tt)-junk)/86400,round((rtimeE(tt)-junk)/86400))
    deltatimeX(ii) = round((rtimeE(ii)-junk)/86400);
    rtime_thedataX(ii) = junk;
  end

  %save /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries/asc_desc_solzen_time_412_64x72_fix_asc.mat thedata translateOld2New commentFix
  %save /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries/timestepsStartEnd_2002_09_to_2020_09.mat  commentFix thedateS thedateE rtimeS rtimeE iNumTimeSteps switchERAtoECM bad
  xname1 = ['/home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries/asc_desc_solzen_time_' num2str(iNumTimeSteps) '_64x72_fix_asc.mat'];
  xname2 = ['/home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries/timestepsStartEnd_2002_09_to_2020_09_' num2str(iNumTimeSteps) '.mat'];
  saver = ['save ' xname1 ' thedata translateOld2New commentFix']; eval(saver)
  saver = ['save ' xname2 ' commentFix thedateS thedateE rtimeS rtimeE iNumTimeSteps switchERAtoECM bad'];

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
so now need to change filenames depending on "translateOld2New" it really should be "translateOldFromNew"  as eg what was 169 should become 170 (ie 169 should not exist)
[translateOld2New; (1:410)]'
  OLD      NEW
 --------------
  1-168    168
  169      DNE
  169-393  170-394
  395      DNE
  394-409  396-411 

plan would be : 
(a) modify these so they read asc_asc_solzen_time_412_64x72_fix_asc.mat or asc_asc_solzen_time_412_64x72_fix_desc.mat instead of asc_asc_solzen_time_412_64x72.mat
-rw-rw-r-- 1 sergio pi_strow 13495 Aug  4 20:40 clust_loop_make16day_tile_28points.m
  currently saves into   
          dout = ['/asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_v3/TimeSeries/ERA/Tile_16day/DESC/Day' num2str(ddd,'%02d') '/ERAindex' num2str(eeeXY_cnt,'%02d')  '/'];
          fout = [dout '/era_tile_X_' num2str(eeeX) '_Y_' num2str(eeeY)  '_day_' num2str(ddd,'%02d') '_individual_timestep_' num2str(JOB,'%03d') '.mat'];
-rw-rw-r-- 1 sergio pi_strow  8144 Aug  4 09:24 clust_loop_make16day_tile_center.m
  currently saves into   
          fout = ['/asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_v3/TimeSeries/ERA/Tile_Center/DESC/era_tile_center_timestep_' num2str(JOB,'%03d') '.mat'];
(b) make new files   rename_loop_make16day_tile_28points.m   and   rename_loop_make16day_tile_center.m   so they do the following

look at current dir
make temp dir
%% do not really need to move 1-168 [unchanged] to temp dir  so will have 001-168
%  for ii = 1:168
%    mver = ['!/bin/mv ' dOrig '/' fname num2str(ii,'%03d') '.mat ' dTemp '/' fname num2str(ii,'%03d') '.mat'];
%    eval(mer)
%  end

%% move 394-408, upping index by two, so will have 396-410   NO 394 395
for ii = 394:409
  mver = ['!/bin/mv ' dOrig '/' fname num2str(ii,'%03d') '.mat ' dTemp '/' fname num2str(ii+2,'%03d') '.mat'];
  eval(mer)
end

%% move 169-393, upping index by one, so will have 170-394   NO 169, and will put 394 into the above segment -- SO NO 169 394 .. have to run those
for ii = 169:393
  mver = ['!/bin/mv ' dOrig '/' fname num2str(ii,'%03d') '.mat ' dTemp '/' fname num2str(ii+1,'%03d') '.mat'];
  eval(mer)
end

%move all renamed files back from temp dir to current dir 
mver = ['/bin/mv dTemp '/' fname*.mat  ' dOrig '/.'];
%}  
