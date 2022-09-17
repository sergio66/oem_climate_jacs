function   lonbin_time = nan_lonbin_time_notfound(lonbin_time0);
lonbin_time = lonbin_time0;

fx = fieldnames(lonbin_time);
length(fx)
for ii = 1 : length(fx)
  thename = fx{ii};
  if contains(thename,'asc') | contains(thename,'desc')
    str = ['junk = lonbin_time.' thename ';'];
    eval(str)
    [mm,nn,oo]  = size(junk);
    if mm == 1 & oo == 1
      zcase = 1;
      junk(lonbin_time0.timestep_notfound) = NaN;
    elseif mm > 1 & oo == 1
      zcase = 2;
      junk(lonbin_time0.timestep_notfound,:) = NaN;
    elseif nn > 1 & oo > 1
      zcase = 3;
      junk(lonbin_time0.timestep_notfound,:,:) = NaN;
    end
    fprintf(1,'%3i %s %5i %5i %5i %2i\n',ii,thename,mm,nn,oo,zcase)
    str = ['lonbin_time.' thename ' = junk;'];
    eval(str)      
  end
end
  
