function [prof,iNotOK,ibadlist] = check_for_errors(pin,cfracSet,iFixLoop)

iNotOK = 0;
prof = pin;
ibadlist = [];

iDebug = +1;  %% plot stuff
iDebug = -1;  %% do not plot stuff

%%%%%%%%%%%%%%%%%%%%%%%%%
cngmax = 500;
cngmax = 300;
oo = find(prof.cngwat > cngmax);
if length(oo) > 0
  fprintf(1,'found %5i profs with cngwat > %5i, resetting to that limit \n',length(oo),cngmax);
end  
prof.cngwat(oo) = cngmax;

oo = find(prof.cngwat2 > cngmax);
if length(oo) > 0
  fprintf(1,'found %5i profs with cngwat2 > %5i, resetting to that limit \n',length(oo),cngmax);
end  
prof.cngwat2(oo) = cngmax;

%%%%%%%%%%%%%%%%%%%%%%%%%
oo = find(prof.cngwat > 0 & prof.cfrac > 0 & prof.cprtop < 50);
if length(oo) > 0
  fprintf(1,'found %5i profs with cprtop < 50 mb, resetting that to 50 mb \n',length(oo));
end
junk = prof.cprbot(oo)-prof.cprtop(oo);
prof.cprtop(oo) = 50;
prof.cprbot(oo) = 50 + junk;

oo = find(prof.cngwat2 > 0 & prof.cfrac2 > 0 & prof.cprtop2 < 50);
if length(oo) > 0
  fprintf(1,'found %5i profs with cprtop2 < 50 mb, resetting that to 250 mb \n',length(oo));
end
junk = prof.cprbot2(oo)-prof.cprtop2(oo);
prof.cprtop2(oo) = 250;
prof.cprbot2(oo) = 250 + junk;

%%%%%%%%%%%%%%%%%%%%%%%%%

if cfracSet > 0
  ibad = find(prof.cngwat > 0 & prof.cfrac ~= cfracSet);
  ibadlist = [ibadlist ibad];
  fprintf(1,'  stage0 : fixing  %6i        ibad cfracs \n',length(ibad));
  prof.cfrac(ibad) = cfracSet;

  ibad = find(prof.cngwat2 > 0 & prof.cfrac2 ~= cfracSet);
  ibadlist = [ibadlist ibad];
  fprintf(1,'  stage0 : fixing  %6i        ibad cfracs \n',length(ibad));
  prof.cfrac2(ibad) = cfracSet;
end

%% cfrac checks
ibad = find(prof.cfrac12 > prof.cfrac | prof.cfrac12 > prof.cfrac2);
ibadlist = [ibadlist ibad];
iNotOK = iNotOK + length(ibad);
prof.cfrac12(ibad) = min(prof.cfrac(ibad), prof.cfrac2(ibad));
if iDebug > 0;
  fprintf(1,'  stage1 : fixing  %6i        ibad cfracs \n',length(ibad));
  plot_hists_cprtop_cprtop2; disp('ret to continue'); pause;
end

%% quick cngwat check
ibad = find(prof.cngwat < eps & prof.cfrac > eps);
prof.cprtop(ibad) = -9999;
prof.cprbot(ibad) = -9999;
prof.cngwat(ibad) = 0.0;
prof.cfrac(ibad) = 0.0;
prof.cfrac12(ibad) = 0.0;

%% quick cngwat check
ibad = find(prof.cngwat2 < eps & prof.cfrac2 > eps);
prof.cprtop2(ibad) = -9999;
prof.cprbot2(ibad) = -9999;
prof.cngwat2(ibad) = 0.0;
prof.cfrac2(ibad) = 0.0;
prof.cfrac12(ibad) = 0.0;

%% cfrac12 checks
cfrac1x  = prof.cfrac;
cfrac2x  = prof.cfrac2;
cfrac12x = prof.cfrac12;
ibad = find(cfrac1x + cfrac2x - cfrac12x > 1);
ibadlist = [ibadlist ibad];
iNotOK = iNotOK + length(ibad);
prof.cfrac12(ibad) = max(cfrac1x(ibad) + cfrac2x(ibad) - 1 + eps,0);
if iDebug > 0;
  fprintf(1,'  stage1B : fixing  %6i        ibad cfracs \n',length(ibad));
  plot_hists_cprtop_cprtop2; disp('ret to continue'); pause;
end

%% need cprtop > 0
ibad = find(prof.cprtop <= 0 & prof.cprbot > 0 & prof.cngwat > 0 & prof.cfrac > 0); %% ORIG
ibad = find(prof.cprtop <= 0 & prof.cngwat > 0 & prof.cfrac > 0);  %% NEW Nov 2017
ibadlist = [ibadlist ibad];
iNotOK = iNotOK + length(ibad);
prof.cprtop(ibad) = prof.cprtop(ibad) + 50.0;
prof.cprbot(ibad) = prof.cprbot(ibad) + 50.0;  %% ORIG
prof.cprbot(ibad) = prof.cprtop(ibad) + 50.0;  %% NEW Nov 2017
%% 
ibad2 = find(prof.cprtop2 <= 0 & prof.cprbot2 > 0); %% ORIG
ibad2 = find(prof.cprtop2 <= 0 & prof.cngwat2 > 0 & prof.cfrac2 > 0); %% NEW NOV 2017
ibadlist = [ibadlist ibad2];
iNotOK = iNotOK + length(ibad2);
prof.cprtop2(ibad2) = prof.cprtop2(ibad2) + 50.0;
prof.cprbot2(ibad2) = prof.cprbot2(ibad2) + 50.0;  %% ORIG
prof.cprbot2(ibad2) = prof.cprtop2(ibad2) + 50.0;  %% NEW Nov 2017
if iDebug > 0;
  fprintf(1,'  stage2 : fixing  %6i %6i ibad cprtop < 0, cprbot > 0 \n',length(ibad),length(ibad2));
  plot_hists_cprtop_cprtop2; disp('ret to continue'); pause;
end

%% need cprbot > 0, added Nov 14, 2014
ibad = find(prof.cprbot <= 0 & prof.cprtop > 0 & prof.cngwat > 0 & prof.cfrac > 0);
ibadlist = [ibadlist ibad];
iNotOK = iNotOK + length(ibad);
prof.cprbot(ibad) = prof.cprtop(ibad) + 50.0;
lala = prof.cprbot(ibad);
ibad2 = find(prof.cprbot2 <= 0 & prof.cprtop2 > 0);
ibadlist = [ibadlist ibad2];
iNotOK = iNotOK + length(ibad2);
prof.cprbot2(ibad2) = prof.cprtop2(ibad2) + 50.0;
if iDebug > 0;
  fprintf(1,'  stage2A :fixing  %6i %6i ibad cprbot < 0, cprtop > 0 \n',length(ibad),length(ibad2));
  plot_hists_cprtop_cprtop2; disp('ret to continue'); pause;
end

%% need cprbot < cprtop2 
%% need to be smart about this ... mebbe everything is OK, just need to swap the cloud fields
%% new, added Nov 15, 2014
ibadX = find(prof.cprbot >= prof.cprtop2 & prof.cprtop > 0 & prof.cprbot > 0 & prof.cprtop2 > 0 & prof.cngwat > 0 & prof.cngwat2 > 0);
if iDebug > 0
  fprintf(1,'  stage3X : fixing  %6i        ibad cprbot > cprtop2 \n',length(ibadX));
end
for ii = 1 : length(ibadX)
  if prof.cprtop(ibadX(ii)) < prof.cprbot(ibadX(ii)) & prof.cprtop2(ibadX(ii)) < prof.cprbot2(ibadX(ii)) & ...
     prof.cprbot(ibadX(ii)) > prof.cprtop2(ibadX(ii))
    %% everything ok, just need to swap fields
    ij = ibadX(ii);
%    junk1 = [prof.cprtop(ij)  prof.cprbot(ij)  prof.ctype(ij)  prof.cfrac(ij)  prof.cngwat(ij)  prof.cpsize(ij)];
%    junk2 = [prof.cprtop2(ij) prof.cprbot2(ij) prof.ctype2(ij) prof.cfrac2(ij) prof.cngwat2(ij) prof.cpsize2(ij)];
    junk1 = [prof.cprtop(ij)  prof.cprbot(ij)  prof.cfrac(ij)  prof.cngwat(ij)  prof.cpsize(ij)];
    junk2 = [prof.cprtop2(ij) prof.cprbot2(ij) prof.cfrac2(ij) prof.cngwat2(ij) prof.cpsize2(ij)];
    prof.cprtop(ij) = junk2(1);
    prof.cprbot(ij) = junk2(2);
%    prof.ctype(ij)  = junk2(3);
    prof.cfrac(ij)  = junk2(3);
    prof.cngwat(ij) = junk2(4);
    prof.cpsize(ij) = junk2(5);
    
    prof.cprtop2(ij) = junk1(1);
    prof.cprbot2(ij) = junk1(2);
%    prof.ctype2(ij)  = junk1(3);
    prof.cfrac2(ij)  = junk1(3);
    prof.cngwat2(ij) = junk1(4);
    prof.cpsize2(ij) = junk1(5);
    
    junk1 = prof.ctype(ij); junk2 = prof.ctype2(ij);
    prof.ctype(ij)  = junk2;
    prof.ctype2(ij)  = junk1;    
  end
end
ibad = find(prof.cprbot >= prof.cprtop2 & prof.cprtop > 0 & prof.cprbot > 0 & prof.cprtop2 > 0 & prof.cngwat > 0 & prof.cngwat2 > 0);
ibadlist = [ibadlist ibad];
iNotOK = iNotOK + length(ibad);
junk = prof.cprbot(ibad);
prof.cprbot(ibad) = prof.cprtop2(ibad)-10.0;
if iDebug > 0;
  plot_hists_cprtop_cprtop2; disp('ret to continue'); pause;
end

% need cprtop < spres
ibad = find(prof.cprtop >= prof.spres & prof.cprtop > 0);
ibadlist = [ibadlist ibad];
prof.cprtop(ibad) = prof.spres(ibad)-50.0;
ibad2 = find(prof.cprtop2 >= prof.spres & prof.cprtop2 > 0);
ibadlist = [ibadlist ibad2];
prof.cprtop2(ibad2) = prof.spres(ibad2)-50.0;
iNotOK = iNotOK + length(ibad) + length(ibad2);
if iDebug > 0;  
  fprintf(1,'  stage4 : fixing  %6i %6i ibad cprtop > spres \n',length(ibad),length(ibad2));
  plot_hists_cprtop_cprtop2; disp('ret to continue'); pause;
end

%% need cprbot < spres
ibad = find(prof.cprbot >= prof.spres & prof.cprbot > 0);
ibadlist = [ibadlist ibad];
prof.cprbot(ibad) = prof.spres(ibad)-25.0;
ibad2 = find(prof.cprbot2 >= prof.spres & prof.cprbot2 > 0);
ibadlist = [ibadlist ibad2];
prof.cprbot2(ibad2) = prof.spres(ibad2)-25.0;
iNotOK = iNotOK + length(ibad) + length(ibad2);
if iDebug > 0;
  fprintf(1,'  stage5 : fixing  %6i %6i ibad cprbot > spres \n',length(ibad),length(ibad2));
  plot_hists_cprtop_cprtop2; disp('ret to continue'); pause;
end

%% need cprtop < cprbot
ibad = find(prof.cprtop >= prof.cprbot & prof.cprtop > 0 & prof.cprbot > 0);
ibadlist = [ibadlist ibad];
if iFixLoop > 5
  prof.cprtop(ibad) = prof.cprbot(ibad)-25.0;
else
  prof.cprbot(ibad) = prof.cprtop(ibad)+25.0;
end
ibad2 = find(prof.cprtop2 >= prof.cprbot2 & prof.cprtop2 > 0 & prof.cprbot2 > 0);
ibadlist = [ibadlist ibad2];
if iFixLoop > 5
  prof.cprtop2(ibad2) = prof.cprbot2(ibad2)-25.0;
else
  prof.cprbot2(ibad) = prof.cprtop2(ibad)+25.0;
end
iNotOK = iNotOK + length(ibad) + length(ibad2);
if iDebug > 0;
  fprintf(1,'  stage6 : fixing  %6i %6i ibad cprtop > cprbot \n',length(ibad),length(ibad2));
  plot_hists_cprtop_cprtop2; disp('ret to continue'); pause;
end

ibadlist = unique(ibadlist);

%%%%%%%%%%%%%%%%%%%%%%%%%
if iFixLoop >= 10 & iNotOK > 0
  iVeryBadCnt = 0;
  %% if things aren't ok by now, do drastic measures!!!!
  fprintf(1,'iFixLoop >= 10, iNotOK == %4i getting desperate!!! \n',iNotOK)

  ibadX = find(prof.cprtop < 0 & prof.cfrac > 0 & prof.cngwat > 0);
  if length(ibadX) > 0
    iVeryBadCnt = iVeryBadCnt + length(iBadX);  
    fprintf(1,'desperate mode : found %4i prof.cprtop < 0 \n',length(ibadX));
    prof.cprtop(ibadX) = 10.0;
    prof.cprbot(ibadX) = 20.0;
    prof.cngwat(ibadX) = 0.0;
    prof.cfrac(ibadX) = 0.0;
    prof.cfrac12(ibadX) = 0.0;
 end

  ibadX = find(prof.cprtop > prof.spres);
  if length(ibadX) > 0
    iVeryBadCnt = iVeryBadCnt + length(iBadX);    
    fprintf(1,'desperate mode : found %4i prof.cprtop > prof.spres \n',length(ibadX));
    prof.cprtop(ibadX) = prof.spres(ibadX)-50.0;
    prof.cprbot(ibadX) = prof.spres(ibadX)-10.0;
    prof.cngwat(ibadX) = 0.0;
    prof.cfrac(ibadX) = 0.0;
    prof.cfrac12(ibadX) = 0.0;
 end

  ibadX = find(prof.cprtop2 < 0 & prof.cngwat2 > 0 & prof.cfrac2 > 0);
  if length(ibadX) > 0
    iVeryBadCnt = iVeryBadCnt + length(iBadX);    
    fprintf(1,'desperate mode : found %4i prof.cprtop2 < 0 \n',length(ibadX));
    prof.cprtop2(ibadX) = 10.0;
    prof.cprbot2(ibadX) = 20.0;
    prof.cngwat2(ibadX) = 0.0;
    prof.cfrac2(ibadX) = 0.0;
    prof.cfrac12(ibadX) = 0.0;
 end

  ibadX = find(prof.cprtop2 > prof.spres);
  if length(ibadX) > 0
    iVeryBadCnt = iVeryBadCnt + length(iBadX);    
    fprintf(1,'desperate mode : found %4i prof.cprtop2 > prof.spres \n',length(ibadX));
    prof.cprtop2(ibadX) = prof.spres(ibadX)-50.0;
    prof.cprbot2(ibadX) = prof.spres(ibadX)-10.0;
    prof.cngwat2(ibadX) = 0.0;
    prof.cfrac(ibadX) = 0.0;
    prof.cfrac12(ibadX) = 0.0;
 end

  ibadX = find(prof.cprbot >= prof.cprtop2 & prof.cprbot > 0 & prof.cprtop2 > 0);
  if length(ibadX) > 0
    iVeryBadCnt = iVeryBadCnt + length(iBadX);    
    fprintf(1,'desperate mode : found %4i prof.cprbot > prof.cprtop2, turn off lower cloud \n',length(ibadX));
    prof.cprtop2(ibadX) = -9999;
    prof.cprbot2(ibadX) = -9999;
    prof.cngwat2(ibadX) = 0.0;
    prof.cfrac2(ibadX) = 0.0;
    prof.cfrac12(ibadX) = 0.0;
  end
  fprintf(1,' >>> iFixLoop >= 10, iNotOK == %4i exiting getting desperate with %4i fixes \n',iNotOK,iVeryBadCnt)
  
end

if iDebug > 0;
  plot_hists_cprtop_cprtop2; disp('ret to continue'); pause;
end

