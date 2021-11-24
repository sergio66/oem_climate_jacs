function y = do_the_max_min_daily(iCnt,iiix,jjjx,s,adsc,thesave,ianpts,asc_or_desc);

y  = thesave;
%toc

[yy0,mm0,dd0,hh0] = tai2utcSergio(s.tai93(ianpts) + offset1958_to_1993);
%toc

[yy,mm,dd,hh] = tai2utcSergio(s.tai93(adsc) + offset1958_to_1993);
%toc
fprintf(1,'  iCnt = %4i iiix jjjjx = %2i %2i asc/desc %2i    length(unique(mm)) = %2i length(unique(dd)) = %2i \n',iCnt,iiix,jjjx,asc_or_desc,length(unique(mm)),length(unique(dd)));

bt1231 = rad2bt(1231,s.rad(1520,adsc));
%toc

themax = find(bt1231 == max(bt1231),1);
  if asc_or_desc > 0
    y.rad_blockmax_asc(iCnt,:) = s.rad(:,adsc(themax));
  else
    y.rad_blockmax_desc(iCnt,:) = s.rad(:,adsc(themax));
  end
%toc

themin = find(bt1231 == min(bt1231),1);
  if asc_or_desc > 0
    y.rad_blockmin_asc(iCnt,:) = s.rad(:,adsc(themin));
  else
    y.rad_blockmin_desc(iCnt,:) = s.rad(:,adsc(themin));
  end

%%% NOTICE HOW WE ARE LOOPING OVER MM0 and DD0 (becuase they err should contain all 16 days)
%%% not mm and dd (because they might not contain all 16 days)

%toc

iCntDay = 0;
umm0 = unique(mm0);
if min(umm0) <= 6 & max(umm0) > 6   %% got to be eg [2002/12 and 2003/01]
  for mmx = max(umm0) : -1 : min(umm0)
    max_min_loop__mm_dd_v2
  end      %% for mmx         
else                           %% got to be eg [2003/11 and 2003/12]
  for mmx = min(umm0) : +1 : max(umm0)
    max_min_loop__mm_dd_v2
  end      %% for mmx         
end
