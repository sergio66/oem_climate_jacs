fop  = '/home/sergio/git/matlabcode/REGR_PROFILES_SARTA/REGR49_PROFILES_for_kCARTA_breakouts_for_SARTA/regr49_1100_400ppm_unitemiss.op.rtp';
fxop = 'regr49_1100_400ppm_unitemiss_oneprofile.op.rtp';
fxrp = 'regr49_1100_400ppm_unitemiss_oneprofile.rp.rtp';

load /home/sergio/git/matlabcode/h2645structure.mat

h2645.nchan = h.nchan;
h2645.ichan = h.ichan;
h2645.vchan = h.vchan;

[h,ha,p,pa] = rtpread(fop);
[h,p] = subset_rtp(h,p,[],[],49);

p.rcalc = zeros(2645,1);
h.ichan = h2645.ichan;
h.vchan = h2645.vchan;
h.nchan = h2645.nchan;
rtpwrite(fxop,h,ha,p,pa);

disp('should really run this through /home/sergio/git/sarta_scatter_rtp_klayers_sergio/JACvers/MATLABCODE/clustmake_sartajacs.m to get the jacs')

sarta = '/home/sergio/git/sarta_scatter_rtp_klayers_sergio/JACvers/bin/jac_airs_l1c_2834_cloudy_apr26_H2024';
sartaer = ['!time ' sarta ' fin=' fxop ' fout=' fxrp];
eval(sartaer);
[hf,~,pf,~] = rtpread(fxrp);

comment = 'see /home/sergio/git/oem_climate_jacs/Python_DNN_RTA/V3_CNN_DNN/do_base_USSTD.m'; 
save us_std_rad_sarta.mat h ha p pa hf pf comment
