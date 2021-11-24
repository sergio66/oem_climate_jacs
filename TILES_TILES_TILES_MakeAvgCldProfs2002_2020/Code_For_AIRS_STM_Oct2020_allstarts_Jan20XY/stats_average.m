function [y] = stats_average(hoem,poem,latbins)

%% almost a copy of /home/sergio/MATLABCODE/CRODGERS_FAST_CLOUD/stats_average_equalarealatbins.m
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
  for ii = 1 : length(latbins)-1
    woo = find(poem.rlat > latbins(ii) & poem.rlat <= latbins(ii+1));
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
        else
          avg = nanmean(junk(:,woo),2);
          str = ['y.' xlist{jj} '(:,ii) = avg;'];		
        end
        eval(str)
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
        else
          avg = nanmean(junk(:,woo),2);
          str = ['y.' xlist{jj} '(:,ii) = avg;'];		
        end
        eval(str)      
      end  %% loop over elements in list
    end    %% if there are FOIVS in the latbis
  end      %% loop over latbins
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
  for ii = 1 : length(latbins)-1
    woo = find(poemX.rlat > latbins(ii) & poemX.rlat <= latbins(ii+1));
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
  end      %% loop over latbins
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'
