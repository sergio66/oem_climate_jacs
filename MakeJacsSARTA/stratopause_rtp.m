function [index_strat] = stratopause_rtp( head, prof );

% function [index_strat] = stratopause_rtp( head, prof );
%
% Find the level/layer of the stratopause for each profile.
%
% Input:
%    head : {structure} RTP header structure containing field "ptype".
%    prof : {structure} RTP profile structure contain fields "ptemp"
%      and either "plevs" (ptype=0,2} or "plays" (ptype=1).
%
% Output:
%    index_strat : [1 x nobs] index of stratopause in "prof.ptemp".
%
% Comment: assumes the stratopause is the level/layer with the lowest
%    temperature within the pressure range 400-50 mb.
%

% Created: 26 October 2006, Scott Hannon
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (~isfield(head,'ptype'))
   error('head lacks manditory field ptype');
end

if (~isfield(prof,'ptemp'))
   error('prof lacks manditory field ptemp');
end

ptype = round(head.ptype);
if (ptype == 1)
   if (~isfield(prof,'plays'))
      error('prof lacks manditory field plays');
   end
else
   if (~isfield(prof,'plevs'))
      error('prof lacks manditory field plevs');
   end
end


% Declare output array
[nlevs, nobs] = size(prof.ptemp);
index_strat = -9999*ones(1, nobs);

% Loop over the profiles
for ip = 1:nobs

   if (ptype == 1)
      ii = 1:(prof.nlevs(ip)-1);
      t = prof.ptemp(ii,ip);
      p = prof.plays(ii,ip);
   else
      ii = 1:prof.nlevs(ip);
      t = prof.ptemp(ii,ip);
      p = prof.plevs(ii,ip);
   end

   isearch = find( p <= 20 & p >= 0 );   
   phigh0 = 20;
   phigh0 = 50;

   isearch = find( p <= phigh0 & p >= 2 );    %% prior March 5, 2012
   isearch = find( p <= phigh0 & p >= 0.1 );  %% after March 6, 2012
   if length(isearch) < 1
%     ip
%     [p t]
%     semilogy(t,p,'o-'); grid;
     isearch = find( p == min(p));
     end
   
   tmax = max( t(isearch) );

   index_strat(ip) = isearch( min( find( t(isearch) == tmax ) ) );

end

%%% end of function %%%
