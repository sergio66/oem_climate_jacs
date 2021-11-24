function [hnew,pnew] = replicate_rtp_headprof(h0,p0,iRTP,numtimes);

% function [hnew,pnew] = replicate_rtp(h0,p0,iRTP,numtimes);
% given input .rtp info, duplicate the "iRTP" th profile "numtimes"
% pretty much the same as replicate_rtp

if isfield(p0,'rcalc') == 0 & isfield(p0,'robs1') == 0
  p0.rcalc = zeros(2378,length(p0.stemp));
  p0.rcalc = zeros(2834,length(p0.stemp));
  %p0.robs1 = zeros(2378,length(p0.stemp));
  h0.pfields = 3;
end

[h1,p1] = subset_rtp(h0,p0,h0.glist,h0.ichan,iRTP);

hnew = h1;
hnew.vcmin =  605;
hnew.vcmax = 2830;

if isfield(p1,'calflag')
  p1 = rmfield(p1,'calflag');  %% having problems with ints
end
if isfield(p1,'pnote')
  p1 = rmfield(p1,'pnote');
end

pfields1 = fieldnames(p1); 

%%%%%%%%%%%%%%% orig code, slow
%tic
%pnew = p1;
%for j = 2 : numtimes
%  for i = 1 : length(pfields1)  
%    % concatenate fields 
%    fieldname = pfields1{i}; 
%    eval(sprintf('[m1,n1]=size(p1.%s);', fieldname)); 
%    % append the p1 field to the corresponding prof field 
%    % e.g., p1.plevs = [p1.plevs, p2.plevs]; 
%    eval(sprintf('pnew.%s = [pnew.%s,p1.%s];',fieldname,fieldname,fieldname)); 
%  end
%end
%pnew0 = pnew;
%toc
%%%%%%%%%%%%%%% new code
pnew = p1;

for i = 1 : length(pfields1)  
  % concatenate fields 
  fieldname = pfields1{i}; 

  eval(sprintf('[m1,n1]=size(p1.%s);', fieldname)); 
  str = ['boojunk=isa(p1.' fieldname ',''int32'');'];
  eval(str);
  %eval(sprintf('boojunk=isa(p1.%s,''int32'');', fieldname)); 
  if boojunk==true
    %eval(sprintf('p1.%s = single(p1.%s);', fieldname,fieldname)); 
    str = ['p1.' fieldname '  = single(p1.' fieldname ');'];
    eval(str)
  end

  if m1 == 1
    str = ['junk = ones(1,' num2str(numtimes) ')* p1.' fieldname ';'];
    %fprintf(1,'%s \n',str)
    eval(str);
    str = ['pnew.' fieldname ' = junk;']; eval(str);
  else
    str = ['junk = p1.' fieldname ' * ones(1,' num2str(numtimes) ');'];
    %fprintf(1,'%s \n',str);
    eval(str);
    str = ['pnew.' fieldname ' = junk;']; eval(str);
  end
end
