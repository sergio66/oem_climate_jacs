iMax = 365;
iMax = 365+23+23;
for ii = 1 : iMax
  fname = ['DATA_StartSept2002/pall_16daytimestep_' num2str(ii,'%03i') '_*.mat'];
  oo = dir(fname);
  if length(oo) > 0
    havefound(ii) = 1;
  else
    havefound(ii) = 0;
  end
end

fprintf(1,'found %3i of %3i files \n',sum(havefound),iMax);

if sum(havefound) < iMax
  miaow = find(havefound < 1);
  fid = fopen('notfound.txt','w');
  for jj = 1 : length(miaow)
    fprintf(fid,'%3i \n',miaow(jj));    
    fprintf(1,'%3i   %3i \n',jj,miaow(jj));
  end
  fclose(fid);
end
