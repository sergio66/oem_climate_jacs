disp('checking number of running kCARTA jac jobs')
sqr = ['!squeue | grep -in '' KCARTA'' | grep -in ''batch'' | grep -in '' R '' | wc -l']; eval(sqr);
disp('checking number of delayed kCARTA jac jobs')
sqr = ['!squeue | grep -in '' KCARTA'' | grep -in ''batch'' | grep -in '' PD '' | wc -l']; eval(sqr));

iWhich = input('Enter all files (+1) or look for missing files (-1) : ');

iPrint2File = -1;
iPrint2File = +1;
if iPrint2File > 0
  fid = fopen('anomaly_listV3.txt','w');
end

if exist('iaaFound')
  iaaFound0 = iaaFound;
end
iaaFound = zeros(365,40);

iVers = 1; %% this was done June 30/July 1, but using bad(?) CO2/CH4/N2o profiles ... 
iVers = 2; %% this was done July 2, using much better(?) CO2/CH4/N2o profiles ... but oops forgot to adjust to (002/09 profile correctly)
iVers = 3; %% this was done July 12, using much better(?) CO2/CH4/N2o profiles ... and fixed t=t0 profile

%%%%%%%%%%%%%%%%%%%%%%%%%
disp('see << find_file_names.m >> and list_anomaly_files_to_be_made.m and put_together_results.m')
  caLBLRTM = '12.4';  %% fun test of the cluster
  caLBLRTM = '12.8';  %% default

  if strfind(caLBLRTM,'12.8')
    %% default; use LBLRTMv12.8 for CO2 and CH4
    %outdir     = ['Anomaly365_16_12p8/' num2str(iTimeStep,'%03d') '/'];
    %outdirR    = ['Anomaly365_16_12p8/RESULTS/'];  %% this is where the M_TS files will sit
    %outdirtemp = ['/scratch/Anomaly365_16_12p8/' num2str(iTimeStep,'%03d') '/'];

    outdir     = ['Anomaly365_16_12p8/'];

  elseif strfind(caLBLRTM,'12.4')
    %% use LBLRTMv12.4 for CO2 and CH4
    %outdir     = ['Anomaly365_16_12p4/' num2str(iTimeStep,'%03d') '/'];
    %outdirR    = ['Anomaly365_16_12p4/RESULTS/'];  %% this is where the M_TS files will sit
    %outdirtemp = ['/scratch/Anomaly365_16_12p4/' num2str(iTimeStep,'%03d') '/'];

    outdir     = ['Anomaly365_16_12p4/'];
  else
    caLBLRTM
    error('caLBLRTM unknowm')
  end
%%%%%%%%%%%%%%%%%%%%%%%%%

if iWhich == 1
  iCnt = 0;
  for iTimeStep = 1 : 365
    for iLatbin = 1 : 40
      iCnt = iCnt + 1;
      if iPrint2File > 0
        fprintf(fid,'%5i \n',iCnt);
      end
    end
  end
else
  iCnt = 0;
  iNotFound = 0;
  for iTimeStep = 1 : 365
    for iLatbin = 1 : 40
      iCnt = iCnt + 1;
      if iVers == 1
        fout = [outdir '/' num2str(iTimeStep,'%03d') '/strowfinitejac_convolved_kcarta_airs_' num2str(iLatbin) '_jac.mat'];   %% done June30/July 1, bad(?) CO2/N2O/CH4 profiles
      elseif iVers == 2
        fout = [outdir '/' num2str(iTimeStep,'%03d') '/strowfinitejac_convolved_kcarta_airs_' num2str(iLatbin) '_jac2.mat'];  %% done July 2,     better(?) CO2/N2O/CH4 profiles
      elseif iVers == 3
	  fout = [outdir '/' num2str(iTimeStep,'%03d') '/strowfinitejac_convolved_kcarta_airs_' num2str(iLatbin) '_jac2.mat'];  %% done July 12,     better(?) CO2/N2O/CH4 profiles, fixed co2 mmr at t=t0
      else
        error('huh?')
      end

      if ~exist(fout)
        iNotFound = iNotFound + 1;
        if iPrint2File > 0
          fprintf(fid,'%5i \n',iCnt);
        end
      else
        iaaFound(iTimeStep,iLatbin) = +1;
      end
    end
  end
  t = datetime('now'); strt = datestr(t); %fprintf(1,'%s\n',strt);
  fprintf(1,'%s : found/did not find  %5i/%5i of %5i files : %8.6f frac done \n',strt,365*40-iNotFound,iNotFound,365*40,(365*40-iNotFound)/(365*40))
end

if iPrint2File > 0
  fclose(fid);
end

figure(1); pcolor(iaaFound); shading flat; colormap jet; colorbar; title('Done So Far');
jett = jet; jett(1,:) = 1; colormap(jett);

if exist('iaaFound0')
  figure(2); plot(1:40,sum(iaaFound0),'bo-',1:40,sum(iaaFound),'rx-'); title('Done So Far'); 
    xlabel('Latbin'); ylabel('num timsteps done/365'); grid
    axis([1 40 0 365]);
  figure(3); plot(1:365,sum(iaaFound0'),'bo-',1:365,sum(iaaFound'),'rx-'); title('Done So Far'); 
    xlabel('TimeStep'); ylabel('num latbins done/40'); grid
    axis([1 365 0 40]);
else
  figure(2); plot(sum(iaaFound),'ro-'); title('Done So Far'); xlabel('Latbin'); grid
  figure(3); plot(sum(iaaFound'),'ro-'); title('Done So Far'); xlabel('TimeStep'); grid
end

notdone = find(sum(iaaFound') < 40);
%notdone

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
notstarted = sum(iaaFound'); notstarted = find(notstarted == 0);
if length(notstarted) > 0
  fprintf(1,'found that %3i of 365 timesteps did not start : see notstartededV3.sc \n',length(notstarted))
  fid = fopen('notstartededV3.sc','w');
  for ii = 1 : length(notstarted)
    str = ['sbatch --array=' num2str(notstarted(ii)) ' sergio_matlab_anom40_strowV3.sbatch'];
    fprintf(fid,'%s \n',str);
  end
  fclose(fid);
end

notfinished = sum(iaaFound'); notfinished = find(notfinished < 40);
%{
%% can be pretty smart if you want to separate out notstarted from notfiniehsd
notfinished = setdiff(notfinished,notstarted);
%}
if length(notfinished) > 0
  fprintf(1,'found that %3i of 365 timesteps did not finish : see notfinishededV3.sc \n',length(notfinished))
  fid = fopen('notfinishededV3.sc','w');
  str = ['sbatch --account=pi_strow --exclude=cnode204,cnode260,cnode267 --array='];
  fprintf(fid,'%s',str);
  iX=nice_output(fid,notfinished);   %% now put in continuous strips)
  str = [' sergio_matlab_anom40_strowV3.sbatch 2'];
  fprintf(fid,'%s \n',str);
  fclose(fid);
end
