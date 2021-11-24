function  p16new = check_98levs(p16);

airslevels = load('/home/sergio/MATLABCODE/airslevels.dat');
airslevels = flipud(airslevels);
airsN = airslevels(1:end-1)-airslevels(2:end);
airsD = log(airslevels(1:end-1)./airslevels(2:end));
airslays = airsN./airsD;
airslays(101) = airslays(100) + abs(airslays(100)-airslays(99));

p16new = p16;

for ii = 1 : length(p16new.stemp)
  boo = find(airslevels > p16new.spres,1);
  stoplev(ii) = boo;
  for jj = 90:98
    badT = find(isnan(p16.ptemp(jj,:)) | isinf(p16.ptemp(jj,:)) | (p16.ptemp(jj,:) < eps));
    badW = find(isnan(p16.gas_1(jj,:)) | isinf(p16.gas_1(jj,:)) | (p16.gas_1(jj,:) < eps));
    badO = find(isnan(p16.gas_3(jj,:)) | isinf(p16.gas_3(jj,:)) | (p16.gas_3(jj,:) < eps));
    findbad(jj-90+1) = length(badT) + length(badW) + length(badO);
  end
end

%% odd it is 98, but there is hardly an profile info at layers 96,97 for high lats
plot(stoplev); title('stoplev ... is it 98?'); 

if sum(findbad) > 0
  fprintf(1,' found some profiles that do not extend to layer 98');
  disp('findbad at begin : ')
  fprintf(1,'%5i %5i %5i %5i %5i %5i %5i %5i %5i \n',findbad)

  iFixBad = 0;
  for ii = 1 : length(p16new.stemp)
    bad = [];
    for jj = 90:98
      badT = find(isnan(p16.ptemp(jj,ii)) | isinf(p16.ptemp(jj,ii)) | (p16.ptemp(jj,ii) < eps));
      badW = find(isnan(p16.gas_1(jj,ii)) | isinf(p16.gas_1(jj,ii)) | (p16.gas_1(jj,ii) < eps));
      badO = find(isnan(p16.gas_3(jj,ii)) | isinf(p16.gas_3(jj,ii)) | (p16.gas_3(jj,ii) < eps));
      bad(jj-90+1) = length(badT) + length(badW) + length(badO);
    end
    if sum(bad) > 0
      iFixBad = iFixBad + 1;
      lala = 1 : 98;

      ptemp = p16.ptemp(lala,ii);
      ohno = find(isnan(ptemp) | isinf(ptemp) | (ptemp < eps));
      ohyes = setdiff(lala,ohno);
      ptemp(ohno) = interp1(log(airslays(ohyes)),ptemp(ohyes),log(airslays(ohno)),[],'extrap');
      p16new.ptemp(lala,ii) = ptemp;

      gas_1 = log(p16.gas_1(lala,ii));
      ohno = find(isnan(gas_1) | isinf(gas_1) | (gas_1 < eps));
      ohyes = setdiff(lala,ohno);
      gas_1(ohno) = interp1(log(airslays(ohyes)),gas_1(ohyes),log(airslays(ohno)),[],'extrap');
      p16new.gas_1(lala,ii) = exp(gas_1);

      gas_3 = log(p16.gas_3(lala,ii));
      ohno = find(isnan(gas_3) | isinf(gas_3) | (gas_3 < eps));
      ohyes = setdiff(lala,ohno);
      gas_3(ohno) = interp1(log(airslays(ohyes)),gas_3(ohyes),log(airslays(ohno)),[],'extrap');
      p16new.gas_3(lala,ii) = exp(gas_3);

    end
  end
  fprintf(1,'fixed %3i of %3i profiles \n',iFixBad,length(p16new.stemp));

  %%%% check
  clear findbad
  for ii = 1 : length(p16new.stemp)
    boo = find(airslevels > p16new.spres,1);
    stoplev(ii) = boo;
    for jj = 90:98
      badT = find(isnan(p16new.ptemp(jj,:)) | isinf(p16new.ptemp(jj,:)) | (p16new.ptemp(jj,:) < eps));
      badW = find(isnan(p16new.gas_1(jj,:)) | isinf(p16new.gas_1(jj,:)) | (p16new.gas_1(jj,:) < eps));
      badO = find(isnan(p16new.gas_3(jj,:)) | isinf(p16new.gas_3(jj,:)) | (p16new.gas_3(jj,:) < eps));
      findbad(jj-90+1) = length(badT) + length(badW) + length(badO);
    end
  end
  disp('findbad at end : ')
  fprintf(1,'%5i %5i %5i %5i %5i %5i %5i %5i %5i \n',findbad)
end
