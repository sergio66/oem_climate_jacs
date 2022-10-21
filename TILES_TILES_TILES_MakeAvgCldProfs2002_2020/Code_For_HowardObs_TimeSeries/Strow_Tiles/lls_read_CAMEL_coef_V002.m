function [camel]=lls_read_CAMEL_coef_V002(coef_filename)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  read_CAMEL_coef_V001.m 

%  to read the MEASURES (CAMEL=ASTER+MODIS) monthly mean coeficients
%
%  It has been developed under the NASA MEASURES program called: 
%  Unified and Coherent Land Surface temperature and Emissivity (LST&LSE) Earth System Data Record (ESDR). 
%  The software runs on the version 0.6 (v00r06) CAMEL emissivity coefficients data. 
%
%    INPUT: coef_filename - filename of the MEASURES CAMEL coef database
%    OUTPUT: data       -  CAMEL structure includes 
%                          coefficients, CAMEL quality flag, 
%                          version number of the laboratory database, 
%                          number of PCs used for a certain pixels
%			   snow fraction, latitude, longitude
%   HISTORY: 
%           created on May 2, 2016   by Eva Borbas UW-Madison, SSEC/CIMSS
%                                        Glynn Hulley NASA/JPL
%           Version V001  Jan, 2017   by Eva Borbas UW-Madison, SSEC/CIMSS
%                                        Glynn Hulley NASA/JPL
%                                      adapted for V001 dataset
%           Version V002  Oct, 2018   by Eva Borbas UW-Madison, SSEC/CIMSS
%                                        Glynn Hulley NASA/JPL
%                                        updated for CAMEL V002 dataset
% 
%  CONTACT: 
%            eva.borbas@ssec.wisc.edu
%            glynn.hulley@jpl.nasa.gov     
%
%    Note: This algorithm was released to be useful, but without any warranty.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% read emis netcdf file
%----------------
ncid = netcdf.open(coef_filename,'NC_NOWRITE');
disp(['Read CAMEL coef File: ' coef_filename]);

%----------------
%  reading dimensions
%----------------
dimid = netcdf.inqDimID(ncid,'max_npcs');
[dimname, dimlen] = netcdf.inqDim(ncid,dimid);
max_npcs=int16(dimlen);
dimid = netcdf.inqDimID(ncid,'latitude');
[dimname, dimlen] = netcdf.inqDim(ncid,dimid);
Xmax=int16(dimlen);
dimid = netcdf.inqDimID(ncid,'longitude');
[dimname, dimlen] = netcdf.inqDim(ncid,dimid);
Ymax=int16(dimlen);


%----------------
%  camel quality flag
%----------------
camel.camel_qflag=ncread(coef_filename,'camel_qflag');

%----------------
%  camel lat,lon
%----------------
lat2 = ncread(coef_filename,'latitude');
lon2 = ncread(coef_filename,'longitude');
camel.lat=repmat(double(lat2),1,Ymax)';
camel.lon=repmat(double(lon2),1,Xmax);


%----------------
% PC_NPCS PC_LABVS SNOW-FRACTION and COEF data
%----------------
pc_npcs = ncread(coef_filename,'pc_npcs');
pc_labvs = ncread(coef_filename,'pc_labvs');
snow_fraction = ncread(coef_filename,'snow_fraction');
pc_coefs = ncread(coef_filename,'pc_coefs');

camel.coef=NaN(max_npcs,Ymax,Xmax);
camel.pcnpcs=NaN(Ymax,Xmax);
camel.snowf=NaN(Ymax,Xmax);
camel.pclabvs=NaN(Ymax,Xmax);

k = camel.camel_qflag > 0;
camel.coef(:,k) = pc_coefs;
camel.pcnpsc(k) = double(pc_npcs);
camel.pclabvs(k) = double(pc_labvs);
camel.snowf(k) = double(snow_fraction);

% Original code below, speed up is ~12X!
% 
% for i=1:max_npcs
%        clear coef
%        coef=double(squeeze(pc_coefs(i,:)));
%        	   indexlut=1;
% 	   for j=1:Xmax
%              for k=1:Ymax
% 		 if camel.camel_qflag(k,j) > 0 
%  		 camel.coef(i,k,j) = coef(indexlut);
% 		    if i == 1
% 		    camel.pcnpcs(k,j) = double(pc_npcs(indexlut));
%                     camel.pclabvs(k,j) =double(pc_labvs(indexlut));
%                     camel.snowf(k,j) =double( snow_fraction(indexlut));
%                     end
% 		   indexlut = indexlut + 1;
%                 end
%             end
%           end
% 
% end

netcdf.close(ncid)


end

