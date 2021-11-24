addpath /asl/matlib/h4tools
addpath /asl/matlib/aslutil
addpath /asl/matlib/rtptools
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS
addpath /home/sergio/MATLABCODE/

JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
%JOB = 21
fin = 'latbin1_40.clr.rp.rtp';

iaCH4 = [1700 : 25 : 2000]/1000;
kcarta = '/home/sergio/KCARTA/BIN/kcarta.x_f90_121_400ppmv_H16';

ch4_esrl = load('ch4_esrl.txt');
raCH4times = interp1(ch4_esrl(:,2)/1000,ch4_esrl(:,1),iaCH4,[],'extrap');
plot(ch4_esrl(:,1),ch4_esrl(:,2)/1000,'.-',raCH4times,iaCH4,'o-'); grid

for ll = JOB
  [h,ha,pall,pa] = rtpread(fin);
  [h,p21] = subset_rtp(h,pall,[],[],ll);
  [ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p21,1,6);
  %semilogy(ppmvLAY,pavgLAY); set(gca,'ydir','reverse');
  meanCH4 = mean(ppmvLAY(10:30));

  for ii = 1 : length(iaCH4)
    if ii == 1
      pnew = p21;
      pnew.gas_6 = pnew.gas_6 * iaCH4(ii)/meanCH4;
    else
      px = p21;
      px.gas_6 = px.gas_6 * iaCH4(ii)/meanCH4;
      [h,pnew] = cat_rtp(h,pnew,h,px);
    end
  end
  [appmvLAY,appmvAVG,appmvMAX,apavgLAY,atavgLAY,appmv500,appmv75] = layers2ppmv_dryair(h,pnew,1:length(iaCH4),6);
  %semilogy(appmvLAY,apavgLAY); set(gca,'ydir','reverse');
  %plot(iaCH4,appmvLAY(50,:),'o-')
    
  fop = ['CH4_1700_2000/make_ch4_1700_2000_latbin_' num2str(ll) '.op.rtp'];
  rtpwrite(fop,h,ha,pnew,pa);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for ii = 1 : length(iaCH4)
    fprintf(1,'latbin %2i ijac %2i \n',ll,ii)
    sedder = ['!sed -e "s/XYZXYZ/' num2str(ll) '/g" -e "s/MMM/' num2str(ii) '/g" templatejacCH4_1700_2000_col.nml > CH4_1700_2000//junk' num2str(ll) '.nml' ];
    eval(sedder)
    kcrad = ['CH4_1700_2000/junkCH4_latbin_' num2str(ll) '_ch4pert_' num2str(ii) '.dat'];
    kcjac = ['CH4_1700_2000/junkCH4_latbin_' num2str(ll) '_ch4pert_' num2str(ii) '.jac'];
    kcartaer = ['!' kcarta ' CH4_1700_2000/junk' num2str(ll) '.nml ' kcrad ' ' kcjac];
    eval(kcartaer)
  end
end

monitor_memory_whos;

return
