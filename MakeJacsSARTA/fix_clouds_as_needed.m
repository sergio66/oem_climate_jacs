function px = fix_clouds_as_needed(pin);

px = pin;
%% px = sanity_check(px);  %% this subroutine calls fix_clouds_as_needed.m so would be an infinite recusrsive loop

iFix = 0;
iNotOK = 1;
while iFix < 12 & iNotOK > 0
  iFix = iFix + 1;
  fprintf(1,' doing n = %2i try at checking clouds \n',iFix)
  [px,iNotOK] = check_for_errors(px,-1,iFix);  %% see possible pitfalls in clouds
end
if iFix >= 12 & iNotOK > 0
  %disp('oops, could not fix cprtop vs cprbot vs spres'); %keyboard
  error('oops, could not fix cprtop vs cprbot vs spres')
end	  
