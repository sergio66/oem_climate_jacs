for ilat = 1:46

   a = dir(['hotsub_lat' int2str(ilat) '_*.mat']);

   all_bt1231a = [];
   all_bt1231d = [];
   all_lat_a = [];
   all_lat_d = [];
   all_satzen_a = [];
   all_satzen_d = [];
   all_solzen_a = [];
   all_solzen_d = [];
   all_sst_a = [];
   all_sst_d = [];
   all_tai_a = [];
   all_tai_d = [];
   all_tsurf_a = [];
   all_tsurf_d = [];

   if length(a) > 0;

      for i = 1:length(a);
         load(a(i).name);
         
         bt1231a = bt1231a';
         bt1231d = bt1231d';
         tsurf_a = tsurf_a';
         tsurf_d = tsurf_d';   

         all_bt1231a = [all_bt1231a; bt1231a];
         all_bt1231d = [all_bt1231d; bt1231d];
         all_lat_a = [all_lat_a; lat_a ];
         all_lat_d = [all_lat_d; lat_d ];
         all_satzen_a = [all_satzen_a; satzen_a];
         all_satzen_d = [all_satzen_d; satzen_d];
         all_solzen_a = [all_solzen_a; solzen_a];
         all_solzen_d = [all_solzen_d; solzen_d];
         all_sst_a = [all_sst_a; sst_a];
         all_sst_d = [all_sst_d; sst_d];
         all_tai_a = [all_tai_a; tai_a];
         all_tai_d = [all_tai_d; tai_d];
         all_tsurf_a = [all_tsurf_a; tsurf_a];
         all_tsurf_d = [all_tsurf_d; tsurf_d];
      end;

      save(['all_ilat_' int2str(ilat)],'all_*_a','all_*_d','all_bt1231a','all_bt1231d');
   end
end
