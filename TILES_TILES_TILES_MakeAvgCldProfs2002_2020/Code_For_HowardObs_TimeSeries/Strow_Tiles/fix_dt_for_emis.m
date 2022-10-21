load_fairs
load emiss1231
rho = mean_emiss_allyears;

load  quantv1_tsurf_global_fits_susskind_times.mat

for ilat = 1:64
   for ilon = 1:72
      r1 = bt2rad(fairs(1520),squeeze(b_desc(ilat,ilon,1)));
      r2 = r1*0.95/rho(ilat,ilon);
      true_t = rad2bt(fairs(1520),r2);

      r1 = bt2rad(fairs(1520),squeeze(b_desc(ilat,ilon,1) + squeeze(b_desc(ilat,ilon,2))));
      r2 = r1*0.95/rho(ilat,ilon);
      true_tc = rad2bt(fairs(1520),r2);

      true_tsurf_desc(ilat,ilon) = true_t;
      true_dtsurf_desc(ilat,ilon) = true_tc - true_t;

      r1 = bt2rad(fairs(1520),squeeze(b_asc(ilat,ilon,1)));
      r2 = r1*0.95/rho(ilat,ilon);
      true_t = rad2bt(fairs(1520),r2);

      r1 = bt2rad(fairs(1520),squeeze(b_asc(ilat,ilon,1) + squeeze(b_asc(ilat,ilon,2))));
      r2 = r1*0.95/rho(ilat,ilon);
      true_tc = rad2bt(fairs(1520),r2);

      true_tsurf_asc(ilat,ilon) = true_t;
      true_dtsurf_asc(ilat,ilon) = true_tc - true_t;

   end
end

%  save true_tsurf_dtsurf  true_tsurf_asc true_dtsurf_asc true_tsurf_desc true_dtsurf_desc