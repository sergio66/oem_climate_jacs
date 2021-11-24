  p16 = p16_0;

  p16 = time_series_tracegas(2,p16,ppmvLAY2,pavgLAY);
  p16 = time_series_tracegas(4,p16,ppmvLAY4,pavgLAY);
  p16 = time_series_tracegas(6,p16,ppmvLAY6,pavgLAY);
  p16 = time_series_tracegas(51,p16,ppmvLAY51,pavgLAY);
  p16 = time_series_tracegas(52,p16,ppmvLAY52,pavgLAY);

  [timeppmvLAY2,timeppmvAVG2,timeppmvMAX2,pavgLAY,tavgLAY,~,~] = layers2ppmv(h16,p16,1:length(p16.stemp),2);
  [timeppmvLAY4,timeppmvAVG4,timeppmvMAX4,pavgLAY,tavgLAY,~,~] = layers2ppmv(h16,p16,1:length(p16.stemp),4);
  [timeppmvLAY6,timeppmvAVG6,timeppmvMAX6,pavgLAY,tavgLAY,~,~] = layers2ppmv(h16,p16,1:length(p16.stemp),6);    
  [timeppmvLAY51,timeppmvAVG61,timeppmvMAX51,pavgLAY,tavgLAY,~,~] = layers2ppmv(h16,p16,1:length(p16.stemp),51);    
  [timeppmvLAY52,timeppmvAVG61,timeppmvMAX52,pavgLAY,tavgLAY,~,~] = layers2ppmv(h16,p16,1:length(p16.stemp),52);    

    figure(1);  plot(ppmvLAY2,1:97,'b',timeppmvLAY2,1:97,'r'); set(gca,'ydir','reverse'); title('CO2(time,z) profile')
      ax = axis; line([ax(1) ax(2)],[76 76],'color','k','linewidth',2);
    figure(2); plot(1:365,ppmvLAY2(76,:),'b',1:365,timeppmvLAY2(76,:),'r'); title('CO2 at 500 mb'); %% 500 mb

    %{
    figure(3);  plot(ppmvLAY4,1:97,'b',timeppmvLAY4,1:97,'r'); set(gca,'ydir','reverse'); title('N2O(time,z) profile')
      ax = axis; line([ax(1) ax(2)],[76 76],'color','k','linewidth',2);
    figure(4); plot(1:365,ppmvLAY4(76,:),'b',1:365,timeppmvLAY4(76,:),'r'); title('N2O at 500 mb'); %% 500 m

    figure(5);  plot(ppmvLAY6,1:97,'b',timeppmvLAY6,1:97,'r'); set(gca,'ydir','reverse'); title('CH4(time,z) profile')
      ax = axis; line([ax(1) ax(2)],[76 76],'color','k','linewidth',2);
    figure(6); plot(1:365,ppmvLAY6(76,:),'b',1:365,timeppmvLAY6(76,:),'r'); title('CH4 at 500 mb'); %% 500 mb
    %}
