function [head,prof] = read_glatm_adjust();

% /home/sergio/KCARTA/MATLAB/GLATM/read_glatm_adjust.m
% Program read_glatm.m
%
% Read glatm.dat file into matlab
%
% copied from /asl/packages/klayersV205/Data/Safe/read_glatm_adjust.m  /asl/packages/klayersV205/Data/Safe/read_glatm.m
% Created: 13 July 2010, Scott Hannon
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% edit this section as needed

% Comment character
comchar='!';

% Expected number of levels
nlev = 50;

% Expected number of models
nmod = 6;

% Max allowed gas ID
maxID = 80;

% Expected ID of model gases
modID=1:7;

% Surface pressure and altitude
% For kcarta database we want 1100 mb at -689 meters
spres = 1100;
salti = -689;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Declare matlab arrays

head.pfields=1; % profile
head.ptype=0;   % levels
head.ngas = 0;
head.glist = zeros(maxID,1);
head.gunit = 10*ones(maxID,1); % ppmv
%
prof.plat = zeros(1,nmod);
prof.nlevs = nlev*ones(1,nmod);
prof.plevs = zeros(nlev,nmod);
prof.ptemp = zeros(nlev,nmod);
prof.pnote = char(zeros(80,nmod));
for ii=1:length(modID)
   ig = modID(ii);
   eval(['prof.gas_' int2str(ig) '=zeros(nlev,nmod);'])
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read file

% Open file
fid = fopen('/asl/packages/klayersV205/Data/Safe/glatm_9July2010.dat','r');
%fid = fopen('glatm.dat','r');

% Read number of levels = 50
cline = readnextline(fid,comchar);
if (~strcmp(cline(1:2),'50'));
   cline
   error('unexpected number of levels; hardcoded for 50')
end

% Loop over the 6 models
for ii=1:6
   % Read model name
   cline = readnextline(fid,comchar);
   prof.pnote(1:length(cline),ii) = cline;

   % Read model plat
   cline = readnextline(fid,comchar);
    prof.plat(ii) = str2num(cline);

   % Read model altitude (ignore)
   for jj=1:10
      cline = readnextline(fid,comchar);
   end

   % Read model plevs
   for jj=1:10
      cline = readnextline(fid,comchar);
      kk = (jj-1)*5 + (1:5);
      prof.plevs(kk,ii) = str2num(cline);
   end

   % Read model ptemp
   for jj=1:10
      cline = readnextline(fid,comchar);
      kk = (jj-1)*5 + (1:5);
      prof.ptemp(kk,ii) = str2num(cline);
   end

   % Read model density (ignore)
   for jj=1:10
      cline = readnextline(fid,comchar);
   end

   for kk=1:7
      % Read gas ID and profile
      cline = readnextline(fid,comchar);
      ig = str2num(cline(1:2));
      gstr = ['prof.gas_' int2str(ig) '(kk,ii)=str2num(cline);'];
      for jj=1:10
         cline = readnextline(fid,comchar);
         kk = (jj-1)*5 + (1:5);
         eval(gstr);
      end
      if (ii == 1)
         head.ngas = round(head.ngas + 1); % exact integer
         head.glist(head.ngas) = ig;
      end
   end

   % Read modend string
   cline = readnextline(fid,comchar);

end


% Read minigas string
cline = readnextline(fid,comchar);

% Read all remaining gases
domore = 1;
while (domore == 1)
  % Read gas ID or DATAEND
   cline = readnextline(fid,comchar);
   if (strcmp(cline(1),'D'))
      domore = 0;
   else
      ig = str2num(cline(1:2));
      gstr = ['prof.gas_' int2str(ig) '=zeros(nlev,nmod);'];
      eval(gstr);
      gstr = ['prof.gas_' int2str(ig) '(kk,:)=str2num(cline)''*ones(1,nmod);'];
      for jj=1:10
         cline = readnextline(fid,comchar);
         kk = (jj-1)*5 + (1:5);
         eval(gstr);
      end
      head.ngas = round(head.ngas + 1); % exact integer
      head.glist(head.ngas) = ig;
   end
end

fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clean up
head.glist=head.glist(1:head.ngas);
head.gunit=head.gunit(1:head.ngas);

prof.spres = spres*ones(1,nmod);
prof.salti = salti*ones(1,nmod);

clear ans cline comchar domore fid gstr ig ii jj kk maxID modID nlev nmod
clear stemp salti

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adjust mixing ratios

prof.gas_2  = prof.gas_2 * 385/330;
prof.gas_6  = prof.gas_6 * 1.8/1.7;
prof.gas_24 = prof.gas_24 * 0.77;
prof.gas_30 = prof.gas_30 * 4.6;
prof.gas_51 = prof.gas_51 * 1.7;
prof.gas_52 = prof.gas_52 * 2.2;
prof.gas_53 = prof.gas_53 * 0.7;
prof.gas_55 = prof.gas_55 * 0.2;
prof.gas_56 = prof.gas_56 * 3.3;
prof.gas_57 = prof.gas_57 * 4.0;
prof.gas_58 = prof.gas_58 * 1.4;
prof.gas_59 = prof.gas_59 * 2.0;
prof.gas_60 = prof.gas_60 * 0.68;
prof.gas_81 = prof.gas_81 * 4.6;

%%% end of program %%%

x = prof.pnote;
for ii = 1 : 6
  fprintf(1,'%s \n',x(1:27,ii)');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [cline] = readnextline(fid, comchar);

% function [cline] = readnextline(fid, comchar);
%
% Read next line not starting with comchar from input file.
%
% Input:
%    fid = [1 x 1] integer file unit ID
%    comchar = [1 x 1] character
%
% Output:
%    cline = [string] character string
%

% Created: 13 July 2010, Scott Hannon
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

skip = 1;
while (skip == 1)
   cline = fgetl(fid);
   if (cline(1) == comchar)
     skip = 1;
   else
     skip = 0;
   end
end

%%% end of program %%%

