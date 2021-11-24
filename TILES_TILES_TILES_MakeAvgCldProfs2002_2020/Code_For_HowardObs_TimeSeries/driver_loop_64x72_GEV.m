addpath /asl/matlib/aslutil
addpath /home/sergio/MATLABCODE/TIME
addpath /home/sergio/MATLABCODE/PLOTTER
addpath /home/sergio/MATLABCODE/COLORMAP

%% see https://www.mathworks.com/help/stats/prob.generalizedextremevaluedistribution.html
%% see https://www.mathworks.com/help/stats/generalized-extreme-value-distribution.html

iPlot = -1;

iCnt = 0;
for jj = 1 : 64
  if mod(jj,10) == 0
    fprintf(1,'+')
  else
    fprintf(1,'.')
  end

  for ii = 1 : 72
    iCnt = iCnt + 1;
    fextv3 = ['/asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_CORRECT_LatLon_v3/Extreme/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/summarystats_LatBin' num2str(jj,'%02d') '_LonBin' num2str(ii,'%02d') '_timesetps_001_413_V1.mat'];
    fextv3 = ['/asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_CORRECT_LatLon_v3/Extreme_July29_2021/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/summarystats_LatBin' num2str(jj,'%02d') '_LonBin' num2str(ii,'%02d') '_timesetps_001_413_V1.mat'];

    fquant16_V2 = ['/asl/s1/sergio/MakeAvgObsStats2002_2020_startSept2002_CORRECT_LatLon/LatBin' num2str(jj,'%02d') '/LonBin' num2str(ii,'%02d') '/summarystats_LatBin' num2str(jj,'%02d') '_LonBin' num2str(ii,'%02d') '_timesetps_001_412_V1.mat'];

    %%%%%%%%%%%%%%%%%%%%%%%%%

    fname = fextv3;
    if exist(fname)
      correctlen = 0;
      correct28 = 0;
      correct32 = 0;
      exampleObject = matfile(fname);
      varlist = who(exampleObject);
      correctlen = (length(varlist) >= 32);
      if correctlen > 0
        varname = varlist{28}; % rad_blockmax_desc
        correct28 = strfind(varname,'rad_blockmax_desc');
        varname = varlist{32}; % rad_blockmax_desc
        correct32 = strfind(varname,'rad_max_desc');
      end
%      [jj ii correctlen correct28 correct32]
      if correctlen > 0 & correct28 > 0 & correct32 > 0
        varname = varlist{28}; % rad_blockmax_desc
          junk = load(fname,varname);
          boostr = ['blockmax  = junk.' varname '(:,1520);'];
          eval(boostr);
          blockmax = rad2bt(1231,blockmax);
        varname = varlist{32}; % rad_max_desc
          junk = load(fname,varname);
          boostr = ['rad_max = junk.' varname '(:,:,1520);'];
          eval(boostr);
          rad_max = rad2bt(1231,rad_max');
          rad_max = rad_max(:);
  
        junkE16 = blockmax;
        nblocks16 = 413;
        paramEsts16 = gevfit(junkE16);
        paramE16(jj,ii,:) = paramEsts16;
        if iPlot > 0    
          dgrid = 0.25;
          figure(2); clf; histogram(junkE16,floor(min(junkE16)):dgrid:ceil(max(junkE16)),'FaceColor',[.8 .8 1]);
          junkE16grid = linspace(floor(min(junkE16)),ceil(max(junkE16)),100);
          line(junkE16grid,nblocks16*dgrid*gevpdf(junkE16grid,paramEsts16(1),paramEsts16(2),paramEsts16(3))); %% nblock*dgrid so things are properly normalized
            title('block maxima')
        end
        
        junkE1 = rad_max;
        good = find(isfinite(junkE1));
        mu = mean(junkE1(good));
        sig = std(junkE1(good));
        goodx = find(junkE1(good) >= mu - 0.5*sig);
        good = good(goodx); 
        paramEsts1 = gevfit(junkE1(good));
        paramE1(jj,ii,:) = paramEsts1;
        if iPlot > 0    
          nblocks1 = length(good);
          dgrid = 0.25;
          figure(3); clf; histogram(junkE1(good),floor(min(junkE1(good))):dgrid:ceil(max(junkE1(good))),'FaceColor',[.8 .8 1]);
          junkE1grid = linspace(floor(min(junkE1(good))),ceil(max(junkE1(good))),100);
          line(junkE1grid,nblocks1*dgrid*gevpdf(junkE1grid,paramEsts1(1),paramEsts1(2),paramEsts1(3))); %% nblock*dgrid so things are properly normalized
            title('daily maxima')
        end      
      else
        paramE16(jj,ii,:) = NaN;   %% individual 16 day stuff
        paramE1(jj,ii,:)  = NaN;   %% block max over 16 days
      end
    else
      paramE16(jj,ii,:) = NaN;   %% individual 16 day stuff
      paramE1(jj,ii,:)  = NaN;   %% block max over 16 days
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%

    fname = fquant16_V2;
    if exist(fname)
      correctlenQ = 0;
      correct30 = 0;
      exampleObject = matfile(fname);
      varlist = who(exampleObject);
      correctlenQ = (length(varlist) >= 30);
      if correctlenQ > 0
        varname = varlist{30}; % rad_blockmax_desc
        correct30 = strfind(varname,'quantile1231_desc');
      end
%      [jj ii correctlen correct28 correct32 correctlenQ correct30]
      if correctlenQ > 0 & correct30 > 0
        varname = varlist{30}; % quantile1231_desc
          junk = load(fname,varname);
          boostr = ['q16  = junk.' varname '(:,16);'];
          eval(boostr);
    
        junkQ = q16;
        nblocks16 = 412;
        paramEsts16 = gevfit(junkQ);   
        paramQ16(jj,ii,:) = paramEsts16;
        if iPlot > 0    
          dgrid = 0.25;
          figure(1); clf; histogram(junkQ,floor(min(junkQ)):dgrid:ceil(max(junkQ)),'FaceColor',[.8 .8 1]);
          junkQgrid = linspace(floor(min(junkQ)),ceil(max(junkQ)),100);
          line(junkQgrid,nblocks16*dgrid*gevpdf(junkQgrid,paramEsts16(1),paramEsts16(2),paramEsts16(3))); %% nblock*dgrid so things are properly normalized
            title('Q16 averaged')
        end
      else
        paramQ16(jj,ii,:) = NaN;  %% block average over 16 days
      end
    else
      paramQ16(jj,ii,:) = NaN;  %% block average over 16 days
    end
          
  end

  figure(1); imagesc(squeeze(paramE1(:,:,1))); colorbar; colormap(jet); title('paramE1(1)');
  figure(2); imagesc(squeeze(paramE1(:,:,2))); colorbar; colormap(jet); title('paramE1(2)');
  figure(3); imagesc(squeeze(paramE1(:,:,3))); colorbar; colormap(jet); title('paramE1(3)');

  figure(4); imagesc(squeeze(paramE16(:,:,1))); colorbar; colormap(jet); title('paramE16(1)');
  figure(5); imagesc(squeeze(paramE16(:,:,2))); colorbar; colormap(jet); title('paramE16(2)');
  figure(6); imagesc(squeeze(paramE16(:,:,3))); colorbar; colormap(jet); title('paramE16(3)');

  pause(0.1)
end
fprintf(1,'\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
comment = 'see driver_loop_64x72_GEV.m';
save GEVresults.mat paramE1 paramE16 paramQ16 comment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1); simplemap(squeeze(paramE1(:,:,1))); colorbar; colormap(jet); title('Daily paramE1(1)');
figure(2); simplemap(squeeze(paramE1(:,:,2))); colorbar; colormap(jet); title('Daily paramE1(2)');
figure(3); simplemap(squeeze(paramE1(:,:,3))); colorbar; colormap(jet); title('Daily paramE1(3)');

figure(4); simplemap(squeeze(paramE16(:,:,1))); colorbar; colormap(jet); title('16day block paramE16(1)');  
figure(5); simplemap(squeeze(paramE16(:,:,2))); colorbar; colormap(jet); title('16day block paramE16(2)');
figure(6); simplemap(squeeze(paramE16(:,:,3))); colorbar; colormap(jet); title('16day block paramE16(3)');

figure(7); simplemap(squeeze(paramQ16(:,:,1))); colorbar; colormap(jet); title('16day block paramQ16(1)');
figure(8); simplemap(squeeze(paramQ16(:,:,2))); colorbar; colormap(jet); title('16day block paramQ16(2)');
figure(9); simplemap(squeeze(paramQ16(:,:,3))); colorbar; colormap(jet); title('16day block paramQ16(3)');

figure(10); simplemap(squeeze(paramE16(:,:,3))-squeeze(paramQ16(:,:,3))); colorbar; colormap(jet); title('16day block paramE16(3)-paramQ16(3)');
  colormap(usa2); caxis([-5 +5])
