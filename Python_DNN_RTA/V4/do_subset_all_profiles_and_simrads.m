if iALOTMP == 0
  iFlag = 1 : length(p.stemp);
  quick_subset_samples

elseif iALOTMP == 1
  iFlag = find(px.landfrac == 1);
  quick_subset_samples
  
elseif iALOTMP == 9
  %% sss = find(p.landfrac == 1);; ist(p.stemp(sss),100)
  iFlag = find(px.landfrac == 1 & p.stemp >= 240 & p.stemp <= 310);
  quick_subset_samples
  
elseif length(intersect(iALOTMP,[2 6 7 8 10])) == 1

  if iALOTMP == 2
    iFlag = find(px.landfrac == 0);
  elseif iALOTMP == 6
    iFlag = find(px.landfrac == 0 & abs(p.rlat) <= 30);
  elseif iALOTMP == 7
    iFlag = find(px.landfrac == 0 & abs(p.rlat) <= 60);
  elseif iALOTMP == 8
    iFlag = find(px.landfrac == 0 & abs(p.rlat) > 60);
  elseif iALOTMP == 10
    iFlag = find(px.landfrac == 0 & abs(p.rlat) <= 60 & p.stemp >= 273 & p.stemp < 305);
  end
  quick_subset_samples
  
end

whos freq0 emissivityRaw0  btRaw radianceRaw_00 T Q co2_500mb surfTemp localAngleSecant
