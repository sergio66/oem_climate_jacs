ddS = find(mm0 == mmx); ddS = min(dd0(ddS));
ddE = find(mm0 == mmx); ddE = max(dd0(ddE));

toc
%y.rad_max_asc(iCnt,:,:) = NaN;
%y.rad_min_asc(iCnt,:,:) = NaN;
toc

profile on -timestamp
%clear tocmxmn
tocmxmn = nan(1,17);
tocmxmn(iCntDay+1) = toc;

for ddx = ddS : ddE
  disp(' ')
  xoo = find(mm == mmx & dd == ddx);
  iCntDay = iCntDay + 1;
  if length(xoo) > 0
%    fprintf(1,'     day %2i of 16 : %2i/%2i \n',[iCntDay mmx ddx])
    bt1231 = rad2bt(1231,s.rad(1520,adsc(xoo)));
    themax = find(bt1231 == max(bt1231),1);
    themin = find(bt1231 == min(bt1231),1);
crapX = squeeze(s.rad(:,adsc(xoo(themax))))'; %whos crapX
toc
crapN = squeeze(s.rad(:,adsc(xoo(themin))))'; %whos crapX
toc
garbage = y.rad_max_asc(iCnt,1:2645,iCntDay); %whos garbage
toc
%[iCnt iCntDay xoo(themax) xoo(themin) adsc(xoo(themin)) adsc(xoo(themax)) length(ianpts) asc_or_desc]
%disp('pause'); pause
    if asc_or_desc > 0
      toc
      y.rad_max_asc(iCnt,1:2645,iCntDay) = crapX;
      toc
      y.rad_min_asc(iCnt,1:2645,iCntDay) = crapN;
      toc
    else
      y.rad_max_desc(iCnt,1:2645,iCntDay) = crapX;
      y.rad_min_desc(iCnt,1:2645,iCntDay) = crapN;
    end
  end  %% for ddx
  tocmxmn(iCntDay+1) = toc;
end    

diff(tocmxmn)
ppp = profile('info')
save myprofiledata ppp
profile off
