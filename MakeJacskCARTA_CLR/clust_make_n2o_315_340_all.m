addpath /asl/matlib/h4tools
addpath /asl/matlib/aslutil
addpath /asl/matlib/rtptools
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS
addpath /home/sergio/MATLABCODE/

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
%JOB = 21
fin = 'latbin1_40.clr.rp.rtp';

iaN2O = [315 : 5 : 340]; %% ppb
kcarta = '/home/sergio/KCARTA/BIN/kcarta.x_f90_121_400ppmv_H16';

n2o_esrl = load('insitu_global_N2O.txt');
ix = 25 : length(n2o_esrl)-12;
raN2Otimes = interp1(n2o_esrl(ix,7) + 0.0001*randn(length(ix),1),n2o_esrl(ix,1) + (n2o_esrl(ix,2)-1)/12,iaN2O,[],'extrap');
plot(n2o_esrl(ix,1) + (n2o_esrl(ix,2)-1)/12,n2o_esrl(ix,7),'.-',raN2Otimes,iaN2O,'o-'); grid

for ll = JOB
  [h,ha,pall,pa] = rtpread(fin);
  [h,p21] = subset_rtp(h,pall,[],[],ll);
  [ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p21,1,4);
  %semilogy(ppmvLAY,pavgLAY); set(gca,'ydir','reverse');
  meanN2O = mean(ppmvLAY(10:30))*1000;

  for ii = 1 : length(iaN2O)
    if ii == 1
      pnew = p21;
      pnew.gas_4 = pnew.gas_4 * iaN2O(ii)/meanN2O;
    else
      px = p21;
      px.gas_4 = px.gas_4 * iaN2O(ii)/meanN2O;
      [h,pnew] = cat_rtp(h,pnew,h,px);
    end
  end
  [appmvLAY,appmvAVG,appmvMAX,apavgLAY,atavgLAY,appmv500,appmv75] = layers2ppmv_dryair(h,pnew,1:length(iaN2O),4);
  %semilogy(appmvLAY,apavgLAY); set(gca,'ydir','reverse');
  %plot(iaN2O,appmvLAY(50,:),'o-')
    
  fop = ['N2O_315_340/make_n2o_315_340_latbin_' num2str(ll) '.op.rtp'];
  rtpwrite(fop,h,ha,pnew,pa);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for ii = 1 : length(iaN2O)
    fprintf(1,'latbin %2i ijac %2i \n',ll,ii)
    sedder = ['!sed -e "s/XYZXYZ/' num2str(ll) '/g" -e "s/MMM/' num2str(ii) '/g" templatejacN2O_315_340_col.nml > N2O_315_340//junk' num2str(ll) '.nml' ];
    eval(sedder)
    kcrad = ['N2O_315_340/junkN2O_latbin_' num2str(ll) '_n2opert_' num2str(ii) '.dat'];
    kcjac = ['N2O_315_340/junkN2O_latbin_' num2str(ll) '_n2opert_' num2str(ii) '.jac'];
    kcartaer = ['!' kcarta ' N2O_315_340/junk' num2str(ll) '.nml ' kcrad ' ' kcjac];
    eval(kcartaer)
  end
end

monitor_memory_whos;

return
