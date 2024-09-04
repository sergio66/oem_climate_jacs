%% X is the BT1231 data     1xN   (N ~ 6500 for asc, 6500 for desc)
%% Y is the BT1231 quantile 1xQ   (Q=[0.5 0.8 0.9 0/95  0.97 0/99 1] for iQAX = 3)

if iQAX == 1
  if qq <  length(quants)-1
    Z = find(X >= Y(qq) & X < Y(qq+1));
  else
    Z = find(X >= Y(qq) & X <= Y(qq+1));
    Z = find(X >= Y(qq));
  end

elseif iQAX == 3
  %% find from Y(qq) to 1.0
  Z = find(X >= Y(qq));      

elseif iQAX == 4
  %% quants = [0 0.03 0.97 1]
  %Z = find(X >= do_tile(Y(qq)));
  if quants(qq) <= eps
    %% quants(qq) = 0
    %% find from 0 to 1
    Z = find(X < Y(end)+1 & X > 0);
    Z = find(X < Y(end)+1);                   %% average over ALL data (Q=0 to Q=1)
  elseif quants(qq) > 0 & quants(qq) < 0.5 
    %% quants(qq) = 0.03
    %% find from 0 to Y(qq)
    Z = find(X < Y(qq));                      %% average from Q=0 to Q=q (cold data)
  elseif quants(qq) >= 0.5
    %% quants(qq) = 0.97
    %% find from Y(qq) to 1.0
    Z = find(X >= Y(qq));                     %% average from Q=q to Q=1 (hot data)
  end
end
