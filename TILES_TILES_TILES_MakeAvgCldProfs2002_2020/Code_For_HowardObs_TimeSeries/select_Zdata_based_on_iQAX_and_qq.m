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
  %Z = find(X >= do_tile(Y(qq)));
  if quants(qq) <= eps
    %% find from 0 to 1
    Z = find(X < Y(end)+1 & X > 0);
    Z = find(X < Y(end)+1);
  elseif quants(qq) > 0 & quants(qq) < 0.5 
    %% find from 0 to Y(qq)
    Z = find(X < Y(qq));
  elseif quants(qq) >= 0.5
    %% find from Y(qq) to 1.0
    Z = find(X >= Y(qq));
  end
end
