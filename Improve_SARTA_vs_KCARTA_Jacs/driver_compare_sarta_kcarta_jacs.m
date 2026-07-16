addpath /home/sergio/git/matlabcode/COLORMAP

%% this makes DATA/v1/COMBINED/sarta_kcarta_1.mat ... DATA/v1/COMBINED/sarta_kcarta_660.mat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist('JOBB')
  JOB = str2num(getenv('SLURM_ARRAY_TASK_ID'));
else
  JOB = JOBB;
end

%JOB = input('enter JOB (default 1) : ');
%if length(JOB) == 0
%  JOB = 1;
%end  

filekcartaR = ['DATA/v1/KCARTA/individual_prof_convolved_kcarta_airs_' num2str(JOB) '.mat'];
filekcartaJ = ['DATA/v1/KCARTA/individual_prof_convolved_kcarta_airs_' num2str(JOB) '_jac.mat'];
filesartaJR = ['DATA/v1/SARTA/prof_' num2str(JOB) '.mat'];

%%%%%%%%%%%%%%%%%%%%%%%%%

sartajr = load(filesartaJR);
kcartar = load(filekcartaR);
kcartaj = load(filekcartaJ);

kcartaj.j1 = zeros(100,2378);
kcartaj.j3 = zeros(100,2378);
kcartaj.jT = zeros(100,2378);

[mm,nn] = size(kcartaj.rKc);
nlay = (nn-4)/4;
offset = 100-nlay;
kcartaj.j1((1:nlay)+offset,:) = kcartaj.rKc(1:2378,(1:nlay)+0*nlay)'; kcartaj.j1 = flipud(kcartaj.j1);
kcartaj.j3((1:nlay)+offset,:) = kcartaj.rKc(1:2378,(1:nlay)+1*nlay)'; kcartaj.j3 = flipud(kcartaj.j3);
kcartaj.jT((1:nlay)+offset,:) = kcartaj.rKc(1:2378,(1:nlay)+2*nlay)'; kcartaj.jT = flipud(kcartaj.jT);
kcartar.r   = kcartar.rKc(1:2378);
kcartar.f   = kcartar.fKc(1:2378);
kcartaj.jST = kcartaj.rKc(1:2378,4*nlay+1);

wah = 1:nlay;

iPlot = -1;
if iPlot > 0
  figure(1); clf;
    yyaxis left;  plot(kcartar.f,rad2bt(kcartar.f,kcartar.r),kcartar.f,rad2bt(kcartar.f,sartajr.px.rcalc))
    yyaxis right; plot(kcartar.f,rad2bt(kcartar.f,kcartar.r) - rad2bt(kcartar.f,sartajr.px.rcalc)); ylim([-1 +1]*0.1); grid on
  
  figure(2); clf; pcolor(kcartaj.j1(wah,:));                    shading interp; colorbar; colormap jet; cx = caxis;  title('kcarta')
  figure(3); clf; pcolor(sartajr.j1(wah,:));                    shading interp; colorbar; colormap jet; caxis(cx);   title('sarta')
  figure(4); clf; pcolor(sartajr.j1(wah,:)-kcartaj.j1(wah,:));  shading interp; colorbar; colormap(usa2); title('sarta-kcarta'); caxis([-1 +1]*0.05)
  
  figure(5); clf; pcolor(kcartaj.j3(wah,:));                    shading interp; colorbar; colormap jet; cx = caxis; title('kcarta')
  figure(6); clf; pcolor(sartajr.j3(wah,:));                    shading interp; colorbar; colormap jet; caxis(cx);  title('sarta')
  figure(7); clf; pcolor(sartajr.j3(wah,:)-kcartaj.jT(wah,:));  shading interp; colorbar; colormap(usa2); title('sarta-kcarta');  caxis([-1 +1]*0.05)
  
  figure(8); clf; pcolor(kcartaj.jT(wah,:));                    shading interp; colorbar; colormap jet; cx = caxis; title('kcarta')
  figure(9); clf; pcolor(sartajr.jT(wah,:));                    shading interp; colorbar; colormap jet; caxis(cx);  title('sarta')
  figure(10);clf; pcolor(sartajr.jT(wah,:)-kcartaj.jT(wah,:));  shading interp; colorbar; colormap(usa2); title('sarta-kcarta');  caxis([-1 +1]*0.05)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

final.kc.ST = kcartaj.jST';
final.kc.TZ  = kcartaj.jT;  final.kc.TZ(nlay+1:100,:) = NaN;
final.kc.g1 = kcartaj.j1;   final.kc.g1(nlay+1:100,:) = NaN;
final.kc.g3 = kcartaj.j3;   final.kc.g3(nlay+1:100,:) = NaN;
final.kc.r  = kcartar.r;
final.kc.f  = kcartar.f;
final.kc.nlay = nlay;

final.sa.ST = zeros(1,2378) ;    final.sa.ST        = sartajr.jT(max(wah)+1,:);
final.sa.TZ  = zeros(100,2378);  final.sa.TZ(wah,:) = sartajr.jT(wah,:);    final.sa.TZ(nlay+1:100,:) = NaN;
final.sa.g1  = zeros(100,2378);  final.sa.g1(wah,:) = sartajr.j1(wah,:);    final.sa.g1(nlay+1:100,:) = NaN;
final.sa.g3  = zeros(100,2378);  final.sa.g3(wah,:) = sartajr.j3(wah,:);    final.sa.g3(nlay+1:100,:) = NaN;
final.sa.r   = sartajr.px.rcalc;
final.sa.f   = sartajr.hx.vchan;
final.sa.i   = sartajr.hx.ichan;

disp('checks ...')
if iPlot > 0
  figure(1); clf;
    yyaxis left;  plot(final.kc.f,rad2bt(final.kc.f,final.kc.r),final.kc.f,rad2bt(final.kc.f,final.sa.r))
    yyaxis right; plot(final.kc.f,rad2bt(final.kc.f,final.kc.r) - rad2bt(final.kc.f,final.sa.r)); ylim([-1 +1]*0.1); grid on
  figure(4); clf; pcolor(final.sa.g1 - final.kc.g1); shading interp; colorbar; colormap(usa2); title('sarta-kcarta WV');	caxis([-1 +1]*0.05)
  figure(7); clf; pcolor(final.sa.g3 - final.kc.g3); shading interp; colorbar; colormap(usa2); title('sarta-kcarta OZ');	caxis([-1 +1]*0.05)
  figure(10);clf; pcolor(final.sa.TZ - final.kc.TZ); shading interp; colorbar; colormap(usa2); title('sarta-kcarta TZ');	caxis([-1 +1]*0.05)
  figure(11); clf;
    yyaxis left;  plot(final.kc.f,final.kc.ST,final.kc.f,final.sa.ST)
    yyaxis right; plot(final.kc.f,final.kc.ST - final.sa.ST); ylim([-1 +1]*0.1); grid on
  
  for ii = 2:10
    figure(ii); set(gca,'ydir','reverse');
  end  
end

saver = ['save DATA/v1/COMBINED/sarta_kcarta_' num2str(JOB) '.mat final'];
eval(saver)
