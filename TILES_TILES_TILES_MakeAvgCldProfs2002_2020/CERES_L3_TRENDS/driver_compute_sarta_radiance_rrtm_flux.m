addpath /asl/matlib/h4tools
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS
addpath /home/sergio/IR_NIR_VIS_UV_RTcodes
addpath /home/sergio/IR_NIR_VIS_UV_RTcodes/RobinHoganECMWF/ECRAD_ECMWF_version_of_flux/ecRad/create_ecrad_inputSergio

%% /umbc/xfs2/strow/asl/s1/sergio/home/MATLABCODE/oem_pkg_run/AIRS_gridded_STM_May2021_trendsonlyCLR/read_fileMean17years.m

fin{1} = '/home/sergio/KCARTA/WORK/RUN_TARA/GENERIC_RADSnJACS_MANYPROFILES/RTP/summary_17years_all_lat_all_lon_2002_2019_palts_startSept2002_CLEAR.rtp';
fin{2} = '/home/sergio/KCARTA/WORK/RUN_TARA/GENERIC_RADSnJACS_MANYPROFILES/RTP/summary_20years_all_lat_all_lon_2002_2022_monthlyERA5.rp.rtp';

sarta   = '/home/chepplew/gitLib/sarta/bin/airs_l1c_2834_cloudy_may19_prod_v3';
angles = [20 22 24 26 28 30];

if ~exist('saved_sarta_calcs.mat')
  for file = 1 : length(fin)
    [h,ha,p,pa] = rtpread(fin{file});
    for aa = 1 : length(angles)
      fprintf(1,'sarta : %s     angle = %2i \n',fin{file},angles(aa));
      pjunk = p;
      pjunk.zobs   = ones(size(pjunk.satzen)) * 705000;
      pjunk.satzen = ones(size(pjunk.satzen)) * angles(aa);
      pjunk.scanang = saconv(pjunk.satzen,pjunk.zobs);
      rtpwrite('junk.op.rtp',h,ha,pjunk,pa);
      sartaer = ['!time ' sarta ' fin=junk.op.rtp fout=junk.rp.rtp >& ugh'];
      eval(sartaer);
      [~,~,pjunk2,~] = rtpread('junk.rp.rtp');
      for ii = 1 : 4608
        flux(file,aa,ii) = trapz(h.vchan,pjunk2.rcalc(:,ii))/1000;
      end
    end
  end

  mmw = mmwater_rtp(h,pjunk2);
  stemp = pjunk2.stemp;
  comment = 'see driver_compute_sarta_radiance_rrtm_flux.m';
  save saved_sarta_calcs.mat fin angles sarta flux mmw stemp

  plot(mmw,nanmean(squeeze(nanmean(flux,1)),1),'.')
  plot(stemp,nanmean(squeeze(nanmean(flux,1)),1),'.')

  plot(mmw,nanmean(squeeze(nanstd(flux,1)),1),'.')
  plot(stemp,nanmean(squeeze(nanstd(flux,1)),1),'.')

else
  disp('have already done sarta calcs')
  sartaflux = load('saved_sarta_calcs.mat');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('saved_ecRad_calcs.mat')
  for file = 1 : length(fin)
    [h,ha,p,pa] = rtpread(fin{file});
    for aa = 1 : 1
      fprintf(1,'ecRad : %s     angle = %2i \n',fin{file},angles(aa));
      pjunk = p;
      pjunk.zobs   = ones(size(pjunk.satzen)) * 705000;
      pjunk.satzen = ones(size(pjunk.satzen)) * angles(aa);
      pjunk.scanang = saconv(pjunk.satzen,pjunk.zobs);
      rtpwrite('junk.op.rtp',h,ha,pjunk,pa);

      cd /home/sergio/IR_NIR_VIS_UV_RTcodes/RobinHoganECMWF/ECRAD_ECMWF_version_of_flux/ecRad/create_ecrad_inputSergio
        pwd
        junk = superdriver_run_ecRad_rtp_loop_over_profiles(h,pjunk,-1,1);
        ecRad_results.flux(file,:) = junk.clr;
        ecRad_results.bands(file,:,:) = junk.bands.clr;
      cd /home/sergio/MATLABCODE/oem_pkg_run_sergio_AuxJacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/CERES_L3_TRENDS/

    end
  end
  mmw = mmwater_rtp(h,pjunk);
  stemp = pjunk.stemp;
  comment = 'see driver_compute_sarta_radiance_rrtm_flux.m';
  save saved_ecRad_calcs.mat fin ecRad_results mmw stemp
else
  disp('have already done ecRad calcs')
  ecRadflux = load('saved_ecRad_calcs.mat');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ecRad1 = ecRadflux.ecRad_results.flux(1,:);
ecRad2 = ecRadflux.ecRad_results.flux(2,:);
plot(sartaflux.stemp,ecRad1 - ecRad2,'.')
xlabel('Stemp'); ylabel('\delta Flux W/m2'); title('17 year - 20 year avg profiles')

hist(ecRadflux.ecRad_results.flux(1,:)-ecRadflux.ecRad_results.flux(2,:),100)

%%%%%%%%%%%%%%%%%%%%%%%%%

sarta1 = squeeze(sartaflux.flux(1,:,:));
sarta2 = squeeze(sartaflux.flux(2,:,:));
plot(sartaflux.stemp,nanstd(sarta1,1),'.',sartaflux.stemp,nanstd(sarta2,1),'+')
  xlabel('Stemp'); ylabel('Std Dev over angles');

factor = 2*pi/2*2;   %% 2pi = azimuth integral    1/2 = zenith (u du) integral      2 = go from 0 to 600 cm-1
plot(ecRad1,factor*nanmean(sarta1,1),'.',ecRad2,factor*nanmean(sarta2,1),'.',ecRad1,ecRad1,'k')
  xlabel('ecRad'); ylabel('sarta')
P1 = polyfit(nanmean(sarta1,1),ecRad1,1);
P2 = polyfit(nanmean(sarta2,1),ecRad2,1);

Q1 = polyfit(nanmean(sarta1,1),ecRad1,2);
Q2 = polyfit(nanmean(sarta2,1),ecRad2,2);

%% (P1+P2)/2 = 3.578808    88.733253
%%  sarta2ecRad conversion : ecrad = 3.5788 sarta + 88.73
%% can estimate these two : 
%%   first element : integral is 2*pi/2 ~ 3.14        (2*pi for azimuth, and 1/2 for mu du) 
%%   second element : we need 0 to 600 cm-1; the radiance at 600 is typically 120 mW/m2/sr/cm1-1
%%     so that triangle is 1/2 base height = (1/2) * (600) *  (110/1000) * 2 * pi /2 = 103 W/m2
printarray(P1)
printarray(P2)
printarray((P1+P2)/2)

%% therefore       ecRad = 3.5788 * sarta + 88.733
%% therefore       ecRad = 3.5788 * sarta + 88.733
%% therefore       ecRad = 3.5788 * sarta + 88.733

factor = 3.5788;   %% 2pi = azimuth integral    1/2 = zenith (u du) integral      2 = go from 0 to 600 cm-1
plot(ecRad1,factor*nanmean(sarta1,1)+88.34,'.',ecRad2,factor*nanmean(sarta2,1)+88.34,'.',ecRad2,ecRad2,'k')
plot(ecRad1,factor*nanmean(sarta1,1)+88.34,'.',ecRad2,factor*nanmean(sarta2,1)+88.34,'.',100:350,100:350,'k.-')
  xlabel('ecRad W/m2'); ylabel('sarta rad --> flux  W/m2')
title('ecRad = 3.5788 sarta + 88.34')
hl = legend('17 year ERA5 avg profles','20 year ERA5 avg profiles','y=x','location','best');
set(gca,'fontsize',10);
