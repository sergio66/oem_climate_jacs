function rcris_all = cris_sinc2hamming(frqLW,frqMW,frqSW,rcris_all0)

iNew = -1; %% do it sergio way
iNew = +1; %% do it howard way

if iNew < 0
  % old way

  [aaCrIS,bbCrIS] = size(rcris_all0);
  %% coeffs are [0.23 0.54 0.23]
  wah = zeros(size(rcris_all));
  for ichan = 2:aaCrIS-1
    wah(ichan,:) = 0.23 * rcris_all0(ichan-1,:) + 0.54 * rcris_all0(ichan,:) + 0.23 * rcris_all0(ichan+1,:);
  end

  if usejava('jvm')
    plot(fcris,rcris_all0,'b',fcris,wah,'r')
  else
    disp('no jvm cannot plot!!!!')
  end

  xrcris_all = wah;
  rcris_all = wah;

else
  %new way
  addpath /asl/packages/airs_decon/source
  band1 = 1 : length(frqLW); band1 = band1 + 0;
  band2 = 1 : length(frqMW); band2 = band2 + length(band1);
  band3 = 1 : length(frqSW); band3 = band3 + length(band1) + length(band2);
  %wah = [band1 band2 band3]; plot(wah-(1:length(fcris))); setdiff(1:length(fcris),wah); sum(wah-(1:length(fcris)))   %% check everything ok
  %[band1(1) band1(end) band2(1) band2(end) band3(1) band3(end)]

  aa = rcris_all0(band1,:); aa = hamm_app(aa);
  bb = rcris_all0(band2,:); bb = hamm_app(bb);
  cc = rcris_all0(band3,:); cc = hamm_app(cc);

  yrcris_all = [aa; bb; cc];
  rcris_all = [aa; bb; cc];

end
