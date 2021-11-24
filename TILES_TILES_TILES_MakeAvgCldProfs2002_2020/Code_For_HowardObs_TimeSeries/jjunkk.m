  %% this is seeing how the files in the directory are ordered
  clear x fname_count fname_year fname_count_found fname_order_found
  dir0 = dir(['../DATAObsStats_StartSept2002_v3/LatBin30/LonBin32/*.mat']);
  dir0 = dir(['../DATAObsStats_StartSept2002_v3/LatBin35/LonBin72/*.mat']);
  for tt = 1 : length(dir0)
    fname = ['../DATAObsStats_StartSept2002_v3/LatBin35/LonBin72/' dir0(tt).name];
    fname_count = str2num(fname(80:82));
    fname_count_found(fname_count) = +1;
    fname_order_found(fname_count) = tt;
    fname_year(fname_count) = str2num(fname(74:77));
    exampleObject = matfile(fname);
    varlist = who(exampleObject);
    yymmddhh = [32 24 20 22];    
    for index = 1 : length(yymmddhh)
      varname = varlist{yymmddhh(index)};
      junk = load(fname,varname);
      boostr = ['x(' num2str(fname_count) ',' num2str(index) ') = junk.' varname ';'];
      eval(boostr);
    end
    varname = varlist{37}; % rad_blockmax_desc
      junk = load(fname,varname);
      boostr = ['blockmax(' num2str(fname_count) ') = junk.' varname '(1520);'];
      eval(boostr);
    varname = varlist{41}; % rad_max_desc
      junk = load(fname,varname);
      boostr = ['rad_max(' num2str(fname_count) ',:) = junk.' varname '(1:16,1520);'];
      eval(boostr);
  end  
