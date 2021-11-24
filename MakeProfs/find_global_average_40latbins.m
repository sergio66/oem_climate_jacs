function globalavg = find_global_average_40latbins(pallx);

%% this function assumes you have the profiles, rads etc of the 40 area weighted latbins, saved off in "pall1"

if isfield(pallx,'calflag')
  pallx = rmfield(pallx,'calflag');
end
if isfield(pallx,'pnote')
  pallx = rmfield(pallx,'pnote');
end
if isfield(pallx,'iudef')
  pallx = rmfield(pallx,'iudef');
end

thefields = fieldnames(pallx);
wgts = cos(pallx.rlat*pi/180);
wgts = wgts/sum(wgts);
for ii = 1 : length(thefields)
  str = ['junk = pallx.' thefields{ii} ';'];
  eval(str);
  
  [mm,nn] = size(junk);  
  xtype = class(junk);
  ztype = +1;
  if strcmp(xtype,'int32')
    ztype = -1;
    junk = cast(junk,'single');
  elseif strcmp(xtype,'uint8')
    ztype = -8;
    junk = cast(junk,'single');
  end
  
  if mm == 1
    junk = junk.* wgts;
    junk = sum(junk);
  else
    junk = (ones(mm,1)*wgts) .* junk;
    junk = sum(junk,2);
  end

  if ztype == -1
    junk = cast(junk,'int32');  
  elseif ztype == -8
    junk = cast(junk,'uintt8');  
  end
  
  str = ['globalavg.' thefields{ii} ' = junk;'];
  eval(str);
end  

figure(1); clf; plot(1:40,pallx.stemp,1:40,globalavg.stemp*ones(1,40))
figure(2); clf; plot(pallx.ptemp,1:101,'b'); hold on; plot(globalavg.ptemp,1:101,'r','linewidth',2); set(gca,'ydir','reverse');
figure(3); clf; semilogx(pallx.gas_1,1:101,'b'); hold on; plot(globalavg.gas_1,1:101,'r','linewidth',2); set(gca,'ydir','reverse');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%