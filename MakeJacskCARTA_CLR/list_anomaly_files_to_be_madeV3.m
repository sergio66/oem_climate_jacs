disp('checking number of running kCARTA jac jobs')
sqr = ['!squeue | grep -in '' KCARTA'' | grep -in ''batch'' | grep -in '' R '' | wc -l']; eval(sqr);
disp('checking number of delayed kCARTA jac jobs')
sqr = ['!squeue | grep -in '' KCARTA'' | grep -in ''batch'' | grep -in '' PD '' | wc -l']; eval(sqr);

iWhich = input('Enter all files (+1) or look for missing files (-1) : ');
if length(iWhich) == 0
  iWhich = -1;
end

iAIRSorCRIS = 1; %% AIRS
iAIRSorCRIS = 2; %% CRIS lo res

if iAIRSorCRIS == 1
  iMaxTimeStep = 365;  %% 16 years
  iMaxLatbin = 40;
elseif iAIRSorCRIS == 2
  iMaxTimeStep = 140;  %% 6 years
  iMaxTimeStep = 136;  %% 6 years
  iMaxTimeStep = 157;  %% 7 years
  iMaxLatbin = 38;
end

iPrint2File = -1;
iPrint2File = +1;
if iPrint2File > 0
  fid = fopen('anomaly_listV3.txt','w');
end

if exist('iaaFound')
  iaaFound0 = iaaFound;
end
iaaFound = zeros(iMaxTimeStep,iMaxLatbin);

iVers = 0; %% this was done June 30/July 1, but using bad(?) CO2/CH4/N2O/CFC11 profiles ... 
iVers = 1; %% this was done July 2,  using much better(?) CO2/CH4/N2O/CFC11 profiles ... but oops forgot to adjust to (002/09 profile correctly)
iVers = 2; %% this was done July 12, using much better(?) CO2/CH4/N2O/CFC11 profiles ... and fixed t=t0 profile
iVers = 3; %% this was done   August 21??, using much better(?) CO2/CH4/N2O/CFC11 profiles ... and fixed t=t0 profile, and include CFC12
iVers = 4; %% this was redone August 28,   using much better(?) CO2/CH4/N2O/CFC11 profiles ... and fixed t=t0 profile, and include CFC12

%% this was only done for AIRS, not done for CRIS
%iVers = 5; %% this was redone August 28,   using much better(?) CO2/CH4/N2O/CFC11 profiles ... and fixed t=t0 profile, and include CFC12, age of air????? UGH!!!!

%%%%%%%%%%%%%%%%%%%%%%%%%
disp('see << find_file_names.m >> and list_anomaly_files_to_be_made.m and put_together_results.m')
  caLBLRTM = '12.4';  %% fun test of the cluster
  caLBLRTM = '12.8';  %% default

  if strfind(caLBLRTM,'12.8') & iAIRSorCRIS == 1
    %% default; use LBLRTMv12.8 for CO2 and CH4
    %outdir     = ['Anomaly365_16_12p8/' num2str(iTimeStep,'%03d') '/'];
    %outdirR    = ['Anomaly365_16_12p8/RESULTS/'];  %% this is where the M_TS files will sit
    %outdirtemp = ['/scratch/Anomaly365_16_12p8/' num2str(iTimeStep,'%03d') '/'];

    outdir     = ['Anomaly365_16_12p8/'];

  elseif strfind(caLBLRTM,'12.4') & iAIRSorCRIS == 1
    %% use LBLRTMv12.4 for CO2 and CH4
    %outdir     = ['Anomaly365_16_12p4/' num2str(iTimeStep,'%03d') '/'];
    %outdirR    = ['Anomaly365_16_12p4/RESULTS/'];  %% this is where the M_TS files will sit
    %outdirtemp = ['/scratch/Anomaly365_16_12p4/' num2str(iTimeStep,'%03d') '/'];

    outdir     = ['Anomaly365_16_12p4/'];

  elseif strfind(caLBLRTM,'12.8') & iAIRSorCRIS == 2
    %% default; use LBLRTMv12.8 for CO2 and CH4
    %outdir     = ['Anomaly365_16_12p8/' num2str(iTimeStep,'%03d') '/'];
    %outdirR    = ['Anomaly365_16_12p8/RESULTS/'];  %% this is where the M_TS files will sit
    %outdirtemp = ['/scratch/Anomaly365_16_12p8/' num2str(iTimeStep,'%03d') '/'];

    outdir     = ['CLO_Anomaly137_16_12p8/'];

  else
    caLBLRTM
    error('caLBLRTM unknowm')
  end
%%%%%%%%%%%%%%%%%%%%%%%%%

if iWhich == 1
  iCnt = 0;
  for iTimeStep = 1 : iMaxTimeStep
    for iLatbin = 1 : iMaxLatbin
      iCnt = iCnt + 1;
      if iPrint2File > 0
        fprintf(fid,'%5i \n',iCnt);
      end
    end
  end
else
  iCnt = 0;
  iNotFound = 0;
  for iTimeStep = 1 : iMaxTimeStep
    for iLatbin = 1 : iMaxLatbin
      iCnt = iCnt + 1;
      if iVers == 0
        fout = [outdir '/' num2str(iTimeStep,'%03d') '/strowfinitejac_convolved_kcarta_cris_' num2str(iLatbin) '_jac.mat'];   %% done June30/July 1, bad(?) CO2/N2O/CH4/CFC11 profiles
      elseif iVers == 1
        fout = [outdir '/' num2str(iTimeStep,'%03d') '/strowfinitejac_convolved_kcarta_cris_' num2str(iLatbin) '_jac2.mat'];  %% done July 2,     better(?) CO2/N2O/CH4/CFC11 profiles
      elseif iVers == 2
	  fout = [outdir '/' num2str(iTimeStep,'%03d') '/strowfinitejac_convolved_kcarta_cris_' num2str(iLatbin) '_jac2.mat'];  %% done July 12,     better(?) CO2/N2O/CH4/CFC11 profiles, fixed co2 mmr at t=t0
      elseif iVers == 3
          outdir = 'Anomaly365_16_12p8_tillAug25_2019/';
	  fout = [outdir '/' num2str(iTimeStep,'%03d') '/strowfinitejac_convolved_kcarta_cris_' num2str(iLatbin) '_jac3.mat'];  %% done Aug 20,     better(?) CO2/N2O/CH4/CFC11 profiles, fixed co2 mmr at t=t0, CFC12
      elseif iVers == 4
	  fout = [outdir '/' num2str(iTimeStep,'%03d') '/strowfinitejac_convolved_kcarta_cris_' num2str(iLatbin) '_jac4.mat'];  %% done Aug 28,     better(?) CO2/N2O/CH4/CFC11 profiles, fixed co2 mmr at t=t0, CFC12
      elseif iVers == 5
	  fout = [outdir '/' num2str(iTimeStep,'%03d') '/strowfinitejac_convolved_kcarta_cris_' num2str(iLatbin) '_jac5.mat'];  %% done Aug 28,     better(?) CO2/N2O/CH4/CFC11 profiles, fixed co2 mmr at t=t0, CFC12???????
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
  fprintf(1,'%s : found/did not find  %5i/%5i of %5i files : %8.6f frac done \n',strt,iMaxTimeStep*iMaxLatbin-iNotFound,iNotFound,iMaxTimeStep*iMaxLatbin,(iMaxTimeStep*iMaxLatbin-iNotFound)/(iMaxTimeStep*iMaxLatbin))
end

if iPrint2File > 0
  fclose(fid);
end

figure(1); pcolor(iaaFound); shading flat; colormap jet; colorbar; title('Done So Far');
jett = jet; jett(1,:) = 1; colormap(jett);

if exist('iaaFound0')
  figure(2); plot(1:iMaxLatbin,sum(iaaFound0),'bo-',1:iMaxLatbin,sum(iaaFound),'rx-'); title('Done So Far'); 
    xlabel('Latbin'); ylabel('num timsteps done/365'); grid
    axis([1 iMaxLatbin 0 iMaxTimeStep]);
  figure(3); plot(1:iMaxTimeStep,sum(iaaFound0'),'bo-',1:iMaxTimeStep,sum(iaaFound'),'rx-'); title('Done So Far'); 
    xlabel('TimeStep'); ylabel('num latbins done/40'); grid
    axis([1 iMaxTimeStep 0 iMaxLatbin]);
  figure(4);
    plot(1:iMaxTimeStep,sum(iaaFound')-sum(iaaFound0'),'kd'); title('Progress = Done Now-Before')
    thediff = sum(iaaFound')-sum(iaaFound0');
    need2Bdone = find(sum(iaaFound0') < iMaxLatbin);
    plot(need2Bdone,thediff(need2Bdone),'kd'); title('Progress : Done Now-Before')    
    xlabel('timesteps that are not finished'); grid
else
  figure(2); plot(sum(iaaFound),'ro-'); title('Done So Far'); xlabel('Latbin'); grid
  figure(3); plot(sum(iaaFound'),'ro-'); title('Done So Far'); xlabel('TimeStep'); grid
end

notdone = find(sum(iaaFound') < iMaxLatbin);
%notdone

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
notstart = sum(iaaFound'); notstart = find(notstart == 0);
if length(notstart) > 0
  fprintf(1,'found that %3i of %3i timesteps did not start : see notstartedV3.sc \n',length(notstart),iMaxTimeStep)
  fid = fopen('notstartedV3.sc','w');
  str = ['sbatch --account=pi_strow --exclude=cnode203,cnode204,cnode260,cnode267 --array='];
  fprintf(fid,'%s',str);
  iX = nice_output(fid,notstart);   %% now put in continuous strips
  fprintf(1,'length(notstart) = %4i Num Continuous Strips = %4i \n',length(notstart),iX);
  str = [' sergio_matlab_anom40_strowV3.sbatch'];
  fprintf(fid,'%s \n',str);
  fclose(fid);
end

notfinished = sum(iaaFound'); notfinished = find(notfinished < iMaxLatbin);
%{
%% can be pretty smart if you want to separate out notstarted from notfiniehsd
notfinished = setdiff(notfinished,notstarted);
%}
if length(notfinished) > 0
  fprintf(1,'found that %3i of %3i timesteps did not finish : see notfinishededV3.sc \n',length(notfinished),iMaxTimeStep)
  fid = fopen('notfinishedV3.sc','w');
  str = ['sbatch --account=pi_strow --exclude=cnode204,cnode260,cnode267 --array='];
  fprintf(fid,'%s',str);
  iX = nice_output(fid,notfinished);   %% now put in continuous strips
  fprintf(1,'length(notfinished) = %4i Num Continuous Strips = %4i \n',length(notfinished),iX);
  str = [' sergio_matlab_anom40_strowV3.sbatch 2'];
  fprintf(fid,'%s \n',str);
  fclose(fid);
end
