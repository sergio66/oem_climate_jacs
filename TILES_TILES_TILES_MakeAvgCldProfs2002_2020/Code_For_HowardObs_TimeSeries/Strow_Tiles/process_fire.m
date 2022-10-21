
for i=1:length(fire);
if ~isfield(fire(i),'night')
fp(i) = NaN;mtime(i) = NaT;
n(i) = NaN;
else
fp(i)=nanmean(fire(i).night.bt_fire(2600,:));
mtime(i) = nanmean(fire(i).night.mtimef);
fpm(i) = max(fire(i).night.bt_fire(2600,:));
fplw(i) = nanmean(fire(i).night.bt_fire(1520,:));
n(i) = length(fire(i).night.latf);
end
end





for i=1:length(fire);
if ~isfield(fire(i),'night')
fp(i) = NaN;mtime(i) = NaT;
n(i) = NaN;
else
fp(i)=nanmean(fire(i).night.bt_fire(2600,:));
mtime(i) = nanmean(fire(i).night.mtimef);
fpm(i) = max(fire(i).night.bt_fire(2600,:));
fplw(i) = nanmean(fire(i).night.bt_fire(1520,:));
n(i) = length(fire(i).night.latf);
end
end

