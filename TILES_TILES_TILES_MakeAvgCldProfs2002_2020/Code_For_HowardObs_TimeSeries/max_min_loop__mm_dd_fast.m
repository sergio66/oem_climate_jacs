ddS = find(mm == mmx); ddS = min(dd(ddS));
ddE = find(mm == mmx); ddE = max(dd(ddE));
%toc

themax = nan(1,16);
themin = nan(1,16);

for ddx = ddS : ddE
%disp(' ')
  xoo = find(mmxs == mmx & ddxs == ddx);
  iCntDay = iCntDay + 1;
%toc
  if length(xoo) > 0
%    fprintf(1,'     day %2i of 16 : %2i/%2i \n',[iCntDay mmx ddx])
    bt1231 = rad2bt(1231,s.rad(1520,adsc(xoo)));
    themax(iCntDay) = xoo(find(bt1231 == max(bt1231),1));
    themin(iCntDay) = xoo(find(bt1231 == min(bt1231),1));
  end
end  

omax = find(isfinite(themax));
  themax(omax) = adsc(themax(omax)); 
omin = find(isfinite(themin));
  themin(omin) = adsc(themin(omin)); 

%disp(' ')
%disp(' ')

%toc
miaowX = s.rad(:,themax(omax));
miaowN = s.rad(:,themin(omin));
%whos miaow*;
%error('miaow')

if asc_or_desc > 0
  thesave.rad_max_asc(iCnt,1:2645,omax) = s.rad(:,themax(omax));
  thesave.rad_min_asc(iCnt,1:2645,omin) = s.rad(:,themin(omin));
  thesave.rad_max_asc(iCnt,1:2645,omax) = miaowX;
  thesave.rad_min_asc(iCnt,1:2645,omin) = miaowN;
else
  thesave.rad_max_desc(iCnt,1:2645,omax) = s.rad(:,themax(omax));
  thesave.rad_min_desc(iCnt,1:2645,omin) = s.rad(:,themin(omin));
end
%toc
