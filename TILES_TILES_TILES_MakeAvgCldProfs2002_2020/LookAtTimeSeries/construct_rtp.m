function [headNx,profNx] = construct_rtp(headN,profN,hsub,psub,dadiffOK);

headNx = hsub;
if isfield(profN,'stemp')
  profNx = profN;
end

fnames = fieldnames(psub);
for ii = 1 : length(fnames)  
  str = ['junk = psub.' fnames{ii} ';'];
  eval(str)
  [mm,nn] = size(junk);

  cl = class(junk);
  on = ones(1,length(dadiffOK));

  if strcmp(cl,'int32')
    on = int32(on);
  elseif strcmp(cl,'unit8')
    on = on;
    %on = uint8(on);
  elseif strcmp(cl,'single')
    on = single(on);
  elseif strcmp(cl,'double')
    on = double(on);
  end

  thecopy = junk * on;

  if mm == 1
    str = ['profNx.' fnames{ii} '(dadiffOK) = thecopy;'];
  else
    str = ['profNx.' fnames{ii} '(:,dadiffOK) = thecopy;'];
  end
  eval(str);

end
