disp('checking number of running kCARTA jac jobs')
sqr = ['!squeue | grep -in '' KCARTA'' | grep -in ''high_'' | grep -in '' R '' | wc -l']; eval(sqr);
disp('checking number of delayed kCARTA jac jobs')
sqr = ['!squeue | grep -in '' KCARTA'' | grep -in ''high_'' | grep -in '' PD '' | wc -l']; eval(sqr);

iWhich = input('Enter all files (+1) or look for missing files (-1,default) : ');
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
  iMaxLatbin = 40;
end

iPrint2File = -1;
iPrint2File = +1;
if iPrint2File > 0
  fid = fopen('anomaly_list.txt','w');
end

if exist('iaaFound')
  iaaFound0 = iaaFound;
end
iaaFound = zeros(iMaxTimeStep,iMaxLatbin);

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
    %outdir     = ['CLO_Anomaly137_16_12p8/' num2str(iTimeStep,'%03d') '/'];
    %outdirR    = ['CLO_Anomaly137_16_12p8/RESULTS/'];  %% this is where the M_TS files will sit

    %outdirtemp = ['/scratch/Anomaly137_16_12p8/' num2str(iTimeStep,'%03d') '/'];                          %% v1 suggested by Roy Prouty
    %outdirtemp = ['/umbc/lustre/strow/sergio/scratch/Anomaly137_16_12p8/' num2str(iTimeStep,'%03d') '/']; %% v2 suggested by Larrabee
    %outdirtemp = [tempscratchdir '/Anomaly137_16_12p8/' num2str(iTimeStep,'%03d') '/'];                   %% v3 suggested by Howard and Steve

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
      %fout = ['Anomaly365_16/' num2str(iTimeStep,'%03d') '/jac_results_' num2str(iLatbin) '.mat'];
      fout = [outdir '/' num2str(iTimeStep,'%03d') '/jac_results_' num2str(iLatbin) '.mat'];
      if ~exist(fout)
        iNotFound = iNotFound + 1;
        if iPrint2File > 0
%          fprintf(fid,'%5i \n',iCnt-iMaxLatbin); %% -iMaxLatbin is to offset timestep by 1
          fprintf(fid,'%5i \n',iCnt); %% -iMaxLatbin is to offset timestep by 1
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
    xlabel('Latbin'); ylabel('num timsteps done/iMaxTimeStep'); grid
    axis([1 iMaxLatbin 0 iMaxTimeStep]);
  figure(3); plot(1:iMaxTimeStep,sum(iaaFound0'),'bo-',1:iMaxTimeStep,sum(iaaFound'),'rx-'); title('Done So Far'); 
    xlabel('TimeStep'); ylabel('num latbins done/iMaxLatbin'); grid
    axis([1 iMaxTimeStep 0 iMaxLatbin]);
  figure(4);
    plot(1:iMaxTimeStep,sum(iaaFound')-sum(iaaFound0'),'kd'); title('Progress = Done Now-Before')
    thediff = sum(iaaFound')-sum(iaaFound0');
    need2Bdone = find(sum(iaaFound0') < iMaxLatbin);
    plot(need2Bdone,thediff(need2Bdone),'rd'); title('Progress : Done Now-Before')    
    xlabel('timesteps that are not finished'); grid
else
  figure(2); plot(sum(iaaFound),'ro-'); title('Done So Far'); xlabel('Latbin'); grid
  figure(3); plot(sum(iaaFound'),'ro-'); title('Done So Far'); xlabel('TimeStep'); grid
end

notdone = find(sum(iaaFound') < iMaxLatbin);
%notdone

notdoneiMaxTimeStep = find(sum(iaaFound) < iMaxTimeStep);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
notstarted = sum(iaaFound'); notstarted = find(notstarted == 0);
if length(notstarted) > 0
  fprintf(1,'found that %3i of %3i timesteps did not start : see notstarted.sc \n',length(notstarted),iMaxTimeStep)
  fid = fopen('notstarted.sc','w');
  for ii = 1 : length(notstarted)
    str = ['sbatch --array=' num2str(notstarted(ii)) ' sergio_matlab_anom40.sbatch']; 
    fprintf(fid,'%s \n',str);
  end
  fclose(fid);
end

notfinished = sum(iaaFound'); notfinished = find(notfinished < iMaxLatbin);
%{
%% can be pretty smart if you want to separate out notstarted from notfiniehsd
notfinished = setdiff(notfinished,notstarted);
%}
if length(notfinished) > 0
  fprintf(1,'found that %3i of %3i timesteps did not finish : see notfinished.sc \n',length(notfinished),iMaxTimeStep)
  fid = fopen('notfinished.sc','w');
  str = ['sbatch --account=pi_strow --exclude=cnode026 --array='];
  fprintf(fid,'%s \n',str);
  iX = nice_output(fid,notfinished);   %% now put in continuous strips
  fprintf(1,'length(notfinished) = %4i Num Continuous Strips = %4i \n',length(notfinished),iX)
  str = [' sergio_matlab_jobB.sbatch 2']; 
  fprintf(fid,'%s \n',str);
  fclose(fid);
end
