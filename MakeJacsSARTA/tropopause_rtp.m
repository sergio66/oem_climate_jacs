function [index_trop] = tropopause_rtp( head, prof );

% function [index_trop] = tropopause_rtp( head, prof );
%
% Find the level/layer of the tropopause for each profile.
%
% Input:
%    head : {structure} RTP header structure containing field "ptype".
%    prof : {structure} RTP profile structure contain fields "ptemp"
%      and either "plevs" (ptype=0,2} or "plays" (ptype=1).
%
% Output:
%    index_trop : [1 x nobs] index of tropopause in "prof.ptemp".
%
% Comment: assumes the tropopause is the level/layer with the lowest
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
      disp('warning : prof lacks manditory field plays : adding it on');
      playsN = prof.plevs(1:100,:) - prof.plevs(2:101,:);
      playsD = log(prof.plevs(1:100,:) ./ prof.plevs(2:101,:));
      plays = playsN ./ playsD;
      prof.plays = zeros(size(prof.plevs));
      prof.plays(1:100,:) = plays;
   end
else
   if (~isfield(prof,'plevs'))
      error('prof lacks manditory field plevs');
   end
end


% Declare output array
[nlevs, nobs] = size(prof.ptemp);
index_trop = -9999*ones(1, nobs);


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
   iDir = +1;     %% assume pressures are decreasing as index increases
   if p(5) < p(6) 
     iDir = -1;   %% assume pressures are increasing as index increases
   end

   isearch = find( p >= 90 & p <= 400 );
   isearch = find( p >= 50 & p <= 400 );
   
   tmin = min( t(isearch) );

   %% /home/sergio/MATLABCODE/UTILITY/localmaxmin.m
   [n]=localmaxmin(t(isearch),'min');
   tminLL = t(isearch(n));
   if iDir > 0
     tminLL = tminLL(1);
   else
     tminLL = tminLL(end);
   end
   tminLL;

   index_trop(ip) = isearch( max( find( t(isearch) == tmin ) ) );
   index_trop(ip) = isearch( max( find( t(isearch) == tminLL ) ) );

end

%%% end of function %%%
