addpath /home/sergio/MATLABCODE/COLORMAP

%% see ~/KCARTA/WORK/RUN_TARA/GENERIC_RADSnJACS_MANYPROFILES/set_rtp.m
%% in /home/sergio/KCARTA/WORK/RUN_TARA/GENERIC_RADSnJACS_MANYPROFILES can make the 25 jacs using 
%%    kleenslurm; sbatch -p high_mem --array=4-4608%128 sergio_matlab_jobB.sbatch 7

use_this_rtp_388 = '/asl/s1/sergio/MakeAvgProfs2002_2020_startSept2002/LatBin64/summary_latbin_64_lonbin_12.rtp'; %% 388 steps
use_this_rtp_5_5 = '/asl/s1/sergio/MakeAvgProfs2002_2020_startSept2002/16dayAvgLatBin64/all12monthavg_T_WV_grid_latbin_64_lonbin_12.rtp'; %% 25 T x WV grids

[h,ha,p_388,pa] = rtpread(use_this_rtp_388);
[h,ha,p_5_5,pa] = rtpread(use_this_rtp_5_5);
mmw = mmwater_rtp(h,p_5_5);

airslevels = load('/home/sergio/MATLABCODE/airslevels.dat');
pN = airslevels(1:100)-airslevels(2:101);
pD = log(airslevels(1:100)./airslevels(2:101));
airslayers = pN./pD;

jac_5_5x = '/home/sergio/KCARTA/WORK/RUN_TARA/GENERIC_RADSnJACS_MANYPROFILES/JUNK/AIRS_gridded_Oct2020_startSept2002_trendsonly/AllDemJacsAnomaly/';
jac_5_5x = [jac_5_5x 'T_WV_Grid/64/12/'];
for ii = 1 : 25
  junk = [jac_5_5x '/individual_prof_convolved_kcarta_airs_' num2str(ii) '_jac.mat'];
  junk = load(junk);
  jac_5_5(ii,:,:) = junk.rKc;
end
for ii = 1 : 25
  junk = [jac_5_5x '/individual_prof_convolved_kcarta_airs_' num2str(ii) '.mat'];
  junk = load(junk);
  rad_5_5(ii,:,:) = junk.rKc;
end

iT = input('enter timstep (-1 to end) : ');
while iT > 0
  jac_388 = '/home/sergio/KCARTA/WORK/RUN_TARA/GENERIC_RADSnJACS_MANYPROFILES/JUNK/AIRS_gridded_Oct2020_startSept2002_trendsonly/AllDemJacsAnomaly/';
  jac_388 = [jac_388 'Avg/64/12/individual_prof_convolved_kcarta_airs_' num2str(iT) '_jac.mat'];
  jac_388 = load(jac_388);

  figure(1); clf; semilogy(p_5_5.ptemp,p_5_5.plevs,'b',p_388.ptemp(:,iT),p_388.plevs(:,iT),'r'); set(gca,'ydir','reverse'); ylim([10 1000])
  figure(2); clf; loglog(p_5_5.gas_1,p_5_5.plevs,'b',p_388.gas_1(:,iT),p_388.plevs(:,iT),'r'); set(gca,'ydir','reverse'); ylim([10 1000])

  jacWVtrue = jac_388.rKc(:,(1:97)+0*97);
  jacO3true = jac_388.rKc(:,(1:97)+1*97);
  jacTztrue = jac_388.rKc(:,(1:97)+2*97);

  for ilay = 1 : 97
    wv = log10(p_388.gas_1(97-ilay+1,iT));
    tz = p_388.ptemp(97-ilay+1,iT);

    wvi = unique(log10(p_5_5.gas_1(97-ilay+1,:)));
    tzi = unique(p_5_5.ptemp(97-ilay+1,:));

    jaci = jac_5_5(:,:,0+ilay);
    jacWV(:,ilay) = interp3(double(wvi),double(tzi),1:2834,double(reshape(jaci,5,5,2834)),double(wv),double(tz),1:2834);

    jaci = jac_5_5(:,:,97+97+ilay);
    jacTz(:,ilay) = interp3(double(wvi),double(tzi),1:2834,double(reshape(jaci,5,5,2834)),double(wv),double(tz),1:2834);

    jacO3(:,ilay) = squeeze(jac_5_5(13,:,97+ilay));
  end

  figure(1); pcolor(h.vchan(1:2378),airslayers(4:100),jacWVtrue(1:2378,:)'); shading flat; set(gca,'ydir','reverse'); colorbar; title('WVtrue');
  figure(2); pcolor(h.vchan(1:2378),airslayers(4:100),jacO3true(1:2378,:)'); shading flat; set(gca,'ydir','reverse'); colorbar; title('O3true');
  figure(3); pcolor(h.vchan(1:2378),airslayers(4:100),jacTztrue(1:2378,:)'); shading flat; set(gca,'ydir','reverse'); colorbar; title('Tztrue');

  figure(4); pcolor(h.vchan(1:2378),airslayers(4:100),jacWV(1:2378,:)'); shading flat; set(gca,'ydir','reverse'); colorbar; title('WV');
  figure(5); pcolor(h.vchan(1:2378),airslayers(4:100),jacO3(1:2378,:)'); shading flat; set(gca,'ydir','reverse'); colorbar; title('O3');
  figure(6); pcolor(h.vchan(1:2378),airslayers(4:100),jacTz(1:2378,:)'); shading flat; set(gca,'ydir','reverse'); colorbar; title('Tz');

  figure(1); cx = caxis; figure(4); caxis(cx);
  figure(2); cx = caxis; figure(5); caxis(cx);
  figure(3); cx = caxis; figure(6); caxis(cx);

  figure(7); pcolor(h.vchan(1:2378),airslayers(4:100),jacWV(1:2378,:)'./jacWVtrue(1:2378,:)' - 1); shading flat; set(gca,'ydir','reverse'); colorbar; title('WV/WV0-1'); colormap(usa2); caxis([-1 +1])
  figure(8); pcolor(h.vchan(1:2378),airslayers(4:100),jacO3(1:2378,:)'./jacO3true(1:2378,:)' - 1); shading flat; set(gca,'ydir','reverse'); colorbar; title('O3/O30-1'); colormap(usa2); caxis([-1 +1])
  figure(9); pcolor(h.vchan(1:2378),airslayers(4:100),jacTz(1:2378,:)'./jacTztrue(1:2378,:)' - 1); shading flat; set(gca,'ydir','reverse'); colorbar; title('Tz/Tz0-1'); colormap(usa2); caxis([-1 +1])

  iT = input('enter timstep (-1 to end) : ');
end
