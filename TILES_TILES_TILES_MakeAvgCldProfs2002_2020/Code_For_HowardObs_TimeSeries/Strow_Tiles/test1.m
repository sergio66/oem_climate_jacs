for i=1:length(fire);
   if length(fire(i).day) == 0;
      fp(i) = NaN;mtime(i) = NaT;
      fpm(i) = NaN;
      fplw(i) = NaN;
      fplwm(i) = NaN;
      n(i) = NaN;
   else
      fp(i)=mean(fire(i).day.bt_fire(2600,:));
      mtime(i) = mean(fire(i).day.mtimef);
      fpm(i) = max(fire(i).day.bt_fire(2600,:));
      fplw(i) = mean(fire(i).day.bt_fire(1520,:));
      fplwm(i) = max(fire(i).day.bt_fire(1520,:));
      n(i) = length(fire(i).day.latf);
   end
end

