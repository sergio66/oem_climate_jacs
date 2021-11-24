%% script do_the_max_min_daily(iCnt,iiix,jjjx,s,adsc,thesave,ianpts,asc_or_desc);

%toc

%[yy0,mm0,dd0,hh0] = tai2utcSergio(s.tai93(ianpts) + offset1958_to_1993);
%toc

[yyxs,mmxs,ddxs,hhxs] = tai2utcSergio(s.tai93(adsc) + offset1958_to_1993);
%toc
fprintf(1,'  iCnt = %4i iiix jjjjx = %2i %2i asc/desc %2i    length(unique(mmxs)) = %2i length(unique(ddxs)) = %2i \n',iCnt,iiix,jjjx,asc_or_desc,length(unique(mmxs)),length(unique(ddxs)));

bt1231xs = rad2bt(1231,s.rad(1520,adsc));
%toc

themax = find(bt1231xs == max(bt1231xs),1);
  if asc_or_desc > 0
    thesave.rad_blockmax_asc(iCnt,:) = s.rad(:,adsc(themax));
  else
    thesave.rad_blockmax_desc(iCnt,:) = s.rad(:,adsc(themax));
  end
%toc

themin = find(bt1231xs == min(bt1231xs),1);
  if asc_or_desc > 0
    thesave.rad_blockmin_asc(iCnt,:) = s.rad(:,adsc(themin));
  else
    thesave.rad_blockmin_desc(iCnt,:) = s.rad(:,adsc(themin));
  end

%%% NOTICE HOW WE ARE LOOPING OVER MM0 and DD0 (becuase they err should contain all 16 days)
%%% not mm and dd (because they might not contain all 16 days)

%toc

iCntDay = 0;
umm = unique(mm);
if min(umm) <= 6 & max(umm) > 6   %% got to be eg [2002/12 and 2003/01]
  for mmx = max(umm) : -1 : min(umm)
    max_min_loop__mm_dd_fast
  end      %% for mmx         
else                           %% got to be eg [2003/11 and 2003/12]
  for mmx = min(umm) : +1 : max(umm)
    max_min_loop__mm_dd_fast
  end      %% for mmx         
end
