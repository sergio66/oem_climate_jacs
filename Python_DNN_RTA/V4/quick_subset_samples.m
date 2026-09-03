nSamples  = length(iFlag);

freq0          = freq_00;
emissivityRaw0 = emissivityRaw_00(iFlag,:);

O3  = O3_00(iFlag,:);
Q   = Q_00(iFlag,:);
T   = T_00(iFlag,:);
CO2 = CO2_00(iFlag,:);
CH4 = CH4_00(iFlag,:);  

T1 = dt1_00(iFlag,:);
T2 = dt2_00(iFlag,:);
T3 = dt3_00(iFlag,:);
T4 = dt4_00(iFlag,:);
T5 = dt5_00(iFlag,:);
T6 = dt6_00(iFlag,:);

Q1  = Wr1_00(iFlag,:);
Q2 = Wr2_00(iFlag,:);
Q3 = Wr3_00(iFlag,:);
Q4 = Wr4_00(iFlag,:);
Q5 = Wr5_00(iFlag,:);
Q6 = Wr6_00(iFlag,:);

O31 = Or1_00(iFlag,:);
O32 = Or2_00(iFlag,:);
O33 = Or3_00(iFlag,:);
O34 = Or4_00(iFlag,:);
O35 = Or5_00(iFlag,:);
O36 = Or6_00(iFlag,:);

ch4_500mb = ch4_500mb_00(iFlag);
co2_500mb = co2_500mb_00(iFlag);
n2o_500mb = n2o_500mb_00(iFlag);

surfPressure     = surfPressure_00(iFlag)';
surfTemp         = surfTemp_00(iFlag)';
localAngleSecant = localAngleSecant_00(iFlag,:)';
viewAngleSecant  = viewAngleSecant_00(iFlag,:)';

disp('WARNING : if you change from eg iJac = -1 to iJac = 101, cut and paste these next two lines')

if iJac == -1
  btRaw = planckBT(radianceRaw_00(iFlag,:), freq0);  %% these are rads changed to BT
  btRaw = btRaw - planckBT(usstd_rad',freq0);        %% these now have US STD rad removed       
else
  btRaw       = radianceRaw_00(iFlag,:);   %% these are dBT/dX so already in K/X units
end

btRaw0         = btRaw;
btTrueVal0     = btRaw;
