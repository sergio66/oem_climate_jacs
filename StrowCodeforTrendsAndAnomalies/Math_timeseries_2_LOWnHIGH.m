function [y g]=Math_timeseries_2_LOWnHIGH(x,c);
% function [y]=Math_timeseries(x,coef)
% 
% Usage:
% x=....
% y=....
% fitc=fminsearch(@(c) Math_timeseries_err(x,y,c),[370;1;1;1;1;1;1;1;1;1]);
% plot(x,y,'b'); hold; plot(x,Math_timeseries(x,fitc),'r');
%
% OR
%
% fitc=fminunc(@(c) Math_timeseries_err(x,y,c),[370;1;1;1;1;1;1;1;1;1]);

if length(c) ~= 2 & mod(length(c),4) ~= 0
  error('Math_timeseries_2_LOWnHIGH.m nees to have length(c) = 2 (n-0) or 4 (n=1) or 8,12,16 (n=2,3,4)')
end
    
y = c(1)       + ...
    c(2)*x/365;
if length(c) >= 4  
  ii = 1; %% look at c(n=3,4)
  %% note ii = 1 this is same as c(2*ii+1)*cos(1/ii*2*pi/365*x) + c(2*ii+2)*sin(1/ii*2*pi/365*x);  
  y = y + c(2*ii+1)*cos(ii*2*pi/365*x) + c(2*ii+2)*sin(ii*2*pi/365*x);   
end
if length(c) >= 8  
  ii = 2; %% look at c(n=5,6,7,8)
  y = y + c(4*(ii-1)+1)*cos(ii*2*pi/365*x) + c(4*(ii-1)+2)*sin(ii*2*pi/365*x);  
  y = y + c(4*(ii-1)+3)*cos(1/ii*2*pi/365*x) + c(4*(ii-1)+4)*sin(1/ii*2*pi/365*x);  
end
if length(c) >= 12  
  ii = 3; %% look at c(n=9,10,11,12)
  y = y + c(4*(ii-1)+1)*cos(ii*2*pi/365*x) + c(4*(ii-1)+2)*sin(ii*2*pi/365*x);  
  y = y + c(4*(ii-1)+3)*cos(1/ii*2*pi/365*x) + c(4*(ii-1)+4)*sin(1/ii*2*pi/365*x);  
end
if length(c) >= 16  
  ii = 4; %% look at c(n=13,14,15,16)
  y = y + c(4*(ii-1)+1)*cos(ii*2*pi/365*x) + c(4*(ii-1)+2)*sin(ii*2*pi/365*x);  
  y = y + c(4*(ii-1)+3)*cos(1/ii*2*pi/365*x) + c(4*(ii-1)+4)*sin(1/ii*2*pi/365*x);  
end

if(nargout > 1)
   g(:,1)=1*ones(size(x));
   g(:,2)=x/365;
   if length(c) >= 4;
     ii = 1;
     g(:,2*ii+1) = cos(ii*2*pi/365*x);
     g(:,2*ii+2) = sin(ii*2*pi/365*x);
   end
   for ii = 1 : (length(c)-4)/4
     jj = ii + 1;
     g(:,4*(jj-1)+1) = cos(jj*2*pi/365*x);
     g(:,4*(jj-1)+2) = sin(jj*2*pi/365*x);
     g(:,4*(jj-1)+3) = cos(1/jj*2*pi/365*x);
     g(:,4*(jj-1)+4) = sin(1/jj*2*pi/365*x);
  end     
end

