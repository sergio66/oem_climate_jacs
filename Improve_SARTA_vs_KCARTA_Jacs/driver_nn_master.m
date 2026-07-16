if ~exist('for_nn_stemp.mat')
  disp('reading in 660 files  + = 100, . = 10')
  for ii = 1 : 660
    if mod(ii,100) == 0
      fprintf(1,'+')
    elseif mod(ii,10) == 0
      fprintf(1,'.')
    end
    fin = ['DATA/v1/COMBINED/sarta_kcarta_' num2str(ii) '.mat'];
    x = load(fin);
    kcarta(ii,:) = x.final.kc.ST;
    sarta(ii,:)  = x.final.sa.ST;
    nlay(ii)     = x.final.kc.nlay;
  end
  f = x.final.kc.f;
  comment = 'see nn_stemp.m';
  save for_nn_stemp.mat f kcarta sarta nlay comment
else
  load for_nn_stemp.mat
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('for_nn_pstruct.mat')
  addpath_convolve
  [h,ha,p,pa] = rtpread('combine_83_49_370to430ppmv_v1.op.rtp');

  mmw = mmwater_rtp(h,p);
  du  = dobson_rtp(h,p);
  pnew.mmw = mmw;
  pnew.o3du = du;
  
  [ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75,ppmvSURF] = layers2ppmv(h,p,1:length(p.stemp),2);
  pnew.co2ppmvLAY = ppmvLAY;
  pnew.co2ppmvAVG = ppmvAVG;  
  pnew.co2ppmv500 = ppmv500;
  pnew.co2ppmvGND = ppmvSURF;      

  [ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75,ppmvSURF] = layers2ppmv(h,p,1:length(p.stemp),6);
  pnew.ch4ppmvLAY = ppmvLAY;
  pnew.ch4ppmvAVG = ppmvAVG;  
  pnew.ch4ppmv500 = ppmv500;
  pnew.ch4ppmvGND = ppmvSURF;      

  pnew.plevs = p.plevs;
  pnew.stemp = p.stemp;
  pnew.ptemp = p.ptemp;
  pnew.gas_1 = p.gas_1;
  pnew.gas_2 = p.gas_2;
  pnew.gas_3 = p.gas_3;  
  pnew.gas_4 = p.gas_4;
  pnew.gas_5 = p.gas_5;
  pnew.gas_6 = p.gas_6;
  pnew.gas_9 = p.gas_9;
  pnew.gas_12= p.gas_12;
  
  pnew.scanang = p.scanang; 
  pnew.satzen = p.satzen;
  pnew.solzen = p.solzen;  
  pnew.landfrac = p.landfrac;
  pnew.spres    = p.spres;
  pnew.nlevs    = p.nlevs;  
  pnew.nemis = p.nemis;
  pnew.efreq = p.efreq;    
  pnew.emis  = p.emis;
  pnew.rho   = p.rho;

  pnew_nan = pnew;
  for ii = 1 : 660
    junk = nlay(ii);
    pnew_nan.ptemp(junk+1:101,ii) = nan;
    pnew_nan.gas_1(junk+1:101,ii) = nan;
    pnew_nan.gas_2(junk+1:101,ii) = nan;
    pnew_nan.gas_3(junk+1:101,ii) = nan;
    pnew_nan.gas_4(junk+1:101,ii) = nan;
    pnew_nan.gas_5(junk+1:101,ii) = nan;
    pnew_nan.gas_6(junk+1:101,ii) = nan;
    pnew_nan.gas_9(junk+1:101,ii) = nan;
    pnew_nan.gas_12(junk+1:101,ii)= nan;        
  end
  
  plot(double(p.nlevs)-double(nlay),'x')
  save for_nn_pstruct.mat pnew pnew_nan comment
else
  load for_nn_pstruct.mat
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% now chose channel, and what you are fitting for ..... eg
% driver_nn_stemp
% driver_nn_wv
% driver_nn_tz
% driver_nn_o3

