addpath /asl/matlib/aslutil
addpath /asl/matlib/time
addpath ~/Matlab/Math
load_fairs

fdirpre = 'Data/Quantv2_fits/';
fdirpre_out = 'Data/Quantv1_fits';

tic

% b_asc = NaN(64,72,2645,8,2);
% b_desc = NaN(64,72,2645,8,2);
% 
% b_err_asc = NaN(64,72,2645,8,2);
% b_err_desc= NaN(64,72,2645,8,2);
% 
% dbt_asc = NaN(64,72,2645,8);
% dbt_desc = NaN(64,72,2645,8);
% 
% dbt_err_asc = NaN(64,72,2645,8);
% dbt_err_desc = NaN(64,72,2645,8);
% 
% rad1513_asc = NaN(64,72,437);
% rad1520_asc = NaN(64,72,437);
% rad2616_asc = NaN(64,72,437);
% rad1513_desc = NaN(64,72,437);
% rad1520_desc = NaN(64,72,437);
% rad2616_desc = NaN(64,72,437);
% 
% resid_asc_std = NaN(64,72,2645);
% resid_desc_std = NaN(64,72,2645);

counts_desc_bin = NaN(64,72,437,8);
counts_asc_bin = NaN(64,72,437,8);

toc

for ilat = 1:64
   ilat
   for ilon = 1:72
      i = ilat; j = ilon;
      fn = sprintf('LatBin%1$02d/LonBin%2$02d/fits_19year_LatBin%1$02d_LonBin%2$02d_V2.mat',ilat,ilon);
      fn = fullfile(fdirpre,fn);

%       d = load(fn,'b_asc','b_desc','berr_asc','berr_desc','dbt_asc','dbt_desc','dbt_err_asc','dbt_err_desc','rad1513_asc','rad1513_desc','rad1520_asc','rad1520_desc','rad2616_asc','rad2616_desc','resid_asc_std','resid_desc_std');
% 
%       b_asc(i,j,:,:,:) = d.b_asc(:,:,1:2);
%       b_desc(i,j,:,:,:) = d.b_desc(:,:,1:2);
%       
%       b_err_asc(i,j,:,:,:) = d.berr_asc(:,:,1:2);
%       b_err_desc(i,j,:,:,:) = d.berr_desc(:,:,1:2);
%       
%       dbt_asc(i,j,:,:) = d.dbt_asc;
%       dbt_desc(i,j,:,:) = d.dbt_desc;
%       
%       dbt_err_asc(i,j,:,:) = d.dbt_err_asc;
%       dbt_err_desc(i,j,:,:) = d.dbt_err_desc;
% 
% 
% 
%       rad1513_asc(i,j,:) = d.rad1513_asc;
%       rad1520_asc(i,j,:) = d.rad1520_asc;
%       rad2616_asc(i,j,:) = d.rad2616_asc;
%       rad1513_desc(i,j,:) = d.rad1513_desc;
%       rad1520_desc(i,j,:) = d.rad1520_desc;
%       rad2616_desc(i,j,:) = d.rad2616_desc;
% 
%       resid_asc_std(i,j,:) = d.resid_asc_std(:,8);
%       resid_desc_std(i,j,:) = d.resid_desc_std(:,8);

      d = load(fn,'counts_desc_bin','counts_asc_bin');

      counts_desc_bin(i,j,:,:) = d.counts_desc_bin;
      counts_asc_bin(i,j,:,:) = d.counts_asc_bin;
   
   end
end



