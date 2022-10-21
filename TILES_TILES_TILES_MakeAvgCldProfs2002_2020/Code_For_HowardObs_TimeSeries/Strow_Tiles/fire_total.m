alat = NaN(1,598034);
alon = NaN(1,598034);
asolzenf = NaN(1,598034);
amtimef = NaT(1,598034);
at1231 = NaN(1,598034);
abt1231 = NaN(1,598034);
abt2616 = NaN(1,598034);

k = 1;
clear nn;for lati = 1:64
   for loni = 1:72
      fl = length(latf(lati,loni).fire);
      for l = 1:fl
         nn(l) = length(latf(lati,loni).fire(l).latf);
         nt(lati,loni) = sum(nn);
         if nn(l) > 0
            alat(k:(k+nn(l)-1)) = latf(lati,loni).fire(l).latf;
            alon(k:(k+nn(l)-1)) = lonf(lati,loni).fire(l).lonf;
            asolzenf(k:(k+nn(l)-1)) = solzenf(lati,loni).fire(l).solzenf;
            amtimef(k:(k+nn(l)-1)) = mtimef(lati,loni).fire(l).mtimef;
            at1231(k:(k+nn(l)-1)) = t1231(lati,loni).fire(l).t1231;
            abt2616(k:(k+nn(l)-1)) = bt2616(lati,loni).fire(l).t2616;
%             abt1231(k:(k+nn(l)-1)) = bt_fire(lati,loni).fire(l).bt_fire(1520);
%             abt2616(k:(k+nn(l)-1)) = bt_fire(lati,loni).fire(l).bt_fire(2600);
%             k = k+nn(l) ;
         end
      end
      clear nn
   end
end
totaln = sum(nt(:));