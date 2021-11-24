function [y] = stats_average_T_WV_grid_uniquemonths(hoem,poem,thebins,latbinsORmonthbins)

%% if latbinsORmonthbins == +1 then length(thebins) = 65 of them (so 64 latbins) from -90 to +90
%% if latbinsORmonthbins == -1 then length(thebins) = 13 of them (so 12 months)  from  01 to  13

if nargin == 3
  latbinsORmonthbins = 1;
end

poem.ptemp(poem.ptemp < 100) = NaN;
poem.gas_1(poem.gas_1 < 100) = NaN;
poem.gas_2(poem.gas_2 < 100) = NaN;
poem.gas_3(poem.gas_3 < 100) = NaN;

[yyyxx,mmmxx,dddxx,hhhxx] = tai2utcSergio(poem.rtime);

%% almost a copy of /home/sergio/MATLABCODE/CRODGERS_FAST_CLOUD/stats_average_equalareathebins.m
addpath /home/sergio/MATLABCODE/matlib/clouds/sarta
addpath /home/sergio/MATLABCODE/PLOTTER

%[hoem,poem] = subset_rtp_allcloudfields(hoem,poem,[],[],yes);

general_list  = {'ptime','plat','plon','rtime','rlat','rlon','salti','landfrac','wspeed','satzen','scanang','solzen'};  
     %% can have negative lats/lons
emis_list     = {'nemis','efreq','emis','rho'};                                             %% everything positive

if hoem.pfields == 7 | isfield(poem,'robs1')
  radiance_list = {'robs1','rcalc','sarta_rclearcalc'};                                       %% everything positive
elseif hoem.pfields == 3 | ~isfield(poem,'robs1')
  radiance_list = {'rcalc','sarta_rclearcalc'};                                       %% everything positive
end

%radiance_list = {'rcalc','sarta_rclearcalc'};                                       %% everything positive

profile_list  = {'spres','nlevs','plevs','stemp','ptemp','gas_1','gas_2','gas_3','gas_4','gas_5','gas_6','gas_9','gas_12','mmw'};          %% everything positive
profile_list  = {'spres','nlevs','plevs','stemp','ptemp','gas_1','gas_2','gas_3','gas_4','gas_5','gas_6','gas_9','gas_12','mmw','palts'};  %% everything positive

cloud_list    = {'cprtop','cprbot','cngwat','cpsize','cfrac','ctype','cprtop2','cprbot2','cngwat2','cpsize2','cfrac2','ctype2','cfrac12'}; %% even more complicated

%cloud_listI   = {'cprtop','cprbot','cngwat','cpsize','cfrac','ctype'};
%cloud_listW   = {'cprtop2','cprbot2','cngwat2','cpsize2','cfrac2','ctype2'};
cloud_listI   = {'icewaterfrac','icectype','icecngwat','iceOD','icetop','icebot','icesze','icefrac','icetopT'};
cloud_listW   = {'waterctype','watercngwat','waterOD','watertop','waterbot','watersze','waterfrac','watertopT'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

all_list = {'general_list','emis_list','radiance_list','profile_list'};
all_list = {'general_list','emis_list','radiance_list','profile_list','cloud_list'};

for aa = 1 : length(all_list);
  xlist = all_list{aa};
  %fprintf(1,'doing %s \n',xlist);
  if aa == 1
    xlist = general_list;
  elseif aa == 2
    xlist = emis_list;
  elseif aa == 3
    xlist = radiance_list;
  elseif aa == 4
    xlist = profile_list;
  elseif aa == 5
    xlist = cloud_list;
  end

  for ii = 1 : length(thebins)-1
    if latbinsORmonthbins == 1
      woo = find(poem.rlat > thebins(ii) & poem.rlat <= thebins(ii+1));
    else
      woo = find(ii == mmmxx); 
    end
    %fprintf(1,'%2i %3i %2i \n',[ii length(woo) -1])
    if length(woo) > 0
      for jj = 1 : length(xlist)
        str = ['junk = poem.' xlist{jj} ';'];
        eval(str);
        [mm,nn] = size(junk);
	if aa > 1
	  bad = find(junk <= 0); junk(bad) = NaN;
	end
        if mm == 1
          avg = nanmean(junk(woo));
          str = ['y.' xlist{jj} '(ii) = avg;'];	
          eval(str)          
          if strcmp(xlist{jj},'stemp')
            boo = nanstd(junk(woo)); strx = ['y.std_' xlist{jj} '(ii) = boo;'];	eval(strx);
            boo = nanmin(junk(woo)); strx = ['y.min_' xlist{jj} '(ii) = boo;'];	eval(strx);
            boo = nanmax(junk(woo)); strx = ['y.max_' xlist{jj} '(ii) = boo;'];	eval(strx);
          end
        else
          avg = nanmean(junk(:,woo),2);
          str = ['y.' xlist{jj} '(:,ii) = avg;'];		
          eval(str)
          if strcmp(xlist{jj},'ptemp') | strcmp(xlist{jj},'gas_1') | strcmp(xlist{jj},'gas_3')
            boo = nanstd(double(junk(:,woo)),0,2); boo = single(boo); strx = ['y.std_' xlist{jj} '(:,ii) = boo;'];	 eval(strx);
            boo = nanmin(junk(:,woo),[],2); strx = ['y.min_' xlist{jj} '(:,ii) = boo;']; eval(strx);
            boo = nanmax(junk(:,woo),[],2); strx = ['y.max_' xlist{jj} '(:,ii) = boo;']; eval(strx);
          end
        end
      end
    else
      for jj = 1 : length(xlist)
        str = ['junk = poem.' xlist{jj} ';'];
        eval(str);
        [mm,nn] = size(junk);
        junk = nan * junk;
        if mm == 1
          avg = nanmean(junk(woo));
          str = ['y.' xlist{jj} '(ii) = avg;'];		
          eval(str)      
          if strcmp(xlist{jj},'stemp')
            boo = nanstd(junk(woo)); strx = ['y.std_' xlist{jj} '(ii) = boo;'];	eval(strx);
            boo = nanmin(junk(woo)); strx = ['y.min_' xlist{jj} '(ii) = boo;'];	eval(strx);
            boo = nanmax(junk(woo)); strx = ['y.max_' xlist{jj} '(ii) = boo;'];	eval(strx);
          end
        else
          avg = nanmean(junk(:,woo),2);
          str = ['y.' xlist{jj} '(:,ii) = avg;'];		
          eval(str)      
          if strcmp(xlist{jj},'ptemp') | strcmp(xlist{jj},'gas_1') | strcmp(xlist{jj},'gas_3')
            boo = nanstd(double(junk(:,woo)),0,2); boo = single(boo); strx = ['y.std_' xlist{jj} '(:,ii) = boo;'];	 eval(strx);
            boo = nanmin(junk(:,woo),[],2); strx = ['y.min_' xlist{jj} '(:,ii) = boo;']; eval(strx);
            boo = nanmax(junk(:,woo),[],2); strx = ['y.max_' xlist{jj} '(:,ii) = boo;']; eval(strx);
          end
        end
      end  %% loop over elements in list
    end    %% if there are FOIVS in the latbis
  end      %% loop over thebins
end        %% loop over lists

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
%% cloudlist is the hardest
for aa = 1 : 2;
  if aa == 1
    xlist = cloud_listI;
%    fprintf(1,'doing %s \n','cloud_list ICE');
%    poemX = poemice;
    poemX = poem;
  elseif aa == 2
    xlist = cloud_listW;
%    fprintf(1,'doing %s \n','cloud_list WATER');
%    poemX = poemwater;    
    poemX = poem;    
  end
  for ii = 1 : length(thebins)-1
    if latbinsORmonthbins == 1
      woo = find(poem.rlat > thebins(ii) & poem.rlat <= thebins(ii+1));
    else
      woo = find(ii == mmmxx); 
    end
    %fprintf(1,'%2i %3o %2i \n',[ii length(woo) +1])
    if length(woo) > 0
      for jj = 1 : length(xlist)
        str = ['junk = poemX.' xlist{jj} ';'];
        eval(str);
        [mm,nn] = size(junk);
        bad = find(junk <= 0); junk(bad) = NaN;
        if mm == 1
          avg = nanmean(junk(woo));
          str = ['y.' xlist{jj} '(ii) = avg;'];	
        else
          avg = nanmean(junk(:,woo),2);
          str = ['y.' xlist{jj} '(:,ii) = avg;'];		
        end
        eval(str)
      end
    else
      for jj = 1 : length(xlist)
        str = ['junk = poemX.' xlist{jj} ';'];
        eval(str);
        [mm,nn] = size(junk);
        junk = nan * junk;
        if mm == 1
          avg = nanmean(junk(woo));
          str = ['y.' xlist{jj} '(ii) = avg;'];		
        else
          avg = nanmean(junk(:,woo),2);
          str = ['y.' xlist{jj} '(:,ii) = avg;'];		
        end
        eval(str)      
      end  %% loop over elements in list
    end    %% if there are FOIVS in the latbis
  end      %% loop over thebins
end        %% loop over lists

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'

y.nlevs = floor(y.nlevs);

y.cprtop = y.icetop;
y.cprbot = y.icebot;
y.cfrac  = y.icefrac;
y.cpsize = y.icesze;
y.cngwat = y.icecngwat;
y.ctype  = y.icectype;
y.cfrac12 = y.icewaterfrac;

oo = find(~isfinite(y.cfrac12));
  y.cfrac12(oo) = 0.0;       y.icewaterfrac(oo) = 0;
  y.ctype2(oo) = -9999;       y.waterctype(oo)    = -9999;
  y.cngwat2(oo) = 0.0;        y.watercngwat(oo)   = 0;       y.waterOD(oo) = 0;
  y.cfrac2(oo) = 0.0;         y.waterfrac(oo)     = 0;
  y.cpsize2(oo) = 0.0;        y.watersze(oo)      = 0;
  y.cprtop2(oo) = -9999;      y.watertop(oo)      = -9999;   y.watertopT(oo) = -9999;
  y.cprbot2(oo) = -9999;      y.waterbot(oo)      = -9999;

oo = find(~isfinite(y.ctype) | ~isfinite(y.cngwat) | ~isfinite(y.cprtop) | ~isfinite(y.cprbot) | ~isfinite(y.cpsize));
  y.ctype(oo) = -9999;       y.icectype(oo)  = -9999;
  y.cngwat(oo) = 0.0;        y.icecngwat(oo) = 0;       y.iceOD(oo) = 0;
  y.cfrac(oo) = 0.0;         y.icefrac(oo)   = 0;
  y.cpsize(oo) = 0.0;        y.icesze(oo)    = 0;
  y.cprtop(oo) = -9999;      y.icetop(oo)    = -9999;   y.icetopT(oo) = -9999;
  y.cprbot(oo) = -9999;      y.icebot(oo)    = -9999;
  y.cfrac12(oo) = 0.0;       y.icewaterfrac(oo) = 0;

y.cprtop2 = y.watertop;
y.cprbot2 = y.waterbot;
y.cfrac2  = y.waterfrac;
y.cpsize2 = y.watersze;
y.cngwat2 = y.watercngwat;
y.ctype2  = y.waterctype;
y.cfrac12 = y.icewaterfrac;
oo = find(~isfinite(y.ctype2) | ~isfinite(y.cngwat2) | ~isfinite(y.cprtop2) | ~isfinite(y.cprbot2) | ~isfinite(y.cpsize2));
  y.ctype2(oo) = -9999;       y.waterctype(oo)    = -9999;
  y.cngwat2(oo) = 0.0;        y.watercngwat(oo)   = 0;       y.waterOD(oo) = 0;
  y.cfrac2(oo) = 0.0;         y.waterfrac(oo)     = 0;
  y.cpsize2(oo) = 0.0;        y.watersze(oo)      = 0;
  y.cprtop2(oo) = -9999;      y.watertop(oo)      = -9999;   y.watertopT(oo) = -9999;
  y.cprbot2(oo) = -9999;      y.waterbot(oo)      = -9999;
  y.cfrac12(oo) = 0.0;        y.icewaterfrac(oo)  = 0;

oo = find(y.cfrac12 >= y.cfrac | y.cfrac12 >= y.cfrac2);
  y.cfrac12(oo) = max(min(y.cfrac(oo),y.cfrac2(oo))-100*eps,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1); plot(1:12,y.stemp,'b',1:12,y.min_stemp,1:12,y.max_stemp,1:12,y.stemp+y.std_stemp,'b--',1:12,y.stemp-y.std_stemp,'b--')
figure(2); plot(y.ptemp,1:101,'b',y.min_ptemp,1:101,'r',y.max_ptemp,1:101,'r',y.ptemp+y.std_ptemp,1:101,'b--',y.ptemp-y.std_ptemp,1:101,'b--'); set(gca,'ydir','reverse')
figure(3); semilogx(y.gas_1,1:101,'b',y.min_gas_1,1:101,'r',y.max_gas_1,1:101,'r',y.gas_1+y.std_gas_1,1:101,'b--',y.gas_1-y.std_gas_1,1:101,'b--'); set(gca,'ydir','reverse')
figure(4); semilogx(y.gas_3,1:101,'b',y.min_gas_3,1:101,'r',y.max_gas_3,1:101,'r',y.gas_3+y.std_gas_3,1:101,'b--',y.gas_3-y.std_gas_3,1:101,'b--'); set(gca,'ydir','reverse')
for ii = 1 : 12
  figure(2); plot(y.ptemp(:,ii),1:101,'b',y.min_ptemp(:,ii),1:101,'r',y.max_ptemp(:,ii),1:101,'r',y.ptemp(:,ii)+y.std_ptemp(:,ii),1:101,'b--',y.ptemp(:,ii)-y.std_ptemp(:,ii),1:101,'b--'); set(gca,'ydir','reverse')
  figure(3); semilogx(y.gas_1(:,ii),1:101,'b',y.min_gas_1(:,ii),1:101,'r',y.max_gas_1(:,ii),1:101,'r',y.gas_1(:,ii)+y.std_gas_1(:,ii),1:101,'b--',y.gas_1(:,ii)-y.std_gas_1(:,ii),1:101,'b--'); set(gca,'ydir','reverse')
  figure(4); semilogx(y.gas_3(:,ii),1:101,'b',y.min_gas_3(:,ii),1:101,'r',y.max_gas_3(:,ii),1:101,'r',y.gas_3(:,ii)+y.std_gas_3(:,ii),1:101,'b--',y.gas_3(:,ii)-y.std_gas_3(:,ii),1:101,'b--'); set(gca,'ydir','reverse')
  pause(0.1);
end

daoff = [];
da3Toff  = [];
da3g1off = [];
da3g3off = [];
repx0 = 6;
for repx = 1 : repx0
  for ii = 1 : 12
    truemin = y.min_ptemp(:,ii); truemax = y.max_ptemp(:,ii);
    fakemin = y.ptemp(:,ii)-y.std_ptemp(:,ii); 
    fakemax = y.ptemp(:,ii)+y.std_ptemp(:,ii); 
      off = find(abs(truemin-truemax) < 1e-3); 
        y.min_ptemp(off,ii) = y.min_ptemp(off,ii)-0.1;
        y.max_ptemp(off,ii) = y.max_ptemp(off,ii)+0.1;
        y.std_ptemp(off,ii) = 0.05;

    truemin = y.min_ptemp(:,ii); truemax = y.max_ptemp(:,ii);
    fakemin = y.ptemp(:,ii)-y.std_ptemp(:,ii); 
    fakemax = y.ptemp(:,ii)+y.std_ptemp(:,ii); 
      off = find(fakemin < truemin); y.std_ptemp(off,ii) = y.std_ptemp(off,ii)*0.75; daoff = [daoff; off]; if repx == repx0; keyboard_nowindow; da3Toff = [da3Toff; off]; end
      off = find(fakemax > truemax); y.std_ptemp(off,ii) = y.std_ptemp(off,ii)*0.75; daoff = [daoff; off]; if repx == repx0; keyboard_nowindow; da3Toff = [da3Toff; off]; end
  
    truemin = y.min_gas_1(:,ii); truemax = y.max_gas_1(:,ii);
    fakemin = y.gas_1(:,ii)-y.std_gas_1(:,ii); 
    fakemax = y.gas_1(:,ii)+y.std_gas_1(:,ii); 
      off = find(fakemin < truemin); y.std_gas_1(off,ii) = y.std_gas_1(off,ii)*0.75;  daoff = [daoff; off]; if repx == repx0; da3g1off = [da3g1off; off]; end
      off = find(fakemax > truemax); y.std_gas_1(off,ii) = y.std_gas_1(off,ii)*0.75;  daoff = [daoff; off]; if repx == repx0; da3g1off = [da3g1off; off]; end
  
    truemin = y.min_gas_3(:,ii); truemax = y.max_gas_3(:,ii);
    fakemin = y.gas_3(:,ii)-y.std_gas_3(:,ii); 
    fakemax = y.gas_3(:,ii)+y.std_gas_3(:,ii); 
      off = find(fakemin < truemin); y.std_gas_3(off,ii) = y.std_gas_3(off,ii)*0.75;  daoff = [daoff; off]; if repx == repx0; da3g3off = [da3g3off; off]; end
      off = find(fakemax > truemax); y.std_gas_3(off,ii) = y.std_gas_3(off,ii)*0.75;  daoff = [daoff; off]; if repx == repx0; da3g3off = [da3g3off; off]; end
  end
end
  
[length(daoff) length(da3Toff) length(da3g1off) length(da3g3off)]
for ii = 1 : 12
  figure(2); plot(y.ptemp(:,ii),1:101,'b',y.min_ptemp(:,ii),1:101,'r',y.max_ptemp(:,ii),1:101,'r',y.ptemp(:,ii)+y.std_ptemp(:,ii),1:101,'b--',y.ptemp(:,ii)-y.std_ptemp(:,ii),1:101,'b--'); set(gca,'ydir','reverse')
  figure(3); semilogx(y.gas_1(:,ii),1:101,'b',y.min_gas_1(:,ii),1:101,'r',y.max_gas_1(:,ii),1:101,'r',y.gas_1(:,ii)+y.std_gas_1(:,ii),1:101,'b--',y.gas_1(:,ii)-y.std_gas_1(:,ii),1:101,'b--'); set(gca,'ydir','reverse')
  figure(4); semilogx(y.gas_3(:,ii),1:101,'b',y.min_gas_3(:,ii),1:101,'r',y.max_gas_3(:,ii),1:101,'r',y.gas_3(:,ii)+y.std_gas_3(:,ii),1:101,'b--',y.gas_3(:,ii)-y.std_gas_3(:,ii),1:101,'b--'); set(gca,'ydir','reverse')
  pause(0.1);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
