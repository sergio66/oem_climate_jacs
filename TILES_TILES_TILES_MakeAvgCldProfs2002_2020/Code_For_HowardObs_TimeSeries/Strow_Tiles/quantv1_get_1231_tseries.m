% read_tile_fits

addpath /asl/matlib/aslutil
addpath /asl/matlib/time
addpath ~/Matlab/Math

load_fairs


warning on
for lati = 1:64
   lati
   for loni = 1:72
      fdirpre = 'Data/Quantv1_fits';
      fnout = sprintf('LatBin%1$02d/LonBin%2$02d/fits_LonBin%2$02d_LatBin%1$02d_V1.mat',lati,loni);
      fnout = fullfile(fdirpre,fnout);
      d = load(fnout);
%       dbt_asc(lati,loni,1,:) = d.dbt_asc(1520,:);
%       dbt_asc(lati,loni,2,:) = d.dbt_asc(1513,:);      
%       dbt_desc(lati,loni,1,:) = d.dbt_desc(1520,:);
%       dbt_desc(lati,loni,2,:) = d.dbt_desc(1513,:);      
%       dbt_err_asc(lati,loni,1,:) = d.dbt_err_asc(1520,:);
%       dbt_err_asc(lati,loni,2,:) = d.dbt_err_asc(1513,:);      
%       dbt_err_desc(lati,loni,1,:) = d.dbt_err_desc(1520,:);
%       dbt_err_desc(lati,loni,2,:) = d.dbt_err_desc(1513,:);      
%       b_asc(lati,loni,1,:,:) = d.b_asc(1520,:,:);
%       b_asc(lati,loni,2,:,:) = d.b_asc(1513,:,:);
%       b_desc(lati,loni,1,:,:) = d.b_desc(1520,:,:);
%       b_desc(lati,loni,2,:,:) = d.b_desc(1513,:,:);
%       
%       berr_asc(lati,loni,1,:,:) = d.berr_asc(1520,:,:);
%       berr_asc(lati,loni,2,:,:) = d.berr_asc(1513,:,:);
%       berr_desc(lati,loni,1,:,:) = d.berr_desc(1520,:,:);
%       berr_desc(lati,loni,2,:,:) = d.berr_desc(1513,:,:);
% 
%       lag_asc(lati,loni,1,:) = d.lag_asc(1520,:);
%       lag_desc(lati,loni,1,:) = d.lag_desc(1520,:);
%       lag_asc(lati,loni,2,:) = d.lag_asc(1513,:);
%       lag_desc(lati,loni,2,:) = d.lag_desc(1513,:);

%       r_mean(lati,loni,1) = nanmean(d.r1231);
%       r_mean(lati,loni,2) = nanmean(d.r1228);
%       r_std(lati,loni,1) = nanstd(d.r1231);
%       r_std(lati,loni,2) = nanstd(d.r1228);

      r_mean(lati,loni,1,:) = d.r1231;
      r_mean(lati,loni,2,:) = d.r1228;
      
   end
end
warning off



