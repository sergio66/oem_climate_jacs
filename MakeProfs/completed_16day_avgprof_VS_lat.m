addpath /asl/matlib/h4tools
addpath /asl/matlib/aslutil
addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS

set_dirIN_dirOUT    %% set the input/output directory here
  dirOUTA = [dirOUT '/16DayAvg/'];
  dirOUTB = [dirOUT '/16DayAvgNoS/'];
dirOUT = dirOUTB;

if strfind(dirIN,'Airs')
  startYY = 2002; startMM = 09;
  %stopYY  = 2015; stopMM  = 08;

  stopYY  = 2017; stopMM  = 08;
  stopYY  = 2018; stopMM  = 08;

elseif strfind(dirIN,'Cris')
  startYY = 2012; startMM = 05;
  stopYY  = 2018; stopMM  = 04;
  stopYY  = 2019; stopMM  = 04;  %% did I mess up .. Larrabee says they really do go to 2019 ... oh well
end

ii = 20;
fopx = [dirOUT '/latbin' num2str(ii) '_16day_avg.op.rtp'];
frpx = [dirOUT '/latbin' num2str(ii) '_16day_avg.rp.rtp'];
if exist(frpx)
  [h20x,ha,p20x,pa] = rtpread(fopx);
  [h20,ha,p20,pa]   = rtpread(frpx);
  [yy20,mm20,dd20,hh20] = tai2utcSergio(p20.rtime);
  days_since_2002_20 = change2days(yy20,mm20,dd20,startYY);
  plot(p20.stemp,rad2bt(1231,p20.rcalc(1291,:)),'.',p20.stemp,p20.stemp)
  [sum(p20x.rtime-p20.rtime) sum(days_since_2002_20 - p20x.avg16_doy_since2002)]
end

iNumTimeStep = 365;
iNumTimeStep = length(p20x.stemp);

iMaxLatbin = 40;  % should be true for all instr
iMaxLatbin = 39;  % dont ask about CriS

xtimestart = 2002.75;   %% AIRS
xtimestart = 2012+4/12; %% CrIS lo

matr_closest_rtime_found = zeros(40,iNumTimeStep);
for ii = 1 : iMaxLatbin
  fopx = [dirOUT '/latbin' num2str(ii) '_16day_avg.op.rtp'];
  frpx = [dirOUT '/latbin' num2str(ii) '_16day_avg.rp.rtp'];
  if exist(frpx)
    [hx,ha,px,pa] = rtpread(fopx);
    [h,ha,p,pa]   = rtpread(frpx);
    [yy,mm,dd,hh] = tai2utcSergio(p.rtime);
    days_since_2002 = change2days(yy,mm,dd,2002);
    plot(p.stemp,rad2bt(1231,p.rcalc(1291,:)),'.',p.stemp,p.stemp); xlabel('stemp'); ylabel('BT1231 calc'); grid
    title(num2str(ii)); pause(0.1)
    fprintf(1,'%2i %3i %3i \n',ii,length(p.stemp),length(p20.stemp))
    %[sum(p20x.rtime-p20.rtime) sum(days_since_2002_20 - p20x.avg16_doy_since2002)]

    for tt = 1 : length(p20.stemp)
      boo = abs(p20.rtime(tt)-p.rtime);
      boo = find(boo == min(boo),1);
      matr_closest_rtime_found(ii,tt) = boo;
    end
  else
    fprintf(1,'%2i DNE \n',ii)
  end
end

pcolor(1:iNumTimeStep,1:40,matr_closest_rtime_found); colormap jet; colorbar; shading flat; title('Closest to rtime20 Mapping')
plot(1:iNumTimeStep,matr_closest_rtime_found(1:3,:),'o-',1:iNumTimeStep,1:iNumTimeStep)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath /home/sergio/MATLABCODE/matlib/clouds/sarta/

%% now that we have the map, we can make 365 rtp files, each with 40 latbins!!!!
for tt = 1 : iNumTimeStep
  fprintf(1,'timestep %3i of %3i \n',tt,iNumTimeStep);
  clear hall pall
  for ii = 1 : iMaxLatbin
    fopx = [dirOUT '/latbin' num2str(ii) '_16day_avg.op.rtp'];
    frpx = [dirOUT '/latbin' num2str(ii) '_16day_avg.rp.rtp'];
    [h,ha,p,pa] = rtpread(fopx);
    [hx,ha,px,pa] = rtpread(frpx);
    px.avg16_doy_since2002 = p.avg16_doy_since2002;
    px.robsqual = zeros(size(px.rcalc));
    [h,p] = subset_rtp_allcloudfields(hx,px,[],[],matr_closest_rtime_found(ii,tt));
    p.matr_closest_rtime_found = matr_closest_rtime_found(ii,tt);
    if ii == 1
      hall = h;
      pall = p;
    else
      [hall,pall] = cat_rtp(hall,pall,h,p);
    end
  end
  fout = [dirOUT '/timestep_' num2str(tt,'%03d') '_16day_avg.rp.rtp'];    
  rtpwrite(fout,hall,ha,pall,pa);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% now check things, can run this separately
check_anom_profiles40
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('now run kCARTA 365 times hahahahahahaha')
