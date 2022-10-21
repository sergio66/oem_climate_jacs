for i=1:422
   if length(fire(i).night) > 0
   if fire(i).night.solzenf > 95 
      latf(i) = fire(i).night.latf;
      lonf(i) = fire(i).night.lonf;
      mtimef(i) = fire(i).night.mtimef;
      bt_fire_2616(i) = fire(i).night.bt_fire(2600);
      bt_fire_1231(i) = fire(i).night.bt_fire(1520);
      t1231(i) = fire(i).night.t1231';
      satzenf(i) = fire(i).night.satzenf;
      solzenf(i) = fire(i).night.solzenf;
   end
   end
end
