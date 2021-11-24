disp('checking number of running SARTA jac jobs')
sqr = ['!squeue | grep -in ''batch'' | grep -in ''CLUST_MA'' | grep -in '' R '' | wc -l']; eval(sqr);
disp('checking number of delayed SARTA jac jobs')
sqr = ['!squeue | grep -in ''batch'' | grep -in ''CLUST_MA'' | grep -in '' PD '' | wc -l']; eval(sqr);

%% while true; do ls SARTA_AIRSL1c_Anomaly365_16/*/xprofile* | wc -l ; sleep 5; done

iRemove = +1;  %% blow away small size files
iRemove = -1;  %% keep small size files

iWhich = input('Enter all files (+1) or look for missing files (-1) : ');

for ii = 1 : 4; figure(ii); clf; end

iPrint2File = -1;
iPrint2File = +1;
if iPrint2File > 0
  fid = fopen('anomaly_list.txt','w');
end

if exist('iaaFound')
  iaaFound0 = iaaFound;
end
iaaFound = zeros(365,40);

foutdir = 'SARTA_AIRSL1c_Anomaly365_16_no_seasonal_OldSarta_smallpert/';
foutdir = 'SARTA_AIRSL1c_Anomaly365_16/';    %% this is usually the default
foutdir = 'SARTA_AIRSL1c_Anomaly365_16_CLD';

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
  iRemoveCnt = 0;
  iNotFound = 0;
  for iTimeStep = 1 : 365
    for iLatbin = 1 : 40
      iCnt = iCnt + 1;

      fout = ['SARTA_AIRSL1c_Anomaly365_16/' num2str(iTimeStep,'%03d') '/xprofile' num2str(iLatbin) '.mat'];
      fout = ['SARTA_AIRSL1c_Anomaly365_16_no_seasonal_OldSarta_smallpert/' num2str(iTimeStep,'%03d') '/xprofile' num2str(iLatbin) '.mat'];
      fout = [foutdir '/' num2str(iTimeStep,'%03d') '/xprofile' num2str(iLatbin) '.mat'];

      if ~exist(fout)
        iNotFound = iNotFound + 1;
        if iPrint2File > 0
          fprintf(fid,'%5i \n',iCnt);
        end
      else
        iExist = -1;
        thedir = dir(fout);
        minsize = 5e5;
        minsize = 3e5;
        minsize = 2e5;
        minsize = 1e5;
        if thedir.bytes > minsize
          iExist = 1;
        end
        if iExist > 0       
          iaaFound(iTimeStep,iLatbin) = +1;
        else
          iNotFound = iNotFound + 1;
          if iPrint2File > 0
            fprintf(fid,'%5i \n',iCnt);
          end
          if iRemove > 0
            iRemoveCnt = iRemoveCnt + 1;
            rmer = ['!/bin/rm ' fout];
            fprintf(1,'%s %6i \n',fout,thedir.bytes);
            eval(rmer)
          end
        end
      end
    end
  end
  t = datetime('now'); strt = datestr(t); %fprintf(1,'%s\n',strt);
  fprintf(1,'%s : found/did not find  %5i/%5i of %5i files : %8.6f frac done \n',strt,365*40-iNotFound,iNotFound,365*40,(365*40-iNotFound)/(365*40))
  fprintf(1,'     removed %4i files \n',iRemoveCnt)
end

if iPrint2File > 0
  fclose(fid);
end

jett = jet; jett(1,:) = 1; 
figure(1); pcolor(iaaFound); shading flat; colormap jet; colorbar; title('Done So Far');
colormap(jett);

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
if length(notdone) > 0
  fprintf(1,'still need to start %3i of 365 \n',length(notdone))
  fid = fopen('notdone.sc','w');
  str = ['sbatch --exclude=cnode[204,267] --array='];
  fprintf(fid,'%s',str);
  iX = nice_output(fid,notdone);   %% now put in continuous strips
  fprintf(1,'length(notdone) = %4i Num Continuous Strips = %4i \n',length(notdone),iX)
  str = ['%30 sergio_matlab_jobB.sbatch'];
  fprintf(fid,'%s \n',str);
  fclose(fid);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ii = 1 : 365
  fout = ['SARTA_AIRSL1c_Anomaly365_16/' num2str(ii,'%03d') '/sarta_origM_TS_jac_all_5_97_97_97.mat'];
  fout = [foutdir '/' num2str(ii,'%03d') '/sarta_origM_TS_jac_all_5_97_97_97.mat'];
  if exist(fout)
    iaFinalFound(ii) = 1;
  else
    iaFinalFound(ii) = 0;
  end
end

figure(4); plot(iaFinalFound,'o-'); title('final output file found')
