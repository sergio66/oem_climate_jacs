addpath /home/sergio/MATLABCODE/TIME
addpath /asl/matlib/h4tools

[yy,mm,dd,hh] = tai2utcSergio(a.p2.rtime);
if min(mm) == 8 & mean(yy) == 2012
  %% Aug 27, 2012- Sep 11, 2012
  pclrfile = 'pclear_Aug2012.mat';
elseif min(mm) == 5 & mean(yy) == 2012
  pclrfile = 'pclear_Jun2012.mat';
elseif min(mm) == 2 & mean(yy) == 2012
  pclrfile = 'pclear_Feb2012.mat';
elseif min(mm) == 12 & mean(yy) == 2012
  pclrfile = 'pclear_Dec2012.mat';
end

if ~exist(pclrfile)
  days_so_far = convert2daysinyear(a.p2.rtime);
  
  for ii = min(days_so_far) : max(days_so_far)
    frtp = ['/asl/rtp/airs/airs_l1c_v672/clear/2012/era_airicrad_day' num2str(ii,'%03d') '_clear.rtp'];
    [h,ha,p,pa] = rtpread(frtp);
    boo = find(p.solzen < 90);
    [h,p] = subset_rtp(h,p,[],[],boo);
    if ii == min(days_so_far)
      pclear.rlat  = p.rlat;
      pclear.rlon  = p.rlon;
      pclear.rtime = p.rtime;
      pclear.r1231 = p.robs1(1520,:);
    else
      pclear.rlat  = [pclear.rlat  p.rlat];
      pclear.rlon  = [pclear.rlon  p.rlon];
      pclear.rtime = [pclear.rtime p.rtime];
      pclear.r1231 = [pclear.r1231 p.robs1(1520,:)];
    end
  end
  commentX = 'see do_the_plots_ecmwf_or_era_16days_tile_onelatbin.m';
  saver = ['save ' pclrfile '  pclear commentX'];
  eval(saver)
else
  loader = ['load ' pclrfile];
  eval(loader)
end
figure(5); clf; simplemap(pclear.rlat,pclear.rlon,rad2bt(1231,pclear.r1231))
