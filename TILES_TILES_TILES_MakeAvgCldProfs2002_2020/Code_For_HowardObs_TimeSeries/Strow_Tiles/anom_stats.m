for l=1:2645
for i=1:407
   a = squeeze(anom(:,:,i,l));
   for j = 1:72
      a(:,j) = a(:,j).*eq_area_wgt;
   end
   am(l,i) = nanmean(a,'all');
   astd(l,i) = nanstd(a,0,'all');
end
end

for l=1:2645
   l
   for ilat = 1:64
      for ilon = 1:72
         a = squeeze(anom(ilat,ilon,:,l));
         a2std = 2*nanstd(a);
         mxa(l,ilat,ilon).k = find(abs(a) > a2std);
      end
   end
end
