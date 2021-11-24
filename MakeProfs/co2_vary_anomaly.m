addpath /asl/matlib/h4tools
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS

for ii = 1 : 365

  fname = ['LATS40_avg_made_Mar29_2019_Clr/Desc/16DayAvg/timestep_'    num2str(ii,'%03d') '_16day_avg.rp.rtp'];
  fname = ['LATS40_avg_made_Mar29_2019_Clr/Desc/16DayAvg/timestepCFC_' num2str(ii,'%03d') '_16day_avg.rp.rtp'];

  [h,ha,p,pa] = rtpread(fname);
  [ppmvLAY,ppmvAVG,ppmvMAX,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv_dryair(h,p,1:length(p.stemp),2);
  stemp(ii) = p.stemp(20);
  gas2(ii) = ppmv500(20);
  fprintf(1,'.');
end
fprintf(1,'\n');
