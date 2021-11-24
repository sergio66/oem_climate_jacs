addpath /asl/matlib/h4tools
addpath /home/sergio/MATLABCODE/PLOTTER

latbins = equal_area_spherical_bands(21);
latbinsx = 0.5*(latbins(1:end-1)+latbins(2:end));

tropics = find(abs(latbinsx) <= 30)
latbinsx(tropics)

iAIRSorCRIS = input('Enter (+1) AIRS or (-1) CRIS (default -1) : ');
if length(iAIRSorCRIS) == 0
  iAIRSorCRIS = -1;
end

pav.stemp = [];
pav.ptemp = [];
for ii = tropics(1) : tropics(end)-1
  if iAIRSorCRIS < 0
    str = 'CRIS NSR';
    [h,ha,p,pa] = rtpread(['CLO_LAT40_avg_made_Dec2019_Clr/Desc/16DayAvgNoS/latbin' num2str(ii) '_16day_avg.op.rtp']);
  else
    str = 'AIRS';
    [h,ha,p,pa] = rtpread(['LATS40_avg_made_Aug20_2019_Clr/Desc/16DayAvgNoS/latbin' num2str(ii) '_16day_avg.op.rtp']);
  end
  strer = ['p' num2str(ii) ' = p;'];
  pav.stemp = [pav.stemp; p.stemp];
  pav.ptemp(ii-tropics(1)+1,:,:) = p.ptemp;
  eval(strer);
end

figure(1); pcolor(pav.stemp); shading flat; colormap jet; colorbar

addpath /home/sergio/MATLABCODE/PLOTTER/PCOLOR3/pcolor3/
figure(2); pcolor3(pav.ptemp-nanmean(pav.ptemp,1))

addpath /home/sergio/MATLABCODE/COLORMAP
wah = pav.ptemp-nanmean(pav.ptemp,1); whos wah
for ii = 50 : 97
  bah = squeeze(wah(:,ii,:));
  figure(2); pcolor(bah); shading flat; colormap jet; colorbar; title(num2str(ii));
  caxis([-5 +5]); colormap(usa2);

  figure(3); pcolor(squeeze(pav.ptemp(:,ii,:))); shading flat; colormap jet; colorbar; title(num2str(ii));
  colormap(jet);
  pause(0.1)
end

figure(1); title(['STEMP ' str]);
figure(2); title(['PTEMP97 anom ' str]);
figure(3); title(['PTEMP97      ' str]);
