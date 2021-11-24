function [dqT,Tjacindex,jjT] = do_hand_N_Tjacs_onlyonedelta(params,normer,px,jacT,i1or2);

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

  lajac = (summ(jacT(:,lays)))*normer.normT/(i1or2*normer.dT);   

  jj=jj+1; 
  str = ['dqT.dq_T_' num2str(jj) '_nominal = lajac;']; eval(str);
  if jj == 1
    Tjacindex = [lays(1) lays(end)];
  else
    Tjacindex = [Tjacindex lays(end)];
  end
  iStart = iEnd + 1; 
end

jjT = jj;

