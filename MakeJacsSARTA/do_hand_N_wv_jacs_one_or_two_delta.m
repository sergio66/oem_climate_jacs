function [dqWV,WVjacindex,jjwv] = do_hand_N_wvjacs_onlyonedelta(params,normer,px,jacWV,i1or2)

%% 100 layer jacs

jj = 0;

iStart = 1; iEnd = px.nlevs-1;
for kk = 1 : px.nlevs-1
  iEnd = iStart;
  lays = iStart:iEnd;
  if length(lays) < 1; 
    break; 
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%% used most of the time
  lajac = (summ(jacWV(:,lays)))*normer.normWV/(log(1+i1or2*normer.dQ));
  %%%%%%%%%%%%%%%%%%%%%%%%%%% used most of the time

  jj=jj+1; 
  str = ['dqWV.dq_WV_' num2str(jj) '_nominal = lajac;']; eval(str);
  if jj == 1
    WVjacindex = [lays(1) lays(end)];
  else
    WVjacindex = [WVjacindex lays(end)];
  end
  iStart = iEnd + 1; 
end

jjwv = jj;
