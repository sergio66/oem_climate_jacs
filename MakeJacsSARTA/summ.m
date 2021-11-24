function y = summ_hand(yin)

[mm,nn] = size(yin);
if nn == 1
  y = yin';
else
  y = sum(yin');
  end