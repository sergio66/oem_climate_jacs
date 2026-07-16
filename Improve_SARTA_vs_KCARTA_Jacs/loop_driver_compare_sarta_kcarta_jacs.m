%% we played with 660 profiles
%% which is 83 ECM83 + 49 profiles, 5 times (CO2 = 370,285,...430 ppm)
%%  (83+49)*5 = 660

for JOBB = 1 : 660
  clear final kcarta* sarta*
  driver_compare_sarta_kcarta_jacs
end
