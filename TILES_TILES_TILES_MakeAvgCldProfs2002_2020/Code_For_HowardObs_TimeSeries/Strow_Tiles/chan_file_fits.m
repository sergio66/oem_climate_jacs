% read_tile_fits

addpath /asl/matlib/aslutil
addpath /asl/matlib/time
addpath ~/Matlab/Math

load_fairs

warning on

dbt_desc_2600 = NaN(64,72,16);
dbt_asc_2600 = NaN(64,72,16);
dbt_err_desc_2600 = NaN(64,72,16);
dbt_err_asc_2600 = NaN(64,72,16);

dbt_desc_1520 = NaN(64,72,16);
dbt_asc_1520 = NaN(64,72,16);
dbt_err_desc_1520 = NaN(64,72,16);
dbt_err_asc_1520 = NaN(64,72,16);

dbt_desc_1513 = NaN(64,72,16);
dbt_asc_1513 = NaN(64,72,16);
dbt_err_desc_1513 = NaN(64,72,16);
dbt_err_asc_1513 = NaN(64,72,16);

dbt_residstd_desc_2600 = NaN(64,72,16);
dbt_residstd_asc_2600 = NaN(64,72,16);

dbt_residstd_desc_1520 = NaN(64,72,16);
dbt_residstd_asc_1520 = NaN(64,72,16);


for lati = 1:64
   lati
   for loni = 1:72
      fdirpre = 'Data/Quantv1_fits';
      fnout = sprintf('LatBin%1$02d/LonBin%2$02d/fits_LonBin%2$02d_LatBin%1$02d_V1.mat',lati,loni);
      fnout = fullfile(fdirpre,fnout);
      d = load(fnout);
      
dbt_desc_2600(lati,loni,:)     = d.dbt_desc(2600,:);
dbt_asc_2600(lati,loni,:)      = d.dbt_asc(2600,:);
dbt_err_desc_2600(lati,loni,:) = d.dbt_err_desc(2600,:);
dbt_err_asc_2600(lati,loni,:)  = d.dbt_err_asc(2600,:);

dbt_desc_1520(lati,loni,:)      = d.dbt_desc(1520,:);   
dbt_asc_1520(lati,loni,:)       = d.dbt_asc(1520,:);    
dbt_err_desc_1520(lati,loni,:)  = d.dbt_err_desc(1520,:);
dbt_err_asc_1520(lati,loni,:)   = d.dbt_err_asc(1520,:);

dbt_desc_1513(lati,loni,:)      = d.dbt_desc(1613,:);   
dbt_asc_1513(lati,loni,:)       = d.dbt_asc(1613,:);    
dbt_err_desc_1513(lati,loni,:)  = d.dbt_err_desc(1613,:);
dbt_err_asc_1513(lati,loni,:)   = d.dbt_err_asc(1613,:);

dbt_residstd_desc_2600(lati,loni,:) = d.resid_desc_std(2600,:);
dbt_residstd_asc_2600(lati,loni,:) = d.resid_asc_std(2600,:);

dbt_residstd_desc_1520(lati,loni,:) = d.resid_desc_std(1520,:);
dbt_residstd_asc_1520(lati,loni,:) = d.resid_asc_std(1520,:);

   end
end
warning off



