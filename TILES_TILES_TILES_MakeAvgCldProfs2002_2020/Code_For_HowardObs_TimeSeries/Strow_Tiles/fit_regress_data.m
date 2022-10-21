%  load regr_data  % pg structure

%  JUST DO LANDFRAC == 0 pts in pg(i,j)

p = NaN(64,72,2);

for i = 1:64
   i
   for j = 1:72
      k = pg(i,j).landfrac == 0;
   
      btclr_1228 = rad2bt(fairs(1513),pg(i,j).rclr_1228(k));
      btclr_1231 = rad2bt(fairs(1520),pg(i,j).rclr_1231(k));
%       btclr_2616 = rad2bt(fairs(2600),pg(i,j).rclr_2600(k));
      
      tcorr = pg(i,j).stemp(k)-btclr_1231;
      dt    = btclr_1228-btclr_1231;
      emis  = pg(i,j).emis_1231(k);

      y = tcorr';
%      X = [ones(size(y)) 1-emis' dt'];
      X = [ones(size(y))  dt' (dt.^2)'];

%      [b(i,j,:,:) bint(i,j,:,:,:) r ]= regress(y,X);

if length(dt) > 10;

      p(i,j,:) = polyfit(dt',y,1);
      yc = polyval(squeeze(p(i,j,:)),dt');
           
      r = y-yc;
else
   r = NaN;
end
resid_std(i,j) = nanstd(r);
resid_mean(i,j) = nanmean(r);
      tcorr_mean(i,j) = nanmean(tcorr);

% Now do SW
      
      emis  = pg(i,j).emis_2616(k);

     btclr_2616 = rad2bt(fairs(2600),pg(i,j).rclr_2616(k));
      tcorr_sw = pg(i,j).stemp(k)-btclr_2616;
      y_sw = tcorr';
%      X = [ones(size(y)) 1-emis' dt'];
%      X = [ones(size(y))  dt' (dt.^2)'];

%      [b(i,j,:,:) bint(i,j,:,:,:) r ]= regress(y,X);

if length(dt) > 10;

      p_sw(i,j,:) = polyfit(dt',y_sw,1);
      yc_sw = polyval(squeeze(p(i,j,:)),dt');
           
      r_sw = y_sw-yc_sw;
else
   r_sw = NaN;
end
      resid_std_sw(i,j) = nanstd(r_sw);
      tcorr_mean_sw(i,j) = nanmean(tcorr_sw);


      
   end
end

% % Now try using satzen instead of emis over ocean
% 
% for i = 1:64
%    i
%    for j = 1:72
% 
%       if glf(i,j) < 0.2
% 
%          btclr_1228 = rad2bt(fairs(1513),pg(i,j).rclr_1228);
%          btclr_1231 = rad2bt(fairs(1520),pg(i,j).rclr_1231);
%          
%          tcorr = pg(i,j).stemp-btclr_1231;
%          dt    = btclr_1228-btclr_1231;
%          satzen = pg(i,j).satzen;
% 
%          y = tcorr';
% %      X = [ones(size(y)) 1-emis' dt'];
%          X = [ones(size(y)) secd(satzen)' dt'];
% 
%          [b(i,j,:) bint(i,j,:,:) r ]= regress(y,X);
% 
%          resid_std(i,j) = nanstd(r);
%          tcorr_mean(i,j) = nanmean(tcorr);
%       end
%    end
% end
% 
