function [dqO3,O3jacindex,jjO3] = do_hand_N_o3jacs_onlyonedelta(params,normer,px,jacO3,i1or2);

%% 100 layer jacs

jj = 0;

iStart = 1; iEnd = px.nlevs-1;
jj = 0;
for kk = 1 : px.nlevs-1
  iEnd = iStart;
  lays = iStart:iEnd;
  if length(lays) < 1; 
    break; 
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%% used most of the time
  lajac = (summ(jacO3(:,lays)))*normer.normO3/(log(1+i1or2*normer.dQ));
  %%%%%%%%%%%%%%%%%%%%%%%%%%% used most of the time
  
  jj=jj+1; 
  str = ['dqO3.dq_O3_' num2str(jj) '_nominal = lajac;']; eval(str);
  if jj == 1
    O3jacindex = [lays(1) lays(end)];
  else
    O3jacindex = [O3jacindex lays(end)];
  end
  iStart = iEnd + 1; 
end

jjO3 = jj;
