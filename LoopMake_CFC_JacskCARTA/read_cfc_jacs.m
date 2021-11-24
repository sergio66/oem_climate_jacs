for ii = 1 : 40
  aname = ['JUNK_CLD/jac_results_' num2str(ii) '.mat'];
  load(aname);
  allCLDstemp(:,ii) = stemp;
  allCLDCFC(:,ii) = tracegas;
end

figure(1); pcolor(fKc(1:2378),1:40,allCLDstemp(1:2378,:)'); title('stemp'); 
figure(2); pcolor(fKc(1:2378),1:40,allCLDCFC(1:2378,:)');   title('CFC')

for ii = 1 : 2
  figure(ii); shading flat; colormap jet; colorbar;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for ii = 1 : 40
  aname = ['JUNK_CLR/jac_results_' num2str(ii) '.mat'];
  load(aname);
  allCLRstemp(:,ii) = stemp;
  allCLRCFC(:,ii) = tracegas;
end

figure(1); pcolor(fKc(1:2378),1:40,allCLRstemp(1:2378,:)'); title('stemp'); 
figure(2); pcolor(fKc(1:2378),1:40,allCLRCFC(1:2378,:)');   title('CFC')

for ii = 1 : 2
  figure(ii); shading flat; colormap jet; colorbar;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1); plot(fKc(1:2378),allCLDstemp(1:2378,:)-allCLRstemp(1:2378,:)); title('diff CLD-CLR stemp')
figure(2); plot(fKc(1:2378),allCLDCFC(1:2378,:)-allCLRCFC(1:2378,:));     title('diff CLD-CLR CFC')
