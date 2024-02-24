iQAX =  0; %% quantile and extreme
iQAX = -1; %% extreme
iQAX = +2; %% mean

iQAX = +1; %% quantile   quants = [0 0.01 0.02 0.03 0.04 0.05 0.10 0.25 0.50 0.75 0.9 0.95 0.96 0.97 0.98 0.99 1.00];
iQAX = +3; %% quantile   quants = [0 0.50 0.9 0.95 0.97 1.00];   %%% TRENDS PAPER DEFAULT
iQAX = +4; %% quantile   quants = [0 0.03 0.50 0.97 1.00];       %%% new quants, cold, median, hot

%%%%%%%%%%%%%%%%%%%%%%%%%

iQAX = +3; %% quantile   quants = [0 0.50 0.9 0.95 0.97 1.00];   %%% TRENDS PAPER DEFAULT

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iQAX == 1
  %% original till Oct 2022 : 17 quantile steps, and do the stats so you find how robs1 has changed between Q(ii) and Q(ii+1)
  disp('iQAX == 1 so looking for regular quantiles   quants = [0 0.01 0.02 0.03 0.04 0.05 0.10 0.25 0.50 0.75 0.9 0.95 0.96 0.97 0.98 0.99 1.00]')
  quants = [0 0.01 0.02 0.03 0.04 0.05 0.10 0.25 0.50 0.75 0.9 0.95 0.96 0.97 0.98 0.99 1.00];

elseif iQAX == 3
  %% **************************** used for trends paper, Sounder Meeting 2023 ***********************************
  %% new in Oct 2022 : 6 quantile steps, do the stats so you find how robs1 has changed between Q(ii) and Q(1.00)
  %% **************************** used for trends paper, Sounder Meeting 2023 ***********************************
  disp('iQAX == 3 so looking for newer   quantiles (TRENDS paper, SOUNDER STM 2023)   quants = [0.50 0.80 0.90 0.95 0.97 1.00]')
  quants = [0.50 0.80 0.90 0.95 0.97 1.00];

elseif iQAX == 4
  %% new in Oct 2022 : 6 quantile steps, do the stats so you find how robs1 has changed between Q(ii) and Q(1.00)
  %% disp('iQAX == 4 so looking for newer   quantiles   quants = [0.50 0.80 0.90 0.95 0.97 1.00] and will do LLS Tsurf quants')
  %% quants = [0.50 0.80 0.90 0.95 0.97 1.00];
  disp('iQAX == 4 so looking for newer   quantiles   quants = [0 0.03 <<<    >>> 0.97 1.00]')
  quants = [0 0.03 0.97 1.00];

%elseif iQAX == 0
%  disp('iQAX == 0 so looking for quantiles and extreme')
%elseif iQAX == -1
%  disp('iQAX == -1 so looking for extreme')
%elseif iQAX == 2
%  disp('iQAX == 2 so looking for mean')
else
  error('need iQAX = 1,3,4')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if iQAX ~= 1 & iQAX ~= 3 & iQAX ~= 4
  error('need iQAX = 1,3,4')
end
