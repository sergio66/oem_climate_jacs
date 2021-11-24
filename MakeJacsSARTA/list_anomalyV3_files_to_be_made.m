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
      fout = ['SARTA_AIRSL1c_Anomaly365_16/' num2str(iTimeStep,'%03d') '/xprofile_finite_jac_anomaly_strow_latbin_' num2str(iLatbin,'%02i') '_timestep_' num2str(iTimeStep,'%03d') '.mat'];
      fout = ['SARTA_AIRSL1c_Anomaly365_16/' num2str(iTimeStep,'%03d') '/xprofile_finite_jac_anomaly_strow_latbin_' num2str(iLatbin,'%02i') '_timestemp_' num2str(iTimeStep,'%03d') '.mat'];
      if ~exist(fout)
        iNotFound = iNotFound + 1;
        if iPrint2File > 0
          fprintf(fid,'%5i \n',iCnt);
        end
      else
        iExist = -1;
        thedir = dir(fout);
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
        end
      end
    end
  end
  t = datetime('now'); strt = datestr(t); %fprintf(1,'%s\n',strt);
  fprintf(1,'%s : found/did not find  %5i/%5i of %5i files : %8.6f frac done \n',strt,365*40-iNotFound,iNotFound,365*40,(365*40-iNotFound)/(365*40))
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

notdoneA = find(sum(iaaFound') < 40);
%notdone
if length(notdoneA) > 0
  fprintf(1,'still need to start %3i of 365 V3 finitediff jacs \n',length(notdoneA))
  fid = fopen('notdoneV3.sc','w');
  for ii = 1 : length(notdoneA)
    str = ['sbatch --exclude=cnode203,cnode260,cnode267 --array=' num2str(notdoneA(ii)) ' sergio_matlab_jobB.sbatch 2'];
    fprintf(fid,'%s \n',str);
  end
  fclose(fid);
end

%{
notdoneB = find(sum(iaaFound) < 364);
if length(notdoneB) > 0
  fprintf(1,'still need to do %3i of 365 V3 finitediff jacs \n',length(notdoneB))
  fid = fopen('notdoneV3b.sc','w');
  for ii = 1 : length(notdoneB)
    str = ['sbatch --exclude=cnode203,cnode260,cnode267 --array=' num2str(notdoneB(ii)) ' sergio_matlab_jobB.sbatch 2'];
    fprintf(fid,'%s \n',str);
  end
  fclose(fid);
end
%}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
for ii = 1 : 365
  fout = ['SARTA_AIRSL1c_Anomaly365_16/' num2str(ii,'%03d') '/sarta_origM_TS_jac_all_5_97_97_97.mat'];
  if exist(fout)
    iaFinalFound(ii) = 1;
  else
    iaFinalFound(ii) = 0;
  end
end

figure(4); plot(iaFinalFound,'o-'); title('final output file found')
%}
