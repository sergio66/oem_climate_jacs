figure(1); 
  subplot(211); plot(wnum,trends.dbt_desc(:,16),wnum,squeeze(mean(ind_lons.b_desc(usethese,JOB,:),1)));         hl = legend('new zonal avg','old<avg>'); ylabel('trend'); title('desc');
  subplot(212); plot(wnum,trends.dbt_err_desc(:,16),wnum,squeeze(mean(ind_lons.b_err_desc(usethese,JOB,:),1))); hl = legend('new zonal avg','old<avg>'); ylabel('unc');;
figure(2); 
  subplot(211); plot(wnum,trends.dbt_asc(:,16),wnum,squeeze(mean(ind_lons.b_asc(usethese,JOB,:),1)));         hl = legend('new zonal avg','old<avg>'); ylabel('trend'); title('asc');
  subplot(212); plot(wnum,trends.dbt_err_asc(:,16),wnum,squeeze(mean(ind_lons.b_err_asc(usethese,JOB,:),1))); hl = legend('new zonal avg','old<avg>'); ylabel('unc');;

figure(3); 
  subplot(211); plot(wnum,trends.dbt_desc(:,16),wnum,squeeze(mean(ind_lons.b_desc(usethese,JOB,:),1)));                  hl = legend('new zonal avg','old<avg>'); ylabel('trend'); title('desc');
  subplot(212); plot(wnum,trends.dbt_err_desc(:,16),wnum,squeeze(mean(ind_lons.b_err_desc(usethese,JOB,:),1))/sqrt(72)); hl = legend('new zonal avg','old<avg>'); ylabel('unc/sqrt(N)');;
figure(4); 
  subplot(211); plot(wnum,trends.dbt_asc(:,16),wnum,squeeze(mean(ind_lons.b_asc(usethese,JOB,:),1)));                    hl = legend('new zonal avg','old<avg>'); ylabel('trend'); title('asc');
  subplot(212); plot(wnum,trends.dbt_err_asc(:,16),wnum,squeeze(mean(ind_lons.b_err_asc(usethese,JOB,:),1))/sqrt(72));   hl = legend('new zonal avg','old<avg>'); ylabel('unc/sqrt(N)');;

%% old individual nose/sqrt(72) gives you red curves in subplot(212), figure3,4
%% new noise is blue curves in subplot(212), figure3,4
%%  old individual nose/sqrt(Neff) = new noise       
%%  Neff = (old noise/new noise).^2

N = 72;

figure(5);  plot(wnum,ones(size(wnum))/sqrt(N),wnum,trends.dbt_err_asc(:,16)./squeeze(mean(ind_lons.b_err_asc(usethese,JOB,:),1)))   %% technically want to see if this is 1/sqrt(N) = 0.11
  sqrtNeff = squeeze(mean(ind_lons.b_err_asc(usethese,JOB,:),1))./trends.dbt_err_asc(:,16);
  Neff = sqrtNeff.^2;
  rho = 0.5*(N./Neff) - 1;
  rho = (N./Neff-1)*N/2;
  rho = (N./Neff -1)/(N-1);
figure(6); plot(wnum,Neff); title('Noise Reduction Neff instead of sqrt(N)')
figure(7);  plot(wnum,rho);  ylim([-2 +2]); title('Correlation'); ylim([0 5]);  ylim([0 +1]*1.03)


% figure(7); rho = 0.5*(N./Neff) - 1; plot(wnum,sqrt(2*(1+rho)/N),'go-',wnum,trends.dbt_err_asc(:,16)./squeeze(mean(ind_lons.b_err_asc(usethese,JOB,:),1)));
% figure(7); rho = 0.5*(N./Neff) - 1; plot(wnum,sqrt(2*(1+rho)/N).*squeeze(mean(ind_lons.b_err_asc(usethese,JOB,:),1)),'go-',wnum,trends.dbt_err_asc(:,16));
