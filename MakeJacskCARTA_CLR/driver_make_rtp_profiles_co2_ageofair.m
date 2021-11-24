addpath /asl/matlib/h4tools
addpath /home/sergio/MATLABCODE/CONVERT_GAS_UNITS
addpath /home/sergio/MATLABCODE/COLORMAP
addpath /home/sergio/MATLABCODE/PLOTMISC
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/
addpath /home/sergio/MATLABCODE/TIME

load co2_age_of_air_profiles.mat

xlats = [-90  lats +90];                         %% extend lats to poles
x1alldatanew = zeros(6,length(hgts),length(xlats));
x1alldatanew(1:6,1:6,2:8) = alldatanew;
x1alldatanew(:,:,1) = alldatanew(:,:,1);
x1alldatanew(:,:,9) = alldatanew(:,:,7);

xhgts = [hgts 30 35 40 45 50 55 60 65 70 75 80]; %% extend heghts to 80 km
xalldatanew = zeros(6,length(xhgts),length(xlats));
xalldatanew(1:6,1:6,1:9) = x1alldatanew;
for hh = 7 : length(xhgts)
  xalldatanew(:,hh,:) = x1alldatanew(:,6,:);
end
clear x1alldatanew
xpres = h2p(xhgts*1000);

[Xlat,Xpres] = meshgrid(xlats,xpres);
    
iStart = 1; iEnd = 365;
iStart = 1; iEnd = 100;

for ii = iStart : iEnd
  fin  = ['AnomSym/timestep_' num2str(ii,'%03d') '_16day_avg.rp.rtp'];
  fout = ['AnomSym/timestep_' num2str(ii,'%03d') '_16day_avg_co2ageofair.rp.rtp'];
  if exist(fin) & ~exist(fout)
    [h,ha,p,pa] = rtpread(fin);
    [ppmvLAY0,ppmvAVG0,ppmvMAX0,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv(h,p,1:length(p.stemp),2);

    [yy,mm,dd] = tai2utcSergio(p.rtime(1));
    co2y = 370 + (yy-2002)*2.2;
    fprintf(1,'%3i of 365 yy/mm/dd = %4i/%2i/%2i \n',ii,yy,mm,dd)

    figure(1); semilogy(ppmvLAY0,pavgLAY); set(gca,'ydir','reverse')
    figure(2); pcolor(p.rlat,p2h(pavgLAY)/1000,ppmvLAY0 - co2y); shading interp; colorbar

    xyalldatanew = xalldatanew - (2010-yy)*2.2;  %% data matrices are for 2002 so adjust
    mmx = (mm-1) + dd/30;
    for ll = 1 : length(xlats)
      for hh = 1 : length(xpres)
        xjunk(hh,ll) = interp1(iaDates,squeeze(xyalldatanew(:,hh,ll)),mmx,[],'extrap');
      end
    end

    figure(3)
    semilogy(xjunk,xpres); ; set(gca,'ydir','reverse'); title('data to use')
    figure(4)
    pcolor(xlats,xhgts,xjunk - co2y); caxis([-7 +7]); colormap(usa2); colorbar; shading interp; 
    set(gca,'ydir','normal'); title('data to use')

    playsN = p.plevs(1:100,:)-p.plevs(2:101,:);
    playsD = log(p.plevs(1:100,:)./p.plevs(2:101,:));
    plays = zeros(size(p.plevs));
    plays(1:100,:) = playsN./playsD;

    newmr = interp2(Xlat,Xpres,xjunk,ones(101,1)*double(p.rlat),plays,'linear',0.0);
    if mean(newmr(1,:)) < 300
      newmr(1,:) = newmr(2,:);
    end

    figure(5)
    pcolor(p.rlat,p2h(mean(plays'))/1000,newmr - co2y); 
    caxis([-7 +7]); colormap(usa2); colorbar; shading interp; 
    set(gca,'ydir','normal'); title('This is what WE WANT')

    px = p;
    px.gas_2(1:97,:) = px.gas_2(1:97,:) .* newmr(1:97,:)./ppmvLAY0;

    [ppmvLAYF,ppmvAVGF,ppmvMAXF,pavgLAY,tavgLAY,ppmv500,ppmv75] = layers2ppmv(h,px,1:length(p.stemp),2);
    figure(6); pcolor(p.rlat,p2h(pavgLAY)/1000,ppmvLAYF - co2y); shading interp; colorbar; title('FINAL MR')
    caxis([-7 +7]); colormap(usa2);

    rtpwrite(fout,h,ha,px,pa);
  end
end
