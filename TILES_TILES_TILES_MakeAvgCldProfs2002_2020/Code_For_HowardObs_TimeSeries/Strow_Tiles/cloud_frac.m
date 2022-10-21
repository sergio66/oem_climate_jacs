for i = 1:64
   for j = 1:72
      for k=1:412
      x = squeeze(cfdbt_desc(i,j,k,:));
      y = squeeze(hist1231_desc(i,j,k,:));
      ys = interp1(x,y,[-10:0.1:100],'pchip');
      cloud_frac(i,j,k) = sum(ys(147:end))./sum(ys);
   end
end

