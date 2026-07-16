iX = 0;
for jj = 1 : 64
  for ii = 1 : 72
    iX = iX + 1;
    p.rlon(iX) = x(ii);
    p.rlat(iX) = y(jj);
    p.stemp(iX) = 300 + -abs(p.rlat(iX));
  end
end
load /home/sergio/git/matlabcode/h2645structure.mat
junk = load('/home/sergio/git/oem_climate_jacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries//asc_desc_solzen_time_525_64x72.mat','thedata');
thedata = junk.thedata; clear junk

emis_lf = load('/home/sergio/git/oem_climate_jacs/TILES_TILES_TILES_MakeAvgCldProfs2002_2020/Code_For_HowardObs_TimeSeries/tile_avg_salti_lf_emis.mat');
p.landfrac = emis_lf.landfrac;
p.salti    = emis_lf.salti;  
p.nemis    = emis_lf.nemis;
p.emis     = emis_lf.emis;  
p.efreq    = emis_lf.efreq;
p.rho      = emis_lf.rho;
p.zobs = ones(size(p.stemp)) * 705000;
if iDorA > 0
  junk = thedata.satzen_desc;
  junk = reshape(junk,4608,526);
  p.satzen = nanmean(junk,2)';
  junk = thedata.solzen_desc;
  junk = reshape(junk,4608,526);
  p.solzen = nanmean(junk,2)';
else
  junk = thedata.satzen_asc;
  junk = reshape(junk,4608,526);
  p.satzen = nanmean(junk,2)';
  junk = thedata.solzen_asc;
  junk = reshape(junk,4608,526);
  p.solzen = nanmean(junk,2)';
end
p.scanang = saconv(p.satzen,p.zobs);

scatter_coast(p.rlon,p.rlat,50,p.nemis)
scatter_coast(p.rlon,p.rlat,50,p.salti)
scatter_coast(p.rlon,p.rlat,50,p.landfrac)
scatter_coast(p.rlon,p.rlat,50,p.stemp)  
