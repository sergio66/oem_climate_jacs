function [y] = stats_average(hoem,poem,latbins)

%% almost a copy of /home/sergio/MATLABCODE/CRODGERS_FAST_CLOUD/stats_average_equalarealatbins.m
addpath /home/sergio/MATLABCODE/matlib/clouds/sarta
addpath /home/sergio/MATLABCODE/PLOTTER

%[hoem,poem] = subset_rtp_allcloudfields(hoem,poem,[],[],yes);

general_list  = {'ptime','plat','plon','rtime','rlat','rlon','salti','landfrac','wspeed'};  %% can have negative lats/lons
emis_list     = {'nemis','efreq','emis','rho'};                                             %% everything positive
%radiance_list = {'robs1','rcalc','sarta_rclearcalc'};                                       %% everything positive
radiance_list = {'rcalc','sarta_rclearcalc'};                                       %% everything positive
profile_list  = {'spres','nlevs','plevs','stemp','ptemp','gas_1','gas_2','gas_3','gas_4','gas_5','gas_6','gas_9','gas_12','mmw'};          %% everything positive
cloud_list    = {'cprtop','cprbot','cngwat','cpsize','cfrac','ctype','cprtop2','cprbot2','cngwat2','cpsize2','cfrac2','ctype2','cfrac12'}; %% even more complicated
%cloud_listI   = {'cprtop','cprbot','cngwat','cpsize','cfrac','ctype'};
%cloud_listW   = {'cprtop2','cprbot2','cngwat2','cpsize2','cfrac2','ctype2'};
cloud_listI   = {'icewaterfrac','icectype','icecngwat','iceOD','icetop','icebot','icesze','icefrac','icetopT'};
cloud_listW   = {'waterctype','watercngwat','waterOD','watertop','waterbot','watersze','waterfrac','watertopT'};

%{
%% now subset into ICE
poemIW = poem;
poemIW = rmfield(poemIW,'cemis');
poemIW = rmfield(poemIW,'crho');
poemIW = rmfield(poemIW,'cemis2');
poemIW = rmfield(poemIW,'crho2');

ice = find(poemIW.ctype == 201 & poemIW.ctype2 ~= 201);
  [hoem,poemice] = subset_rtp_allcloudfields(hoem,poemIW,[],[],ice);
  poemice.ctype2  = NaN * ones(size(poemice.ctype));
  poemice.cngwat2 = NaN * ones(size(poemice.ctype));
  poemice.cpsize2 = NaN * ones(size(poemice.ctype));
  poemice.cfrac2  = NaN * ones(size(poemice.ctype));      
  poemice.cprtop2 = NaN * ones(size(poemice.ctype));
  poemice.cprbot2 = NaN * ones(size(poemice.ctype));
  poemice.cfrac12 = NaN * ones(size(poemice.ctype));
xice = find(poemIW.ctype2 == 201 & poemIW.ctype ~= 201);
  [hoem,xpoemice] = subset_rtp_allcloudfields(hoem,poemIW,[],[],xice);
  xpoemice.ctype  = xpoemice.ctype2;
  xpoemice.cngwat = xpoemice.cngwat2;
  xpoemice.cpsize = xpoemice.cpsize2;
  xpoemice.cfrac  = xpoemice.cfrac2;
  xpoemice.cprtop = xpoemice.cprtop2;
  xpoemice.cprbot = xpoemice.cprbot2;
  xpoemice.ctype2  = NaN * ones(size(xpoemice.ctype));
  xpoemice.cngwat2 = NaN * ones(size(xpoemice.ctype));
  xpoemice.cpsize2 = NaN * ones(size(xpoemice.ctype));
  xpoemice.cfrac2  = NaN * ones(size(xpoemice.ctype));      
  xpoemice.cprtop2 = NaN * ones(size(xpoemice.ctype));
  xpoemice.cprbot2 = NaN * ones(size(xpoemice.ctype));
  xpoemice.cfrac12  = NaN * ones(size(xpoemice.ctype));
  [hoem,poemice] = cat_rtp(hoem,poemice,hoem,xpoemice);
xice = find(poemIW.ctype == 201 & poemIW.ctype2 == 201);
  [hoem,xpoemice] = subset_rtp_allcloudfields(hoem,poemIW,[],[],xice);
  xpoemice.ctype  = xpoemice.ctype;
  xpoemice.cngwat = xpoemice.cngwat + xpoemice.cngwat2;
  xpoemice.cpsize = (xpoemice.cpsize + xpoemice.cpsize2)/2;
  xpoemice.cfrac  = (xpoemice.cfrac + xpoemice.cfrac2)/2;
  xpoemice.cprtop = (xpoemice.cprtop + xpoemice.cprtop2)/2;
  xpoemice.cprbot = (xpoemice.cprbot + xpoemice.cprbot2)/2;
  xpoemice.ctype2  = NaN * ones(size(xpoemice.ctype));
  xpoemice.cngwat2 = NaN * ones(size(xpoemice.ctype));
  xpoemice.cpsize2 = NaN * ones(size(xpoemice.ctype));
  xpoemice.cfrac2  = NaN * ones(size(xpoemice.ctype));      
  xpoemice.cprtop2 = NaN * ones(size(xpoemice.ctype));
  xpoemice.cprbot2 = NaN * ones(size(xpoemice.ctype));
  xpoemice.cfrac12  = NaN * ones(size(xpoemice.ctype));
  [hoem,poemice] = cat_rtp(hoem,poemice,hoem,xpoemice);
xice = find(poemIW.ctype == 201 & poemIW.ctype2 == 101);
  [hoem,xpoemice] = subset_rtp_allcloudfields(hoem,poemIW,[],[],xice);
  xpoemice.ctype2  = NaN * ones(size(xpoemice.ctype));
  xpoemice.cngwat2 = NaN * ones(size(xpoemice.ctype));
  xpoemice.cpsize2 = NaN * ones(size(xpoemice.ctype));
  xpoemice.cfrac2  = NaN * ones(size(xpoemice.ctype));      
  xpoemice.cprtop2 = NaN * ones(size(xpoemice.ctype));
  xpoemice.cprbot2 = NaN * ones(size(xpoemice.ctype));
  xpoemice.cfrac12  = NaN * ones(size(xpoemice.ctype));
  [hoem,poemice] = cat_rtp(hoem,poemice,hoem,xpoemice);
xice = find(poemIW.ctype == 101 & poemIW.ctype2 == 201);
  [hoem,xpoemice] = subset_rtp_allcloudfields(hoem,poemIW,[],[],xice);
  xpoemice.ctype  = xpoemice.ctype2;
  xpoemice.cngwat = xpoemice.cngwat2;
  xpoemice.cpsize = xpoemice.cpsize2;
  xpoemice.cfrac  = xpoemice.cfrac2;
  xpoemice.cprtop = xpoemice.cprtop2;
  xpoemice.cprbot = xpoemice.cprbot2;
  xpoemice.ctype2  = NaN * ones(size(xpoemice.ctype));
  xpoemice.cngwat2 = NaN * ones(size(xpoemice.ctype));
  xpoemice.cpsize2 = NaN * ones(size(xpoemice.ctype));
  xpoemice.cfrac2  = NaN * ones(size(xpoemice.ctype));      
  xpoemice.cprtop2 = NaN * ones(size(xpoemice.ctype));
  xpoemice.cprbot2 = NaN * ones(size(xpoemice.ctype));
  xpoemice.cfrac12  = NaN * ones(size(xpoemice.ctype));
  [hoem,poemice] = cat_rtp(hoem,poemice,hoem,xpoemice);
  disp('here ICE')
  
%% now subset into WATER
water = find(poemIW.ctype2 == 101 & poemIW.ctype ~= 101);
  [hoem,poemwater] = subset_rtp_allcloudfields(hoem,poemIW,[],[],water);
  poemwater.ctype  = NaN * ones(size(poemwater.ctype));
  poemwater.cngwat = NaN * ones(size(poemwater.ctype));
  poemwater.cpsize = NaN * ones(size(poemwater.ctype));
  poemwater.cfrac  = NaN * ones(size(poemwater.ctype));      
  poemwater.cprtop = NaN * ones(size(poemwater.ctype));
  poemwater.cprbot = NaN * ones(size(poemwater.ctype));
  poemwater.cfrac12 = NaN * ones(size(poemwater.ctype));        
xwater = find(poemIW.ctype == 101 & poemIW.ctype2 ~= 101);
  [hoem,xpoemwater] = subset_rtp_allcloudfields(hoem,poemIW,[],[],xwater);
  xpoemwater.ctype2  = xpoemwater.ctype;
  xpoemwater.cngwat2 = xpoemwater.cngwat;
  xpoemwater.cpsize2 = xpoemwater.cpsize;
  xpoemwater.cfrac2  = xpoemwater.cfrac;
  xpoemwater.cprtop2 = xpoemwater.cprtop;
  xpoemwater.cprbot2 = xpoemwater.cprbot;
  xpoemwater.ctype  = NaN * ones(size(xpoemwater.ctype));
  xpoemwater.cngwat = NaN * ones(size(xpoemwater.ctype));
  xpoemwater.cpsize = NaN * ones(size(xpoemwater.ctype));
  xpoemwater.cfrac  = NaN * ones(size(xpoemwater.ctype));      
  xpoemwater.cprtop = NaN * ones(size(xpoemwater.ctype));
  xpoemwater.cprbot = NaN * ones(size(xpoemwater.ctype));
  xpoemwater.cfrac12  = NaN * ones(size(xpoemwater.ctype));        
  [hoem,poemwater] = cat_rtp(hoem,poemwater,hoem,xpoemwater);
xwater = find(poemIW.ctype == 101 & poemIW.ctype2 == 101);
  [hoem,xpoemwater] = subset_rtp_allcloudfields(hoem,poemIW,[],[],xwater);
  xpoemwater.ctype2  = xpoemwater.ctype2;
  xpoemwater.cngwat2 = xpoemwater.cngwat + xpoemwater.cngwat2;
  xpoemwater.cpsize2 = (xpoemwater.cpsize + xpoemwater.cpsize2)/2;
  xpoemwater.cfrac2  = (xpoemwater.cfrac + xpoemwater.cfrac2)/2;
  xpoemwater.cprtop2 = (xpoemwater.cprtop + xpoemwater.cprtop2)/2;
  xpoemwater.cprbot2 = (xpoemwater.cprbot + xpoemwater.cprbot2)/2;
  xpoemwater.ctype  = NaN * ones(size(xpoemwater.ctype));
  xpoemwater.cngwat = NaN * ones(size(xpoemwater.ctype));
  xpoemwater.cpsize = NaN * ones(size(xpoemwater.ctype));
  xpoemwater.cfrac  = NaN * ones(size(xpoemwater.ctype));      
  xpoemwater.cprtop = NaN * ones(size(xpoemwater.ctype));
  xpoemwater.cprbot = NaN * ones(size(xpoemwater.ctype));
  xpoemwater.cfrac12  = NaN * ones(size(xpoemwater.ctype));        
  [hoem,poemwater] = cat_rtp(hoem,poemwater,hoem,xpoemwater);
xwater = find(poemIW.ctype == 201 & poemIW.ctype2 == 101);
  [hoem,xpoemwater] = subset_rtp_allcloudfields(hoem,poemIW,[],[],xwater);
  xpoemwater.ctype  = NaN * ones(size(xpoemwater.ctype));
  xpoemwater.cngwat = NaN * ones(size(xpoemwater.ctype));
  xpoemwater.cpsize = NaN * ones(size(xpoemwater.ctype));
  xpoemwater.cfrac  = NaN * ones(size(xpoemwater.ctype));      
  xpoemwater.cprtop = NaN * ones(size(xpoemwater.ctype));
  xpoemwater.cprbot = NaN * ones(size(xpoemwater.ctype));
  xpoemwater.cfrac12  = NaN * ones(size(xpoemwater.ctype));
  [hoem,poemwater] = cat_rtp(hoem,poemwater,hoem,xpoemwater);
xwater = find(poemIW.ctype == 101 & poemIW.ctype2 == 201);
  [hoem,xpoemwater] = subset_rtp_allcloudfields(hoem,poemIW,[],[],xwater);
  xpoemwater.ctype2  = xpoemwater.ctype;
  xpoemwater.cngwat2 = xpoemwater.cngwat;
  xpoemwater.cpsize2 = xpoemwater.cpsize;
  xpoemwater.cfrac2  = xpoemwater.cfrac;
  xpoemwater.cprtop2 = xpoemwater.cprtop;
  xpoemwater.cprbot2 = xpoemwater.cprbot;
  xpoemwater.ctype  = NaN * ones(size(xpoemwater.ctype));
  xpoemwater.cngwat = NaN * ones(size(xpoemwater.ctype));
  xpoemwater.cpsize = NaN * ones(size(xpoemwater.ctype));
  xpoemwater.cfrac  = NaN * ones(size(xpoemwater.ctype));      
  xpoemwater.cprtop = NaN * ones(size(xpoemwater.ctype));
  xpoemwater.cprbot = NaN * ones(size(xpoemwater.ctype));
  xpoemwater.cfrac12  = NaN * ones(size(xpoemwater.ctype));
  [hoem,poemwater] = cat_rtp(hoem,poemwater,hoem,xpoemwater);
  disp('here WATER')

[hoem,poemIW] = cat_rtp(hoem,poemice,hoem,poemwater);
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
all_list = {'general_list','emis_list','radiance_list','profile_list'};

for aa = 1 : length(all_list);
  xlist = all_list{aa};
  fprintf(1,'doing %s \n',xlist);
  if aa == 1
    xlist = general_list;
  elseif aa == 2
    xlist = emis_list;
  elseif aa == 3
    xlist = radiance_list;
  elseif aa == 4
    xlist = profile_list;
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
    fprintf(1,'doing %s \n','cloud_list ICE');
%    poemX = poemice;
    poemX = poem;
  elseif aa == 2
    xlist = cloud_listW;
    fprintf(1,'doing %s \n','cloud_list WATER');
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
