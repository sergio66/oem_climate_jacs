if ~exist('MWchannels15.op.rtp')
  cper = ['!cp /home/sergio/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/summary_17years_all_lat_all_lon_2002_2019_palts_startSept2002_PERTv1.rtp .'];
  
  [h,ha,p,pa] = rtpread('summary_17years_all_lat_all_lon_2002_2019_palts_startSept2002_PERTv1.rtp');
  h.nchan = 13;
  h.ichan = (1:13)';
  h = rmfield(h,'vchan');
  p.robs1 = zeros(13,4608);
  p.rcalc = zeros(13,4608);
  p = rmfield(p,'sarta_rclearcalc');
  p = rmfield(p,'nemis');
  p = rmfield(p,'emis');
  p = rmfield(p,'rho');
  
  rtpwrite('MWchannels15.op.rtp',h,ha,p,pa);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sarta = '/home/sergio/SARTA_CLOUDY_RTP_KLAYERS_NLEVELS/SARTA_MW/mrta_rtp201/BinV201/mwsarta_amsua'
sartaer = ['!time ' sarta ' fin=MWchannels15.op.rtp fout=MWchannels15.rp.rtp >& ugh'];
eval(sartaer);

[h2,ha,p2,pa] = rtpread('MWchannels15.rp.rtp');

figure(1); clf
plotyy(h2.vchan,nanmean(p2.rcalc,2),h2.vchan,nanstd(p2.rcalc,[],2)); legend('bias','std','location','best')
xlabel('Microwave Freq [GHz]'); ylabel('BT [K]')

for ii = 1 : 13
  figure(1); clf; scatter_coast(p2.rlon,p2.rlat,50,p2.rcalc(ii,:))
    title(['AMSU Ch ' num2str(ii,'%02d')])
  figure(2); clf; plot(p2.rlat,p2.rcalc(ii,:))
    title(['AMSU Ch ' num2str(ii,'%02d')])
  pause(1)
end

hAMSU = h2;
save hAMSU.mat hAMSU

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath /home/sergio/MATLABCODE_Git/AIRS_IASI_AMSU_JACS_gas_T/
make_amsu_jacs
