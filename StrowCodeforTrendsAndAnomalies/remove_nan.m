function [i,x] = remove_nan(y);
% Remove NaN's from a vector, and return non-NaN indices

i = find(~isnan(y));
x = y(i);

return


