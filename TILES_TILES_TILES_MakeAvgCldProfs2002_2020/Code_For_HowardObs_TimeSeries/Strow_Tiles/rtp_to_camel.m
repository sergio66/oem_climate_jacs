% Read in rtp file

k = find(pe.landfrac ==1);

p.efreq = NaN(3,length(p.rtime));
p.emis = NaN(3,length(p.rtime));
p.rho = NaN(3,length(p.rtime));
p.nemis = NaN(1,length(p.rtime));

>> emis = p.emis(39,k);
Ind

dtime = tai2dnum(p.rtime);
dv = datevec(dtime);
dv(:,1) = 2007;
dtime2007 = datenum(dv);
p.rtime = dnum2tai(dtime2007);

[pe,bad_emis,iaDone] = hsr_camel_main_rtp(p);