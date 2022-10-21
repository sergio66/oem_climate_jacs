function [mag phase ] = magphase(c,d);

mag = sqrt(c.^2 + d.^2);
phase = atan(d./c);
phase = rad2deg(phase);

end

