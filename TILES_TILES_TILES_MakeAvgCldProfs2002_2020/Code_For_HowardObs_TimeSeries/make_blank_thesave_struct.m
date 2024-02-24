function thesave = make_blank_thesave_struct(quants,dbt,N)

%% most of thesave fields = 1 x N bins eg thesave.meansolzen_asc, thesave.meanyear_asc etc        = 1 x N
%% some are size length(quants)-1      eg thesave.quantile1231_asc,thesave.count_quantile1231_asc = N x length(quants)-1
%% some are size N,length(dbt))        eg thesave.hist_asc                                        = N x length(dbt)
%%   quite big one                     eg thesave.meanrad_asc                                     = N x 2645
%%   big one                           eg thesave.rad_asc                                         = N x length(quants)-1 x 2645 

if nargin < 2
  error('need at least 2 args')
elseif nargin == 2
  N = 4608;
end

thesave = struct;
thesave.iii = nan(1,N);
thesave.jjj = nan(1,N);

thesave.count_asc = nan(1,N);
thesave.lat_asc = nan(1,N);
thesave.lon_asc = nan(1,N);
thesave.meansolzen_asc = nan(1,N);
thesave.stdsolzen_asc  = nan(1,N);
thesave.meansatzen_asc = nan(1,N);
thesave.stdsatzen_asc  = nan(1,N);
thesave.meanyear_asc = nan(1,N);
thesave.stdyear_asc  = nan(1,N);
thesave.meanmonth_asc = nan(1,N);
thesave.stdmonth_asc  = nan(1,N);
thesave.meanday_asc = nan(1,N);
thesave.stdday_asc  = nan(1,N);
thesave.meanhour_asc  = nan(1,N);
thesave.stdhour_asc  = nan(1,N);
thesave.meantai93_asc = nan(1,N);
thesave.stdtai93_asc  = nan(1,N);
thesave.meanrad_asc = nan(N,2645);
thesave.stdrad_asc  = nan(N,2645);
thesave.max1231_asc = nan(1,N);
thesave.min1231_asc = nan(1,N);
thesave.DCC1231_asc = nan(1,N);
%thesave.hist_asc = nan(N,length(quants)-1);
thesave.hist_asc = nan(N,length(dbt));
thesave.quantile1231_asc = nan(N,length(quants)-1);
thesave.rad_asc = nan(N,length(quants)-1,2645);
thesave.count_quantile1231_asc = nan(N,length(quants)-1);
thesave.satzen_quantile1231_asc = nan(N,length(quants)-1);
thesave.solzen_quantile1231_asc = nan(N,length(quants)-1);

thesave.count_desc = nan(1,N);
thesave.lat_desc = nan(1,N);
thesave.lon_desc = nan(1,N);
thesave.meansolzen_desc = nan(1,N);
thesave.stdsolzen_desc  = nan(1,N);
thesave.meansatzen_desc = nan(1,N);
thesave.stdsatzen_desc  = nan(1,N);
thesave.meanyear_desc = nan(1,N);
thesave.stdyear_desc  = nan(1,N);
thesave.meanmonth_desc = nan(1,N);
thesave.stdmonth_desc  = nan(1,N);
thesave.meanday_desc = nan(1,N);
thesave.stdday_desc  = nan(1,N);
thesave.meanhour_desc  = nan(1,N);
thesave.stdhour_desc  = nan(1,N);
thesave.meantai93_desc = nan(1,N);
thesave.stdtai93_desc  = nan(1,N);
thesave.meanrad_desc = nan(N,2645);
thesave.stdrad_desc  = nan(N,2645);
thesave.max1231_desc = nan(1,N);
thesave.min1231_descc = nan(1,N);
thesave.DCC1231_desc = nan(1,N);
%thesave.hist_desc = nan(N,length(quants)-1);
thesave.hist_desc = nan(N,length(dbt));
thesave.quantile1231_desc = nan(N,length(quants)-1);
thesave.rad_desc = nan(N,length(quants)-1,2645);
thesave.count_quantile1231_desc = nan(N,length(quants)-1);
thesave.satzen_quantile1231_desc = nan(N,length(quants)-1);
thesave.solzen_quantile1231_desc = nan(N,length(quants)-1);
