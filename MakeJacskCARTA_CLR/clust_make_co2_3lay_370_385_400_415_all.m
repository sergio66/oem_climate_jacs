addpath /asl/matlib/h4tools
addpath /asl/matlib/aslutil
addpath /asl/matlib/rtptools
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS
addpath /home/sergio/MATLABCODE/

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
%JOB = 20
fin = 'latbin1_40.clr.rp.rtp';

iaCO2 = [370 385 400 415];
iaCO2 = [370 : 5 : 415];
kcarta = '/home/sergio/KCARTA/BIN/kcarta.x_f90_121_400ppmv_H16';

for ll = JOB
  [h,ha,pall,pa] = rtpread(fin);
  [h,p21] = subset_rtp(h,pall,[],[],ll);
  [ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p21,1,2);
  %semilogy(ppmvLAY,pavgLAY); set(gca,'ydir','reverse');
  meanCO2 = mean(ppmvLAY(10:30));

  for ii = 1 : length(iaCO2)
    if ii == 1
      pnew = p21;
      pnew.gas_2 = pnew.gas_2 * iaCO2(ii)/meanCO2;
    else
      px = p21;
      px.gas_2 = px.gas_2 * iaCO2(ii)/meanCO2;
      [h,pnew] = cat_rtp(h,pnew,h,px);
    end
  end
  [appmvLAY,appmvAVG,appmvMAX,apavgLAY,atavgLAY,appmv500,appmv75] = layers2ppmv_dryair(h,pnew,1:length(iaCO2),2);
  %semilogy(appmvLAY,apavgLAY); set(gca,'ydir','reverse');
  %plot(iaCO2,appmvLAY(50,:),'o-')
    
  fop = ['CO2_370_385_400_415/make_co2_370_385_400_415_latbin_' num2str(ll) '.op.rtp'];
  rtpwrite(fop,h,ha,pnew,pa);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for ii = 1 : length(iaCO2)
    fprintf(1,'latbin %2i ijac %2i \n',ll,ii)
    sedder = ['!sed -e "s/XYZXYZ/' num2str(ll) '/g" -e "s/MMM/' num2str(ii) '/g" templatejacCO2_370_385_400_415_alllay.nml > CO2_370_385_400_415//junk' num2str(ll) '.nml' ];
    eval(sedder)
    kcrad = ['CO2_370_385_400_415/junkCO2_latbin_' num2str(ll) '_3layco2pert_' num2str(ii) '.dat'];
    kcjac = ['CO2_370_385_400_415/junkCO2_latbin_' num2str(ll) '_3layco2pert_' num2str(ii) '.jac'];
    kcartaer = ['!' kcarta ' CO2_370_385_400_415/junk' num2str(ll) '.nml ' kcrad ' ' kcjac];
    eval(kcartaer)
  end
end

monitor_memory_whos

return
