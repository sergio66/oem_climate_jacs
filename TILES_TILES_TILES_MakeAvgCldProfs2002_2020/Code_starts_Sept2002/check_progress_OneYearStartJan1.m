iX = input('both (0) asc (-1) desc (+1, default) : ');
if length(iX) == 0
  iX = 1;
end
if iX == 1
  diruse = 'DATA_OneYear/DESC/';
elseif iX == 0
  diruse = 'DATA_OneYear/';
elseif iX == -1
  diruse = 'DATA_OneYear/ASC/';
end

iX = input('check progress? (-1/+1) : ');
if length(iX) == 0
  iX = -1;
end

if iX > 0
  for grid = 1 : 72*64
    for tt = 1 : 23
      fout = [diruse num2str(grid,'%04i') '/pall_gridbox_' num2str(grid,'%04i') '_16daytimestep_' num2str(tt,'%03i') '_*.mat'];
      thedir = dir(fout);
      iaaFound(grid,tt) = NaN;
      if length(thedir) == 1
        iaaFound(grid,tt) = 0;      
        if thedir.bytes > 0
          iaaFound(grid,tt) = 1;      
        end
      end
    end
  end
  
  fprintf(1,'have found %6i of %6i \n',nansum(iaaFound(:)),72*64*23)
  figure(1); pcolor(iaaFound); shading flat; colorbar; colormap jet;
  figure(2); plot(1:4608,nansum(iaaFound,2));
  figure(3); plot(1:23,nansum(iaaFound,1));
  pause(0.1)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

iX = input('make pdfs? (-1/+1) : ');
if length(iX) == 0
  iX = -1;
end

if iX > 0
  stemp = [];
  rlat = [];
  rlon = [];
  rclr = [];
  rcld = [];
  landfrac = [];
  
  stemp_av = [];
  rlat_av = [];
  rlon_av = [];
  rclr_av = [];
  rcld_av = [];
  landfrac_av = [];
  
  bt = 200:1:330;

  for grid = 1 : 72*64
    if mod(grid,72) == 0
      fprintf(1,'.');
      figure(1); plot(bt,histc(stemp,bt),'k',bt,histc(rad2bt(1231,rcld),bt),'r',bt,histc(rad2bt(1231,rclr),bt),'b')
      figure(2); scatter(rlon_av,rlat_av,10,stemp_av,'filled');
      pause(0.1)
    end
    for tt = 1
      fout = [diruse num2str(grid,'%04i') '/pall_gridbox_' num2str(grid,'%04i') '_16daytimestep_' num2str(tt,'%03i') '_*.mat'];
      thedir = dir(fout);
      if length(thedir) == 1
        if thedir.bytes > 0
          fout = [diruse num2str(grid,'%04i') '/' thedir.name];
          a = load(fout);
          darand = ceil(rand(1,5000)*48000);
          darand(darand > 48000) = 48000;
          darand(darand < 1) = 1;
          darand = unique(darand);

          darand  = 1 : length(a.p2x.stemp);

          stemp = [stemp a.p2x.stemp(darand)];        
          rlat = [rlat a.p2x.rlat(darand)];        
          rlon = [rlon a.p2x.rlon(darand)];        
          landfrac = [landfrac a.p2x.landfrac(darand)];        
          rclr = [rclr a.p2x.sarta_rclearcalc(5,darand)];        
          rcld = [rcld a.p2x.rcalc(5,darand)]; 
       
          stemp_av = [stemp_av a.pavg.stemp];        
          rlat_av = [rlat_av a.pavg.rlat];        
          rlon_av = [rlon_av a.pavg.rlon];        
          landfrac_av = [landfrac_av a.pavg.landfrac];        
          rclr_av = [rclr_av a.pavg.sarta_rclearcalc(5)];        
          rcld_av = [rcld_av a.pavg.rcalc(5)];        
        end
      end
    end
  end
  figure(1); plot(bt,histc(stemp,bt),'k',bt,histc(rad2bt(1231,rcld),bt),'r',bt,histc(rad2bt(1231,rclr),bt),'b')
  figure(2); scatter(rlon_av,rlat_av,10,stemp_av,'filled');
end
