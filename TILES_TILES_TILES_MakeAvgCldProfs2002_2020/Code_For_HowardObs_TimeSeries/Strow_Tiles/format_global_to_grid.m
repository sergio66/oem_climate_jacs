% Note: this takes a long time to run!

cd  /asl/stats/airs/global_by_time

a = dir('*.mat');
for i=1:nt
   g = load(a(i).name);
   gtot(i,:,:) = g.gtot;
   gavg(i,:,:,:) = g.gavg;
   gvar(i,:,:,:) = g.gvar;
   mtime(i) = mean(datetime(g.year,1,g.dlist));
end

cd  /asl/stats/airs/grid_by_time

for ilat = 1:64
   ilat
%   mkdir(['lat_',int2str(ilat)]);   % Already done (maybe)
   cd(['lat_',int2str(ilat)]);
   for ilon = 1:72
      r_avg = squeeze(gavg(:,:,ilat,ilon));
      r_var = squeeze(gvar(:,:,ilat,ilon));
      r_tot = squeeze(gtot(:,ilat,ilon));
      glatb = latB(ilat:ilat+1);
      glonb = lonB(ilon:ilon+1);
      save(['grid_lat_lon_' int2str(ilat) '_' int2str(ilon)],'r_avg','r_var','r_tot','glatb','glonb','mtime');
   end
   cd ..
end


  