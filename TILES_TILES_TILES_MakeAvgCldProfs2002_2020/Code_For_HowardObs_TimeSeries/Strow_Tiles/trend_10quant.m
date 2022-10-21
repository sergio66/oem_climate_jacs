addpath ~/Matlab/Math
addpath /asl/matlib/time

load_fairs

tdir = '/asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_CORRECT_LatLon';

warning off
for lati = [16 50 64]
   lati
   lats = ['LatBin' sprintf('%02d',lati)];
   for loni = 1:32:72
      lons = ['LonBin' sprintf('%02d',loni)];
      fstr = ['summarystats_'  lats '_'  lons '_timesetps_001_412_V1'];
      fout = ['trend_' lats '_' lons 'v1'];
      fn = fullfile(tdir,lats,lons,fstr);
      load(fn);
      dtime = tai2dnum(airs2tai(tai93_desc));
      for i=1:412
         bt_desc(i,:,:) = rad2bt(fairs,squeeze(rad_quantile_desc(i,:,:)));
         bt_asc(i,:,:) = rad2bt(fairs,squeeze(rad_quantile_asc(i,:,:)));
      end
      for qi = 1:10
         qi
         for ni = 1:2645
            [ b be resid ] = Math_tsfit_lin_robust(dtime-dtime(1),squeeze(bt_desc(:,ni,qi)),4);
            b_desc(qi,ni,:) = b;
            b_desc_err(qi,ni,:) = be;
            l = xcorr(resid,1,'coeff');
            lag_desc(qi,ni) = l(1); 
            [ b be resid ] = Math_tsfit_lin_robust(dtime-dtime(1),squeeze(bt_asc(:,ni,qi)),4);
            b_asc(qi,ni,:) = b;
            b_asc_err(qi,ni,:) = be;
            l = xcorr(resid,1,'coeff');
            lag_asc(qi,ni) = l(1);
         end
      end
      save(fout,'b_desc', 'b_asc', 'b_desc_err', 'b_asc_err','lag_desc','lag_asc');
   end
end
warning on

