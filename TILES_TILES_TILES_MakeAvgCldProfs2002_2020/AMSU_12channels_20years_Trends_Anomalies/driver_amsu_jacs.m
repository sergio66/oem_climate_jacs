function jac = driver_amsu_jacs(h,p,iRTP,fop,frp)

if length(p.stemp > 1)
  [headyy0,profxx0] = subset_rtp(h,p,h.glist,1:h.nchan,iRTP);
else
  headyy0 = h;
  profxx0 = p;
end

headyy = headyy0;
profxx = profxx0;

deltaT = 0.1;
deltaQ = 0.01;

ha = [];
pa = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numtimes = 101;  
numtimes = (profxx0.nlevs-1) + 1;
fprintf(1,'G1 : replicating %3i profiles for p.nlevs = %3i \n',numtimes,profxx0.nlevs);
[headyy,profyy] = replicate_rtp_headprof(headyy0,profxx0,1,numtimes); 
%gas = input('Enter which gas to perturb (1,2,3,4,5,6,9,12 or -1 for T or -10 for ST) : ');
gas = 1;
if gas > 0
  rMult = 1 + deltaQ;
  if gas == 9
    rMult = 10.0;
  end
  if gas == 12
    rMult = 2.0;
  end
  fprintf(1,'gas multiplier = %8.6f \n',rMult);
  for ii = 1 : (profxx0.nlevs-1)
    str = ['profyy.gas_' num2str(gas) '(' num2str(ii) ',' num2str(ii) ') = profyy.gas_' num2str(gas) '(' num2str(ii) ',' num2str(ii) ')*' num2str(rMult) ';'];
    eval(str);
  end 

  headyy.nchan = 13;   %%% 13 AMSU chans 
  rtpwrite(fop,headyy,ha,profyy,pa);

  sarta = '/home/sergio/SARTA_CLOUDY_RTP_KLAYERS_NLEVELS/SARTA_MW/mrta_rtp201/BinV201/mwsarta_amsua';
  amsuer = ['!time ' sarta ' fin=' fop ' fout=' frp ' >& ugh'];
  eval(amsuer);

  [hh,hha,pp,ppa] = rtpread(frp);
  tout = pp.rcalc;
  tout0 = tout(:,profxx.nlevs);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numtimes = 101 + 1;  
numtimes = (profxx0.nlevs-1) + 1 + 1;
fprintf(1,'T + ST : replicating %3i profiles for p.nlevs = %3i \n',numtimes,profxx0.nlevs);
[headyy,profyy] = replicate_rtp_headprof(headyy0,profxx0,1,numtimes); 
gas = -1;
if gas == -1
  for ii = 1 : (profxx0.nlevs-1)
    str = ['profyy.ptemp(' num2str(ii) ',' num2str(ii) ') = profyy.ptemp(' num2str(ii) ') + deltaT;'];
    eval(str);
  end 
  ii = (profxx.nlevs-1) + 1;
  str = ['profyy.stemp(ii) = profyy.stemp(ii)  + deltaT;'];
  eval(str);

  headyy.nchan = 13;   %%% 13 AMSU chans 
  rtpwrite(fop,headyy,ha,profyy,pa);

  sarta = '/home/sergio/SARTA_CLOUDY_RTP_KLAYERS_NLEVELS/SARTA_MW/mrta_rtp201/BinV201/mwsarta_amsua';
  amsuer = ['!time ' sarta ' fin=' fop ' fout=' frp ' >& ugh'];
  eval(amsuer);

  [hh,hha,pp,ppa] = rtpread(frp);
  toutT = pp.rcalc;
  tout0T = toutT(:,profxx.nlevs+1);
  %% sum(tout0T-tout0)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% jac.wv = tout(:,1 : (profxx.nlevs-1))  - tout0*ones(1,profxx.nlevs-1);
%% jac.WV = jac.wv/log(1+deltaQ);

jac.WV = tout(:,1 : (profxx.nlevs-1))  - tout0*ones(1,profxx.nlevs-1);
  jac.WV = jac.WV/log(1+deltaQ);

jac.T  = toutT(:,1 : (profxx.nlevs-1)) - tout0T*ones(1,profxx.nlevs-1);
  jac.T  = jac.T/deltaT;

jac.ST = toutT(:,profxx.nlevs) - tout0T;
  jac.ST = jac.ST/deltaT;

jac.BT = tout0;
jac.f  = hh.vchan;

jac.nlevs = profxx0.nlevs;
jac.plevs = profxx0.plevs(1:jac.nlevs);
jac.wvnm  = hh.vchan;

rmer = ['!/bin/rm ' fop ' ' frp];
eval(rmer);
