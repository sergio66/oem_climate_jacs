addpath /home/sergio/KCARTA/MATLAB
[xj,w] = readkcjac('x.jac');    %% orig Jan 2019 all jacs, unweighted, complicated
[yj,w] = readkcjac('y3.jac');   %% new Feb 2019, all jacs, weighted, easy
[zj,w] = readkcjac('y4.jac');   %% new Feb 2019, only final weighted jacs, easy

frac = [0.27731 0.41040 0.14486 0.16744 1];

for indy = 1:5 
  inds = indy;
  indsx = indy; 
  inds = (1:877) + (inds-1)*877; 
  xjj = xj(:,inds); yjj = yj(:,inds); 

  junk = [indy 1./frac(indsx) sum(yjj(:)-frac(indsx)*xjj(:))];
  fprintf(1,'iAtm = %2i the wgtfrac is %8.6f while diff is %8.6f \n',junk);

  wah = junk(2);
  plot(w,xjj./yjj); axis([605 630 wah-0.5 wah+0.5]); grid on; 
  title(num2str(indy)); disp('ret'); pause;
end

blah = zeros(size(yjj));
for indsx=1:4
  inds = indsx; 
  inds = (1:877) + (inds-1)*877; 
  yjj = yj(:,inds); 
  blah = blah + yjj;
end
inds=5; indsx = inds; inds = (1:877) + (inds-1)*877; 
xjj = xj(:,inds); 
yjj = yj(:,inds); 
zjj = zj;

disp('>>>>>>>>>>>>')
fprintf(1,'CHECK : alldump-smallwgt dump : sum(yjj(:)-zj(:)) = %8.6f \n',sum(yjj(:)-zj(:)))
disp('>>>>>>>>>>>>')

[sum(yjj(:)-blah(:)) sum(yjj(:)-zj(:)) sum(zj(:)-blah(:))]
plot(w,blah./yjj); axis([605 630 0.5 1.5]); grid on; 
title('final sum'); disp('ret'); pause;

for indy = 1 : 8
  ix = 10 + (indy-1)*100; plot(w,yjj(:,ix),'b.-',w,blah(:,ix),'r');
  title(num2str(ix)); disp('ret'); pause;
end

iFr = 1;
iFr = 6100;
plot(1:877,yj(iFr,1:877),'k.-',1:877,yjj(iFr,:),'b.-',1:877,blah(iFr,:),'r')
axis([0 900 -0.1 +0.1]); grid
hl = legend('individual contr','kcarta sum','matlab sum','location','best');

plot(1:877,yj(iFr,1:877),'k.-',1:877,blah(iFr,:),'r')
axis([0 900 -0.1 +0.1]); grid
hl = legend('individual contr','matlab sum','location','best');

plot(1:877,yjj(iFr,1:877),'bo-',1:877,blah(iFr,:),'rx-')
axis([0 900 -0.1 +0.1]); grid
hl = legend('kcarta sum','matlab sum','location','best');

plot(1:877,yjj(iFr,1:877) ./ blah(iFr,:),'bx-')
axis([0 900 0.75 1.25]); grid
hl = legend('kcarta sum/matlab sum','location','best');
